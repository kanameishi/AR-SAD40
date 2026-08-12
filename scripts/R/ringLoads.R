# Load models and source adapters for the direct circular-ring solver.
#
# This file deliberately separates three evidence levels:
#   published  : equation or table reproduced from the cited source;
#   derived    : transparent mapping into Pr(theta), Pt(theta);
#   assumption : analyst-selected scenario that must be documented upstream.
#
# Use one consistent force-length system. The examples use kN, m and kPa.

if (!exists("newRingLoad", mode = "function")) {
  stop("Source scripts/R/ringDirect.R before scripts/R/ringLoads.R.", call. = FALSE)
}

# FHWA NHI-05-037, Section 5.4.9, Eq. 5.38 (Jaky relationship).
k0NormallyConsolidated <- function(frictionAngleDeg) {
  .assertFiniteScalar(frictionAngleDeg, "frictionAngleDeg", minimum = 0)
  if (frictionAngleDeg >= 90) {
    stop("frictionAngleDeg must be less than 90 degrees.", call. = FALSE)
  }
  1 - sin(frictionAngleDeg * pi / 180)
}

# FHWA NHI-05-037, Section 5.4.9, Eq. 5.37.
k0ElasticConfined <- function(poissonRatio) {
  .assertFiniteScalar(poissonRatio, "poissonRatio", minimum = 0)
  if (poissonRatio >= 0.5) {
    stop("poissonRatio must be less than 0.5.", call. = FALSE)
  }
  poissonRatio / (1 - poissonRatio)
}

# Mayne and Kulhawy (1982), Eqs. 11-12. The Rankine coefficient is used
# only to identify the limit of the at-rest unloading relationship.
checkK0PassiveDomain <- function(frictionAngleDeg, ocrMaximum) {
  .assertFiniteScalar(
    frictionAngleDeg,
    "frictionAngleDeg",
    minimum = 0,
    strict = TRUE
  )
  if (frictionAngleDeg >= 90) {
    stop("frictionAngleDeg must be less than 90 degrees.", call. = FALSE)
  }
  .assertFiniteScalar(ocrMaximum, "ocrMaximum", minimum = 1)

  FrictionSine <- sin(frictionAngleDeg * pi / 180)
  if (FrictionSine >= 1) {
    stop(
      "frictionAngleDeg is too close to 90 degrees for finite evaluation.",
      call. = FALSE
    )
  }

  PassiveCoefficient <- (1 + FrictionSine) / (1 - FrictionSine)
  OcrLimit <- exp(
    (log1p(FrictionSine) - 2 * log1p(-FrictionSine)) / FrictionSine
  )
  Valid <- ocrMaximum < OcrLimit

  list(
    valid = Valid,
    domainStatus = if (Valid) {
      "withinDomain"
    } else {
      "passiveLimitReached"
    },
    passiveCoefficient = PassiveCoefficient,
    ocrLimit = OcrLimit
  )
}

# Mayne and Kulhawy (1982), Eq. 10: primary unloading from virgin
# compression. The function rejects the passive limit instead of clipping K0.
k0MayneKulhawyUnloading <- function(frictionAngleDeg, ocr) {
  .assertFiniteScalar(ocr, "ocr", minimum = 1)
  Domain <- checkK0PassiveDomain(frictionAngleDeg, ocr)
  if (!Domain$valid) {
    stop(
      "ocr reaches the passive limit of the at-rest unloading relationship.",
      call. = FALSE
    )
  }

  BaseK0 <- k0NormallyConsolidated(frictionAngleDeg)
  FrictionSine <- 1 - BaseK0
  BaseK0 * ocr^FrictionSine
}

# Mayne and Kulhawy (1982), Eq. 18. FHWA NHI-05-037 Eq. 5.39 omits
# the complement in the second term and is not implemented here.
k0MayneKulhawyReload <- function(frictionAngleDeg, ocr, ocrMaximum) {
  .assertFiniteScalar(ocr, "ocr", minimum = 1)
  .assertFiniteScalar(ocrMaximum, "ocrMaximum", minimum = 1)
  if (ocr > ocrMaximum) {
    stop("ocr must not exceed ocrMaximum during reloading.", call. = FALSE)
  }

  Domain <- checkK0PassiveDomain(frictionAngleDeg, ocrMaximum)
  if (!Domain$valid) {
    stop(
      paste0(
        "ocrMaximum reaches the passive limit of the at-rest ",
        "unloading-reloading relationship."
      ),
      call. = FALSE
    )
  }

  BaseK0 <- k0NormallyConsolidated(frictionAngleDeg)
  FrictionSine <- 1 - BaseK0
  BaseK0 * (
    ocr / ocrMaximum^(1 - FrictionSine) +
      3 / 4 * (1 - ocr / ocrMaximum)
  )
}

