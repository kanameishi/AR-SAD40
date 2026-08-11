# Highcharter renderer for already prepared circular-section geometry.

ringEqualAspectLimits <- function(limit, plotWidth, plotHeight) {
  values <- c(limit, plotWidth, plotHeight)
  if (any(!is.finite(values)) || any(values <= 0)) {
    stop("limit and plot dimensions must be positive and finite.", call. = FALSE)
  }
  unitPerPixel <- 2 * limit / min(plotWidth, plotHeight)
  list(
    x = c(-1, 1) * unitPerPixel * plotWidth / 2,
    y = c(-1, 1) * unitPerPixel * plotHeight / 2
  )
}

buildRingParametricPlot <- function(
  geometry,
  title,
  baselineRadius,
  colors = c("#0072B2", "#D55E00", "#009E73", "#CC79A7")
) {
  assertFigureColumns(
    geometry,
    c(
      "case", "prescription", "resultant", "thetaDeg", "value", "unit",
      "x", "y", "radialFraction"
    ),
    "geometry"
  )
  if (length(unique(geometry$resultant)) != 1L) {
    stop("geometry must contain exactly one resultant.", call. = FALSE)
  }
  if (!requireNamespace("highcharter", quietly = TRUE)) {
    stop("Package highcharter is required.", call. = FALSE)
  }
  if (!requireNamespace("htmlwidgets", quietly = TRUE)) {
    stop("Package htmlwidgets is required.", call. = FALSE)
  }

  limit <- baselineRadius * (1 + max(geometry$radialFraction) + 0.12)
  ringTheta <- seq(0, 2 * pi, length.out = 361L)
  ringData <- lapply(seq_along(ringTheta), function(index) {
    list(
      x = baselineRadius * sin(ringTheta[index]),
      y = baselineRadius * cos(ringTheta[index])
    )
  })
  equalAspectHandler <- htmlwidgets::JS(paste0(
    "function () {",
    "var chart = this, limit = ", format(limit, digits = 17L), ";",
    "if (chart.__equalAspectActive || !chart.plotWidth || !chart.plotHeight) return;",
    "var unitPerPixel = 2 * limit / Math.min(chart.plotWidth, chart.plotHeight);",
    "var xHalf = unitPerPixel * chart.plotWidth / 2;",
    "var yHalf = unitPerPixel * chart.plotHeight / 2;",
    "var xAxis = chart.xAxis[0], yAxis = chart.yAxis[0];",
    "var tolerance = limit * 1e-10;",
    "var unchanged = Math.abs(xAxis.min + xHalf) <= tolerance && ",
    "Math.abs(xAxis.max - xHalf) <= tolerance && ",
    "Math.abs(yAxis.min + yHalf) <= tolerance && ",
    "Math.abs(yAxis.max - yHalf) <= tolerance;",
    "if (unchanged) return;",
    "chart.__equalAspectActive = true;",
    "xAxis.setExtremes(-xHalf, xHalf, false, false, {trigger: 'equalAspect'});",
    "yAxis.setExtremes(-yHalf, yHalf, false, false, {trigger: 'equalAspect'});",
    "chart.redraw(false);",
    "chart.__equalAspectActive = false;",
    "}"
  ))

  chart <- highcharter::highchart() |>
    highcharter::hc_chart(
      type = "line",
      width = 420,
      height = 420,
      animation = FALSE,
      spacing = c(18, 18, 18, 18),
      events = list(render = equalAspectHandler)
    ) |>
    highcharter::hc_title(text = title) |>
    highcharter::hc_xAxis(
      min = -limit,
      max = limit,
      title = list(text = NULL),
      labels = list(enabled = FALSE),
      tickLength = 0,
      gridLineWidth = 0,
      lineWidth = 0,
      startOnTick = FALSE,
      endOnTick = FALSE
    ) |>
    highcharter::hc_yAxis(
      min = -limit,
      max = limit,
      title = list(text = NULL),
      labels = list(enabled = FALSE),
      tickLength = 0,
      gridLineWidth = 0,
      lineWidth = 0,
      startOnTick = FALSE,
      endOnTick = FALSE
    ) |>
    highcharter::hc_legend(
      align = "center",
      verticalAlign = "bottom",
      layout = "horizontal"
    ) |>
    highcharter::hc_plotOptions(
      series = list(
        animation = FALSE,
        marker = list(enabled = FALSE),
        lineWidth = 2.4,
        requireSorting = FALSE,
        findNearestPointBy = "xy",
        turboThreshold = 0
      )
    ) |>
    highcharter::hc_tooltip(
      useHTML = TRUE,
      formatter = htmlwidgets::JS(paste0(
        "function () {",
        "if (!this.point.custom) { return false; }",
        "return '<b>' + this.series.name + '</b><br/>' +",
        "'&theta; = ' + Highcharts.numberFormat(this.point.custom.thetaDeg, 1) + '&deg;<br/>' +",
        "this.point.custom.resultant + ' = ' + Highcharts.numberFormat(this.point.custom.value, 3) + ' ' + this.point.custom.unit;",
        "}"
      ))
    ) |>
    highcharter::hc_add_series(
      data = ringData,
      name = "Sección de referencia",
      color = "#5B6573",
      dashStyle = "ShortDash",
      lineWidth = 1.4,
      enableMouseTracking = FALSE,
      showInLegend = FALSE
    )

  cases <- unique(geometry$case)
  for (index in seq_along(cases)) {
    current <- geometry[geometry$case == cases[index], , drop = FALSE]
    pointData <- lapply(seq_len(nrow(current)), function(row) {
      list(
        x = current$x[row],
        y = current$y[row],
        custom = list(
          thetaDeg = current$thetaDeg[row] %% 360,
          value = current$value[row],
          unit = current$unit[row],
          resultant = current$resultant[row]
        )
      )
    })
    chart <- highcharter::hc_add_series(
      chart,
      data = pointData,
      name = current$prescription[1L],
      color = colors[(index - 1L) %% length(colors) + 1L],
      type = "line"
    )
  }

  cardinal <- data.frame(
    x = c(0, baselineRadius, 0, -baselineRadius),
    y = c(baselineRadius, 0, -baselineRadius, 0),
    label = c("Clave", "Hastial", "Solera", "Hastial"),
    stringsAsFactors = FALSE
  )
  chart <- highcharter::hc_add_series(
    chart,
    data = lapply(seq_len(nrow(cardinal)), function(index) {
      list(x = cardinal$x[index], y = cardinal$y[index], name = cardinal$label[index])
    }),
    type = "scatter",
    name = "Posiciones",
    color = "#31363F",
    marker = list(enabled = FALSE),
    dataLabels = list(
      enabled = TRUE,
      format = "{point.name}",
      style = list(fontSize = "10px", fontWeight = "normal", textOutline = "none")
    ),
    enableMouseTracking = FALSE,
    showInLegend = FALSE
  )
  chart
}

