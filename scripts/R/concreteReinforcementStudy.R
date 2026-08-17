# Discrete ACI 318-25 P-M family for symmetric circumferential reinforcement.
#
# The study reuses the configured factored sectional demands and changes only
# the area of the two circumferential layers. It is a sensitivity plot, not an
# optimizer and not a catalogue of constructible reinforcement layouts.

.reinforcementStudyScalar <- function(value, name, minimum = -Inf) {
  if (!is.numeric(value) || length(value) != 1L || !is.finite(value) ||
      value < minimum) {
    stop(name, " must be one finite number >= ", minimum, ".", call. = FALSE)
  }
  as.numeric(value)
}

.reinforcementStudyInteger <- function(value, name, minimum = 1L) {
  Value <- .reinforcementStudyScalar(value, name, minimum)
  if (Value != as.integer(Value)) {
    stop(name, " must be one integer.", call. = FALSE)
  }
  as.integer(Value)
}

normaliseAci31825ReinforcementStudyPolicy <- function(
  value,
  path = "reinforcementStudy"
) {
  if (!is.list(value) || is.null(names(value))) {
    stop(path, " must be one named object.", call. = FALSE)
  }
  Required <- c(
    "studyID", "reinforcementRatioGrid", "domainBasePointCount",
    "domainRefinedPointCount", "convergenceTolerance"
  )
  Missing <- setdiff(Required, names(value))
  Unexpected <- setdiff(names(value), Required)
  if (length(Missing) > 0L || length(Unexpected) > 0L) {
    Detail <- c(
      if (length(Missing) > 0L) {
        paste("missing", paste(Missing, collapse = ", "))
      },
      if (length(Unexpected) > 0L) {
        paste("unsupported", paste(Unexpected, collapse = ", "))
      }
    )
    stop(path, " has invalid fields: ", paste(Detail, collapse = "; "), ".",
      call. = FALSE
    )
  }
  StudyID <- value[["studyID", exact = TRUE]]
  if (!is.character(StudyID) || length(StudyID) != 1L ||
      is.na(StudyID) || !nzchar(StudyID)) {
    stop(path, ".studyID must be one non-empty string.", call. = FALSE)
  }
  Grid <- unlist(
    value[["reinforcementRatioGrid", exact = TRUE]],
    recursive = TRUE,
    use.names = FALSE
  )
  if (!is.numeric(Grid) || length(Grid) < 2L || any(!is.finite(Grid)) ||
      any(Grid <= 0) || is.unsorted(Grid, strictly = TRUE)) {
    stop(
      path,
      ".reinforcementRatioGrid must be a strictly increasing numeric array.",
      call. = FALSE
    )
  }
  BaseCount <- .reinforcementStudyInteger(
    value[["domainBasePointCount", exact = TRUE]],
    paste0(path, ".domainBasePointCount"),
    minimum = 101L
  )
  RefinedCount <- .reinforcementStudyInteger(
    value[["domainRefinedPointCount", exact = TRUE]],
    paste0(path, ".domainRefinedPointCount"),
    minimum = 102L
  )
  if (RefinedCount <= BaseCount) {
    stop(path, ".domainRefinedPointCount must exceed the base count.",
      call. = FALSE
    )
  }
  list(
    studyID = StudyID,
    reinforcementRatioGrid = as.numeric(Grid),
    domainBasePointCount = BaseCount,
    domainRefinedPointCount = RefinedCount,
    convergenceTolerance = .reinforcementStudyScalar(
      value[["convergenceTolerance", exact = TRUE]],
      paste0(path, ".convergenceTolerance"),
      minimum = .Machine$double.eps
    )
  )
}

.reinforcementStudyCaseID <- function(areaTotalMm2PerM) {
  Token <- formatC(
    areaTotalMm2PerM,
    format = "f",
    digits = 6L,
    drop0trailing = TRUE
  )
  Token <- sub("^-", "m", Token)
  Token <- gsub("\\.", "p", Token)
  paste0("circumferential-as-total-", Token)
}

