buildAashtoStatusSummary <- function(checks) {
  if (!is.data.frame(checks) || !("checkStatus" %in% names(checks)) ||
      nrow(checks) == 0L) {
    stop("AASHTO checks are unavailable for the summary.", call. = FALSE)
  }
  Statuses <- checks[["checkStatus", exact = TRUE]]
  AllowedStatuses <- c("satisfied", "not-satisfied", "not-evaluated")
  if (anyNA(Statuses) || any(!(Statuses %in% AllowedStatuses))) {
    stop("The AASHTO summary contains unsupported states.", call. = FALSE)
  }

  TotalCount <- length(Statuses)
  SatisfiedCount <- sum(Statuses == "satisfied")
  NotSatisfiedCount <- sum(Statuses == "not-satisfied")
  NotEvaluatedCount <- sum(Statuses == "not-evaluated")
  EvaluatedCount <- TotalCount - NotEvaluatedCount

  if (SatisfiedCount == TotalCount) {
    return(paste0(
      "Los ", TotalCount,
      " controles numéricos evaluados satisfacen sus límites."
    ))
  }
  if (NotSatisfiedCount == TotalCount) {
    return(paste0(
      "Ninguno de los ", TotalCount,
      " controles numéricos evaluados satisface su límite."
    ))
  }
  if (NotEvaluatedCount == TotalCount) {
    return(paste0(
      "Ninguno de los ", TotalCount,
      " controles numéricos pudo evaluarse."
    ))
  }
  if (SatisfiedCount == EvaluatedCount) {
    return(paste0(
      "Los ", EvaluatedCount,
      " controles numéricos evaluados satisfacen sus límites; ",
      NotEvaluatedCount, " no fueron evaluados."
    ))
  }
  if (NotSatisfiedCount == EvaluatedCount) {
    return(paste0(
      "Ninguno de los ", EvaluatedCount,
      " controles numéricos evaluados satisface su límite; ",
      NotEvaluatedCount, " no fueron evaluados."
    ))
  }
  paste0(
    "Algunos controles numéricos satisfacen sus límites: ",
    SatisfiedCount, " de ", TotalCount, " satisfacen, ",
    NotSatisfiedCount, " no satisfacen y ",
    NotEvaluatedCount, " no fueron evaluados."
  )
}

buildConcreteLocalStatusSummary <- function(summaryData, concreteTypeID) {
  if (!is.data.frame(summaryData) ||
      !("shotcreteLocalStrengthStatus" %in% names(summaryData)) ||
      nrow(summaryData) == 0L) {
    stop("Concrete local checks are unavailable for the summary.", call. = FALSE)
  }
  Statuses <- summaryData[["shotcreteLocalStrengthStatus", exact = TRUE]]
  if (anyNA(Statuses) ||
      any(!(Statuses %in% c("satisfied", "not-satisfied")))) {
    stop("The concrete summary contains unsupported local states.", call. = FALSE)
  }
  TypeLabel <- switch(
    concreteTypeID,
    `plain-concrete` = "hormigón simple",
    `reinforced-concrete` = "hormigón armado",
    stop("Unsupported concreteTypeID in the summary.", call. = FALSE)
  )
  TotalCount <- length(Statuses)
  SatisfiedCount <- sum(Statuses == "satisfied")
  if (SatisfiedCount == TotalCount) {
    return(paste0(
      "Las comprobaciones locales de ", TypeLabel,
      " satisfacen el límite resistente en las ", TotalCount,
      " representaciones de carga."
    ))
  }
  if (SatisfiedCount == 0L) {
    return(paste0(
      "Las comprobaciones locales de ", TypeLabel,
      " no satisfacen el límite resistente en ninguna de las ",
      TotalCount, " representaciones de carga."
    ))
  }
  paste0(
    "Las comprobaciones locales de ", TypeLabel,
    " satisfacen el límite resistente en ", SatisfiedCount,
    " de las ", TotalCount, " representaciones de carga."
  )
}

buildMinimumReinforcementStatusSummary <- function(summaryData) {
  Statuses <- unique(summaryData[["minimumReinforcementStatus", exact = TRUE]])
  if (length(Statuses) != 1L ||
      !(Statuses %in% c("satisfied", "not-satisfied"))) {
    stop("The minimum-reinforcement state is incomplete.", call. = FALSE)
  }
  if (Statuses == "satisfied") {
    return(paste(
      "La armadura provista satisface la cuantía mínima en las direcciones",
      "circunferencial y longitudinal."
    ))
  }
  paste(
    "La armadura provista no satisface la cuantía mínima en al menos una",
    "de las dos direcciones."
  )
}

if (!exists("projectRoot", inherits = FALSE)) {
  stop("projectRoot must be defined before loading calculation results.", call. = FALSE)
}

