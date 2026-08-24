# Independent Fourier comparator; not part of the production execution path.
# Source this file into a separate environment because it retains historical
# public names such as evaluateRingLoad().
#
# Fourier solution for a thin circular ring under prescribed radial and
# tangential line loads. The sign convention follows Baker (1968), PDF
# pages 19-25: radial load is positive outward, tangential load is positive
# with increasing theta, and ring normal force is positive in tension.

assertFiniteScalar <- function(value, name, lower = -Inf, strictLower = FALSE) {
  if (!is.numeric(value) || length(value) != 1L || !is.finite(value)) {
    stop(name, " must be one finite numeric value.", call. = FALSE)
  }

  Invalid <- if (strictLower) value <= lower else value < lower
  if (Invalid) {
    Relation <- if (strictLower) "greater than" else "at least"
    stop(name, " must be ", Relation, " ", lower, ".", call. = FALSE)
  }

  invisible(value)
}

copyRingMetadata <- function(source, target) {
  MetadataNames <- setdiff(
    names(attributes(source)),
    c("names", "row.names", "class")
  )
  for (MetadataName in MetadataNames) {
    attr(target, MetadataName) <- attr(source, MetadataName)
  }
  target
}

newRingSpectrum <- function(maxMode) {
  assertFiniteScalar(maxMode, "maxMode", lower = 0)
  if (maxMode != as.integer(maxMode)) {
    stop("maxMode must be an integer.", call. = FALSE)
  }

  Modes <- 0:as.integer(maxMode)
  data.frame(
    mode = Modes,
    radialCos = numeric(length(Modes)),
    radialSin = numeric(length(Modes)),
    tangentialCos = numeric(length(Modes)),
    tangentialSin = numeric(length(Modes)),
    check.names = FALSE
  )
}

validateRingSpectrum <- function(spectrum) {
  Required <- c(
    "mode", "radialCos", "radialSin", "tangentialCos", "tangentialSin"
  )
  Missing <- setdiff(Required, names(spectrum))
  if (length(Missing) > 0L) {
    stop(
      "spectrum is missing columns: ", paste(Missing, collapse = ", "), ".",
      call. = FALSE
    )
  }

  Spectrum <- spectrum[, Required, drop = FALSE]
  if (nrow(Spectrum) == 0L || any(!is.finite(as.matrix(Spectrum)))) {
    stop("spectrum must contain finite numeric coefficients.", call. = FALSE)
  }
  if (any(Spectrum$mode < 0) || any(Spectrum$mode != as.integer(Spectrum$mode))) {
    stop("spectrum modes must be non-negative integers.", call. = FALSE)
  }
  if (anyDuplicated(Spectrum$mode)) {
    stop("spectrum modes must be unique.", call. = FALSE)
  }

  Spectrum <- Spectrum[order(Spectrum$mode), , drop = FALSE]
  if (!identical(Spectrum$mode, 0:max(Spectrum$mode))) {
    stop("spectrum must contain every mode from zero through max(mode).", call. = FALSE)
  }

  ZeroRow <- Spectrum$mode == 0L
  ZeroTerms <- c(
    Spectrum$radialSin[ZeroRow],
    Spectrum$tangentialSin[ZeroRow]
  )
  if (any(ZeroTerms != 0)) {
    stop("sine coefficients for mode zero must be zero.", call. = FALSE)
  }

  rownames(Spectrum) <- NULL
  copyRingMetadata(spectrum, Spectrum)
}

