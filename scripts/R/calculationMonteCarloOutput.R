# Adds the calculation-memo metadata to an existing ringMonteCarlo result.
# Distribution selection and sample generation remain outside this adapter.

prepareCalculationMonteCarloProducts <- function(
  result,
  caseId,
  stageId,
  units = c(N = "kN/m", M = "kN m/m", Q = "kN/m")
) {
  if (!inherits(result, "ringMonteCarlo")) {
    stop("result must be returned by runRingMonteCarlo().", call. = FALSE)
  }
  .assertText(caseId, "caseId")
  .assertText(stageId, "stageId")
  if (!is.character(units) || !identical(sort(names(units)), c("M", "N", "Q")) ||
      any(!nzchar(units))) {
    stop("units must be a named character vector for N, M and Q.", call. = FALSE)
  }

  pointwise <- result$pointwiseQuantiles
  pointwise$case <- caseId
  pointwise$stage <- stageId
  pointwise$thetaIndex <- ave(
    pointwise$theta,
    pointwise$model,
    pointwise$resultant,
    pointwise$probability,
    FUN = function(value) seq_along(value) - 1L
  )
  pointwise$unit <- unname(units[pointwise$resultant])
  pointwise$sampleCount <- result$sampleCount
  pointwise$quantileType <- result$quantileType
  pointwise$statisticScope <- "pointwise"
  pointwise <- pointwise[, c(
    "case", "stage", "model", "resultant", "probability", "thetaIndex",
    "theta", "thetaDeg", "value", "unit", "sampleCount", "quantileType",
    "statisticScope"
  )]

  extremaSamples <- result$extremaSamples
  extremaSamples$case <- caseId
  extremaSamples$stage <- stageId
  extremaSamples$model <- result$model
  extremaSamples$unit <- unname(units[extremaSamples$resultant])
  extremaSamples <- extremaSamples[, c(
    "sampleId", "case", "stage", "model", "resultant", "statistic",
    "value", "signedValue", "theta", "thetaDeg", "unit"
  )]

  extremaQuantiles <- result$extremaQuantiles
  extremaQuantiles$case <- caseId
  extremaQuantiles$stage <- stageId
  extremaQuantiles$unit <- unname(units[extremaQuantiles$resultant])
  extremaQuantiles$sampleCount <- result$sampleCount
  extremaQuantiles$quantileType <- result$quantileType
  extremaQuantiles$valueBasis <- ifelse(
    extremaQuantiles$statistic == "absoluteMaximum",
    "absolute",
    "signed"
  )
  extremaQuantiles$statisticScope <- "spatialExtremum"
  extremaQuantiles <- extremaQuantiles[, c(
    "case", "stage", "model", "resultant", "statistic", "probability",
    "value", "unit", "sampleCount", "quantileType", "valueBasis",
    "statisticScope"
  )]

  list(
    pointwiseQuantiles = pointwise,
    extremaSamples = extremaSamples,
    extremaQuantiles = extremaQuantiles
  )
}

writeCalculationMonteCarloProducts <- function(products, directory) {
  required <- c("pointwiseQuantiles", "extremaSamples", "extremaQuantiles")
  if (!is.list(products) || !all(required %in% names(products))) {
    stop("products must contain the three calculation-memo tables.", call. = FALSE)
  }
  if (!is.character(directory) || length(directory) != 1L || !nzchar(directory)) {
    stop("directory must be one non-empty path.", call. = FALSE)
  }
  if (!dir.exists(directory)) {
    dir.create(directory, recursive = TRUE)
  }
  paths <- file.path(
    directory,
    c(
      "ring-pointwise-quantiles.csv",
      "ring-extrema-samples.csv",
      "ring-extrema-quantiles.csv"
    )
  )
  for (index in seq_along(required)) {
    utils::write.csv(
      products[[required[index]]],
      paths[index],
      row.names = FALSE,
      na = ""
    )
  }
  invisible(paths)
}