layeredEffectiveVerticalStress <- function(
  depth,
  layerBottom,
  effectiveUnitWeight,
  effectiveSurcharge = 0
) {
  if (!is.numeric(depth) || length(depth) == 0L ||
      any(!is.finite(depth)) || any(depth < 0)) {
    stop("depth must be a finite, non-negative numeric vector.", call. = FALSE)
  }
  FiniteBottom <- utils::head(layerBottom, -1L)
  if (!is.numeric(layerBottom) || length(layerBottom) == 0L ||
      any(is.na(layerBottom)) || any(layerBottom <= 0) ||
      !is.infinite(utils::tail(layerBottom, 1L)) ||
      any(!is.finite(FiniteBottom)) ||
      (length(FiniteBottom) > 1L && any(diff(FiniteBottom) <= 0))) {
    stop(
      "layerBottom must increase strictly, remain positive, and end at Inf.",
      call. = FALSE
    )
  }
  if (!is.numeric(effectiveUnitWeight) ||
      length(effectiveUnitWeight) != length(layerBottom) ||
      any(!is.finite(effectiveUnitWeight)) ||
      any(effectiveUnitWeight < 0)) {
    stop(
      "effectiveUnitWeight must be finite, non-negative, and match layerBottom.",
      call. = FALSE
    )
  }
  .assertFiniteScalar(effectiveSurcharge, "effectiveSurcharge", minimum = 0)

  LayerTop <- c(0, utils::head(layerBottom, -1L))
  vapply(depth, function(CurrentDepth) {
    Thickness <- pmax(0, pmin(CurrentDepth, layerBottom) - LayerTop)
    effectiveSurcharge + sum(Thickness * effectiveUnitWeight)
  }, numeric(1))
}

ringVerticalStressOrdinates <- function(
  coverCrown,
  radius,
  layerBottom,
  effectiveUnitWeight,
  effectiveSurcharge = 0,
  waterTableDepth = Inf,
  waterUnitWeight = 9.81
) {
  .assertFiniteScalar(coverCrown, "coverCrown", minimum = 0)
  .assertFiniteScalar(radius, "radius", minimum = 0, strict = TRUE)
  if (!is.numeric(waterTableDepth) || length(waterTableDepth) != 1L ||
      is.na(waterTableDepth) || waterTableDepth < 0) {
    stop("waterTableDepth must be one non-negative value or Inf.", call. = FALSE)
  }
  .assertFiniteScalar(waterUnitWeight, "waterUnitWeight", minimum = 0)

  Depth <- coverCrown + c(0, radius, 2 * radius)
  Effective <- layeredEffectiveVerticalStress(
    depth = Depth,
    layerBottom = layerBottom,
    effectiveUnitWeight = effectiveUnitWeight,
    effectiveSurcharge = effectiveSurcharge
  )
  Pore <- if (is.infinite(waterTableDepth)) {
    rep(0, length(Depth))
  } else {
    waterUnitWeight * pmax(0, Depth - waterTableDepth)
  }

  data.frame(
    location = c("crown", "axis", "invert"),
    depth = Depth,
    effectiveVertical = Effective,
    porePressure = Pore,
    totalVertical = Effective + Pore,
    stringsAsFactors = FALSE
  )
}

