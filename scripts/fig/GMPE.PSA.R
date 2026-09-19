# nolint start
# One scenario/site spectrum: producer medians by model and ensemble quantiles.
if (!exists("ID.target", inherits = FALSE) || length(ID.target) != 1L) {
  stop("GMPE.PSA.R: set scalar ID.target.", call. = FALSE)
}
if (!exists("siteID.target", inherits = FALSE) || length(siteID.target) != 1L) {
  stop("GMPE.PSA.R: set scalar siteID.target.", call. = FALSE)
}
if (!exists("Vs30.target", inherits = FALSE) || length(Vs30.target) != 1L) {
  stop("GMPE.PSA.R: set scalar Vs30.target.", call. = FALSE)
}
if (!exists("p.target") || !length(p.target)) p.target <- c("0.10", "0.16", "0.50", "0.84", "0.90")
if (!exists("ScenarioGMPETable", inherits = TRUE) || is.null(ScenarioGMPETable)) {
  stop("GMPE.PSA.R: ScenarioGMPETable is required from oqt --process --steps mce.", call. = FALSE)
}
DT <- ScenarioGMPETable[
  ID %in% ID.target & siteID %in% siteID.target & Vs30 %in% Vs30.target &
    ((model != "ensemble" & .matchP(p, "0.50")) |
     (model == "ensemble" & .matchP(p, unique(c(p.target, "0.05", "0.95")))))
]
if (!nrow(DT)) {
  stop("GMPE.PSA.R: no rows for the selected scenario/site.", call. = FALSE)
}

DATA <- DT[, .(
  ID    = fifelse(
    model == "ensemble",
    fifelse(.matchP(p, "0.05"), ".min", fifelse(.matchP(p, "0.95"), ".max", paste("ensemble", p))),
    model
  ),
  X     = Tn,
  Y     = Sa,
  style = fifelse(model == "ensemble", fifelse(.matchP(p, "0.50"), "Solid", "Dash"), "ShortDashDot"),
  size  = fifelse(
    model == "ensemble",
    fifelse(.matchP(p, "0.50"), THICK_LINE_SIZE, THIN_LINE_SIZE),
    MID_LINE_SIZE
  ),
  fill  = model == "ensemble" & .matchP(p, c("0.05", "0.95"))
)][order(X)][order(ID)]

DUP <- DATA[, .N, by = .(ID, X)][N > 1L]
if (nrow(DUP)) {
  stop("GMPE.PSA.R: duplicate ordinates for at least one series/Tn.", call. = FALSE)
}
PLOT <- buildPlot(
  line.type     = "spline",
  plot.height   = 650,
  legend.layout = "horizontal",
  legend.show   = TRUE,
  xAxis.log     = TRUE,
  yAxis.log     = TRUE,
  xAxis.log.zero.label = "PGA",
  xAxis.legend  = "Tn [s]",
  yAxis.legend  = "Sa [g]",
  group.legend  = "ID",
  plot.theme    = NGR::hc_theme_538_gridlines(),
  fill.legend   = "p5–p95",
  fill.min.style = "Dash",
  fill.min.size = THIN_LINE_SIZE,
  fill.max.style = "Dash",
  fill.max.size = THIN_LINE_SIZE,
  data.lines    = DATA
)
if (exists("fillColor", inherits = FALSE)) PLOT <- .paintFillSeries(PLOT, fillColor)
rm(DT, DATA, DUP)
# nolint end
