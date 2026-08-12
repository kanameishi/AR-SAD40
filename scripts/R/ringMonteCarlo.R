# Monte Carlo orchestration for the circular-ring methodology.
#
# The runner consumes realized draws. It does not select distributions,
# correlations, truncation limits, source weights, or model probabilities.
# Those choices belong in the analysis specification and remain auditable in
# the supplied data frame.

if (!exists("solveRingDirect", mode = "function")) {
  stop("Source scripts/R/ringDirect.R before scripts/R/ringMonteCarlo.R.", call. = FALSE)
}

.validateProbabilities <- function(probabilities) {
  if (!is.numeric(probabilities) || length(probabilities) == 0L ||
      any(!is.finite(probabilities)) || any(probabilities < 0) ||
      any(probabilities > 1)) {
    stop("probabilities must be finite numeric values in [0, 1].", call. = FALSE)
  }
  sort(unique(probabilities))
}

.quantiles <- function(values, probabilities, quantileType) {
  as.numeric(stats::quantile(
    values,
    probs = probabilities,
    names = FALSE,
    type = quantileType
  ))
}

.validateQuantileType <- function(quantileType) {
  .assertFiniteScalar(quantileType, "quantileType", minimum = 1)
  if (quantileType != as.integer(quantileType) || quantileType > 9) {
    stop("quantileType must be an integer from 1 through 9.", call. = FALSE)
  }
  as.integer(quantileType)
}

.responseExtrema <- function(response, sampleID) {
  OUT <- summarizeSectionResultants(response)
  OUT$sampleID <- sampleID
  OUT <- OUT[, c(
    "sampleID", "resultant", "statistic", "value", "signedValue",
    "theta", "thetaDeg"
  )]
  OUT
}

runRingMonteCarlo <- function(
  draws,
  responseFunction,
  theta,
  probabilities = c(0.05, 0.50, 0.95),
  modelLabel,
  quantileType = 7L,
  keepSampleCurves = FALSE
) {
  if (!is.data.frame(draws) || nrow(draws) == 0L) {
    stop("draws must be a non-empty data frame.", call. = FALSE)
  }
  if (!is.function(responseFunction)) {
    stop("responseFunction must be a function.", call. = FALSE)
  }
  .assertTheta(theta)
  .assertText(modelLabel, "modelLabel")
  Probabilities <- .validateProbabilities(probabilities)
  QuantileType <- .validateQuantileType(quantileType)
  if (!is.logical(keepSampleCurves) || length(keepSampleCurves) != 1L ||
      is.na(keepSampleCurves)) {
    stop("keepSampleCurves must be TRUE or FALSE.", call. = FALSE)
  }

  SampleCount <- nrow(draws)
  AngleCount <- length(theta)
  Curves <- list(
    N = matrix(NA_real_, nrow = SampleCount, ncol = AngleCount),
    M = matrix(NA_real_, nrow = SampleCount, ncol = AngleCount),
    Q = matrix(NA_real_, nrow = SampleCount, ncol = AngleCount)
  )
  Extrema <- vector("list", SampleCount)
  Diagnostics <- vector("list", SampleCount)

  for (i in seq_len(SampleCount)) {
    Draw <- draws[i, , drop = FALSE]
    Response <- responseFunction(Draw, theta)
    if (!inherits(Response, "ringDirectResponse")) {
      stop(
        "responseFunction must return a ringDirectResponse; sample ",
        i,
        " did not.",
        call. = FALSE
      )
    }
    if (!isTRUE(Response$diagnostics$valid)) {
      stop(
        "responseFunction returned an unbalanced ring response at sample ",
        i,
        ".",
        call. = FALSE
      )
    }
    Values <- Response$values
    Required <- c(
      "theta", "thetaDeg", "normalForce", "bendingMoment", "shearForce"
    )
    if (!identical(names(Values), Required) || nrow(Values) != AngleCount ||
        max(abs(Values$theta - theta)) > 1e-12) {
      stop(
        "responseFunction returned a different angular grid at sample ",
        i,
        ".",
        call. = FALSE
      )
    }
    if (any(!is.finite(as.matrix(Values[, -c(1L, 2L), drop = FALSE])))) {
      stop("Non-finite resultant at sample ", i, ".", call. = FALSE)
    }

    Curves$N[i, ] <- Values$normalForce
    Curves$M[i, ] <- Values$bendingMoment
    Curves$Q[i, ] <- Values$shearForce
    Extrema[[i]] <- .responseExtrema(Response, i)
    Diagnostics[[i]] <- Response$diagnostics
  }

  Pointwise <- do.call(rbind, lapply(names(Curves), function(resultant) {
    QuantileMatrix <- apply(Curves[[resultant]], 2L, function(values) {
      .quantiles(values, Probabilities, QuantileType)
    })
    dim(QuantileMatrix) <- c(length(Probabilities), AngleCount)
    do.call(rbind, lapply(seq_along(Probabilities), function(i) {
      data.frame(
        model = modelLabel,
        resultant = resultant,
        probability = Probabilities[i],
        theta = theta,
        thetaDeg = theta * 180 / pi,
        value = QuantileMatrix[i, ],
        stringsAsFactors = FALSE
      )
    }))
  }))
  rownames(Pointwise) <- NULL

  ExtremaSamples <- do.call(rbind, Extrema)
  rownames(ExtremaSamples) <- NULL
  ExtremaGroups <- split(
    ExtremaSamples,
    list(ExtremaSamples$resultant, ExtremaSamples$statistic),
    drop = TRUE
  )
  ExtremaQuantiles <- do.call(rbind, lapply(ExtremaGroups, function(group) {
    data.frame(
      model = modelLabel,
      resultant = group$resultant[1L],
      statistic = group$statistic[1L],
      probability = Probabilities,
      value = .quantiles(group$value, Probabilities, QuantileType),
      stringsAsFactors = FALSE
    )
  }))
  rownames(ExtremaQuantiles) <- NULL

  Result <- list(
    model = modelLabel,
    sampleCount = SampleCount,
    theta = theta,
    probabilities = Probabilities,
    quantileType = QuantileType,
    pointwiseQuantiles = Pointwise,
    extremaSamples = ExtremaSamples,
    extremaQuantiles = ExtremaQuantiles,
    draws = draws,
    diagnostics = Diagnostics
  )
  if (keepSampleCurves) {
    Result$sampleCurves <- Curves
  }
  class(Result) <- "ringMonteCarlo"
  Result
}

