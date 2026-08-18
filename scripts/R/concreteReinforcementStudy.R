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
    "domainRefinedPointCount", "convergenceTolerance", "compositeCase"
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
  Composite <- value[["compositeCase", exact = TRUE]]
  CompositeFields <- c(
    "caseID", "enabled", "interiorBarDiameterMm",
    "interiorBarSpacingMm", "interiorClearCoverMm",
    "fullCompositeAction"
  )
  if (!is.list(Composite) || is.null(names(Composite)) ||
      !setequal(names(Composite), CompositeFields)) {
    stop(
      path,
      ".compositeCase must contain exactly: ",
      paste(CompositeFields, collapse = ", "),
      ".",
      call. = FALSE
    )
  }
  CompositeCaseID <- Composite[["caseID", exact = TRUE]]
  if (!is.character(CompositeCaseID) || length(CompositeCaseID) != 1L ||
      is.na(CompositeCaseID) || !nzchar(CompositeCaseID)) {
    stop(path, ".compositeCase.caseID must be one identifier.",
      call. = FALSE
    )
  }
  for (Flag in c("enabled", "fullCompositeAction")) {
    Value <- Composite[[Flag, exact = TRUE]]
    if (!is.logical(Value) || length(Value) != 1L || is.na(Value)) {
      stop(
        path, ".compositeCase.", Flag, " must be TRUE or FALSE.",
        call. = FALSE
      )
    }
  }
  CompositeDiameter <- .reinforcementStudyScalar(
    Composite[["interiorBarDiameterMm", exact = TRUE]],
    paste0(path, ".compositeCase.interiorBarDiameterMm"),
    minimum = .Machine$double.eps
  )
  CompositeSpacing <- .reinforcementStudyScalar(
    Composite[["interiorBarSpacingMm", exact = TRUE]],
    paste0(path, ".compositeCase.interiorBarSpacingMm"),
    minimum = .Machine$double.eps
  )
  CompositeCover <- .reinforcementStudyScalar(
    Composite[["interiorClearCoverMm", exact = TRUE]],
    paste0(path, ".compositeCase.interiorClearCoverMm"),
    minimum = .Machine$double.eps
  )
  if (CompositeSpacing <= CompositeDiameter) {
    stop(
      path,
      ".compositeCase.interiorBarSpacingMm must exceed the diameter.",
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
    ),
    compositeCase = list(
      caseID = CompositeCaseID,
      enabled = Composite[["enabled", exact = TRUE]],
      interiorBarDiameterMm = CompositeDiameter,
      interiorBarSpacingMm = CompositeSpacing,
      interiorClearCoverMm = CompositeCover,
      fullCompositeAction = Composite[["fullCompositeAction", exact = TRUE]]
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

.reinforcementStudyGoverningDemands <- function(
  demands,
  scenarioID,
  liningID,
  sectionID,
  studyID,
  reinforcementCaseID,
  reinforcementCaseOrder,
  circumferentialAreaTotalMm2PerM,
  reinforcementRatio,
  interfaceCaseIDs,
  strengthCaseIDs
) {
  Rows <- lapply(seq_along(interfaceCaseIDs), function(i) {
    Data <- demands[
      demands$caseID == interfaceCaseIDs[i] &
        demands$strengthCaseID %in% strengthCaseIDs,
      ,
      drop = FALSE
    ]
    if (nrow(Data) == 0L ||
        !setequal(unique(Data$strengthCaseID), strengthCaseIDs)) {
      stop("The P-M demand groups are incomplete.", call. = FALSE)
    }
    Data[order(
      -Data$radialUtilization,
      match(Data$strengthCaseID, strengthCaseIDs),
      Data$thetaIndex
    )[1L], , drop = FALSE]
  })
  OUT <- do.call(rbind, Rows)
  rownames(OUT) <- NULL
  OUT <- OUT[order(
    match(OUT$caseID, interfaceCaseIDs)
  ), , drop = FALSE]
  Required <- c(
    "caseID", "interfaceID", "strengthCaseID", "combinationID",
    "verticalStressFactor", "horizontalStressFactor", "stageID",
    "forceEffectStatus", "loadCombinationBasisID", "thetaIndex",
    "thetaRad", "thetaDeg", "axialDemandKnPerM",
    "bendingDemandKnMPerM", "radialUtilization", "domainPositionID",
    "convergenceStatus", "checkStatus"
  )
  if (nrow(OUT) != length(interfaceCaseIDs) ||
      any(!Required %in% names(OUT))) {
    stop("The governing P-M demand schema is incomplete.", call. = FALSE)
  }
  cbind(
    data.frame(
      scenarioID = scenarioID,
      liningID = liningID,
      sectionID = sectionID,
      concreteTypeID = "reinforced-concrete-parametric",
      studyID = studyID,
      reinforcementCaseID = reinforcementCaseID,
      reinforcementCaseOrder = reinforcementCaseOrder,
      circumferentialAreaTotalMm2PerM =
        circumferentialAreaTotalMm2PerM,
      reinforcementRatio = reinforcementRatio,
      demandOrder = seq_len(nrow(OUT)),
      selectionBasisID = "reinforcement-domain-interface-envelope",
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
  layerTemplate,
  actions,
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
    layerTemplate,
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
  ActionRequired <- c(
    "caseID", "interfaceID", "strengthCaseID", "thetaRad", "thetaDeg",
    "combinationID", "stageID", "forceEffectStatus", "stripWidthM",
    "axialForceKn", "bendingMomentKnM", "verticalStressFactor",
    "horizontalStressFactor", "loadCombinationBasisID"
  )
  if (!is.data.frame(actions) || nrow(actions) == 0L ||
      any(!ActionRequired %in% names(actions)) ||
      any(!is.finite(actions$axialForceKn)) ||
      any(!is.finite(actions$bendingMomentKnM)) ||
      any(actions$forceEffectStatus != "lrfd-factored") ||
      any(abs(actions$stripWidthM - WidthM) > 1e-12)) {
    stop("actions must contain the factored P-M demand field.", call. = FALSE)
  }
  GroupKey <- paste(actions$caseID, actions$strengthCaseID, sep = "\r")
  ThetaIndex <- ave(seq_len(nrow(actions)), GroupKey, FUN = seq_along)
  DemandTemplate <- data.frame(
    caseID = actions$caseID,
    interfaceID = actions$interfaceID,
    strengthCaseID = actions$strengthCaseID,
    thetaIndex = as.integer(ThetaIndex),
    thetaRad = actions$thetaRad,
    thetaDeg = actions$thetaDeg,
    combinationID = actions$combinationID,
    stageID = actions$stageID,
    forceEffectStatus = actions$forceEffectStatus,
    axialDemandKnPerM = actions$axialForceKn / WidthM,
    bendingDemandKnMPerM = actions$bendingMomentKnM / WidthM,
    verticalStressFactor = actions$verticalStressFactor,
    horizontalStressFactor = actions$horizontalStressFactor,
    loadCombinationBasisID = actions$loadCombinationBasisID,
    stringsAsFactors = FALSE
  )
  Ratios <- Policy$reinforcementRatioGrid
  AreasPerFace <- Ratios * 1000 * Thickness / 2

  buildRecord <- function(areaPerFace) {
    Area <- .reinforcementStudyScalar(
      areaPerFace,
      "areaPerFaceMm2PerM",
      minimum = .Machine$double.eps
    )
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

  Records <- lapply(seq_along(Ratios), function(i) {
    buildRecord(AreasPerFace[i])
  })
  CaseIDs <- vapply(AreasPerFace, function(area) {
    .reinforcementStudyCaseID(2 * area)
  }, character(1))
  if (anyDuplicated(CaseIDs)) {
    stop("Reinforcement case identifiers are not unique.", call. = FALSE)
  }
  LowerReferenceFlags <- Ratios == min(Ratios)
  SummaryRows <- lapply(seq_along(Records), function(i) {
    Record <- Records[[i]]
    Governing <- .reinforcementStudyGoverningRow(Record$demands)
    MaximumUtilization <- Governing$radialUtilization[1L]
    data.frame(
      scenarioID = scenarioID,
      liningID = liningID,
      sectionID = sectionID,
      concreteTypeID = "reinforced-concrete-parametric",
      studyID = Policy$studyID,
      reinforcementCaseID = CaseIDs[i],
      reinforcementCaseOrder = i,
      circumferentialAreaTotalMm2PerM = 2 * AreasPerFace[i],
      reinforcementRatio = Ratios[i],
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
      isLowerReferenceCase = LowerReferenceFlags[i],
      isParametricCase = TRUE,
      demandReuseBasisID =
        "aci-318-25-cracked-wall-0p35-ig-invariant-demands",
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
        concreteTypeID = "reinforced-concrete-parametric",
        studyID = Policy$studyID,
        reinforcementCaseID = CaseIDs[i],
        stringsAsFactors = FALSE
      ),
      Domain[, Required, drop = FALSE]
    )
  })
  Domains <- do.call(rbind, DomainRows)
  rownames(Domains) <- NULL
  GoverningDemands <- do.call(rbind, lapply(seq_along(Records), function(i) {
    .reinforcementStudyGoverningDemands(
      demands = Records[[i]]$demands,
      scenarioID = scenarioID,
      liningID = liningID,
      sectionID = sectionID,
      studyID = Policy$studyID,
      reinforcementCaseID = CaseIDs[i],
      reinforcementCaseOrder = i,
      circumferentialAreaTotalMm2PerM = 2 * AreasPerFace[i],
      reinforcementRatio = Ratios[i],
      interfaceCaseIDs = interfaceCaseIDs,
      strengthCaseIDs = strengthCaseIDs
    )
  }))
  rownames(GoverningDemands) <- NULL
  GoverningDemands$demandOrder <- seq_len(nrow(GoverningDemands))
  list(
    domains = Domains,
    summary = Summary,
    governingDemands = GoverningDemands
  )
}

.reinforcementStudyInteriorMesh <- function(
  thicknessMm,
  stripWidthM,
  compositePolicy,
  yieldStrengthMPa,
  modulusMPa
) {
  Diameter <- compositePolicy$interiorBarDiameterMm
  Spacing <- compositePolicy$interiorBarSpacingMm
  Cover <- compositePolicy$interiorClearCoverMm
  Coordinate <- -thicknessMm / 2 + Cover + Diameter / 2
  if (Coordinate >= 0 || abs(Coordinate) >= thicknessMm / 2) {
    stop("The composite interior mesh is outside the section.",
      call. = FALSE
    )
  }
  data.frame(
    layerID = "composite-circumferential-interior",
    areaMm2 = pi * Diameter^2 / 4 * 1000 / Spacing * stripWidthM,
    coordinateMm = Coordinate,
    yieldStrengthMPa = yieldStrengthMPa,
    modulusMPa = modulusMPa,
    displacesConcrete = TRUE,
    stringsAsFactors = FALSE
  )
}

.reinforcementStudySheetLayer <- function(
  thicknessMm,
  stripWidthM,
  steelSection,
  yieldStrengthMPa,
  modulusMPa
) {
  AreaPerWidth <- steelSection$areaMm2PerMm[1L]
  if (!is.numeric(AreaPerWidth) || length(AreaPerWidth) != 1L ||
      !is.finite(AreaPerWidth) || AreaPerWidth <= 0) {
    stop("The remaining sheet area is unavailable.", call. = FALSE)
  }
  data.frame(
    layerID = "existing-corrugated-sheet-exterior",
    areaMm2 = AreaPerWidth * 1000 * stripWidthM,
    coordinateMm = thicknessMm / 2,
    yieldStrengthMPa = yieldStrengthMPa,
    modulusMPa = modulusMPa,
    displacesConcrete = FALSE,
    stringsAsFactors = FALSE
  )
}

.reinforcementStudySheetSection <- function(steelSection) {
  Required <- c(
    "areaMm2PerMm", "inertiaMm4PerMm", "centroidalRadiusM",
    "circumferentialYoungModulusGPa"
  )
  if (!is.data.frame(steelSection) || nrow(steelSection) != 1L ||
      any(!Required %in% names(steelSection))) {
    stop("steelSection must contain one calculated steel section.",
      call. = FALSE
    )
  }
  E <- steelSection$circumferentialYoungModulusGPa[1L] * 1e6
  list(
    section = as.list(steelSection[1L, , drop = FALSE]),
    rigidity = calculateRingSection(
      youngModulus = E,
      area = steelSection$areaMm2PerMm[1L] * 1e-3,
      inertia = steelSection$inertiaMm4PerMm[1L] * 1e-9,
      radius = steelSection$centroidalRadiusM[1L]
    )
  )
}

.reinforcementStudyCompositeActions <- function(
  config,
  lining,
  compositeSection
) {
  Theta <- buildThetaMesh(
    pointCount = config$numerics$thetaPointCount,
    criticalAnglesDeg = config$numerics$criticalAnglesDeg
  )
  Stress <- calculateHomogeneousCoverStress(
    coverCrownM = config$cover$coverCrownM,
    crownToAxisM = config$cover$crownToAxisM,
    effectiveUnitWeightKnPerM3 = config$cover$effectiveUnitWeightKnPerM3,
    effectiveSurchargeKPa = config$cover$effectiveSurchargeKPa,
    referencePositionID = config$cover$referencePositionID
  )
  K0State <- do.call(estimateK0, config$ground$k0)
  VerticalStress <- Stress$effectiveVerticalStressKPa
  HorizontalStress <- K0State$k0Applied * VerticalStress
  Cases <- config$interfaceCases
  StrengthCases <- lining$aci$strengthCases
  Rows <- lapply(seq_len(nrow(Cases)), function(j) {
    Scenario <- list(
      scenarioID = paste(
        config$scenarioID,
        "composite",
        Cases$caseID[j],
        sep = "--"
      ),
      cover = config$cover,
      ground = config$ground,
      interfaceID = .coverInterfaceAPI(Cases$interfaceID[j]),
      comparisonInterfaceID = .coverComparisonInterfaceAPI(
        Cases$comparisonInterfaceID[j]
      ),
      tangentialMultiplier = Cases$tangentialMultiplier[j],
      action = config$action,
      numerics = config$numerics,
      lining = lining
    )
    Scenario$lining$centroidalRadiusM <-
      compositeSection$centroidalRadiusM
    do.call(rbind, lapply(seq_len(nrow(StrengthCases)), function(i) {
      StrengthCase <- StrengthCases[i, , drop = FALSE]
      Baseline <- .calculateSchwartzEinsteinDesignInteraction(
        scenario = Scenario,
        section = compositeSection,
        theta = Theta,
        effectiveVerticalStressKPa =
          VerticalStress * StrengthCase$verticalStressFactor,
        effectiveHorizontalStressKPa =
          HorizontalStress * StrengthCase$horizontalStressFactor,
        waterPressureDifferenceKPa =
          config$action$waterPressureDifferenceKPa *
          StrengthCase$horizontalStressFactor,
        combinationID = StrengthCase$combinationID,
        forceEffectStatus = StrengthCase$forceEffectStatus
      )
      Interaction <- addBalancedGeostaticGradient(
        interaction = Baseline,
        radiusM = compositeSection$centroidalRadiusM,
        verticalStressGradientKPaPerM =
          config$cover$effectiveUnitWeightKnPerM3 *
          StrengthCase$verticalStressFactor,
        horizontalStressGradientKPaPerM =
          config$cover$effectiveUnitWeightKnPerM3 *
          K0State$k0Applied * StrengthCase$horizontalStressFactor
      )
      Values <- Interaction$values
      Actions <- mapAciShellActions(
        normalForceKnPerM = Values$normalForceKnPerM,
        bendingMomentKnMPerM = Values$bendingMomentKnMPerM,
        shearForceKnPerM = Values$shearForceKnPerM,
        stripWidthM = lining$stripWidthM,
        thetaRad = Values$thetaRad,
        thetaDeg = Values$thetaDeg,
        combinationID = Values$combinationID,
        stageID = Values$stageID,
        forceEffectStatus = Values$forceEffectStatus,
        interfaceID = Values$interfaceID
      )
      Actions$caseID <- Cases$caseID[j]
      Actions$interfaceID <- Cases$comparisonInterfaceID[j]
      Actions$strengthCaseID <- StrengthCase$caseID
      Actions$verticalStressFactor <- StrengthCase$verticalStressFactor
      Actions$horizontalStressFactor <- StrengthCase$horizontalStressFactor
      Actions$loadCombinationBasisID <-
        StrengthCase$loadCombinationBasisID
      Actions
    }))
  })
  OUT <- do.call(rbind, Rows)
  rownames(OUT) <- NULL
  OUT
}

.reinforcementStudyShearChecks <- function(
  actions,
  thicknessMm,
  stripWidthM,
  compressiveStrengthMPa,
  reinforcement
) {
  WidthMm <- 1000 * stripWidthM
  GrossArea <- WidthMm * thicknessMm
  Reinforcement <- .validateConcreteReinforcement(
    reinforcement,
    thicknessMm
  )
  calculateFace <- function(faceID) {
    Keep <- if (faceID == "interior") {
      Reinforcement$coordinateMm < 0
    } else {
      Reinforcement$coordinateMm > 0
    }
    if (!any(Keep)) {
      stop("Both flexural tension faces require reinforcement.",
        call. = FALSE
      )
    }
    Area <- sum(Reinforcement$areaMm2[Keep])
    Coordinate <- weighted.mean(
      Reinforcement$coordinateMm[Keep],
      Reinforcement$areaMm2[Keep]
    )
    Depth <- if (faceID == "interior") {
      thicknessMm / 2 - Coordinate
    } else {
      thicknessMm / 2 + Coordinate
    }
    list(areaMm2 = Area, effectiveDepthMm = Depth)
  }
  Interior <- calculateFace("interior")
  Exterior <- calculateFace("exterior")
  TensionFace <- ifelse(
    actions$bendingMomentKnM >= 0,
    "interior",
    "exterior"
  )
  Area <- ifelse(
    TensionFace == "interior",
    Interior$areaMm2,
    Exterior$areaMm2
  )
  Depth <- ifelse(
    TensionFace == "interior",
    Interior$effectiveDepthMm,
    Exterior$effectiveDepthMm
  )
  Rho <- Area / (WidthMm * Depth)
  LambdaS <- pmin(sqrt(2 / (1 + Depth / 250)), 1)
  AxialStress <- pmin(
    pmax(actions$axialForceKn * 1000 / (6 * GrossArea), -Inf),
    0.05 * compressiveStrengthMPa
  )
  NominalStress <- 0.66 * LambdaS * Rho^(1 / 3) *
    sqrt(compressiveStrengthMPa) + AxialStress
  UpperStress <- 0.42 * sqrt(compressiveStrengthMPa)
  LowerStress <- 0.083 * sqrt(compressiveStrengthMPa)
  NominalStress <- pmin(pmax(NominalStress, LowerStress), UpperStress)
  NominalStress <- pmax(NominalStress, 0)
  Phi <- 0.75
  Capacity <- Phi * NominalStress * WidthMm * Depth / 1000
  Utilization <- actions$shearDemandKn / Capacity
  data.frame(
    checkID = "one-way-shear",
    caseID = actions$caseID,
    interfaceID = actions$interfaceID,
    strengthCaseID = actions$strengthCaseID,
    thetaRad = actions$thetaRad,
    thetaDeg = actions$thetaDeg,
    tensionFaceID = TensionFace,
    reinforcementAreaMm2 = Area,
    effectiveDepthMm = Depth,
    reinforcementRatio = Rho,
    axialCompressionKn = actions$axialForceKn,
    demandKn = actions$shearDemandKn,
    nominalCapacityKn = Capacity / Phi,
    designCapacityKn = Capacity,
    strengthReductionFactor = Phi,
    utilization = Utilization,
    checkStatus = ifelse(Utilization <= 1, "satisfied", "not-satisfied"),
    standardID = "ACI-318-25",
    clauseID = "22.5.5.1",
    sourceLocator = paste(
      "ACI CODE-318-25 SI, Table 22.5.5.1 and",
      "Sections 22.5.5.1.1 through 22.5.5.1.3"
    ),
    stringsAsFactors = FALSE
  )
}

.reinforcementStudyRadialTensionCheck <- function(
  lining,
  reinforcement,
  reinforcementCaseID
) {
  Reinforcement <- .validateConcreteReinforcement(
    reinforcement,
    1000 * lining$thicknessM
  )
  Interior <- Reinforcement[Reinforcement$coordinateMm < 0, , drop = FALSE]
  if (nrow(Interior) != 1L) {
    stop("The radial-tension check requires one interior layer.",
      call. = FALSE
    )
  }
  InsideDiameterM <- 2 * (lining$outerRadiusM - lining$thicknessM)
  if (InsideDiameterM <= 1.8 || InsideDiameterM > 3.6) {
    stop("The CIRSOC radial-tension diameter branch is unavailable.",
      call. = FALSE
    )
  }
  SteelRadiusM <- lining$centroidalRadiusM +
    Interior$coordinateMm[1L] / 1000
  Frt <- 0.80 + 0.0615 * (3.60 - InsideDiameterM)^2
  Frp <- 1.0
  Rphi <- 0.82 / 0.90
  MaximumArea <- 110720 * SteelRadiusM * Frp *
    sqrt(lining$compressiveStrengthMPa) * Rphi * Frt /
    Interior$yieldStrengthMPa[1L]
  Utilization <- Interior$areaMm2[1L] / MaximumArea
  data.frame(
    checkID = "radial-tension-without-radial-stirrups",
    reinforcementCaseID = reinforcementCaseID,
    interiorAreaMm2PerM = Interior$areaMm2[1L] / lining$stripWidthM,
    maximumInteriorAreaMm2PerM = MaximumArea / lining$stripWidthM,
    steelRadiusM = SteelRadiusM,
    insideDiameterM = InsideDiameterM,
    reinforcementFactor = Frp,
    diameterFactor = Frt,
    resistanceFactorRatio = Rphi,
    utilization = Utilization,
    checkStatus = if (Utilization <= 1) "satisfied" else "not-satisfied",
    standardID = "CIRSOC-804-4-2023",
    clauseID = "12.10.4.2.4c",
    applicabilityStatus = "conditional-shotcrete-analogy",
    sourceLocator = paste(
      "CIRSOC 804-4:2023, Section 12.10.4.2.4c,",
      "Eqs. 12.10.4.2.4c-1 and 12.10.4.2.4c-2"
    ),
    stringsAsFactors = FALSE
  )
}

.reinforcementStudyLimitAssessment <- function(
  scenarioID,
  liningID,
  sectionID,
  lining,
  reinforcement,
  actions,
  reinforcementCaseID
) {
  Shear <- .reinforcementStudyShearChecks(
    actions = actions,
    thicknessMm = 1000 * lining$thicknessM,
    stripWidthM = lining$stripWidthM,
    compressiveStrengthMPa = lining$compressiveStrengthMPa,
    reinforcement = reinforcement
  )
  ShearGoverning <- Shear[which.max(Shear$utilization), , drop = FALSE]
  Radial <- .reinforcementStudyRadialTensionCheck(
    lining = lining,
    reinforcement = reinforcement,
    reinforcementCaseID = reinforcementCaseID
  )
  Rows <- rbind(
    data.frame(
      scenarioID = scenarioID,
      liningID = liningID,
      sectionID = sectionID,
      reinforcementCaseID = reinforcementCaseID,
      checkID = ShearGoverning$checkID,
      standardID = ShearGoverning$standardID,
      clauseID = ShearGoverning$clauseID,
      applicabilityStatus = "applicable",
      caseID = ShearGoverning$caseID,
      interfaceID = ShearGoverning$interfaceID,
      strengthCaseID = ShearGoverning$strengthCaseID,
      thetaDeg = ShearGoverning$thetaDeg,
      demandValue = ShearGoverning$demandKn,
      capacityValue = ShearGoverning$designCapacityKn,
      unit = "kN/m",
      utilization = ShearGoverning$utilization,
      checkStatus = ShearGoverning$checkStatus,
      sourceLocator = ShearGoverning$sourceLocator,
      stringsAsFactors = FALSE
    ),
    data.frame(
      scenarioID = scenarioID,
      liningID = liningID,
      sectionID = sectionID,
      reinforcementCaseID = reinforcementCaseID,
      checkID = Radial$checkID,
      standardID = Radial$standardID,
      clauseID = Radial$clauseID,
      applicabilityStatus = Radial$applicabilityStatus,
      caseID = "",
      interfaceID = "",
      strengthCaseID = "",
      thetaDeg = NA_real_,
      demandValue = Radial$interiorAreaMm2PerM,
      capacityValue = Radial$maximumInteriorAreaMm2PerM,
      unit = "mm2/m",
      utilization = Radial$utilization,
      checkStatus = Radial$checkStatus,
      sourceLocator = Radial$sourceLocator,
      stringsAsFactors = FALSE
    )
  )
  list(
    checks = Rows,
    maximumShearUtilization = ShearGoverning$utilization,
    shearStatus = ShearGoverning$checkStatus,
    radialTensionUtilization = Radial$utilization,
    radialTensionStatus = Radial$checkStatus
  )
}

.evaluateAci31825CompositeReinforcementStudy <- function(
  scenarioID,
  liningID,
  lining,
  config,
  steelSection,
  policy
) {
  Policy <- normaliseAci31825ReinforcementStudyPolicy(policy)
  CompositePolicy <- Policy$compositeCase
  if (!isTRUE(CompositePolicy$enabled)) return(NULL)
  if (!isTRUE(CompositePolicy$fullCompositeAction)) {
    stop(
      "The enabled composite case requires fullCompositeAction = TRUE.",
      call. = FALSE
    )
  }
  Thickness <- 1000 * lining$thicknessM
  WidthM <- lining$stripWidthM
  ReinforcementReference <- config$additionalLinings$reinforcedConcrete
  Grade <- resolveReinforcementGrade(
    ReinforcementReference$reinforcementGradeID
  )
  ReinforcementModulus <- unique(
    ReinforcementReference$reinforcement$modulusMPa
  )
  if (length(ReinforcementModulus) != 1L) {
    stop("The interior reinforcement modulus is not unique.",
      call. = FALSE
    )
  }
  Interior <- .reinforcementStudyInteriorMesh(
    thicknessMm = Thickness,
    stripWidthM = WidthM,
    compositePolicy = CompositePolicy,
    yieldStrengthMPa = Grade$yieldStrengthMPa,
    modulusMPa = ReinforcementModulus
  )
  Sheet <- .reinforcementStudySheetLayer(
    thicknessMm = Thickness,
    stripWidthM = WidthM,
    steelSection = steelSection,
    yieldStrengthMPa = config$lining$yieldStrengthMPa,
    modulusMPa = config$lining$youngModulusKPa / 1000
  )
  StrengthLayers <- rbind(Interior, Sheet)
  ConcreteSection <- calculateConcreteRingSection(
    analysisThicknessM = lining$thicknessM,
    analysisModulusKPa = lining$youngModulusKPa,
    centroidalRadiusM = lining$centroidalRadiusM,
    stiffnessBasisID = lining$stiffnessBasisID
  )
  SheetCalculatedSection <- .reinforcementStudySheetSection(steelSection)
  CompositeSection <- calculateCompositeConcreteSteelRingSection(
    concreteSection = ConcreteSection,
    sheetSection = SheetCalculatedSection,
    sheetYoungModulusKPa = config$lining$youngModulusKPa,
    sheetCoordinateM = lining$thicknessM / 2,
    reinforcement = Interior,
    concreteCentroidalRadiusM = lining$centroidalRadiusM
  )
  Domains <- buildAci31825MixedReinforcedSectionDomains(
    thicknessMm = Thickness,
    stripWidthMm = 1000 * WidthM,
    compressiveStrengthMPa = lining$compressiveStrengthMPa,
    reinforcement = StrengthLayers,
    momentReferenceCoordinateMm =
      CompositeSection$momentReferenceCoordinateMm,
    basePointCount = Policy$domainBasePointCount,
    refinedPointCount = Policy$domainRefinedPointCount
  )
  Actions <- .reinforcementStudyCompositeActions(
    config = config,
    lining = lining,
    compositeSection = CompositeSection
  )
  Demand <- evaluateConcreteDemandConvergence(
    normalForceKnPerM = -Actions$normalForceKnPerM,
    bendingMomentKnMPerM = Actions$bendingMomentKnMPerM,
    stripWidthM = WidthM,
    baseDomain = Domains$base,
    refinedDomain = Domains$refined,
    forceEffectStatus = unique(Actions$forceEffectStatus),
    relativeTolerance = Policy$convergenceTolerance,
    baseGeometry = Domains$baseGeometry,
    refinedGeometry = Domains$refinedGeometry
  )
  if (any(Demand$convergenceStatus != "satisfied")) {
    stop("The composite P-M domain did not converge.", call. = FALSE)
  }
  GroupKey <- paste(Actions$caseID, Actions$strengthCaseID, sep = "\r")
  Demands <- data.frame(
    caseID = Actions$caseID,
    interfaceID = Actions$interfaceID,
    strengthCaseID = Actions$strengthCaseID,
    thetaIndex = as.integer(ave(
      seq_len(nrow(Actions)),
      GroupKey,
      FUN = seq_along
    )),
    thetaRad = Actions$thetaRad,
    thetaDeg = Actions$thetaDeg,
    combinationID = Actions$combinationID,
    stageID = Actions$stageID,
    forceEffectStatus = Actions$forceEffectStatus,
    axialDemandKnPerM = Actions$axialForceKn / WidthM,
    bendingDemandKnMPerM = Actions$bendingMomentKnM / WidthM,
    verticalStressFactor = Actions$verticalStressFactor,
    horizontalStressFactor = Actions$horizontalStressFactor,
    loadCombinationBasisID = Actions$loadCombinationBasisID,
    radialCapacityMultiplier = Demand$radialCapacityMultiplier,
    radialUtilization = Demand$radialUtilization,
    domainPositionID = Demand$domainPositionID,
    convergenceRelativeDifference = Demand$convergenceRelativeDifference,
    convergenceStatus = Demand$convergenceStatus,
    checkStatus = ifelse(
      Demand$radialUtilization <= 1,
      "satisfied",
      "not-satisfied"
    ),
    stringsAsFactors = FALSE
  )
  CaseID <- CompositePolicy$caseID
  CaseOrder <- length(Policy$reinforcementRatioGrid) + 1L
  AreaTotal <- sum(StrengthLayers$areaMm2) / WidthM
  Ratio <- AreaTotal / (1000 * Thickness)
  Governing <- .reinforcementStudyGoverningRow(Demands)
  MaximumPM <- Governing$radialUtilization[1L]
  Limit <- .reinforcementStudyLimitAssessment(
    scenarioID = scenarioID,
    liningID = liningID,
    sectionID = lining$sectionID,
    lining = lining,
    reinforcement = StrengthLayers,
    actions = Actions,
    reinforcementCaseID = CaseID
  )
  PMStatus <- if (MaximumPM <= 1) "satisfied" else "not-satisfied"
  OverallStatus <- if (all(c(
    PMStatus,
    Limit$shearStatus,
    Limit$radialTensionStatus
  ) == "satisfied")) "satisfied" else "not-satisfied"
  Summary <- data.frame(
    scenarioID = scenarioID,
    liningID = liningID,
    sectionID = lining$sectionID,
    concreteTypeID = "reinforced-concrete-composite",
    studyID = Policy$studyID,
    reinforcementCaseID = CaseID,
    reinforcementCaseOrder = CaseOrder,
    circumferentialAreaTotalMm2PerM = AreaTotal,
    reinforcementRatio = Ratio,
    calculationStatus = "calculated",
    maximumRadialUtilization = MaximumPM,
    localPMStatus = PMStatus,
    governingCaseID = Governing$caseID[1L],
    governingInterfaceID = Governing$interfaceID[1L],
    governingStrengthCaseID = Governing$strengthCaseID[1L],
    governingCombinationID = Governing$combinationID[1L],
    governingVerticalStressFactor = Governing$verticalStressFactor[1L],
    governingHorizontalStressFactor = Governing$horizontalStressFactor[1L],
    governingThetaIndex = Governing$thetaIndex[1L],
    governingThetaDeg = Governing$thetaDeg[1L],
    governingAxialDemandKnPerM = Governing$axialDemandKnPerM[1L],
    governingBendingDemandKnMPerM = Governing$bendingDemandKnMPerM[1L],
    isLowerReferenceCase = FALSE,
    isParametricCase = FALSE,
    demandReuseBasisID = "full-composite-recalculated-demands",
    demandReuseStatus = "satisfied",
    blockReason = "",
    maximumShearUtilization = Limit$maximumShearUtilization,
    shearStatus = Limit$shearStatus,
    radialTensionUtilization = Limit$radialTensionUtilization,
    radialTensionStatus = Limit$radialTensionStatus,
    overallLocalStatus = OverallStatus,
    compositeActionHypothesisID = "full-composite-total-load-sensitivity",
    interiorReinforcementAreaMm2PerM = Interior$areaMm2 / WidthM,
    exteriorSheetAreaMm2PerM = Sheet$areaMm2 / WidthM,
    elasticCentroidCoordinateMm =
      CompositeSection$momentReferenceCoordinateMm,
    extensionalRigidityKnPerM =
      CompositeSection$rigidity$extensionalRigidity,
    flexuralRigidityKnM2PerM =
      CompositeSection$rigidity$flexuralRigidity,
    stringsAsFactors = FALSE
  )
  Domain <- .reinforcementStudyDomain(Domains, WidthM)
  DomainsOutput <- cbind(
    data.frame(
      scenarioID = scenarioID,
      liningID = liningID,
      sectionID = lining$sectionID,
      concreteTypeID = "reinforced-concrete-composite",
      studyID = Policy$studyID,
      reinforcementCaseID = CaseID,
      stringsAsFactors = FALSE
    ),
    Domain
  )
  GoverningDemands <- .reinforcementStudyGoverningDemands(
    demands = Demands,
    scenarioID = scenarioID,
    liningID = liningID,
    sectionID = lining$sectionID,
    studyID = Policy$studyID,
    reinforcementCaseID = CaseID,
    reinforcementCaseOrder = CaseOrder,
    circumferentialAreaTotalMm2PerM = AreaTotal,
    reinforcementRatio = Ratio,
    interfaceCaseIDs = config$interfaceCases$caseID,
    strengthCaseIDs = lining$aci$strengthCases$caseID
  )
  list(
    domains = DomainsOutput,
    summary = Summary,
    governingDemands = GoverningDemands,
    limitChecks = Limit$checks
  )
}

.evaluateCoverReinforcementStudy <- function(
  config,
  additionalLinings,
  steelSection = NULL
) {
  if (!is.list(config) || !is.list(additionalLinings)) {
    stop("config and additionalLinings must be named lists.", call. = FALSE)
  }
  ReferenceLining <- config[["additionalLinings", exact = TRUE]][[
    "reinforcedConcrete",
    exact = TRUE
  ]]
  Policy <- if (is.null(ReferenceLining)) {
    NULL
  } else {
    ReferenceLining[["reinforcementStudy", exact = TRUE]]
  }
  if (is.null(Policy)) return(NULL)
  if (!identical(ReferenceLining[["concreteTypeID", exact = TRUE]],
        "reinforced-concrete") ||
      !identical(ReferenceLining[["stiffnessBasisID", exact = TRUE]],
        "aci-318-25-cracked-wall-0p35-ig")) {
    stop("The reinforced-concrete study basis is unavailable.", call. = FALSE)
  }
  ReferenceThickness <- 1000 * ReferenceLining[["thicknessM", exact = TRUE]]
  TargetIDs <- intersect(c("shotcrete", "reinforcedConcrete"), names(additionalLinings))
  Studies <- lapply(TargetIDs, function(LiningID) {
    Lining <- config[["additionalLinings", exact = TRUE]][[LiningID]]
    Result <- additionalLinings[[LiningID]]
    Aci <- Result[["assessment", exact = TRUE]][["aci", exact = TRUE]]
    Actions <- if (is.null(Aci)) NULL else Aci[["actions", exact = TRUE]]
    Thickness <- 1000 * Lining[["thicknessM", exact = TRUE]]
    Layers <- ReferenceLining[["reinforcement", exact = TRUE]]
    Layers$coordinateMm <- Layers$coordinateMm * Thickness / ReferenceThickness
    Study <- evaluateAci31825SymmetricCircumferentialStudy(
      scenarioID = config[["scenarioID", exact = TRUE]],
      liningID = LiningID,
      sectionID = Lining[["sectionID", exact = TRUE]],
      thicknessMm = Thickness,
      stripWidthM = Lining[["stripWidthM", exact = TRUE]],
      compressiveStrengthMPa = Lining[["compressiveStrengthMPa", exact = TRUE]],
      layerTemplate = Layers,
      actions = Actions,
      interfaceCaseIDs = config[["interfaceCases", exact = TRUE]][["caseID", exact = TRUE]],
      strengthCaseIDs = Lining[["aci", exact = TRUE]][["strengthCases", exact = TRUE]][["caseID", exact = TRUE]],
      policy = Policy
    )
    LimitRows <- lapply(seq_len(nrow(Study$summary)), function(i) {
      Ratio <- Study$summary$reinforcementRatio[i]
      CaseID <- Study$summary$reinforcementCaseID[i]
      CaseLayers <- Layers
      CaseLayers$areaMm2 <-
        Ratio * 1000 * Thickness / 2 * Lining$stripWidthM
      Limit <- .reinforcementStudyLimitAssessment(
        scenarioID = config$scenarioID,
        liningID = LiningID,
        sectionID = Lining$sectionID,
        lining = Lining,
        reinforcement = CaseLayers,
        actions = Actions,
        reinforcementCaseID = CaseID
      )
      Study$summary$maximumShearUtilization[i] <<-
        Limit$maximumShearUtilization
      Study$summary$shearStatus[i] <<- Limit$shearStatus
      Study$summary$radialTensionUtilization[i] <<-
        Limit$radialTensionUtilization
      Study$summary$radialTensionStatus[i] <<-
        Limit$radialTensionStatus
      Study$summary$overallLocalStatus[i] <<- if (all(c(
        Study$summary$localPMStatus[i],
        Limit$shearStatus,
        Limit$radialTensionStatus
      ) == "satisfied")) "satisfied" else "not-satisfied"
      Limit$checks
    })
    Study$summary$compositeActionHypothesisID <- "not-applicable"
    Study$summary$interiorReinforcementAreaMm2PerM <-
      Study$summary$circumferentialAreaTotalMm2PerM / 2
    Study$summary$exteriorSheetAreaMm2PerM <- NA_real_
    Study$summary$elasticCentroidCoordinateMm <- 0
    Study$summary$extensionalRigidityKnPerM <-
      Result$section$extensionalRigidityKnPerM[1L]
    Study$summary$flexuralRigidityKnM2PerM <-
      Result$section$flexuralRigidityKnM2PerM[1L]
    Study$limitChecks <- do.call(rbind, LimitRows)
    Composite <- .evaluateAci31825CompositeReinforcementStudy(
      scenarioID = config$scenarioID,
      liningID = LiningID,
      lining = Lining,
      config = config,
      steelSection = steelSection,
      policy = Policy
    )
    if (!is.null(Composite)) {
      for (Name in c("domains", "summary", "governingDemands", "limitChecks")) {
        Study[[Name]] <- rbind(Study[[Name]], Composite[[Name]])
        rownames(Study[[Name]]) <- NULL
      }
      Study$governingDemands$demandOrder <-
        seq_len(nrow(Study$governingDemands))
    }
    Study
  })
  bind <- function(name) {
    OUT <- do.call(rbind, lapply(Studies, `[[`, name))
    rownames(OUT) <- NULL
    OUT
  }
  list(
    domains = bind("domains"),
    summary = bind("summary"),
    governingDemands = bind("governingDemands"),
    limitChecks = bind("limitChecks")
  )
}
