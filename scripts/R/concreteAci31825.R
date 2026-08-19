# Reinforced-concrete strip checks based on ACI CODE-318-25.
#
# The local P-M domain uses strain compatibility and equilibrium. The minimum
# shell reinforcement is distributed symmetrically between both faces for the
# initial P-M domain. ACI 318.2-14 defines the minimum total area by direction;
# the equal face split is an explicit analytical hypothesis. This adapter does
# not claim compliance with ACI 318.2-25, whose complete operative text is not
# available in the project library.

calculateAci31825Beta1 <- function(compressiveStrengthMPa) {
  ConcreteStrength <- .concretePositiveScalar(
    compressiveStrengthMPa,
    "compressiveStrengthMPa"
  )
  if (ConcreteStrength <= 28) return(0.85)
  if (ConcreteStrength >= 55) return(0.65)
  0.85 - 0.05 * (ConcreteStrength - 28) / 7
}

calculateAci31825StrengthReductionFactor <- function(
  netTensileStrain,
  reinforcementYieldStrain
) {
  if (!is.numeric(netTensileStrain) || length(netTensileStrain) != 1L ||
      !is.finite(netTensileStrain) || netTensileStrain < 0) {
    stop("netTensileStrain must be one nonnegative number.", call. = FALSE)
  }
  YieldStrain <- .concretePositiveScalar(
    reinforcementYieldStrain,
    "reinforcementYieldStrain"
  )
  if (netTensileStrain <= YieldStrain) return(0.65)
  if (netTensileStrain >= YieldStrain + 0.003) return(0.90)
  0.65 + 0.25 * (netTensileStrain - YieldStrain) / 0.003
}

.aci31825NeutralAxisDepths <- function(
  thicknessMm,
  reinforcement,
  yieldStrain,
  pointCount
) {
  Thickness <- .concretePositiveScalar(thicknessMm, "thicknessMm")
  if (!is.numeric(pointCount) || length(pointCount) != 1L ||
      !is.finite(pointCount) || pointCount != as.integer(pointCount) ||
      pointCount < 101L) {
    stop("pointCount must be one integer of at least 101.", call. = FALSE)
  }
  Reinforcement <- .validateConcreteReinforcement(
    reinforcement,
    Thickness
  )
  ExteriorDepth <- Thickness / 2 - min(Reinforcement$coordinateMm)
  InteriorDepth <- Thickness / 2 + max(Reinforcement$coordinateMm)
  BalancedDepths <- c(ExteriorDepth, InteriorDepth) /
    (1 + yieldStrain / 0.003)
  sort(unique(c(
    Thickness * exp(seq(
      log(1e-6),
      log(1e3),
      length.out = as.integer(pointCount)
    )),
    BalancedDepths
  )))
}

.applyAci31825AxialPhiLimit <- function(
  domain,
  compressiveStrengthMPa,
  reinforcementYieldStrain = NULL
) {
  ConcreteStrength <- .concretePositiveScalar(
    compressiveStrengthMPa,
    "compressiveStrengthMPa"
  )
  Required <- c(
    "stateID", "compressionFaceID", "neutralAxisDepthMm",
    "netTensileStrain",
    "nominalAxialStrengthN", "nominalBendingStrengthNmm",
    "strengthReductionFactor", "thicknessMm", "stripWidthMm"
  )
  if (!is.data.frame(domain) ||
      length(setdiff(Required, names(domain))) > 0L) {
    stop("domain must be returned by buildConcreteSectionDomain().", call. = FALSE)
  }
  YieldStrain <- if (is.null(reinforcementYieldStrain)) {
    if (!("controllingYieldStrain" %in% names(domain)) ||
        any(!is.finite(domain$controllingYieldStrain)) ||
        any(domain$controllingYieldStrain <= 0)) {
      stop("The mixed-layer yield-strain field is unavailable.",
        call. = FALSE
      )
    }
    NULL
  } else {
    .concretePositiveScalar(
      reinforcementYieldStrain,
      "reinforcementYieldStrain"
    )
  }
  GrossArea <- unique(domain$thicknessMm * domain$stripWidthMm)
  if (length(GrossArea) != 1L) {
    stop("The reinforced domain must use one gross area.", call. = FALSE)
  }
  AxialThreshold <- 0.1 * ConcreteStrength * GrossArea
  Phi <- domain$strengthReductionFactor
  for (FaceID in c("interior", "exterior")) {
    FaceRows <- which(
      domain$compressionFaceID == FaceID &
        domain$stateID == "compatibility"
    )
    if (length(FaceRows) == 0L) next
    TargetYield <- if (is.null(YieldStrain)) {
      domain$controllingYieldStrain[FaceRows]
    } else {
      rep(YieldStrain, length(FaceRows))
    }
    BalanceDifference <- abs(
      domain$netTensileStrain[FaceRows] - TargetYield
    )
    BalanceIndex <- FaceRows[which.min(BalanceDifference)]
    if (abs(
      domain$netTensileStrain[BalanceIndex] -
        if (is.null(YieldStrain)) {
          domain$controllingYieldStrain[BalanceIndex]
        } else {
          YieldStrain
        }
    ) > 1e-10) {
      stop(
        "The reinforced domain does not contain the balanced point.",
        call. = FALSE
      )
    }
    BalancedAxial <- domain$nominalAxialStrengthN[BalanceIndex]
    if (!is.finite(BalancedAxial) || BalancedAxial <= AxialThreshold) next
    LimitedRows <- FaceRows[
      domain$nominalAxialStrengthN[FaceRows] >= AxialThreshold &
        domain$nominalAxialStrengthN[FaceRows] <= BalancedAxial
    ]
    PhiLimit <- 0.90 + (0.65 - 0.90) *
      (domain$nominalAxialStrengthN[LimitedRows] - AxialThreshold) /
      (BalancedAxial - AxialThreshold)
    Phi[LimitedRows] <- pmin(Phi[LimitedRows], PhiLimit)
  }
  domain$strengthReductionFactor <- Phi
  domain$axialStrengthN <- Phi * domain$nominalAxialStrengthN
  domain$bendingStrengthNmm <- Phi * domain$nominalBendingStrengthNmm
  domain$strengthReductionRuleID <-
    "ACI-318-25-21.2.2-table-and-axial-limit"
  domain$domainPrimitiveID <- paste0(
    domain$domainPrimitiveID,
    "||ACI-318-25-21.2.2.3"
  )
  domain
}

