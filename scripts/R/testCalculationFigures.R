source("scripts/fig/Calculation.resultants.R")
source("scripts/fig/Calculation.envelopes.R")
source("scripts/fig/Calculation.extrema.quantiles.R")
source("scripts/fig/Calculation.compaction.stages.R")

PathCurves <- "data/calculation/section.resultants.csv"
PathScales <- "data/calculation/display.scales.csv"
ScaleData <- utils::read.csv(PathScales, check.names = FALSE)
Radius <- unique(ScaleData$referenceRadiusM)
OrdinateCount <- unique(ScaleData$ordinateCount)
GraphicAmplification <- unique(ScaleData$graphicAmplification)
RadialFraction <- unique(ScaleData$radialFraction)
stopifnot(
  length(Radius) == 1L,
  length(OrdinateCount) == 1L,
  length(GraphicAmplification) == 1L,
  length(RadialFraction) == 1L
)
resultants <- buildCalculationResultants(
  PathCurves,
  PathScales,
  Radius,
  graphicAmplification = GraphicAmplification,
  raysPerCircle = OrdinateCount
)
stopifnot(inherits(resultants, "ggplot"))
stopifnot(identical(resultants$coordinates$ratio, 1))
stopifnot(length(resultants$layers) == 4L)
rays <- resultants$layers[[2L]]$data
stopifnot(inherits(resultants$layers[[2L]]$geom, "GeomSegment"))
stopifnot(nrow(rays) == 6L * OrdinateCount)
sectionResidual <- abs(rays$xSection^2 + rays$ySection^2 - Radius^2)
stopifnot(max(sectionResidual) < 1e-12 * Radius^2)
rayLengths <- sqrt(
  (rays$x - rays$xSection)^2 + (rays$y - rays$ySection)^2
)
expectedLengths <- abs(rays$displayScale * rays$value)
stopifnot(max(abs(rayLengths - expectedLengths)) < 1e-12)
stopifnot(all(rays$graphicAmplification == GraphicAmplification))
stopifnot(all(abs(
  rays$radialFraction - GraphicAmplification * RadialFraction
) < 1e-14))
stopifnot(all(abs(
  rays$displayScale - GraphicAmplification * rays$baseDisplayScale
) < 1e-14))
stopifnot(identical(levels(rays$sign), c("positive", "negative")))
curves <- resultants$layers[[3L]]$data
curveGroups <- split(curves, interaction(curves$case, curves$resultant))
stopifnot(length(curveGroups) == 6L)
stopifnot(all(vapply(curveGroups, function(current) {
  isTRUE(all.equal(current$x[1L], current$x[nrow(current)], tolerance = 1e-12)) &&
    isTRUE(all.equal(current$y[1L], current$y[nrow(current)], tolerance = 1e-12))
}, logical(1))))

