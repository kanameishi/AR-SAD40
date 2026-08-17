# Build and evaluate a generic reinforced-concrete P-M section domain.
#
# This file implements sectional compatibility, equilibrium and radial-domain
# geometry. It does not select a concrete code, load combination or complete
# shell verification. A code adapter must supply the material coefficients and
# the strength-reduction rule point by point.

.concretePositiveScalar <- function(value, name) {
  if (!is.numeric(value) || length(value) != 1L || !is.finite(value) ||
      value <= 0) {
    stop(name, " must be one positive finite number.", call. = FALSE)
  }
  as.numeric(value)
}

.concreteTextScalar <- function(value, name) {
  if (!is.character(value) || length(value) != 1L || !nzchar(value)) {
    stop(name, " must be one non-empty string.", call. = FALSE)
  }
  value
}

.concreteClamp <- function(value, lower, upper) {
  pmin(pmax(value, lower), upper)
}

.validateConcreteReinforcement <- function(reinforcement, thicknessMm) {
  if (!is.data.frame(reinforcement)) {
    stop("reinforcement must be one data frame.", call. = FALSE)
  }
  Fields.required <- c(
    "layerID", "areaMm2", "coordinateMm", "yieldStrengthMPa",
    "modulusMPa"
  )
  Fields.missing <- setdiff(Fields.required, names(reinforcement))
  if (length(Fields.missing) > 0L) {
    stop(
      "reinforcement is missing: ",
      paste(Fields.missing, collapse = ", "),
      ".",
      call. = FALSE
    )
  }
  if (nrow(reinforcement) == 0L) {
    stop(
      paste(
        "This reinforced-section constructor requires at least one",
        "reinforcement layer. Use a separate plain-concrete capacity model."
      ),
      call. = FALSE
    )
  }
  if (any(!is.character(reinforcement$layerID) |
      !nzchar(reinforcement$layerID)) ||
      anyDuplicated(reinforcement$layerID)) {
    stop("Reinforcement layer identifiers must be unique.", call. = FALSE)
  }
  Fields.numeric <- c(
    "areaMm2", "coordinateMm", "yieldStrengthMPa", "modulusMPa"
  )
  if (any(!vapply(reinforcement[Fields.numeric], is.numeric, logical(1))) ||
      any(!is.finite(as.matrix(reinforcement[Fields.numeric]))) ||
      any(reinforcement$areaMm2 <= 0) ||
      any(reinforcement$yieldStrengthMPa <= 0) ||
      any(reinforcement$modulusMPa <= 0) ||
      any(abs(reinforcement$coordinateMm) >= thicknessMm / 2)) {
    stop("The reinforcement geometry and properties are invalid.", call. = FALSE)
  }
  reinforcement
}

.concreteReductionFactor <- function(rule, netTensileStrain) {
  Factor <- if (is.function(rule)) {
    rule(netTensileStrain)
  } else {
    rule
  }
  Factor <- .concretePositiveScalar(Factor, "strengthReductionFactor")
  if (Factor > 1) {
    stop("strengthReductionFactor must not exceed one.", call. = FALSE)
  }
  Factor
}

.concreteNumberText <- function(value) {
  paste(format(
    as.numeric(value),
    digits = 17,
    scientific = TRUE,
    trim = TRUE
  ), collapse = ",")
}

.concreteReinforcementSignature <- function(reinforcement) {
  Ordered <- reinforcement[order(reinforcement$layerID), , drop = FALSE]
  paste(vapply(seq_len(nrow(Ordered)), function(i) {
    paste(
      Ordered$layerID[i],
      .concreteNumberText(Ordered$areaMm2[i]),
      .concreteNumberText(Ordered$coordinateMm[i]),
      .concreteNumberText(Ordered$yieldStrengthMPa[i]),
      .concreteNumberText(Ordered$modulusMPa[i]),
      sep = ":"
    )
  }, character(1)), collapse = "|")
}

