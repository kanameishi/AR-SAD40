# Compose cover-defined demand and structural checks for one lining option.
#
# Each scenario represents either corrugated steel or autonomous shotcrete.
# The two alternatives never reuse section resultants because their stiffness
# and centroidal radius differ. The composition applies no implicit action
# factor and does not manufacture missing AISI capacities.

.coverRequireNamedList <- function(value, name) {
  if (!is.list(value) || is.null(names(value))) {
    stop(name, " must be one named list.", call. = FALSE)
  }
  value
}

.coverRequireFields <- function(value, fields, name) {
  Missing <- setdiff(fields, names(value))
  if (length(Missing) > 0L) {
    stop(
      name, " is missing: ", paste(Missing, collapse = ", "), ".",
      call. = FALSE
    )
  }
  invisible(value)
}

.coverText <- function(value, name) {
  if (!is.character(value) || length(value) != 1L || !nzchar(value)) {
    stop(name, " must be one non-empty string.", call. = FALSE)
  }
  value
}

.coverFinite <- function(value, name, minimum = -Inf, strict = FALSE) {
  if (!is.numeric(value) || length(value) != 1L || !is.finite(value) ||
      value < minimum || (strict && value == minimum)) {
    stop(name, " is outside its permitted numerical domain.", call. = FALSE)
  }
  as.numeric(value)
}

.coverValidateScenario <- function(scenario) {
  Scenario <- .coverRequireNamedList(scenario, "scenario")
  .coverRequireFields(
    Scenario,
    c(
      "scenarioID", "cover", "ground", "interfaceID",
      "comparisonInterfaceID", "tangentialMultiplier", "action",
      "numerics", "lining"
    ),
    "scenario"
  )
  .coverText(Scenario$scenarioID, "scenario.scenarioID")
  Cover <- .coverRequireNamedList(Scenario$cover, "scenario.cover")
  Ground <- .coverRequireNamedList(Scenario$ground, "scenario.ground")
  Action <- .coverRequireNamedList(Scenario$action, "scenario.action")
  Numerics <- .coverRequireNamedList(Scenario$numerics, "scenario.numerics")
  Lining <- .coverRequireNamedList(Scenario$lining, "scenario.lining")
  .coverRequireFields(
    Cover,
    c(
      "coverCrownM", "crownToAxisM", "effectiveUnitWeightKnPerM3",
      "effectiveSurchargeKPa", "referencePositionID"
    ),
    "scenario.cover"
  )
  .coverRequireFields(
    Ground,
    c("modulusKPa", "poisson", "k0"),
    "scenario.ground"
  )
  .coverRequireFields(
    Action,
    c(
      "combinationID", "stageID", "forceEffectStatus",
      "loadCombinationBasisID", "waterPressureDifferenceKPa"
    ),
    "scenario.action"
  )
  .coverRequireFields(
    Numerics,
    c("integrationSteps", "balanceTolerance", "closedFormTolerance"),
    "scenario.numerics"
  )
  .coverRequireFields(
    Lining,
    c("liningTypeID", "sectionID", "centroidalRadiusM", "poisson"),
    "scenario.lining"
  )

  .coverFinite(Cover$coverCrownM, "cover.coverCrownM", 0)
  .coverFinite(Cover$crownToAxisM, "cover.crownToAxisM", 0, TRUE)
  .coverFinite(
    Cover$effectiveUnitWeightKnPerM3,
    "cover.effectiveUnitWeightKnPerM3",
    0,
    TRUE
  )
  .coverFinite(
    Cover$effectiveSurchargeKPa,
    "cover.effectiveSurchargeKPa",
    0
  )
  if (!(Cover$referencePositionID %in% c("crown", "axis", "invert"))) {
    stop(
      "cover.referencePositionID must be crown, axis or invert.",
      call. = FALSE
    )
  }
  .coverFinite(Ground$modulusKPa, "ground.modulusKPa", 0, TRUE)
  .coverFinite(Ground$poisson, "ground.poisson", -1, TRUE)
  if (Ground$poisson >= 0.5) {
    stop("ground.poisson must be less than 0.5.", call. = FALSE)
  }
  .coverRequireNamedList(Ground$k0, "ground.k0")
  if (!(Scenario$interfaceID %in% c("fullTraction", "normalOnly"))) {
    stop(
      "scenario.interfaceID must be fullTraction or normalOnly.",
      call. = FALSE
    )
  }
  if (!(Scenario$comparisonInterfaceID %in% c("fullSlip", "noSlip"))) {
    stop(
      "scenario.comparisonInterfaceID must be fullSlip or noSlip.",
      call. = FALSE
    )
  }
  .coverFinite(
    Scenario$tangentialMultiplier,
    "scenario.tangentialMultiplier",
    0
  )
  if (Scenario$tangentialMultiplier > 1) {
    stop("scenario.tangentialMultiplier must not exceed 1.", call. = FALSE)
  }
  for (Field in c(
    "combinationID", "stageID", "forceEffectStatus",
    "loadCombinationBasisID"
  )) {
    .coverText(Action[[Field]], paste0("action.", Field))
  }
  .coverFinite(
    Action$waterPressureDifferenceKPa,
    "action.waterPressureDifferenceKPa"
  )
  if (!(Action$forceEffectStatus %in% c(
    "asd-required", "lrfd-factored", "unfactored-reference-state"
  ))) {
    stop("action.forceEffectStatus is not recognized.", call. = FALSE)
  }
  .coverFinite(Numerics$integrationSteps, "numerics.integrationSteps", 128)
  if (Numerics$integrationSteps != as.integer(Numerics$integrationSteps)) {
    stop("numerics.integrationSteps must be an integer.", call. = FALSE)
  }
  .coverFinite(
    Numerics$balanceTolerance,
    "numerics.balanceTolerance",
    0,
    TRUE
  )
  .coverFinite(
    Numerics$closedFormTolerance,
    "numerics.closedFormTolerance",
    0,
    TRUE
  )
  .coverText(Lining$liningTypeID, "lining.liningTypeID")
  .coverText(Lining$sectionID, "lining.sectionID")
  .coverFinite(
    Lining$centroidalRadiusM,
    "lining.centroidalRadiusM",
    0,
    TRUE
  )
  .coverFinite(Lining$poisson, "lining.poisson", -1, TRUE)
  if (Lining$poisson >= 0.5) {
    stop("lining.poisson must be less than 0.5.", call. = FALSE)
  }
  if (!(Lining$liningTypeID %in% c("corrugated-steel", "shotcrete"))) {
    stop(
      "lining.liningTypeID must be corrugated-steel or shotcrete.",
      call. = FALSE
    )
  }
  Scenario
}

