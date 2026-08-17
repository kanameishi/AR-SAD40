# Mechanical P-M reproduction of the official ACI E702.4-21 example.
#
# The adapter implements the rectangular concrete stress block and the
# strain-dependent strength-reduction factor used by that example. The full
# ACI 318 code basis and the applicable axial-strength limit are not supplied;
# this module therefore returns a diagnostic mechanical utilization only.

calculateAci31819NormalWeightConcreteModulus <- function(
  compressiveStrengthMPa
) {
  ConcreteStrength <- .concretePositiveScalar(
    compressiveStrengthMPa,
    "compressiveStrengthMPa"
  )
  4700 * sqrt(ConcreteStrength) * 1000
}

calculateAci31819Beta1 <- function(compressiveStrengthMPa) {
  ConcreteStrength <- .concretePositiveScalar(
    compressiveStrengthMPa,
    "compressiveStrengthMPa"
  )
  max(0.65, 0.85 - 0.05 * max(ConcreteStrength - 28, 0) / 7)
}

calculateAci31819StrengthReductionFactor <- function(
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

.aci31819NeutralAxisDepths <- function(
  thicknessMm,
  pointCount
) {
  Thickness <- .concretePositiveScalar(thicknessMm, "thicknessMm")
  if (!is.numeric(pointCount) || length(pointCount) != 1L ||
      !is.finite(pointCount) || pointCount != as.integer(pointCount) ||
      pointCount < 101L) {
    stop("pointCount must be one integer of at least 101.", call. = FALSE)
  }
  Thickness * exp(seq(log(1e-6), log(1e3), length.out = as.integer(pointCount)))
}

buildAciE702421ReinforcedSectionDomains <- function(
  thicknessMm,
  stripWidthMm,
  compressiveStrengthMPa,
  reinforcement,
  basePointCount = 601L,
  refinedPointCount = 1201L
) {
  Reinforcement <- .validateConcreteReinforcement(
    reinforcement = reinforcement,
    thicknessMm = thicknessMm
  )
  YieldStrains <- Reinforcement$yieldStrengthMPa /
    Reinforcement$modulusMPa
  if (max(YieldStrains) - min(YieldStrains) > 1e-12) {
    stop(
      paste(
        "All layers must use one reinforcement yield strain in this",
        "ACI 318-19 adapter."
      ),
      call. = FALSE
    )
  }
  if (refinedPointCount <= basePointCount) {
    stop("refinedPointCount must exceed basePointCount.", call. = FALSE)
  }
  YieldStrain <- YieldStrains[1L]
  Reduction <- function(NetTensileStrain) {
    calculateAci31819StrengthReductionFactor(
      netTensileStrain = NetTensileStrain,
      reinforcementYieldStrain = YieldStrain
    )
  }
  Beta <- calculateAci31819Beta1(compressiveStrengthMPa)
  buildDomain <- function(PointCount) {
    buildConcreteSectionDomain(
      thicknessMm = thicknessMm,
      stripWidthMm = stripWidthMm,
      compressiveStrengthMPa = compressiveStrengthMPa,
      reinforcement = Reinforcement,
      concreteMaximumStrain = 0.003,
      concreteStressFactor = 0.85,
      beta1 = Beta,
      strengthReductionFactor = Reduction,
      neutralAxisDepthsMm = .aci31819NeutralAxisDepths(
        thicknessMm = thicknessMm,
        pointCount = PointCount
      ),
      provisionID = "ACI-E702.4-21-mechanical-reproduction",
      designBasisID = "factored-sectional-strain-compatibility",
      strengthReductionRuleID = "ACI-E702.4-21-example-phi-rule",
      sourceLocator = paste(
        "ACI E702.4-21 pp. 6-7; ACI 318-19 secs. 21.2.2,",
        "22.2.1.1 and 22.2.2"
      )
    )
  }
  list(
    base = buildDomain(basePointCount),
    refined = buildDomain(refinedPointCount),
    beta1 = Beta,
    reinforcementYieldStrain = YieldStrain,
    standardID = "ACI-E702.4-21",
    referenceStandardID = "ACI-318-19",
    scopeID = "mechanical-sectional-P-M-reproduction",
    codeBasisStatus = "incomplete",
    axialLimitStatus = "not-applied"
  )
}

checkAci318214ShellReinforcement <- function(
  thicknessMm,
  stripWidthMm,
  circumferentialAreaMm2,
  orthogonalAreaMm2 = NA_real_,
  reinforcementGradeID
) {
  Thickness <- .concretePositiveScalar(thicknessMm, "thicknessMm")
  Width <- .concretePositiveScalar(stripWidthMm, "stripWidthMm")
  if (!is.numeric(circumferentialAreaMm2) ||
      length(circumferentialAreaMm2) != 1L ||
      !is.finite(circumferentialAreaMm2) ||
      circumferentialAreaMm2 < 0) {
    stop(
      "circumferentialAreaMm2 must be one nonnegative finite number.",
      call. = FALSE
    )
  }
  CircumferentialArea <- as.numeric(circumferentialAreaMm2)
  .concreteTextScalar(reinforcementGradeID, "reinforcementGradeID")
  Ratio <- switch(
    reinforcementGradeID,
    "Grade-60" = 0.0018,
    "Grade-40" = 0.0020,
    stop(
      "reinforcementGradeID must be Grade-60 or Grade-40.",
      call. = FALSE
    )
  )
  if (!is.numeric(orthogonalAreaMm2) || length(orthogonalAreaMm2) != 1L ||
      (!is.na(orthogonalAreaMm2) &&
        (!is.finite(orthogonalAreaMm2) || orthogonalAreaMm2 < 0))) {
    stop(
      "orthogonalAreaMm2 must be one nonnegative number or NA.",
      call. = FALSE
    )
  }
  RequiredArea <- Ratio * Thickness * Width
  CircumferentialStatus <- if (
    CircumferentialArea >= RequiredArea
  ) "satisfied" else "not-satisfied"
  OrthogonalStatus <- if (is.na(orthogonalAreaMm2)) {
    "unknown"
  } else if (orthogonalAreaMm2 >= RequiredArea) {
    "satisfied"
  } else {
    "not-satisfied"
  }
  data.frame(
    reinforcementGradeID = reinforcementGradeID,
    minimumRatio = Ratio,
    requiredAreaMm2 = RequiredArea,
    circumferentialAreaMm2 = CircumferentialArea,
    circumferentialStatus = CircumferentialStatus,
    orthogonalAreaMm2 = orthogonalAreaMm2,
    orthogonalStatus = OrthogonalStatus,
    minimumReinforcementStatus = if (
      CircumferentialStatus == "not-satisfied" ||
        OrthogonalStatus == "not-satisfied"
    ) {
      "not-satisfied"
    } else if (OrthogonalStatus == "unknown") {
      "incomplete"
    } else {
      "satisfied"
    },
    standardID = "ACI-318.2-14",
    editionStatus = "historical",
    scopeID = "minimum-shell-reinforcement-only",
    sourceLocator = "section 6.1.3, printed p. 9",
    stringsAsFactors = FALSE
  )
}

evaluateAciE702421SectionDemand <- function(
  normalForceKnPerM,
  bendingMomentKnMPerM,
  stripWidthM,
  sectionDomains,
  forceEffectStatus,
  convergenceTolerance = 1e-3
) {
  if (!is.list(sectionDomains) ||
      is.null(sectionDomains$base) ||
      is.null(sectionDomains$refined) ||
      !identical(sectionDomains$standardID, "ACI-E702.4-21") ||
      !identical(
        sectionDomains$scopeID,
        "mechanical-sectional-P-M-reproduction"
      ) ||
      !identical(sectionDomains$codeBasisStatus, "incomplete") ||
      !identical(sectionDomains$axialLimitStatus, "not-applied")) {
    stop(
      paste(
        "sectionDomains must be returned by",
        "buildAciE702421ReinforcedSectionDomains()."
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
    relativeTolerance = convergenceTolerance
  )
  OUT$sectionalAssessmentStatus <- ifelse(
    OUT$convergenceStatus != "satisfied",
    "not-evaluated-convergence",
    "not-evaluated-code-basis"
  )
  OUT$standardID <- sectionDomains$standardID
  OUT$referenceStandardID <- sectionDomains$referenceStandardID
  OUT$scopeID <- sectionDomains$scopeID
  OUT$codeBasisStatus <- sectionDomains$codeBasisStatus
  OUT$axialLimitStatus <- sectionDomains$axialLimitStatus
  OUT
}
