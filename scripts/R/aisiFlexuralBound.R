# Calculate an upper bound for prescribed AISI S100 flexural routes.
#
# The section is symmetric about the bending axis and its properties are
# expressed per unit projected width. The result is a one-sided screen: an
# exceedance rules out the prescribed Chapter F routes, while a value below
# the bound does not establish capacity.

.aisiPositiveScalar <- function(value, name) {
  if (!is.numeric(value) || length(value) != 1L || !is.finite(value) ||
      value <= 0) {
    stop(name, " must be one positive finite number.", call. = FALSE)
  }
  as.numeric(value)
}

screenAisiFlexuralDemand <- function(
  bendingMomentKnMPerM,
  areaMm2PerMm,
  inertiaMm4PerMm,
  sectionModulusMm3PerMm,
  yieldStrengthMPa
) {
  if (!is.numeric(bendingMomentKnMPerM) ||
      length(bendingMomentKnMPerM) == 0L ||
      any(!is.finite(bendingMomentKnMPerM))) {
    stop(
      "bendingMomentKnMPerM must contain finite numbers.",
      call. = FALSE
    )
  }
  Area <- .aisiPositiveScalar(areaMm2PerMm, "areaMm2PerMm")
  Inertia <- .aisiPositiveScalar(inertiaMm4PerMm, "inertiaMm4PerMm")
  SectionModulus <- .aisiPositiveScalar(
    sectionModulusMm3PerMm,
    "sectionModulusMm3PerMm"
  )
  YieldStrength <- .aisiPositiveScalar(
    yieldStrengthMPa,
    "yieldStrengthMPa"
  )

  FiberDistance <- Inertia / SectionModulus
  PlasticModulusBound <- Area * FiberDistance
  ReserveBound <- 1.25 * SectionModulus * YieldStrength / 1000
  PlasticBound <- PlasticModulusBound * YieldStrength / 1000
  NominalBound <- max(ReserveBound, PlasticBound)
  Ratio <- abs(bendingMomentKnMPerM) / NominalBound
  BoundBasisID <- if (PlasticBound > ReserveBound) {
    "plastic-geometric"
  } else if (ReserveBound > PlasticBound) {
    "inelastic-reserve"
  } else {
    "coincident"
  }

  data.frame(
    bendingMomentKnMPerM = as.numeric(bendingMomentKnMPerM),
    absoluteMomentKnMPerM = abs(bendingMomentKnMPerM),
    extremeFiberDistanceMm = FiberDistance,
    plasticModulusBoundMm3PerMm = PlasticModulusBound,
    reserveBoundKnMPerM = ReserveBound,
    plasticBoundKnMPerM = PlasticBound,
    nominalBoundKnMPerM = NominalBound,
    boundBasisID = BoundBasisID,
    demandBoundRatio = Ratio,
    screenStatus = ifelse(
      Ratio > 1,
      "prescriptive-bound-exceeded",
      "inconclusive"
    ),
    stringsAsFactors = FALSE
  )
}