.applyAci31825AxialStrengthLimit <- function(
  domain,
  compressiveStrengthMPa,
  reinforcement,
  maximumNominalRatio = 0.80,
  compressionControlledPhi = 0.65
) {
  ConcreteStrength <- .concretePositiveScalar(
    compressiveStrengthMPa,
    "compressiveStrengthMPa"
  )
  Thickness <- unique(domain$thicknessMm)
  Width <- unique(domain$stripWidthMm)
  if (length(Thickness) != 1L || length(Width) != 1L) {
    stop("The ACI domain geometry is not unique.", call. = FALSE)
  }
  Reinforcement <- .validateConcreteReinforcement(
    reinforcement,
    Thickness
  )
  DisplacedArea <- sum(
    Reinforcement$areaMm2[Reinforcement$displacesConcrete]
  )
  ConcreteArea <- Thickness * Width - DisplacedArea
  if (ConcreteArea <= 0) {
    stop("The displaced concrete area is invalid.", call. = FALSE)
  }
  PureAxial <- 0.85 * ConcreteStrength * ConcreteArea +
    sum(Reinforcement$yieldStrengthMPa * Reinforcement$areaMm2)
  MaximumNominal <- maximumNominalRatio * PureAxial
  MaximumDesign <- compressionControlledPhi * MaximumNominal
  domain$nominalAxialStrengthN <- pmin(
    domain$nominalAxialStrengthN,
    MaximumNominal
  )
  domain$axialStrengthN <- pmin(domain$axialStrengthN, MaximumDesign)
  domain$pureAxialNominalStrengthN <- PureAxial
  domain$maximumNominalAxialStrengthN <- MaximumNominal
  domain$maximumDesignAxialStrengthN <- MaximumDesign
  domain$axialStrengthLimitStatus <- "applied"
  domain$domainPrimitiveID <- paste0(
    domain$domainPrimitiveID,
    "||ACI-318-25-22.4.2.1"
  )
  domain
}

.aci31825DomainInput <- function(
  thicknessMm,
  stripWidthMm,
  compressiveStrengthMPa,
  reinforcement
) {
  Thickness <- .concretePositiveScalar(thicknessMm, "thicknessMm")
  Width <- .concretePositiveScalar(stripWidthMm, "stripWidthMm")
  ConcreteStrength <- .concretePositiveScalar(
    compressiveStrengthMPa,
    "compressiveStrengthMPa"
  )
  Reinforcement <- .validateConcreteReinforcement(
    reinforcement,
    Thickness
  )
  rownames(Reinforcement) <- NULL
  list(
    thicknessMm = Thickness,
    stripWidthMm = Width,
    compressiveStrengthMPa = ConcreteStrength,
    reinforcement = Reinforcement
  )
}