buildConcreteSectionDomain <- function(
  thicknessMm,
  stripWidthMm,
  compressiveStrengthMPa,
  reinforcement,
  concreteMaximumStrain,
  concreteStressFactor,
  beta1,
  strengthReductionFactor,
  neutralAxisDepthsMm,
  provisionID,
  sourceLocator,
  designBasisID = "sectional-strain-compatibility",
  strengthReductionRuleID = NULL
) {
  Thickness <- .concretePositiveScalar(thicknessMm, "thicknessMm")
  Width <- .concretePositiveScalar(stripWidthMm, "stripWidthMm")
  ConcreteStrength <- .concretePositiveScalar(
    compressiveStrengthMPa,
    "compressiveStrengthMPa"
  )
  MaximumStrain <- .concretePositiveScalar(
    concreteMaximumStrain,
    "concreteMaximumStrain"
  )
  StressFactor <- .concretePositiveScalar(
    concreteStressFactor,
    "concreteStressFactor"
  )
  Beta <- .concretePositiveScalar(beta1, "beta1")
  if (StressFactor > 1 || Beta > 1) {
    stop("concreteStressFactor and beta1 must not exceed one.", call. = FALSE)
  }
  ReductionIsFunction <- is.function(strengthReductionFactor)
  ReductionValue <- if (ReductionIsFunction) {
    NA_real_
  } else {
    .concreteReductionFactor(strengthReductionFactor, 0)
  }
  if (!is.numeric(neutralAxisDepthsMm) ||
      length(neutralAxisDepthsMm) < 25L ||
      any(!is.finite(neutralAxisDepthsMm)) ||
      any(neutralAxisDepthsMm <= 0) ||
      any(diff(neutralAxisDepthsMm) <= 0)) {
    stop(
      paste(
        "neutralAxisDepthsMm must be a strictly increasing positive vector",
        "with at least 25 values."
      ),
      call. = FALSE
    )
  }
  .concreteTextScalar(provisionID, "provisionID")
  .concreteTextScalar(sourceLocator, "sourceLocator")
  .concreteTextScalar(designBasisID, "designBasisID")
  if (ReductionIsFunction) {
    .concreteTextScalar(
      strengthReductionRuleID,
      "strengthReductionRuleID"
    )
  } else if (is.null(strengthReductionRuleID)) {
    strengthReductionRuleID <- "constant-strength-reduction-factor"
  } else {
    .concreteTextScalar(
      strengthReductionRuleID,
      "strengthReductionRuleID"
    )
  }
  Reinforcement <- .validateConcreteReinforcement(
    reinforcement = reinforcement,
    thicknessMm = Thickness
  )
  ReinforcementSignature <- .concreteReinforcementSignature(Reinforcement)
  ReductionSignature <- if (ReductionIsFunction) {
    paste("function", strengthReductionRuleID, sep = ":")
  } else {
    paste("scalar", .concreteNumberText(ReductionValue), sep = ":")
  }
  PrimitiveID <- paste(
    .concreteNumberText(c(
      Thickness, Width, ConcreteStrength, MaximumStrain,
      StressFactor, Beta
    )),
    ReinforcementSignature,
    ReductionSignature,
    provisionID,
    designBasisID,
    sourceLocator,
    sep = "||"
  )

  assemblePoint <- function(
    StateID,
    CompressionFace,
    NeutralAxisDepth,
    BlockDepth,
    ConcreteForce,
    ConcreteCoordinate,
    SteelStrain,
    SteelStress,
    ConcreteDisplacement,
    reductionFactorOverride = NULL,
    reductionFactorBasisID = "strain-rule"
  ) {
    SteelForce <- Reinforcement$areaMm2 *
      (SteelStress - ConcreteDisplacement)
    NominalAxial <- ConcreteForce + sum(SteelForce)
    NominalMoment <- ConcreteForce * ConcreteCoordinate +
      sum(SteelForce * Reinforcement$coordinateMm)
    NetTensileStrain <- max(0, -min(SteelStrain))
    Phi <- if (is.null(reductionFactorOverride)) {
      .concreteReductionFactor(
        rule = strengthReductionFactor,
        netTensileStrain = NetTensileStrain
      )
    } else {
      .concreteReductionFactor(
        rule = reductionFactorOverride,
        netTensileStrain = NetTensileStrain
      )
    }
    data.frame(
      stateID = StateID,
      compressionFaceID = CompressionFace,
      neutralAxisDepthMm = NeutralAxisDepth,
      concreteBlockDepthMm = BlockDepth,
      minimumSteelStrain = min(SteelStrain),
      netTensileStrain = NetTensileStrain,
      nominalAxialStrengthN = NominalAxial,
      nominalBendingStrengthNmm = NominalMoment,
      axialStrengthN = Phi * NominalAxial,
      bendingStrengthNmm = Phi * NominalMoment,
      strengthReductionFactor = Phi,
      reductionFactorBasisID = reductionFactorBasisID,
      thicknessMm = Thickness,
      stripWidthMm = Width,
      compressiveStrengthMPa = ConcreteStrength,
      concreteMaximumStrain = MaximumStrain,
      concreteStressFactor = StressFactor,
      beta1 = Beta,
      coordinateConventionID = "middepth-positive-exterior",
      reinforcementAreaBasisID = "declared-layer-area-for-strip",
      reinforcementSignature = ReinforcementSignature,
      strengthReductionRuleID = strengthReductionRuleID,
      domainPrimitiveID = PrimitiveID,
      meshPointCount = length(neutralAxisDepthsMm),
      meshMinimumDepthRatio = min(neutralAxisDepthsMm) / Thickness,
      meshMaximumDepthRatio = max(neutralAxisDepthsMm) / Thickness,
      provisionID = provisionID,
      designBasisID = designBasisID,
      sourceLocator = sourceLocator,
      stringsAsFactors = FALSE
    )
  }

  calculateCompatibilityPoint <- function(CompressionFace, NeutralAxisDepth) {
    FaceSign <- if (CompressionFace == "exterior") 1 else -1
    BlockDepth <- min(Beta * NeutralAxisDepth, Thickness)
    ConcreteForce <- StressFactor * ConcreteStrength * Width * BlockDepth
    ConcreteCoordinate <- FaceSign * (Thickness / 2 - BlockDepth / 2)
    LayerDepth <- Thickness / 2 -
      FaceSign * Reinforcement$coordinateMm
    SteelStrain <- MaximumStrain *
      (1 - LayerDepth / NeutralAxisDepth)
    SteelStress <- .concreteClamp(
      Reinforcement$modulusMPa * SteelStrain,
      -Reinforcement$yieldStrengthMPa,
      Reinforcement$yieldStrengthMPa
    )
    ConcreteDisplacement <- ifelse(
      LayerDepth <= BlockDepth,
      StressFactor * ConcreteStrength,
      0
    )
    assemblePoint(
      StateID = "compatibility",
      CompressionFace = CompressionFace,
      NeutralAxisDepth = NeutralAxisDepth,
      BlockDepth = BlockDepth,
      ConcreteForce = ConcreteForce,
      ConcreteCoordinate = ConcreteCoordinate,
      SteelStrain = SteelStrain,
      SteelStress = SteelStress,
      ConcreteDisplacement = ConcreteDisplacement
    )
  }

  calculateUniformPoint <- function(StateID, ReductionFactor) {
    if (StateID == "uniform-tension") {
      SteelStrain <- -Reinforcement$yieldStrengthMPa /
        Reinforcement$modulusMPa
      SteelStress <- -Reinforcement$yieldStrengthMPa
      BlockDepth <- 0
      ConcreteForce <- 0
      ConcreteDisplacement <- rep(0, nrow(Reinforcement))
    } else {
      SteelStrain <- rep(MaximumStrain, nrow(Reinforcement))
      SteelStress <- pmin(
        Reinforcement$modulusMPa * MaximumStrain,
        Reinforcement$yieldStrengthMPa
      )
      BlockDepth <- Thickness
      ConcreteForce <- StressFactor * ConcreteStrength * Width * Thickness
      ConcreteDisplacement <- rep(
        StressFactor * ConcreteStrength,
        nrow(Reinforcement)
      )
    }
    assemblePoint(
      StateID = StateID,
      CompressionFace = "none",
      NeutralAxisDepth = NA_real_,
      BlockDepth = BlockDepth,
      ConcreteForce = ConcreteForce,
      ConcreteCoordinate = 0,
      SteelStrain = SteelStrain,
      SteelStress = SteelStress,
      ConcreteDisplacement = ConcreteDisplacement,
      reductionFactorOverride = ReductionFactor,
      reductionFactorBasisID = "adjacent-compatibility-limit"
    )
  }

  Exterior <- do.call(rbind, lapply(
    neutralAxisDepthsMm,
    function(Depth) calculateCompatibilityPoint("exterior", Depth)
  ))
  Interior <- do.call(rbind, lapply(
    rev(neutralAxisDepthsMm),
    function(Depth) calculateCompatibilityPoint("interior", Depth)
  ))
  Tension <- calculateUniformPoint(
    "uniform-tension",
    min(
      Exterior$strengthReductionFactor[1L],
      Interior$strengthReductionFactor[nrow(Interior)]
    )
  )
  Compression <- calculateUniformPoint(
    "uniform-compression",
    min(
      Exterior$strengthReductionFactor[nrow(Exterior)],
      Interior$strengthReductionFactor[1L]
    )
  )
  OUT <- rbind(Tension, Exterior, Compression, Interior, Tension)
  rownames(OUT) <- NULL
  OUT
}