k0TensorLoad <- function(
  effectiveVertical,
  k0,
  porePressure = 0,
  horizontalIncrement = 0,
  interface = c("fullTraction", "normalOnly")
) {
  .assertFiniteScalar(effectiveVertical, "effectiveVertical", minimum = 0)
  .assertFiniteScalar(k0, "k0", minimum = 0)
  .assertFiniteScalar(porePressure, "porePressure", minimum = 0)
  .assertFiniteScalar(horizontalIncrement, "horizontalIncrement", minimum = 0)
  Interface <- match.arg(interface)

  EffectiveHorizontal <- k0 * effectiveVertical + horizontalIncrement
  MeanPressure <- porePressure +
    (effectiveVertical + EffectiveHorizontal) / 2
  Difference <- effectiveVertical - EffectiveHorizontal
  Tangential <- if (Interface == "fullTraction") {
    function(theta) Difference * sin(2 * theta) / 2
  } else {
    function(theta) rep(0, length(theta))
  }

  newRingLoad(
    radial = function(theta) {
      -MeanPressure - Difference * cos(2 * theta) / 2
    },
    tangential = Tangential,
    label = paste("K0 tensor projection -", Interface),
    source = "derived from a constant biaxial total-stress tensor",
    representation = Interface,
    metadata = list(
      evidenceLevel = "derived",
      effectiveVertical = effectiveVertical,
      effectiveHorizontal = EffectiveHorizontal,
      porePressure = porePressure,
      horizontalIncrement = horizontalIncrement
    )
  )
}

# Projection of a prescribed biaxial effective-stress state on the circular
# boundary. The horizontal stress is supplied explicitly so downstream
# actions do not have to reconstruct K0.
biaxialStressTangentialMultiplierLoad <- function(
  effectiveVertical,
  effectiveHorizontal,
  waterPressureDifference = 0,
  tangentialMultiplier
) {
  .assertFiniteScalar(effectiveVertical, "effectiveVertical", minimum = 0)
  .assertFiniteScalar(effectiveHorizontal, "effectiveHorizontal", minimum = 0)
  .assertFiniteScalar(waterPressureDifference, "waterPressureDifference")
  .assertFiniteScalar(
    tangentialMultiplier,
    "tangentialMultiplier",
    minimum = 0
  )
  if (tangentialMultiplier > 1) {
    stop(
      "tangentialMultiplier must not exceed 1.",
      call. = FALSE
    )
  }

  EffectiveMean <- (effectiveVertical + effectiveHorizontal) / 2
  Difference <- effectiveVertical - effectiveHorizontal

  newRingLoad(
    radial = function(theta) {
      -waterPressureDifference - EffectiveMean -
        Difference * cos(2 * theta) / 2
    },
    tangential = function(theta) {
      tangentialMultiplier * Difference * sin(2 * theta) / 2
    },
    label = paste0(
      "Biaxial stress field with tangential multiplier alpha = ",
      format(tangentialMultiplier, trim = TRUE)
    ),
    source = "derived projection of a prescribed biaxial stress state",
    representation = "scaledTangentialProjection",
    metadata = list(
      evidenceLevel = "assumption",
      effectiveVertical = effectiveVertical,
      effectiveHorizontal = effectiveHorizontal,
      waterPressureDifference = waterPressureDifference,
      tangentialMultiplier = tangentialMultiplier,
      tangentialReference = "biaxial stress projection"
    )
  )
}

# Analyst-selected fraction of the projected tangential component.
#
# This is a prescribed-load model.  It does not solve interface slip or a
# friction law.  tangentialMultiplier = 0 omits the tangential component and
# tangentialMultiplier = 1 applies the complete projected component.
k0TangentialMultiplierLoad <- function(
  effectiveVertical,
  k0,
  porePressure = 0,
  horizontalIncrement = 0,
  tangentialMultiplier
) {
  .assertFiniteScalar(effectiveVertical, "effectiveVertical", minimum = 0)
  .assertFiniteScalar(k0, "k0", minimum = 0)
  .assertFiniteScalar(porePressure, "porePressure", minimum = 0)
  .assertFiniteScalar(horizontalIncrement, "horizontalIncrement", minimum = 0)
  .assertFiniteScalar(
    tangentialMultiplier,
    "tangentialMultiplier",
    minimum = 0
  )
  if (tangentialMultiplier > 1) {
    stop(
      "tangentialMultiplier must not exceed 1.",
      call. = FALSE
    )
  }

  EffectiveHorizontal <- k0 * effectiveVertical + horizontalIncrement
  Load <- biaxialStressTangentialMultiplierLoad(
    effectiveVertical = effectiveVertical,
    effectiveHorizontal = EffectiveHorizontal,
    waterPressureDifference = porePressure,
    tangentialMultiplier = tangentialMultiplier
  )
  Load$label <- sub("Biaxial", "K0", Load$label, fixed = TRUE)
  Load$source <- "derived stress projection with analyst-selected multiplier"
  Load$metadata$k0 <- k0
  Load$metadata$horizontalIncrement <- horizontalIncrement
  Load
}

