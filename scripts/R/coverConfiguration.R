# Evaluate one cover configuration for report and Wolfram consumers.
#
# The function reads the declared corrugation row and writes no products. The
# AASHTO conduit controls remain separate from the angular interaction model.

if (any(!vapply(
  c(
    "validateCoverCalculationConfig", ".readCoverSectionReference",
    ".buildCoverScenario", ".buildCoverStressTable",
    ".buildCoverSectionTable", ".buildCoverInteractionTable",
    ".buildCoverResultants", ".buildCoverExtrema", ".buildCoverControls",
    "evaluateCoverScenario", "calculatePrismThrust",
    "evaluateAashto127CorrugatedConduit"
  ),
  function(s) exists(s, mode = "function", inherits = TRUE),
  logical(1)
))) {
  stop(
    paste(
      "Source scripts/setup/calculationFunctions.R dependencies before",
      "scripts/R/coverConfiguration.R."
    ),
    call. = FALSE
  )
}

.evaluateCoverAashto <- function(config, reference, steelResult) {
  ScenarioID <- config[["scenarioID", exact = TRUE]]
  Cover <- config[["cover", exact = TRUE]]
  Lining <- config[["lining", exact = TRUE]]
  Aashto <- config[["aashto", exact = TRUE]]
  Section <- .buildCoverSectionTable(config, reference, steelResult)
  Thrust <- calculatePrismThrust(
    unitWeightKnPerM3 = Aashto[["totalUnitWeightKnPerM3", exact = TRUE]],
    coverCrownM = Cover[["coverCrownM", exact = TRUE]],
    spanM = Aashto[["spanM", exact = TRUE]],
    deadLoadFactor = Aashto[["deadLoadFactor", exact = TRUE]],
    demandModifier = Aashto[["demandModifier", exact = TRUE]],
    factorBasis = Aashto[["factorBasisID", exact = TRUE]],
    combinationID = Aashto[["combinationID", exact = TRUE]],
    stageID = Aashto[["stageID", exact = TRUE]],
    forceEffectStatus = Aashto[["forceEffectStatus", exact = TRUE]],
    liveCrownPressureKPa = Aashto[[
      "liveCrownPressureKPa",
      exact = TRUE
    ]],
    liveLoadedWidthM = Aashto[["liveLoadedWidthM", exact = TRUE]],
    liveLoadFactor = Aashto[["liveLoadFactor", exact = TRUE]]
  )
  DemandValue <- Thrust$values$value[
    Thrust$values$quantityID == "modified-demand"
  ]
  if (length(DemandValue) != 1L || !is.finite(DemandValue)) {
    stop("The AASHTO thrust demand is not unique.", call. = FALSE)
  }

  Demand <- list(
    designThrustKnPerM = DemandValue,
    combinationID = Aashto[["combinationID", exact = TRUE]],
    stageID = Aashto[["stageID", exact = TRUE]],
    forceEffectStatus = Aashto[["forceEffectStatus", exact = TRUE]],
    demandBasisID = Aashto[["demandBasisID", exact = TRUE]],
    sourceKey = Aashto[["demandSourceKey", exact = TRUE]],
    sourceLocator = Aashto[["demandSourceLocator", exact = TRUE]]
  )
  SectionInput <- list(
    structuralProductID = Lining[["sectionID", exact = TRUE]],
    productTypeID = Aashto[["productTypeID", exact = TRUE]],
    shapeID = "round",
    spanM = Aashto[["spanM", exact = TRUE]],
    corrugationProfileID = Section[["profileID", exact = TRUE]],
    referenceRowID = Section[["referenceRowID", exact = TRUE]],
    specifiedThicknessMm = Section[["specifiedThicknessMm", exact = TRUE]],
    designBaseThicknessMm = Section[["designBaseThicknessMm", exact = TRUE]],
    remainingBaseThicknessMm = Section[[
      "remainingBaseThicknessMm",
      exact = TRUE
    ]],
    areaMm2PerMm = Section[["areaMm2PerMm", exact = TRUE]],
    inertiaMm4PerMm = Section[["inertiaMm4PerMm", exact = TRUE]],
    coverCrownM = Cover[["coverCrownM", exact = TRUE]],
    sourceKey = Section[["sourceKey", exact = TRUE]],
    sourceLocator = Section[["sourceLocator", exact = TRUE]]
  )
  Material <- list(
    materialID = Aashto[["materialID", exact = TRUE]],
    yieldStrengthMPa = Lining[["yieldStrengthMPa", exact = TRUE]],
    tensileStrengthMPa = Aashto[["tensileStrengthMPa", exact = TRUE]],
    elasticModulusMPa = Lining[["youngModulusKPa", exact = TRUE]] / 1000,
    sourceKey = Aashto[["materialSourceKey", exact = TRUE]],
    sourceLocator = Aashto[["materialSourceLocator", exact = TRUE]]
  )
  Specification <- list(
    standardID = Aashto[["standardID", exact = TRUE]],
    editionID = Aashto[["editionID", exact = TRUE]],
    errataID = Aashto[["errataID", exact = TRUE]],
    branchID = Aashto[["branchID", exact = TRUE]],
    productTypeID = Aashto[["productTypeID", exact = TRUE]],
    sourceBasisID = Aashto[["sourceBasisID", exact = TRUE]],
    specificationStatus = Aashto[["specificationStatus", exact = TRUE]],
    editionStatus = Aashto[["editionStatus", exact = TRUE]],
    errataStatus = Aashto[["errataStatus", exact = TRUE]],
    productApplicabilityStatus = Aashto[[
      "productApplicabilityStatus",
      exact = TRUE
    ]],
    wallResistanceFactor = Aashto[["wallResistanceFactor", exact = TRUE]],
    wallSourceKey = Aashto[["wallSourceKey", exact = TRUE]],
    wallSourceLocator = Aashto[["wallSourceLocator", exact = TRUE]],
    seamResistanceFactor = Aashto[["seamResistanceFactor", exact = TRUE]],
    seamFactorSourceKey = Aashto[["seamFactorSourceKey", exact = TRUE]],
    seamFactorSourceLocator = Aashto[[
      "seamFactorSourceLocator",
      exact = TRUE
    ]],
    soilStiffnessFactor = Aashto[["soilStiffnessFactor", exact = TRUE]],
    soilSourceKey = Aashto[["soilSourceKey", exact = TRUE]],
    soilSourceLocator = Aashto[["soilSourceLocator", exact = TRUE]],
    flexibilityLimitMmPerN = Aashto[[
      "flexibilityLimitMmPerN",
      exact = TRUE
    ]],
    flexibilitySourceKey = Aashto[["flexibilitySourceKey", exact = TRUE]],
    flexibilitySourceLocator = Aashto[[
      "flexibilitySourceLocator",
      exact = TRUE
    ]],
    minimumCoverSourceKey = Aashto[["minimumCoverSourceKey", exact = TRUE]],
    minimumCoverSourceLocator = Aashto[[
      "minimumCoverSourceLocator",
      exact = TRUE
    ]]
  )
  Evaluation <- evaluateAashto127CorrugatedConduit(
    demand = Demand,
    section = SectionInput,
    material = Material,
    specification = Specification,
    seam = Aashto[["seam", exact = TRUE]]
  )
  Seam <- Aashto[["seam", exact = TRUE]]

  Inputs <- data.frame(
    scenarioID = ScenarioID,
    standardID = Aashto[["standardID", exact = TRUE]],
    editionID = Aashto[["editionID", exact = TRUE]],
    errataID = Aashto[["errataID", exact = TRUE]],
    branchID = Aashto[["branchID", exact = TRUE]],
    productTypeID = Aashto[["productTypeID", exact = TRUE]],
    sourceBasisID = Aashto[["sourceBasisID", exact = TRUE]],
    specificationStatus = Aashto[["specificationStatus", exact = TRUE]],
    demandBasisID = Aashto[["demandBasisID", exact = TRUE]],
    factorBasisID = Aashto[["factorBasisID", exact = TRUE]],
    combinationID = Aashto[["combinationID", exact = TRUE]],
    stageID = Aashto[["stageID", exact = TRUE]],
    forceEffectStatus = Aashto[["forceEffectStatus", exact = TRUE]],
    coverCrownM = Cover[["coverCrownM", exact = TRUE]],
    totalUnitWeightKnPerM3 = Aashto[[
      "totalUnitWeightKnPerM3",
      exact = TRUE
    ]],
    spanM = Aashto[["spanM", exact = TRUE]],
    areaMm2PerMm = Section[["areaMm2PerMm", exact = TRUE]],
    inertiaMm4PerMm = Section[["inertiaMm4PerMm", exact = TRUE]],
    yieldStrengthMPa = Lining[["yieldStrengthMPa", exact = TRUE]],
    tensileStrengthMPa = Aashto[["tensileStrengthMPa", exact = TRUE]],
    elasticModulusMPa = Lining[["youngModulusKPa", exact = TRUE]] / 1000,
    deadLoadFactor = Aashto[["deadLoadFactor", exact = TRUE]],
    liveLoadFactor = Aashto[["liveLoadFactor", exact = TRUE]],
    demandModifier = Aashto[["demandModifier", exact = TRUE]],
    liveCrownPressureKPa = Aashto[[
      "liveCrownPressureKPa",
      exact = TRUE
    ]],
    liveLoadedWidthM = Aashto[["liveLoadedWidthM", exact = TRUE]],
    soilStiffnessFactor = Aashto[["soilStiffnessFactor", exact = TRUE]],
    wallResistanceFactor = Aashto[["wallResistanceFactor", exact = TRUE]],
    seamResistanceFactor = Aashto[["seamResistanceFactor", exact = TRUE]],
    seamID = if (is.null(Seam)) {
      NA_character_
    } else {
      Seam[["seamID", exact = TRUE]]
    },
    seamNominalResistanceKnPerM = if (is.null(Seam)) {
      NA_real_
    } else {
      Seam[["nominalResistanceKnPerM", exact = TRUE]]
    },
    fastenerDiameterMm = if (is.null(Seam)) {
      NA_real_
    } else {
      Seam[["fastenerDiameterMm", exact = TRUE]]
    },
    fastenerDiameterLossRatio = if (is.null(Seam)) {
      NA_real_
    } else {
      Seam[["fastenerDiameterLossRatio", exact = TRUE]]
    },
    flexibilityLimitMmPerN = Aashto[[
      "flexibilityLimitMmPerN",
      exact = TRUE
    ]],
    stringsAsFactors = FALSE
  )
  ThrustValues <- cbind(
    data.frame(
      scenarioID = ScenarioID,
      demandBasisID = Aashto[["demandBasisID", exact = TRUE]],
      stringsAsFactors = FALSE
    ),
    Thrust$values
  )
  Calculation <- cbind(
    data.frame(scenarioID = ScenarioID, stringsAsFactors = FALSE),
    Evaluation$calculation
  )
  Checks <- cbind(
    data.frame(
      scenarioID = ScenarioID,
      demandBasisID = Aashto[["demandBasisID", exact = TRUE]],
      stringsAsFactors = FALSE
    ),
    Evaluation$checks
  )
  Summary <- cbind(
    data.frame(
      scenarioID = ScenarioID,
      demandBasisID = Aashto[["demandBasisID", exact = TRUE]],
      stringsAsFactors = FALSE
    ),
    Evaluation$summary
  )
  list(
    inputs = Inputs,
    thrust = ThrustValues,
    calculation = Calculation,
    checks = Checks,
    summary = Summary
  )
}