.buildAisiDemandFromInteraction <- function(
  values,
  scenarioID,
  sectionID
) {
  data.frame(
    scenarioID = scenarioID,
    sectionID = sectionID,
    combinationID = values$combinationID,
    stageID = values$stageID,
    thetaRad = values$thetaRad,
    thetaDeg = values$thetaDeg,
    normalForceKnPerM = values$normalForceKnPerM,
    bendingMomentKnMPerM = values$bendingMomentKnMPerM,
    shearForceKnPerM = values$shearForceKnPerM,
    forceEffectStatus = values$forceEffectStatus,
    longitudinalBasis = values$longitudinalBasis,
    resultantConcurrencyStatus = "satisfied",
    resultantConcurrencyEvidenceLocator =
      "same angular row from calculateExternalInteraction",
    localizedReactionStatus = "absent-demonstrated",
    localizedReactionValue = NA_real_,
    localizedReactionUnit = NA_character_,
    localizedReactionWidthBasisID = NA_character_,
    localizedReactionEvidenceLocator =
      "distributed free-field stress model without localized reaction",
    localizedMomentValue = NA_real_,
    localizedMomentUnit = NA_character_,
    localizedDemandEvidenceLocator = NA_character_,
    stringsAsFactors = FALSE
  )
}

.calculateSchwartzEinsteinDesignInteraction <- function(
  scenario,
  section,
  theta,
  effectiveVerticalStressKPa,
  effectiveHorizontalStressKPa,
  waterPressureDifferenceKPa,
  combinationID,
  forceEffectStatus
) {
  Rigidity <- section[["rigidity", exact = TRUE]]
  calculateExternalInteraction(
    theta = theta,
    effectiveVerticalStressKPa = effectiveVerticalStressKPa,
    effectiveHorizontalStressKPa = effectiveHorizontalStressKPa,
    waterPressureDifferenceKPa = waterPressureDifferenceKPa,
    stressReferenceID = scenario$cover$referencePositionID,
    radiusM = scenario$lining$centroidalRadiusM,
    groundModulusKPa = scenario$ground$modulusKPa,
    groundPoisson = scenario$ground$poisson,
    liningModulusKPa = Rigidity$youngModulus,
    liningPoisson = scenario$lining$poisson,
    liningAreaM2PerM = Rigidity$area,
    liningInertiaM4PerM = Rigidity$inertia,
    interface = scenario$comparisonInterfaceID,
    combinationID = combinationID,
    stageID = scenario$action$stageID,
    forceEffectStatus = forceEffectStatus
  )
}