.reinforcementStudyDomain <- function(domains, stripWidthM) {
  Domain <- domains[["refined", exact = TRUE]]
  Width <- .reinforcementStudyScalar(
    stripWidthM,
    "stripWidthM",
    minimum = .Machine$double.eps
  )
  data.frame(
    domainPointIndex = seq_len(nrow(Domain)),
    axialStrengthKnPerM = Domain$axialStrengthN / 1000 / Width,
    bendingStrengthKnMPerM =
      Domain$bendingStrengthNmm / 1e6 / Width,
    domainPrimitiveID = Domain$domainPrimitiveID,
    provisionID = Domain$provisionID,
    designBasisID = Domain$designBasisID,
    strengthReductionRuleID = Domain$strengthReductionRuleID,
    sourceLocator = Domain$sourceLocator,
    stringsAsFactors = FALSE
  )
}

.reinforcementStudyGoverningRow <- function(demands) {
  Required <- c(
    "radialUtilization", "caseID", "strengthCaseID", "thetaIndex"
  )
  if (!is.data.frame(demands) || nrow(demands) == 0L ||
      any(!Required %in% names(demands)) ||
      any(!is.finite(demands$radialUtilization))) {
    stop("The reinforcement-study demands are incomplete.", call. = FALSE)
  }
  Index <- order(
    -demands$radialUtilization,
    demands$caseID,
    demands$strengthCaseID,
    demands$thetaIndex
  )[1L]
  demands[Index, , drop = FALSE]
}

.reinforcementStudyConfiguredDemands <- function(
  demands,
  scenarioID,
  liningID,
  sectionID,
  studyID,
  reinforcementCaseID,
  interfaceCaseIDs,
  strengthCaseIDs
) {
  Expected <- expand.grid(
    caseID = interfaceCaseIDs,
    strengthCaseID = strengthCaseIDs,
    stringsAsFactors = FALSE
  )
  Rows <- lapply(seq_len(nrow(Expected)), function(i) {
    Data <- demands[
      demands$caseID == Expected$caseID[i] &
        demands$strengthCaseID == Expected$strengthCaseID[i],
      ,
      drop = FALSE
    ]
    if (nrow(Data) == 0L) {
      stop("The configured P-M demand groups are incomplete.", call. = FALSE)
    }
    Data[order(-Data$radialUtilization, Data$thetaIndex)[1L], , drop = FALSE]
  })
  OUT <- do.call(rbind, Rows)
  rownames(OUT) <- NULL
  OUT <- OUT[order(
    match(OUT$caseID, interfaceCaseIDs),
    match(OUT$strengthCaseID, strengthCaseIDs)
  ), , drop = FALSE]
  Required <- c(
    "caseID", "interfaceID", "strengthCaseID", "combinationID",
    "verticalStressFactor", "horizontalStressFactor", "stageID",
    "forceEffectStatus", "loadCombinationBasisID", "thetaIndex",
    "thetaRad", "thetaDeg", "axialDemandKnPerM",
    "bendingDemandKnMPerM", "radialUtilization", "domainPositionID",
    "convergenceStatus", "checkStatus"
  )
  if (nrow(OUT) != length(interfaceCaseIDs) * length(strengthCaseIDs) ||
      any(!Required %in% names(OUT))) {
    stop("The configured P-M demand schema is incomplete.", call. = FALSE)
  }
  cbind(
    data.frame(
      scenarioID = scenarioID,
      liningID = liningID,
      sectionID = sectionID,
      concreteTypeID = "reinforced-concrete",
      studyID = studyID,
      reinforcementCaseID = reinforcementCaseID,
      demandOrder = seq_len(nrow(OUT)),
      stringsAsFactors = FALSE
    ),
    OUT[, Required, drop = FALSE]
  )
}