.buildShotcreteSectionTable <- function(config, lining, result) {
  Section <- result[["section", exact = TRUE]]
  Rigidity <- Section[["rigidity", exact = TRUE]]
  data.frame(
    scenarioID = config[["scenarioID", exact = TRUE]],
    liningTypeID = lining[["liningTypeID", exact = TRUE]],
    sectionID = lining[["sectionID", exact = TRUE]],
    centroidalRadiusM = lining[["centroidalRadiusM", exact = TRUE]],
    thicknessM = Section[["analysisThicknessM", exact = TRUE]],
    youngModulusKPa = Section[["analysisModulusKPa", exact = TRUE]],
    poisson = lining[["poisson", exact = TRUE]],
    areaM2PerM = Section[["areaM2PerM", exact = TRUE]],
    inertiaM4PerM = Section[["inertiaM4PerM", exact = TRUE]],
    extensionalRigidityKnPerM = Rigidity[[
      "extensionalRigidity",
      exact = TRUE
    ]],
    flexuralRigidityKnM2PerM = Rigidity[[
      "flexuralRigidity",
      exact = TRUE
    ]],
    sectionRatio = Rigidity[["sectionRatio", exact = TRUE]],
    equivalentThicknessM = Rigidity[["equivalentThickness", exact = TRUE]],
    stiffnessBasisID = Section[["stiffnessBasisID", exact = TRUE]],
    stringsAsFactors = FALSE
  )
}

