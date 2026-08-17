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
    stressBasis = rep("effective", length(theta)),
    hydraulicActionTreatment = rep(
      "separate-not-included",
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
    stressRatio = rep(StressRatio, length(theta)),
    thetaRad = as.numeric(theta),
    thetaDeg = as.numeric(theta) * 180 / pi,
    normalForceKnPerM = -Values.source[["thrust", exact = TRUE]],
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
        Source$amplitudes[["thrust0", exact = TRUE]],
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
    limitations = Source[["limitations", exact = TRUE]]
  )
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
  Harmonics <- list(
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