.evaluateSteelCoverScenario <- function(
  scenario,
  sectionReference,
  section,
  interaction
) {
  Lining <- scenario$lining
  .coverRequireFields(
    Lining,
    c(
      "referenceProfileID", "referenceRowID", "remainingBaseThicknessMm",
      "youngModulusKPa", "yieldStrengthMPa"
    ),
    "scenario.lining"
  )
  if (!is.list(sectionReference) ||
      !identical(sectionReference$profileID, Lining$referenceProfileID) ||
      !identical(sectionReference$referenceRowID, Lining$referenceRowID)) {
    stop(
      "sectionReference does not match the steel lining identifiers.",
      call. = FALSE
    )
  }
  .coverFinite(
    Lining$remainingBaseThicknessMm,
    "lining.remainingBaseThicknessMm",
    0,
    TRUE
  )
  .coverFinite(Lining$youngModulusKPa, "lining.youngModulusKPa", 0, TRUE)
  .coverFinite(Lining$yieldStrengthMPa, "lining.yieldStrengthMPa", 0, TRUE)
  Section <- section
  Values <- interaction$values
  Aisi <- NULL
  AisiWallMemberUtilization <- NA_real_
  AisiWallMemberStatus <- "not-evaluated-capacities"
  AisiSystemStatus <- "not-evaluated-capacities"
  AisiInput <- Lining[["aisi", exact = TRUE]]
  if (!is.null(AisiInput)) {
    AisiInput <- .coverRequireNamedList(AisiInput, "lining.aisi")
    .coverRequireFields(
      AisiInput,
      c(
        "capacityBaseThicknessMm", "capacityYieldStrengthMPa",
        "capacityProfileID", "capacityReferenceRowID", "capacities",
        "applicability", "settings"
      ),
      "lining.aisi"
    )
    .coverFinite(
      AisiInput$capacityBaseThicknessMm,
      "lining.aisi.capacityBaseThicknessMm",
      0,
      TRUE
    )
    if (abs(
      AisiInput$capacityBaseThicknessMm -
        Lining$remainingBaseThicknessMm
    ) > 1e-9) {
      stop(
        paste(
          "The AISI capacity set and the lining use different base",
          "thicknesses."
        ),
        call. = FALSE
      )
    }
    .coverFinite(
      AisiInput$capacityYieldStrengthMPa,
      "lining.aisi.capacityYieldStrengthMPa",
      0,
      TRUE
    )
    if (abs(
      AisiInput$capacityYieldStrengthMPa - Lining$yieldStrengthMPa
    ) > 1e-9) {
      stop(
        paste(
          "The AISI capacity set and the lining use different yield",
          "strengths."
        ),
        call. = FALSE
      )
    }
    .coverText(
      AisiInput$capacityProfileID,
      "lining.aisi.capacityProfileID"
    )
    .coverText(
      AisiInput$capacityReferenceRowID,
      "lining.aisi.capacityReferenceRowID"
    )
    if (!identical(
      AisiInput$capacityProfileID,
      Lining$referenceProfileID
    ) || !identical(
      AisiInput$capacityReferenceRowID,
      Lining$referenceRowID
    )) {
      stop(
        "The AISI capacity set and the lining use different profiles.",
        call. = FALSE
      )
    }
    if (!identical(
      AisiInput$settings$loadCombinationBasisID,
      scenario$action$loadCombinationBasisID
    )) {
      stop(
        "AISI settings and the scenario use different combination bases.",
        call. = FALSE
      )
    }
    if (!identical(
      AisiInput$settings$demandBasisID,
      scenario$action$forceEffectStatus
    )) {
      stop(
        "AISI settings and the scenario use different demand bases.",
        call. = FALSE
      )
    }
    Capacities <- AisiInput$capacities
    if (!is.data.frame(Capacities)) {
      stop("lining.aisi.capacities must be one data frame.", call. = FALSE)
    }
    if (nrow(Capacities) > 0L &&
        !any(Capacities$sectionID == Lining$sectionID)) {
      stop(
        "No supplied AISI capacity matches lining.sectionID.",
        call. = FALSE
      )
    }
    Capacities <- Capacities[
      Capacities$sectionID == Lining$sectionID,
      ,
      drop = FALSE
    ]
    Demand <- .buildAisiDemandFromInteraction(
      values = Values,
      scenarioID = scenario$scenarioID,
      sectionID = Lining$sectionID
    )
    Aisi <- evaluateAisiS100Demand(
      demand = Demand,
      capacities = Capacities,
      applicability = AisiInput$applicability,
      settings = AisiInput$settings
    )
    Summary <- Aisi$summary[1L, , drop = FALSE]
    AisiSystemStatus <- Summary$systemVerdict[1L]
    Eligible <- isTRUE(Summary$complete[1L]) &&
      Summary$normativeVerdict[1L] %in% c("pass", "fail") &&
      is.finite(Summary$governingNormalizedCheckValue[1L])
    if (Eligible) {
      AisiWallMemberUtilization <-
        Summary$governingNormalizedCheckValue[1L]
      AisiWallMemberStatus <- Summary$normativeVerdict[1L]
    } else {
      AisiWallMemberStatus <- Summary$normativeVerdict[1L]
      if (is.na(AisiWallMemberStatus) || !nzchar(AisiWallMemberStatus)) {
        AisiWallMemberStatus <- "not-evaluated-incomplete"
      }
    }
  }
  list(
    section = Section,
    sectionSignature = paste(
      Lining$referenceProfileID,
      Lining$referenceRowID,
      format(Lining$remainingBaseThicknessMm, digits = 17),
      format(Lining$centroidalRadiusM, digits = 17),
      format(Lining$youngModulusKPa, digits = 17),
      format(Lining$poisson, digits = 17),
      format(Lining$yieldStrengthMPa, digits = 17),
      sep = "|"
    ),
    assessment = list(aisi = Aisi),
    summary = data.frame(
      scenarioID = scenario$scenarioID,
      sectionID = Lining$sectionID,
      coverCrownM = scenario$cover$coverCrownM,
      remainingBaseThicknessMm = Lining$remainingBaseThicknessMm,
      interfaceID = Values$interfaceID[1L],
      normalAbsoluteMaxKnPerM = max(abs(Values$normalForceKnPerM)),
      momentAbsoluteMaxKnMPerM = max(abs(Values$bendingMomentKnMPerM)),
      shearAbsoluteMaxKnPerM = max(abs(Values$shearForceKnPerM)),
      aisiWallMemberUtilization = AisiWallMemberUtilization,
      aisiWallMemberStatus = AisiWallMemberStatus,
      aisiSystemStatus = AisiSystemStatus,
      stringsAsFactors = FALSE
    )
  )
}