solveBiaxialTangentialMultiplierClosed <- function(
  effectiveVertical,
  effectiveHorizontal,
  waterPressureDifference,
  radius,
  tangentialMultiplier,
  theta = (0:720) * 2 * pi / 721,
  sectionRatio = 0
) {
  .assertFiniteScalar(radius, "radius", minimum = 0, strict = TRUE)
  .assertFiniteScalar(sectionRatio, "sectionRatio", minimum = 0)
  .assertTheta(theta)
  Load <- biaxialStressTangentialMultiplierLoad(
    effectiveVertical = effectiveVertical,
    effectiveHorizontal = effectiveHorizontal,
    waterPressureDifference = waterPressureDifference,
    tangentialMultiplier = tangentialMultiplier
  )
  MeanPressure <- waterPressureDifference +
    (effectiveVertical + effectiveHorizontal) / 2
  Difference <- effectiveVertical - effectiveHorizontal
  Factors <- c(
    normal = (1 + 2 * tangentialMultiplier) / 6,
    moment = (2 + tangentialMultiplier) / 12,
    shear = (2 + tangentialMultiplier) / 6
  )
  MeanNormal <- -radius * MeanPressure
  UniformCoupling <- radius * sectionRatio / (1 + sectionRatio)
  MeanMoment <- UniformCoupling * MeanNormal

  Values <- data.frame(
    theta = theta,
    thetaDeg = theta * 180 / pi,
    normalForce = MeanNormal +
      radius * Difference * Factors["normal"] * cos(2 * theta),
    bendingMoment = MeanMoment +
      radius^2 * Difference * Factors["moment"] * cos(2 * theta),
    shearForce = -radius * Difference * Factors["shear"] * sin(2 * theta)
  )
  Result <- list(
    values = Values,
    diagnostics = list(
      valid = TRUE,
      balanceMetric = 0,
      balanceTolerance = 0,
      globalLoads = c(forceX = 0, forceZ = 0, momentCenter = 0),
      normalizedGlobalLoads = c(forceX = 0, forceZ = 0, momentCenter = 0),
      closureResidual = c(normalForce = 0, shearForce = 0, bendingMoment = 0),
      normalizedClosureResidual = c(
        normalForce = 0,
        shearForce = 0,
        bendingMoment = 0
      ),
      expectedClosureResidual = c(
        normalForce = 0,
        shearForce = 0,
        bendingMoment = 0
      ),
      closureConsistencyResidual = c(
        normalForce = 0,
        shearForce = 0,
        bendingMoment = 0
      ),
      normalizedClosureConsistencyResidual = c(
        normalForce = 0,
        shearForce = 0,
        bendingMoment = 0
      ),
      globalBalanceMetric = 0,
      closureMetric = 0,
      residualType = "none",
      characteristicPressure = max(
        abs(waterPressureDifference + effectiveVertical),
        abs(waterPressureDifference + effectiveHorizontal)
      ),
      compatibility = c(
        momentCosOne = 0,
        momentSinOne = 0,
        meanMomentMinusCoupledMeanNormal = 0
      ),
      integrationSteps = 0L,
      meshPoints = length(theta),
      sectionRatio = sectionRatio,
      exact = TRUE
    ),
    load = Load,
    radius = radius,
    sectionRatio = sectionRatio
  )
  class(Result) <- "ringDirectResponse"
  Result
}

solveK0Closed <- function(
  effectiveVertical,
  k0,
  porePressure,
  radius,
  theta = (0:720) * 2 * pi / 721,
  interface = c("fullTraction", "normalOnly"),
  horizontalIncrement = 0,
  sectionRatio = 0
) {
  Interface <- match.arg(interface)
  solveBiaxialTangentialMultiplierClosed(
    effectiveVertical = effectiveVertical,
    effectiveHorizontal = k0 * effectiveVertical + horizontalIncrement,
    waterPressureDifference = porePressure,
    radius = radius,
    tangentialMultiplier = if (Interface == "fullTraction") 1 else 0,
    theta = theta,
    sectionRatio = sectionRatio
  )
}

