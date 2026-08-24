# Calculate one cover-defined external-interaction scenario.

if (any(!vapply(
  c(
    ".assertFiniteScalar", ".assertText", ".assertTheta",
    "calculateExternalInteraction", "calculateSectionResultants",
    "solveBiaxialTangentialMultiplierClosed",
    "biaxialStressTangentialMultiplierLoad", "summarizeSectionResultants"
  ),
  function(s) exists(s, mode = "function", inherits = TRUE),
  logical(1)
))) {
  stop(
    paste(
      "Source scripts/R/ringDirect.R and scripts/R/externalInteraction.R",
      "before scripts/R/coverInteractionScenario.R."
    ),
    call. = FALSE
  )
}
calculateHomogeneousCoverStress <- function(
  coverCrownM,
  crownToAxisM,
  effectiveUnitWeightKnPerM3,
  effectiveSurchargeKPa = 0,
  referencePositionID = "axis"
) {
  .assertFiniteScalar(coverCrownM, "coverCrownM", minimum = 0)
  .assertFiniteScalar(
    crownToAxisM,
    "crownToAxisM",
    minimum = 0,
    strict = TRUE
  )
  .assertFiniteScalar(
    effectiveUnitWeightKnPerM3,
    "effectiveUnitWeightKnPerM3",
    minimum = 0,
    strict = TRUE
  )
  .assertFiniteScalar(
    effectiveSurchargeKPa,
    "effectiveSurchargeKPa",
    minimum = 0
  )
  if (!is.character(referencePositionID) ||
      length(referencePositionID) != 1L ||
      !referencePositionID %in% c("crown", "axis", "invert")) {
    stop(
      "referencePositionID must be crown, axis or invert.",
      call. = FALSE
    )
  }

  DepthIncrement <- switch(
    referencePositionID,
    crown = 0,
    axis = crownToAxisM,
    invert = 2 * crownToAxisM
  )
  Depth <- coverCrownM + DepthIncrement
  data.frame(
    referencePositionID = referencePositionID,
    depthM = Depth,
    effectiveVerticalStressKPa = effectiveSurchargeKPa +
      effectiveUnitWeightKnPerM3 * Depth,
    stressModelID = "homogeneous-free-field",
    stringsAsFactors = FALSE
  )
}

