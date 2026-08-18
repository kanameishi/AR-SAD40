# Adapt the Schwartz--Einstein external-loading solution to the project
# convention used by structural checks. The source-native equations remain in
# ringInteraction.R; this file owns only the explicit coordinate/sign boundary.

if (any(!vapply(
  c(
    ".assertFiniteScalar", ".assertText", ".assertTheta",
    "schwartzEinsteinStiffness", "schwartzEinsteinResultants"
  ),
  function(s) exists(s, mode = "function", inherits = TRUE),
  logical(1)
))) {
  stop(
    paste(
      "Source scripts/R/ringDirect.R and scripts/R/ringInteraction.R before",
      "scripts/R/externalInteraction.R."
    ),
    call. = FALSE
  )
}

calculateExternalInteraction <- function(
  theta,
  effectiveVerticalStressKPa,
  effectiveHorizontalStressKPa,
  waterPressureDifferenceKPa = 0,
  stressReferenceID,
  radiusM,
  groundModulusKPa,
  groundPoisson,
  liningModulusKPa,
  liningPoisson,
  liningAreaM2PerM,
  liningInertiaM4PerM,
  interface,
  combinationID,
  stageID,
  forceEffectStatus
) {
  .assertTheta(theta)
  .assertFiniteScalar(
    effectiveVerticalStressKPa,
    "effectiveVerticalStressKPa",
    minimum = 0,
    strict = TRUE
  )
  .assertFiniteScalar(
    effectiveHorizontalStressKPa,
    "effectiveHorizontalStressKPa",
    minimum = 0
  )
  .assertFiniteScalar(
    waterPressureDifferenceKPa,
    "waterPressureDifferenceKPa"
  )
  .assertText(stressReferenceID, "stressReferenceID")
  .assertText(combinationID, "combinationID")
  .assertText(stageID, "stageID")
  .assertText(forceEffectStatus, "forceEffectStatus")
  if (!is.character(interface) || length(interface) != 1L ||
      !interface %in% c("fullSlip", "noSlip")) {
    stop("interface must be fullSlip or noSlip.", call. = FALSE)
  }

  Stiffness <- schwartzEinsteinStiffness(
    radius = radiusM,
    groundModulus = groundModulusKPa,
    groundPoisson = groundPoisson,
    supportModulus = liningModulusKPa,
    supportPoisson = liningPoisson,
    supportArea = liningAreaM2PerM,
    supportInertia = liningInertiaM4PerM
  )
  StressRatio <- effectiveHorizontalStressKPa / effectiveVerticalStressKPa

  # Source angle: zero at the right-hand point of the horizontal diameter and
  # counterclockwise positive. Project angle: zero at crown, clockwise positive.
  Theta.source <- (pi / 2 - theta) %% (2 * pi)
  Source <- schwartzEinsteinResultants(
    theta = Theta.source,
    verticalStress = effectiveVerticalStressKPa,
    stressRatio = StressRatio,
    radius = radiusM,
    cStar = Stiffness[["cStar", exact = TRUE]],
    fStar = Stiffness[["fStar", exact = TRUE]],
    groundPoisson = groundPoisson,
    sequence = "external",
    interface = interface
  )
  Values.source <- Source[["response", exact = TRUE]]

  Values <- data.frame(
    combinationID = rep(combinationID, length(theta)),
    stageID = rep(stageID, length(theta)),
    forceEffectStatus = rep(forceEffectStatus, length(theta)),
    interactionModelID = rep(
      "schwartz-einstein-external-loading",
      length(theta)
    ),
    interfaceID = rep(interface, length(theta)),
    stressReferenceID = rep(stressReferenceID, length(theta)),
    stressBasis = rep(
      "effective-plus-net-water-pressure",
      length(theta)
    ),
    hydraulicActionTreatment = rep(
      "uniform-net-pressure-superposed",
      length(theta)
    ),
    effectiveVerticalStressKPa = rep(
      effectiveVerticalStressKPa,
      length(theta)
    ),
    effectiveHorizontalStressKPa = rep(
      effectiveHorizontalStressKPa,
      length(theta)
    ),
    waterPressureDifferenceKPa = rep(
      waterPressureDifferenceKPa,
      length(theta)
    ),
    stressRatio = rep(StressRatio, length(theta)),
    thetaRad = as.numeric(theta),
    thetaDeg = as.numeric(theta) * 180 / pi,
    normalForceKnPerM = -Values.source[["thrust", exact = TRUE]] -
      waterPressureDifferenceKPa * radiusM,
    bendingMomentKnMPerM = -Values.source[["moment", exact = TRUE]],
    shearForceKnPerM = Values.source[["shear", exact = TRUE]],
    longitudinalBasis = rep("per-projected-metre", length(theta)),
    stringsAsFactors = FALSE
  )
  if (any(!is.finite(as.matrix(Values[c(
    "thetaRad", "thetaDeg", "normalForceKnPerM",
    "bendingMomentKnMPerM", "shearForceKnPerM"
  )])))) {
    stop("The adapted interaction resultants are not finite.", call. = FALSE)
  }

  list(
    values = Values,
    stiffness = Stiffness,
    source = Source,
    amplitudesProject = c(
      normalMean = -effectiveVerticalStressKPa * radiusM *
        Source$amplitudes[["thrust0", exact = TRUE]] -
        waterPressureDifferenceKPa * radiusM,
      normalCosine = effectiveVerticalStressKPa * radiusM *
        Source$amplitudes[["thrust2", exact = TRUE]],
      momentCosine = effectiveVerticalStressKPa * radiusM^2 *
        Source$amplitudes[["moment2", exact = TRUE]],
      shearSine = -2 * effectiveVerticalStressKPa * radiusM *
        Source$amplitudes[["moment2", exact = TRUE]]
    ),
    convention = c(
      thetaOrigin = "crown",
      thetaDirection = "clockwise",
      normalForceSign = "tensionPositive",
      bendingMomentSign = "positiveTensionInner",
      shearForceSign = "towardCenterOnPositiveFace"
    ),
    sourceKey = "SchwartzEinstein1980",
    sourceLocation = Source[["sourceLocation", exact = TRUE]],
    limitations = c(
      Source[["limitations", exact = TRUE]],
      paste(
        "net water pressure is superposed as a uniform radial action;",
        "it does not modify the effective-stress interaction coefficients"
      )
    )
  )
}