.normaliseShotcreteReinforcement <- function(reinforcement) {
  Fields <- c(
    "layerID", "areaMm2", "coordinateMm", "yieldStrengthMPa", "modulusMPa"
  )
  if (is.data.frame(reinforcement)) {
    return(reinforcement)
  }
  if (!is.list(reinforcement)) {
    stop(
      "reinforcement must be one data frame or one list of records.",
      call. = FALSE
    )
  }
  if (length(reinforcement) == 0L) {
    return(data.frame(
      layerID = character(),
      areaMm2 = numeric(),
      coordinateMm = numeric(),
      yieldStrengthMPa = numeric(),
      modulusMPa = numeric(),
      stringsAsFactors = FALSE
    ))
  }
  Rows <- lapply(seq_along(reinforcement), function(i) {
    Record <- reinforcement[[i]]
    if (!is.list(Record) || is.data.frame(Record)) {
      stop("Every reinforcement record must be one named list.", call. = FALSE)
    }
    Missing <- setdiff(Fields, names(Record))
    if (length(Missing) > 0L) {
      stop(
        paste0(
          "reinforcement record is missing: ",
          paste(Missing, collapse = ", "),
          "."
        ),
        call. = FALSE
      )
    }
    Values <- Record[Fields]
    if (any(vapply(Values, length, integer(1)) != 1L)) {
      stop("Every reinforcement field must be one scalar.", call. = FALSE)
    }
    data.frame(
      layerID = Values[["layerID", exact = TRUE]],
      areaMm2 = Values[["areaMm2", exact = TRUE]],
      coordinateMm = Values[["coordinateMm", exact = TRUE]],
      yieldStrengthMPa = Values[["yieldStrengthMPa", exact = TRUE]],
      modulusMPa = Values[["modulusMPa", exact = TRUE]],
      stringsAsFactors = FALSE
    )
  })
  OUT <- do.call(rbind, Rows)
  rownames(OUT) <- NULL
  OUT
}