usaceCrownPressure <- function(unitWeight, coverCrown) {
  .assertFiniteScalar(unitWeight, "unitWeight", minimum = 0)
  .assertFiniteScalar(coverCrown, "coverCrown", minimum = 0)
  unitWeight * coverCrown
}

usaceCmpThrust <- function(
  deadCrownPressure,
  span,
  deadLoadFactor,
  demandModifier,
  factorBasis,
  liveCrownPressure = 0,
  liveLoadedWidth = 0,
  liveDistributionFactor = 0,
  liveLoadFactor = 0
) {
  .assertFiniteScalar(deadCrownPressure, "deadCrownPressure", minimum = 0)
  .assertFiniteScalar(span, "span", minimum = 0, strict = TRUE)
  .assertFiniteScalar(deadLoadFactor, "deadLoadFactor", minimum = 0)
  .assertFiniteScalar(demandModifier, "demandModifier", minimum = 0)
  .assertFiniteScalar(liveCrownPressure, "liveCrownPressure", minimum = 0)
  .assertFiniteScalar(liveLoadedWidth, "liveLoadedWidth", minimum = 0)
  .assertFiniteScalar(
    liveDistributionFactor,
    "liveDistributionFactor",
    minimum = 0
  )
  .assertFiniteScalar(liveLoadFactor, "liveLoadFactor", minimum = 0)
  .assertText(factorBasis, "factorBasis")
  LiveValues <- unname(c(
    liveCrownPressure,
    liveLoadedWidth,
    liveDistributionFactor,
    liveLoadFactor
  ))
  if (!all(LiveValues == 0) && any(LiveValues <= 0)) {
    stop("All live-load inputs must be positive, or all must be zero.", call. = FALSE)
  }

  DeadService <- deadCrownPressure * span / 2
  LiveService <- liveCrownPressure * liveLoadedWidth *
    liveDistributionFactor / 2
  Factored <- deadLoadFactor * DeadService + liveLoadFactor * LiveService

  structure(list(
    source = "USACE EM 1110-2-2902 (2020)",
    sourceLocation = "Eq. 4-20, printed p. 86/PDF p. 100",
    evidenceLevel = "published scalar equation",
    factorBasis = factorBasis,
    warning = paste(
      "EM 1110-2-2902 is internally inconsistent:",
      "Table 4-4 gives 1.50 while Eq. 4-20 gives 1.95;",
      "Eq. 4-21 gives 1.05 while Appendix D4 uses 1.10."
    ),
    span = span,
    equivalentRadius = span / 2,
    deadCrownPressure = deadCrownPressure,
    deadServiceThrust = DeadService,
    liveServiceThrust = LiveService,
    factoredThrust = Factored,
    designDemand = demandModifier * Factored,
    angularTractionPublished = FALSE,
    momentPublished = FALSE,
    shearPublished = FALSE
  ), class = "usaceCmpThrust")
}

usaceUniformSurrogate <- function(
  thrust,
  quantity = c("deadServiceThrust", "factoredThrust", "designDemand")
) {
  if (!inherits(thrust, "usaceCmpThrust")) {
    stop("thrust must be returned by usaceCmpThrust().", call. = FALSE)
  }
  Quantity <- match.arg(quantity)
  Pressure <- thrust[[Quantity]] / thrust$equivalentRadius

  newRingLoad(
    radial = function(theta) rep(-Pressure, length(theta)),
    label = paste("USACE uniform surrogate -", Quantity),
    source = thrust$source,
    representation = "derived uniform pressure with the same scalar thrust",
    metadata = list(
      evidenceLevel = "derived",
      sourceLocation = thrust$sourceLocation,
      scalarQuantity = Quantity,
      targetCompression = thrust[[Quantity]],
      equivalentRadius = thrust$equivalentRadius,
      requiredRadius = thrust$equivalentRadius,
      limitation = "USACE does not publish this angular pressure field"
    )
  )
}

