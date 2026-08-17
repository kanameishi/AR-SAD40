# Verifies the reproduced AASHTO Section 12.7 calculation boundary.

Arguments <- commandArgs(trailingOnly = FALSE)
FileArgument <- grep("^--file=", Arguments, value = TRUE)
if (length(FileArgument) != 1L) {
  stop(
    "Run with Rscript scripts/R/testAashtoCorrugatedConduit.R.",
    call. = FALSE
  )
}
ScriptPath <- normalizePath(sub("^--file=", "", FileArgument))
projectRoot <- normalizePath(file.path(dirname(ScriptPath), "..", ".."))
source(
  file.path(projectRoot, "scripts", "setup", "calculationFunctions.R"),
  local = TRUE
)

Demand <- list(
  designThrustKnPerM = 1.05 * 1.95 * 20 * 2 * 2.63 / 2,
  combinationID = "aashto-lrfd-control",
  stageID = "completed-fill",
  forceEffectStatus = "lrfd-factored",
  demandBasisID = "reproduced-prior-edition",
  sourceKey = "USACE2020",
  sourceLocator = "Eq. 4-20, printed p. 87/PDF p. 101"
)
Section <- list(
  structuralProductID = "cspi-76x25-2.8-t2.64",
  productTypeID = "ordinary-corrugated-metal-conduit",
  shapeID = "round",
  spanM = 2.63,
  corrugationProfileID = "cspi-76x25-csp-sheet",
  referenceRowID = "cspi-76x25-2.8",
  specifiedThicknessMm = 2.8,
  designBaseThicknessMm = 2.64,
  remainingBaseThicknessMm = 2.64,
  areaMm2PerMm = 3.281,
  inertiaMm4PerMm = 249.73,
  coverCrownM = 2,
  sourceKey = "CSPI2007",
  sourceLocator = "Table 2.4, row 2.8"
)
Material <- list(
  materialID = "adopted-steel-fy250-fu400",
  yieldStrengthMPa = 250,
  tensileStrengthMPa = 400,
  elasticModulusMPa = 200000,
  sourceKey = "adopted-scenario",
  sourceLocator = "synthetic calculation control"
)
Specification <- list(
  standardID = "AASHTO-LRFD",
  editionID = "AASHTO-LRFD-9e-reproduced",
  errataID = "not-verified",
  branchID = "12.7",
  productTypeID = "ordinary-corrugated-metal-conduit",
  sourceBasisID = "USACE-2020-AASHTO-8e;ALDOT-2023-AASHTO-9e",
  specificationStatus = "reference-basis-not-current",
  editionStatus = "not-verified",
  errataStatus = "not-verified",
  productApplicabilityStatus = "verified",
  wallResistanceFactor = 1,
  wallSourceKey = "USACE2020;AndersonEtAl2023",
  wallSourceLocator = "USACE Eq. 4-22; Anderson et al. p. 164",
  seamResistanceFactor = 0.67,
  seamFactorSourceKey = "USACE2020",
  seamFactorSourceLocator = "Section 4.12.3.3",
  soilStiffnessFactor = 0.22,
  soilSourceKey = "AndersonEtAl2023",
  soilSourceLocator = "AASHTO LRFD 9e 12.7.2.4 reproduction",
  flexibilityLimitMmPerN = 0.1884349,
  flexibilitySourceKey = "USACE2020",
  flexibilitySourceLocator = "Eq. 4-23 and Table 4-6",
  minimumCoverSourceKey = "AndersonEtAl2023",
  minimumCoverSourceLocator = "AASHTO LRFD 9e minimum-cover table"
)

Result <- evaluateAashto127CorrugatedConduit(
  demand = Demand,
  section = Section,
  material = Material,
  specification = Specification
)
ExpectedRadius <- sqrt(249.73 / 3.281)
ExpectedSlenderness <- 0.22 * 2630 / ExpectedRadius
ExpectedTransition <- ExpectedRadius / 0.22 * sqrt(24 * 200000 / 400) / 1000
ExpectedBuckling <- 400 - 400^2 / (48 * 200000) * ExpectedSlenderness^2
ExpectedFlexibility <- 2630^2 / (200000 * 249.73)
stopifnot(
  abs(Result$calculation$gyrationRadiusMm - ExpectedRadius) < 1e-12,
  identical(Result$calculation$bucklingBranchID, "inelastic"),
  abs(Result$calculation$transitionSpanM - ExpectedTransition) < 1e-12,
  abs(Result$calculation$criticalBucklingStressMPa - ExpectedBuckling) < 1e-12,
  abs(Result$calculation$flexibilityFactorMmPerN - ExpectedFlexibility) < 1e-12,
  abs(Result$calculation$minimumCoverM - max(2.63 / 8, 0.3048)) < 1e-12,
  identical(Result$summary$wallStatus, "satisfied"),
  identical(Result$summary$seamStatus, "not-evaluated"),
  identical(Result$summary$calculationStatus, "incomplete"),
  identical(Result$summary$systemStatus, "not-evaluated-inputs")
)