fitRingSpectrum <- function(
  theta,
  radialOutward,
  tangentialPositive,
  maxMode,
  gridTolerance = 1e-10
) {
  assertFiniteScalar(maxMode, "maxMode", lower = 0)
  assertFiniteScalar(gridTolerance, "gridTolerance", lower = 0, strictLower = TRUE)
  if (maxMode != as.integer(maxMode)) {
    stop("maxMode must be an integer.", call. = FALSE)
  }
  if (!is.numeric(theta) || !is.numeric(radialOutward) ||
      !is.numeric(tangentialPositive)) {
    stop("theta and both load vectors must be numeric.", call. = FALSE)
  }

  Count <- length(theta)
  if (Count != length(radialOutward) || Count != length(tangentialPositive)) {
    stop("theta and both load vectors must have the same length.", call. = FALSE)
  }
  if (Count < 2L * as.integer(maxMode) + 1L) {
    stop("The angular grid is too short for maxMode without aliasing.", call. = FALSE)
  }
  if (any(!is.finite(theta)) || any(!is.finite(radialOutward)) ||
      any(!is.finite(tangentialPositive))) {
    stop("theta and both load vectors must contain only finite values.", call. = FALSE)
  }

  Wrapped <- theta %% (2 * pi)
  Order <- order(Wrapped)
  Wrapped <- Wrapped[Order]
  Radial <- radialOutward[Order]
  Tangential <- tangentialPositive[Order]
  Target <- (0:(Count - 1L)) * 2 * pi / Count
  Error <- max(abs(Wrapped - Target))
  if (Error > gridTolerance) {
    stop(
      "theta must be one complete, equally spaced periodic grid beginning at zero; ",
      "do not include both zero and 2*pi.",
      call. = FALSE
    )
  }

  Spectrum <- newRingSpectrum(as.integer(maxMode))
  Spectrum$radialCos[1L] <- mean(Radial)
  Spectrum$tangentialCos[1L] <- mean(Tangential)

  if (maxMode >= 1L) {
    Modes <- 1:as.integer(maxMode)
    Angles <- outer(Target, Modes, `*`)
    Cosines <- cos(Angles)
    Sines <- sin(Angles)
    Spectrum$radialCos[-1L] <- 2 * colMeans(Radial * Cosines)
    Spectrum$radialSin[-1L] <- 2 * colMeans(Radial * Sines)
    Spectrum$tangentialCos[-1L] <- 2 * colMeans(Tangential * Cosines)
    Spectrum$tangentialSin[-1L] <- 2 * colMeans(Tangential * Sines)
  }

  attr(Spectrum, "fitRadialLoadScale") <- max(abs(Radial), 1e-300)
  attr(Spectrum, "fitTangentialLoadScale") <- max(abs(Tangential), 1e-300)
  Spectrum
}

evaluateRingLoad <- function(spectrum, theta) {
  Spectrum <- validateRingSpectrum(spectrum)
  if (!is.numeric(theta) || any(!is.finite(theta))) {
    stop("theta must contain only finite numeric values.", call. = FALSE)
  }

  Angles <- outer(theta, Spectrum$mode, `*`)
  Cosines <- cos(Angles)
  Sines <- sin(Angles)
  data.frame(
    theta = theta,
    radialOutward = as.vector(
      Cosines %*% Spectrum$radialCos + Sines %*% Spectrum$radialSin
    ),
    tangentialPositive = as.vector(
      Cosines %*% Spectrum$tangentialCos +
        Sines %*% Spectrum$tangentialSin
    )
  )
}

ringGlobalLoads <- function(spectrum, radius) {
  Spectrum <- validateRingSpectrum(spectrum)
  assertFiniteScalar(radius, "radius", lower = 0, strictLower = TRUE)

  ModeOne <- Spectrum[Spectrum$mode == 1L, , drop = FALSE]
  if (nrow(ModeOne) == 0L) {
    ModeOne <- data.frame(
      radialCos = 0, radialSin = 0,
      tangentialCos = 0, tangentialSin = 0
    )
  }

  data.frame(
    forceX = pi * radius * (
      ModeOne$radialSin + ModeOne$tangentialCos
    ),
    forceZ = pi * radius * (
      -ModeOne$radialCos + ModeOne$tangentialSin
    ),
    momentCenter = 2 * pi * radius^2 * Spectrum$tangentialCos[1L]
  )
}