.prepareCoverLinings <- function(linings, domainCache = list()) {
  if (!is.list(linings)) {
    stop("additionalLinings must be one list.", call. = FALSE)
  }
  if (length(linings) == 0L) return(list())
  LiningIDs <- names(linings)
  if (is.null(LiningIDs) || any(!nzchar(LiningIDs)) ||
      anyDuplicated(LiningIDs)) {
    stop(
      "additionalLinings must have unique non-empty names.",
      call. = FALSE
    )
  }
  if (!is.list(domainCache)) {
    stop("domainCache must be one named list.", call. = FALSE)
  }
  OUT <- lapply(seq_along(linings), function(i) {
    Lining <- linings[[i]]
    if (!is.list(Lining) ||
        !identical(Lining[["liningTypeID", exact = TRUE]], "shotcrete")) {
      stop(
        "Every additional lining must declare liningTypeID = shotcrete.",
        call. = FALSE
      )
    }
    Reinforcement <- .normaliseShotcreteReinforcement(
      Lining[["reinforcement", exact = TRUE]]
    )
    OrthogonalReinforcement <- .normaliseShotcreteReinforcement(
      if ("orthogonalReinforcement" %in% names(Lining)) {
        Lining[["orthogonalReinforcement", exact = TRUE]]
      } else {
        list()
      }
    )
    Lining[["reinforcement"]] <- Reinforcement
    Lining[["orthogonalReinforcement"]] <- OrthogonalReinforcement
    Aci <- Lining[["aci", exact = TRUE]]
    UsesLegacyDomain <- nrow(Reinforcement) > 0L &&
      (is.null(Aci) || identical(
        Aci[["standardSetID", exact = TRUE]],
        "aci-318.2-14-partial"
      ))
    if (UsesLegacyDomain) {
      attr(Lining, ".shotcreteDomains") <-
        buildAciE702421ReinforcedSectionDomains(
          thicknessMm = 1000 * Lining[["thicknessM", exact = TRUE]],
          stripWidthMm = 1000 * Lining[["stripWidthM", exact = TRUE]],
          compressiveStrengthMPa = Lining[[
            "compressiveStrengthMPa",
            exact = TRUE
          ]],
          reinforcement = Reinforcement
        )
    }
    UsesAci31825Domain <- nrow(Reinforcement) > 0L &&
      !is.null(Aci) && identical(
        Aci[["standardSetID", exact = TRUE]],
        "aci-318.2-14-aci-318-25-reinforced-flexure"
      )
    if (UsesAci31825Domain) {
      DomainInput <- .aci31825DomainInput(
        thicknessMm = 1000 * Lining[["thicknessM", exact = TRUE]],
        stripWidthMm = 1000 * Lining[["stripWidthM", exact = TRUE]],
        compressiveStrengthMPa = Lining[[
          "compressiveStrengthMPa",
          exact = TRUE
        ]],
        reinforcement = Reinforcement
      )
      Cached <- domainCache[[LiningIDs[i]]]
      ExistingInput <- attr(
        Lining,
        ".aci31825DomainInput",
        exact = TRUE
      )
      ExistingDomains <- attr(Lining, ".aci31825Domains", exact = TRUE)
      Domains <- if (
        is.list(Cached) &&
          identical(Cached[["domainInput", exact = TRUE]], DomainInput)
      ) {
        Cached[["domains", exact = TRUE]]
      } else if (
        identical(ExistingInput, DomainInput) && !is.null(ExistingDomains)
      ) {
        ExistingDomains
      } else {
        buildAci31825ReinforcedSectionDomains(
          thicknessMm = DomainInput[["thicknessMm", exact = TRUE]],
          stripWidthMm = DomainInput[["stripWidthMm", exact = TRUE]],
          compressiveStrengthMPa = DomainInput[[
            "compressiveStrengthMPa",
            exact = TRUE
          ]],
          reinforcement = DomainInput[["reinforcement", exact = TRUE]]
        )
      }
      if (!identical(Domains[["domainInput", exact = TRUE]], DomainInput)) {
        stop(
          "The prepared ACI domain does not match the lining primitives.",
          call. = FALSE
        )
      }
      attr(Lining, ".aci31825DomainInput") <- DomainInput
      attr(Lining, ".aci31825Domains") <- Domains
    }
    Lining
  })
  names(OUT) <- LiningIDs
  OUT
}