fhwaCompactionPressure <- function(
  compactorForceKn,
  looseFrictionAngleDeg,
  centroidalDiameterMm
) {
  .assertFiniteScalar(compactorForceKn, "compactorForceKn", minimum = 0)
  .assertFiniteScalar(
    looseFrictionAngleDeg,
    "looseFrictionAngleDeg",
    minimum = 0
  )
  .assertFiniteScalar(
    centroidalDiameterMm,
    "centroidalDiameterMm",
    minimum = 250,
    strict = TRUE
  )
  if (looseFrictionAngleDeg >= 90) {
    stop("looseFrictionAngleDeg must be less than 90 degrees.", call. = FALSE)
  }

  EffectiveForce <- max(compactorForceKn, 4)
  1.3 * EffectiveForce *
    (1 - sin(looseFrictionAngleDeg * pi / 180))^3 *
    (970 / (centroidalDiameterMm - 250))^2
}

.depthCrossingAngles <- function(depth, radius) {
  if (depth <= 0 || depth >= 2 * radius) {
    return(numeric())
  }
  Angle <- acos(1 - depth / radius)
  c(Angle, 2 * pi - Angle)
}

fhwaCompactionBandLoad <- function(
  pressureKpa,
  radiusM,
  fillSurfaceDepthBelowCrownM,
  bandDepthM = 0.300
) {
  .assertFiniteScalar(pressureKpa, "pressureKpa", minimum = 0)
  .assertFiniteScalar(radiusM, "radiusM", minimum = 0, strict = TRUE)
  .assertFiniteScalar(
    fillSurfaceDepthBelowCrownM,
    "fillSurfaceDepthBelowCrownM"
  )
  .assertFiniteScalar(bandDepthM, "bandDepthM", minimum = 0, strict = TRUE)

  Lower <- fillSurfaceDepthBelowCrownM
  Upper <- fillSurfaceDepthBelowCrownM + bandDepthM
  Breakpoints <- sort(unique(c(
    .depthCrossingAngles(Lower, radiusM),
    .depthCrossingAngles(Upper, radiusM),
    if (Lower <= 2 * radiusM && Upper >= 2 * radiusM) pi else numeric()
  )))
  Horizontal <- function(theta) {
    Depth <- radiusM * (1 - cos(theta))
    Active <- Depth >= Lower & Depth <= Upper
    Side <- sign(sin(theta))
    -pressureKpa * Side * Active
  }

  newRingLoad(
    radial = function(theta) Horizontal(theta) * sin(theta),
    tangential = function(theta) Horizontal(theta) * cos(theta),
    label = "FHWA compaction stage band",
    source = "FHWA-RD-98-191 (1999), Eq. 5.1 and Fig. 5.4",
    representation = "derived projection of symmetric horizontal nodal forces",
    breakpoints = Breakpoints,
    metadata = list(
      evidenceLevel = "derived from a published construction-stage model",
      sourceLocation = "printed pp. 173-178/PDF pp. 188-193",
      pressureKpa = pressureKpa,
      fillSurfaceDepthBelowCrownM = fillSurfaceDepthBelowCrownM,
      bandDepthM = bandDepthM,
      publishedBandDepthM = 0.300,
      limitation = paste(
        "Equivalent 2D CANDE pressure calibrated to deformation;",
        "not a measured retained contact pressure"
      )
    )
  )
}

fhwaSuggestedConstrainedModulus <- function() {
  Stress <- c(7, 35, 70, 140, 275, 410)
  Values <- data.frame(
    stressKpa = Stress,
    SW95 = c(13.8, 17.9, 20.7, 23.8, 29.3, 34.5),
    SW90 = c(8.78, 10.3, 11.2, 12.4, 14.5, 17.24),
    SW85 = c(3.24, 3.59, 3.93, 4.48, 5.69, 6.90),
    ML95 = c(9.76, 11.5, 12.2, 13.0, 14.4, 15.9),
    ML90 = c(4.62, 5.10, 5.86, 5.45, 6.21, 7.07),
    ML85 = c(2.48, 2.69, 2.76, 2.97, 3.52, 4.14),
    CL95 = c(3.68, 4.31, 4.76, 5.10, 5.62, 6.17),
    CL90 = c(1.76, 2.21, 2.45, 2.72, 3.07, 3.62),
    CL85 = c(0.90, 1.21, 1.38, 1.59, 1.97, 2.38),
    check.names = FALSE
  )
  attr(Values, "units") <- "MPa"
  attr(Values, "source") <- paste(
    "FHWA-RD-98-191 Table 3.6, printed pp. 70-71/PDF pp. 86-87"
  )
  Values
}

