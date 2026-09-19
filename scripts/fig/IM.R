# nolint start
if (!ID %in% c("AI", "CAV", "CAV5")) {
  stop("IM.R supports only AI, CAV, and CAV5.", call. = FALSE)
}
Column <- paste(ID, DIR, sep = ".")
if (!Column %in% names(TSWTable)) {
  stop(sprintf("Missing cumulative TS column: %s", Column), call. = FALSE)
}
Label <- if (ID == "AI") "IA" else ID

SRS <- TSWTable[, .(
  ID    = RecordID,
  X     = t,
  Y     = get(Column),
  style = "ShortDashDot",
  size  = THIN_LINE_SIZE
)][is.finite(X) & is.finite(Y)][order(ID, X)]

PLOT <- buildPlot(
  line.type     = "line",
  plot.height   = 750,
  legend.layout = "horizontal",
  legend.show   = TRUE,
  xAxis.legend  = "t [s]",
  yAxis.legend  = sprintf("%s(%s) / max(%s(%s)) [-]",
                          Label, DIR, Label, DIR),
  group.legend  = "ID",
  plot.theme    = NGR::hc_theme_538_gridlines(),
  data.lines    = SRS
)
PLOT$x$hc_opts$xAxis$gridLineWidth <- 0.3
PLOT$x$hc_opts$xAxis$gridLineColor <- "#e8e8e8"
PLOT$x$hc_opts$xAxis$minorGridLineWidth <- 0.15
PLOT$x$hc_opts$xAxis$minorGridLineColor <- "#f3f3f3"
PLOT$x$hc_opts$yAxis$gridLineWidth <- 0.3
PLOT$x$hc_opts$yAxis$gridLineColor <- "#e8e8e8"
PLOT$x$hc_opts$yAxis$minorGridLineWidth <- 0.15
PLOT$x$hc_opts$yAxis$minorGridLineColor <- "#f3f3f3"
rm(SRS, Column, Label)
# nolint end
