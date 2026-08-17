# Verifies the prescribed-biaxial direct-integration adapter.

Arguments <- commandArgs(trailingOnly = FALSE)
FileArgument <- grep("^--file=", Arguments, value = TRUE)
if (length(FileArgument) != 1L) {
  stop(
    "Run with Rscript scripts/R/testCoverInteractionScenario.R.",
    call. = FALSE
  )
}
ScriptPath <- normalizePath(sub("^--file=", "", FileArgument))
projectRoot <- normalizePath(file.path(dirname(ScriptPath), "..", ".."))
source(
  file.path(projectRoot, "scripts", "setup", "calculationFunctions.R"),
  local = TRUE
)

runCoverInteractionScenarioTests <- function() {
  Stress <- calculateHomogeneousCoverStress(
    coverCrownM = 2,
    crownToAxisM = 1.315,
    effectiveUnitWeightKnPerM3 = 20,
    effectiveSurchargeKPa = 5,
    referencePositionID = "axis"
  )
  stopifnot(
    abs(Stress$depthM - 3.315) < 1e-12,
    abs(Stress$effectiveVerticalStressKPa - 71.3) < 1e-12
  )

  Lining <- calculateConcreteRingSection(
    analysisThicknessM = 0.15,
    analysisModulusKPa = 25e6,
    centroidalRadiusM = 1.315,
    stiffnessBasisID = "gross-uncracked-short-term"
  )
  Theta <- seq(0, 2 * pi, length.out = 721L)[-721L]
  Scenario <- calculatePrescribedBiaxialInteraction(
    theta = Theta,
    effectiveVerticalStressKPa = 66.3,
    effectiveHorizontalStressKPa = 33.15,
    waterPressureDifferenceKPa = 0,
    stressReferenceID = "axis",
    radiusM = 1.315,
    sectionRatio = Lining$rigidity$sectionRatio,
    tangentialMultiplier = 1,
    actionRepresentationID = "fullTraction",
    combinationID = "synthetic-cover",
    stageID = "autonomous-shotcrete",
    forceEffectStatus = "unfactored-reference-state",
    integrationSteps = 4096L,
    balanceTolerance = 1e-9
  )
  Values <- Scenario$values
  Extrema <- summarizePrescribedBiaxialInteraction(Scenario)
  stopifnot(
    nrow(Values) == length(Theta),
    all(Values$interactionModelID ==
      "prescribed-biaxial-direct-integration"),
    all(Values$interfaceID == "fullTraction"),
    all(is.finite(Values$normalForceKnPerM)),
    all(is.finite(Values$bendingMomentKnMPerM)),
    all(is.finite(Values$shearForceKnPerM)),
    nrow(Extrema) == 9L,
    max(Scenario$closedFormDifference) < 1e-7
  )
  invisible(TRUE)
}

runCoverInteractionScenarioTests()
cat("PASS: prescribed-biaxial direct-integration scenario.\n")