.concreteCross2D <- function(x, y) {
  x[1L] * y[2L] - x[2L] * y[1L]
}

.concreteOnSegment <- function(point, start, end, tolerance) {
  Segment <- end - start
  Offset <- point - start
  SegmentNorm <- sqrt(sum(Segment^2))
  OffsetNorm <- sqrt(sum(Offset^2))
  CrossTolerance <- tolerance * max(
    SegmentNorm * OffsetNorm,
    .Machine$double.eps
  )
  ProjectionTolerance <- tolerance * max(
    SegmentNorm^2,
    .Machine$double.eps
  )
  abs(.concreteCross2D(Segment, Offset)) <= CrossTolerance &&
    sum(Offset * Segment) >= -ProjectionTolerance &&
    sum((point - end) * Segment) <= ProjectionTolerance
}

.concreteSegmentsIntersect <- function(a, b, c, d, tolerance) {
  AB <- b - a
  CD <- d - c
  Cross1 <- .concreteCross2D(b - a, c - a)
  Cross2 <- .concreteCross2D(b - a, d - a)
  Cross3 <- .concreteCross2D(d - c, a - c)
  Cross4 <- .concreteCross2D(d - c, b - c)
  Tolerance1 <- tolerance * max(
    sqrt(sum(AB^2)) * max(sqrt(sum((c - a)^2)), sqrt(sum((d - a)^2))),
    .Machine$double.eps
  )
  Tolerance2 <- tolerance * max(
    sqrt(sum(CD^2)) * max(sqrt(sum((a - c)^2)), sqrt(sum((b - c)^2))),
    .Machine$double.eps
  )
  Proper <- ((Cross1 > Tolerance1 && Cross2 < -Tolerance1) ||
    (Cross1 < -Tolerance1 && Cross2 > Tolerance1)) &&
    ((Cross3 > Tolerance2 && Cross4 < -Tolerance2) ||
      (Cross3 < -Tolerance2 && Cross4 > Tolerance2))
  if (Proper) return(TRUE)
  (abs(Cross1) <= Tolerance1 && .concreteOnSegment(c, a, b, tolerance)) ||
    (abs(Cross2) <= Tolerance1 && .concreteOnSegment(d, a, b, tolerance)) ||
    (abs(Cross3) <= Tolerance2 && .concreteOnSegment(a, c, d, tolerance)) ||
    (abs(Cross4) <= Tolerance2 && .concreteOnSegment(b, c, d, tolerance))
}