Interactive <- buildCalculationResultantsInteractive(
  PathCurves,
  PathScales,
  Radius,
  graphicAmplification = GraphicAmplification,
  raysPerCircle = OrdinateCount
)
stopifnot(inherits(Interactive, "highchart"))
stopifnot(is.null(Interactive$x$hc_opts$chart$width))
stopifnot(identical(Interactive$x$hc_opts$chart$height, 560))
stopifnot(isTRUE(Interactive$x$hc_opts$chart$reflow))
stopifnot(identical(attr(Interactive, "sectionLayout"), "responsive-square-panels"))
LayoutHandler <- Interactive$x$hc_opts$chart$events$render
stopifnot(inherits(LayoutHandler, "JS_EVAL"))
stopifnot(grepl("xAxis.update", LayoutHandler, fixed = TRUE))
stopifnot(grepl("yAxis.update", LayoutHandler, fixed = TRUE))
Series <- Interactive$x$hc_opts$series
stopifnot(sum(vapply(Series, function(x) isTRUE(x$showInLegend), logical(1))) == 2L)
LegendSeries <- Filter(function(x) isTRUE(x$showInLegend), Series)
DashByName <- stats::setNames(
  vapply(LegendSeries, `[[`, character(1), "dashStyle"),
  vapply(LegendSeries, `[[`, character(1), "name")
)
stopifnot(identical(
  unname(DashByName[c(
    "Componente tangencial: α = 1.00",
    "Componente tangencial: α = 0.00"
  )]),
  c("Solid", "ShortDash")
))
GroupIDs <- attr(Interactive, "sectionCaseIds")
stopifnot(length(GroupIDs) == 2L)
stopifnot(all(GroupIDs %in% vapply(Series, function(x) {
  if (is.null(x$id)) "" else x$id
}, character(1))))
PanelSize <- attr(Interactive, "sectionPanelSize")
stopifnot(all(vapply(Interactive$x$hc_opts$xAxis, `[[`, numeric(1), "width") == PanelSize))
stopifnot(all(vapply(Interactive$x$hc_opts$yAxis, `[[`, numeric(1), "height") == PanelSize))
stopifnot(all(vapply(Interactive$x$hc_opts$xAxis, function(x) {
  is.character(x$title$text) && length(x$title$text) == 1L
}, logical(1))))
Geometry <- .readResultantGeometry(
  PathCurves,
  PathScales,
  Radius,
  graphicAmplification = GraphicAmplification
)
stopifnot(identical(
  unique(as.character(Geometry$case)),
  c("alpha-1", "alpha-0")
))
Baseline <- buildRingComparisonPlot(
  geometry = Geometry,
  baselineRadius = Radius,
  raysPerCircle = OrdinateCount,
  subtitle = paste0(
    "Multiplicador tangencial α; amplificación gráfica Ag = ",
    GraphicAmplification,
    ". La lectura interactiva conserva las magnitudes físicas."
  )
)
stopifnot(identical(Baseline$x$hc_opts, Interactive$x$hc_opts))
stopifnot(identical(Baseline$width, Interactive$width))
stopifnot(identical(Baseline$height, Interactive$height))
stopifnot(identical(Baseline$dependencies, Interactive$dependencies))
CurveSeries <- Filter(function(x) {
  length(x$data) > 0L && !is.null(x$data[[1L]]$custom)
}, Series)
stopifnot(length(CurveSeries) == 6L)
for (CurrentSeries in CurveSeries) {
  Resultant <- CurrentSeries$data[[1L]]$custom$resultant
  CurrentGeometry <- Geometry[
    Geometry$prescription == CurrentSeries$name &
      Geometry$resultant == Resultant,
    ,
    drop = FALSE
  ]
  Values <- vapply(CurrentSeries$data, function(x) x$custom$value, numeric(1))
  X <- vapply(CurrentSeries$data, `[[`, numeric(1), "x")
  Y <- vapply(CurrentSeries$data, `[[`, numeric(1), "y")
  stopifnot(identical(Values, CurrentGeometry$value))
  stopifnot(identical(X, CurrentGeometry$x))
  stopifnot(identical(Y, CurrentGeometry$y))
}
RaySeries <- Filter(function(x) {
  !is.null(x$linkedTo) && isFALSE(x$enableMouseTracking)
}, Series)
stopifnot(length(RaySeries) == 10L)
stopifnot(all(vapply(RaySeries, function(x) {
  isFALSE(x$requireSorting)
}, logical(1))))
for (CurrentSeries in RaySeries) {
  NullPositions <- which(vapply(CurrentSeries$data, is.null, logical(1)))
  stopifnot(identical(NullPositions, seq(3L, length(CurrentSeries$data), by = 3L)))
}
Cases <- unique(Geometry$case)
PhasedRays <- prepareRingRays(
  geometry = Geometry,
  baselineRadius = Radius,
  raysPerCircle = OrdinateCount,
  phaseDegByCase = stats::setNames(c(0, 5), Cases)
)
SignSeries <- nrow(unique(PhasedRays[c("case", "resultant", "sign")]))
stopifnot(length(Series) == 6L + 3L * length(Cases) + SignSeries)
Linked <- vapply(Series, function(x) {
  if (is.null(x$linkedTo)) "" else x$linkedTo
}, character(1))
stopifnot(sum(Linked %in% GroupIDs) == 3L * length(Cases) + SignSeries - length(Cases))
FirstAngles <- vapply(Cases, function(s) {
  min(PhasedRays$thetaDeg[PhasedRays$case == s])
}, numeric(1))
stopifnot(abs(FirstAngles[1L]) < 1e-12)
stopifnot(abs(FirstAngles[2L] - 5) < 0.3)

