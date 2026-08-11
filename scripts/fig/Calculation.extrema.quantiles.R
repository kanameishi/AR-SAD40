buildCalculationExtremaQuantiles <- function(pathQuantiles) {
  if (!file.exists(pathQuantiles)) {
    stop("The extrema-quantile file is not available.", call. = FALSE)
  }
  data <- utils::read.csv(pathQuantiles, check.names = FALSE)
  required <- c(
    "model", "resultant", "statistic", "probability", "value", "unit",
    "statisticScope"
  )
  missing <- setdiff(required, names(data))
  if (length(missing) > 0L) {
    stop("Extrema quantiles are missing required columns.", call. = FALSE)
  }
  if ("theta" %in% names(data) || "thetaDeg" %in% names(data)) {
    stop("Spatial-extremum quantiles must not contain an angular coordinate.", call. = FALSE)
  }
  if (any(data$statisticScope != "spatialExtremum")) {
    stop("All rows must have statisticScope = spatialExtremum.", call. = FALSE)
  }
  if (!requireNamespace("highcharter", quietly = TRUE)) {
    stop("Package highcharter is required.", call. = FALSE)
  }
  charts <- lapply(unique(data$resultant), function(resultant) {
    currentResultant <- data[data$resultant == resultant, , drop = FALSE]
    units <- unique(currentResultant$unit)
    if (length(units) != 1L) {
      stop("Each resultant must use one physical unit.", call. = FALSE)
    }
    categories <- unique(currentResultant$statistic)
    chart <- highcharter::highchart() |>
      highcharter::hc_chart(type = "column", animation = FALSE) |>
      highcharter::hc_title(
        text = paste("Extremos espaciales —", resultant)
      ) |>
      highcharter::hc_xAxis(categories = categories) |>
      highcharter::hc_yAxis(title = list(text = units[1L])) |>
      highcharter::hc_plotOptions(
        series = list(animation = FALSE, turboThreshold = 0)
      )
    for (probability in sort(unique(currentResultant$probability))) {
      current <- currentResultant[
        currentResultant$probability == probability,
        ,
        drop = FALSE
      ]
      values <- current$value[match(categories, current$statistic)]
      chart <- highcharter::hc_add_series(
        chart,
        name = paste0("q", probability),
        data = as.list(values),
        type = "column"
      )
    }
    chart
  })
  htmltools::div(
    style = paste(
      "display:grid;",
      "grid-template-columns:repeat(auto-fit,minmax(360px,1fr));",
      "gap:1rem;align-items:start;"
    ),
    charts
  )
}
