# Closed elastic ground-ring interaction comparators.
#
# Schwartz-Einstein (1980) is kept source-native on purpose:
#   theta = 0 at the right springline, counterclockwise positive;
#   T is the published ring thrust, positive in compression;
#   M retains the source sign;
#   Q = (1/R) dM/dtheta is derived from equilibrium, not tabulated.
#
# This module does not generate Pr(theta), Pt(theta), estimate field stress,
# model compaction, or silently translate signs into ringDirect.R.

if (!exists(".assertFiniteScalar", mode = "function")) {
  stop("Source scripts/R/ringDirect.R before ringInteraction.R.", call. = FALSE)
}

.assertSchwartzPoisson <- function(value, name) {
  .assertFiniteScalar(value, name, minimum = -1, strict = TRUE)
  if (value >= 0.5) {
    stop(name, " must be less than 0.5.", call. = FALSE)
  }
  invisible(value)
}

.matchSchwartzChoice <- function(value, name, choices) {
  if (!is.character(value) || length(value) != 1L || !value %in% choices) {
    stop(
      name,
      " must be one of: ",
      paste(choices, collapse = ", "),
      ".",
      call. = FALSE
    )
  }
  value
}

.angleSet <- function(theta = numeric(), allAngles = FALSE) {
  list(theta = theta, allAngles = allAngles)
}

.cosineCriticalAngles <- function(amplitude) {
  if (amplitude == 0) {
    All <- .angleSet(allAngles = TRUE)
    return(list(minimum = All, maximum = All))
  }

  Axis0 <- .angleSet(c(0, pi))
  Axis90 <- .angleSet(c(pi / 2, 3 * pi / 2))
  if (amplitude > 0) {
    list(minimum = Axis90, maximum = Axis0)
  } else {
    list(minimum = Axis0, maximum = Axis90)
  }
}

.sineCriticalAngles <- function(amplitude) {
  if (amplitude == 0) {
    All <- .angleSet(allAngles = TRUE)
    return(list(minimum = All, maximum = All))
  }

  PositiveSine <- .angleSet(c(pi / 4, 5 * pi / 4))
  NegativeSine <- .angleSet(c(3 * pi / 4, 7 * pi / 4))
  if (amplitude > 0) {
    list(minimum = NegativeSine, maximum = PositiveSine)
  } else {
    list(minimum = PositiveSine, maximum = NegativeSine)
  }
}

# Schwartz and Einstein (1980), Eqs. (2.1)-(2.2), printed p. 12/PDF p. 28.
schwartzEinsteinStiffness <- function(
  radius,
  groundModulus,
  groundPoisson,
  supportModulus,
  supportPoisson,
  supportArea,
  supportInertia
) {
  .assertFiniteScalar(radius, "radius", minimum = 0, strict = TRUE)
  .assertFiniteScalar(
    groundModulus,
    "groundModulus",
    minimum = 0,
    strict = TRUE
  )
  .assertSchwartzPoisson(groundPoisson, "groundPoisson")
  .assertFiniteScalar(
    supportModulus,
    "supportModulus",
    minimum = 0,
    strict = TRUE
  )
  .assertSchwartzPoisson(supportPoisson, "supportPoisson")
  .assertFiniteScalar(
    supportArea,
    "supportArea",
    minimum = 0,
    strict = TRUE
  )
  .assertFiniteScalar(
    supportInertia,
    "supportInertia",
    minimum = 0,
    strict = TRUE
  )

  CStar <- groundModulus * radius * (1 - supportPoisson^2) /
    (supportModulus * supportArea * (1 - groundPoisson^2))
  FStar <- groundModulus * radius^3 * (1 - supportPoisson^2) /
    (supportModulus * supportInertia * (1 - groundPoisson^2))
  if (!is.finite(CStar) || CStar <= 0 || !is.finite(FStar) || FStar <= 0) {
    stop("Calculated Schwartz-Einstein stiffness ratios are not finite.", call. = FALSE)
  }

  list(
    cStar = CStar,
    fStar = FStar,
    source = "Schwartz and Einstein (1980), Eqs. (2.1)-(2.2)",
    sourceLocation = "printed p. 12/PDF p. 28"
  )
}