evaluateAci31825SymmetricCircumferentialStudy <- function(
  scenarioID,
  liningID,
  sectionID,
  thicknessMm,
  stripWidthM,
  compressiveStrengthMPa,
  baselineCircumferentialReinforcement,
  orthogonalReinforcement,
  interactionDiagram,
  interfaceCaseIDs,
  strengthCaseIDs,
  policy
) {
  Policy <- normaliseAci31825ReinforcementStudyPolicy(policy)
  Thickness <- .reinforcementStudyScalar(
    thicknessMm,
    "thicknessMm",
    minimum = .Machine$double.eps
  )
  WidthM <- .reinforcementStudyScalar(
    stripWidthM,
    "stripWidthM",
    minimum = .Machine$double.eps
  )
  ConcreteStrength <- .reinforcementStudyScalar(
    compressiveStrengthMPa,
    "compressiveStrengthMPa",
    minimum = .Machine$double.eps
  )
  Reinforcement <- .validateConcreteReinforcement(
    baselineCircumferentialReinforcement,
    Thickness
  )
  Orthogonal <- .validateConcreteReinforcement(
    orthogonalReinforcement,
    Thickness
  )
  if (nrow(Reinforcement) != 2L ||
      sum(Reinforcement$coordinateMm < 0) != 1L ||
      sum(Reinforcement$coordinateMm > 0) != 1L ||
      abs(sum(Reinforcement$coordinateMm)) > 1e-10 ||
      diff(range(Reinforcement$areaMm2)) > 1e-10 ||
      length(unique(Reinforcement$yieldStrengthMPa)) != 1L ||
      length(unique(Reinforcement$modulusMPa)) != 1L) {
    stop(
      "The reinforcement study requires two symmetric equal-material layers.",
      call. = FALSE
    )
  }
  if (!is.list(interactionDiagram) ||
      !is.data.frame(interactionDiagram[["domain", exact = TRUE]]) ||
      !is.data.frame(interactionDiagram[["demands", exact = TRUE]])) {
    stop("interactionDiagram must contain the configured P-M products.",
      call. = FALSE
    )
  }
  ConfiguredDomain <- interactionDiagram[["domain", exact = TRUE]]
  DemandTemplate <- interactionDiagram[["demands", exact = TRUE]]
  DemandRequired <- c(
    "caseID", "interfaceID", "strengthCaseID", "thetaIndex", "thetaRad",
    "thetaDeg", "combinationID", "stageID", "forceEffectStatus",
    "axialDemandKnPerM", "bendingDemandKnMPerM",
    "radialCapacityMultiplier", "radialUtilization", "domainPositionID",
    "convergenceRelativeDifference", "convergenceStatus", "checkStatus",
    "verticalStressFactor", "horizontalStressFactor",
    "loadCombinationBasisID"
  )
  if (nrow(DemandTemplate) == 0L ||
      any(!DemandRequired %in% names(DemandTemplate)) ||
      length(unique(DemandTemplate$forceEffectStatus)) != 1L ||
      unique(DemandTemplate$forceEffectStatus) != "lrfd-factored" ||
      any(DemandTemplate$convergenceStatus != "satisfied")) {
    stop("The configured P-M demands cannot seed the study.", call. = FALSE)
  }
  Minimum <- checkAci318214SymmetricShellReinforcement(
    thicknessMm = Thickness,
    stripWidthMm = 1000 * WidthM,
    circumferentialReinforcement = Reinforcement,
    orthogonalReinforcement = Orthogonal
  )
  MinimumTotalAreaPerM <-
    Minimum$requiredAreaPerDirectionMm2 / WidthM
  MinimumRatio <- MinimumTotalAreaPerM / (1000 * Thickness)
  if (!any(abs(Policy$reinforcementRatioGrid - MinimumRatio) < 1e-12)) {
    stop("The discrete family must include the historical minimum.",
      call. = FALSE
    )
  }
  ConfiguredAreaPerFacePerM <- Reinforcement$areaMm2[1L] / WidthM
  ConfiguredRatio <- 2 * ConfiguredAreaPerFacePerM / (1000 * Thickness)
  Ratios <- sort(unique(c(
    Policy$reinforcementRatioGrid,
    ConfiguredRatio
  )))
  AreasPerFace <- Ratios * 1000 * Thickness / 2

  buildRecord <- function(areaPerFace, isConfigured) {
    Area <- .reinforcementStudyScalar(
      areaPerFace,
      "areaPerFaceMm2PerM",
      minimum = .Machine$double.eps
    )
    if (isConfigured) {
      return(list(
        domain = ConfiguredDomain,
        demands = DemandTemplate
      ))
    }
    Layers <- Reinforcement
    Layers$areaMm2 <- Area * WidthM
    Domains <- buildAci31825ReinforcedSectionDomains(
      thicknessMm = Thickness,
      stripWidthMm = 1000 * WidthM,
      compressiveStrengthMPa = ConcreteStrength,
      reinforcement = Layers,
      basePointCount = Policy$domainBasePointCount,
      refinedPointCount = Policy$domainRefinedPointCount
    )
    Demand <- evaluateAci31825ReinforcedSectionDemand(
      normalForceKnPerM = -DemandTemplate$axialDemandKnPerM,
      bendingMomentKnMPerM = DemandTemplate$bendingDemandKnMPerM,
      stripWidthM = WidthM,
      sectionDomains = Domains,
      forceEffectStatus = unique(DemandTemplate$forceEffectStatus),
      convergenceTolerance = Policy$convergenceTolerance
    )
    if (any(Demand$convergenceStatus != "satisfied")) {
      stop(
        "The discrete domain at ", format(Area, digits = 16),
        " mm2/m per face has maximum relative difference ",
        format(max(Demand$convergenceRelativeDifference), digits = 8),
        ", above ", format(Policy$convergenceTolerance, digits = 8), ".",
        call. = FALSE
      )
    }
    Demands <- DemandTemplate
    for (Name in c(
      "radialCapacityMultiplier", "radialUtilization", "domainPositionID",
      "convergenceRelativeDifference", "convergenceStatus"
    )) {
      Demands[[Name]] <- Demand[[Name, exact = TRUE]]
    }
    Demands$checkStatus <- Demand$localStrengthStatus
    list(
      domain = .reinforcementStudyDomain(Domains, WidthM),
      demands = Demands
    )
  }

  ConfiguredFlags <- abs(Ratios - ConfiguredRatio) < 1e-12
  Records <- lapply(seq_along(Ratios), function(i) {
    buildRecord(AreasPerFace[i], ConfiguredFlags[i])
  })
  CaseIDs <- vapply(AreasPerFace, function(area) {
    .reinforcementStudyCaseID(2 * area)
  }, character(1))
  if (anyDuplicated(CaseIDs)) {
    stop("Reinforcement case identifiers are not unique.", call. = FALSE)
  }
  MinimumFlags <- abs(Ratios - MinimumRatio) < 1e-12
  SummaryRows <- lapply(seq_along(Records), function(i) {
    Record <- Records[[i]]
    Governing <- .reinforcementStudyGoverningRow(Record$demands)
    MaximumUtilization <- Governing$radialUtilization[1L]
    data.frame(
      scenarioID = scenarioID,
      liningID = liningID,
      sectionID = sectionID,
      concreteTypeID = "reinforced-concrete",
      studyID = Policy$studyID,
      reinforcementCaseID = CaseIDs[i],
      reinforcementCaseOrder = i,
      circumferentialAreaTotalMm2PerM = 2 * AreasPerFace[i],
      reinforcementRatio = Ratios[i],
      areaToMinimumRatio = 2 * AreasPerFace[i] / MinimumTotalAreaPerM,
      calculationStatus = "calculated",
      maximumRadialUtilization = MaximumUtilization,
      localPMStatus = if (MaximumUtilization <= 1) {
        "satisfied"
      } else {
        "not-satisfied"
      },
      governingCaseID = Governing$caseID[1L],
      governingInterfaceID = Governing$interfaceID[1L],
      governingStrengthCaseID = Governing$strengthCaseID[1L],
      governingCombinationID = Governing$combinationID[1L],
      governingVerticalStressFactor =
        Governing$verticalStressFactor[1L],
      governingHorizontalStressFactor =
        Governing$horizontalStressFactor[1L],
      governingThetaIndex = Governing$thetaIndex[1L],
      governingThetaDeg = Governing$thetaDeg[1L],
      governingAxialDemandKnPerM = Governing$axialDemandKnPerM[1L],
      governingBendingDemandKnMPerM =
        Governing$bendingDemandKnMPerM[1L],
      minimumComparisonStatus = if (
        2 * AreasPerFace[i] + 1e-9 >= MinimumTotalAreaPerM
      ) "satisfied" else "not-satisfied",
      isConfiguredCase = ConfiguredFlags[i],
      isMinimumHistoricalCase = MinimumFlags[i],
      isParametricReferenceCase = !ConfiguredFlags[i],
      demandReuseBasisID =
        "gross-uncracked-short-term-invariant-demands",
      demandReuseStatus = "satisfied",
      blockReason = "",
      stringsAsFactors = FALSE
    )
  })
  Summary <- do.call(rbind, SummaryRows)
  rownames(Summary) <- NULL

  DomainRows <- lapply(seq_along(Records), function(i) {
    Domain <- Records[[i]]$domain
    Required <- c(
      "domainPointIndex", "axialStrengthKnPerM",
      "bendingStrengthKnMPerM", "domainPrimitiveID", "provisionID",
      "designBasisID", "strengthReductionRuleID", "sourceLocator"
    )
    if (any(!Required %in% names(Domain))) {
      stop("A reinforcement domain is incomplete.", call. = FALSE)
    }
    cbind(
      data.frame(
        scenarioID = scenarioID,
        liningID = liningID,
        sectionID = sectionID,
        concreteTypeID = "reinforced-concrete",
        studyID = Policy$studyID,
        reinforcementCaseID = CaseIDs[i],
        stringsAsFactors = FALSE
      ),
      Domain[, Required, drop = FALSE]
    )
  })
  Domains <- do.call(rbind, DomainRows)
  rownames(Domains) <- NULL
  ConfiguredIndex <- which(ConfiguredFlags)
  if (length(ConfiguredIndex) != 1L) {
    stop("The configured reinforcement case is ambiguous.", call. = FALSE)
  }
  ConfiguredGoverningDemands <- .reinforcementStudyConfiguredDemands(
    demands = DemandTemplate,
    scenarioID = scenarioID,
    liningID = liningID,
    sectionID = sectionID,
    studyID = Policy$studyID,
    reinforcementCaseID = CaseIDs[ConfiguredIndex],
    interfaceCaseIDs = interfaceCaseIDs,
    strengthCaseIDs = strengthCaseIDs
  )
  list(
    domains = Domains,
    summary = Summary,
    configuredGoverningDemands = ConfiguredGoverningDemands
  )
}