.ringPointData <- function(data) {
  lapply(seq_len(nrow(data)), function(i) {
    list(
      x = data$x[i],
      y = data$y[i],
      custom = list(
        thetaDeg = data$thetaDeg[i] %% 360,
        value = data$value[i],
        unit = data$unit[i],
        resultant = data$resultant[i]
      )
    )
  })
}

.ringSegmentData <- function(data) {
  OUT <- vector("list", nrow(data) * 3L)
  k <- 1L
  for (i in seq_len(nrow(data))) {
    OUT[k] <- list(list(x = data$xSection[i], y = data$ySection[i]))
    OUT[k + 1L] <- list(list(x = data$x[i], y = data$y[i]))
    OUT[k + 2L] <- list(NULL)
    k <- k + 3L
  }
  OUT[-length(OUT)]
}

.ringPanelAxis <- function(left, top, size, limit, title = NULL) {
  list(
    min = -limit,
    max = limit,
    left = left,
    top = top,
    width = size,
    height = size,
    offset = 0,
    minPadding = 0,
    maxPadding = 0,
    startOnTick = FALSE,
    endOnTick = FALSE,
    tickLength = 0,
    lineWidth = 0,
    gridLineWidth = 0,
    labels = list(enabled = FALSE),
    title = list(
      text = title,
      margin = 8,
      style = list(
        color = "#1F2933",
        fontSize = "13px",
        fontWeight = "600"
      )
    )
  )
}