.schwartzEinsteinAmplitudes <- function(
  cStar,
  fStar,
  groundPoisson,
  stressRatio,
  sequence,
  interface
) {
  U <- 1 - groundPoisson

  if (sequence == "excavation") {
    A0Star <- cStar * fStar * U /
      (cStar + fStar + cStar * fStar * U)
    Thrust0 <- 0.5 * (1 + stressRatio) * (1 - A0Star)

    if (interface == "fullSlip") {
      A2Star <- (fStar + 6) * U /
        (2 * fStar * U + 6 * (5 - 6 * groundPoisson))
      Thrust2 <- 0.5 * (1 - stressRatio) * (1 - 2 * A2Star)
      Moment2 <- Thrust2
      Coefficients <- c(a0Star = A0Star, a2Star = A2Star)
    } else {
      # Algebraically equivalent, numerically stable form of Eqs. (2.4).
      Denominator <- 3 * fStar + 3 * cStar + 2 * cStar * fStar * U
      NumeratorB <- (6 + fStar) * cStar * U +
        2 * fStar * groundPoisson
      StableDenominator <- cStar * fStar * U^2 +
        3 * cStar * U * (5 - 6 * groundPoisson) +
        fStar * U * (3 - 2 * groundPoisson) +
        12 * (3 - 4 * groundPoisson)
      BHat <- NumeratorB / Denominator
      B2Star <- -U * Denominator / (2 * StableDenominator)
      A2Star <- -U * NumeratorB / (2 * StableDenominator)
      Thrust2 <- 0.5 * (1 - stressRatio) * (1 + 2 * A2Star)
      Moment2 <- 0.25 * (1 - stressRatio) *
        (1 - 2 * A2Star + 2 * B2Star)
      Coefficients <- c(
        a0Star = A0Star,
        bHat = BHat,
        b2Star = B2Star,
        a2Star = A2Star
      )
    }

    return(list(
      thrust0 = Thrust0,
      thrust2 = Thrust2,
      moment2 = Moment2,
      coefficients = Coefficients
    ))
  }

  A1 <- (cStar * U - 1 + 2 * groundPoisson) / (cStar * U + 1)
  Thrust0 <- 0.5 * (1 + stressRatio) * (1 - A1)

  if (interface == "fullSlip") {
    Denominator <- fStar * U + 15 - 18 * groundPoisson
    A2 <- (fStar * U + 3 - 6 * groundPoisson) / Denominator
    A3 <- (fStar * U - 3) / Denominator
    Harmonic <- (1 - stressRatio) * (1 + 3 * A2 - 4 * A3) / 6
    Thrust2 <- Harmonic
    Moment2 <- Harmonic
    Coefficients <- c(a1 = A1, a2 = A2, a3 = A3)
  } else {
    # The published apparent (1-2*nu) singularity cancels exactly because
    # 5/2-8*nu+6*nu^2=(1-2*nu)(5/2-3*nu).
    AHat <- fStar * U / 6 *
      ((3 - 2 * groundPoisson) + cStar * U) +
      cStar * U * (2.5 - 3 * groundPoisson) +
      6 - 8 * groundPoisson
    A2 <- (
      fStar * U / 6 * ((1 - 2 * groundPoisson) - cStar * U) -
        0.5 * cStar * U * (1 - 2 * groundPoisson) + 2
    ) / AHat
    A3 <- (
      fStar * U / 6 * (cStar * U + 1) -
        0.5 * cStar * U - 2
    ) / AHat
    Thrust2 <- 0.5 * (1 - stressRatio) * (1 + A2)
    Moment2 <- 0.25 * (1 - stressRatio) * (1 - A2 - 2 * A3)
    Coefficients <- c(a1 = A1, aHat = AHat, a2 = A2, a3 = A3)
  }

  list(
    thrust0 = Thrust0,
    thrust2 = Thrust2,
    moment2 = Moment2,
    coefficients = Coefficients
  )
}

