# Direct equilibrium integration for a circular ring under prescribed
# perimeter tractions. This is the production solver. Fourier and Wolfram are
# independent comparators; neither is required to run this file.
#
# Convention:
#   theta = 0 at the crown and increases clockwise;
#   Pr > 0 points radially outward;
#   Pt > 0 follows increasing theta;
#   N > 0 is tension;
#   Q and M follow
#     dN/dtheta - Q + R Pt = 0,
#     dQ/dtheta + N - R Pr = 0,
#     dM/dtheta - R Q = 0.

.assertFiniteScalar <- function(value, name, minimum = -Inf, strict = FALSE) {
  if (!is.numeric(value) || length(value) != 1L || !is.finite(value)) {
    stop(name, " must be one finite numeric value.", call. = FALSE)
  }

  Invalid <- if (strict) value <= minimum else value < minimum
  if (Invalid) {
    Relation <- if (strict) "greater than" else "at least"
    stop(name, " must be ", Relation, " ", minimum, ".", call. = FALSE)
  }
  invisible(value)
}

.assertText <- function(value, name) {
  if (!is.character(value) || length(value) != 1L || !nzchar(value)) {
    stop(name, " must be one non-empty character value.", call. = FALSE)
  }
  invisible(value)
}

.assertTheta <- function(theta) {
  if (!is.numeric(theta) || length(theta) < 3L || any(!is.finite(theta))) {
    stop("theta must contain at least three finite numeric values.", call. = FALSE)
  }
  if (any(theta < 0) || any(theta >= 2 * pi) || any(diff(theta) <= 0)) {
    stop("theta must be strictly increasing on [0, 2*pi).", call. = FALSE)
  }
  invisible(theta)
}

# Section properties are per unit projected length of the tunnel axis. Inputs
# must use one coherent force-length system; no unit conversion is performed.
calculateRingSection <- function(youngModulus, area, inertia, radius) {
  .assertFiniteScalar(
    youngModulus,
    "youngModulus",
    minimum = 0,
    strict = TRUE
  )
  .assertFiniteScalar(area, "area", minimum = 0, strict = TRUE)
  .assertFiniteScalar(inertia, "inertia", minimum = 0, strict = TRUE)
  .assertFiniteScalar(radius, "radius", minimum = 0, strict = TRUE)

  EquivalentThickness <- sqrt(12 * inertia / area)
  list(
    youngModulus = youngModulus,
    area = area,
    inertia = inertia,
    extensionalRigidity = youngModulus * area,
    flexuralRigidity = youngModulus * inertia,
    sectionRatio = inertia / (area * radius^2),
    equivalentThickness = EquivalentThickness,
    equivalentYoungModulus = youngModulus * area / EquivalentThickness
  )
}

newRingLoad <- function(
  radial,
  tangential = function(theta) rep(0, length(theta)),
  label,
  source,
  representation,
  breakpoints = numeric(),
  metadata = list()
) {
  if (!is.function(radial) || !is.function(tangential)) {
    stop("radial and tangential must be functions of theta.", call. = FALSE)
  }
  .assertText(label, "label")
  .assertText(source, "source")
  .assertText(representation, "representation")
  if (!is.numeric(breakpoints) || any(!is.finite(breakpoints))) {
    stop("breakpoints must be finite angles in radians.", call. = FALSE)
  }
  if (length(breakpoints) > 0L &&
      any(breakpoints <= 0 | breakpoints >= 2 * pi)) {
    stop("breakpoints must lie strictly inside (0, 2*pi).", call. = FALSE)
  }
  if (!is.list(metadata)) {
    stop("metadata must be a list.", call. = FALSE)
  }

  Load <- list(
    radial = radial,
    tangential = tangential,
    label = label,
    source = source,
    representation = representation,
    breakpoints = sort(unique(breakpoints)),
    metadata = metadata
  )
  class(Load) <- "ringLoad"
  Load
}

.loadComponent <- function(component, theta, name) {
  Value <- component(theta)
  if (!is.numeric(Value) || length(Value) == 0L || any(!is.finite(Value))) {
    stop(name, " returned a non-finite or non-numeric value.", call. = FALSE)
  }
  if (length(Value) == 1L) {
    Value <- rep(Value, length(theta))
  }
  if (length(Value) != length(theta)) {
    stop(name, " must return one value per theta.", call. = FALSE)
  }
  as.numeric(Value)
}