buildAci31825ReinforcedSectionDomains <- function(
  thicknessMm,
  stripWidthMm,
  compressiveStrengthMPa,
  reinforcement,
  basePointCount = 201L,
  refinedPointCount = 401L
) {
  DomainInput <- .aci31825DomainInput(
    thicknessMm = thicknessMm,
    stripWidthMm = stripWidthMm,
    compressiveStrengthMPa = compressiveStrengthMPa,
    reinforcement = reinforcement
  )
  Reinforcement <- DomainInput[["reinforcement", exact = TRUE]]
  Thickness <- DomainInput[["thicknessMm", exact = TRUE]]
  Width <- DomainInput[["stripWidthMm", exact = TRUE]]
  ConcreteStrength <- DomainInput[["compressiveStrengthMPa", exact = TRUE]]
  YieldStrains <- Reinforcement$yieldStrengthMPa /
    Reinforcement$modulusMPa
  if (max(YieldStrains) - min(YieldStrains) > 1e-12) {
    stop(
      "All layers must use one reinforcement yield strain.",
      call. = FALSE
    )
  }
  if (refinedPointCount <= basePointCount) {
    stop("refinedPointCount must exceed basePointCount.", call. = FALSE)
  }
  YieldStrain <- YieldStrains[1L]
  Reduction <- function(netTensileStrain) {
    calculateAci31825StrengthReductionFactor(
      netTensileStrain = netTensileStrain,
      reinforcementYieldStrain = YieldStrain
    )
  }
  Beta <- calculateAci31825Beta1(ConcreteStrength)
  buildDomain <- function(pointCount) {
    Domain <- buildConcreteSectionDomain(
      thicknessMm = Thickness,
      stripWidthMm = Width,
      compressiveStrengthMPa = ConcreteStrength,
      reinforcement = Reinforcement,
      concreteMaximumStrain = 0.003,
      concreteStressFactor = 0.85,
      beta1 = Beta,
      strengthReductionFactor = Reduction,
      neutralAxisDepthsMm = .aci31825NeutralAxisDepths(
        thicknessMm = Thickness,
        reinforcement = Reinforcement,
        yieldStrain = YieldStrain,
        pointCount = pointCount
      ),
      provisionID = "ACI-318-25-reinforced-P-M",
      designBasisID = "factored-sectional-strain-compatibility",
      strengthReductionRuleID = "ACI-318-25-21.2.2-table",
      sourceLocator = paste(
        "ACI CODE-318-25 SI, Table 21.2.2, 21.2.2.3,",
        "22.2.1 and 22.2.2"
      )
    )
    Domain <- .applyAci31825AxialPhiLimit(
      domain = Domain,
      compressiveStrengthMPa = ConcreteStrength,
      reinforcementYieldStrain = YieldStrain
    )
    .applyAci31825AxialStrengthLimit(
      domain = Domain,
      compressiveStrengthMPa = ConcreteStrength,
      reinforcement = Reinforcement
    )
  }
  DomainBase <- buildDomain(basePointCount)
  DomainRefined <- buildDomain(refinedPointCount)
  list(
    base = DomainBase,
    refined = DomainRefined,
    baseGeometry = .prepareConcreteDomainGeometry(DomainBase),
    refinedGeometry = .prepareConcreteDomainGeometry(DomainRefined),
    domainInput = DomainInput,
    beta1 = Beta,
    reinforcementYieldStrain = YieldStrain,
    standardID = "ACI-318-25",
    supplementID = "ACI-318.2-14",
    scopeID = "local-reinforced-shell-strip-P-M",
    currentShellCodeStatus = "not-evaluated-aci-318.2-25",
    shearStatus = "not-evaluated"
  )
}

.aci31825MixedNeutralAxisDepths <- function(
  thicknessMm,
  reinforcement,
  pointCount
) {
  Thickness <- .concretePositiveScalar(thicknessMm, "thicknessMm")
  if (!is.numeric(pointCount) || length(pointCount) != 1L ||
      !is.finite(pointCount) || pointCount != as.integer(pointCount) ||
      pointCount < 101L) {
    stop("pointCount must be one integer of at least 101.", call. = FALSE)
  }
  Reinforcement <- .validateConcreteReinforcement(
    reinforcement,
    Thickness
  )
  YieldStrains <- Reinforcement$yieldStrengthMPa /
    Reinforcement$modulusMPa
  ExteriorLayerDepth <- Thickness / 2 - Reinforcement$coordinateMm
  InteriorLayerDepth <- Thickness / 2 + Reinforcement$coordinateMm
  BalancedDepths <- c(
    ExteriorLayerDepth / (1 + YieldStrains / 0.003),
    InteriorLayerDepth / (1 + YieldStrains / 0.003)
  )
  BalancedDepths <- BalancedDepths[
    is.finite(BalancedDepths) & BalancedDepths > 0
  ]
  sort(unique(c(
    Thickness * exp(seq(
      log(1e-6),
      log(1e3),
      length.out = as.integer(pointCount)
    )),
    BalancedDepths
  )))
}