calculatePrescribedBiaxialInteraction <- function(
  theta,
  effectiveVerticalStressKPa,
  effectiveHorizontalStressKPa,
  waterPressureDifferenceKPa,
  stressReferenceID,
  radiusM,
  sectionRatio,
  tangentialMultiplier,
  actionRepresentationID,
  combinationID,
  stageID,
  forceEffectStatus,
  integrationSteps,
  balanceTolerance
) {
  .assertTheta(theta)
  .assertFiniteScalar(
    effectiveVerticalStressKPa,
    "effectiveVerticalStressKPa",
    minimum = 0
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
  .assertFiniteScalar(radiusM, "radiusM", minimum = 0, strict = TRUE)
  .assertFiniteScalar(sectionRatio, "sectionRatio", minimum = 0)
  .assertFiniteScalar(
    tangentialMultiplier,
    "tangentialMultiplier",
    minimum = 0
  )
  if (tangentialMultiplier > 1) {
    stop("tangentialMultiplier must not exceed 1.", call. = FALSE)
  }
  .assertText(actionRepresentationID, "actionRepresentationID")
  .assertText(stressReferenceID, "stressReferenceID")
  .assertText(combinationID, "combinationID")
  .assertText(stageID, "stageID")
  .assertText(forceEffectStatus, "forceEffectStatus")
  .assertFiniteScalar(
    integrationSteps,
    "integrationSteps",
    minimum = 128
  )
  if (integrationSteps != as.integer(integrationSteps)) {
    stop("integrationSteps must be an integer.", call. = FALSE)
  }
  .assertFiniteScalar(
    balanceTolerance,
    "balanceTolerance",
    minimum = 0,
    strict = TRUE
  )

  Load <- biaxialStressTangentialMultiplierLoad(
    effectiveVertical = effectiveVerticalStressKPa,
    effectiveHorizontal = effectiveHorizontalStressKPa,
    waterPressureDifference = waterPressureDifferenceKPa,
    tangentialMultiplier = tangentialMultiplier
  )
  Direct <- calculateSectionResultants(
    load = Load,
    radius = radiusM,
    theta = theta,
    sectionRatio = sectionRatio,
    integrationSteps = as.integer(integrationSteps),
    balanceTolerance = balanceTolerance
  )
  Closed <- solveBiaxialTangentialMultiplierClosed(
    effectiveVertical = effectiveVerticalStressKPa,
    effectiveHorizontal = effectiveHorizontalStressKPa,
    waterPressureDifference = waterPressureDifferenceKPa,
    radius = radiusM,
    tangentialMultiplier = tangentialMultiplier,
    theta = theta,
    sectionRatio = sectionRatio
  )

  MeanPressure <- waterPressureDifferenceKPa +
    (effectiveVerticalStressKPa + effectiveHorizontalStressKPa) / 2
  Difference <- effectiveVerticalStressKPa - effectiveHorizontalStressKPa
  NormalMean <- -radiusM * MeanPressure
  NormalCosine <- radiusM * Difference *
    (1 + 2 * tangentialMultiplier) / 6
  MomentMean <- radiusM * sectionRatio / (1 + sectionRatio) * NormalMean
  MomentCosine <- radiusM^2 * Difference *
    (2 + tangentialMultiplier) / 12
  ShearSine <- -radiusM * Difference *
    (2 + tangentialMultiplier) / 6
  DirectValues <- Direct[["values", exact = TRUE]]
  Values <- data.frame(
    combinationID = rep(combinationID, nrow(DirectValues)),
    stageID = rep(stageID, nrow(DirectValues)),
    forceEffectStatus = rep(forceEffectStatus, nrow(DirectValues)),
    interactionModelID = rep(
      "prescribed-biaxial-direct-integration",
      nrow(DirectValues)
    ),
    interfaceID = rep(actionRepresentationID, nrow(DirectValues)),
    stressReferenceID = rep(stressReferenceID, nrow(DirectValues)),
    stressBasis = rep("effective-plus-net-water-pressure", nrow(DirectValues)),
    hydraulicActionTreatment = rep(
      "net-pressure-included",
      nrow(DirectValues)
    ),
    effectiveVerticalStressKPa = rep(
      effectiveVerticalStressKPa,
      nrow(DirectValues)
    ),
    effectiveHorizontalStressKPa = rep(
      effectiveHorizontalStressKPa,
      nrow(DirectValues)
    ),
    waterPressureDifferenceKPa = rep(
      waterPressureDifferenceKPa,
      nrow(DirectValues)
    ),
    stressRatio = rep(
      if (effectiveVerticalStressKPa == 0) {
        NA_real_
      } else {
        effectiveHorizontalStressKPa / effectiveVerticalStressKPa
      },
      nrow(DirectValues)
    ),
    tangentialMultiplier = rep(tangentialMultiplier, nrow(DirectValues)),
    thetaRad = DirectValues[["theta", exact = TRUE]],
    thetaDeg = DirectValues[["thetaDeg", exact = TRUE]],
    normalForceKnPerM = DirectValues[["normalForce", exact = TRUE]],
    bendingMomentKnMPerM = DirectValues[["bendingMoment", exact = TRUE]],
    shearForceKnPerM = DirectValues[["shearForce", exact = TRUE]],
    longitudinalBasis = rep("per-projected-metre", nrow(DirectValues)),
    stringsAsFactors = FALSE
  )
  Columns <- c(
    normalForce = "normalForce",
    bendingMoment = "bendingMoment",
    shearForce = "shearForce"
  )
  ClosedFormDifference <- vapply(names(Columns), function(s) {
    max(abs(
      DirectValues[[s, exact = TRUE]] -
        Closed[["values", exact = TRUE]][[Columns[[s]], exact = TRUE]]
    ))
  }, numeric(1))

  list(
    values = Values,
    amplitudesProject = c(
      normalMean = NormalMean,
      normalCosine = NormalCosine,
      momentMean = MomentMean,
      momentCosine = MomentCosine,
      shearSine = ShearSine
    ),
    response = Direct,
    closedForm = Closed,
    closedFormDifference = ClosedFormDifference,
    sectionRatio = sectionRatio,
    tangentialMultiplier = tangentialMultiplier,
    sourceKey = "Baker1968",
    sourceLocation = paste(
      "Direct equilibrium integration with periodic compatibility;",
      "closed biaxial solution used as the numerical control."
    ),
    limitations = paste(
      "Prescribed uniform biaxial stress projection;",
      "not a constitutive soil--lining contact law."
    )
  )
}

summarizePrescribedBiaxialInteraction <- function(result) {
  if (!is.list(result) ||
      is.null(result[["response", exact = TRUE]]) ||
      is.null(result[["values", exact = TRUE]])) {
    stop(
      "result must be returned by calculatePrescribedBiaxialInteraction().",
      call. = FALSE
    )
  }
  Summary <- summarizeSectionResultants(result[["response", exact = TRUE]])
  Values <- result[["values", exact = TRUE]]
  Units <- c(N = "kN/m", M = "kN m/m", Q = "kN/m")
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
    resultantID = Summary[["resultant", exact = TRUE]],
    statisticID = sub(
      "absoluteMaximum",
      "absolute-maximum",
      Summary[["statistic", exact = TRUE]],
      fixed = TRUE
    ),
    value = Summary[["value", exact = TRUE]],
    signedValue = Summary[["signedValue", exact = TRUE]],
    thetaRad = Summary[["theta", exact = TRUE]],
    thetaDeg = Summary[["thetaDeg", exact = TRUE]],
    unit = unname(Units[Summary[["resultant", exact = TRUE]]]),
    stringsAsFactors = FALSE
  )
}
