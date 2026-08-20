if (!requireNamespace("chromote", quietly = TRUE)) {
  stop("chromote is required for this integration test.", call. = FALSE)
}

.inspectResultantFigure <- function(path, selector, viewportWidth) {
  if (!file.exists(path)) {
    stop("Rendered HTML is not available: ", path, call. = FALSE)
  }
  Session <- chromote::ChromoteSession$new()
  on.exit(Session$close(), add = TRUE)
  invisible(Session$Emulation$setDeviceMetricsOverride(
    width = viewportWidth,
    height = 2200,
    deviceScaleFactor = 1,
    mobile = FALSE
  ))
  Session$Page$navigate(paste0("file://", normalizePath(path)))
  Sys.sleep(0.8)
  Script <- paste0(
    "(() => {",
    "const figure = document.querySelector('", selector, "');",
    "if (!figure) throw new Error('Figure not found');",
    "const el = figure.querySelector('.highchart');",
    "const chart = Highcharts.charts.find(x => x && x.renderTo === el);",
    "if (!chart) throw new Error('Highchart not found');",
    "const er = el.getBoundingClientRect();",
    "const relative = r => ({left:r.left-er.left,top:r.top-er.top,right:r.right-er.left,bottom:r.bottom-er.top,width:r.width,height:r.height});",
    "const reference = chart.series.filter(s => s.name === 'Reference section').map(s => relative(s.group.element.getBoundingClientRect()));",
    "const referencePoints = chart.series.filter(s => s.name === 'Reference section').flatMap(s => s.points || []);",
    "const referenceRadius = Math.max(...referencePoints.map(p => Math.hypot(p.x, p.y)));",
    "const physicalPoints = chart.series.filter(s => (s.points || []).some(p => p.options && p.options.custom)).flatMap(s => s.points || []);",
    "const maxRelativeExcursion = Math.max(...physicalPoints.map(p => Math.abs(Math.hypot(p.x, p.y) - referenceRadius))) / referenceRadius;",
    "const bottomLabels = Array.from(chart.container.querySelectorAll('.highcharts-data-label text')).filter(x => x.textContent.trim() === 'Fondo').map(x => relative(x.getBoundingClientRect()));",
    "const masters = chart.series.filter(s => s.options.showInLegend === true);",
    "const legendItems = Array.from(chart.container.querySelectorAll('.highcharts-legend-item'));",
    "const toggles = masters.map((master, index) => {",
    "const id = master.options.id;",
    "const family = chart.series.filter(s => s === master || s.options.linkedTo === id);",
    "const before = family.map(s => s.visible);",
    "legendItems[index].dispatchEvent(new MouseEvent('click', {bubbles:true,cancelable:true}));",
    "const hidden = family.map(s => s.visible);",
    "legendItems[index].dispatchEvent(new MouseEvent('click', {bubbles:true,cancelable:true}));",
    "const restored = family.map(s => s.visible);",
    "return {id:id,linkedCount:family.length,before:before,hidden:hidden,restored:restored};",
    "});",
    "return {",
    "element:{width:er.width,height:er.height,scrollWidth:el.scrollWidth,scrollHeight:el.scrollHeight},",
    "chart:{width:chart.chartWidth,height:chart.chartHeight},",
    "xAxes:chart.xAxis.map(a => ({left:a.left,top:a.top,width:a.width,height:a.height})),",
    "yAxes:chart.yAxis.map(a => ({left:a.left,top:a.top,width:a.width,height:a.height})),",
    "reference:reference,bottomLabels:bottomLabels,toggles:toggles,maxRelativeExcursion:maxRelativeExcursion",
    "};",
    "})()"
  )
  Evaluation <- Session$Runtime$evaluate(Script, returnByValue = TRUE)
  if (!is.null(Evaluation$exceptionDetails)) {
    stop(Evaluation$exceptionDetails$text, call. = FALSE)
  }
  Evaluation$result$value
}