solveRingSpectrum <- function(
  spectrum,
  radius,
  thickness = NULL,
  uniformMoment = c("membrane", "baker", "section"),
  rigidModeTolerance = 1e-10,
  sectionRatio = NULL
) {
  Spectrum <- validateRingSpectrum(spectrum)
  assertFiniteScalar(radius, "radius", lower = 0, strictLower = TRUE)
  assertFiniteScalar(
    rigidModeTolerance,
    "rigidModeTolerance",
    lower = 0,
    strictLower = TRUE
  )
  UniformMoment <- match.arg(uniformMoment)

  if (UniformMoment == "baker") {
    if (is.null(thickness)) {
      stop("thickness is required when uniformMoment = 'baker'.", call. = FALSE)
    }
    assertFiniteScalar(thickness, "thickness", lower = 0, strictLower = TRUE)
  }
  if (UniformMoment == "section") {
    if (is.null(sectionRatio)) {
      stop(
        "sectionRatio is required when uniformMoment = 'section'.",
        call. = FALSE
      )
    }
    if (!is.null(thickness)) {
      stop(
        "thickness and sectionRatio cannot define the same uniform moment.",
        call. = FALSE
      )
    }
    assertFiniteScalar(sectionRatio, "sectionRatio", lower = 0)
  } else if (!is.null(sectionRatio)) {
    stop(
      "sectionRatio is used only when uniformMoment = 'section'.",
      call. = FALSE
    )
  }

  EquivalentRadius <- attr(Spectrum, "equivalentRadius")
  if (!is.null(EquivalentRadius)) {
    assertFiniteScalar(
      EquivalentRadius,
      "spectrum equivalentRadius",
      lower = 0,
      strictLower = TRUE
    )
    RadiusError <- abs(radius - EquivalentRadius)
    RadiusTolerance <- rigidModeTolerance * max(abs(EquivalentRadius), 1e-300)
    if (RadiusError > RadiusTolerance) {
      RadiusUnit <- attr(Spectrum, "lengthUnit")
      UnitText <- if (is.null(RadiusUnit)) "declared length units" else RadiusUnit
      stop(
        sprintf(
          paste0(
            "radius %.12g does not match the spectrum equivalentRadius ",
            "%.12g %s. Rebuild the projection after any unit conversion."
          ),
          radius,
          EquivalentRadius,
          UnitText
        ),
        call. = FALSE
      )
    }
  }

  ModeOne <- Spectrum[Spectrum$mode == 1L, , drop = FALSE]
  readFitScale <- function(name) {
    Value <- attr(Spectrum, name)
    if (is.null(Value)) return(0)
    assertFiniteScalar(Value, paste("spectrum", name), lower = 0)
    Value
  }
  FitRadialLoadScale <- readFitScale("fitRadialLoadScale")
  FitTangentialLoadScale <- readFitScale("fitTangentialLoadScale")

  # rigidModeTolerance is an absolute coefficient tolerance. The second term
  # only covers floating-point projection noise. Radial and tangential scales
  # remain separate so an unrelated large harmonic cannot hide a resultant.
  FloatingFactor <- 64 * .Machine$double.eps
  TorqueScale <- max(
    abs(Spectrum$tangentialCos[1L]),
    FitTangentialLoadScale,
    1e-300
  )
  TorqueTolerance <- max(
    rigidModeTolerance,
    FloatingFactor * TorqueScale
  )
  ForceXTolerance <- if (nrow(ModeOne) == 0L) {
    rigidModeTolerance
  } else {
    ForceXScale <- abs(ModeOne$radialSin) +
      abs(ModeOne$tangentialCos) +
      FitRadialLoadScale +
      FitTangentialLoadScale
    max(rigidModeTolerance, FloatingFactor * ForceXScale)
  }
  ForceZTolerance <- if (nrow(ModeOne) == 0L) {
    rigidModeTolerance
  } else {
    ForceZScale <- abs(ModeOne$radialCos) +
      abs(ModeOne$tangentialSin) +
      FitRadialLoadScale +
      FitTangentialLoadScale
    max(rigidModeTolerance, FloatingFactor * ForceZScale)
  }

  if (abs(Spectrum$tangentialCos[1L]) > TorqueTolerance) {
    stop(
      "A non-zero mean tangential load has a net torque and requires an explicit reaction.",
      call. = FALSE
    )
  }
  ModeOneUnbalanced <- if (nrow(ModeOne) == 0L) {
    FALSE
  } else {
    abs(ModeOne$tangentialSin - ModeOne$radialCos) > ForceZTolerance ||
      abs(ModeOne$tangentialCos + ModeOne$radialSin) > ForceXTolerance
  }
  if (ModeOneUnbalanced) {
    Global <- ringGlobalLoads(Spectrum, radius)
    stop(
      sprintf(
        paste0(
          "Mode n=1 has a non-zero global force. ",
          "Define body force/support/contact reactions first ",
          "(Fx=%.8g, Fz=%.8g, Mc=%.8g)."
        ),
        Global$forceX,
        Global$forceZ,
        Global$momentCenter
      ),
      call. = FALSE
    )
  }

  Response <- data.frame(
    mode = Spectrum$mode,
    nCos = numeric(nrow(Spectrum)),
    nSin = numeric(nrow(Spectrum)),
    mCos = numeric(nrow(Spectrum)),
    mSin = numeric(nrow(Spectrum)),
    qCos = numeric(nrow(Spectrum)),
    qSin = numeric(nrow(Spectrum)),
    check.names = FALSE
  )

  Response$nCos[1L] <- radius * Spectrum$radialCos[1L]
  CurvatureRatio <- switch(
    UniformMoment,
    membrane = 0,
    baker = thickness^2 / (12 * radius^2),
    section = sectionRatio
  )
  if (CurvatureRatio > 0) {
    Response$mCos[1L] <- radius^2 * CurvatureRatio /
      (1 + CurvatureRatio) * Spectrum$radialCos[1L]
  }

  if (nrow(ModeOne) == 1L) {
    ModeOneIndex <- Response$mode == 1L
    Response$nCos[ModeOneIndex] <- radius * ModeOne$radialCos
    Response$nSin[ModeOneIndex] <- radius * ModeOne$radialSin
  }

  General <- Spectrum$mode >= 2L
  if (any(General)) {
    Mode <- Spectrum$mode[General]
    Denominator <- Mode^2 - 1
    RadialCos <- Spectrum$radialCos[General]
    RadialSin <- Spectrum$radialSin[General]
    TangentialCos <- Spectrum$tangentialCos[General]
    TangentialSin <- Spectrum$tangentialSin[General]

    Response$nCos[General] <- radius * (
      Mode * TangentialSin - RadialCos
    ) / Denominator
    Response$mCos[General] <- radius^2 * (
      TangentialSin / Mode - RadialCos
    ) / Denominator
    Response$qSin[General] <- radius * (
      Mode * RadialCos - TangentialSin
    ) / Denominator

    Response$nSin[General] <- -radius * (
      RadialSin + Mode * TangentialCos
    ) / Denominator
    Response$mSin[General] <- -radius^2 * (
      RadialSin + TangentialCos / Mode
    ) / Denominator
    Response$qCos[General] <- -radius * (
      Mode * RadialSin + TangentialCos
    ) / Denominator
  }

  if (identical(attr(Spectrum, "momentSupported"), FALSE)) {
    Response$mCos[] <- NA_real_
    Response$mSin[] <- NA_real_
  }
  if (identical(attr(Spectrum, "shearSupported"), FALSE)) {
    Response$qCos[] <- NA_real_
    Response$qSin[] <- NA_real_
  }

  attr(Response, "radius") <- radius
  attr(Response, "uniformMoment") <- UniformMoment
  attr(Response, "thickness") <- thickness
  attr(Response, "sectionRatio") <- CurvatureRatio
  Response <- copyRingMetadata(Spectrum, Response)
  class(Response) <- c("ringResponseSpectrum", class(Response))
  Response
}