.ringLayoutHandler <- function(panelCount) {
  htmlwidgets::JS(paste0(
    "function () {",
    "var chart = this, count = ", panelCount, ";",
    "if (chart.__sectionLayoutActive || chart.xAxis.length < count || chart.yAxis.length < count) return;",
    "var outerGap = Math.max(10, Math.min(24, chart.plotWidth * 0.025));",
    "var panelGap = Math.max(12, Math.min(42, chart.plotWidth * 0.035));",
    "var topSpace = chart.subtitle && chart.subtitle.textStr ? 40 : 10;",
    "var bottomSpace = 30;",
    "var availableWidth = chart.plotWidth - 2 * outerGap - (count - 1) * panelGap;",
    "var availableHeight = chart.plotHeight - topSpace - bottomSpace;",
    "var size = Math.floor(Math.min(availableWidth / count, availableHeight));",
    "if (!Number.isFinite(size) || size <= 0) return;",
    "var totalWidth = count * size + (count - 1) * panelGap;",
    "var left = chart.plotLeft + (chart.plotWidth - totalWidth) / 2;",
    "var top = chart.plotTop + topSpace + Math.max(0, (availableHeight - size) / 2);",
    "var changed = false;",
    "chart.__sectionLayoutActive = true;",
    "for (var i = 0; i < count; i += 1) {",
    "var options = {left: Math.round(left + i * (size + panelGap)), top: Math.round(top), width: size, height: size};",
    "var xAxis = chart.xAxis[i], yAxis = chart.yAxis[i];",
    "if (Math.abs(xAxis.left - options.left) > 0.5 || Math.abs(xAxis.top - options.top) > 0.5 || Math.abs(xAxis.width - size) > 0.5 || Math.abs(xAxis.height - size) > 0.5) {",
    "xAxis.update(options, false);",
    "yAxis.update(options, false);",
    "changed = true;",
    "}",
    "}",
    "if (changed) chart.redraw(false);",
    "chart.__sectionLayoutActive = false;",
    "}"
  ))
}