.assertContained <- function(Metrics, label) {
  Tolerance <- 1
  Element <- Metrics$element
  Chart <- Metrics$chart
  if (Element$scrollWidth > Element$width + Tolerance ||
      Element$scrollHeight > Element$height + Tolerance) {
    stop(label, ": widget content exceeds its container.", call. = FALSE)
  }
  if (abs(Chart$width - Element$width) > Tolerance ||
      abs(Chart$height - Element$height) > Tolerance) {
    stop(label, ": Highcharts canvas and widget dimensions differ.", call. = FALSE)
  }
  PanelCount <- length(Metrics$xAxes)
  if (PanelCount != 3L || length(Metrics$yAxes) != PanelCount) {
    stop(label, ": expected three X-Y axis pairs.", call. = FALSE)
  }
  for (i in seq_len(PanelCount)) {
    X <- Metrics$xAxes[[i]]
    Y <- Metrics$yAxes[[i]]
    if (abs(X$width - X$height) > Tolerance ||
        abs(Y$width - Y$height) > Tolerance ||
        abs(X$width - Y$height) > Tolerance) {
      stop(label, ": panel ", i, " is not square.", call. = FALSE)
    }
    if (X$left < -Tolerance || X$top < -Tolerance ||
        X$left + X$width > Chart$width + Tolerance ||
        X$top + X$height > Chart$height + Tolerance) {
      stop(label, ": panel ", i, " exceeds the canvas.", call. = FALSE)
    }
  }
  if (length(Metrics$reference) != PanelCount ||
      length(Metrics$bottomLabels) != PanelCount) {
    stop(label, ": reference circles or bottom labels are missing.", call. = FALSE)
  }
  if (!is.finite(Metrics$maxRelativeExcursion) ||
      Metrics$maxRelativeExcursion < 0.35) {
    stop(label, ": resultant curves are not visibly separated from the reference section.", call. = FALSE)
  }
  VisibleBounds <- c(Metrics$reference, Metrics$bottomLabels)
  for (Bounds in VisibleBounds) {
    if (Bounds$left < -Tolerance || Bounds$top < -Tolerance ||
        Bounds$right > Element$width + Tolerance ||
        Bounds$bottom > Element$height + Tolerance) {
      stop(label, ": a curve or bottom label is clipped.", call. = FALSE)
    }
  }
  if (length(Metrics$toggles) != 2L) {
    stop(label, ": expected two interactive legend groups.", call. = FALSE)
  }
  for (Toggle in Metrics$toggles) {
    if (Toggle$linkedCount < 2L ||
        !all(unlist(Toggle$before, use.names = FALSE)) ||
        any(unlist(Toggle$hidden, use.names = FALSE)) ||
        !all(unlist(Toggle$restored, use.names = FALSE))) {
      stop(
        label, ": a legend item does not toggle its complete formulation",
        " (id=", Toggle$id,
        ", linkedCount=", Toggle$linkedCount,
        ", before=", paste(unlist(Toggle$before, use.names = FALSE), collapse = ","),
        ", hidden=", paste(unlist(Toggle$hidden, use.names = FALSE), collapse = ","),
        ", restored=", paste(unlist(Toggle$restored, use.names = FALSE), collapse = ","),
        ").",
        call. = FALSE
      )
    }
  }
  invisible(TRUE)
}

Checks <- list(
  list(
    path = "html/report/_index/liner.ES.html",
    selector = "#fig-resultants-liner"
  ),
  list(
    path = "html/report/_index/rehabilitation.ES.html",
    selector = "#fig-resultants-shotcrete100"
  ),
  list(
    path = "html/report/_index/rehabilitation.ES.html",
    selector = "#fig-resultants-shotcrete150"
  )
)
for (Check in Checks) {
  for (ViewportWidth in c(1440, 900)) {
    Label <- paste(Check$path, "at", ViewportWidth, "px")
    Metrics <- .inspectResultantFigure(
      Check$path,
      Check$selector,
      ViewportWidth
    )
    .assertContained(Metrics, Label)
  }
}
cat("PASS: three three-panel resultant figures are square, contained, and toggle complete formulations.\n")
