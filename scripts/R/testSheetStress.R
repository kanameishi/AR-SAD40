# Verifies the conditional linear recovery of normal stress in the sheet.

Arguments <- commandArgs(trailingOnly = FALSE)
FileArgument <- grep("^--file=", Arguments, value = TRUE)
if (length(FileArgument) != 1L) {
  stop("Run with Rscript scripts/R/testSheetStress.R.", call. = FALSE)
}

ScriptPath <- normalizePath(sub("^--file=", "", FileArgument))
ProjectRoot <- normalizePath(file.path(dirname(ScriptPath), "..", ".."))
source(file.path(ProjectRoot, "scripts", "R", "sheetStress.R"))

assertClose <- function(observed, expected, tolerance = 1e-12) {
  stopifnot(
    length(observed) == length(expected),
    all(is.finite(observed)),
    max(abs(observed - expected)) <= tolerance
  )
}

Resultants <- data.frame(
  sectionID = "net-section-01",
  combinationID = "strength-01",
  stageID = "existing",
  theta = 0,
  thetaDeg = 0,
  normalForceKnPerM = -60,
  bendingMomentKnMPerM = 0.02,
  shearForceKnPerM = 999,
  forceEffectStatus = "factored-strength",
  longitudinalBasis = "per-projected-metre",
  stringsAsFactors = FALSE
)
NetSection <- list(
  sectionID = "net-section-01",
  areaMm2PerMm = 4,
  inertiaMm4PerMm = 300,
  outerFiberCoordinateMm = -10,
  innerFiberCoordinateMm = 15,
  coordinatePositiveDirection = "inward",
  momentSignConvention = "positive-tension-inner"
)
RecoveryBasis <- list(
  modelID = "linear-homogenized",
  criterionID = "synthetic-straight-section-control",
  applicabilityStatus = "satisfied"
)

Stress <- calculateSheetNormalStress(Resultants, NetSection, RecoveryBasis)
stopifnot(
  identical(Stress$fiberID, c("outer", "inner")),
  identical(Stress$sectionID, rep("net-section-01", 2L)),
  identical(Stress$combinationID, rep("strength-01", 2L)),
  identical(Stress$stageID, rep("existing", 2L)),
  identical(Stress$shearForceKnPerM, rep(999, 2L)),
  identical(Stress$shearStressStatus, rep("not-evaluated", 2L)),
  identical(Stress$applicabilityStatus, rep("satisfied", 2L))
)
assertClose(Stress$membraneStressMPa, c(-15, -15))
assertClose(Stress$bendingStressMPa, c(-2 / 3, 1))
assertClose(Stress$normalStressMPa, c(-47 / 3, -14))

Axial <- Resultants
Axial$bendingMomentKnMPerM <- 0
StressAxial <- calculateSheetNormalStress(Axial, NetSection, RecoveryBasis)
assertClose(StressAxial$normalStressMPa, c(-15, -15))

Bending <- Resultants
Bending$normalForceKnPerM <- 0
StressBending <- calculateSheetNormalStress(Bending, NetSection, RecoveryBasis)
assertClose(StressBending$normalStressMPa, c(-2 / 3, 1))

Bending$bendingMomentKnMPerM <- -Bending$bendingMomentKnMPerM
StressReversed <- calculateSheetNormalStress(Bending, NetSection, RecoveryBasis)
assertClose(StressReversed$normalStressMPa, c(2 / 3, -1))

ScaleFactor <- 0.75
ScaledSection <- NetSection
ScaledSection$areaMm2PerMm <- ScaleFactor * NetSection$areaMm2PerMm
ScaledSection$inertiaMm4PerMm <- ScaleFactor * NetSection$inertiaMm4PerMm
StressScaled <- calculateSheetNormalStress(
  Resultants,
  ScaledSection,
  RecoveryBasis
)
assertClose(StressScaled$normalStressMPa, Stress$normalStressMPa / ScaleFactor)

ChangedShear <- Resultants
ChangedShear$shearForceKnPerM <- -12345
StressChangedShear <- calculateSheetNormalStress(
  ChangedShear,
  NetSection,
  RecoveryBasis
)
assertClose(StressChangedShear$normalStressMPa, Stress$normalStressMPa)
stopifnot(all(StressChangedShear$shearStressStatus == "not-evaluated"))

for (Status in c("unknown", "not-satisfied")) {
  Basis <- RecoveryBasis
  Basis$applicabilityStatus <- Status
  StressUnavailable <- calculateSheetNormalStress(
    Resultants,
    NetSection,
    Basis
  )
  stopifnot(
    all(is.na(StressUnavailable$membraneStressMPa)),
    all(is.na(StressUnavailable$bendingStressMPa)),
    all(is.na(StressUnavailable$normalStressMPa)),
    identical(StressUnavailable$applicabilityStatus, rep(Status, 2L))
  )
}

AdoptedBasis <- RecoveryBasis
AdoptedBasis$criterionID <- "reference-section-model-adoption"
AdoptedBasis$applicabilityStatus <- "adopted"
StressAdopted <- calculateSheetNormalStress(
  Resultants,
  NetSection,
  AdoptedBasis
)
assertClose(StressAdopted$normalStressMPa, Stress$normalStressMPa)
stopifnot(all(StressAdopted$applicabilityStatus == "adopted"))

expectError <- function(expression, pattern) {
  Message <- tryCatch(
    {
      force(expression)
      NA_character_
    },
    error = function(e) conditionMessage(e)
  )
  stopifnot(!is.na(Message), grepl(pattern, Message, fixed = TRUE))
}

InvalidSection <- NetSection
InvalidSection$areaMm2PerMm <- 0
expectError(
  calculateSheetNormalStress(Resultants, InvalidSection, RecoveryBasis),
  "area and inertia must be positive"
)
InvalidSection <- NetSection
InvalidSection$outerFiberCoordinateMm <- 1
expectError(
  calculateSheetNormalStress(Resultants, InvalidSection, RecoveryBasis),
  "outer fibre must be negative"
)
InvalidSection <- NetSection
InvalidSection$sectionID <- "other-section"
expectError(
  calculateSheetNormalStress(Resultants, InvalidSection, RecoveryBasis),
  "same sectionID"
)
InvalidResultants <- Resultants
InvalidResultants$longitudinalBasis <- "per-actual-width"
expectError(
  calculateSheetNormalStress(InvalidResultants, NetSection, RecoveryBasis),
  "must be per-projected-metre"
)
InvalidBasis <- RecoveryBasis
InvalidBasis$modelID <- "curved-beam"
expectError(
  calculateSheetNormalStress(Resultants, NetSection, InvalidBasis),
  "Unsupported sheet-stress recovery modelID"
)
InvalidBasis <- RecoveryBasis
InvalidBasis$applicabilityStatus <- "assumed"
expectError(
  calculateSheetNormalStress(Resultants, NetSection, InvalidBasis),
  "Unsupported recovery applicabilityStatus"
)

cat("PASS: conditional sheet normal-stress recovery is consistent.\n")