.evaluateAdditionalLinings <- function(config, linings, theta) {
  if (!is.list(linings)) {
    stop("additionalLinings must be one list.", call. = FALSE)
  }
  if (length(linings) == 0L) {
    return(list())
  }
  Linings <- .prepareCoverLinings(linings = linings)
  LiningIDs <- names(Linings)
  if (is.null(LiningIDs) || any(!nzchar(LiningIDs)) ||
      anyDuplicated(LiningIDs)) {
    stop(
      "additionalLinings must have unique non-empty names.",
      call. = FALSE
    )
  }
  Cases <- config[["interfaceCases", exact = TRUE]]
  OUT <- lapply(seq_along(Linings), function(i) {
    Lining <- Linings[[i]]
    Reinforcement <- Lining[["reinforcement", exact = TRUE]]
    ScenarioID <- paste(
      config[["scenarioID", exact = TRUE]],
      LiningIDs[i],
      sep = "--"
    )
    Config <- config
    Config[["scenarioID"]] <- ScenarioID
    Config[["lining"]] <- Lining
    Results <- lapply(seq_len(nrow(Cases)), function(j) {
      Case <- as.list(Cases[j, , drop = FALSE])
      Scenario <- list(
        scenarioID = paste(
          ScenarioID,
          Case[["caseID", exact = TRUE]],
          sep = "--"
        ),
        cover = config[["cover", exact = TRUE]],
        ground = config[["ground", exact = TRUE]],
        interfaceID = .coverInterfaceAPI(Case[["interfaceID", exact = TRUE]]),
        comparisonInterfaceID = .coverComparisonInterfaceAPI(
          Case[["comparisonInterfaceID", exact = TRUE]]
        ),
        tangentialMultiplier = Case[["tangentialMultiplier", exact = TRUE]],
        action = config[["action", exact = TRUE]],
        numerics = config[["numerics", exact = TRUE]],
        lining = Lining
      )
      evaluateCoverScenario(
        scenario = Scenario,
        theta = theta,
        sectionReference = NULL
      )
    })
    names(Results) <- Cases[["caseID", exact = TRUE]]
    Resultants <- .buildCoverResultants(Config, Results)
    Summary <- do.call(rbind, lapply(Results, `[[`, "summary"))
    Summary[["interfaceID"]] <- Cases[["interfaceID", exact = TRUE]]
    MechanicalChecks <- do.call(rbind, lapply(seq_along(Results), function(j) {
      Assessment <- Results[[j]][["assessment", exact = TRUE]]
      Mechanical <- Assessment[["mechanical", exact = TRUE]]
      if (is.data.frame(Mechanical) && nrow(Mechanical) > 0L) {
        Governing <- Mechanical[
          which.max(Mechanical[["radialUtilization", exact = TRUE]]),
          ,
          drop = FALSE
        ]
        ThetaRad <- Governing[["thetaRad", exact = TRUE]]
        ThetaDeg <- Governing[["thetaDeg", exact = TRUE]]
        MechanicalUtilization <- Governing[[
          "radialUtilization",
          exact = TRUE
        ]]
        ConvergenceStatus <- Governing[["convergenceStatus", exact = TRUE]]
        CodeBasisStatus <- Governing[["codeBasisStatus", exact = TRUE]]
        AxialLimitStatus <- Governing[["axialLimitStatus", exact = TRUE]]
        LocalStrengthUtilization <- Summary[[
          "shotcreteLocalStrengthUtilization",
          exact = TRUE
        ]][j]
        LocalStrengthStatus <- Summary[[
          "shotcreteLocalStrengthStatus",
          exact = TRUE
        ]][j]
        NormativeStatus <- Summary[[
          "shotcreteNormativeStatus",
          exact = TRUE
        ]][j]
      } else {
        ThetaRad <- NA_real_
        ThetaDeg <- NA_real_
        MechanicalUtilization <- NA_real_
        ConvergenceStatus <- "not-applicable"
        CodeBasisStatus <- "not-applicable"
        AxialLimitStatus <- "not-applicable"
        LocalStrengthUtilization <- NA_real_
        LocalStrengthStatus <- "not-applicable"
        NormativeStatus <- "not-applicable"
      }
      data.frame(
        scenarioID = ScenarioID,
        caseID = Cases[["caseID", exact = TRUE]][j],
        sectionID = Lining[["sectionID", exact = TRUE]],
        concreteTypeID = Lining[["concreteTypeID", exact = TRUE]],
        interfaceID = Cases[["interfaceID", exact = TRUE]][j],
        thetaRad = ThetaRad,
        thetaDeg = ThetaDeg,
        mechanicalUtilization = MechanicalUtilization,
        mechanicalStatus = Summary[[
          "shotcreteMechanicalStatus",
          exact = TRUE
        ]][j],
        convergenceStatus = ConvergenceStatus,
        codeBasisStatus = CodeBasisStatus,
        axialLimitStatus = AxialLimitStatus,
        localStrengthUtilization = LocalStrengthUtilization,
        localStrengthStatus = LocalStrengthStatus,
        normativeStatus = NormativeStatus,
        stringsAsFactors = FALSE
      )
    }))
    AciResults <- lapply(Results, function(result) {
      result[["assessment", exact = TRUE]][["aci", exact = TRUE]]
    })
    Aci <- if (all(vapply(AciResults, is.null, logical(1)))) {
      NULL
    } else {
      if (any(vapply(AciResults, is.null, logical(1)))) {
        stop("ACI assessment is missing for one interface case.", call. = FALSE)
      }
      bindAci <- function(name) {
        Rows <- lapply(seq_along(AciResults), function(j) {
          Data <- AciResults[[j]][[name, exact = TRUE]]
          if (!is.data.frame(Data)) {
            stop("ACI assessment is not tabular: ", name, ".", call. = FALSE)
          }
          Data$caseID <- Cases[["caseID", exact = TRUE]][j]
          Data$interfaceID <- Cases[["interfaceID", exact = TRUE]][j]
          Data
        })
        OUT <- do.call(rbind, Rows)
        rownames(OUT) <- NULL
        OUT
      }
      InteractionDiagrams <- lapply(AciResults, function(result) {
        result[["interactionDiagram", exact = TRUE]]
      })
      InteractionDiagram <- if (all(vapply(
        InteractionDiagrams,
        is.null,
        logical(1)
      ))) {
        NULL
      } else {
        if (any(vapply(InteractionDiagrams, is.null, logical(1)))) {
          stop(
            "The P-M interaction diagram is missing for one interface case.",
            call. = FALSE
          )
        }
        Domains <- lapply(InteractionDiagrams, function(diagram) {
          diagram[["domain", exact = TRUE]]
        })
        if (!all(vapply(
          Domains[-1L],
          identical,
          logical(1),
          Domains[[1L]]
        ))) {
          stop(
            "Interface cases produced inconsistent P-M domains.",
            call. = FALSE
          )
        }
        DiagramDemands <- lapply(seq_along(InteractionDiagrams), function(j) {
          Data <- InteractionDiagrams[[j]][["demands", exact = TRUE]]
          InterfaceID <- Cases[["interfaceID", exact = TRUE]][j]
          InternalInterfaceID <- .coverInterfaceAPI(InterfaceID)
          if (!all(
            Data[["interfaceID", exact = TRUE]] == InternalInterfaceID
          )) {
            stop(
              "The P-M demand interface identity is inconsistent.",
              call. = FALSE
            )
          }
          Data[["interfaceID"]] <- InterfaceID
          Data[["caseID"]] <- Cases[["caseID", exact = TRUE]][j]
          Data
        })
        DiagramDemands <- do.call(rbind, DiagramDemands)
        rownames(DiagramDemands) <- NULL
        list(
          domain = Domains[[1L]],
          demands = DiagramDemands
        )
      }
      list(
        actions = bindAci("actions"),
        checks = bindAci("checks"),
        controls = bindAci("controls"),
        summary = bindAci("summary"),
        interactionDiagram = InteractionDiagram
      )
    }
    list(
      stress = .buildCoverStressTable(Config, Results[[1L]]),
      section = .buildShotcreteSectionTable(Config, Lining, Results[[1L]]),
      interaction = .buildCoverInteractionTable(Config, Results),
      schwartzEinsteinComparison =
        .buildCoverSchwartzEinsteinComparisonTable(Config, Results),
      resultants = Resultants,
      extrema = .buildCoverExtrema(Config, Results),
      controls = .buildCoverControls(Config, Results),
      assessment = list(
        mechanical = MechanicalChecks,
        minimumReinforcement = Results[[1L]][[
          "assessment",
          exact = TRUE
        ]][["minimumReinforcement", exact = TRUE]],
        aci = Aci
      ),
      summary = Summary
    )
  })
  names(OUT) <- LiningIDs
  OUT
}