validateRingResponseSpectrum <- function(responseSpectrum) {
  Required <- c("mode", "nCos", "nSin", "mCos", "mSin", "qCos", "qSin")
  Missing <- setdiff(Required, names(responseSpectrum))
  if (length(Missing) > 0L) {
    stop(
      "responseSpectrum is missing columns: ",
      paste(Missing, collapse = ", "),
      ".",
      call. = FALSE
    )
  }
  Response <- responseSpectrum[, Required, drop = FALSE]
  if (nrow(Response) == 0L || any(!is.finite(Response$mode)) ||
      any(!is.finite(as.matrix(Response[, c("nCos", "nSin"), drop = FALSE])))) {
    stop(
      "responseSpectrum must contain finite modes and normal-force coefficients.",
      call. = FALSE
    )
  }
  MomentSupported <- !identical(attr(responseSpectrum, "momentSupported"), FALSE)
  ShearSupported <- !identical(attr(responseSpectrum, "shearSupported"), FALSE)
  MomentFinite <- is.finite(as.matrix(
    Response[, c("mCos", "mSin"), drop = FALSE]
  ))
  ShearFinite <- is.finite(as.matrix(
    Response[, c("qCos", "qSin"), drop = FALSE]
  ))
  if ((MomentSupported && any(!MomentFinite)) ||
      (!MomentSupported && any(!(MomentFinite | is.na(as.matrix(
        Response[, c("mCos", "mSin"), drop = FALSE]
      )))))) {
    stop("responseSpectrum has invalid moment coefficients.", call. = FALSE)
  }
  if ((ShearSupported && any(!ShearFinite)) ||
      (!ShearSupported && any(!(ShearFinite | is.na(as.matrix(
        Response[, c("qCos", "qSin"), drop = FALSE]
      )))))) {
    stop("responseSpectrum has invalid shear coefficients.", call. = FALSE)
  }
  if (any(Response$mode < 0) || any(Response$mode != as.integer(Response$mode)) ||
      anyDuplicated(Response$mode)) {
    stop("responseSpectrum modes must be unique non-negative integers.", call. = FALSE)
  }
  Response <- Response[order(Response$mode), , drop = FALSE]
  if (!identical(Response$mode, 0:max(Response$mode))) {
    stop(
      "responseSpectrum must contain every mode from zero through max(mode).",
      call. = FALSE
    )
  }
  rownames(Response) <- NULL
  copyRingMetadata(responseSpectrum, Response)
}