theta <- (0:71) * 2 * pi / 72
quantiles <- do.call(rbind, lapply(c(0.05, 0.50, 0.95), function(probability) {
  data.frame(
    model = "mathematical-control",
    resultant = "M",
    probability = probability,
    thetaIndex = seq_along(theta) - 1L,
    theta = theta,
    thetaDeg = theta * 180 / pi,
    value = 10 * cos(2 * theta) + c(`0.05` = -2, `0.5` = 0, `0.95` = 2)[as.character(probability)],
    unit = "kN m/m",
    sampleCount = 1000L,
    quantileType = 7L,
    statisticScope = "pointwise",
    stringsAsFactors = FALSE
  )
}))
quantilePath <- tempfile(fileext = ".csv")
utils::write.csv(quantiles, quantilePath, row.names = FALSE)
envelope <- buildCalculationEnvelopes(quantilePath, "M", 0.02, Radius)
stopifnot(inherits(envelope, "highchart"))

extrema <- expand.grid(
  model = "mathematical-control",
  resultant = c("N", "M", "Q"),
  statistic = "absoluteMaximum",
  probability = c(0.05, 0.50, 0.95),
  stringsAsFactors = FALSE
)
extrema$value <- seq_len(nrow(extrema))
extrema$unit <- "scaled"
extrema$sampleCount <- 1000L
extrema$quantileType <- 7L
extrema$valueBasis <- "absolute"
extrema$statisticScope <- "spatialExtremum"
extremaPath <- tempfile(fileext = ".csv")
utils::write.csv(extrema, extremaPath, row.names = FALSE)
extremaChart <- buildCalculationExtremaQuantiles(extremaPath)
stopifnot(inherits(extremaChart, "shiny.tag"))

CanonicalCurves <- utils::read.csv(PathCurves, check.names = FALSE)
stages <- data.frame(
  case = CanonicalCurves$caseId,
  stage = ifelse(CanonicalCurves$alpha == 1, "Etapa 1", "Etapa 2"),
  model = "mathematical-control",
  prescription = paste0(
    "Componente tangencial: α = ",
    formatC(CanonicalCurves$alpha, format = "f", digits = 2)
  ),
  resultant = CanonicalCurves$resultantId,
  thetaIndex = CanonicalCurves$thetaIndex,
  theta = CanonicalCurves$thetaRad,
  thetaDeg = CanonicalCurves$thetaDeg,
  value = CanonicalCurves$value,
  unit = CanonicalCurves$unit,
  evidenceLevel = CanonicalCurves$evidenceLevel,
  stringsAsFactors = FALSE
)
stagePath <- tempfile(fileext = ".csv")
stageScalePath <- tempfile(fileext = ".csv")
utils::write.csv(stages, stagePath, row.names = FALSE)
utils::write.csv(
  data.frame(
    resultant = ScaleData$resultantId,
    displayScale = ScaleData$displayScale,
    maximumAbsoluteValue = ScaleData$maximumAbsoluteValue,
    unit = ScaleData$resultantUnit,
    radialFraction = ScaleData$radialFraction,
    stringsAsFactors = FALSE
  ),
  stageScalePath,
  row.names = FALSE
)
stageChart <- buildCalculationCompactionStages(
  stagePath,
  stageScalePath,
  "N",
  Radius
)
stopifnot(inherits(stageChart, "highchart"))

unlink(c(quantilePath, extremaPath, stagePath, stageScalePath))
cat("PASS: calculation figure builders.\n")
