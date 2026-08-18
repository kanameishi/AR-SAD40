# Verifies the minimal cover-scenario composition for both lining options.
# All values are internal regression fixtures, not project data.

Arguments <- commandArgs(trailingOnly = FALSE)
FileArgument <- grep("^--file=", Arguments, value = TRUE)
if (length(FileArgument) != 1L) {
  stop("Run with Rscript scripts/R/testCoverScenarios.R.", call. = FALSE)
}
ScriptPath <- normalizePath(sub("^--file=", "", FileArgument))
projectRoot <- normalizePath(file.path(dirname(ScriptPath), "..", ".."))
source(
  file.path(projectRoot, "scripts", "setup", "calculationFunctions.R"),
  local = TRUE
)

runCoverScenarioTests <- function() {
  Reference <- utils::read.csv(
    file.path(
      projectRoot,
      "data", "reference", "cspi.corrugation.section.properties.csv"
    ),
    stringsAsFactors = FALSE
  )
  SectionReference <- selectCorrugatedSection(
    reference = Reference,
    profileID = "cspi-76x25-csp-sheet",
    referenceRowID = "cspi-76x25-2.8"
  )
  Theta <- seq(0, 2 * pi, length.out = 73L)[-73L]
  Cover <- function(value) {
    list(
      coverCrownM = value,
      crownToAxisM = 1.315,
      effectiveUnitWeightKnPerM3 = 20,
      effectiveSurchargeKPa = 0,
      referencePositionID = "axis"
    )
  }
  Ground <- list(
    modulusKPa = 30e3,
    poisson = 0.30,
    k0 = list(modelID = "adopted-constant", k0 = 0.50)
  )
  Action <- list(
    combinationID = "synthetic-service-state",
    stageID = "completed-fill",
    forceEffectStatus = "unfactored-reference-state",
    loadCombinationBasisID = "synthetic-unfactored-basis",
    waterPressureDifferenceKPa = 0
  )
  Numerics <- list(
    integrationSteps = 4096L,
    balanceTolerance = 1e-9,
    closedFormTolerance = 1e-7
  )
  Steel <- function(sectionID, thicknessMm) {
    list(
      liningTypeID = "corrugated-steel",
      sectionID = sectionID,
      centroidalRadiusM = 1.315,
      poisson = 0.30,
      referenceProfileID = "cspi-76x25-csp-sheet",
      referenceRowID = "cspi-76x25-2.8",
      remainingBaseThicknessMm = thicknessMm,
      youngModulusKPa = 200e6,
      yieldStrengthMPa = 250,
      aisi = NULL
    )
  }
  Reinforcement <- data.frame(
    layerID = c("interior", "exterior"),
    areaMm2 = c(135, 135),
    coordinateMm = c(-35, 35),
    yieldStrengthMPa = c(420, 420),
    modulusMPa = c(200000, 200000),
    stringsAsFactors = FALSE
  )
  Shotcrete <- list(
    liningTypeID = "shotcrete",
    concreteTypeID = "plain-concrete",
    sectionID = "shotcrete-h150-reinforced",
    centroidalRadiusM = 1.24,
    poisson = 0.20,
    thicknessM = 0.15,
    youngModulusKPa = 25e6,
    stiffnessBasisID = "aci-318-25-cracked-wall-0p35-ig",
    compressiveStrengthMPa = 30,
    stripWidthM = 1,
    reinforcement = Reinforcement,
    orthogonalReinforcement = Reinforcement,
    reinforcementGradeID = "Grade-60",
    orthogonalAreaMm2 = 270,
    convergenceTolerance = 2e-3
  )
  EmptyReinforcement <- Reinforcement[0, , drop = FALSE]
  Plain <- Shotcrete
  Plain$sectionID <- "shotcrete-h150-plain"
  Plain$reinforcement <- EmptyReinforcement
  Plain$orthogonalReinforcement <- EmptyReinforcement
  Plain$orthogonalAreaMm2 <- 0

  Scenarios <- list(
    list(
      scenarioID = "steel-h2-t2.64",
      cover = Cover(2),
      ground = Ground,
      interfaceID = "fullTraction",
      comparisonInterfaceID = "fullSlip",
      tangentialMultiplier = 1,
      action = Action,
      numerics = Numerics,
      lining = Steel("steel-t2.64", 2.64)
    ),
    list(
      scenarioID = "steel-h4-t2.64",
      cover = Cover(4),
      ground = Ground,
      interfaceID = "fullTraction",
      comparisonInterfaceID = "fullSlip",
      tangentialMultiplier = 1,
      action = Action,
      numerics = Numerics,
      lining = Steel("steel-t2.64", 2.64)
    ),
    list(
      scenarioID = "steel-h2-t1.98",
      cover = Cover(2),
      ground = Ground,
      interfaceID = "fullTraction",
      comparisonInterfaceID = "fullSlip",
      tangentialMultiplier = 1,
      action = Action,
      numerics = Numerics,
      lining = Steel("steel-t1.98", 1.98)
    ),
    list(
      scenarioID = "shotcrete-h2",
      cover = Cover(2),
      ground = Ground,
      interfaceID = "fullTraction",
      comparisonInterfaceID = "fullSlip",
      tangentialMultiplier = 1,
      action = Action,
      numerics = Numerics,
      lining = Shotcrete
    ),
    list(
      scenarioID = "plain-h2",
      cover = Cover(2),
      ground = Ground,
      interfaceID = "fullTraction",
      comparisonInterfaceID = "fullSlip",
      tangentialMultiplier = 1,
      action = Action,
      numerics = Numerics,
      lining = Plain
    )
  )
  Result <- evaluateCoverScenarios(
    scenarios = Scenarios,
    theta = Theta,
    sectionReference = SectionReference
  )
  stopifnot(
    nrow(Result$steelSummary) == 3L,
    nrow(Result$shotcreteSummary) == 2L,
    all(is.na(Result$steelSummary$aisiWallMemberUtilization)),
    all(
      Result$steelSummary$aisiWallMemberStatus ==
        "not-evaluated-capacities"
    )
  )
  SteelH2 <- Result$steelSummary[
    Result$steelSummary$scenarioID == "steel-h2-t2.64",
  ]
  SteelH4 <- Result$steelSummary[
    Result$steelSummary$scenarioID == "steel-h4-t2.64",
  ]
  SteelThin <- Result$steelSummary[
    Result$steelSummary$scenarioID == "steel-h2-t1.98",
  ]
  ShotcreteH2 <- Result$shotcreteSummary[
    Result$shotcreteSummary$scenarioID == "shotcrete-h2",
  ]
  PlainH2 <- Result$shotcreteSummary[
    Result$shotcreteSummary$scenarioID == "plain-h2",
  ]
  stopifnot(
    SteelH4$normalAbsoluteMaxKnPerM > SteelH2$normalAbsoluteMaxKnPerM,
    abs(
      SteelThin$momentAbsoluteMaxKnMPerM -
        SteelH2$momentAbsoluteMaxKnMPerM
    ) > 1e-8,
    abs(
      ShotcreteH2$momentAbsoluteMaxKnMPerM -
        SteelH2$momentAbsoluteMaxKnMPerM
    ) > 1e-8,
    is.finite(ShotcreteH2$shotcreteMechanicalUtilization),
    ShotcreteH2$shotcreteNormativeStatus ==
      "not-evaluated-code-basis",
    PlainH2$shotcreteMechanicalStatus == "not-applicable",
    is.na(PlainH2$shotcreteMechanicalUtilization),
    PlainH2$minimumReinforcementStatus == "not-applicable"
  )
  SteelStress <- Result$scenarios[["steel-h2-t2.64"]]$freeFieldStress
  ShotcreteStress <- Result$scenarios[["shotcrete-h2"]]$freeFieldStress
  stopifnot(
    SteelStress$effectiveVerticalStressKPa ==
      ShotcreteStress$effectiveVerticalStressKPa,
    SteelStress$depthM == ShotcreteStress$depthM
  )

  AisiSectionID <- "steel-t2.64-aisi-fixture"
  AisiCapacities <- data.frame(
    sectionID = AisiSectionID,
    capacityID = c(
      "ta", "pa", "ma-positive", "ma-negative", "mat-positive",
      "mat-negative", "malo-positive", "malo-negative", "va-positive",
      "va-negative"
    ),
    capacityRoleID = c(
      "Ta", "Pa", "Ma", "Ma", "Mat", "Mat", "MaloH2", "MaloH2",
      "Va", "Va"
    ),
    senseID = c(
      "not-applicable", "not-applicable", "positive", "negative",
      "positive", "negative", "positive", "negative", "positive",
      "negative"
    ),
    nominalValue = NA_real_,
    availableValue = c(100, 100, 50, 40, 60, 55, 40, 35, 20, 18),
    unit = c(
      "kN/m", "kN/m", rep("kN m/m", 6L), "kN/m", "kN/m"
    ),
    designMethodID = "ASD",
    widthBasisID = "per-projected-metre",
    capacityConsumerID = c(
      "general", "general", "general", "general", "H1", "H1", "H2",
      "H2", "general", "general"
    ),
    capacityBasisID = "test",
    applicabilityStatus = "satisfied",
    sourceLocator = "internal mathematical control",
    limitStateID = c(
      "D", "E", "F", "F", "F", "F", "F-H2", "F-H2", "G", "G"
    ),
    sectionHoleStatus = c(
      rep("absent", 8L), rep("not-applicable", 2L)
    ),
    webHoleStatus = c(
      rep("not-applicable", 8L), rep("absent", 2L)
    ),
    netSectionBasisID = NA_character_,
    capacityCoverageStatus = "satisfied",
    capacityCoverageEvidenceLocator = "synthetic complete capacity set",
    evidenceLocator = "internal mathematical control",
    stringsAsFactors = FALSE
  )
  AisiSettings <- list(
    standardID = "ANSI-SDI-AISI-S100-24",
    jurisdictionID = "US",
    designMethodID = "ASD",
    loadCombinationBasisID = "synthetic-ASD-basis",
    demandBasisID = "asd-required",
    editionAdoptionStatus = "satisfied",
    evaluationPurposeID = "strength-check",
    widthBasisID = "per-projected-metre",
    axialZeroToleranceKnPerM = 1e-10,
    momentZeroToleranceKnMPerM = 1e-12,
    shearZeroToleranceKnPerM = 1e-10,
    angleToleranceDeg = 1e-10
  )
  AisiApplicability <- list(
    sectionClassID = "general-uniaxial",
    secondOrderStatus = "satisfied",
    concentricDemandStatus = "satisfied",
    concentricDemandEvidenceLocator = "synthetic regression fixture",
    b4Status = "satisfied",
    b4EvidenceLocator = "synthetic regression fixture",
    crossSectionSymmetryStatus = "satisfied",
    shearInWebPlaneStatus = "satisfied",
    shearMappingStatus = "satisfied",
    shearRouteID = "accepted-alternative",
    shearRouteStatus = "satisfied",
    shearRouteEvidenceLocator = "synthetic regression fixture",
    shearStiffenerStatus = "absent",
    g4GateStatus = c(
      strengthStiffness = "satisfied",
      spacingLe2h = "satisfied",
      flangeDistortionRestraint = "satisfied",
      spanEndAttachment = "satisfied"
    ),
    g4GateEvidenceLocator = c(
      strengthStiffness = "synthetic regression fixture",
      spacingLe2h = "synthetic regression fixture",
      flangeDistortionRestraint = "synthetic regression fixture",
      spanEndAttachment = "synthetic regression fixture"
    ),
    localizedReactionRouteID = "unknown",
    localizedReactionRouteStatus = "unknown",
    localizedReactionRouteEvidenceLocator = "not required",
    h3InteractionCaseID = "unknown",
    h3CaseEvidenceLocator = "not required",
    localizedReactionStatus = "absent-demonstrated",
    localizedReactionEvidenceLocator = "distributed load fixture"
  )
  AisiScenario <- Scenarios[[1L]]
  AisiScenario$scenarioID <- "steel-h2-aisi-fixture"
  AisiScenario$action$forceEffectStatus <- "asd-required"
  AisiScenario$action$loadCombinationBasisID <- "synthetic-ASD-basis"
  AisiScenario$lining$sectionID <- AisiSectionID
  AisiScenario$lining$aisi <- list(
    capacityBaseThicknessMm = 2.64,
    capacityYieldStrengthMPa = 250,
    capacityProfileID = "cspi-76x25-csp-sheet",
    capacityReferenceRowID = "cspi-76x25-2.8",
    capacities = AisiCapacities,
    applicability = AisiApplicability,
    settings = AisiSettings
  )
  AisiResult <- evaluateCoverScenario(
    scenario = AisiScenario,
    theta = Theta,
    sectionReference = SectionReference
  )
  stopifnot(
    AisiResult$summary$aisiWallMemberStatus == ifelse(
      AisiResult$summary$aisiWallMemberUtilization <= 1,
      "pass",
      "fail"
    ),
    AisiResult$summary$aisiSystemStatus == "blocked",
    is.finite(AisiResult$summary$aisiWallMemberUtilization),
    AisiResult$summary$aisiWallMemberUtilization ==
      AisiResult$assessment$aisi$summary$governingNormalizedCheckValue
  )

  AisiThicknessMismatch <- AisiScenario
  AisiThicknessMismatch$lining$remainingBaseThicknessMm <- 1.98
  AisiThicknessMismatch.error <- tryCatch(
    evaluateCoverScenario(
      scenario = AisiThicknessMismatch,
      theta = Theta,
      sectionReference = SectionReference
    ),
    error = function(e) conditionMessage(e)
  )
  stopifnot(grepl(
    "different base thicknesses",
    AisiThicknessMismatch.error,
    fixed = TRUE
  ))

  AisiYieldMismatch <- AisiScenario
  AisiYieldMismatch$lining$yieldStrengthMPa <- 300
  AisiYieldMismatch.error <- tryCatch(
    evaluateCoverScenario(
      scenario = AisiYieldMismatch,
      theta = Theta,
      sectionReference = SectionReference
    ),
    error = function(e) conditionMessage(e)
  )
  stopifnot(grepl(
    "different yield strengths",
    AisiYieldMismatch.error,
    fixed = TRUE
  ))

  AisiProfileMismatch <- AisiScenario
  AisiProfileMismatch$lining$aisi$capacityProfileID <- "other-profile"
  AisiProfileMismatch.error <- tryCatch(
    evaluateCoverScenario(
      scenario = AisiProfileMismatch,
      theta = Theta,
      sectionReference = SectionReference
    ),
    error = function(e) conditionMessage(e)
  )
  stopifnot(grepl(
    "different profiles",
    AisiProfileMismatch.error,
    fixed = TRUE
  ))

  FixedValues <- data.frame(
    combinationID = "synthetic-ASD-basis",
    stageID = "completed-fill",
    thetaRad = 0,
    thetaDeg = 0,
    normalForceKnPerM = -20,
    bendingMomentKnMPerM = 15,
    shearForceKnPerM = 8,
    forceEffectStatus = "asd-required",
    longitudinalBasis = "per-projected-metre",
    stringsAsFactors = FALSE
  )
  FixedDemand <- .buildAisiDemandFromInteraction(
    values = FixedValues,
    scenarioID = "accepted-concurrent-fixture",
    sectionID = AisiSectionID
  )
  FixedResult <- evaluateAisiS100Demand(
    demand = FixedDemand,
    capacities = AisiCapacities,
    applicability = AisiApplicability,
    settings = AisiSettings
  )
  FixedH1 <- FixedResult$checks[
    FixedResult$checks$clauseID == "Eq. H1.2-1",
  ]
  FixedH2 <- FixedResult$checks[
    FixedResult$checks$clauseID == "Eq. H2-1",
  ]
  FixedH3 <- FixedResult$checks[
    FixedResult$checks$checkFamilyID == "H3",
  ]
  stopifnot(
    nrow(FixedH1) == 1L,
    nrow(FixedH2) == 1L,
    FixedH1$equationValue == 0.5,
    abs(FixedH2$equationValue - 0.300625) < 1e-15,
    !any(FixedH3$evaluationStatus %in% c("pass", "fail"))
  )

  InvalidStiffness <- Scenarios[[4L]]
  InvalidStiffness$lining$stiffnessBasisID <- "gross-uncracked-short-term"
  InvalidStiffness.error <- tryCatch(
    evaluateCoverScenario(
      scenario = InvalidStiffness,
      theta = Theta,
      sectionReference = SectionReference
    ),
    error = function(e) conditionMessage(e)
  )
  stopifnot(grepl(
    "aci-318-25-cracked-wall-0p35-ig",
    InvalidStiffness.error,
    fixed = TRUE
  ))

  PoissonMismatch <- Scenarios[c(4L, 4L)]
  PoissonMismatch[[1L]]$scenarioID <- "shotcrete-nu-020"
  PoissonMismatch[[2L]]$scenarioID <- "shotcrete-nu-025"
  PoissonMismatch[[2L]]$lining$poisson <- 0.25
  PoissonMismatch.error <- tryCatch(
    evaluateCoverScenarios(
      scenarios = PoissonMismatch,
      theta = Theta,
      sectionReference = SectionReference
    ),
    error = function(e) conditionMessage(e)
  )
  stopifnot(grepl("reused", PoissonMismatch.error, fixed = TRUE))

  ShotcreteOnly <- evaluateCoverScenarios(
    scenarios = Scenarios[4:5],
    theta = Theta
  )
  stopifnot(nrow(ShotcreteOnly$shotcreteSummary) == 2L)

  Mismatched <- Scenarios[1:2]
  Mismatched[[2]]$lining$remainingBaseThicknessMm <- 1.98
  Identity.error <- tryCatch(
    evaluateCoverScenarios(
      scenarios = Mismatched,
      theta = Theta,
      sectionReference = SectionReference
    ),
    error = function(e) conditionMessage(e)
  )
  stopifnot(grepl("reused", Identity.error, fixed = TRUE))
  invisible(TRUE)
}

runCoverScenarioTests()
cat("PASS: cover scenarios for steel and shotcrete.\n")