.concretePointInsidePolygon <- function(point, points, tolerance) {
  Closed <- rbind(points, points[1L, , drop = FALSE])
  for (i in seq_len(nrow(points))) {
    if (.concreteOnSegment(point, Closed[i, ], Closed[i + 1L, ], tolerance)) {
      return(FALSE)
    }
  }
  Inside <- FALSE
  for (i in seq_len(nrow(points))) {
    Start <- Closed[i, ]
    End <- Closed[i + 1L, ]
    Crosses <- (Start[2L] > point[2L]) != (End[2L] > point[2L])
    if (Crosses) {
      Intersection <- Start[1L] +
        (point[2L] - Start[2L]) * (End[1L] - Start[1L]) /
          (End[2L] - Start[2L])
      if (Intersection > point[1L] + tolerance) Inside <- !Inside
    }
  }
  Inside
}

.validateConcreteDomain <- function(designDomain, tolerance) {
  if (!is.data.frame(designDomain)) {
    stop("designDomain must be one data frame.", call. = FALSE)
  }
  Fields.required <- c(
    "axialStrengthN", "bendingStrengthNmm", "stripWidthMm",
    "provisionID", "designBasisID", "sourceLocator"
  )
  Fields.missing <- setdiff(Fields.required, names(designDomain))
  if (length(Fields.missing) > 0L) {
    stop(
      "designDomain is missing: ",
      paste(Fields.missing, collapse = ", "),
      ".",
      call. = FALSE
    )
  }
  if (nrow(designDomain) < 4L ||
      any(!is.finite(designDomain$axialStrengthN)) ||
      any(!is.finite(designDomain$bendingStrengthNmm)) ||
      any(!is.finite(designDomain$stripWidthMm))) {
    stop("designDomain must contain finite section-domain points.", call. = FALSE)
  }
  TextFields <- c("provisionID", "designBasisID", "sourceLocator")
  if (any(vapply(
    designDomain[TextFields],
    function(x) any(!is.character(x) | !nzchar(x)),
    logical(1)
  ))) {
    stop("The design-domain provenance must be complete.", call. = FALSE)
  }
  if (any(vapply(
    designDomain[c("stripWidthMm", TextFields)],
    function(x) length(unique(x)) != 1L,
    logical(1)
  ))) {
    stop("designDomain must use one width, provision and design basis.", call. = FALSE)
  }

  Points <- as.matrix(designDomain[c(
    "axialStrengthN", "bendingStrengthNmm"
  )])
  Scale <- apply(abs(Points), 2L, max)
  if (any(!is.finite(Scale)) || any(Scale <= 0)) {
    stop("designDomain must span both axial and bending axes.", call. = FALSE)
  }
  Normalized <- sweep(Points, 2L, Scale, "/")
  if (sqrt(sum((Normalized[1L, ] - Normalized[nrow(Normalized), ])^2)) <=
      tolerance) {
    Normalized <- Normalized[-nrow(Normalized), , drop = FALSE]
  }
  Clean <- Normalized[1L, , drop = FALSE]
  if (nrow(Normalized) > 1L) {
    for (i in 2:nrow(Normalized)) {
      Distance <- sqrt(sum((Normalized[i, ] - Clean[nrow(Clean), ])^2))
      if (Distance > tolerance) {
        Clean <- rbind(Clean, Normalized[i, , drop = FALSE])
      }
    }
  }
  Normalized <- Clean
  if (nrow(Normalized) < 3L) {
    stop("designDomain must contain three distinct perimeter points.", call. = FALSE)
  }
  ClosingLength <- sqrt(sum(
    (Normalized[1L, ] - Normalized[nrow(Normalized), ])^2
  ))
  if (ClosingLength <= tolerance) {
    Normalized <- Normalized[-nrow(Normalized), , drop = FALSE]
  }
  Rounded <- round(Normalized / tolerance) * tolerance
  if (anyDuplicated(data.frame(Rounded))) {
    stop("designDomain contains repeated non-consecutive points.", call. = FALSE)
  }
  PointCount <- nrow(Normalized)
  for (i in seq_len(PointCount)) {
    A <- Normalized[i, ]
    B <- Normalized[if (i == PointCount) 1L else i + 1L, ]
    if (i == PointCount) next
    for (j in seq.int(i + 1L, PointCount)) {
      Adjacent <- j == i + 1L || (i == 1L && j == PointCount)
      if (Adjacent) next
      C <- Normalized[j, ]
      D <- Normalized[if (j == PointCount) 1L else j + 1L, ]
      if (.concreteSegmentsIntersect(A, B, C, D, tolerance)) {
        stop("designDomain is self-intersecting or not perimeter ordered.", call. = FALSE)
      }
    }
  }
  if (!.concretePointInsidePolygon(c(0, 0), Normalized, tolerance)) {
    stop("The origin must be strictly inside designDomain.", call. = FALSE)
  }
  list(points = Normalized, scale = Scale)
}