Seam <- list(
  seamID = "synthetic-seam-control",
  nominalResistanceKnPerM = 769,
  fastenerDiameterMm = 12.7,
  fastenerDiameterLossRatio = 0,
  sourceKey = "synthetic-control",
  sourceLocator = "synthetic seam resistance"
)
SpecificationVerified <- Specification
SpecificationVerified$editionID <- "synthetic-current-edition"
SpecificationVerified$errataID <- "synthetic-current-errata"
SpecificationVerified$specificationStatus <- "verified-current-edition"
SpecificationVerified$editionStatus <- "verified"
SpecificationVerified$errataStatus <- "verified"
Complete <- evaluateAashto127CorrugatedConduit(
  demand = Demand,
  section = Section,
  material = Material,
  specification = SpecificationVerified,
  seam = Seam
)
stopifnot(
  all(Complete$checks$checkStatus == "satisfied"),
  identical(Complete$summary$calculationStatus, "satisfied"),
  identical(Complete$summary$systemStatus, "satisfied"),
  abs(Complete$calculation$remainingFastenerDiameterMm - 12.7) < 1e-12,
  abs(Complete$calculation$fastenerAreaRatio - 1) < 1e-12,
  abs(
    Complete$calculation$criticalFastenerDiameterLossRatio -
      (1 - sqrt(Demand$designThrustKnPerM / (0.67 * 769)))
  ) < 1e-12
)

CorrodedSeam <- Seam
CorrodedSeam$fastenerDiameterLossRatio <- 0.4
Corroded <- evaluateAashto127CorrugatedConduit(
  demand = Demand,
  section = Section,
  material = Material,
  specification = SpecificationVerified,
  seam = CorrodedSeam
)
CorrodedCheck <- Corroded$checks[
  Corroded$checks$checkID == "seam",
  ,
  drop = FALSE
]
stopifnot(
  abs(Corroded$calculation$remainingFastenerDiameterMm - 7.62) < 1e-12,
  abs(Corroded$calculation$fastenerAreaRatio - 0.36) < 1e-12,
  abs(
    Corroded$calculation$corrodedSeamNominalResistanceKnPerM - 769 * 0.36
  ) < 1e-12,
  abs(CorrodedCheck$limitValue - 0.67 * 769 * 0.36) < 1e-12,
  abs(
    CorrodedCheck$utilization -
      Demand$designThrustKnPerM / (0.67 * 769 * 0.36)
  ) < 1e-12
)

InvalidSeam <- Seam
InvalidSeam$fastenerDiameterLossRatio <- 1
Error <- try(
  evaluateAashto127CorrugatedConduit(
    demand = Demand,
    section = Section,
    material = Material,
    specification = Specification,
    seam = InvalidSeam
  ),
  silent = TRUE
)
stopifnot(inherits(Error, "try-error"))

SectionElastic <- Section
SectionElastic$spanM <- 6
SectionElastic$coverCrownM <- 2
Elastic <- evaluateAashto127CorrugatedConduit(
  demand = Demand,
  section = SectionElastic,
  material = Material,
  specification = Specification,
  seam = Seam
)
stopifnot(identical(Elastic$calculation$bucklingBranchID, "elastic"))

SectionTransition <- Section
SectionTransition$spanM <- ExpectedTransition
Transition <- evaluateAashto127CorrugatedConduit(
  demand = Demand,
  section = SectionTransition,
  material = Material,
  specification = Specification,
  seam = Seam
)
stopifnot(
  identical(Transition$calculation$bucklingBranchID, "inelastic"),
  abs(Transition$calculation$criticalBucklingStressMPa - 200) < 1e-10
)

DemandInvalid <- Demand
DemandInvalid$forceEffectStatus <- "unfactored-reference-state"
Error <- try(
  evaluateAashto127CorrugatedConduit(
    demand = DemandInvalid,
    section = Section,
    material = Material,
    specification = Specification
  ),
  silent = TRUE
)
stopifnot(inherits(Error, "try-error"))

SpecificationInvalid <- Specification
SpecificationInvalid$specificationStatus <- "verified-current-edition"
Error <- try(
  evaluateAashto127CorrugatedConduit(
    demand = Demand,
    section = Section,
    material = Material,
    specification = SpecificationInvalid,
    seam = Seam
  ),
  silent = TRUE
)
stopifnot(inherits(Error, "try-error"))

cat("PASS: AASHTO Section 12.7 reproduced calculation boundary.\n")