runOutputMonteCarlo <- function(
  draws,
  outputFunction,
  probabilities = c(0.05, 0.50, 0.95),
  modelLabel,
  quantileType = 7L,
  keepSamples = TRUE
) {
  if (!is.data.frame(draws) || nrow(draws) == 0L) {
    stop("draws must be a non-empty data frame.", call. = FALSE)
  }
  if (!is.function(outputFunction)) {
    stop("outputFunction must be a function.", call. = FALSE)
  }
  .assertText(modelLabel, "modelLabel")
  Probabilities <- .validateProbabilities(probabilities)
  QuantileType <- .validateQuantileType(quantileType)
  if (!is.logical(keepSamples) || length(keepSamples) != 1L ||
      is.na(keepSamples)) {
    stop("keepSamples must be TRUE or FALSE.", call. = FALSE)
  }

  Outputs <- lapply(seq_len(nrow(draws)), function(i) {
    Value <- outputFunction(draws[i, , drop = FALSE])
    if (!is.numeric(Value) || any(!is.finite(Value)) ||
        is.null(names(Value)) || any(!nzchar(names(Value))) ||
        anyDuplicated(names(Value))) {
      stop(
        "outputFunction must return a finite, uniquely named numeric vector; ",
        "sample ",
        i,
        " did not.",
        call. = FALSE
      )
    }
    Value
  })
  OutputNames <- names(Outputs[[1L]])
  if (any(!vapply(Outputs, function(value) {
    identical(names(value), OutputNames)
  }, logical(1)))) {
    stop("outputFunction must return the same names in the same order.", call. = FALSE)
  }
  SampleMatrix <- do.call(rbind, Outputs)

  Quantiles <- do.call(rbind, lapply(seq_along(OutputNames), function(i) {
    data.frame(
      model = modelLabel,
      output = OutputNames[i],
      probability = Probabilities,
      value = .quantiles(
        SampleMatrix[, i],
        Probabilities,
        QuantileType
      ),
      stringsAsFactors = FALSE
    )
  }))
  rownames(Quantiles) <- NULL

  Result <- list(
    model = modelLabel,
    sampleCount = nrow(draws),
    probabilities = Probabilities,
    quantileType = QuantileType,
    quantiles = Quantiles,
    draws = draws
  )
  if (isTRUE(keepSamples)) {
    Result$samples <- as.data.frame(SampleMatrix, check.names = FALSE)
  }
  class(Result) <- "outputMonteCarlo"
  Result
}
