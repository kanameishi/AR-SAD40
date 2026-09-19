# nolint start
Column <- paste(ID, DIR, sep = ".")
if (!ID %in% c("AT", "VT", "DT")) {
  stop("TS.R supports only AT, VT, and DT.", call. = FALSE)
}
if (!Column %in% names(TSWTable)) {
  stop(sprintf("Missing TS column: %s", Column), call. = FALSE)
}
Units <- if (ID == "AT") paste0(SRS_UNITS, "/s2") else if (ID == "VT") paste0(SRS_UNITS, "/s") else SRS_UNITS

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
  yAxis.legend  = sprintf("%s(%s) [%s]", ID, DIR, Units),
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
PLOT$x$hc_opts$series <- lapply(PLOT$x$hc_opts$series, function(Series) {
  Series$visible <- FALSE
  Series
})
rm(SRS, Column, Units)
# nolint end