.evaluateCoverReinforcementStudy <- function(config, additionalLinings) {
  if (!is.list(config) || !is.list(additionalLinings)) {
    stop("config and additionalLinings must be named lists.", call. = FALSE)
  }
  Lining <- config[["additionalLinings", exact = TRUE]][[
    "reinforcedConcrete",
    exact = TRUE
  ]]
  Policy <- if (is.null(Lining)) {
    NULL
  } else {
    Lining[["reinforcementStudy", exact = TRUE]]
  }
  if (is.null(Policy)) return(NULL)
  Result <- additionalLinings[["reinforcedConcrete", exact = TRUE]]
  if (is.null(Result) ||
      !identical(Lining[["concreteTypeID", exact = TRUE]],
        "reinforced-concrete") ||
      !identical(Lining[["stiffnessBasisID", exact = TRUE]],
        "gross-uncracked-short-term")) {
    stop("The reinforced-concrete study basis is unavailable.", call. = FALSE)
  }
  Aci <- Result[["assessment", exact = TRUE]][["aci", exact = TRUE]]
  Diagram <- if (is.null(Aci)) {
    NULL
  } else {
    Aci[["interactionDiagram", exact = TRUE]]
  }
  if (is.null(Diagram)) {
    stop("The configured reinforced P-M diagram is unavailable.", call. = FALSE)
  }
  evaluateAci31825SymmetricCircumferentialStudy(
    scenarioID = config[["scenarioID", exact = TRUE]],
    liningID = "reinforcedConcrete",
    sectionID = Lining[["sectionID", exact = TRUE]],
    thicknessMm = 1000 * Lining[["thicknessM", exact = TRUE]],
    stripWidthM = Lining[["stripWidthM", exact = TRUE]],
    compressiveStrengthMPa = Lining[[
      "compressiveStrengthMPa",
      exact = TRUE
    ]],
    baselineCircumferentialReinforcement = Lining[[
      "reinforcement",
      exact = TRUE
    ]],
    orthogonalReinforcement = Lining[[
      "orthogonalReinforcement",
      exact = TRUE
    ]],
    interactionDiagram = Diagram,
    interfaceCaseIDs = config[["interfaceCases", exact = TRUE]][[
      "caseID",
      exact = TRUE
    ]],
    strengthCaseIDs = Lining[["aci", exact = TRUE]][[
      "strengthCases",
      exact = TRUE
    ]][["caseID", exact = TRUE]],
    policy = Policy
  )
}
