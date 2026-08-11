source("scripts/R/ringFigureData.R")
source("scripts/fig/ringParametric.R")

buildCalculationEnvelopes <- function(
  pathQuantiles,
  resultant,
  displayScale,
  radius
) {
  if (!file.exists(pathQuantiles)) {
    stop("The pointwise-quantile file is not available.", call. = FALSE)
  }
  quantiles <- utils::read.csv(pathQuantiles, check.names = FALSE)
  quantiles <- quantiles[quantiles$resultant == resultant, , drop = FALSE]
  prepared <- prepareRingEnvelope(quantiles, displayScale, radius)
  geometry <- prepared$geometry
  labels <- c(
    paste0("q", prepared$probabilities["lower"]),
    paste0("q", prepared$probabilities["central"]),
    paste0("q", prepared$probabilities["upper"])
  )
  geometry$prescription <- labels[match(geometry$case, labels)]
  chart <- buildRingParametricPlot(
    geometry = geometry,
    title = paste("Cuantiles puntuales de", resultant),
    baselineRadius = radius,
    colors = c("#56B4E9", "#0072B2", "#56B4E9")
  )
  lower <- geometry[geometry$case == labels[1L], , drop = FALSE]
  upper <- geometry[geometry$case == labels[3L], , drop = FALSE]
  polygon <- rbind(upper, lower[nrow(lower):1L, , drop = FALSE])
  polygonData <- lapply(seq_len(nrow(polygon)), function(index) {
    list(x = polygon$x[index], y = polygon$y[index])
  })
  highcharter::hc_add_series(
    chart,
    data = polygonData,
    type = "polygon",
    name = paste0(labels[1L], "–", labels[3L]),
    color = "rgba(86,180,233,0.18)",
    lineWidth = 0,
    enableMouseTracking = FALSE,
    zIndex = 0
  )
}