buildAci31825MixedReinforcedSectionDomains <- function(
  thicknessMm,
  stripWidthMm,
  compressiveStrengthMPa,
  reinforcement,
  momentReferenceCoordinateMm,
  basePointCount = 201L,
  refinedPointCount = 401L
) {
  DomainInput <- .aci31825DomainInput(
    thicknessMm = thicknessMm,
    stripWidthMm = stripWidthMm,
    compressiveStrengthMPa = compressiveStrengthMPa,
    reinforcement = reinforcement
  )
  Reinforcement <- DomainInput[["reinforcement", exact = TRUE]]
  Thickness <- DomainInput[["thicknessMm", exact = TRUE]]
  Width <- DomainInput[["stripWidthMm", exact = TRUE]]
  ConcreteStrength <- DomainInput[["compressiveStrengthMPa", exact = TRUE]]
  if (refinedPointCount <= basePointCount) {
    stop("refinedPointCount must exceed basePointCount.", call. = FALSE)
  }
  Reduction <- function(netTensileStrain, steelStrain, reinforcement) {
    TensionIndex <- which.min(steelStrain)[1L]
    calculateAci31825StrengthReductionFactor(
      netTensileStrain = netTensileStrain,
      reinforcementYieldStrain =
        reinforcement$yieldStrengthMPa[TensionIndex] /
        reinforcement$modulusMPa[TensionIndex]
    )
  }
  Beta <- calculateAci31825Beta1(ConcreteStrength)
  buildDomain <- function(pointCount) {
    Domain <- buildConcreteSectionDomain(
      thicknessMm = Thickness,
      stripWidthMm = Width,
      compressiveStrengthMPa = ConcreteStrength,
      reinforcement = Reinforcement,
      concreteMaximumStrain = 0.003,
      concreteStressFactor = 0.85,
      beta1 = Beta,
      strengthReductionFactor = Reduction,
      neutralAxisDepthsMm = .aci31825MixedNeutralAxisDepths(
        thicknessMm = Thickness,
        reinforcement = Reinforcement,
        pointCount = pointCount
      ),
      provisionID = "ACI-318-25-mixed-steel-P-M",
      designBasisID =
        "conditional-full-composite-sectional-strain-compatibility",
      strengthReductionRuleID =
        "ACI-318-25-21.2.2-mixed-controlling-tension-layer",
      sourceLocator = paste(
        "ACI CODE-318-25 SI, Table 21.2.2, 21.2.2.3,",
        "22.2.1, 22.2.2 and 22.4.2"
      ),
      momentReferenceCoordinateMm = momentReferenceCoordinateMm
    )
    Domain <- .applyAci31825AxialPhiLimit(
      domain = Domain,
      compressiveStrengthMPa = ConcreteStrength,
      reinforcementYieldStrain = NULL
    )
    .applyAci31825AxialStrengthLimit(
      domain = Domain,
      compressiveStrengthMPa = ConcreteStrength,
      reinforcement = Reinforcement
    )
  }
  DomainBase <- buildDomain(basePointCount)
  DomainRefined <- buildDomain(refinedPointCount)
  list(
    base = DomainBase,
    refined = DomainRefined,
    baseGeometry = .prepareConcreteDomainGeometry(DomainBase),
    refinedGeometry = .prepareConcreteDomainGeometry(DomainRefined),
    domainInput = c(
      DomainInput,
      list(momentReferenceCoordinateMm = momentReferenceCoordinateMm)
    ),
    beta1 = Beta,
    standardID = "ACI-318-25",
    supplementID = "conditional-full-composite-action",
    scopeID = "conditional-full-composite-local-P-M",
    currentShellCodeStatus = "not-evaluated-aci-318.2-25",
    shearStatus = "evaluated-separately"
  )
}

.aci31825FaceAreas <- function(reinforcement, thicknessMm, name) {
  Reinforcement <- .validateConcreteReinforcement(
    reinforcement,
    thicknessMm
  )
  if (any(Reinforcement$coordinateMm == 0)) {
    stop(name, " layers must be assigned to one face.", call. = FALSE)
  }
  c(
    interior = sum(Reinforcement$areaMm2[Reinforcement$coordinateMm < 0]),
    exterior = sum(Reinforcement$areaMm2[Reinforcement$coordinateMm > 0])
  )
}