evaluateRingLoad <- function(load, theta) {
  if (!inherits(load, "ringLoad")) {
    stop("load must be created by newRingLoad().", call. = FALSE)
  }
  if (!is.numeric(theta) || any(!is.finite(theta))) {
    stop("theta must contain finite numeric values.", call. = FALSE)
  }

  NormalizedTheta <- theta %% (2 * pi)
  data.frame(
    theta = NormalizedTheta,
    radialOutward = .loadComponent(
      load$radial,
      NormalizedTheta,
      "radial(theta)"
    ),
    tangentialPositive = .loadComponent(
      load$tangential,
      NormalizedTheta,
      "tangential(theta)"
    )
  )
}

combineRingLoads <- function(loads, label = "combined load") {
  if (!is.list(loads) || length(loads) == 0L ||
      any(!vapply(loads, inherits, logical(1), what = "ringLoad"))) {
    stop("loads must be a non-empty list of ringLoad objects.", call. = FALSE)
  }
  .assertText(label, "label")

  Radial <- function(theta) {
    Reduce(`+`, lapply(loads, function(Load) {
      .loadComponent(Load$radial, theta, "radial(theta)")
    }))
  }
  Tangential <- function(theta) {
    Reduce(`+`, lapply(loads, function(Load) {
      .loadComponent(Load$tangential, theta, "tangential(theta)")
    }))
  }

  combineConstraint <- function(name) {
    Values <- unlist(lapply(loads, function(Load) Load$metadata[[name]]))
    if (length(Values) == 0L) {
      return(NULL)
    }
    if (!is.numeric(Values) || any(!is.finite(Values))) {
      stop("Load constraint ", name, " must be finite and numeric.", call. = FALSE)
    }
    Tolerance <- 100 * .Machine$double.eps * max(1, abs(Values))
    if (max(Values) - min(Values) > Tolerance) {
      stop("Combined loads have incompatible ", name, " constraints.", call. = FALSE)
    }
    unname(Values[1L])
  }
  RequiredRadius <- combineConstraint("requiredRadius")
  RequiredSectionRatio <- combineConstraint("requiredSectionRatio")
  Metadata <- list(components = lapply(loads, function(Load) {
    list(
      label = Load$label,
      source = Load$source,
      representation = Load$representation
    )
  }))
  if (!is.null(RequiredRadius)) {
    Metadata$requiredRadius <- RequiredRadius
  }
  if (!is.null(RequiredSectionRatio)) {
    Metadata$requiredSectionRatio <- RequiredSectionRatio
  }

  newRingLoad(
    radial = Radial,
    tangential = Tangential,
    label = label,
    source = "superposition of declared components",
    representation = "linear superposition",
    breakpoints = sort(unique(unlist(lapply(loads, `[[`, "breakpoints")))),
    metadata = Metadata
  )
}

scaleRingLoad <- function(load, factor, label = NULL) {
  if (!inherits(load, "ringLoad")) {
    stop("load must be created by newRingLoad().", call. = FALSE)
  }
  .assertFiniteScalar(factor, "factor")
  if (is.null(label)) {
    label <- paste0(factor, " x ", load$label)
  }
  .assertText(label, "label")

  Metadata <- load$metadata
  PreviousScale <- Metadata$scaleFactor
  if (is.null(PreviousScale)) {
    PreviousScale <- 1
  } else {
    .assertFiniteScalar(PreviousScale, "metadata scaleFactor")
  }
  Metadata$scaleFactor <- PreviousScale * factor
  Metadata$scaledFrom <- load$label
  if (!is.null(Metadata$reproduces)) {
    Metadata$baseCaseProvenance <- list(
      label = load$label,
      reproduces = Metadata$reproduces
    )
    Metadata$reproduces <- NULL
  }

  newRingLoad(
    radial = function(theta) factor * load$radial(theta),
    tangential = function(theta) factor * load$tangential(theta),
    label = label,
    source = load$source,
    representation = paste("scaled", load$representation),
    breakpoints = load$breakpoints,
    metadata = Metadata
  )
}