.evaluateShotcreteCoverScenario <- function(scenario, section, interaction) {
  Lining <- scenario$lining
  .coverRequireFields(
    Lining,
    c(
      "thicknessM", "youngModulusKPa", "stiffnessBasisID",
      "compressiveStrengthMPa", "stripWidthM", "reinforcement",
      "orthogonalReinforcement", "reinforcementGradeID",
      "orthogonalAreaMm2",
      "convergenceTolerance"
    ),
    "scenario.lining"
  )
  .coverFinite(Lining$thicknessM, "lining.thicknessM", 0, TRUE)
  .coverFinite(Lining$youngModulusKPa, "lining.youngModulusKPa", 0, TRUE)
  .coverFinite(
    Lining$compressiveStrengthMPa,
    "lining.compressiveStrengthMPa",
    0,
    TRUE
  )
  .coverFinite(Lining$stripWidthM, "lining.stripWidthM", 0, TRUE)
  .coverFinite(
    Lining$convergenceTolerance,
    "lining.convergenceTolerance",
    0,
    TRUE
  )
  .coverText(Lining$stiffnessBasisID, "lining.stiffnessBasisID")
  if (Lining$stiffnessBasisID != "gross-uncracked-short-term") {
    stop(
      paste(
        "lining.stiffnessBasisID must be",
        "gross-uncracked-short-term for this section helper."
      ),
      call. = FALSE
    )
  }
  Section <- section
  Reinforcement <- Lining$reinforcement
  if (!is.data.frame(Reinforcement)) {
    stop("lining.reinforcement must be one data frame.", call. = FALSE)
  }
  if (!("areaMm2" %in% names(Reinforcement)) ||
      !is.numeric(Reinforcement$areaMm2) ||
      any(!is.finite(Reinforcement$areaMm2)) ||
      any(Reinforcement$areaMm2 < 0)) {
    stop(
      "lining.reinforcement.areaMm2 must contain nonnegative values.",
      call. = FALSE
    )
  }
  OrthogonalReinforcement <- Lining$orthogonalReinforcement
  if (!is.data.frame(OrthogonalReinforcement) ||
      !("areaMm2" %in% names(OrthogonalReinforcement)) ||
      !is.numeric(OrthogonalReinforcement$areaMm2) ||
      any(!is.finite(OrthogonalReinforcement$areaMm2)) ||
      any(OrthogonalReinforcement$areaMm2 < 0)) {
    stop(
      paste(
        "lining.orthogonalReinforcement.areaMm2 must contain",
        "nonnegative values."
      ),
      call. = FALSE
    )
  }
  CircumferentialArea <- if (nrow(Reinforcement) == 0L) {
    0
  } else {
    sum(Reinforcement$areaMm2)
  }
  Minimum <- if (Lining$concreteTypeID == "reinforced-concrete") {
    checkAci318214SymmetricShellReinforcement(
      thicknessMm = 1000 * Lining$thicknessM,
      stripWidthMm = 1000 * Lining$stripWidthM,
      circumferentialReinforcement = Reinforcement,
      orthogonalReinforcement = OrthogonalReinforcement
    )
  } else {
    NULL
  }
  Values <- interaction$values
  Aci <- NULL
  if (!is.null(Lining$aci)) {
    AciConfig <- Lining$aci
    .coverRequireFields(
      AciConfig,
      c(
        "standardSetID", "structuralClassificationID",
        "plainConcretePermissionBasisID", "seismicDesignCategoryID",
        "jointingStatus", "openingStatus", "lambda",
        "castAgainstSoil", "compressionLengthMm", "strengthCases",
        "shellClassificationStatus", "longitudinalBoundaryConditionID"
      ),
      "lining.aci"
    )
    StrengthCases <- AciConfig$strengthCases
    if (!is.data.frame(StrengthCases) || nrow(StrengthCases) == 0L) {
      stop("lining.aci.strengthCases must be a non-empty table.", call. = FALSE)
    }
    Rigidity <- Section$rigidity
    GradientK0State <- do.call(estimateK0, scenario$ground$k0)
    AciEvaluations <- lapply(seq_len(nrow(StrengthCases)), function(i) {
      StrengthCase <- StrengthCases[i, , drop = FALSE]
      StrengthBaseline <- .calculateSchwartzEinsteinDesignInteraction(
        scenario = scenario,
        section = Section,
        theta = Values$thetaRad,
        effectiveVerticalStressKPa =
          Values$effectiveVerticalStressKPa[1L] *
          StrengthCase$verticalStressFactor,
        effectiveHorizontalStressKPa =
          Values$effectiveHorizontalStressKPa[1L] *
          StrengthCase$horizontalStressFactor,
        waterPressureDifferenceKPa =
          Values$waterPressureDifferenceKPa[1L] *
          StrengthCase$horizontalStressFactor,
        combinationID = StrengthCase$combinationID,
        forceEffectStatus = StrengthCase$forceEffectStatus
      )
      StrengthInteraction <- addBalancedGeostaticGradient(
        interaction = StrengthBaseline,
        radiusM = scenario$lining$centroidalRadiusM,
        verticalStressGradientKPaPerM =
          scenario$cover$effectiveUnitWeightKnPerM3 *
          StrengthCase$verticalStressFactor,
        horizontalStressGradientKPaPerM =
          scenario$cover$effectiveUnitWeightKnPerM3 *
          GradientK0State$k0Applied *
          StrengthCase$horizontalStressFactor
      )
      StrengthValues <- StrengthInteraction$values
      Evaluation <- evaluateAciShotcrete(
        normalForceKnPerM = StrengthValues$normalForceKnPerM,
        bendingMomentKnMPerM = StrengthValues$bendingMomentKnMPerM,
        shearForceKnPerM = StrengthValues$shearForceKnPerM,
        stripWidthM = Lining$stripWidthM,
        thetaRad = StrengthValues$thetaRad,
        thetaDeg = StrengthValues$thetaDeg,
        combinationID = StrengthValues$combinationID,
        stageID = StrengthValues$stageID,
        forceEffectStatus = StrengthValues$forceEffectStatus,
        interfaceID = StrengthValues$interfaceID,
        thicknessMm = 1000 * Lining$thicknessM,
        compressiveStrengthMPa = Lining$compressiveStrengthMPa,
        concreteTypeID = Lining$concreteTypeID,
        circumferentialAreaMm2 = CircumferentialArea,
        longitudinalAreaMm2 = Lining$orthogonalAreaMm2,
        reinforcementGradeID = Lining$reinforcementGradeID,
        standardSetID = AciConfig$standardSetID,
        shellClassificationStatus = AciConfig$shellClassificationStatus,
        longitudinalBoundaryConditionID =
          AciConfig$longitudinalBoundaryConditionID,
        castAgainstSoil = AciConfig$castAgainstSoil,
        lambda = AciConfig$lambda,
        compressionLengthMm = AciConfig$compressionLengthMm,
        structuralClassificationID =
          AciConfig$structuralClassificationID,
        plainConcretePermissionBasisID =
          AciConfig$plainConcretePermissionBasisID,
        seismicDesignCategoryID = AciConfig$seismicDesignCategoryID,
        jointingStatus = AciConfig$jointingStatus,
        openingStatus = AciConfig$openingStatus,
        circumferentialReinforcement = Reinforcement,
        orthogonalReinforcement = OrthogonalReinforcement,
        convergenceTolerance = Lining$convergenceTolerance,
        sectionDomains = attr(
          Lining,
          ".aci31825Domains",
          exact = TRUE
        )
      )
      GateMetadata <- data.frame(
        combinationID = StrengthCase$combinationID,
        stageID = scenario$action$stageID,
        forceEffectStatus = StrengthCase$forceEffectStatus,
        interfaceID = StrengthValues$interfaceID[1L],
        thetaRad = NA_real_,
        thetaDeg = NA_real_,
        normalForceKnPerM = NA_real_,
        bendingMomentKnMPerM = NA_real_,
        shearForceKnPerM = NA_real_,
        axialForceKn = NA_real_,
        bendingMomentKnM = NA_real_,
        shearDemandKn = NA_real_,
        stringsAsFactors = FALSE
      )
      GateChecks <- cbind(GateMetadata, Evaluation$gateChecks)
      GateChecks <- GateChecks[, names(Evaluation$checks), drop = FALSE]
      Checks <- rbind(Evaluation$checks, GateChecks)
      Checks$strengthCaseID <- StrengthCase$caseID
      Checks$verticalStressFactor <- StrengthCase$verticalStressFactor
      Checks$horizontalStressFactor <- StrengthCase$horizontalStressFactor
      Checks$loadCombinationBasisID <-
        StrengthCase$loadCombinationBasisID
      Checks$loadCombinationSourceLocator <- StrengthCase$sourceLocator
      Summary <- Evaluation$summary
      Summary$strengthCaseID <- StrengthCase$caseID
      Summary$combinationID <- StrengthCase$combinationID
      Summary$verticalStressFactor <- StrengthCase$verticalStressFactor
      Summary$horizontalStressFactor <- StrengthCase$horizontalStressFactor
      Summary$loadCombinationBasisID <-
        StrengthCase$loadCombinationBasisID
      list(
        actions = Evaluation$actions,
        rowChecks = Evaluation$rowChecks,
        checks = Checks,
        controls = Evaluation$controls,
        summary = Summary,
        interactionDiagram = Evaluation$interactionDiagram,
        interaction = StrengthInteraction
      )
    })
    AciChecks <- do.call(rbind, lapply(AciEvaluations, `[[`, "checks"))
    rownames(AciChecks) <- NULL
    AciSummary <- do.call(rbind, lapply(AciEvaluations, `[[`, "summary"))
    rownames(AciSummary) <- NULL
    AciActions <- do.call(rbind, lapply(seq_along(AciEvaluations), function(i) {
      OUT <- AciEvaluations[[i]]$actions
      OUT$strengthCaseID <- StrengthCases$caseID[i]
      OUT$verticalStressFactor <- StrengthCases$verticalStressFactor[i]
      OUT$horizontalStressFactor <- StrengthCases$horizontalStressFactor[i]
      OUT$loadCombinationBasisID <- StrengthCases$loadCombinationBasisID[i]
      OUT
    }))
    rownames(AciActions) <- NULL
    AciControls <- do.call(rbind, lapply(
      seq_along(AciEvaluations),
      function(i) {
        OUT <- AciEvaluations[[i]]$controls
        OUT$strengthCaseID <- StrengthCases$caseID[i]
        OUT$verticalStressFactor <- StrengthCases$verticalStressFactor[i]
        OUT$horizontalStressFactor <- StrengthCases$horizontalStressFactor[i]
        OUT$loadCombinationBasisID <- StrengthCases$loadCombinationBasisID[i]
        OUT
      }
    ))
    rownames(AciControls) <- NULL
    InteractionDiagrams <- lapply(
      AciEvaluations,
      function(evaluation) {
        evaluation[["interactionDiagram", exact = TRUE]]
      }
    )
    AciInteractionDiagram <- if (all(vapply(
      InteractionDiagrams,
      is.null,
      logical(1)
    ))) {
      NULL
    } else {
      if (any(vapply(InteractionDiagrams, is.null, logical(1)))) {
        stop(
          "The P-M interaction diagram is missing for one strength case.",
          call. = FALSE
        )
      }
      AciDomains <- lapply(
        InteractionDiagrams,
        function(diagram) {
          diagram[["domain", exact = TRUE]]
        }
      )
      if (!all(vapply(
        AciDomains[-1L],
        identical,
        logical(1),
        AciDomains[[1L]]
      ))) {
        stop(
          "ACI strength cases produced inconsistent P-M domains.",
          call. = FALSE
        )
      }
      AciDemands <- do.call(rbind, lapply(
        seq_along(InteractionDiagrams),
        function(i) {
          OUT <- InteractionDiagrams[[i]][["demands", exact = TRUE]]
          OUT[["strengthCaseID"]] <- StrengthCases$caseID[i]
          OUT[["verticalStressFactor"]] <-
            StrengthCases$verticalStressFactor[i]
          OUT[["horizontalStressFactor"]] <-
            StrengthCases$horizontalStressFactor[i]
          OUT[["loadCombinationBasisID"]] <-
            StrengthCases$loadCombinationBasisID[i]
          OUT
        }
      ))
      rownames(AciDemands) <- NULL
      list(
        domain = AciDomains[[1L]],
        demands = AciDemands
      )
    }
    Aci <- list(
      actions = AciActions,
      checks = AciChecks,
      controls = AciControls,
      summary = AciSummary,
      interactionDiagram = AciInteractionDiagram
    )
  }
  Mechanical <- NULL
  MechanicalUtilization <- NA_real_
  if ("sectionDomains" %in% names(Lining)) {
    stop(
      paste(
        "lining.sectionDomains is not an input; the shotcrete domains are",
        "constructed from the declared section and reinforcement primitives."
      ),
      call. = FALSE
    )
  }
  UsesLegacyDomain <- nrow(Reinforcement) > 0L &&
    (is.null(Lining$aci) || identical(
      Lining$aci$standardSetID,
      "aci-318.2-14-partial"
    ))
  SectionDomains <- attr(Lining, ".shotcreteDomains", exact = TRUE)
  SectionDomains <- if (!UsesLegacyDomain) {
    NULL
  } else if (is.null(SectionDomains)) {
    buildAciE702421ReinforcedSectionDomains(
      thicknessMm = 1000 * Lining$thicknessM,
      stripWidthMm = 1000 * Lining$stripWidthM,
      compressiveStrengthMPa = Lining$compressiveStrengthMPa,
      reinforcement = Reinforcement
    )
  } else {
    SectionDomains
  }
  MechanicalStatus <- if (!UsesLegacyDomain) {
    "not-applicable"
  } else {
    "not-evaluated"
  }
  if (UsesLegacyDomain) {
    Evaluation <- evaluateAciE702421SectionDemand(
      normalForceKnPerM = Values$normalForceKnPerM,
      bendingMomentKnMPerM = Values$bendingMomentKnMPerM,
      stripWidthM = Lining$stripWidthM,
      sectionDomains = SectionDomains,
      forceEffectStatus = scenario$action$forceEffectStatus,
      convergenceTolerance = Lining$convergenceTolerance
    )
    Mechanical <- cbind(
      data.frame(
        scenarioID = scenario$scenarioID,
        sectionID = Lining$sectionID,
        combinationID = Values$combinationID,
        stageID = Values$stageID,
        interfaceID = Values$interfaceID,
        thetaRad = Values$thetaRad,
        thetaDeg = Values$thetaDeg,
        shearForceKnPerM = Values$shearForceKnPerM,
        stringsAsFactors = FALSE
      ),
      Evaluation
    )
    MechanicalUtilization <- max(Mechanical$radialUtilization)
    MechanicalStatus <- if (any(
      Mechanical$convergenceStatus != "satisfied"
    )) {
      "not-evaluated-convergence"
    } else if (MechanicalUtilization <= 1) {
      "inside-supplied-domain"
    } else {
      "outside-supplied-domain"
    }
  }
  AciCalculated <- if (is.null(Aci)) {
    logical()
  } else {
    is.finite(Aci$summary$governingUtilization)
  }
  AciGoverningIndex <- if (any(AciCalculated)) {
    which(AciCalculated)[which.max(
      Aci$summary$governingUtilization[AciCalculated]
    )]
  } else {
    NA_integer_
  }
  AciNormativeStatus <- if (is.null(Aci)) {
    "not-evaluated-code-basis"
  } else if (any(Aci$summary$normativeStatus == "not-satisfied")) {
    "not-satisfied"
  } else if (any(Aci$summary$normativeStatus == "not-evaluated")) {
    "not-evaluated"
  } else {
    "satisfied"
  }
  AciLocalStrengthStatus <- if (is.null(Aci)) {
    "not-evaluated-code-basis"
  } else if (any(Aci$summary$localStrengthStatus == "not-satisfied")) {
    "not-satisfied"
  } else if (any(Aci$summary$localStrengthStatus == "not-evaluated")) {
    "not-evaluated"
  } else {
    "satisfied"
  }
  list(
    section = Section,
    sectionSignature = paste(
      "shotcrete",
      format(Lining$thicknessM, digits = 17),
      format(Lining$centroidalRadiusM, digits = 17),
      format(Lining$youngModulusKPa, digits = 17),
      format(Lining$poisson, digits = 17),
      format(Lining$compressiveStrengthMPa, digits = 17),
      format(Lining$stripWidthM, digits = 17),
      Lining$stiffnessBasisID,
      Lining$reinforcementGradeID,
      format(Lining$orthogonalAreaMm2, digits = 17),
      if (nrow(Reinforcement) == 0L) {
        "unreinforced"
      } else {
        .concreteReinforcementSignature(Reinforcement)
      },
      if (nrow(OrthogonalReinforcement) == 0L) {
        "orthogonal-unreinforced"
      } else {
        .concreteReinforcementSignature(OrthogonalReinforcement)
      },
      sep = "|"
    ),
    assessment = list(
      mechanical = Mechanical,
      minimumReinforcement = Minimum,
      aci = Aci
    ),
    summary = data.frame(
      scenarioID = scenario$scenarioID,
      sectionID = Lining$sectionID,
      concreteTypeID = Lining$concreteTypeID,
      coverCrownM = scenario$cover$coverCrownM,
      thicknessM = Lining$thicknessM,
      interfaceID = Values$interfaceID[1L],
      normalAbsoluteMaxKnPerM = max(abs(Values$normalForceKnPerM)),
      momentAbsoluteMaxKnMPerM = max(abs(Values$bendingMomentKnMPerM)),
      shearAbsoluteMaxKnPerM = max(abs(Values$shearForceKnPerM)),
      shotcreteMechanicalUtilization = MechanicalUtilization,
      shotcreteMechanicalStatus = MechanicalStatus,
      minimumReinforcementStatus = if (
        Lining$concreteTypeID == "plain-concrete"
      ) {
        "not-applicable"
      } else {
        Minimum$minimumReinforcementStatus
      },
      shotcreteLocalStrengthUtilization = if (is.null(Aci)) {
        NA_real_
      } else {
        Aci$summary$governingUtilization[AciGoverningIndex]
      },
      shotcreteNormativeStatus = AciNormativeStatus,
      shotcreteLocalStrengthStatus = AciLocalStrengthStatus,
      shotcreteGoverningStrengthCaseID = if (is.na(AciGoverningIndex)) {
        ""
      } else {
        Aci$summary$strengthCaseID[AciGoverningIndex]
      },
      shotcreteGoverningCheckID = if (is.na(AciGoverningIndex)) {
        ""
      } else {
        Aci$summary$governingCheckID[AciGoverningIndex]
      },
      stringsAsFactors = FALSE
    )
  )
}

