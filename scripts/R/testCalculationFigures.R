source("scripts/fig/Calculation.resultants.R")
source("scripts/fig/Calculation.envelopes.R")
source("scripts/fig/Calculation.extrema.quantiles.R")
source("scripts/fig/Calculation.compaction.stages.R")
source("scripts/fig/Calculation.concrete.axial.flexure.R")
source("scripts/tbl/Calculation.concrete.reinforcement.sweep.R")

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
    "Schwartz–Einstein: deslizamiento libre",
    "Schwartz–Einstein: sin deslizamiento"
  )]),
  c("ShortDash", "Dash")
))
ReferenceSeries <- Filter(function(x) {
  identical(x$name, "Reference section")
}, Series)
stopifnot(
  length(ReferenceSeries) == 3L,
  all(vapply(ReferenceSeries, function(x) {
    identical(x$dashStyle, "Solid") && identical(x$lineWidth, 2.4)
  }, logical(1))),
  all(vapply(LegendSeries, function(x) {
    identical(x$lineWidth, 1.6)
  }, logical(1)))
)
GroupIDs <- attr(Interactive, "sectionCaseIDs")
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
stopifnot(identical(
  unique(Geometry$interfaceID),
  c("full-slip", "no-slip")
))
LocalGeometry <- .readResultantGeometry(
  PathCurves,
  PathScales,
  Radius,
  graphicAmplification = GraphicAmplification,
  scaleMode = "local-by-lining-and-resultant"
)
LocalExcursions <- vapply(c("N", "M", "Q"), function(ResultantID) {
  Current <- LocalGeometry[
    LocalGeometry$resultant == ResultantID &
      !LocalGeometry$displayClosed,
    ,
    drop = FALSE
  ]
  max(abs(Current$plotRadius - Radius)) / Radius
}, numeric(1))
stopifnot(
  all(LocalGeometry$scaleMode == "local-by-lining-and-resultant"),
  all(abs(
    LocalExcursions - GraphicAmplification * RadialFraction
  ) < 1e-12)
)
LocalMomentInteractive <- buildCalculationResultantsInteractive(
  PathCurves,
  PathScales,
  Radius,
  graphicAmplification = GraphicAmplification,
  raysPerCircle = OrdinateCount,
  resultant = "M",
  scaleMode = "local-by-lining-and-resultant"
)
stopifnot(
  inherits(LocalMomentInteractive, "highchart"),
  grepl(
    "escala radial propia de esta sección y resultante",
    LocalMomentInteractive$x$hc_opts$subtitle$text,
    fixed = TRUE
  )
)
PathConcreteCurves <- "data/calculation/shotcrete.section.resultants.csv"
PathConcreteScales <- "data/calculation/shotcrete.display.scales.csv"
PathConcreteSections <- "data/calculation/shotcrete.section.properties.csv"
ConcreteScales <- utils::read.csv(
  PathConcreteScales,
  check.names = FALSE
)
ConcreteSections <- utils::read.csv(
  PathConcreteSections,
  check.names = FALSE
)
ReinforcedScales <- ConcreteScales[
  ConcreteScales[["liningID", exact = TRUE]] == "reinforcedConcrete",
  ,
  drop = FALSE
]
ConcreteScales <- ConcreteScales[
  ConcreteScales[["liningID", exact = TRUE]] == "shotcrete",
  ,
  drop = FALSE
]
ConcreteRadius <- unique(ConcreteScales$referenceRadiusM)
ConcreteAmplification <- unique(ConcreteScales$graphicAmplification)
ConcreteOrdinateCount <- unique(ConcreteScales$ordinateCount)
ReinforcedRadius <- unique(ReinforcedScales$referenceRadiusM)
ReinforcedAmplification <- unique(
  ReinforcedScales$graphicAmplification
)
ReinforcedOrdinateCount <- unique(ReinforcedScales$ordinateCount)
ConcreteSectionRadius <- unique(ConcreteSections[[
  "centroidalRadiusM",
  exact = TRUE
]][ConcreteSections[["liningID", exact = TRUE]] == "shotcrete"])
ReinforcedSectionRadius <- unique(ConcreteSections[[
  "centroidalRadiusM",
  exact = TRUE
]][ConcreteSections[["liningID", exact = TRUE]] == "reinforcedConcrete"])
stopifnot(
  length(ConcreteRadius) == 1L,
  length(ConcreteAmplification) == 1L,
  length(ConcreteOrdinateCount) == 1L,
  length(ReinforcedRadius) == 1L,
  length(ReinforcedAmplification) == 1L,
  length(ReinforcedOrdinateCount) == 1L,
  length(ConcreteSectionRadius) == 1L,
  length(ReinforcedSectionRadius) == 1L,
  isTRUE(all.equal(ConcreteRadius, ConcreteSectionRadius)),
  isTRUE(all.equal(ReinforcedRadius, ReinforcedSectionRadius)),
  ReinforcedRadius != ConcreteRadius,
  ConcreteRadius != Radius
)
ConcreteGeometry <- .readResultantGeometry(
  PathConcreteCurves,
  PathConcreteScales,
  ConcreteRadius,
  graphicAmplification = ConcreteAmplification,
  liningID = "shotcrete"
)
ReinforcedGeometry <- .readResultantGeometry(
  PathConcreteCurves,
  PathConcreteScales,
  ReinforcedRadius,
  graphicAmplification = ReinforcedAmplification,
  liningID = "reinforcedConcrete"
)
stopifnot(
  identical(
    unique(as.character(ConcreteGeometry$case)),
    c("alpha-1", "alpha-0")
  ),
  identical(
    unique(as.character(ReinforcedGeometry$case)),
    c("alpha-1", "alpha-0")
  ),
  identical(unique(ConcreteGeometry$interfaceID), c("full-slip", "no-slip")),
  identical(unique(ReinforcedGeometry$interfaceID), c("full-slip", "no-slip")),
  !isTRUE(all.equal(
    ReinforcedGeometry$value,
    ConcreteGeometry$value,
    tolerance = 1e-12
  )),
  max(abs(ConcreteGeometry$value[ConcreteGeometry$resultant == "M"])) >
    max(abs(Geometry$value[Geometry$resultant == "M"]))
)
ConcreteInteractive <- buildCalculationResultantsInteractive(
  PathConcreteCurves,
  PathConcreteScales,
  ConcreteRadius,
  graphicAmplification = ConcreteAmplification,
  raysPerCircle = ConcreteOrdinateCount,
  liningID = "shotcrete"
)
ReinforcedInteractive <- buildCalculationResultantsInteractive(
  PathConcreteCurves,
  PathConcreteScales,
  ReinforcedRadius,
  graphicAmplification = ReinforcedAmplification,
  raysPerCircle = ReinforcedOrdinateCount,
  liningID = "reinforcedConcrete"
)
stopifnot(
  inherits(ConcreteInteractive, "highchart"),
  inherits(ReinforcedInteractive, "highchart")
)
AxialFlexureInteractive <- buildCalculationConcreteAxialFlexurePlot(
  "data/calculation/shotcrete.axial.flexure.reinforcement.domains.csv",
  "data/calculation/shotcrete.axial.flexure.reinforcement.sweep.csv",
  paste0(
    "data/calculation/",
    "shotcrete.axial.flexure.reinforcement.governing.demands.csv"
  )
)
AxialFlexureSeries <- AxialFlexureInteractive[["x"]][["hc_opts"]][[
  "series"
]]
stopifnot(
  inherits(AxialFlexureInteractive, "highchart"),
  isFALSE(AxialFlexureInteractive[["x"]][["hc_opts"]][[
    "plotOptions"
  ]][["series"]][["requireSorting"]]),
  identical(
    vapply(AxialFlexureSeries, `[[`, character(1), "name"),
    c(
      "Referencia inferior · rho=0.18% · As=2.7 cm2/m",
      "rho=1.00% · As=15.0 cm2/m",
      "rho=2.00% · As=30.0 cm2/m",
      "rho=3.00% · As=45.0 cm2/m",
      paste0(
        "Deslizamiento libre · Permanente vertical ×1,4 · ",
        "Empuje lateral ×1,6"
      ),
      paste0(
        "Deslizamiento libre · Permanente vertical ×1,4 · ",
        "Empuje lateral ×0,9"
      ),
      paste0(
        "Sin deslizamiento · Permanente vertical ×1,4 · ",
        "Empuje lateral ×1,6"
      ),
      paste0(
        "Sin deslizamiento · Permanente vertical ×1,4 · ",
        "Empuje lateral ×0,9"
      )
    )
  ),
  identical(
    vapply(
      AxialFlexureSeries[seq_len(4L)],
      function(x) length(x[["data"]]),
      integer(1)
    ),
    rep(807L, 4L)
  ),
  identical(
    vapply(
      AxialFlexureSeries[-seq_len(4L)],
      function(x) length(x[["data"]]),
      integer(1)
    ),
    rep(1L, 4L)
  )
)
ReinforcementSweepTable <- buildCalculationConcreteReinforcementSweepTable(
  "data/calculation/shotcrete.axial.flexure.reinforcement.sweep.csv",
  "reinforcedConcrete"
)
ReinforcementSweepText <- as.character(ReinforcementSweepTable)
stopifnot(
  inherits(ReinforcementSweepTable, "knitr_kable"),
  any(grepl("2.00", ReinforcementSweepText, fixed = TRUE)),
  any(grepl("Excede el dominio", ReinforcementSweepText, fixed = TRUE)),
  any(grepl("Dentro del dominio", ReinforcementSweepText, fixed = TRUE))
)
Baseline <- buildRingComparisonPlot(
  geometry = Geometry,
  baselineRadius = Radius,
  raysPerCircle = OrdinateCount,
  subtitle = paste0(
    "Interacción Schwartz–Einstein; escala radial común de los productos; amplificación gráfica Ag = ",
    GraphicAmplification,
    ". La lectura interactiva conserva las magnitudes físicas."
  )
)
Baseline$x$hc_opts$tooltip <- Interactive$x$hc_opts$tooltip
stopifnot(identical(Baseline$x$hc_opts, Interactive$x$hc_opts))
stopifnot(identical(Baseline$width, Interactive$width))
stopifnot(identical(Baseline$height, Interactive$height))
stopifnot(identical(Baseline$dependencies, Interactive$dependencies))
CurveSeries <- Filter(function(x) {
  length(x$data) > 0L && !is.null(x$data[[1L]]$custom)
}, Series)
stopifnot(length(CurveSeries) == 6L)
for (v in CurveSeries) {
  Resultant <- v$data[[1L]]$custom$resultant
  CurrentGeometry <- Geometry[
    Geometry$prescription == v$name &
      Geometry$resultant == Resultant,
    ,
    drop = FALSE
  ]
  Values <- vapply(v$data, function(x) x$custom$value, numeric(1))
  X <- vapply(v$data, `[[`, numeric(1), "x")
  Y <- vapply(v$data, `[[`, numeric(1), "y")
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
for (v in RaySeries) {
  NullPositions <- which(vapply(v$data, is.null, logical(1)))
  stopifnot(identical(NullPositions, seq(3L, length(v$data), by = 3L)))
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
  case = CanonicalCurves$caseID,
  stage = ifelse(
    CanonicalCurves$interfaceID == "full-slip",
    "Etapa 1",
    "Etapa 2"
  ),
  model = "mathematical-control",
  prescription = ifelse(
    CanonicalCurves$interfaceID == "full-slip",
    "Interfaz con deslizamiento libre",
    "Interfaz sin deslizamiento"
  ),
  resultant = CanonicalCurves$resultantID,
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
    resultant = ScaleData$resultantID,
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