loadCoverCalculationResults <- function(
  projectRoot,
  calculationDirectory = file.path(projectRoot, "data", "calculation")
) {
  Directory <- normalizePath(calculationDirectory, mustWork = TRUE)
  Paths <- list(
    inputs = file.path(Directory, "calculation.inputs.csv"),
    section = file.path(Directory, "section.properties.csv"),
    stress = file.path(Directory, "stress.state.csv"),
    interaction = file.path(Directory, "interaction.parameters.csv"),
    schwartzEinstein = file.path(
      Directory,
      "schwartz.einstein.comparison.csv"
    ),
    resultants = file.path(Directory, "section.resultants.csv"),
    extrema = file.path(Directory, "section.extrema.csv"),
    controls = file.path(Directory, "numerical.controls.csv"),
    scales = file.path(Directory, "display.scales.csv"),
    aashtoInputs = file.path(Directory, "aashto.inputs.csv"),
    aashtoThrust = file.path(Directory, "aashto.thrust.csv"),
    aashtoCalculation = file.path(Directory, "aashto.calculation.csv"),
    aashtoChecks = file.path(Directory, "aashto.checks.csv"),
    aashtoSummary = file.path(Directory, "aashto.summary.csv"),
    shotcreteSection = file.path(
      Directory,
      "shotcrete.section.properties.csv"
    ),
    shotcreteInteraction = file.path(
      Directory,
      "shotcrete.interaction.parameters.csv"
    ),
    shotcreteSchwartzEinstein = file.path(
      Directory,
      "shotcrete.schwartz.einstein.comparison.csv"
    ),
    shotcreteResultants = file.path(
      Directory,
      "shotcrete.section.resultants.csv"
    ),
    shotcreteExtrema = file.path(
      Directory,
      "shotcrete.section.extrema.csv"
    ),
    shotcreteScales = file.path(
      Directory,
      "shotcrete.display.scales.csv"
    ),
    shotcreteControls = file.path(
      Directory,
      "shotcrete.numerical.controls.csv"
    ),
    shotcreteChecks = file.path(Directory, "shotcrete.checks.csv"),
    shotcreteSummary = file.path(Directory, "shotcrete.summary.csv"),
    shotcreteAxialFlexureDomain = file.path(
      Directory,
      "shotcrete.axial.flexure.domain.csv"
    ),
    shotcreteAxialFlexureDemands = file.path(
      Directory,
      "shotcrete.axial.flexure.demands.csv"
    ),
    shotcreteReinforcementDomains = file.path(
      Directory,
      "shotcrete.axial.flexure.reinforcement.domains.csv"
    ),
    shotcreteReinforcementSweep = file.path(
      Directory,
      "shotcrete.axial.flexure.reinforcement.sweep.csv"
    ),
    shotcreteReinforcementGoverningDemands = file.path(
      Directory,
      "shotcrete.axial.flexure.reinforcement.governing.demands.csv"
    ),
    shotcreteReinforcementLimitChecks = file.path(
      Directory,
      "shotcrete.axial.flexure.reinforcement.limit.checks.csv"
    ),
    classicalComparisonInputs = file.path(
      Directory, "classical.comparison.inputs.csv"
    ),
    classicalComparisonSections = file.path(
      Directory, "classical.comparison.sections.csv"
    ),
    classicalComparisonCurves = file.path(
      Directory, "classical.comparison.curves.csv"
    ),
    classicalComparisonPoints = file.path(
      Directory, "classical.comparison.points.csv"
    ),
    classicalComparisonSummary = file.path(
      Directory, "classical.comparison.summary.csv"
    ),
    config = file.path(Directory, "calculation.config.json")
  )
  readProduct <- function(path, required) {
    if (!file.exists(path)) {
      stop("The calculation product is not available: ", path, call. = FALSE)
    }
    Data <- utils::read.csv(
      path,
      check.names = FALSE,
      stringsAsFactors = FALSE,
      na.strings = ""
    )
    Missing <- setdiff(required, names(Data))
    if (length(Missing) > 0L) {
      stop(
        basename(path), " is missing: ", paste(Missing, collapse = ", "), ".",
        call. = FALSE
      )
    }
    Data
  }

  Config <- validateCoverCalculationConfig(readCalculationJson(Paths$config))
  if (Config[["schemaVersion", exact = TRUE]] != "3.1.0" ||
      Config[["analysisModelID", exact = TRUE]] !=
        "schwartz-einstein-balanced-gradient-hybrid") {
    stop("The main calculation must use schema 3.1.0.", call. = FALSE)
  }
  Inputs <- readProduct(
    Paths$inputs,
    c(
      "scenarioID", "caseID", "groupID", "parameterID", "symbol",
      "numericValue", "textValue", "unit", "evidenceLevel",
      "conditionCode"
    )
  )
  Stress <- readProduct(
    Paths$stress,
    c(
      "scenarioID", "stressStateID", "stressModelID",
      "referencePositionID", "depthM", "coverCrownM", "crownToAxisM",
      "effectiveUnitWeightKnPerM3", "effectiveSurchargeKPa",
      "effectiveVerticalStressKPa", "effectiveHorizontalStressKPa",
      "k0ModelID", "k0Applied", "domainStatus", "evidenceLevel"
    )
  )
  Section <- readProduct(
    Paths$section,
    c(
      "scenarioID", "sectionID", "profileID", "referenceRowID",
      "propertyModelID", "nominalPitchMm", "nominalDepthMm",
      "actualPitchMm", "actualDepthMm", "corrugationRadiusMm",
      "specifiedThicknessMm", "designBaseThicknessMm",
      "remainingBaseThicknessMm", "areaMm2PerMm", "inertiaMm4PerMm",
      "sectionModulusMm3PerMm", "centroidalRadiusM",
      "circumferentialYoungModulusGPa", "extensionalRigidityKnPerM",
      "flexuralRigidityKnM2PerM", "sectionRatio", "yieldStrengthMPa",
      "sourceKey", "sourceLocator", "domainStatus"
    )
  )
  Interaction <- readProduct(
    Paths$interaction,
    c(
      "scenarioID", "caseID", "sectionID", "interactionModelID",
      "interfaceID", "combinationID", "stageID", "forceEffectStatus",
      "stressReferenceID", "effectiveVerticalStressKPa",
      "effectiveHorizontalStressKPa", "waterPressureDifferenceKPa",
      "stressRatio", "tangentialMultiplier", "sectionRatio",
      "normalMeanKnPerM", "normalCosineKnPerM",
      "momentMeanKnMPerM", "momentCosineKnMPerM", "shearSineKnPerM",
      "sourceKey", "sourceLocator"
    )
  )
  Resultants <- readProduct(
    Paths$resultants,
    c(
      "scenarioID", "caseID", "sectionID", "stressStateID",
      "combinationID", "stageID", "forceEffectStatus",
      "interactionModelID", "interfaceID", "stressReferenceID",
      "resultantID", "thetaIndex", "thetaRad", "thetaDeg", "value",
      "unit", "evidenceLevel"
    )
  )
  Extrema <- readProduct(
    Paths$extrema,
    c(
      "scenarioID", "caseID", "sectionID", "stressStateID",
      "combinationID", "stageID", "forceEffectStatus",
      "interactionModelID", "interfaceID", "stressReferenceID",
      "resultantID", "statisticID", "value", "signedValue", "thetaRad",
      "thetaDeg", "unit", "evidenceLevel"
    )
  )
  Controls <- readProduct(
    Paths$controls,
    c(
      "scenarioID", "caseID", "controlID", "resultantID", "metricID",
      "observedValue", "comparison", "limitValue", "unit", "pass",
      "thetaPointCount", "evidenceLevel"
    )
  )
  Scales <- readProduct(
    Paths$scales,
    c(
      "scenarioID", "resultantID", "referenceRadiusM", "displayScale",
      "maximumAbsoluteValue", "resultantUnit", "radialFraction",
      "graphicAmplification", "ordinateCount", "evidenceLevel"
    )
  )
  AashtoInputs <- readProduct(
    Paths$aashtoInputs,
    c(
      "scenarioID", "standardID", "editionID", "branchID",
      "productTypeID", "sourceBasisID", "specificationStatus",
      "demandBasisID", "factorBasisID", "combinationID", "stageID",
      "forceEffectStatus", "coverCrownM", "totalUnitWeightKnPerM3",
      "deadSurchargeKPa",
      "spanM", "areaMm2PerMm", "inertiaMm4PerMm",
      "yieldStrengthMPa", "tensileStrengthMPa", "elasticModulusMPa",
      "deadLoadFactor", "liveLoadFactor", "demandModifier",
      "liveCrownPressureKPa", "liveLoadedWidthM", "soilStiffnessFactor",
      "wallResistanceFactor", "seamResistanceFactor",
      "seamID", "seamNominalResistanceKnPerM", "fastenerDiameterMm",
      "fastenerDiameterLossRatio", "flexibilityLimitMmPerN"
    )
  )
  AashtoThrust <- readProduct(
    Paths$aashtoThrust,
    c(
      "scenarioID", "demandBasisID", "combinationID", "stageID",
      "forceEffectStatus", "loadModelID", "quantityID", "value", "unit",
      "factorBasis"
    )
  )
  AashtoCalculation <- readProduct(
    Paths$aashtoCalculation,
    c(
      "scenarioID", "standardID", "editionID", "branchID",
      "structuralProductID", "combinationID", "stageID",
      "forceEffectStatus", "demandBasisID", "designThrustKnPerM",
      "spanM", "areaMm2PerMm", "inertiaMm4PerMm", "gyrationRadiusMm",
      "bucklingBranchID", "criticalBucklingStressMPa",
      "yieldResistanceKnPerM", "bucklingResistanceKnPerM",
      "referenceSeamNominalResistanceKnPerM", "fastenerDiameterMm",
      "fastenerDiameterLossRatio", "remainingFastenerDiameterMm",
      "fastenerAreaRatio", "corrodedSeamNominalResistanceKnPerM",
      "factoredSeamResistanceKnPerM", "seamUtilizationAtZeroLoss",
      "criticalFastenerDiameterLossRatio",
      "flexibilityFactorMmPerN", "minimumCoverM", "specificationStatus"
    )
  )
  AashtoChecks <- readProduct(
    Paths$aashtoChecks,
    c(
      "scenarioID", "demandBasisID", "checkID", "observedValue",
      "limitValue", "unit", "utilization", "checkStatus",
      "normativeStatus", "sourceKey", "sourceLocator"
    )
  )
  AashtoSummary <- readProduct(
    Paths$aashtoSummary,
    c(
      "scenarioID", "demandBasisID", "standardID", "editionID",
      "branchID", "structuralProductID", "calculationStatus",
      "specificationStatus", "systemStatus", "normativeStatus",
      "wallStatus", "seamStatus", "flexibilityStatus",
      "minimumCoverStatus", "governingCheckID", "governingUtilization"
    )
  )
  ClassicalComparisonInputs <- readProduct(
    Paths$classicalComparisonInputs,
    c(
      "scenarioID", "coverCrownM", "depthAxisM",
      "effectiveUnitWeightKnPerM3", "effectiveSurchargeKPa",
      "effectiveVerticalStressKPa", "effectiveHorizontalStressKPa",
      "k0Applied", "groundModulusKPa", "groundPoisson",
      "waterPressureDifferenceKPa", "nunezRelaxationFactor",
      "nunezContactFactor", "curveAngleStepDeg", "forceEffectStatus"
    )
  )
  ClassicalComparisonSections <- readProduct(
    Paths$classicalComparisonSections,
    c(
      "scenarioID", "liningID", "sectionID", "centroidalDiameterM",
      "structuralThicknessM", "nunezEquivalentThicknessM",
      "nunezThicknessBasisID", "youngModulusKPa", "poisson",
      "extensionalRigidityKnPerM", "flexuralRigidityKnM2PerM",
      "nunezInteractionRatio"
    )
  )
  ClassicalComparisonCurves <- readProduct(
    Paths$classicalComparisonCurves,
    c(
      "scenarioID", "liningID", "sectionID", "methodID", "caseID",
      "forceEffectStatus", "resultScopeID", "thetaIndex", "thetaRad",
      "thetaDeg", "resultantID", "value", "unit", "sourceKey",
      "sourceLocator"
    )
  )
  ClassicalComparisonPoints <- readProduct(
    Paths$classicalComparisonPoints,
    c(
      "scenarioID", "liningID", "sectionID", "methodID", "caseID",
      "forceEffectStatus", "resultScopeID", "pointID", "resultantID",
      "thetaDeg", "value", "unit", "valueStatusID", "sourceKey",
      "sourceLocator"
    )
  )
  ClassicalComparisonSummary <- readProduct(
    Paths$classicalComparisonSummary,
    c(
      "scenarioID", "liningID", "sectionID", "methodID", "caseID",
      "forceEffectStatus", "resultScopeID", "applicabilityStatus",
      "normalAbsoluteMaxKnPerM", "normalThetaDeg",
      "momentAbsoluteMaxKnMPerM", "momentThetaDeg",
      "shearAbsoluteMaxKnPerM", "shearThetaDeg",
      "normalRatioToOfficialEnvelope", "momentRatioToOfficialEnvelope",
      "shearRatioToOfficialEnvelope", "sourceKey", "sourceLocator"
    )
  )
  ShotcreteSection <- readProduct(
    Paths$shotcreteSection,
    c(
      "liningID", "scenarioID", "liningTypeID", "sectionID",
      "centroidalRadiusM", "thicknessM", "youngModulusKPa", "poisson",
      "areaM2PerM", "inertiaM4PerM", "extensionalRigidityKnPerM",
      "flexuralRigidityKnM2PerM", "sectionRatio",
      "equivalentThicknessM", "stiffnessBasisID"
    )
  )
  ShotcreteInteraction <- readProduct(
    Paths$shotcreteInteraction,
    c(
      "liningID", "scenarioID", "caseID", "sectionID",
      "interactionModelID", "interfaceID", "combinationID", "stageID",
      "forceEffectStatus", "stressReferenceID", "effectiveVerticalStressKPa",
      "effectiveHorizontalStressKPa", "waterPressureDifferenceKPa",
      "stressRatio", "tangentialMultiplier", "sectionRatio",
      "normalMeanKnPerM", "normalCosineKnPerM", "momentMeanKnMPerM",
      "momentCosineKnMPerM", "shearSineKnPerM"
    )
  )
  ShotcreteResultants <- readProduct(
    Paths$shotcreteResultants,
    c(
      "liningID", "scenarioID", "caseID", "sectionID", "stressStateID",
      "combinationID", "stageID", "forceEffectStatus", "interactionModelID",
      "interfaceID", "stressReferenceID", "resultantID", "thetaIndex",
      "thetaRad", "thetaDeg", "value", "unit"
    )
  )
  ShotcreteExtrema <- readProduct(
    Paths$shotcreteExtrema,
    c(
      "liningID", "scenarioID", "caseID", "sectionID", "stressStateID",
      "combinationID", "stageID", "forceEffectStatus", "interactionModelID",
      "interfaceID", "stressReferenceID", "resultantID", "statisticID",
      "value", "signedValue", "thetaRad", "thetaDeg", "unit"
    )
  )
  ShotcreteScales <- readProduct(
    Paths$shotcreteScales,
    c(
      "liningID", "scenarioID", "resultantID", "referenceRadiusM",
      "displayScale", "maximumAbsoluteValue", "resultantUnit",
      "radialFraction", "graphicAmplification", "ordinateCount",
      "evidenceLevel"
    )
  )
  ShotcreteControls <- readProduct(
    Paths$shotcreteControls,
    c(
      "liningID", "scenarioID", "caseID", "controlID", "resultantID",
      "metricID", "observedValue", "comparison", "limitValue", "unit",
      "pass", "thetaPointCount", "evidenceLevel"
    )
  )
  ShotcreteChecks <- readProduct(
    Paths$shotcreteChecks,
    c(
      "scenarioID", "liningID", "sectionID", "concreteTypeID", "caseID",
      "interfaceID", "strengthCaseID", "combinationID", "stageID",
      "forceEffectStatus", "thetaRad", "thetaDeg", "normalForceKnPerM",
      "bendingMomentKnMPerM", "shearForceKnPerM", "axialForceKn",
      "bendingMomentKnM", "shearDemandKn", "checkID", "standardID",
      "clauseID", "sourceLocator", "demandValue", "capacityValue", "unit",
      "utilization", "applicabilityStatus", "calculationStatus",
      "checkStatus", "blockReason", "verticalStressFactor",
      "horizontalStressFactor", "loadCombinationBasisID",
      "loadCombinationSourceLocator"
    )
  )
  ShotcreteSummary <- readProduct(
    Paths$shotcreteSummary,
    c(
      "scenarioID", "liningID", "liningScenarioID", "caseID", "sectionID",
      "concreteTypeID", "coverCrownM", "thicknessM", "interfaceID",
      "normalAbsoluteMaxKnPerM", "momentAbsoluteMaxKnMPerM",
      "shearAbsoluteMaxKnPerM", "shotcreteMechanicalUtilization",
      "shotcreteMechanicalStatus", "minimumReinforcementStatus",
      "shotcreteLocalStrengthUtilization", "shotcreteNormativeStatus",
      "shotcreteLocalStrengthStatus", "shotcreteGoverningStrengthCaseID",
      "shotcreteGoverningCheckID"
    )
  )
  ShotcreteAxialFlexureDomain <- readProduct(
    Paths$shotcreteAxialFlexureDomain,
    c(
      "scenarioID", "liningID", "sectionID", "concreteTypeID",
      "domainPointIndex", "axialStrengthKnPerM",
      "bendingStrengthKnMPerM", "nominalAxialStrengthKnPerM",
      "nominalBendingStrengthKnMPerM", "strengthReductionFactor",
      "stateID", "compressionFaceID", "netTensileStrain",
      "domainPrimitiveID", "provisionID", "designBasisID",
      "strengthReductionRuleID", "sourceLocator"
    )
  )
  ShotcreteAxialFlexureDemands <- readProduct(
    Paths$shotcreteAxialFlexureDemands,
    c(
      "scenarioID", "liningID", "sectionID", "concreteTypeID", "caseID",
      "interfaceID", "strengthCaseID", "thetaIndex", "thetaRad",
      "thetaDeg", "combinationID", "stageID", "forceEffectStatus",
      "axialDemandKnPerM", "bendingDemandKnMPerM",
      "radialCapacityMultiplier", "radialUtilization", "domainPositionID",
      "convergenceRelativeDifference", "convergenceStatus", "checkStatus",
      "verticalStressFactor", "horizontalStressFactor",
      "loadCombinationBasisID"
    )
  )
  ShotcreteReinforcementDomains <- readProduct(
    Paths$shotcreteReinforcementDomains,
    c(
      "scenarioID", "liningID", "sectionID", "concreteTypeID",
      "studyID", "reinforcementCaseID", "domainPointIndex",
      "axialStrengthKnPerM", "bendingStrengthKnMPerM",
      "domainPrimitiveID", "provisionID", "designBasisID",
      "strengthReductionRuleID", "sourceLocator"
    )
  )
  ShotcreteReinforcementSweep <- readProduct(
    Paths$shotcreteReinforcementSweep,
    c(
      "scenarioID", "liningID", "sectionID", "concreteTypeID",
      "studyID", "reinforcementCaseID", "reinforcementCaseOrder",
      "barDiameterMm", "barSpacingMm", "clearCoverMm",
      "reinforcementArrangementID",
      "circumferentialAreaTotalMm2PerM", "reinforcementRatio",
      "calculationStatus",
      "maximumRadialUtilization", "localPMStatus", "governingCaseID",
      "governingInterfaceID", "governingStrengthCaseID",
      "governingCombinationID", "governingVerticalStressFactor",
      "governingHorizontalStressFactor", "governingThetaIndex",
      "governingThetaDeg", "governingAxialDemandKnPerM",
      "governingBendingDemandKnMPerM", "isParametricCase",
      "demandReuseBasisID",
      "demandReuseStatus", "blockReason", "maximumShearUtilization",
      "shearStatus", "radialTensionUtilization",
      "radialTensionStatus", "overallLocalStatus",
      "compositeActionHypothesisID",
      "interiorReinforcementAreaMm2PerM",
      "exteriorSheetAreaMm2PerM", "elasticCentroidCoordinateMm",
      "extensionalRigidityKnPerM", "flexuralRigidityKnM2PerM"
    )
  )
  ShotcreteReinforcementGoverningDemands <- readProduct(
    Paths$shotcreteReinforcementGoverningDemands,
    c(
      "scenarioID", "liningID", "sectionID", "concreteTypeID",
      "studyID", "reinforcementCaseID", "reinforcementCaseOrder",
      "circumferentialAreaTotalMm2PerM", "reinforcementRatio",
      "demandOrder", "selectionBasisID", "caseID",
      "interfaceID", "strengthCaseID", "combinationID",
      "verticalStressFactor", "horizontalStressFactor", "stageID",
      "forceEffectStatus", "loadCombinationBasisID", "thetaIndex",
      "thetaRad", "thetaDeg", "axialDemandKnPerM",
      "bendingDemandKnMPerM", "radialUtilization", "domainPositionID",
      "convergenceStatus", "checkStatus"
    )
  )
  ShotcreteReinforcementLimitChecks <- readProduct(
    Paths$shotcreteReinforcementLimitChecks,
    c(
      "scenarioID", "liningID", "sectionID", "reinforcementCaseID",
      "checkID", "standardID", "clauseID", "applicabilityStatus",
      "caseID", "interfaceID", "strengthCaseID", "thetaDeg",
      "demandValue", "capacityValue", "unit", "utilization",
      "checkStatus", "sourceLocator"
    )
  )
  AdditionalLinings <- Config[["additionalLinings", exact = TRUE]]
  LiningIDs <- names(AdditionalLinings)
  if (length(AdditionalLinings) == 0L || is.null(LiningIDs) ||
      any(!nzchar(LiningIDs)) || anyDuplicated(LiningIDs)) {
    stop("The report requires named concrete alternatives.", call. = FALSE)
  }
  LiningCount <- length(LiningIDs)
  InterfaceCount <- nrow(Config[["interfaceCases", exact = TRUE]])
  if (nrow(Stress) != 1L || nrow(Section) != 1L ||
      nrow(Interaction) != nrow(Config$interfaceCases) ||
      nrow(Resultants) == 0L || nrow(Extrema) != 9L * nrow(Interaction) ||
      nrow(Controls) != 6L * nrow(Interaction) || nrow(Scales) != 3L ||
      nrow(AashtoInputs) != 1L || nrow(AashtoThrust) == 0L ||
      nrow(AashtoCalculation) != 1L || nrow(AashtoChecks) != 5L ||
      nrow(AashtoSummary) != 1L ||
      nrow(ShotcreteSection) != LiningCount ||
      nrow(ShotcreteInteraction) != LiningCount * InterfaceCount ||
      nrow(ShotcreteResultants) == 0L ||
      nrow(ShotcreteExtrema) != 9L * LiningCount * InterfaceCount ||
      nrow(ShotcreteScales) != 3L * LiningCount ||
      nrow(ShotcreteControls) != 6L * LiningCount * InterfaceCount ||
      nrow(ShotcreteChecks) == 0L ||
      nrow(ShotcreteSummary) != LiningCount * InterfaceCount ||
      nrow(ShotcreteAxialFlexureDomain) == 0L ||
      nrow(ShotcreteAxialFlexureDemands) == 0L ||
      nrow(ShotcreteReinforcementDomains) == 0L ||
      nrow(ShotcreteReinforcementSweep) < 2L ||
      nrow(ShotcreteReinforcementGoverningDemands) !=
        nrow(ShotcreteReinforcementSweep) * InterfaceCount ||
      nrow(ShotcreteReinforcementLimitChecks) !=
        2L * nrow(ShotcreteReinforcementSweep) ||
      nrow(ClassicalComparisonInputs) != 1L ||
      nrow(ClassicalComparisonSections) != LiningCount + 1L ||
      nrow(ClassicalComparisonCurves) == 0L ||
      nrow(ClassicalComparisonPoints) == 0L ||
      nrow(ClassicalComparisonSummary) == 0L ||
      !setequal(
        unique(ClassicalComparisonSections$liningID),
        c("steel", LiningIDs)
      )) {
    stop("The cover-calculation products have incompatible row counts.", call. = FALSE)
  }
  ScenarioIDs <- unique(c(
    Inputs$scenarioID,
    Stress$scenarioID,
    Section$scenarioID,
    Interaction$scenarioID,
    Resultants$scenarioID,
    Extrema$scenarioID,
    Controls$scenarioID,
    Scales$scenarioID,
    AashtoInputs$scenarioID,
    AashtoThrust$scenarioID,
    AashtoCalculation$scenarioID,
    AashtoChecks$scenarioID,
    AashtoSummary$scenarioID
    ,
    ShotcreteAxialFlexureDomain$scenarioID,
    ShotcreteAxialFlexureDemands$scenarioID,
    ShotcreteReinforcementDomains$scenarioID,
    ShotcreteReinforcementSweep$scenarioID,
    ShotcreteReinforcementGoverningDemands$scenarioID,
    ShotcreteReinforcementLimitChecks$scenarioID
  ))
  if (length(ScenarioIDs) != 1L || ScenarioIDs != Config$scenarioID) {
    stop("The calculation products do not share the configured scenarioID.", call. = FALSE)
  }
  ExpectedCaseIDs <- Config[["interfaceCases", exact = TRUE]][[
    "caseID",
    exact = TRUE
  ]]
  ExpectedInterfaceIDs <- Config[["interfaceCases", exact = TRUE]][[
    "comparisonInterfaceID",
    exact = TRUE
  ]]
  ReinforcedConfig <- AdditionalLinings[["reinforcedConcrete", exact = TRUE]]
  ReinforcementPolicy <- if (is.null(ReinforcedConfig)) {
    NULL
  } else {
    ReinforcedConfig[["reinforcementStudy", exact = TRUE]]
  }
  if (is.null(ReinforcementPolicy)) {
    stop("The reinforced-concrete P-M family policy is unavailable.",
      call. = FALSE
    )
  }
  ExpectedStudyCases <- ReinforcementPolicy$reinforcementCases
  CompositePolicy <- ReinforcementPolicy$compositeCase
  CompositeCount <- if (isTRUE(CompositePolicy$enabled)) 1L else 0L
  ExpectedStudyCaseCount <- length(ExpectedStudyCases) + CompositeCount
  StudyIDs <- unique(c(
    ShotcreteReinforcementDomains$studyID,
    ShotcreteReinforcementSweep$studyID,
    ShotcreteReinforcementGoverningDemands$studyID
  ))
  if (length(StudyIDs) != 1L ||
      StudyIDs != ReinforcementPolicy$studyID ||
      nrow(ShotcreteReinforcementSweep) !=
        LiningCount * ExpectedStudyCaseCount ||
      any(
        ShotcreteReinforcementSweep$calculationStatus != "calculated" |
          ShotcreteReinforcementSweep$demandReuseStatus != "satisfied"
      ) ||
      any(
        ShotcreteReinforcementGoverningDemands$convergenceStatus !=
          "satisfied"
      )) {
    stop("The parametric P-M families are inconsistent.",
      call. = FALSE
    )
  }
  ConcreteProducts <- lapply(LiningIDs, function(liningID) {
    LiningConfig <- AdditionalLinings[[liningID, exact = TRUE]]
    ScenarioID <- paste(Config$scenarioID, liningID, sep = "--")
    Products <- list(
      section = ShotcreteSection[ShotcreteSection$liningID == liningID, , drop = FALSE],
      interaction = ShotcreteInteraction[ShotcreteInteraction$liningID == liningID, , drop = FALSE],
      resultants = ShotcreteResultants[ShotcreteResultants$liningID == liningID, , drop = FALSE],
      extrema = ShotcreteExtrema[ShotcreteExtrema$liningID == liningID, , drop = FALSE],
      scales = ShotcreteScales[ShotcreteScales$liningID == liningID, , drop = FALSE],
      controls = ShotcreteControls[ShotcreteControls$liningID == liningID, , drop = FALSE],
      checks = ShotcreteChecks[ShotcreteChecks$liningID == liningID, , drop = FALSE],
      summary = ShotcreteSummary[ShotcreteSummary$liningID == liningID, , drop = FALSE],
      axialFlexureDomain = ShotcreteAxialFlexureDomain[
        ShotcreteAxialFlexureDomain$liningID == liningID,
        ,
        drop = FALSE
      ],
      axialFlexureDemands = ShotcreteAxialFlexureDemands[
        ShotcreteAxialFlexureDemands$liningID == liningID,
        ,
        drop = FALSE
      ],
      reinforcementSweep = list(
        domains = ShotcreteReinforcementDomains[
          ShotcreteReinforcementDomains$liningID == liningID,
          ,
          drop = FALSE
        ],
        summary = ShotcreteReinforcementSweep[
          ShotcreteReinforcementSweep$liningID == liningID,
          ,
          drop = FALSE
        ],
        governingDemands = ShotcreteReinforcementGoverningDemands[
          ShotcreteReinforcementGoverningDemands$liningID == liningID,
          ,
          drop = FALSE
        ],
        limitChecks = ShotcreteReinforcementLimitChecks[
          ShotcreteReinforcementLimitChecks$liningID == liningID,
          ,
          drop = FALSE
        ]
      )
    )
    Sweep <- Products$reinforcementSweep$summary
    StudyDomains <- Products$reinforcementSweep$domains
    StudyDemands <- Products$reinforcementSweep$governingDemands
    StudyLimitChecks <- Products$reinforcementSweep$limitChecks
    StudyCaseIDs <- Sweep$reinforcementCaseID
    DomainGroups <- split(StudyDomains, StudyDomains$reinforcementCaseID)
    ExpectedDiameters <- vapply(
      ExpectedStudyCases,
      `[[`,
      numeric(1),
      "barDiameterMm"
    )
    ExpectedSpacings <- vapply(
      ExpectedStudyCases,
      `[[`,
      numeric(1),
      "barSpacingMm"
    )
    ExpectedAreas <- 2 * pi * ExpectedDiameters^2 / 4 *
      1000 / ExpectedSpacings
    ExpectedStudyRatios <- ExpectedAreas /
      (1000 * (1000 * LiningConfig$thicknessM))
    Parametric <- Sweep[Sweep$isParametricCase, , drop = FALSE]
    Composite <- Sweep[!Sweep$isParametricCase, , drop = FALSE]
    if (nrow(Sweep) != ExpectedStudyCaseCount ||
        anyDuplicated(StudyCaseIDs) ||
        !identical(Sweep$reinforcementCaseOrder, seq_len(ExpectedStudyCaseCount)) ||
        !isTRUE(all.equal(
          Parametric$reinforcementRatio,
          ExpectedStudyRatios,
          tolerance = 1e-12,
          check.attributes = FALSE
        )) ||
        !isTRUE(all.equal(
          Parametric$circumferentialAreaTotalMm2PerM,
          ExpectedAreas,
          tolerance = 1e-9,
          check.attributes = FALSE
        )) ||
        !isTRUE(all.equal(
          Parametric$barDiameterMm,
          ExpectedDiameters,
          tolerance = 1e-12,
          check.attributes = FALSE
        )) ||
        !isTRUE(all.equal(
          Parametric$barSpacingMm,
          ExpectedSpacings,
          tolerance = 1e-12,
          check.attributes = FALSE
        )) ||
        any(Parametric$reinforcementArrangementID != "symmetric-two-face") ||
        nrow(Parametric) != length(ExpectedStudyCases) ||
        nrow(Composite) != CompositeCount ||
        (CompositeCount == 1L &&
          Composite$reinforcementCaseID != CompositePolicy$caseID) ||
        !setequal(unique(StudyDomains$reinforcementCaseID), StudyCaseIDs) ||
        any(!vapply(DomainGroups, function(x) {
          identical(x$domainPointIndex, seq_len(nrow(x))) &&
            length(unique(x$domainPrimitiveID)) == 1L
        }, logical(1))) ||
        nrow(StudyDemands) != ExpectedStudyCaseCount * InterfaceCount ||
        !identical(
          StudyDemands$demandOrder,
          seq_len(ExpectedStudyCaseCount * InterfaceCount)
        ) ||
        any(StudyDemands$selectionBasisID !=
          "reinforcement-domain-interface-envelope") ||
        !setequal(unique(StudyDemands$reinforcementCaseID), StudyCaseIDs) ||
        any(table(StudyDemands$reinforcementCaseID) != InterfaceCount) ||
        any(table(StudyDemands$interfaceID) != ExpectedStudyCaseCount) ||
        nrow(StudyLimitChecks) != 2L * ExpectedStudyCaseCount ||
        any(table(StudyLimitChecks$reinforcementCaseID) != 2L) ||
        !setequal(
          unique(StudyLimitChecks$checkID),
          c("one-way-shear", "radial-tension-without-radial-stirrups")
        )) {
      stop("The parametric P-M family is inconsistent for liningID: ",
        liningID, ".", call. = FALSE
      )
    }
    if (nrow(Products$section) != 1L ||
        nrow(Products$interaction) != InterfaceCount ||
        nrow(Products$resultants) == 0L ||
        nrow(Products$extrema) != 9L * InterfaceCount ||
        nrow(Products$scales) != 3L ||
        nrow(Products$controls) != 6L * InterfaceCount ||
        nrow(Products$checks) == 0L ||
        nrow(Products$summary) != InterfaceCount ||
        !all(Products$section$scenarioID == ScenarioID) ||
        !all(Products$interaction$scenarioID == ScenarioID) ||
        !all(Products$resultants$scenarioID == ScenarioID) ||
        !all(Products$extrema$scenarioID == ScenarioID) ||
        !all(Products$scales$scenarioID == ScenarioID) ||
        !all(Products$controls$scenarioID == ScenarioID) ||
        !all(Products$checks$scenarioID == Config$scenarioID) ||
        !all(Products$summary$scenarioID == Config$scenarioID)) {
      stop("Concrete products do not match liningID: ", liningID, ".", call. = FALSE)
    }
    SummaryOrder <- match(ExpectedCaseIDs, Products$summary$caseID)
    if (anyNA(SummaryOrder) || anyDuplicated(Products$summary$caseID) ||
        !identical(
          Products$summary$interfaceID[SummaryOrder],
          ExpectedInterfaceIDs
        )) {
      stop("Concrete summary does not match liningID: ", liningID, ".", call. = FALSE)
    }
    StrengthCases <- LiningConfig[["aci", exact = TRUE]][[
      "strengthCases",
      exact = TRUE
    ]]
    ExpectedStrengthCaseIDs <- StrengthCases[["caseID", exact = TRUE]]
    LocalCheckIDs <- if (
      LiningConfig[["concreteTypeID", exact = TRUE]] == "plain-concrete"
    ) {
      c("tension-face", "one-way-shear")
    } else {
      "axial-flexure"
    }
    CheckKeys <- paste(
      Products$checks$caseID,
      Products$checks$strengthCaseID,
      Products$checks$checkID,
      sep = "\r"
    )
    CalculatedLocalChecks <- Products$checks[
      Products$checks$checkID %in% LocalCheckIDs &
        Products$checks$calculationStatus == "calculated",
      ,
      drop = FALSE
    ]
    ExpectedLocalKeys <- as.vector(outer(
      paste(
        rep(ExpectedCaseIDs, each = length(ExpectedStrengthCaseIDs)),
        rep(ExpectedStrengthCaseIDs, times = length(ExpectedCaseIDs)),
        sep = "\r"
      ),
      LocalCheckIDs,
      paste,
      sep = "\r"
    ))
    ObservedLocalKeys <- paste(
      CalculatedLocalChecks$caseID,
      CalculatedLocalChecks$strengthCaseID,
      CalculatedLocalChecks$checkID,
      sep = "\r"
    )
    if (anyDuplicated(CheckKeys) ||
        any(Products$checks$concreteTypeID !=
          LiningConfig[["concreteTypeID", exact = TRUE]]) ||
        !setequal(unique(Products$checks$caseID), ExpectedCaseIDs) ||
        !setequal(
          unique(Products$checks$strengthCaseID),
          ExpectedStrengthCaseIDs
        ) ||
        !setequal(ObservedLocalKeys, ExpectedLocalKeys) ||
        !all(Products$controls$pass)) {
      stop("ACI products are incomplete for liningID: ", LiningID, ".", call. = FALSE)
    }
    if (LiningConfig[["concreteTypeID", exact = TRUE]] ==
        "reinforced-concrete") {
      ExpectedDemandCount <- InterfaceCount *
        length(ExpectedStrengthCaseIDs) *
        Config[["numerics", exact = TRUE]][["thetaPointCount", exact = TRUE]]
      if (nrow(Products$axialFlexureDomain) == 0L ||
          nrow(Products$axialFlexureDemands) != ExpectedDemandCount ||
          length(unique(Products$axialFlexureDomain$domainPrimitiveID)) != 1L ||
          !is.list(Products$reinforcementSweep)) {
        stop("P-M products are incomplete for liningID: ", LiningID, ".", call. = FALSE)
      }
    } else if (nrow(Products$axialFlexureDomain) != 0L ||
        nrow(Products$axialFlexureDemands) != 0L ||
        !is.list(Products$reinforcementSweep)) {
      stop("The plain-concrete canonical branch is inconsistent for liningID: ", LiningID, ".", call. = FALSE)
    }
    Products$liningConfig <- LiningConfig
    Products$strengthCases <- StrengthCases
    Products$calculatedLocalChecks <- CalculatedLocalChecks
    Products
  })
  names(ConcreteProducts) <- LiningIDs
  if (!all(ShotcreteControls$pass)) {
    stop("One or more shotcrete numerical controls failed.", call. = FALSE)
  }
  if (!all(Controls$pass)) {
    stop("One or more materialized numerical controls failed.", call. = FALSE)
  }

  PrescribedInterfaceLabels <- c(
    `full-traction` = "proyección tangencial completa",
    `normal-only` = "acción exclusivamente normal"
  )
  PrescribedInterfaceCodes <- c(
    `full-traction` = "α=1",
    `normal-only` = "α=0"
  )
  DesignInterfaceLabels <- c(
    `full-slip` = "interfaz con deslizamiento libre",
    `no-slip` = "interfaz sin deslizamiento"
  )
  if (any(!(
    Interaction$interfaceID %in% names(PrescribedInterfaceLabels)
  ))) {
    stop("The public interface mapping is incomplete.", call. = FALSE)
  }
  Interaction$interfaceLabel <- unname(
    PrescribedInterfaceLabels[Interaction$interfaceID]
  )
  Interaction$interfaceCode <- unname(
    PrescribedInterfaceCodes[Interaction$interfaceID]
  )

  findExtremum <- function(caseID, resultantID, statisticID) {
    Data <- Extrema[
      Extrema$caseID == caseID &
        Extrema$resultantID == resultantID &
        Extrema$statisticID == statisticID,
      ,
      drop = FALSE
    ]
    if (nrow(Data) != 1L) {
      stop("An expected interaction extremum is missing or duplicated.", call. = FALSE)
    }
    Data
  }
  CaseSummary <- vapply(seq_len(nrow(Interaction)), function(i) {
    CaseID <- Interaction$caseID[i]
    CaseInterfaceID <- unique(Extrema$interfaceID[Extrema$caseID == CaseID])
    if (length(CaseInterfaceID) != 1L ||
        !(CaseInterfaceID %in% names(DesignInterfaceLabels))) {
      stop("The design interface mapping is incomplete.", call. = FALSE)
    }
    NormalMinimum <- findExtremum(CaseID, "N", "minimum")$value
    NormalMaximum <- findExtremum(CaseID, "N", "maximum")$value
    MomentMinimum <- findExtremum(CaseID, "M", "minimum")$value
    MomentMaximum <- findExtremum(CaseID, "M", "maximum")$value
    ShearMaximum <- findExtremum(CaseID, "Q", "absolute-maximum")$value
    paste0(
      "Para ", tolower(DesignInterfaceLabels[[CaseInterfaceID]]),
      " se obtiene\n\n$$\n",
      formatCalculationFixed(NormalMinimum, 0L),
      "\\le N_\\theta\\le ",
      formatCalculationFixed(NormalMaximum, 0L),
      "\\ \\mathrm{kN/m},\\qquad\n",
      formatCalculationFixed(MomentMinimum, 0L),
      "\\le M_\\theta\\le ",
      formatCalculationFixed(MomentMaximum, 0L),
      "\\ \\mathrm{kN\\,m/m},\n$$\n\n",
      "con $|Q_\\theta|_{\\max}=",
      formatCalculationFixed(ShearMaximum, 0L),
      "$ kN/m."
    )
  }, character(1))
  Governing <- do.call(rbind, lapply(c("N", "M", "Q"), function(resultantID) {
    Data <- Extrema[
      Extrema$resultantID == resultantID &
        Extrema$statisticID == "absolute-maximum",
      ,
      drop = FALSE
    ]
    Row <- Data[which.max(Data$value), , drop = FALSE]
    Row$interfaceLabel <- unname(DesignInterfaceLabels[Row$interfaceID])
    Row
  }))
  rownames(Governing) <- NULL

  findAashtoCheck <- function(checkID) {
    Data <- AashtoChecks[AashtoChecks$checkID == checkID, , drop = FALSE]
    if (nrow(Data) != 1L) {
      stop("An expected AASHTO check is missing or duplicated.", call. = FALSE)
    }
    Data
  }
  WallChecks <- AashtoChecks[
    AashtoChecks$checkID %in% c("wall-yield", "wall-buckling"),
    ,
    drop = FALSE
  ]
  WallGoverning <- WallChecks[which.max(WallChecks$utilization), , drop = FALSE]
  WallCheckLabels <- c(
    `wall-yield` = "fluencia de la pared",
    `wall-buckling` = "pandeo de la pared"
  )
  WallGoverningLabel <- unname(WallCheckLabels[WallGoverning$checkID])
  if (is.na(WallGoverningLabel)) {
    stop("The governing AASHTO wall check is not recognized.", call. = FALSE)
  }
  FlexibilityCheck <- findAashtoCheck("flexibility")
  CoverCheck <- findAashtoCheck("minimum-cover")
  SeamCheck <- findAashtoCheck("seam")
  StatusLabels <- c(
    satisfied = "satisface",
    `not-satisfied` = "no satisface",
    incomplete = "queda incompleta"
  )
  WallLabel <- unname(StatusLabels[AashtoSummary$wallStatus])
  FlexibilityLabel <- unname(StatusLabels[FlexibilityCheck$checkStatus])
  CoverLabel <- unname(StatusLabels[CoverCheck$checkStatus])
  if (any(is.na(c(WallLabel, FlexibilityLabel, CoverLabel)))) {
    stop("An AASHTO result status is not recognized.", call. = FALSE)
  }
  AashtoResultMarkdown <- paste0(
    "La fuerza circunferencial de diseño es $T_u=",
    formatCalculationFixed(AashtoCalculation$designThrustKnPerM, 0L),
    "$ kN/m. Con las propiedades y los factores adoptados, la comparación ",
    "numérica de la pared ", WallLabel,
    "; gobierna la ", WallGoverningLabel, " con una utilización de ",
    formatCalculationFixed(WallGoverning$utilization, 4L),
    ". La condición de flexibilidad ", FlexibilityLabel,
    " con una utilización de ",
    formatCalculationFixed(FlexibilityCheck$utilization, 4L),
    ". La altura de relleno sobre la clave adoptada, de ",
    formatCalculationGeneral(AashtoInputs$coverCrownM),
    " m ", CoverLabel, " el límite geométrico de ",
    formatCalculationFixed(AashtoCalculation$minimumCoverM, 3L),
    " m."
  )
  if (SeamCheck$checkStatus == "not-evaluated") {
    AashtoResultMarkdown <- paste(
      AashtoResultMarkdown,
      paste(
        "La comprobación del sistema no se completa porque la resistencia",
        "documentada de la costura no forma parte de las entradas del caso."
      )
    )
  } else {
    SeamLabel <- unname(StatusLabels[SeamCheck$checkStatus])
    if (is.na(SeamLabel)) {
      stop("The AASHTO seam result status is not recognized.", call. = FALSE)
    }
    AashtoResultMarkdown <- paste(
      AashtoResultMarkdown,
      paste0(
        "La comparación con la costura doble remachada de referencia de ",
        "$R_{n,c}=",
        formatCalculationFixed(AashtoCalculation[[
          "corrodedSeamNominalResistanceKnPerM",
          exact = TRUE
        ]], 0L),
        "$ kN/m ", SeamLabel, " el límite, con una utilización de ",
        formatCalculationFixed(SeamCheck$utilization, 4L), "."
      ),
      paste0(
        "La pérdida relativa de diámetro adoptada es ",
        "$\\delta_d=",
        formatCalculationGeneral(AashtoInputs$fastenerDiameterLossRatio),
        "$; el umbral correspondiente a $U_s=1$ para las restantes entradas ",
        "es $\\delta_{d,lim}=",
        formatCalculationFixed(
          AashtoCalculation$criticalFastenerDiameterLossRatio,
          4L
        ),
        "$."
      ),
      paste(
        "La resistencia tabulada no demuestra la equivalencia resistente",
        "de la unión abulonada existente."
      )
    )
  }
  AashtoResultMarkdown <- paste(
    AashtoResultMarkdown,
    buildAashtoStatusSummary(AashtoChecks),
    "Las propiedades resistentes adoptadas del acero requieren confirmación."
  )
  if (AashtoSummary$specificationStatus != "verified-current-edition") {
    AashtoResultMarkdown <- paste(
      AashtoResultMarkdown,
      paste(
        "Las ecuaciones y factores corresponden a la base de referencia",
        "declarada; el resultado no constituye una comprobación de la edición",
        "AASHTO vigente."
      )
    )
  }

  buildConcreteResult <- function(liningID, products) {
    LiningConfig <- products$liningConfig
    SectionData <- products$section
    SummaryData <- products$summary
    SummaryData$interfaceLabel <- unname(
      DesignInterfaceLabels[SummaryData$interfaceID]
    )
    if (anyNA(SummaryData$interfaceLabel) ||
        any(!is.finite(SummaryData$shotcreteLocalStrengthUtilization)) ||
        any(!(SummaryData$shotcreteLocalStrengthStatus %in% c(
          "satisfied", "not-satisfied"
        )))) {
      stop(
        "Concrete public results are incomplete for: ", liningID, ".",
        call. = FALSE
      )
    }
    ConcreteTypeID <- LiningConfig[["concreteTypeID", exact = TRUE]]
    NormativeStatus <- unique(
      SummaryData[["shotcreteNormativeStatus", exact = TRUE]]
    )
    if (length(NormativeStatus) != 1L ||
        !(NormativeStatus %in% c(
          "satisfied", "not-satisfied", "not-evaluated"
        ))) {
      stop(
        "Concrete normative status is incomplete for: ", liningID, ".",
        call. = FALSE
      )
    }
    StatusLabels <- c(
      satisfied = "satisface",
      `not-satisfied` = "no satisface"
    )
    CaseMarkdown <- vapply(
      seq_len(nrow(SummaryData)),
      function(i) {
        SummaryRow <- SummaryData[i, , drop = FALSE]
        StatusLabel <- unname(StatusLabels[[
          SummaryRow$shotcreteLocalStrengthStatus
        ]])
        StrengthRow <- products$strengthCases[
          products$strengthCases$caseID ==
            SummaryRow$shotcreteGoverningStrengthCaseID,
          ,
          drop = FALSE
        ]
        if (length(StatusLabel) != 1L || is.na(StatusLabel) ||
            nrow(StrengthRow) != 1L) {
          stop("The concrete assessment is not recognized.", call. = FALSE)
        }
        paste0(
          "Para ", tolower(SummaryRow$interfaceLabel), " ", StatusLabel,
          " la resistencia local, con $U=",
          formatCalculationFixed(
            SummaryRow$shotcreteLocalStrengthUtilization,
            4L
          ),
          "$ para $f_v=",
          formatCalculationGeneral(StrengthRow$verticalStressFactor),
          "$ y $f_h=",
          formatCalculationGeneral(StrengthRow$horizontalStressFactor),
          "$."
        )
      },
      character(1)
    )
    TypeLabel <- if (ConcreteTypeID == "plain-concrete") {
      "hormigón proyectado simple"
    } else {
      "hormigón proyectado armado"
    }
    ScopeText <- if (ConcreteTypeID == "plain-concrete") {
      ReinforcementText <- paste(
        "La cuantía de armadura no interviene en estas comprobaciones",
        "de hormigón simple."
      )
      NormativeText <- switch(
        NormativeStatus,
        `not-evaluated` = paste(
          "La clasificación estructural requerida para establecer la",
          "aplicabilidad del Capítulo 14 no está caracterizada; por ello,",
          "las comprobaciones se informan como resultados locales",
          "condicionales y no constituyen una verificación normativa integral."
        ),
        `not-satisfied` = paste(
          "La evaluación normativa incluida en el alcance no satisface",
          "los requisitos comprobados."
        ),
        satisfied = paste(
          "Los controles normativos incluidos en el alcance resultan",
          "satisfechos."
        )
      )
      paste(ReinforcementText, NormativeText)
    } else {
      paste(
        "La comprobación corresponde exclusivamente al dominio local P--M",
        "y a las comprobaciones de cuantía presentadas en esta sección."
      )
    }
    NormativeStatusSummaryMarkdown <- switch(
      NormativeStatus,
      `not-evaluated` = paste(
        "La verificación normativa integral permanece no evaluada para el",
        "alcance no caracterizado."
      ),
      `not-satisfied` = paste(
        "Los controles normativos incluidos en el alcance no satisfacen",
        "todos sus requisitos."
      ),
      satisfied = paste(
        "Los controles normativos incluidos en el alcance satisfacen sus",
        "requisitos."
      )
    )
    LocalStatusSummaryMarkdown <- buildConcreteLocalStatusSummary(
      SummaryData,
      ConcreteTypeID
    )
    ResultMarkdown <- paste0(
      "La alternativa de ", TypeLabel, " tiene un espesor de ",
      formatCalculationFixed(1000 * SectionData$thicknessM, 0L),
      " mm y $f'_c=",
      formatCalculationGeneral(
        LiningConfig[["compressiveStrengthMPa", exact = TRUE]]
      ),
      "$ MPa. El análisis con rigidez bruta no fisurada produce ",
      "$|N_\\theta|_{\\max}=",
      formatCalculationFixed(max(SummaryData$normalAbsoluteMaxKnPerM), 0L),
      "$ kN/m, $|M_\\theta|_{\\max}=",
      formatCalculationFixed(max(SummaryData$momentAbsoluteMaxKnMPerM), 0L),
      "$ kN·m/m y $|Q_\\theta|_{\\max}=",
      formatCalculationFixed(max(SummaryData$shearAbsoluteMaxKnPerM), 0L),
      "$ kN/m. ", LocalStatusSummaryMarkdown, " ",
      paste(CaseMarkdown, collapse = " "), " ", ScopeText
    )
    list(
      section = as.list(SectionData[1L, , drop = FALSE]),
      concreteTypeID = ConcreteTypeID,
      stripWidthM = LiningConfig[["stripWidthM", exact = TRUE]],
      reinforcement = LiningConfig[["reinforcement", exact = TRUE]],
      orthogonalReinforcement = LiningConfig[[
        "orthogonalReinforcement",
        exact = TRUE
      ]],
      strengthCases = products$strengthCases,
      interaction = products$interaction,
      resultants = products$resultants,
      extrema = products$extrema,
      scales = products$scales,
      display = list(
        graphicAmplification = unique(products$scales$graphicAmplification),
        raysPerCircle = unique(products$scales$ordinateCount),
        radialFraction = unique(products$scales$radialFraction)
      ),
      controls = products$controls,
      checks = products$checks,
      calculatedLocalChecks = products$calculatedLocalChecks,
      summary = SummaryData,
      resultMarkdown = ResultMarkdown,
      localStatusSummaryMarkdown = LocalStatusSummaryMarkdown,
      minimumReinforcementStatusSummaryMarkdown = if (
        ConcreteTypeID == "reinforced-concrete"
      ) {
        buildMinimumReinforcementStatusSummary(SummaryData)
      } else {
        ""
      },
      normativeStatusSummaryMarkdown = NormativeStatusSummaryMarkdown,
      axialFlexureDomain = products$axialFlexureDomain,
      axialFlexureDemands = products$axialFlexureDemands,
      reinforcementSweep = products$reinforcementSweep
    )
  }
  ConcreteResults <- lapply(
    LiningIDs,
    function(liningID) {
      buildConcreteResult(liningID, ConcreteProducts[[liningID]])
    }
  )
  names(ConcreteResults) <- LiningIDs

  SectionList <- as.list(Section[1L, , drop = FALSE])
  SectionList$nominalProfile <- paste0(
    formatCalculationGeneral(Section$nominalPitchMm),
    "\\times",
    formatCalculationGeneral(Section$nominalDepthMm)
  )
  OUT <- list(
    scenarioID = Config$scenarioID,
    config = Config,
    paths = Paths,
    inputs = Inputs,
    geometry = list(
      centroidalDiameterM = 2 * Section$centroidalRadiusM,
      radiusM = Section$centroidalRadiusM
    ),
    section = SectionList,
    stress = Stress[1L, , drop = FALSE],
    interaction = Interaction,
    resultants = Resultants,
    extrema = Extrema,
    governing = Governing,
    numerics = list(
      maximumControlDifference = max(Controls$observedValue),
      controlTolerance = unique(Controls$limitValue),
      gridPoints = unique(Controls$thetaPointCount)
    ),
    display = list(
      graphicAmplification = unique(Scales$graphicAmplification),
      raysPerCircle = unique(Scales$ordinateCount),
      radialFraction = unique(Scales$radialFraction)
    ),
    controls = Controls,
    scales = Scales,
    aashto = list(
      inputs = AashtoInputs,
      thrust = AashtoThrust,
      calculation = AashtoCalculation,
      checks = AashtoChecks,
      summary = AashtoSummary,
      resultMarkdown = AashtoResultMarkdown,
      statusSummaryMarkdown = buildAashtoStatusSummary(AashtoChecks)
    ),
    classicalComparison = list(
      inputs = ClassicalComparisonInputs,
      sections = ClassicalComparisonSections,
      curves = ClassicalComparisonCurves,
      points = ClassicalComparisonPoints,
      summary = ClassicalComparisonSummary
    ),
    caseSummaryMarkdown = paste(CaseSummary, collapse = "\n\n")
  )
  for (LiningID in LiningIDs) {
    OUT[[LiningID]] <- ConcreteResults[[LiningID]]
  }
  OUT
}

CalculationDirectory <- if (exists("calculationDirectory", inherits = FALSE)) {
  calculationDirectory
} else {
  file.path(projectRoot, "data", "calculation")
}
Calculation <- loadCoverCalculationResults(projectRoot, CalculationDirectory)