buildRingComparisonPlot <- function(
  geometry,
  baselineRadius,
  raysPerCircle = 24L,
  width = 1200,
  height = 560,
  subtitle = "Las formulaciones pueden activarse o desactivarse desde la leyenda."
) {
  assertFigureColumns(
    geometry,
    c(
      "case", "prescription", "resultant", "thetaDeg", "value", "unit",
      "x", "y", "radialFraction", "displayClosed"
    ),
    "geometry"
  )
  if (!requireNamespace("highcharter", quietly = TRUE)) {
    stop("Package highcharter is required.", call. = FALSE)
  }
  if (!requireNamespace("htmlwidgets", quietly = TRUE)) {
    stop("Package htmlwidgets is required.", call. = FALSE)
  }
  if (!is.numeric(width) || length(width) != 1L || !is.finite(width) ||
      width < 900 || !is.numeric(height) || length(height) != 1L ||
      !is.finite(height) || height < 500) {
    stop("width and height are insufficient for three square panels.", call. = FALSE)
  }

  Resultants <- c("N", "M", "Q")
  Titles <- c(
    N = "Fuerza normal, Nθ [kN/m]",
    M = "Momento flector, Mθ [kN·m/m]",
    Q = "Fuerza cortante, Qθ [kN/m]"
  )
  if (!setequal(unique(geometry$resultant), Resultants)) {
    stop("geometry must contain the N, M and Q resultants.", call. = FALSE)
  }
  Cases <- unique(geometry$case)
  if (length(Cases) < 1L || any(vapply(Cases, function(s) {
    length(unique(geometry$prescription[geometry$case == s])) != 1L
  }, logical(1)))) {
    stop("Each case requires one public prescription.", call. = FALSE)
  }

  Rays <- prepareRingRays(
    geometry = geometry,
    baselineRadius = baselineRadius,
    raysPerCircle = raysPerCircle,
    phaseDegByCase = stats::setNames(
      ((seq_along(Cases) - 1L) * 5) %% (360 / raysPerCircle),
      Cases
    )
  )
  Limits <- vapply(Resultants, function(s) {
    baselineRadius * (
      1 + max(geometry$radialFraction[geometry$resultant == s]) + 0.18
    )
  }, numeric(1))
  OuterGap <- 24
  PanelGap <- 42
  PanelTop <- 60
  PanelSize <- floor((width - 2 * OuterGap - 2 * PanelGap) / 3)
  if (PanelTop + PanelSize + 115 > height) {
    stop("height is insufficient for the square panels and legend.", call. = FALSE)
  }
  Left <- OuterGap + (seq_along(Resultants) - 1L) * (PanelSize + PanelGap)
  Xaxes <- Map(
    function(x, limit, s) {
      .ringPanelAxis(
        x,
        PanelTop,
        PanelSize,
        limit,
        unname(Titles[[s]])
      )
    },
    Left,
    Limits,
    Resultants
  )
  Yaxes <- Map(function(x, limit) {
    Axis <- .ringPanelAxis(
      x,
      PanelTop,
      PanelSize,
      limit
    )
    Axis$title <- list(text = NULL)
    Axis
  }, Left, Limits)

  Chart <- highcharter::highchart() |>
    highcharter::hc_size(height = height) |>
    highcharter::hc_chart(
      reflow = TRUE,
      animation = FALSE,
      backgroundColor = "#FFFFFF",
      spacing = c(10, 10, 52, 10),
      events = list(render = .ringLayoutHandler(length(Resultants)))
    ) |>
    highcharter::hc_title(text = NULL) |>
    highcharter::hc_subtitle(
      text = subtitle,
      style = list(color = "#4B5563", fontSize = "11px")
    ) |>
    highcharter::hc_legend(
      align = "center",
      verticalAlign = "bottom",
      layout = "horizontal",
      symbolWidth = 30
    ) |>
    highcharter::hc_plotOptions(
      series = list(
        animation = FALSE,
        marker = list(enabled = FALSE),
        states = list(inactive = list(opacity = 1)),
        turboThreshold = 0
      )
    ) |>
    highcharter::hc_tooltip(
      useHTML = TRUE,
      formatter = htmlwidgets::JS(paste0(
        "function () {",
        "if (!this.point.custom) return false;",
        "return '<b>' + this.series.name + '</b><br/>' +",
        "'&theta; = ' + Highcharts.numberFormat(this.point.custom.thetaDeg, 1) + '&deg;<br/>' +",
        "this.point.custom.resultant + ' = ' + Highcharts.numberFormat(this.point.custom.value, 3) + ' ' + this.point.custom.unit;",
        "}"
      ))
    ) |>
    highcharter::hc_credits(enabled = FALSE)
  Chart <- do.call(
    highcharter::hc_xAxis_multiples,
    c(list(hc = Chart), unname(Xaxes))
  )
  Chart <- do.call(
    highcharter::hc_yAxis_multiples,
    c(list(hc = Chart), unname(Yaxes))
  )

  RingTheta <- seq(0, 2 * pi, length.out = 361L)
  RingData <- lapply(RingTheta, function(x) {
    list(x = baselineRadius * sin(x), y = baselineRadius * cos(x))
  })
  for (j in seq_along(Resultants)) {
    AxisIndex <- j - 1L
    Chart <- highcharter::hc_add_series(
      Chart,
      data = RingData,
      type = "line",
      xAxis = AxisIndex,
      yAxis = AxisIndex,
      name = "Reference section",
      color = "#68727D",
      dashStyle = "ShortDash",
      lineWidth = 1.2,
      marker = list(enabled = FALSE),
      enableMouseTracking = FALSE,
      showInLegend = FALSE,
      zIndex = 2
    )
    LabelRadius <- Limits[j] - 0.07 * baselineRadius
    Cardinal <- data.frame(
      x = c(0, 1, 0, -1) * LabelRadius,
      y = c(1, 0, -1, 0) * LabelRadius,
      label = c("Clave", "Hastial", "Solera", "Hastial")
    )
    Chart <- highcharter::hc_add_series(
      Chart,
      data = lapply(seq_len(nrow(Cardinal)), function(i) {
        list(x = Cardinal$x[i], y = Cardinal$y[i], name = Cardinal$label[i])
      }),
      type = "scatter",
      xAxis = AxisIndex,
      yAxis = AxisIndex,
      name = "Positions",
      marker = list(enabled = FALSE),
      dataLabels = list(
        enabled = TRUE,
        format = "{point.name}",
        crop = FALSE,
        overflow = "allow",
        style = list(
          color = "#6B7280",
          fontSize = "9px",
          fontWeight = "400",
          textOutline = "none"
        )
      ),
      enableMouseTracking = FALSE,
      showInLegend = FALSE,
      zIndex = 4
    )
  }

  Styles <- list(
    list(
      line = "#1F2933",
      positive = "rgba(0,114,178,0.72)",
      negative = "rgba(213,94,0,0.70)",
      dash = "Solid"
    ),
    list(
      line = "#6B7280",
      positive = "rgba(0,114,178,0.52)",
      negative = "rgba(213,94,0,0.50)",
      dash = "ShortDash"
    )
  )
  GroupIDs <- paste0("section-case-", seq_along(Cases))
  names(GroupIDs) <- Cases
  for (i in seq_along(Cases)) {
    GroupID <- unname(GroupIDs[i])
    Style <- Styles[[(i - 1L) %% length(Styles) + 1L]]
    Prescription <- unique(geometry$prescription[geometry$case == Cases[i]])
    for (j in seq_along(Resultants)) {
      AxisIndex <- j - 1L
      DATA <- geometry[
        geometry$case == Cases[i] & geometry$resultant == Resultants[j],
        ,
        drop = FALSE
      ]
      AUX <- Rays[
        Rays$case == Cases[i] & Rays$resultant == Resultants[j],
        ,
        drop = FALSE
      ]
      IsMaster <- j == 1L
      Options <- list(
        hc = Chart,
        data = .ringPointData(DATA),
        type = "line",
        xAxis = AxisIndex,
        yAxis = AxisIndex,
        id = if (IsMaster) GroupID else paste0(GroupID, "-", Resultants[j]),
        name = Prescription,
        color = Style$line,
        dashStyle = Style$dash,
        lineWidth = 2.1,
        marker = list(enabled = FALSE),
        requireSorting = FALSE,
        findNearestPointBy = "xy",
        showInLegend = IsMaster,
        zIndex = 3
      )
      if (!IsMaster) {
        Options$linkedTo <- GroupID
      }
      Chart <- do.call(highcharter::hc_add_series, Options)
      for (Sign in c("positive", "negative")) {
        CurrentRays <- AUX[AUX$sign == Sign, , drop = FALSE]
        if (nrow(CurrentRays) == 0L) {
          next
        }
        Chart <- highcharter::hc_add_series(
          Chart,
          data = .ringSegmentData(CurrentRays),
          type = "line",
          xAxis = AxisIndex,
          yAxis = AxisIndex,
          name = Prescription,
          color = Style[[Sign]],
          dashStyle = Style$dash,
          lineWidth = 0.65,
          marker = list(enabled = FALSE),
          requireSorting = FALSE,
          enableMouseTracking = FALSE,
          showInLegend = FALSE,
          connectNulls = FALSE,
          linkedTo = GroupID,
          zIndex = 1
        )
      }
    }
  }
  attr(Chart, "ringPanelSize") <- PanelSize
  attr(Chart, "ringLayout") <- "responsive-square-panels"
  attr(Chart, "ringCaseIds") <- GroupIDs
  Chart
}