.prepareConcreteDomainGeometry <- function(designDomain, tolerance = 1e-9) {
  Tolerance <- .concretePositiveScalar(tolerance, "tolerance")
  Geometry <- .validateConcreteDomain(
    designDomain = designDomain,
    tolerance = Tolerance
  )
  Geometry$stripWidthMm <- unique(designDomain$stripWidthMm)
  Geometry$domainPointCount <- nrow(designDomain)
  Geometry$domainPrimitiveID <- if (
    "domainPrimitiveID" %in% names(designDomain)
  ) {
    unique(designDomain$domainPrimitiveID)
  } else {
    NULL
  }
  Geometry$tolerance <- Tolerance
  Geometry
}

.useConcreteDomainGeometry <- function(designDomain, geometry, tolerance) {
  if (is.null(geometry)) {
    return(.prepareConcreteDomainGeometry(
      designDomain = designDomain,
      tolerance = tolerance
    ))
  }
  Required <- c(
    "points", "scale", "stripWidthMm", "domainPointCount", "tolerance"
  )
  if (!is.list(geometry) || any(!Required %in% names(geometry)) ||
      !is.matrix(geometry$points) || ncol(geometry$points) != 2L ||
      !is.numeric(geometry$scale) || length(geometry$scale) != 2L ||
      !identical(geometry$stripWidthMm, unique(designDomain$stripWidthMm)) ||
      !identical(geometry$domainPointCount, nrow(designDomain)) ||
      !identical(geometry$tolerance, tolerance)) {
    stop(
      "domainGeometry is incompatible with the supplied designDomain.",
      call. = FALSE
    )
  }
  if (!is.null(geometry$domainPrimitiveID)) {
    if (!("domainPrimitiveID" %in% names(designDomain)) ||
        !identical(
          geometry$domainPrimitiveID,
          unique(designDomain$domainPrimitiveID)
        )) {
      stop(
        "domainGeometry has a different domain primitive identity.",
        call. = FALSE
      )
    }
  }
  geometry
}