# Superpose the balanced odd-harmonic correction associated with a linear
# geostatic gradient on the uniform Schwartz--Einstein interaction solution.
#
# The free-field tensor projected on the ring contains n = 1 and n = 3.  Its
# vertical n = 1 resultant is balanced by the exact full-circumference radial
# reaction required for global equilibrium.  Tangential support stiffness is
# zero.  The reaction is a force constraint; no physical spring stiffness or
# displacement is inferred here.
addBalancedGeostaticGradient <- function(
  interaction,
  radiusM,
  verticalStressGradientKPaPerM,
  horizontalStressGradientKPaPerM
) {
  if (!is.list(interaction) ||
      is.null(interaction[["values", exact = TRUE]]) ||
      is.null(interaction[["amplitudesProject", exact = TRUE]])) {
    stop(
      "interaction must be returned by calculateExternalInteraction().",
      call. = FALSE
    )
  }
  .assertFiniteScalar(radiusM, "radiusM", minimum = 0, strict = TRUE)
  .assertFiniteScalar(
    verticalStressGradientKPaPerM,
    "verticalStressGradientKPaPerM",
    minimum = 0
  )
  .assertFiniteScalar(
    horizontalStressGradientKPaPerM,
    "horizontalStressGradientKPaPerM",
    minimum = 0
  )

  Values <- interaction[["values", exact = TRUE]]
  Theta <- Values[["thetaRad", exact = TRUE]]
  .assertTheta(Theta)
  GradientDifference <- verticalStressGradientKPaPerM -
    horizontalStressGradientKPaPerM

  # Projected load coefficients, with radial load positive outward and
  # tangential load positive in the project theta direction.
  RadialMode1.unbalanced <- radiusM * (
    3 * verticalStressGradientKPaPerM +
      horizontalStressGradientKPaPerM
  ) / 4
  TangentialMode1 <- -radiusM * GradientDifference / 4
  RadialMode3 <- radiusM * GradientDifference / 4
  TangentialMode3 <- -radiusM * GradientDifference / 4

  # A uniform radial support around the complete circumference develops a
  # cos(theta) reaction under vertical translation.  Enforcing a1 = d1 is
  # exactly the n = 1 global force-balance condition.
  SupportRadialMode1 <- TangentialMode1 - RadialMode1.unbalanced
  RadialMode1.balanced <- RadialMode1.unbalanced + SupportRadialMode1

  NormalMode1 <- radiusM * RadialMode1.balanced
  NormalMode3 <- radiusM * (
    3 * TangentialMode3 - RadialMode3
  ) / (3^2 - 1)
  MomentMode3 <- radiusM^2 * (
    TangentialMode3 / 3 - RadialMode3
  ) / (3^2 - 1)
  ShearMode3 <- radiusM * (
    3 * RadialMode3 - TangentialMode3
  ) / (3^2 - 1)

  Values[["normalForceKnPerM"]] <-
    Values[["normalForceKnPerM", exact = TRUE]] +
    NormalMode1 * cos(Theta) + NormalMode3 * cos(3 * Theta)
  Values[["bendingMomentKnMPerM"]] <-
    Values[["bendingMomentKnMPerM", exact = TRUE]] +
    MomentMode3 * cos(3 * Theta)
  Values[["shearForceKnPerM"]] <-
    Values[["shearForceKnPerM", exact = TRUE]] +
    ShearMode3 * sin(3 * Theta)
  Values[["interactionModelID"]] <-
    "schwartz-einstein-balanced-gradient-hybrid"

  VerticalAxis <- Values[["effectiveVerticalStressKPa", exact = TRUE]][1L]
  HorizontalAxis <- Values[[
    "effectiveHorizontalStressKPa",
    exact = TRUE
  ]][1L]
  PrescribedCompressivePressure <-
    VerticalAxis * cos(Theta)^2 + HorizontalAxis * sin(Theta)^2 -
    RadialMode1.balanced * cos(Theta) - RadialMode3 * cos(3 * Theta)

  interaction[["values"]] <- Values
  interaction[["amplitudesProject"]] <- c(
    interaction[["amplitudesProject", exact = TRUE]],
    normalMode1 = NormalMode1,
    normalMode3 = NormalMode3,
    momentMode3 = MomentMode3,
    shearMode3 = ShearMode3
  )
  interaction[["gradient"]] <- data.frame(
    gradientModelID = "balanced-linear-geostatic-n1-n3",
    supportModelID = "full-circumference-radial-n1-constraint",
    tangentialSupportStiffness = 0,
    verticalStressGradientKPaPerM = verticalStressGradientKPaPerM,
    horizontalStressGradientKPaPerM = horizontalStressGradientKPaPerM,
    radialMode1UnbalancedKPa = RadialMode1.unbalanced,
    tangentialMode1KPa = TangentialMode1,
    radialMode3KPa = RadialMode3,
    tangentialMode3KPa = TangentialMode3,
    supportRadialMode1KPa = SupportRadialMode1,
    radialMode1BalancedKPa = RadialMode1.balanced,
    unbalancedVerticalForceKnPerM = pi * radiusM * (
      -RadialMode1.unbalanced + TangentialMode1
    ),
    balancedVerticalForceKnPerM = pi * radiusM * (
      -RadialMode1.balanced + TangentialMode1
    ),
    normalMode1KnPerM = NormalMode1,
    normalMode3KnPerM = NormalMode3,
    momentMode3KnMPerM = MomentMode3,
    shearMode3KnPerM = ShearMode3,
    minimumPrescribedCompressivePressureKPa =
      min(PrescribedCompressivePressure),
    maximumPrescribedCompressivePressureKPa =
      max(PrescribedCompressivePressure),
    equilibriumStatus = if (abs(
      pi * radiusM * (-RadialMode1.balanced + TangentialMode1)
    ) <= 1e-10) "satisfied" else "not-satisfied",
    prescribedCompressionStatus = if (
      min(PrescribedCompressivePressure) >= -1e-9
    ) "satisfied" else "not-satisfied",
    stringsAsFactors = FALSE
  )
  interaction[["sourceKey"]] <- paste(
    interaction[["sourceKey", exact = TRUE]],
    "project-balanced-gradient-equilibrium",
    sep = ";"
  )
  interaction[["limitations"]] <- c(
    interaction[["limitations", exact = TRUE]],
    paste(
      "odd n=1 and n=3 modes are a prescribed geostatic-gradient",
      "correction and do not add an odd-mode soil-impedance law"
    ),
    paste(
      "the n=1 radial reaction enforces global equilibrium but does not",
      "define a support displacement or a physical radial spring stiffness"
    )
  )
  interaction
}