fhwaMetalBurnsRichardBenchmark <- function() {
  data.frame(
    constrainedModulusMpa = c(3.5, 16),
    bendingStiffnessRatioPartA = c(57, 260),
    bendingStiffnessRatioPartB = c(57, 261),
    hoopStiffnessRatio = c(0.005, 0.022),
    crownPressureKpa = c(27, 24),
    springlinePressureKpa = c(19, 22),
    springlineThrustKnM = c(11.39, 10.84),
    crownMomentKnMPerM = c(-0.289, -0.077),
    springlineMomentKnMPerM = c(0.288, 0.076),
    verticalArchingFactor = c(1.05, 1.00),
    sourceLocation = paste(
      "FHWA-RD-98-191 Table 5.1, printed pp. 166-167/PDF pp. 181-182"
    ),
    note = c(
      "Part A and Part B agree",
      "Part A prints SB=260; Part B prints SB=261"
    ),
    stringsAsFactors = FALSE
  )
}

nunezInteractionRatio <- function(
  diameter,
  thickness,
  liningYoungModulus,
  soilYoungModulus,
  liningPoisson,
  soilPoisson,
  contactFactor
) {
  .assertFiniteScalar(diameter, "diameter", minimum = 0, strict = TRUE)
  .assertFiniteScalar(thickness, "thickness", minimum = 0, strict = TRUE)
  .assertFiniteScalar(
    liningYoungModulus,
    "liningYoungModulus",
    minimum = 0,
    strict = TRUE
  )
  .assertFiniteScalar(
    soilYoungModulus,
    "soilYoungModulus",
    minimum = 0,
    strict = TRUE
  )
  .assertFiniteScalar(contactFactor, "contactFactor", minimum = 0, strict = TRUE)
  .assertFiniteScalar(liningPoisson, "liningPoisson")
  .assertFiniteScalar(soilPoisson, "soilPoisson")
  if (liningPoisson <= -1 || liningPoisson >= 0.5 ||
      soilPoisson <= -1 || soilPoisson >= 0.5) {
    stop("Poisson ratios must lie strictly between -1 and 0.5.", call. = FALSE)
  }

  LiningPlaneModulus <- liningYoungModulus / (1 - liningPoisson^2)
  SoilPlaneModulus <- soilYoungModulus / (1 - soilPoisson^2)
  16 * LiningPlaneModulus / (contactFactor * SoilPlaneModulus) *
    (thickness / diameter)^3
}

.validateNunezInputs <- function(
  diameter,
  depthAxis,
  unitWeight,
  surfaceLoad,
  k0,
  relaxation,
  interactionRatio
) {
  .assertFiniteScalar(diameter, "diameter", minimum = 0, strict = TRUE)
  .assertFiniteScalar(depthAxis, "depthAxis", minimum = 0)
  .assertFiniteScalar(unitWeight, "unitWeight", minimum = 0)
  .assertFiniteScalar(surfaceLoad, "surfaceLoad", minimum = 0)
  .assertFiniteScalar(k0, "k0", minimum = 0)
  .assertFiniteScalar(relaxation, "relaxation", minimum = 0)
  .assertFiniteScalar(interactionRatio, "interactionRatio", minimum = 0)
  if (relaxation > 1) {
    stop("relaxation must not exceed 1.", call. = FALSE)
  }
  invisible(NULL)
}