.concreteRayMultipliers <- function(demands, points, tolerance) {
  Demand <- as.matrix(demands)
  if (!is.numeric(Demand) || ncol(Demand) != 2L ||
      any(!is.finite(Demand))) {
    stop("demands must be one finite two-column matrix.", call. = FALSE)
  }
  Zero <- rowSums(abs(Demand) > tolerance) == 0L
  Closed <- rbind(points, points[1L, , drop = FALSE])
  Multipliers <- rep(Inf, nrow(Demand))
  for (i in seq_len(nrow(points))) {
    Start <- Closed[i, ]
    Segment <- Closed[i + 1L, ] - Start
    Denominator <- Demand[, 1L] * Segment[2L] -
      Demand[, 2L] * Segment[1L]
    OK <- abs(Denominator) > tolerance & !Zero
    if (!any(OK)) next
    Multiplier <- rep(Inf, nrow(Demand))
    SegmentCoordinate <- rep(Inf, nrow(Demand))
    Multiplier[OK] <- .concreteCross2D(Start, Segment) / Denominator[OK]
    SegmentCoordinate[OK] <- (
      Start[1L] * Demand[OK, 2L] - Start[2L] * Demand[OK, 1L]
    ) / Denominator[OK]
    OK <- OK & Multiplier > tolerance &
      SegmentCoordinate >= -tolerance &
      SegmentCoordinate <= 1 + tolerance
    Multipliers[OK] <- pmin(Multipliers[OK], Multiplier[OK])
  }
  if (any(!Zero & !is.finite(Multipliers))) {
    stop("The demand ray does not intersect the supplied design domain.", call. = FALSE)
  }
  Multipliers
}