checkAci318214SymmetricShellReinforcement <- function(
  thicknessMm,
  stripWidthMm,
  circumferentialReinforcement,
  orthogonalReinforcement,
  equalityTolerance = 1e-9
) {
  Thickness <- .concretePositiveScalar(thicknessMm, "thicknessMm")
  Width <- .concretePositiveScalar(stripWidthMm, "stripWidthMm")
  Tolerance <- .concretePositiveScalar(
    equalityTolerance,
    "equalityTolerance"
  )
  Circumferential <- .aci31825FaceAreas(
    circumferentialReinforcement,
    Thickness,
    "circumferentialReinforcement"
  )
  Orthogonal <- .aci31825FaceAreas(
    orthogonalReinforcement,
    Thickness,
    "orthogonalReinforcement"
  )
  AllReinforcement <- rbind(
    circumferentialReinforcement,
    orthogonalReinforcement
  )
  Grade <- resolveReinforcementGrade(reinforcementGradeID = "Grade-60")
  YieldStrength <- Grade[["yieldStrengthMPa", exact = TRUE]]
  if (any(abs(AllReinforcement$yieldStrengthMPa - YieldStrength) > 1e-12)) {
    stop(
      paste(
        "The activated minimum-flexure branch uses 414 MPa as the",
        "declared conversion of Grade 60 reinforcement."
      ),
      call. = FALSE
    )
  }
  RequiredTotal <- 0.0018 * Thickness * Width
  RequiredPerFace <- RequiredTotal / 2
  EqualStatus <- function(values) {
    Scale <- max(abs(values), RequiredPerFace)
    if (abs(diff(values)) <= Tolerance * Scale) {
      "satisfied"
    } else {
      "not-satisfied"
    }
  }
  TotalStatus <- function(values) {
    if (sum(values) + Tolerance >= RequiredTotal) {
      "satisfied"
    } else {
      "not-satisfied"
    }
  }
  Statuses <- c(
    TotalStatus(Circumferential),
    TotalStatus(Orthogonal),
    EqualStatus(Circumferential),
    EqualStatus(Orthogonal)
  )
  data.frame(
    reinforcementGradeID = "Grade-60",
    adoptedYieldStrengthMPa = YieldStrength,
    minimumRatio = 0.0018,
    requiredAreaPerDirectionMm2 = RequiredTotal,
    requiredAreaPerFaceMm2 = RequiredPerFace,
    circumferentialInteriorAreaMm2 = Circumferential["interior"],
    circumferentialExteriorAreaMm2 = Circumferential["exterior"],
    orthogonalInteriorAreaMm2 = Orthogonal["interior"],
    orthogonalExteriorAreaMm2 = Orthogonal["exterior"],
    circumferentialTotalStatus = Statuses[1L],
    orthogonalTotalStatus = Statuses[2L],
    circumferentialFaceEqualityStatus = Statuses[3L],
    orthogonalFaceEqualityStatus = Statuses[4L],
    minimumReinforcementStatus = if (all(Statuses == "satisfied")) {
      "satisfied"
    } else {
      "not-satisfied"
    },
    standardID = "ACI-318-25+ACI-318.2-14",
    editionStatus = "current-base-with-historical-shell-supplement",
    scopeID = "minimum-shell-reinforcement-symmetric-face-hypothesis",
    sourceLocator = paste(
      "ACI 318.2-14 sections 6.1.3 and 6.1.9, printed pp. 9-10;",
      "Grade 60 converted as 414 MPa for the candidate analysis"
    ),
    stringsAsFactors = FALSE
  )
}

evaluateAci31825ReinforcedSectionDemand <- function(
  normalForceKnPerM,
  bendingMomentKnMPerM,
  stripWidthM,
  sectionDomains,
  forceEffectStatus,
  convergenceTolerance = 1e-3
) {
  if (!is.list(sectionDomains) ||
      !identical(sectionDomains$standardID, "ACI-318-25") ||
      !identical(
        sectionDomains$scopeID,
        "local-reinforced-shell-strip-P-M"
      )) {
    stop(
      paste(
        "sectionDomains must be returned by",
        "buildAci31825ReinforcedSectionDomains()."
      ),
      call. = FALSE
    )
  }
  OUT <- evaluateConcreteDemandConvergence(
    normalForceKnPerM = normalForceKnPerM,
    bendingMomentKnMPerM = bendingMomentKnMPerM,
    stripWidthM = stripWidthM,
    baseDomain = sectionDomains$base,
    refinedDomain = sectionDomains$refined,
    forceEffectStatus = forceEffectStatus,
    relativeTolerance = convergenceTolerance,
    baseGeometry = sectionDomains$baseGeometry,
    refinedGeometry = sectionDomains$refinedGeometry
  )
  OUT$localStrengthStatus <- ifelse(
    OUT$convergenceStatus != "satisfied",
    "not-evaluated-convergence",
    ifelse(
      OUT$radialUtilization <= 1,
      "satisfied",
      "not-satisfied"
    )
  )
  OUT$standardID <- sectionDomains$standardID
  OUT$supplementID <- sectionDomains$supplementID
  OUT$scopeID <- sectionDomains$scopeID
  OUT$currentShellCodeStatus <- sectionDomains$currentShellCodeStatus
  OUT$shearStatus <- sectionDomains$shearStatus
  OUT
}