evaluateCoverScenario <- function(
  scenario,
  theta,
  sectionReference = NULL
) {
  Scenario <- .coverValidateScenario(scenario)
  .assertTheta(theta)
  K0State <- do.call(estimateK0, Scenario$ground$k0)
  Stress <- calculateHomogeneousCoverStress(
    coverCrownM = Scenario$cover$coverCrownM,
    crownToAxisM = Scenario$cover$crownToAxisM,
    effectiveUnitWeightKnPerM3 =
      Scenario$cover$effectiveUnitWeightKnPerM3,
    effectiveSurchargeKPa = Scenario$cover$effectiveSurchargeKPa,
    referencePositionID = Scenario$cover$referencePositionID
  )
  VerticalStress <- Stress$effectiveVerticalStressKPa
  HorizontalStress <- K0State$k0Applied * VerticalStress

  if (Scenario$lining$liningTypeID == "corrugated-steel") {
    Lining <- Scenario$lining
    .coverRequireFields(
      Lining,
      c("youngModulusKPa", "remainingBaseThicknessMm"),
      "scenario.lining"
    )
    Section <- calculateCorrugatedRingSection(
      referenceSection = sectionReference,
      remainingBaseThicknessMm = Lining$remainingBaseThicknessMm,
      youngModulusKPa = Lining$youngModulusKPa,
      radiusM = Lining$centroidalRadiusM
    )
  } else {
    Lining <- Scenario$lining
    .coverRequireFields(
      Lining,
      c(
        "thicknessM", "youngModulusKPa", "stiffnessBasisID",
        "concreteTypeID"
      ),
      "scenario.lining"
    )
    if (!(Lining$concreteTypeID %in% c(
      "plain-concrete", "reinforced-concrete"
    ))) {
      stop("lining.concreteTypeID is not recognized.", call. = FALSE)
    }
    Section <- calculateConcreteRingSection(
      analysisThicknessM = Lining$thicknessM,
      analysisModulusKPa = Lining$youngModulusKPa,
      centroidalRadiusM = Lining$centroidalRadiusM,
      stiffnessBasisID = Lining$stiffnessBasisID
    )
  }
  Rigidity <- Section$rigidity
  PrescribedInteraction <- calculatePrescribedBiaxialInteraction(
    theta = theta,
    effectiveVerticalStressKPa = VerticalStress,
    effectiveHorizontalStressKPa = HorizontalStress,
    waterPressureDifferenceKPa =
      Scenario$action$waterPressureDifferenceKPa,
    stressReferenceID = Scenario$cover$referencePositionID,
    radiusM = Lining$centroidalRadiusM,
    sectionRatio = Rigidity$sectionRatio,
    tangentialMultiplier = Scenario$tangentialMultiplier,
    actionRepresentationID = Scenario$interfaceID,
    combinationID = Scenario$action$combinationID,
    stageID = Scenario$action$stageID,
    forceEffectStatus = Scenario$action$forceEffectStatus,
    integrationSteps = Scenario$numerics$integrationSteps,
    balanceTolerance = Scenario$numerics$balanceTolerance
  )
  SchwartzEinsteinInteraction <- .calculateSchwartzEinsteinDesignInteraction(
    scenario = Scenario,
    section = Section,
    theta = theta,
    effectiveVerticalStressKPa = VerticalStress,
    effectiveHorizontalStressKPa = HorizontalStress,
    waterPressureDifferenceKPa =
      Scenario$action$waterPressureDifferenceKPa,
    combinationID = Scenario$action$combinationID,
    forceEffectStatus = Scenario$action$forceEffectStatus
  )
  DesignInteraction <- addBalancedGeostaticGradient(
    interaction = SchwartzEinsteinInteraction,
    radiusM = Lining$centroidalRadiusM,
    verticalStressGradientKPaPerM =
      Scenario$cover$effectiveUnitWeightKnPerM3,
    horizontalStressGradientKPaPerM =
      Scenario$cover$effectiveUnitWeightKnPerM3 * K0State$k0Applied
  )
  Assessment <- if (Lining$liningTypeID == "corrugated-steel") {
    .evaluateSteelCoverScenario(
      scenario = Scenario,
      sectionReference = sectionReference,
      section = Section,
      interaction = DesignInteraction
    )
  } else {
    .evaluateShotcreteCoverScenario(
      scenario = Scenario,
      section = Section,
      interaction = DesignInteraction
    )
  }
  list(
    scenario = data.frame(
      scenarioID = Scenario$scenarioID,
      liningTypeID = Lining$liningTypeID,
      sectionID = Lining$sectionID,
      sectionSignature = Assessment$sectionSignature,
      coverCrownM = Scenario$cover$coverCrownM,
      crownToAxisM = Scenario$cover$crownToAxisM,
      centroidalRadiusM = Lining$centroidalRadiusM,
      interfaceID = Scenario$interfaceID,
      comparisonInterfaceID = Scenario$comparisonInterfaceID,
      designInteractionModelID =
        "schwartz-einstein-balanced-gradient-hybrid",
      tangentialMultiplier = Scenario$tangentialMultiplier,
      combinationID = Scenario$action$combinationID,
      stageID = Scenario$action$stageID,
      forceEffectStatus = Scenario$action$forceEffectStatus,
      loadCombinationBasisID =
        Scenario$action$loadCombinationBasisID,
      stringsAsFactors = FALSE
    ),
    k0State = K0State,
    freeFieldStress = data.frame(
      Stress,
      effectiveHorizontalStressKPa = HorizontalStress,
      k0 = K0State$k0Applied,
      stringsAsFactors = FALSE
    ),
    section = Assessment$section,
    interaction = PrescribedInteraction,
    prescribedInteraction = PrescribedInteraction,
    designInteraction = DesignInteraction,
    comparisonInteraction = SchwartzEinsteinInteraction,
    hybridGradient = DesignInteraction[["gradient", exact = TRUE]],
    extrema = summarizeExternalInteraction(DesignInteraction),
    prescribedExtrema = summarizePrescribedBiaxialInteraction(
      PrescribedInteraction
    ),
    assessment = Assessment$assessment,
    summary = Assessment$summary
  )
}