.ringDerivative <- function(theta, state, load, radius, loadTheta = theta) {
  Pr <- .loadComponent(load$radial, loadTheta, "radial(theta)")[1L]
  Pt <- .loadComponent(load$tangential, loadTheta, "tangential(theta)")[1L]
  N <- state[1L]
  Q <- state[2L]
  M <- state[3L]

  c(
    Q - radius * Pt,
    radius * Pr - N,
    radius * Q,
    M * cos(theta),
    M * sin(theta),
    N,
    M,
    radius * (Pr * sin(theta) + Pt * cos(theta)),
    radius * (-Pr * cos(theta) + Pt * sin(theta)),
    radius^2 * Pt
  )
}

.integrateParticular <- function(load, radius, mesh) {
  State <- matrix(0, nrow = length(mesh), ncol = 10L)
  colnames(State) <- c(
    "N", "Q", "M", "intMCos", "intMSin", "intN", "intM",
    "forceX", "forceZ", "momentCenter"
  )

  for (Index in seq_len(length(mesh) - 1L)) {
    Theta <- mesh[Index]
    Step <- mesh[Index + 1L] - Theta
    Current <- State[Index, ]
    # A breakpoint has zero measure in the continuous load integral. Evaluate
    # RK4 endpoint loads from inside the current interval so a jump is not
    # counted once with the value from each neighbouring interval.
    EndpointOffset <- max(
      Step * 1e-10,
      32 * .Machine$double.eps * max(1, abs(Theta), abs(Theta + Step))
    )
    LeftLoadTheta <- Theta + EndpointOffset
    RightLoadTheta <- Theta + Step - EndpointOffset

    K1 <- .ringDerivative(
      Theta,
      Current,
      load,
      radius,
      loadTheta = LeftLoadTheta
    )
    K2 <- .ringDerivative(
      Theta + Step / 2,
      Current + Step * K1 / 2,
      load,
      radius
    )
    K3 <- .ringDerivative(
      Theta + Step / 2,
      Current + Step * K2 / 2,
      load,
      radius
    )
    K4 <- .ringDerivative(
      Theta + Step,
      Current + Step * K3,
      load,
      radius,
      loadTheta = RightLoadTheta
    )
    State[Index + 1L, ] <- Current + Step * (K1 + 2 * K2 + 2 * K3 + K4) / 6
  }
  State
}