evaluateAci31825ReinforcedShellStrip <- function(
  actions,
  thicknessMm,
  stripWidthMm,
  compressiveStrengthMPa,
  circumferentialReinforcement,
  orthogonalReinforcement,
  convergenceTolerance,
  shellClassificationStatus,
  longitudinalBoundaryConditionID,
  seismicDesignCategoryID,
  jointingStatus,
  openingStatus,
  sectionDomains = NULL
) {
  if (!is.data.frame(actions) || nrow(actions) == 0L) {
    stop("actions must be returned by mapAciShellActions().", call. = FALSE)
  }
  if (any(actions$forceEffectStatus != "lrfd-factored")) {
    stop("Reinforced checks require lrfd-factored actions.", call. = FALSE)
  }
  Thickness <- .concretePositiveScalar(thicknessMm, "thicknessMm")
  Width <- .concretePositiveScalar(stripWidthMm, "stripWidthMm")
  StripWidthM <- Width / 1000
  Minimum <- checkAci318214SymmetricShellReinforcement(
    thicknessMm = Thickness,
    stripWidthMm = Width,
    circumferentialReinforcement = circumferentialReinforcement,
    orthogonalReinforcement = orthogonalReinforcement
  )
  DomainInput <- .aci31825DomainInput(
    thicknessMm = Thickness,
    stripWidthMm = Width,
    compressiveStrengthMPa = compressiveStrengthMPa,
    reinforcement = circumferentialReinforcement
  )
  Domains <- if (is.null(sectionDomains)) {
    buildAci31825ReinforcedSectionDomains(
      thicknessMm = Thickness,
      stripWidthMm = Width,
      compressiveStrengthMPa = compressiveStrengthMPa,
      reinforcement = circumferentialReinforcement
    )
  } else {
    if (!is.list(sectionDomains) ||
        !identical(
          sectionDomains[["domainInput", exact = TRUE]],
          DomainInput
        )) {
      stop(
        "sectionDomains is incompatible with the reinforced section.",
        call. = FALSE
      )
    }
    sectionDomains
  }
  Demand <- evaluateAci31825ReinforcedSectionDemand(
    normalForceKnPerM = actions$normalForceKnPerM,
    bendingMomentKnMPerM = actions$bendingMomentKnMPerM,
    stripWidthM = StripWidthM,
    sectionDomains = Domains,
    forceEffectStatus = unique(actions$forceEffectStatus),
    convergenceTolerance = convergenceTolerance
  )
  RowChecks <- data.frame(
    combinationID = actions$combinationID,
    stageID = actions$stageID,
    forceEffectStatus = actions$forceEffectStatus,
    interfaceID = actions$interfaceID,
    thetaRad = actions$thetaRad,
    thetaDeg = actions$thetaDeg,
    normalForceKnPerM = actions$normalForceKnPerM,
    bendingMomentKnMPerM = actions$bendingMomentKnMPerM,
    shearForceKnPerM = actions$shearForceKnPerM,
    axialForceKn = actions$axialForceKn,
    bendingMomentKnM = actions$bendingMomentKnM,
    shearDemandKn = actions$shearDemandKn,
    checkID = "axial-flexure",
    standardID = "ACI-318-25",
    clauseID = "21.2.2;22.2.1;22.2.2",
    sourceLocator = paste(
      "ACI CODE-318-25 SI, Table 21.2.2, 21.2.2.3,",
      "22.2.1 and 22.2.2"
    ),
    demandValue = Demand$radialUtilization,
    capacityValue = 1,
    unit = "-",
    utilization = Demand$radialUtilization,
    applicabilityStatus = "applicable",
    calculationStatus = ifelse(
      Demand$convergenceStatus == "satisfied",
      "calculated",
      "not-evaluated"
    ),
    checkStatus = Demand$localStrengthStatus,
    blockReason = ifelse(
      Demand$convergenceStatus == "satisfied",
      "",
      "section-domain-convergence-not-satisfied"
    ),
    stringsAsFactors = FALSE
  )
  Checks <- .aci31825GoverningChecks(RowChecks)
  MinimumIDs <- c(
    "minimum-circumferential-reinforcement",
    "minimum-longitudinal-reinforcement"
  )
  MinimumProvided <- c(
    Minimum$circumferentialInteriorAreaMm2 +
      Minimum$circumferentialExteriorAreaMm2,
    Minimum$orthogonalInteriorAreaMm2 +
      Minimum$orthogonalExteriorAreaMm2
  )
  MinimumStatus <- c(
    Minimum$circumferentialTotalStatus,
    Minimum$orthogonalTotalStatus
  )
  MaximumOppositeFaceDifference <- max(
    abs(
      Minimum$circumferentialInteriorAreaMm2 -
        Minimum$circumferentialExteriorAreaMm2
    ),
    abs(
      Minimum$orthogonalInteriorAreaMm2 -
        Minimum$orthogonalExteriorAreaMm2
    )
  )
  GateChecks <- data.frame(
    checkID = c(
      MinimumIDs,
      "equal-reinforcement-at-opposite-faces",
      "minimum-concrete-strength",
      "longitudinal-action",
      "one-way-shear",
      "reinforcement-detailing",
      "current-shell-code",
      "global-stability",
      "durability",
      "serviceability"
    ),
    standardID = c(
      rep("ACI-318.2-14", 3L),
      "ACI-318.2-14",
      "ACI-318.2-14",
      "ACI-318-25",
      "ACI-318.2-14",
      "ACI-318.2-25",
      "ACI-318.2-14",
      "ACI-318-25",
      "ACI-318-25+ACI-224R-01"
    ),
    clauseID = c(
      rep("6.1.3;6.1.9", 3L),
      "4.1.1",
      "3.1.3",
      "6.1.4;22.5",
      "6.1.1-6.1.12;20.5;25.2.7",
      "1.4.4",
      "3.1.8",
      "19.3;20.5",
      "24.1;24.2;6.1.7"
    ),
    sourceLocator = c(
      rep(Minimum$sourceLocator, 3L),
      "ACI 318.2-14 section 4.1.1, printed p. 6",
      "ACI 318.2-14 section 3.1.3, printed p. 5",
      "ACI 318.2-14 section 6.1.4; ACI CODE-318-25 SI 22.5",
      "ACI 318.2-14 sections 6.1.1-6.1.12; ACI CODE-318-25 SI 20.5 and 25.2.7",
      "ACI CODE-318-25 SI 1.4.4; ACI CODE-318.2-25 operative text unavailable",
      "ACI 318.2-14 section 3.1.8",
      "ACI CODE-318-25 SI 19.3 and 20.5",
      "ACI CODE-318-25 SI 24.1 and 24.2; ACI 318.2-14 section 6.1.7"
    ),
    demandValue = c(
      rep(Minimum$requiredAreaPerDirectionMm2, 2L),
      MaximumOppositeFaceDifference,
      3000 * 0.006894757293168,
      rep(NA_real_, 7L)
    ),
    capacityValue = c(
      MinimumProvided,
      0,
      compressiveStrengthMPa,
      rep(NA_real_, 7L)
    ),
    unit = c(rep("mm2/m", 3L), "MPa", rep("-", 7L)),
    utilization = c(
      Minimum$requiredAreaPerDirectionMm2 / MinimumProvided,
      NA_real_,
      (3000 * 0.006894757293168) / compressiveStrengthMPa,
      rep(NA_real_, 7L)
    ),
    applicabilityStatus = "applicable",
    calculationStatus = c(rep("calculated", 4L), rep("not-evaluated", 7L)),
    checkStatus = c(
      MinimumStatus,
      if (
        Minimum$circumferentialFaceEqualityStatus == "satisfied" &&
          Minimum$orthogonalFaceEqualityStatus == "satisfied"
      ) "satisfied" else "not-satisfied",
      if (compressiveStrengthMPa >= 3000 * 0.006894757293168) {
        "satisfied"
      } else {
        "not-satisfied"
      },
      rep("blocked", 7L)
    ),
    blockReason = c(
      rep("", 4L),
      "longitudinal-boundary-condition-not-characterized",
      "reinforced-one-way-shear-not-implemented",
      "reinforcement-detailing-and-development-not-evaluated",
      "aci-318.2-25-operative-text-required",
      "global-shell-stability-not-evaluated",
      "exposure-classes-not-provided",
      "service-combination-and-crack-model-not-provided"
    ),
    stringsAsFactors = FALSE
  )
  if (longitudinalBoundaryConditionID == "plane-stress-free-ends") {
    Index <- GateChecks$checkID == "longitudinal-action"
    GateChecks$calculationStatus[Index] <- "calculated"
    GateChecks$checkStatus[Index] <- "satisfied"
    GateChecks$blockReason[Index] <- ""
  }
  Failed <- any(RowChecks$checkStatus == "not-satisfied") ||
    any(GateChecks$checkStatus == "not-satisfied")
  LocalStatus <- if (any(RowChecks$checkStatus == "not-satisfied")) {
    "not-satisfied"
  } else if (any(RowChecks$checkStatus == "not-evaluated-convergence")) {
    "not-evaluated"
  } else {
    "satisfied"
  }
  NormativeStatus <- if (Failed) {
    "not-satisfied"
  } else if (any(GateChecks$checkStatus == "blocked")) {
    "not-evaluated"
  } else {
    "satisfied"
  }
  Governing <- which.max(Checks$utilization)
  ConvergenceTolerance <- unique(Demand$convergenceTolerance)
  StrengthReductionRuleID <- unique(
    Domains$refined$strengthReductionRuleID
  )
  SourceLocator <- unique(Domains$refined$sourceLocator)
  if (length(ConvergenceTolerance) != 1L ||
      length(StrengthReductionRuleID) != 1L ||
      length(SourceLocator) != 1L ||
      !grepl("axial-limit", StrengthReductionRuleID, fixed = TRUE)) {
    stop("The ACI numerical-control identity is incomplete.", call. = FALSE)
  }
  Controls <- data.frame(
    standardID = "ACI-318-25",
    controlID = "local-strength-numerical-control",
    convergenceRelativeDifference = max(
      Demand$convergenceRelativeDifference
    ),
    convergenceTolerance = ConvergenceTolerance,
    convergenceStatus = if (all(
      Demand$convergenceStatus == "satisfied"
    )) "satisfied" else "not-satisfied",
    strengthReductionRuleID = StrengthReductionRuleID,
    strengthReductionStatus = "applied",
    axialLimitStatus = "applied",
    sourceLocator = SourceLocator,
    stringsAsFactors = FALSE
  )
  Domain <- Domains[["refined", exact = TRUE]]
  InteractionDomain <- data.frame(
    domainPointIndex = seq_len(nrow(Domain)),
    axialStrengthKnPerM = Domain$axialStrengthN / 1000 / StripWidthM,
    bendingStrengthKnMPerM =
      Domain$bendingStrengthNmm / 1e6 / StripWidthM,
    nominalAxialStrengthKnPerM =
      Domain$nominalAxialStrengthN / 1000 / StripWidthM,
    nominalBendingStrengthKnMPerM =
      Domain$nominalBendingStrengthNmm / 1e6 / StripWidthM,
    strengthReductionFactor = Domain$strengthReductionFactor,
    stateID = Domain$stateID,
    compressionFaceID = Domain$compressionFaceID,
    netTensileStrain = Domain$netTensileStrain,
    domainPrimitiveID = Domain$domainPrimitiveID,
    provisionID = Domain$provisionID,
    designBasisID = Domain$designBasisID,
    strengthReductionRuleID = Domain$strengthReductionRuleID,
    sourceLocator = Domain$sourceLocator,
    stringsAsFactors = FALSE
  )
  InteractionDemands <- data.frame(
    thetaIndex = seq_len(nrow(actions)),
    thetaRad = actions$thetaRad,
    thetaDeg = actions$thetaDeg,
    combinationID = actions$combinationID,
    stageID = actions$stageID,
    forceEffectStatus = actions$forceEffectStatus,
    interfaceID = actions$interfaceID,
    axialDemandKnPerM = Demand$axialDemandN / 1000 / StripWidthM,
    bendingDemandKnMPerM = Demand$bendingDemandNmm / 1e6 / StripWidthM,
    radialCapacityMultiplier = Demand$radialCapacityMultiplier,
    radialUtilization = Demand$radialUtilization,
    domainPositionID = Demand$domainPositionID,
    convergenceRelativeDifference = Demand$convergenceRelativeDifference,
    convergenceStatus = Demand$convergenceStatus,
    checkStatus = Demand$localStrengthStatus,
    stringsAsFactors = FALSE
  )
  list(
    actions = actions,
    rowChecks = RowChecks,
    checks = Checks,
    gateChecks = GateChecks,
    controls = Controls,
    minimumReinforcement = Minimum,
    interactionDiagram = list(
      domain = InteractionDomain,
      demands = InteractionDemands
    ),
    summary = data.frame(
      standardSetID =
        "aci-318.2-14-aci-318-25-reinforced-flexure",
      concreteTypeID = "reinforced-concrete",
      localStrengthStatus = LocalStatus,
      normativeStatus = NormativeStatus,
      governingCheckID = Checks$checkID[Governing],
      governingUtilization = Checks$utilization[Governing],
      structuralClassificationID = "thin-shell",
      plainConcretePermissionBasisID = "not-applicable",
      seismicDesignCategoryID = seismicDesignCategoryID,
      jointingStatus = jointingStatus,
      openingStatus = openingStatus,
      stringsAsFactors = FALSE
    )
  )
}
