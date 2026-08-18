buildCalculationClassicalComparisonFigure <- function(data, liningID, height = 780) {
  Required <- c(
    "liningID", "methodID", "caseID", "thetaDeg", "resultantID",
    "value", "unit"
  )
  if (!is.data.frame(data) || any(!Required %in% names(data))) {
    stop("The classical-comparison curves have an invalid schema.", call. = FALSE)
  }
  Data <- data[data$liningID == liningID, , drop = FALSE]
  if (nrow(Data) == 0L) stop("The requested comparison curves are unavailable.", call. = FALSE)
  Closing <- Data[Data$thetaDeg == min(Data$thetaDeg), , drop = FALSE]
  Closing$thetaDeg <- 360
  Data <- rbind(Data, Closing)
  Data <- Data[order(Data$resultantID, Data$methodID, Data$caseID, Data$thetaDeg), ]

  Style <- data.frame(
    methodID = c(
      "official-hybrid", "official-hybrid",
      "schwartz-einstein-uniform", "schwartz-einstein-uniform",
      "prescribed-k0-ring", "prescribed-k0-ring"
    ),
    caseID = c(
      "alpha-1", "alpha-0",
      "schwartz-einstein-full-slip", "schwartz-einstein-no-slip",
      "alpha-1", "alpha-0"
    ),
    label = c(
      "Híbrido · deslizamiento libre", "Híbrido · sin deslizamiento",
      "E–S uniforme · deslizamiento libre", "E–S uniforme · sin deslizamiento",
      "K0 prescrito · proyección tangencial", "K0 prescrito · acción normal"
    ),
    color = c("#0072B2", "#56B4E9", "#D55E00", "#E69F00", "#009E73", "#7A9E2D"),
    dashStyle = c("Solid", "Solid", "ShortDash", "ShortDash", "Dot", "Dot"),
    lineWidth = c(2.8, 2.8, 2.2, 2.2, 2.0, 2.0),
    stringsAsFactors = FALSE
  )
  Resultants <- c("N", "M", "Q")
  AxisTitle <- c(N = "N [kN/m]", M = "M [kN·m/m]", Q = "Q [kN/m]")
  Top <- c("2%", "35%", "68%")
  Height <- "27%"
  Xaxes <- lapply(seq_along(Resultants), function(i) {
    list(
      min = 0, max = 360, tickInterval = 45, top = Top[i], height = Height,
      offset = 0, lineWidth = 1, gridLineWidth = 0,
      labels = list(enabled = i == length(Resultants)),
      title = list(text = if (i == length(Resultants)) "θ [°]" else NULL)
    )
  })
  Yaxes <- lapply(seq_along(Resultants), function(i) {
    list(
      top = Top[i], height = Height, offset = 0, gridLineWidth = 1,
      title = list(text = unname(AxisTitle[Resultants[i]])),
      labels = list(format = "{value:.1f}")
    )
  })
  Chart <- highcharter::highchart() |>
    highcharter::hc_size(height = height) |>
    highcharter::hc_chart(animation = FALSE, backgroundColor = "#FFFFFF") |>
    highcharter::hc_title(text = NULL) |>
    highcharter::hc_legend(
      align = "center", verticalAlign = "bottom", layout = "horizontal",
      symbolWidth = 28
    ) |>
    highcharter::hc_plotOptions(
      series = list(
        animation = FALSE, marker = list(enabled = FALSE), turboThreshold = 0,
        states = list(inactive = list(opacity = 1))
      )
    ) |>
    highcharter::hc_tooltip(
      useHTML = TRUE,
      formatter = htmlwidgets::JS(paste0(
        "function () { return '<b>' + this.series.name + '</b><br/>' + ",
        "'&theta; = ' + Highcharts.numberFormat(this.x, 1) + '&deg;<br/>' + ",
        "this.point.custom.resultant + ' = ' + Highcharts.numberFormat(this.y, 1) + ' ' + this.point.custom.unit; }"
      ))
    ) |>
    highcharter::hc_credits(enabled = FALSE) |>
    highcharter::hc_add_theme(HC.THEME)
  Chart <- do.call(highcharter::hc_xAxis_multiples, c(list(hc = Chart), Xaxes))
  Chart <- do.call(highcharter::hc_yAxis_multiples, c(list(hc = Chart), Yaxes))
  for (j in seq_along(Resultants)) {
    ResultantID <- Resultants[j]
    for (i in seq_len(nrow(Style))) {
      Current <- Data[
        Data$resultantID == ResultantID &
          Data$methodID == Style$methodID[i] & Data$caseID == Style$caseID[i],
        , drop = FALSE
      ]
      if (nrow(Current) == 0L) next
      Points <- lapply(seq_len(nrow(Current)), function(k) {
        list(
          x = Current$thetaDeg[k], y = Current$value[k],
          custom = list(resultant = ResultantID, unit = Current$unit[k])
        )
      })
      Chart <- highcharter::hc_add_series(
        Chart, data = Points, type = "line", xAxis = j - 1L, yAxis = j - 1L,
        name = Style$label[i], color = Style$color[i],
        dashStyle = Style$dashStyle[i], lineWidth = Style$lineWidth[i],
        showInLegend = j == 1L
      )
    }
  }
  Chart
}