solveRingDirect <- function(
  load,
  radius,
  theta = (0:720) * 2 * pi / 721,
  sectionRatio = 0,
  integrationSteps = 4096L,
  balanceTolerance = 1e-8,
  allowUnbalanced = FALSE
) {
  if (!inherits(load, "ringLoad")) {
    stop("load must be created by newRingLoad().", call. = FALSE)
  }
  .assertFiniteScalar(radius, "radius", minimum = 0, strict = TRUE)
  .assertFiniteScalar(sectionRatio, "sectionRatio", minimum = 0)
  .assertFiniteScalar(balanceTolerance, "balanceTolerance", minimum = 0)
  .assertTheta(theta)
  .assertFiniteScalar(integrationSteps, "integrationSteps", minimum = 128)
  if (integrationSteps != as.integer(integrationSteps)) {
    stop("integrationSteps must be an integer.", call. = FALSE)
  }
  if (!is.logical(allowUnbalanced) || length(allowUnbalanced) != 1L ||
      is.na(allowUnbalanced)) {
    stop("allowUnbalanced must be TRUE or FALSE.", call. = FALSE)
  }

  RequiredRadius <- load$metadata$requiredRadius
  if (!is.null(RequiredRadius)) {
    .assertFiniteScalar(
      RequiredRadius,
      "load metadata requiredRadius",
      minimum = 0,
      strict = TRUE
    )
    RadiusTolerance <- 100 * .Machine$double.eps *
      max(1, abs(radius), abs(RequiredRadius))
    if (abs(radius - RequiredRadius) > RadiusTolerance) {
      stop(
        "This load representation requires radius = ",
        format(RequiredRadius, digits = 15),
        ".",
        call. = FALSE
      )
    }
  }
  RequiredSectionRatio <- load$metadata$requiredSectionRatio
  if (!is.null(RequiredSectionRatio)) {
    .assertFiniteScalar(
      RequiredSectionRatio,
      "load metadata requiredSectionRatio",
      minimum = 0
    )
    RatioTolerance <- 100 * .Machine$double.eps *
      max(1, abs(sectionRatio), abs(RequiredSectionRatio))
    if (abs(sectionRatio - RequiredSectionRatio) > RatioTolerance) {
      stop(
        "This load representation requires sectionRatio = ",
        format(RequiredSectionRatio, digits = 15),
        ".",
        call. = FALSE
      )
    }
  }

  BaseMesh <- seq(0, 2 * pi, length.out = as.integer(integrationSteps) + 1L)
  Mesh <- sort(unique(c(0, theta, load$breakpoints, BaseMesh, 2 * pi)))
  Particular <- .integrateParticular(load, radius, Mesh)
  Final <- Particular[nrow(Particular), ]

  MomentCosOne <- unname(Final["intMCos"] / pi)
  MomentSinOne <- unname(Final["intMSin"] / pi)
  MeanNormal <- unname(Final["intN"] / (2 * pi))
  MeanMoment <- unname(Final["intM"] / (2 * pi))
  CosineConstant <- -MomentCosOne / radius
  SineConstant <- -MomentSinOne / radius
  UniformCoupling <- radius * sectionRatio / (1 + sectionRatio)
  MomentConstant <- UniformCoupling * MeanNormal - MeanMoment

  Row <- match(theta, Mesh)
  if (anyNA(Row)) {
    stop("Internal error: requested theta values are absent from the mesh.", call. = FALSE)
  }
  Selected <- Particular[Row, , drop = FALSE]
  Normal <- Selected[, "N"] +
    CosineConstant * cos(theta) + SineConstant * sin(theta)
  Shear <- Selected[, "Q"] -
    CosineConstant * sin(theta) + SineConstant * cos(theta)
  Moment <- Selected[, "M"] +
    radius * CosineConstant * cos(theta) +
    radius * SineConstant * sin(theta) + MomentConstant

  Values <- data.frame(
    theta = theta,
    thetaDeg = theta * 180 / pi,
    normalForce = as.numeric(Normal),
    bendingMoment = as.numeric(Moment),
    shearForce = as.numeric(Shear)
  )
  GlobalLoads <- c(
    forceX = unname(Final["forceX"]),
    forceZ = unname(Final["forceZ"]),
    momentCenter = unname(Final["momentCenter"])
  )
  ClosureResidual <- c(
    normalForce = unname(Final["N"]),
    shearForce = unname(Final["Q"]),
    bendingMoment = unname(Final["M"])
  )
  IntervalMidpoint <- (
    utils::head(Mesh, -1L) + utils::tail(Mesh, -1L)
  ) / 2
  PressureScale <- max(abs(c(
    .loadComponent(load$radial, IntervalMidpoint, "radial(theta)"),
    .loadComponent(load$tangential, IntervalMidpoint, "tangential(theta)")
  )))
  if (PressureScale == 0) {
    PressureScale <- 1
  }
  ForceScale <- 2 * pi * radius * PressureScale
  MomentScale <- 2 * pi * radius^2 * PressureScale
  NormalizedGlobalLoads <- GlobalLoads / c(
    forceX = ForceScale,
    forceZ = ForceScale,
    momentCenter = MomentScale
  )
  NormalizedClosure <- ClosureResidual / c(
    normalForce = radius * PressureScale,
    shearForce = radius * PressureScale,
    bendingMoment = radius^2 * PressureScale
  )
  # Global equilibrium fixes the increments over one revolution:
  # N(2*pi)-N(0)=-Fx, Q(2*pi)-Q(0)=-Fz and
  # M(2*pi)-M(0)=Mc-R*Fx. The particular integration starts from zero, so its
  # final state is exactly that increment. Compare it with the expected values
  # so a real first-harmonic resultant is not mislabeled as quadrature error.
  ExpectedClosure <- c(
    normalForce = -GlobalLoads["forceX"],
    shearForce = -GlobalLoads["forceZ"],
    bendingMoment = GlobalLoads["momentCenter"] -
      radius * GlobalLoads["forceX"]
  )
  names(ExpectedClosure) <- names(ClosureResidual)
  ClosureConsistency <- ClosureResidual - ExpectedClosure
  NormalizedClosureConsistency <- ClosureConsistency / c(
    normalForce = radius * PressureScale,
    shearForce = radius * PressureScale,
    bendingMoment = radius^2 * PressureScale
  )
  GlobalBalanceMetric <- max(abs(NormalizedGlobalLoads))
  ClosureMetric <- max(abs(NormalizedClosureConsistency))
  BalanceMetric <- max(GlobalBalanceMetric, ClosureMetric)
  Valid <- is.finite(BalanceMetric) && BalanceMetric <= balanceTolerance
  ResidualType <- if (Valid) {
    "none"
  } else if (GlobalBalanceMetric > balanceTolerance) {
    "globalLoad"
  } else {
    "integrationClosure"
  }

  Diagnostics <- list(
    valid = Valid,
    balanceMetric = BalanceMetric,
    globalBalanceMetric = GlobalBalanceMetric,
    closureMetric = ClosureMetric,
    residualType = ResidualType,
    balanceTolerance = balanceTolerance,
    globalLoads = GlobalLoads,
    normalizedGlobalLoads = NormalizedGlobalLoads,
    closureResidual = ClosureResidual,
    normalizedClosureResidual = NormalizedClosure,
    expectedClosureResidual = ExpectedClosure,
    closureConsistencyResidual = ClosureConsistency,
    normalizedClosureConsistencyResidual = NormalizedClosureConsistency,
    characteristicPressure = PressureScale,
    compatibility = c(
      momentCosOne = MomentCosOne + radius * CosineConstant,
      momentSinOne = MomentSinOne + radius * SineConstant,
      meanMomentMinusCoupledMeanNormal =
        MeanMoment + MomentConstant - UniformCoupling * MeanNormal
    ),
    integrationSteps = as.integer(integrationSteps),
    meshPoints = length(Mesh),
    sectionRatio = sectionRatio,
    exact = FALSE
  )

  if (!Valid && !allowUnbalanced) {
    Message <- if (ResidualType == "globalLoad") {
      paste0(
        "The perimeter load has a non-zero global resultant: normalized ",
        "residual %.6g exceeds balanceTolerance %.6g."
      )
    } else {
      paste0(
        "The numerical ring integration did not close: normalized residual ",
        "%.6g exceeds balanceTolerance %.6g. Increase integrationSteps and ",
        "check declared load breakpoints."
      )
    }
    stop(
      paste0(
        sprintf(Message, BalanceMetric, balanceTolerance),
        " Use allowUnbalanced=TRUE only to inspect diagnostics."
      ),
      call. = FALSE
    )
  }

  Result <- list(
    values = Values,
    diagnostics = Diagnostics,
    load = load,
    radius = radius,
    sectionRatio = sectionRatio
  )
  class(Result) <- "ringDirectResponse"
  Result
}