# Four published branches: external/excavation x fullSlip/noSlip.
schwartzEinsteinResultants <- function(
  theta,
  verticalStress,
  stressRatio,
  radius,
  cStar,
  fStar,
  groundPoisson,
  sequence,
  interface
) {
  if (!is.numeric(theta) || length(theta) == 0L || any(!is.finite(theta))) {
    stop("theta must contain at least one finite numeric value.", call. = FALSE)
  }
  .assertFiniteScalar(
    verticalStress,
    "verticalStress",
    minimum = 0,
    strict = TRUE
  )
  .assertFiniteScalar(stressRatio, "stressRatio", minimum = 0)
  .assertFiniteScalar(radius, "radius", minimum = 0, strict = TRUE)
  .assertFiniteScalar(cStar, "cStar", minimum = 0, strict = TRUE)
  .assertFiniteScalar(fStar, "fStar", minimum = 0, strict = TRUE)
  .assertSchwartzPoisson(groundPoisson, "groundPoisson")
  Sequence <- .matchSchwartzChoice(
    sequence,
    "sequence",
    c("external", "excavation")
  )
  Interface <- .matchSchwartzChoice(
    interface,
    "interface",
    c("fullSlip", "noSlip")
  )

  Amplitudes <- .schwartzEinsteinAmplitudes(
    cStar = cStar,
    fStar = fStar,
    groundPoisson = groundPoisson,
    stressRatio = stressRatio,
    sequence = Sequence,
    interface = Interface
  )
  NumericCoefficients <- c(
    Amplitudes$thrust0,
    Amplitudes$thrust2,
    Amplitudes$moment2,
    Amplitudes$coefficients
  )
  if (any(!is.finite(NumericCoefficients))) {
    stop("Schwartz-Einstein coefficients are not finite.", call. = FALSE)
  }

  Theta <- as.numeric(theta)
  Cosine2 <- cos(2 * Theta)
  Sine2 <- sin(2 * Theta)
  ThrustRatio <- Amplitudes$thrust0 + Amplitudes$thrust2 * Cosine2
  MomentRatio <- Amplitudes$moment2 * Cosine2
  ShearRatio <- -2 * Amplitudes$moment2 * Sine2
  ForceScale <- verticalStress * radius
  MomentScale <- verticalStress * radius^2

  Response <- data.frame(
    theta = Theta,
    thetaDeg = Theta * 180 / pi,
    thrust = ForceScale * ThrustRatio,
    moment = MomentScale * MomentRatio,
    shear = ForceScale * ShearRatio,
    thrustRatio = ThrustRatio,
    momentRatio = MomentRatio,
    shearRatio = ShearRatio
  )

  ThrustAngles <- .cosineCriticalAngles(Amplitudes$thrust2)
  MomentAngles <- .cosineCriticalAngles(Amplitudes$moment2)
  ShearAngles <- .sineCriticalAngles(-2 * Amplitudes$moment2)
  AllAngles <- .angleSet(allAngles = TRUE)
  MomentAbsoluteAngles <- if (Amplitudes$moment2 == 0) {
    AllAngles
  } else {
    .angleSet(c(0, pi / 2, pi, 3 * pi / 2))
  }
  ShearAbsoluteAngles <- if (Amplitudes$moment2 == 0) {
    AllAngles
  } else {
    .angleSet(c(pi / 4, 3 * pi / 4, 5 * pi / 4, 7 * pi / 4))
  }

  MomentAbsolute <- MomentScale * abs(Amplitudes$moment2)
  ShearAbsolute <- 2 * ForceScale * abs(Amplitudes$moment2)
  ExtremaValues <- c(
    thrustMin = ForceScale *
      (Amplitudes$thrust0 - abs(Amplitudes$thrust2)),
    thrustMax = ForceScale *
      (Amplitudes$thrust0 + abs(Amplitudes$thrust2)),
    momentMin = -MomentAbsolute,
    momentMax = MomentAbsolute,
    momentAbsMax = MomentAbsolute,
    shearMin = -ShearAbsolute,
    shearMax = ShearAbsolute,
    shearAbsMax = ShearAbsolute
  )

  list(
    response = Response,
    amplitudes = c(
      thrust0 = Amplitudes$thrust0,
      thrust2 = Amplitudes$thrust2,
      moment2 = Amplitudes$moment2
    ),
    extrema = list(
      values = ExtremaValues,
      angles = list(
        thrustMin = ThrustAngles$minimum,
        thrustMax = ThrustAngles$maximum,
        momentMin = MomentAngles$minimum,
        momentMax = MomentAngles$maximum,
        momentAbsMax = MomentAbsoluteAngles,
        shearMin = ShearAngles$minimum,
        shearMax = ShearAngles$maximum,
        shearAbsMax = ShearAbsoluteAngles
      )
    ),
    coefficients = Amplitudes$coefficients,
    inputs = list(
      verticalStress = verticalStress,
      stressRatio = stressRatio,
      radius = radius,
      cStar = cStar,
      fStar = fStar,
      groundPoisson = groundPoisson,
      sequence = Sequence,
      interface = Interface
    ),
    provenance = c(
      thrust = "published",
      moment = "published",
      shear = "derivedFromPublishedEquilibrium"
    ),
    convention = c(
      thetaOrigin = "rightSpringline",
      thetaDirection = "counterclockwise",
      thetaUnit = "radian",
      thrustSign = "compressionPositive",
      momentSign = "SchwartzEinsteinSource",
      shearDefinition = "Q=(1/R)dM/dtheta"
    ),
    source = "Schwartz and Einstein (1980)",
    sourceLocation = if (Sequence == "external") {
      "Eqs. (A.49)/(A.52), printed pp. 372-374/PDF pp. 388-390"
    } else {
      "Eqs. (2.3)/(2.4), printed pp. 23-25/PDF pp. 39-41"
    },
    limitations = c(
      "homogeneous isotropic linear-elastic ground and support",
      "plane strain and infinite-medium approximation",
      "free-field stress constant over the ring",
      "does not generate P or K or model compaction",
      "full-slip and no-slip are discrete limiting interfaces"
    )
  )
}