evaluateCoverScenarios <- function(
  scenarios,
  theta,
  sectionReference = NULL
) {
  if (!is.list(scenarios) || length(scenarios) == 0L) {
    stop("scenarios must be one non-empty list.", call. = FALSE)
  }
  ScenarioIDs <- vapply(scenarios, function(scenario) {
    if (!is.list(scenario) || is.null(scenario$scenarioID)) return(NA_character_)
    scenario$scenarioID
  }, character(1))
  if (any(is.na(ScenarioIDs)) || any(!nzchar(ScenarioIDs)) ||
      anyDuplicated(ScenarioIDs)) {
    stop("Every scenarioID must be present and unique.", call. = FALSE)
  }
  Results <- lapply(scenarios, function(scenario) {
    evaluateCoverScenario(
      scenario = scenario,
      theta = theta,
      sectionReference = sectionReference
    )
  })
  names(Results) <- ScenarioIDs
  Identity <- do.call(rbind, lapply(Results, `[[`, "scenario"))
  SignatureCount <- vapply(split(
    Identity$sectionSignature,
    Identity$sectionID
  ), function(x) length(unique(x)), integer(1))
  if (any(SignatureCount != 1L)) {
    stop(
      "One sectionID was reused for different section primitives.",
      call. = FALSE
    )
  }
  Steel <- Results[Identity$liningTypeID == "corrugated-steel"]
  Shotcrete <- Results[Identity$liningTypeID == "shotcrete"]
  list(
    scenarios = Results,
    steelSummary = if (length(Steel) == 0L) {
      data.frame()
    } else {
      do.call(rbind, lapply(Steel, `[[`, "summary"))
    },
    shotcreteSummary = if (length(Shotcrete) == 0L) {
      data.frame()
    } else {
      do.call(rbind, lapply(Shotcrete, `[[`, "summary"))
    }
  )
}