compareRingRefinement <- function(
  load,
  radius,
  theta = (0:360) * 2 * pi / 361,
  sectionRatio = 0,
  integrationSteps = 1024L
) {
  Coarse <- solveRingDirect(
    load = load,
    radius = radius,
    theta = theta,
    sectionRatio = sectionRatio,
    integrationSteps = integrationSteps
  )
  Fine <- solveRingDirect(
    load = load,
    radius = radius,
    theta = theta,
    sectionRatio = sectionRatio,
    integrationSteps = 2L * as.integer(integrationSteps)
  )
  Columns <- c("normalForce", "bendingMoment", "shearForce")

  data.frame(
    quantity = c("N", "M", "Q"),
    maximumDifference = vapply(Columns, function(Column) {
      max(abs(Coarse$values[[Column]] - Fine$values[[Column]]))
    }, numeric(1)),
    coarseSteps = as.integer(integrationSteps),
    fineSteps = 2L * as.integer(integrationSteps)
  )
}

summarizeRingGrid <- function(response) {
  if (!inherits(response, "ringDirectResponse")) {
    stop("response must be returned by solveRingDirect().", call. = FALSE)
  }
  Quantities <- c(
    N = "normalForce",
    M = "bendingMoment",
    Q = "shearForce"
  )

  do.call(rbind, lapply(names(Quantities), function(Name) {
    Column <- Quantities[[Name]]
    Value <- response$values[[Column]]
    Indices <- c(which.min(Value), which.max(Value), which.max(abs(Value)))
    Signed <- Value[Indices]
    data.frame(
      resultant = Name,
      statistic = c("minimum", "maximum", "absoluteMaximum"),
      value = c(Signed[1L], Signed[2L], abs(Signed[3L])),
      signedValue = Signed,
      theta = response$values$theta[Indices],
      thetaDeg = response$values$thetaDeg[Indices],
      stringsAsFactors = FALSE
    )
  }))
}
