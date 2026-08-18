# Evaluate the USACE circumferential-thrust relation without creating an
# angular pressure field. Inputs and outputs retain their declared load basis.

if (any(!vapply(
  c(
    ".assertFiniteScalar", ".assertText", "usaceCrownPressure",
    "usaceCmpThrust"
  ),
  function(s) exists(s, mode = "function", inherits = TRUE),
  logical(1)
))) {
  stop(
    paste(
      "Source scripts/R/ringDirect.R and scripts/R/ringLoads.R before",
      "scripts/R/prismThrust.R."
    ),
    call. = FALSE
  )
}

calculatePrismThrust <- function(
  unitWeightKnPerM3,
  coverCrownM,
  spanM,
  deadLoadFactor,
  demandModifier,
  factorBasis,
  combinationID,
  stageID,
  forceEffectStatus,
  deadSurchargeKPa = 0,
  liveCrownPressureKPa = 0,
  liveLoadedWidthM = 0,
  liveLoadFactor = 0
) {
  .assertText(combinationID, "combinationID")
  .assertText(stageID, "stageID")
  .assertText(forceEffectStatus, "forceEffectStatus")
  .assertFiniteScalar(spanM, "spanM", minimum = 0, strict = TRUE)
  .assertFiniteScalar(deadSurchargeKPa, "deadSurchargeKPa", minimum = 0)
  .assertFiniteScalar(
    liveCrownPressureKPa,
    "liveCrownPressureKPa",
    minimum = 0
  )
  .assertFiniteScalar(liveLoadedWidthM, "liveLoadedWidthM", minimum = 0)
  .assertFiniteScalar(liveLoadFactor, "liveLoadFactor", minimum = 0)

  LiveValues <- c(
    liveCrownPressureKPa,
    liveLoadedWidthM,
    liveLoadFactor
  )
  if (!all(LiveValues == 0) && any(LiveValues <= 0)) {
    stop(
      "All live-load inputs must be positive, or all must be zero.",
      call. = FALSE
    )
  }
  if (liveLoadedWidthM > spanM) {
    stop("liveLoadedWidthM must not exceed spanM.", call. = FALSE)
  }
  LiveDistributionFactor <- if (all(LiveValues == 0)) {
    0
  } else {
    DistributionFactor.min <- max(0.381 / spanM, 1)
    max(0.75 * spanM / liveLoadedWidthM, DistributionFactor.min)
  }

  CrownPressure <- usaceCrownPressure(
    unitWeight = unitWeightKnPerM3,
    coverCrown = coverCrownM
  ) + deadSurchargeKPa
  Source <- usaceCmpThrust(
    deadCrownPressure = CrownPressure,
    span = spanM,
    deadLoadFactor = deadLoadFactor,
    demandModifier = demandModifier,
    factorBasis = factorBasis,
    liveCrownPressure = liveCrownPressureKPa,
    liveLoadedWidth = liveLoadedWidthM,
    liveDistributionFactor = LiveDistributionFactor,
    liveLoadFactor = liveLoadFactor
  )

  Values <- data.frame(
    combinationID = combinationID,
    stageID = stageID,
    forceEffectStatus = forceEffectStatus,
    loadModelID = "usace-em-1110-2-2902-equation-4-20",
    quantityID = c(
      "dead-crown-pressure", "dead-service-thrust", "live-service-thrust",
      "factored-thrust", "modified-demand"
    ),
    value = c(
      Source[["deadCrownPressure", exact = TRUE]],
      Source[["deadServiceThrust", exact = TRUE]],
      Source[["liveServiceThrust", exact = TRUE]],
      Source[["factoredThrust", exact = TRUE]],
      Source[["designDemand", exact = TRUE]]
    ),
    unit = c("kPa", rep("kN/m", 4L)),
    factorBasis = rep(factorBasis, 5L),
    liveDistributionFactor = rep(LiveDistributionFactor, 5L),
    forceEffectBasis = c(
      "unfactored-input", "unfactored-service", "unfactored-service",
      "factored-demand", "modified-factored-demand"
    ),
    angularDistributionStatus = "not-defined-by-source-relation",
    stringsAsFactors = FALSE
  )

  list(
    values = Values,
    source = Source,
    sourceKey = "USACE2020",
    sourceLocation = Source[["sourceLocation", exact = TRUE]],
    limitations = c(
      "scalar circumferential thrust relation",
      "does not provide angular contact pressure",
      "does not provide bending moment or shear force"
    )
  )
}
