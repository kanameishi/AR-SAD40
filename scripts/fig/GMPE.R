# nolint start
# Attenuation plot for one tectonic regime: median spectral acceleration
# of every individual GMPE versus distance at a fixed magnitude, depth,
# and structural period, with the weighted ensemble mixture highlighted.
# The ensemble 5th and 95th percentiles bound a shaded central mixture band
# (buildPlot fill boundaries .min/.max). Consumes GMPETable (one ID per TRT).
if (!exists("ID.target", inherits = FALSE) || length(ID.target) != 1L) {
  stop("GMPE.R: set scalar ID.target (one TRT grid).", call. = FALSE)
}
if (!exists("Mw.target", inherits = FALSE) || length(Mw.target) != 1L) {
  stop("GMPE.R: set scalar Mw.target.", call. = FALSE)
}
if (!exists("dep.target", inherits = FALSE) || length(dep.target) != 1L) {
  dep.target <- min(GMPETable[ID %in% ID.target, dep])
}
if (!exists("Tn.target", inherits = FALSE) || length(Tn.target) != 1L) Tn.target <- 0
if (!exists("p.target") || !length(p.target)) p.target <- c("0.10", "0.16", "0.50", "0.84", "0.90")

DT <- GMPETable[
  ID %in% ID.target & Mw == Mw.target & dep == dep.target & Tn == Tn.target &
    ((model != "ensemble" & .matchP(p, "0.50")) |
     (model == "ensemble" & .matchP(p, unique(c(p.target, "0.05", "0.95")))))
]
if (!nrow(DT)) {
  stop("GMPE.R: no rows for the selected grid cell.", call. = FALSE)
}

DATA <- DT[, .(
  ID    = fifelse(
    model == "ensemble",
    fifelse(.matchP(p, "0.05"), ".min", fifelse(.matchP(p, "0.95"), ".max", paste("ensemble", p))),
    model
  ),
  X     = Repi,
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
  stop("GMPE.R: duplicate ordinates for at least one series/Repi.", call. = FALSE)
}
PLOT <- buildPlot(
  line.type     = "spline",
  plot.height   = 650,
  legend.layout = "horizontal",
  legend.show   = TRUE,
  xAxis.log     = TRUE,
  yAxis.log     = TRUE,
  xAxis.legend  = "Repi [km]",
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
