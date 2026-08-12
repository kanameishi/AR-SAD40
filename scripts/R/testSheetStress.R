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
  theta = 0,
  thetaDeg = 0,
  normalForce = -60,
  bendingMoment = 0.02,
  shearForce = 999,
  stringsAsFactors = FALSE
)
NetSection <- list(
  areaMm2PerMm = 4,
  inertiaMm4PerMm = 300,
  positiveFiberCoordinateMm = 12.5,
  negativeFiberCoordinateMm = -12.5
)
RecoveryBasis <- list(
  modelID = "linear-homogenized",
  criterionID = "straight-section-control",
  applicabilityStatus = "satisfied"
)

Stress <- calculateSheetNormalStress(
  resultants = Resultants,
  netSection = NetSection,
  recoveryBasis = RecoveryBasis
)
stopifnot(
  identical(Stress$fiberID, c("outer", "inner")),
  identical(Stress$applicabilityStatus, rep("satisfied", 2L))
)
assertClose(Stress$membraneStressMPa, c(-15, -15))
assertClose(Stress$bendingStressMPa, c(-5 / 6, 5 / 6))
assertClose(Stress$normalStressMPa, c(-95 / 6, -85 / 6))

Axial <- Resultants
Axial$bendingMoment <- 0
Stress.axial <- calculateSheetNormalStress(Axial, NetSection, RecoveryBasis)
assertClose(Stress.axial$normalStressMPa, c(-15, -15))

Bending <- Resultants
Bending$normalForce <- 0
Stress.bending <- calculateSheetNormalStress(Bending, NetSection, RecoveryBasis)
assertClose(Stress.bending$normalStressMPa, c(-5 / 6, 5 / 6))

Bending$bendingMoment <- -Bending$bendingMoment
Stress.reversed <- calculateSheetNormalStress(Bending, NetSection, RecoveryBasis)
assertClose(
  Stress.reversed$normalStressMPa,
  rev(Stress.bending$normalStressMPa)
)

Eta <- 0.75
NetSection.scaled <- NetSection
NetSection.scaled$areaMm2PerMm <- Eta * NetSection$areaMm2PerMm
NetSection.scaled$inertiaMm4PerMm <- Eta * NetSection$inertiaMm4PerMm
Stress.scaled <- calculateSheetNormalStress(
  resultants = Resultants,
  netSection = NetSection.scaled,
  recoveryBasis = RecoveryBasis
)
assertClose(Stress.scaled$normalStressMPa, Stress$normalStressMPa / Eta)

Resultants.changedQ <- Resultants
Resultants.changedQ$shearForce <- -12345
Stress.changedQ <- calculateSheetNormalStress(
  resultants = Resultants.changedQ,
  netSection = NetSection,
  recoveryBasis = RecoveryBasis
)
stopifnot(identical(Stress.changedQ, Stress))

for (s in c("unknown", "not-satisfied")) {
  Basis <- RecoveryBasis
  Basis$applicabilityStatus <- s
  Stress.unavailable <- calculateSheetNormalStress(
    resultants = Resultants,
    netSection = NetSection,
    recoveryBasis = Basis
  )
  stopifnot(
    all(is.na(Stress.unavailable$membraneStressMPa)),
    all(is.na(Stress.unavailable$bendingStressMPa)),
    all(is.na(Stress.unavailable$normalStressMPa)),
    identical(Stress.unavailable$applicabilityStatus, rep(s, 2L))
  )
}

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
InvalidSection$negativeFiberCoordinateMm <- 1
expectError(
  calculateSheetNormalStress(Resultants, InvalidSection, RecoveryBasis),
  "must straddle the centroid"
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