.summarizeHarmonic <- function(meanValue, amplitude, harmonic) {
  if (!harmonic %in% c("cosine", "sine")) {
    stop("harmonic must be cosine or sine.", call. = FALSE)
  }
  if (amplitude == 0) {
    Angle.min <- 0
    Angle.max <- 0
  } else if (harmonic == "cosine") {
    Angle.min <- if (amplitude > 0) pi / 2 else 0
    Angle.max <- if (amplitude > 0) 0 else pi / 2
  } else {
    Angle.min <- if (amplitude > 0) 3 * pi / 4 else pi / 4
    Angle.max <- if (amplitude > 0) pi / 4 else 3 * pi / 4
  }
  Value.min <- meanValue - abs(amplitude)
  Value.max <- meanValue + abs(amplitude)
  if (abs(Value.min) >= abs(Value.max)) {
    SignedValue.absolute <- Value.min
    Angle.absolute <- Angle.min
  } else {
    SignedValue.absolute <- Value.max
    Angle.absolute <- Angle.max
  }

  list(
    value = c(Value.min, Value.max, abs(SignedValue.absolute)),
    signedValue = c(Value.min, Value.max, SignedValue.absolute),
    thetaRad = c(Angle.min, Angle.max, Angle.absolute)
  )
}

summarizeExternalInteraction <- function(result) {
  if (!is.list(result) || is.null(result[["values", exact = TRUE]])) {
    stop(
      "result must be returned by calculateExternalInteraction().",
      call. = FALSE
    )
  }
  Values <- result[["values", exact = TRUE]]
  Amplitudes <- result[["amplitudesProject", exact = TRUE]]
  IsHybrid <- all(c(
    "normalMode1", "normalMode3", "momentMode3", "shearMode3"
  ) %in% names(Amplitudes))
  summarizeValues <- function(value) {
    Index.min <- which.min(value)[1L]
    Index.max <- which.max(value)[1L]
    Index.absolute <- which.max(abs(value))[1L]
    list(
      value = c(value[Index.min], value[Index.max], abs(value[Index.absolute])),
      signedValue = c(value[Index.min], value[Index.max], value[Index.absolute]),
      thetaRad = Values[["thetaRad", exact = TRUE]][c(
        Index.min,
        Index.max,
        Index.absolute
      )]
    )
  }
  Harmonics <- if (IsHybrid) {
    list(
      N = summarizeValues(Values[["normalForceKnPerM", exact = TRUE]]),
      M = summarizeValues(Values[["bendingMomentKnMPerM", exact = TRUE]]),
      Q = summarizeValues(Values[["shearForceKnPerM", exact = TRUE]])
    )
  } else {
    list(
      N = .summarizeHarmonic(
        Amplitudes[["normalMean", exact = TRUE]],
        Amplitudes[["normalCosine", exact = TRUE]],
        "cosine"
      ),
      M = .summarizeHarmonic(
        0,
        Amplitudes[["momentCosine", exact = TRUE]],
        "cosine"
      ),
      Q = .summarizeHarmonic(
        0,
        Amplitudes[["shearSine", exact = TRUE]],
        "sine"
      )
    )
  }
  Units <- c(N = "kN/m", M = "kN m/m", Q = "kN/m")

  LIST <- lapply(names(Harmonics), function(s) {
    Harmonic <- Harmonics[[s]]
    data.frame(
      combinationID = Values[["combinationID", exact = TRUE]][1L],
      stageID = Values[["stageID", exact = TRUE]][1L],
      forceEffectStatus = Values[["forceEffectStatus", exact = TRUE]][1L],
      interactionModelID = Values[["interactionModelID", exact = TRUE]][1L],
      interfaceID = Values[["interfaceID", exact = TRUE]][1L],
      stressReferenceID = Values[["stressReferenceID", exact = TRUE]][1L],
      stressBasis = Values[["stressBasis", exact = TRUE]][1L],
      hydraulicActionTreatment = Values[[
        "hydraulicActionTreatment",
        exact = TRUE
      ]][1L],
      effectiveVerticalStressKPa = Values[[
        "effectiveVerticalStressKPa",
        exact = TRUE
      ]][1L],
      effectiveHorizontalStressKPa = Values[[
        "effectiveHorizontalStressKPa",
        exact = TRUE
      ]][1L],
      waterPressureDifferenceKPa = Values[[
        "waterPressureDifferenceKPa",
        exact = TRUE
      ]][1L],
      stressRatio = Values[["stressRatio", exact = TRUE]][1L],
      resultantID = s,
      statisticID = c("minimum", "maximum", "absolute-maximum"),
      value = Harmonic$value,
      signedValue = Harmonic$signedValue,
      thetaRad = Harmonic$thetaRad,
      thetaDeg = Harmonic$thetaRad * 180 / pi,
      unit = Units[[s]],
      stringsAsFactors = FALSE
    )
  })
  OUT <- do.call(rbind, LIST)
  rownames(OUT) <- NULL
  OUT
}
