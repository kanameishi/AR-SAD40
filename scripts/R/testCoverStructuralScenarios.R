# Exercises the cover-to-demand chain for steel and autonomous shotcrete.
# All values in this file are internal regression fixtures, not project data.

Arguments <- commandArgs(trailingOnly = FALSE)
FileArgument <- grep("^--file=", Arguments, value = TRUE)
if (length(FileArgument) != 1L) {
  stop("Run with Rscript scripts/R/testCoverStructuralScenarios.R.", call. = FALSE)
}
ScriptPath <- normalizePath(sub("^--file=", "", FileArgument))
projectRoot <- normalizePath(file.path(dirname(ScriptPath), "..", ".."))
source(
  file.path(projectRoot, "scripts", "setup", "calculationFunctions.R"),
  local = TRUE
)

runCoverStructuralScenarioTests <- function() {
  Reference <- read.csv(
    file.path(
      projectRoot,
      "data", "reference", "cspi.corrugation.section.properties.csv"
    ),
    stringsAsFactors = FALSE
  )
  ReferenceSection <- selectCorrugatedSection(
    reference = Reference,
    profileID = "cspi-76x25-csp-sheet",
    referenceRowID = "cspi-76x25-2.8"
  )
  Theta <- seq(0, 2 * pi, length.out = 361L)[-361L]
  SteelRows <- list()
  Counter <- 1L
  for (Cover in c(2, 4)) {
    for (Thickness in c(2.64, 1.98)) {
      Steel <- calculateCorrugatedRingSection(
        referenceSection = ReferenceSection,
        remainingBaseThicknessMm = Thickness,
        youngModulusKPa = 200e6,
        radiusM = 1.315
      )
      for (Interface in c("fullSlip", "noSlip")) {
        Scenario <- calculateCoverInteractionScenario(
          theta = Theta,
          coverCrownM = Cover,
          effectiveUnitWeightKnPerM3 = 20,
          effectiveSurchargeKPa = 0,
          referencePositionID = "axis",
          crownToAxisM = 1.315,
          k0 = 0.5,
          liningRadiusM = 1.315,
          groundModulusKPa = 30e3,
          groundPoisson = 0.3,
          liningSection = Steel,
          liningPoisson = 0.3,
          interface = Interface,
          combinationID = "synthetic-cover",
          stageID = "steel",
          forceEffectStatus = "unfactored-reference-state"
        )
        Screen <- screenAisiFlexuralDemand(
          bendingMomentKnMPerM =
            Scenario$interaction$values$bendingMomentKnMPerM,
          areaMm2PerMm = Steel$section$areaMm2PerMm,
          inertiaMm4PerMm = Steel$section$inertiaMm4PerMm,
          sectionModulusMm3PerMm = Steel$section$sectionModulusMm3PerMm,
          yieldStrengthMPa = 250
        )
        SteelRows[[Counter]] <- data.frame(
          coverCrownM = Cover,
          remainingBaseThicknessMm = Thickness,
          interfaceID = Interface,
          normalAbsoluteMaxKnPerM = max(abs(
            Scenario$interaction$values$normalForceKnPerM
          )),
          momentAbsoluteMaxKnMPerM = max(abs(
            Scenario$interaction$values$bendingMomentKnMPerM
          )),
          flexuralBoundRatio = max(Screen$demandBoundRatio),
          stringsAsFactors = FALSE
        )
        Counter <- Counter + 1L
      }
    }
  }
  SteelResults <- do.call(rbind, SteelRows)
  stopifnot(
    nrow(SteelResults) == 8L,
    all(is.finite(as.matrix(SteelResults[c(
      "normalAbsoluteMaxKnPerM", "momentAbsoluteMaxKnMPerM",
      "flexuralBoundRatio"
    )]))),
    min(SteelResults$flexuralBoundRatio) > 0
  )
  Base <- SteelResults[
    SteelResults$remainingBaseThicknessMm == 2.64 &
      SteelResults$interfaceID == "fullSlip",
  ]
  stopifnot(
    Base$normalAbsoluteMaxKnPerM[Base$coverCrownM == 4] >
      Base$normalAbsoluteMaxKnPerM[Base$coverCrownM == 2]
  )

  Shotcrete <- calculateConcreteRingSection(
    analysisThicknessM = 0.15,
    analysisModulusKPa = 25e6,
    centroidalRadiusM = 1.315,
    stiffnessBasisID = "gross-uncracked-short-term"
  )
  ShotcreteScenario <- calculateCoverInteractionScenario(
    theta = Theta,
    coverCrownM = 2,
    effectiveUnitWeightKnPerM3 = 20,
    effectiveSurchargeKPa = 0,
    referencePositionID = "axis",
    crownToAxisM = 1.315,
    k0 = 0.5,
    liningRadiusM = 1.315,
    groundModulusKPa = 30e3,
    groundPoisson = 0.3,
    liningSection = Shotcrete,
    liningPoisson = 0.2,
    interface = "fullSlip",
    combinationID = "synthetic-cover",
    stageID = "autonomous-shotcrete",
    forceEffectStatus = "unfactored-reference-state"
  )
  Reinforcement <- data.frame(
    layerID = c("interior", "exterior"),
    areaMm2 = c(135, 135),
    coordinateMm = c(-35, 35),
    yieldStrengthMPa = c(420, 420),
    modulusMPa = c(200000, 200000),
    stringsAsFactors = FALSE
  )
  Domains <- buildAciE702421ReinforcedSectionDomains(
    thicknessMm = 150,
    stripWidthMm = 1000,
    compressiveStrengthMPa = 30,
    reinforcement = Reinforcement,
    basePointCount = 601L,
    refinedPointCount = 1201L
  )
  Assessment <- evaluateAciE702421SectionDemand(
    normalForceKnPerM =
      ShotcreteScenario$interaction$values$normalForceKnPerM,
    bendingMomentKnMPerM =
      ShotcreteScenario$interaction$values$bendingMomentKnMPerM,
    stripWidthM = 1,
    sectionDomains = Domains,
    forceEffectStatus = "unfactored-reference-state",
    convergenceTolerance = 2e-3
  )
  stopifnot(
    all(Assessment$convergenceStatus == "satisfied"),
    all(is.finite(Assessment$radialUtilization)),
    max(Assessment$radialUtilization) > 0,
    all(
      Assessment$sectionalAssessmentStatus ==
        "not-evaluated-code-basis"
    )
  )
  invisible(TRUE)
}

runCoverStructuralScenarioTests()
cat("PASS: cover, thickness, AISI-screen and shotcrete scenario chain.\n")