.evaluateValidatedCoverConfiguration <- function(
  config,
  projectRoot = NULL,
  additionalLinings = NULL,
  reference = NULL,
  theta = NULL
) {
  Config <- config
  if (Config[["schemaVersion", exact = TRUE]] != "3.1.0") {
    stop(
      "evaluateCoverConfiguration requires schemaVersion 3.1.0.",
      call. = FALSE
    )
  }
  Reference <- if (is.null(reference)) {
    if (!is.character(projectRoot) || length(projectRoot) != 1L ||
        is.na(projectRoot) || !nzchar(projectRoot)) {
      stop(
        "projectRoot is required when reference is not prepared.",
        call. = FALSE
      )
    }
    ProjectRoot <- normalizePath(projectRoot, mustWork = TRUE)
    .readCoverSectionReference(Config, ProjectRoot)
  } else {
    reference
  }
  Numerics <- Config[["numerics", exact = TRUE]]
  Theta <- if (is.null(theta)) {
    buildThetaMesh(
      pointCount = Numerics[["thetaPointCount", exact = TRUE]],
      criticalAnglesDeg = Numerics[["criticalAnglesDeg", exact = TRUE]]
    )
  } else {
    if (!is.numeric(theta) || length(theta) == 0L || any(!is.finite(theta))) {
      stop("theta must be one finite numeric mesh.", call. = FALSE)
    }
    theta
  }
  Cases <- Config[["interfaceCases", exact = TRUE]]
  Results <- lapply(seq_len(nrow(Cases)), function(i) {
    Case <- as.list(Cases[i, , drop = FALSE])
    evaluateCoverScenario(
      scenario = .buildCoverScenario(Config, Case, aisiInput = NULL),
      theta = Theta,
      sectionReference = Reference
    )
  })
  names(Results) <- Cases[["caseID", exact = TRUE]]

  Signatures <- vapply(
    Results,
    function(x) x[["scenario", exact = TRUE]][[
      "sectionSignature",
      exact = TRUE
    ]],
    character(1)
  )
  if (length(unique(Signatures)) != 1L) {
    stop("Interface cases produced inconsistent lining sections.", call. = FALSE)
  }
  Stresses <- lapply(Results, `[[`, "freeFieldStress")
  if (!all(vapply(
    Stresses[-1L],
    identical,
    logical(1),
    Stresses[[1L]]
  ))) {
    stop(
      "Interface cases produced inconsistent free-field stresses.",
      call. = FALSE
    )
  }

  Resultants <- .buildCoverResultants(Config, Results)
  Linings <- if (is.null(additionalLinings)) {
    Config[["additionalLinings", exact = TRUE]]
  } else {
    additionalLinings
  }
  list(
    schemaVersion = Config[["schemaVersion", exact = TRUE]],
    scenarioID = Config[["scenarioID", exact = TRUE]],
    config = Config,
    theta = data.frame(
      thetaIndex = seq_along(Theta) - 1L,
      thetaRad = Theta,
      thetaDeg = Theta * 180 / pi,
      stringsAsFactors = FALSE
    ),
    stress = .buildCoverStressTable(Config, Results[[1L]]),
    section = .buildCoverSectionTable(Config, Reference, Results[[1L]]),
    interaction = .buildCoverInteractionTable(Config, Results),
    schwartzEinsteinComparison =
      .buildCoverSchwartzEinsteinComparisonTable(Config, Results),
    resultants = Resultants,
    extrema = .buildCoverExtrema(Config, Results),
    controls = .buildCoverControls(Config, Results),
    aashto = .evaluateCoverAashto(Config, Reference, Results[[1L]]),
    additionalLinings = .evaluateAdditionalLinings(
      config = Config,
      linings = Linings,
      theta = Theta
    )
  )
}

evaluateCoverConfiguration <- function(
  config,
  projectRoot,
  additionalLinings = NULL
) {
  if (!is.list(config) || is.null(names(config))) {
    stop("config must be one named list.", call. = FALSE)
  }
  Config <- validateCoverCalculationConfig(config)
  .evaluateValidatedCoverConfiguration(
    config = Config,
    projectRoot = projectRoot,
    additionalLinings = additionalLinings
  )
}
