# Adds the calculation-memo metadata to an existing ringMonteCarlo result.
# Distribution selection and sample generation remain outside this adapter.

prepareCalculationMonteCarloProducts <- function(
  result,
  caseID,
  stageID,
  units = c(N = "kN/m", M = "kN m/m", Q = "kN/m")
) {
  if (!inherits(result, "ringMonteCarlo")) {
    stop("result must be returned by runRingMonteCarlo().", call. = FALSE)
  }
  .assertText(caseID, "caseID")
  .assertText(stageID, "stageID")
  if (!is.character(units) || !identical(sort(names(units)), c("M", "N", "Q")) ||
      any(!nzchar(units))) {
    stop("units must be a named character vector for N, M and Q.", call. = FALSE)
  }

  Pointwise <- result$pointwiseQuantiles
  Pointwise$case <- caseID
  Pointwise$stage <- stageID
  Pointwise$thetaIndex <- ave(
    Pointwise$theta,
    Pointwise$model,
    Pointwise$resultant,
    Pointwise$probability,
    FUN = function(value) seq_along(value) - 1L
  )
  Pointwise$unit <- unname(units[Pointwise$resultant])
  Pointwise$sampleCount <- result$sampleCount
  Pointwise$quantileType <- result$quantileType
  Pointwise$statisticScope <- "pointwise"
  Pointwise <- Pointwise[, c(
    "case", "stage", "model", "resultant", "probability", "thetaIndex",
    "theta", "thetaDeg", "value", "unit", "sampleCount", "quantileType",
    "statisticScope"
  )]

  ExtremaSamples <- result$extremaSamples
  ExtremaSamples$case <- caseID
  ExtremaSamples$stage <- stageID
  ExtremaSamples$model <- result$model
  ExtremaSamples$unit <- unname(units[ExtremaSamples$resultant])
  ExtremaSamples <- ExtremaSamples[, c(
    "sampleID", "case", "stage", "model", "resultant", "statistic",
    "value", "signedValue", "theta", "thetaDeg", "unit"
  )]

  ExtremaQuantiles <- result$extremaQuantiles
  ExtremaQuantiles$case <- caseID
  ExtremaQuantiles$stage <- stageID
  ExtremaQuantiles$unit <- unname(units[ExtremaQuantiles$resultant])
  ExtremaQuantiles$sampleCount <- result$sampleCount
  ExtremaQuantiles$quantileType <- result$quantileType
  ExtremaQuantiles$valueBasis <- ifelse(
    ExtremaQuantiles$statistic == "absoluteMaximum",
    "absolute",
    "signed"
  )
  ExtremaQuantiles$statisticScope <- "spatialExtremum"
  ExtremaQuantiles <- ExtremaQuantiles[, c(
    "case", "stage", "model", "resultant", "statistic", "probability",
    "value", "unit", "sampleCount", "quantileType", "valueBasis",
    "statisticScope"
  )]

  list(
    pointwiseQuantiles = Pointwise,
    extremaSamples = ExtremaSamples,
    extremaQuantiles = ExtremaQuantiles
  )
}

writeCalculationMonteCarloProducts <- function(products, directory) {
  Required <- c("pointwiseQuantiles", "extremaSamples", "extremaQuantiles")
  if (!is.list(products) || !all(Required %in% names(products))) {
    stop("products must contain the three calculation-memo tables.", call. = FALSE)
  }
  if (!is.character(directory) || length(directory) != 1L || !nzchar(directory)) {
    stop("directory must be one non-empty path.", call. = FALSE)
  }
  if (!dir.exists(directory)) {
    dir.create(directory, recursive = TRUE)
  }
  Paths <- file.path(
    directory,
    c(
      "ring-pointwise-quantiles.csv",
      "ring-extrema-samples.csv",
      "ring-extrema-quantiles.csv"
    )
  )
  for (i in seq_along(Required)) {
    utils::write.csv(
      products[[Required[i]]],
      Paths[i],
      row.names = FALSE,
      na = ""
    )
  }
  invisible(Paths)
}