evaluateRingResponse <- function(responseSpectrum, theta) {
  Response <- validateRingResponseSpectrum(responseSpectrum)
  if (!is.numeric(theta) || any(!is.finite(theta))) {
    stop("theta must contain only finite numeric values.", call. = FALSE)
  }

  Angles <- outer(theta, Response$mode, `*`)
  Cosines <- cos(Angles)
  Sines <- sin(Angles)
  Values <- data.frame(
    theta = theta %% (2 * pi),
    normalForce = as.vector(Cosines %*% Response$nCos + Sines %*% Response$nSin),
    bendingMoment = as.vector(Cosines %*% Response$mCos + Sines %*% Response$mSin),
    shearForce = as.vector(Cosines %*% Response$qCos + Sines %*% Response$qSin)
  )
  if (identical(attr(Response, "momentSupported"), FALSE)) {
    Values$bendingMoment[] <- NA_real_
  }
  if (identical(attr(Response, "shearSupported"), FALSE)) {
    Values$shearForce[] <- NA_real_
  }
  copyRingMetadata(Response, Values)
}

ringEquilibriumResidual <- function(spectrum, responseSpectrum, radius, theta) {
  Spectrum <- validateRingSpectrum(spectrum)
  Response <- validateRingResponseSpectrum(responseSpectrum)
  assertFiniteScalar(radius, "radius", lower = 0, strictLower = TRUE)
  if (!identical(Spectrum$mode, Response$mode)) {
    stop("load and response spectra must contain the same modes.", call. = FALSE)
  }
  if (!is.numeric(theta) || any(!is.finite(theta))) {
    stop("theta must contain only finite numeric values.", call. = FALSE)
  }

  Loads <- evaluateRingLoad(Spectrum, theta)
  Resultants <- evaluateRingResponse(Response, theta)
  Angles <- outer(theta, Response$mode, `*`)
  Cosines <- cos(Angles)
  Sines <- sin(Angles)
  Mode <- matrix(
    Response$mode,
    nrow = length(theta),
    ncol = nrow(Response),
    byrow = TRUE
  )

  MomentDerivative <- as.vector(
    (-Mode * Sines) %*% Response$mCos +
      (Mode * Cosines) %*% Response$mSin
  )
  NormalDerivative <- as.vector(
    (-Mode * Sines) %*% Response$nCos +
      (Mode * Cosines) %*% Response$nSin
  )
  ShearDerivative <- as.vector(
    (-Mode * Sines) %*% Response$qCos +
      (Mode * Cosines) %*% Response$qSin
  )

  data.frame(
    theta = theta %% (2 * pi),
    momentBalance = radius * Resultants$shearForce - MomentDerivative,
    radialBalance = radius * Loads$radialOutward -
      Resultants$normalForce - ShearDerivative,
    tangentialBalance = NormalDerivative - Resultants$shearForce +
      radius * Loads$tangentialPositive
  )
}