nunez2000CircularResultants <- function(
  diameter,
  depthAxis,
  unitWeight,
  surfaceLoad,
  k0,
  relaxation,
  interactionRatio
) {
  .validateNunezInputs(
    diameter,
    depthAxis,
    unitWeight,
    surfaceLoad,
    k0,
    relaxation,
    interactionRatio
  )

  Vertical <- unitWeight * depthAxis + surfaceLoad
  Differential <- relaxation * (1 - k0) * Vertical
  Fraction <- interactionRatio / (1 + interactionRatio)
  HorizontalReaction <- Differential / (1 + interactionRatio)
  Moment <- Differential * diameter^2 * Fraction / 16
  Crown <- diameter * (k0 * Differential + HorizontalReaction) / 2
  Springline <- diameter * (
    relaxation * unitWeight * depthAxis + surfaceLoad
  ) / 2

  structure(list(
    source = "Nunez (2000)",
    sourceLocation = "circular dry examples, PDF pp. 14-15",
    sourceQuality = "96 dpi scan; circular dry equations are legible",
    evidenceLevel = paste(
      "derived circular dry reduction of the published formulation;",
      "reproduces rounded examples"
    ),
    formulaVersion = "2000 circular dry",
    domain = "excavated NATM tunnel",
    applicableDirectlyToBackfilledPipe = FALSE,
    signConvention = "compression positive",
    verticalGeostatic = Vertical,
    differentialPressure = Differential,
    horizontalReaction = HorizontalReaction,
    interactionRatio = interactionRatio,
    interactionFraction = Fraction,
    momentCrown = Moment,
    normalCrown = Crown,
    normalSpringline = Springline,
    angularTractionPublished = FALSE,
    shearPublished = FALSE,
    versionWarning = paste(
      "The 2000 surface-load/relaxation placement differs from 2014;",
      "do not mix the two normal-force equations"
    )
  ), class = "nunez2000CircularResultants")
}

nunez2014Resultants <- function(
  diameter,
  depthAxis,
  unitWeight,
  surfaceLoad,
  k0,
  relaxation,
  interactionRatio
) {
  .validateNunezInputs(
    diameter,
    depthAxis,
    unitWeight,
    surfaceLoad,
    k0,
    relaxation,
    interactionRatio
  )

  Vertical <- unitWeight * depthAxis + surfaceLoad
  Fraction <- interactionRatio / (1 + interactionRatio)
  Moment <- relaxation * (1 - k0) * Vertical * diameter^2 * Fraction / 16
  Common <- relaxation * diameter * Vertical / 2
  Crown <- Common * (
    k0 + (2 / 3) * (1 - k0) / (1 + interactionRatio)
  ) - k0 * unitWeight * diameter^2 / 12
  Springline <- Common
  Invert <- Common * (
    k0 + (4 / 3) * (1 - k0) / (1 + interactionRatio)
  ) + k0 * unitWeight * diameter^2 / 12

  structure(list(
    source = "Nunez, Sfriso and Laiun (2014)",
    sourceLocation = "Eqs. 22-25, PDF p. 6",
    evidenceLevel = "published point resultants",
    formulaVersion = "2014 Eqs. 22-25",
    domain = "excavated NATM tunnel in stiff Pampeano soil",
    applicableDirectlyToBackfilledPipe = FALSE,
    signConvention = "compression positive",
    verticalGeostatic = Vertical,
    diameter = diameter,
    k0 = k0,
    relaxation = relaxation,
    interactionRatio = interactionRatio,
    interactionFraction = Fraction,
    momentMaximum = Moment,
    normalCrown = Crown,
    normalSpringline = Springline,
    normalInvert = Invert,
    angularTractionPublished = FALSE,
    shearPublished = FALSE
  ), class = "nunez2014Resultants")
}

nunezEquivalentTensorLoad <- function(resultants) {
  if (!inherits(resultants, "nunez2014Resultants")) {
    stop("resultants must be returned by nunez2014Resultants().", call. = FALSE)
  }

  Vertical <- resultants$relaxation * resultants$verticalGeostatic
  Difference <- resultants$interactionFraction * resultants$relaxation *
    (1 - resultants$k0) * resultants$verticalGeostatic
  Horizontal <- Vertical - Difference
  MeanPressure <- (Vertical + Horizontal) / 2

  newRingLoad(
    radial = function(theta) {
      -MeanPressure - Difference * cos(2 * theta) / 2
    },
    tangential = function(theta) Difference * sin(2 * theta) / 2,
    label = "Nunez equivalent tensor surrogate",
    source = resultants$source,
    representation = "derived n=0+n=2 tensor traction",
    metadata = list(
      evidenceLevel = "derived",
      sourceLocation = resultants$sourceLocation,
      reproduces = c(
        "published Mmax",
        "published N at springline",
        "mean of published crown and invert N"
      ),
      doesNotReproduce = c(
        "published crown-invert N difference",
        "a published Q(theta), which does not exist"
      ),
      requiredRadius = resultants$diameter / 2,
      requiredSectionRatio = 0,
      applicableDirectlyToBackfilledPipe = FALSE
    )
  )
}
