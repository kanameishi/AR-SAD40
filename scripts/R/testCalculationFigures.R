source("scripts/fig/Resultants.R")
source("scripts/fig/PM.R")
source("scripts/fig/Comparison.R")
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
    "Modelo híbrido: Slip (S)",
    "Modelo híbrido: No Slip (NS)"
  )]),
  c("ShortDash", "Dash")
))
stopifnot(
  is.null(Interactive$x$hc_opts$subtitle),
  !grepl(
    "Schwartz–Einstein",
    paste(names(DashByName), collapse = " "),
    fixed = TRUE
  )
)
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
  c("slip", "no-slip")
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
  is.null(LocalMomentInteractive$x$hc_opts$subtitle)
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
    c("slip", "no-slip")
  ),
  identical(
    unique(as.character(ReinforcedGeometry$case)),
    c("slip", "no-slip")
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
      "S8 · Ø8/150 · rho=0.45% · As=6.7 cm2/m",
      "S10 · Ø10/150 · rho=0.70% · As=10.5 cm2/m",
      "S12 · Ø12/150 · rho=1.01% · As=15.1 cm2/m",
      "A8 · chapa + Ø8/150 interior",
      "S8 · Ø8/150 · rho=0.45% · As=6.7 cm2/m",
      "S10 · Ø10/150 · rho=0.70% · As=10.5 cm2/m",
      "S12 · Ø12/150 · rho=1.01% · As=15.1 cm2/m",
      "A8 · chapa + Ø8/150 interior"
    )
  ),
  identical(
    vapply(
      AxialFlexureSeries[seq_len(4L)],
      function(x) length(x[["data"]]),
      integer(1)
    ),
    c(447L, 440L, 435L, 793L)
  ),
  identical(
    vapply(
      AxialFlexureSeries[-seq_len(4L)],
      function(x) length(x[["data"]]),
      integer(1)
    ),
    rep(2L, 4L)
  ),
  identical(
    vapply(
      AxialFlexureSeries[-seq_len(4L)],
      function(x) x[["data"]][[1L]][["marker"]][["radius"]],
      numeric(1)
    ),
    c(6, 8, 10, 7)
  ),
  all(vapply(
    AxialFlexureSeries[-seq_len(4L)],
    function(x) {
      identical(
        x[["data"]][[1L]][["marker"]][["lineColor"]],
        x[["color"]]
      )
    },
    logical(1)
  )),
  all(!vapply(
    AxialFlexureSeries[-seq_len(4L)],
    function(x) isTRUE(x$showInLegend),
    logical(1)
  ))
)
ReinforcementSweepTable <- buildCalculationConcreteReinforcementSweepTable(
  "data/calculation/shotcrete.axial.flexure.reinforcement.sweep.csv",
  "reinforcedConcrete"
)
ReinforcementSweepText <- unlist(
  ReinforcementSweepTable$body$dataset,
  use.names = FALSE
)
stopifnot(
  inherits(ReinforcementSweepTable, "flextable"),
  any(grepl("S12", ReinforcementSweepText, fixed = TRUE)),
  any(grepl("FAIL", ReinforcementSweepText, fixed = TRUE)),
  any(grepl("OK", ReinforcementSweepText, fixed = TRUE))
)
ComparisonCurves <- utils::read.csv(
  "data/calculation/classical.comparison.curves.csv",
  check.names = FALSE
)
ComparisonMethods <- c(
  "official-hybrid",
  "schwartz-einstein-uniform",
  "prescribed-k0-ring"
)
ComparisonPlots <- lapply(ComparisonMethods, function(MethodID) {
  buildCalculationClassicalComparisonFigure(
    ComparisonCurves,
    "steel",
    MethodID
  )
})
stopifnot(
  all(vapply(ComparisonPlots, inherits, logical(1), "highchart")),
  all(vapply(ComparisonPlots, function(Plot) {
    identical(attr(Plot, "sectionLayout"), "responsive-square-panels")
  }, logical(1))),
  all(vapply(ComparisonPlots, function(Plot) {
    sum(vapply(
      Plot$x$hc_opts$series,
      function(Series) isTRUE(Series$showInLegend),
      logical(1)
    )) == 2L
  }, logical(1)))
)
source("scripts/tbl/Calculation.sensitivity.R")
SensitivitySteel <- utils::read.csv(
  "data/calculation/sensitivity.steel.extrema.csv",
  check.names = FALSE
)
SensitivityAashto <- utils::read.csv(
  "data/calculation/sensitivity.aashto.checks.csv",
  check.names = FALSE
)
SensitivityPlain <- utils::read.csv(
  "data/calculation/sensitivity.plain.checks.csv",
  check.names = FALSE
)
SensitivitySweep <- utils::read.csv(
  "data/calculation/sensitivity.pm.sweep.csv",
  check.names = FALSE
)
SensitivityDemands <- utils::read.csv(
  "data/calculation/sensitivity.pm.demands.csv",
  check.names = FALSE
)
SensitivityModuli <- sort(unique(SensitivitySteel$modulusMPa))
stopifnot(
  length(SensitivityModuli) >= 2L,
  nrow(SensitivitySteel) == 6L * length(SensitivityModuli),
  nrow(SensitivityAashto) == 5L * length(SensitivityModuli),
  nrow(SensitivityPlain) == 4L * length(SensitivityModuli),
  nrow(SensitivitySweep) == 8L * length(SensitivityModuli),
  nrow(SensitivityDemands) == 16L * length(SensitivityModuli),
  identical(
    sort(unique(SensitivityAashto$modulusMPa)),
    SensitivityModuli
  ),
  identical(
    sort(unique(SensitivityDemands$modulusMPa)),
    SensitivityModuli
  ),
  setequal(
    unique(SensitivityPlain$liningID),
    c("shotcrete", "plainConcrete150")
  ),
  all(is.finite(SensitivitySweep$maximumRadialUtilization))
)
SensitivityTables <- list(
  buildCalculationSensitivitySteelTable(
    "data/calculation/sensitivity.steel.extrema.csv"
  ),
  buildCalculationSensitivityPlainTable(
    "data/calculation/sensitivity.plain.checks.csv"
  ),
  buildCalculationSensitivityPmTable(
    "data/calculation/sensitivity.pm.sweep.csv",
    "shotcrete"
  ),
  buildCalculationSensitivityPmTable(
    "data/calculation/sensitivity.pm.sweep.csv",
    "reinforcedConcrete"
  )
)
stopifnot(all(vapply(
  SensitivityTables,
  inherits,
  logical(1),
  "flextable"
)))
for (SensitivityLiningID in c("shotcrete", "reinforcedConcrete")) {
  SensitivityPlot <- buildCalculationConcreteAxialFlexureSensitivityPlot(
    "data/calculation/shotcrete.axial.flexure.reinforcement.domains.csv",
    "data/calculation/shotcrete.axial.flexure.reinforcement.sweep.csv",
    "data/calculation/sensitivity.pm.demands.csv",
    liningID = SensitivityLiningID
  )
  SensitivitySeries <- SensitivityPlot$x$hc_opts$series
  SensitivityMarked <- vapply(
    SensitivitySeries,
    function(Series) isTRUE(Series$marker$enabled),
    logical(1)
  )
  stopifnot(
    inherits(SensitivityPlot, "highchart"),
    length(SensitivitySeries) == 8L,
    sum(SensitivityMarked) == 4L,
    all(vapply(
      SensitivitySeries[SensitivityMarked],
      function(Series) length(Series$data) == length(SensitivityModuli),
      logical(1)
    ))
  )
}
cat("PASS: calculation figure builders.\n")