evaluateConcreteDemand <- function(
  normalForceKnPerM,
  bendingMomentKnMPerM,
  stripWidthM,
  designDomain,
  forceEffectStatus,
  tolerance = 1e-9,
  domainGeometry = NULL
) {
  if (!is.numeric(normalForceKnPerM) ||
      !is.numeric(bendingMomentKnMPerM) ||
      length(normalForceKnPerM) != length(bendingMomentKnMPerM) ||
      length(normalForceKnPerM) == 0L ||
      any(!is.finite(normalForceKnPerM)) ||
      any(!is.finite(bendingMomentKnMPerM))) {
    stop("N and M must be finite numeric vectors of equal length.", call. = FALSE)
  }
  StripWidth <- .concretePositiveScalar(stripWidthM, "stripWidthM")
  .concreteTextScalar(forceEffectStatus, "forceEffectStatus")
  Tolerance <- .concretePositiveScalar(tolerance, "tolerance")
  Geometry <- .useConcreteDomainGeometry(
    designDomain = designDomain,
    geometry = domainGeometry,
    tolerance = Tolerance
  )
  DomainWidthMm <- designDomain$stripWidthMm[1L]
  WidthDifference <- abs(DomainWidthMm - 1000 * StripWidth)
  WidthScale <- max(DomainWidthMm, 1000 * StripWidth)
  if (WidthDifference / WidthScale > Tolerance) {
    stop("The demand and design-domain strip widths are inconsistent.", call. = FALSE)
  }
  AxialDemand <- -1000 * normalForceKnPerM * StripWidth
  MomentDemand <- 1e6 * bendingMomentKnMPerM * StripWidth
  Demand <- cbind(AxialDemand, MomentDemand)
  Demand.normalized <- sweep(Demand, 2L, Geometry$scale, "/")
  Multipliers <- .concreteRayMultipliers(
    demands = Demand.normalized,
    points = Geometry$points,
    tolerance = Tolerance
  )
  Utilization <- ifelse(is.infinite(Multipliers), 0, 1 / Multipliers)

  data.frame(
    normalForceKnPerM = normalForceKnPerM,
    bendingMomentKnMPerM = bendingMomentKnMPerM,
    stripWidthM = StripWidth,
    axialDemandN = AxialDemand,
    bendingDemandNmm = MomentDemand,
    radialCapacityMultiplier = Multipliers,
    radialUtilization = Utilization,
    domainPositionID = ifelse(
      Utilization <= 1 + Tolerance,
      "inside-supplied-domain",
      "outside-supplied-domain"
    ),
    forceEffectStatus = forceEffectStatus,
    provisionID = designDomain$provisionID[1L],
    designBasisID = designDomain$designBasisID[1L],
    sourceLocator = designDomain$sourceLocator[1L],
    stringsAsFactors = FALSE
  )
}

evaluateConcreteDemandConvergence <- function(
  normalForceKnPerM,
  bendingMomentKnMPerM,
  stripWidthM,
  baseDomain,
  refinedDomain,
  forceEffectStatus,
  relativeTolerance = 1e-3,
  geometryTolerance = 1e-9,
  baseGeometry = NULL,
  refinedGeometry = NULL
) {
  RelativeTolerance <- .concretePositiveScalar(
    relativeTolerance,
    "relativeTolerance"
  )
  PrimitiveField <- "domainPrimitiveID"
  if (!(PrimitiveField %in% names(baseDomain)) ||
      !(PrimitiveField %in% names(refinedDomain)) ||
      length(unique(baseDomain[[PrimitiveField]])) != 1L ||
      length(unique(refinedDomain[[PrimitiveField]])) != 1L ||
      !identical(
        unique(baseDomain[[PrimitiveField]]),
        unique(refinedDomain[[PrimitiveField]])
      )) {
    stop(
      paste(
        "baseDomain and refinedDomain must share every section, material,",
        "reinforcement, reduction-rule and provenance primitive."
      ),
      call. = FALSE
    )
  }
  Base <- evaluateConcreteDemand(
    normalForceKnPerM = normalForceKnPerM,
    bendingMomentKnMPerM = bendingMomentKnMPerM,
    stripWidthM = stripWidthM,
    designDomain = baseDomain,
    forceEffectStatus = forceEffectStatus,
    tolerance = geometryTolerance,
    domainGeometry = baseGeometry
  )
  Refined <- evaluateConcreteDemand(
    normalForceKnPerM = normalForceKnPerM,
    bendingMomentKnMPerM = bendingMomentKnMPerM,
    stripWidthM = stripWidthM,
    designDomain = refinedDomain,
    forceEffectStatus = forceEffectStatus,
    tolerance = geometryTolerance,
    domainGeometry = refinedGeometry
  )
  DifferenceNumerator <- 2 * abs(
    Refined$radialUtilization - Base$radialUtilization
  )
  DifferenceDenominator <- abs(Refined$radialUtilization) +
    abs(Base$radialUtilization)
  Difference <- ifelse(
    DifferenceDenominator == 0,
    0,
    DifferenceNumerator / DifferenceDenominator
  )
  Refined$convergenceRelativeDifference <- Difference
  Refined$convergenceTolerance <- RelativeTolerance
  Refined$convergenceStatus <- ifelse(
    Difference <= RelativeTolerance,
    "satisfied",
    "not-satisfied"
  )
  Refined
}
