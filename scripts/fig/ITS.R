# nolint start
if (!exists("RecordID.target", inherits = FALSE)) {
  stop("RecordID.target must be set before sourcing ITS.R.", call. = FALSE)
}
if (!exists("ITSTable", inherits = FALSE)) {
  stop("ITSTable must be loaded before sourcing ITS.R.", call. = FALSE)
}
COLS <- c("RecordID", "OCID", "t", "ID", "AT")
MISS <- setdiff(COLS, names(ITSTable))
if (length(MISS)) {
  stop(sprintf("ITS.csv missing columns: %s.", paste(MISS, collapse = ", ")),
       call. = FALSE)
}

Record <- as.character(RecordID.target)
SRS <- ITSTable[RecordID == Record & OCID == "H1", .(
  ID    = ID,
  X     = t,
  Y     = AT,
  style = fifelse(ID == "signal", "Solid", "ShortDashDot"),
  size  = THIN_LINE_SIZE,
  Draw  = fifelse(ID == "signal", 1L, 0L)
)][is.finite(X) & is.finite(Y)]
if (!nrow(SRS)) stop(sprintf("ITS has no H1 rows for %s.", Record), call. = FALSE)

setorder(SRS, Draw, ID, X)
SRS[, Draw := NULL]

PLOT <- buildPlot(
  line.type     = "line",
  plot.height   = 750,
  legend.layout = "horizontal",
  legend.show   = TRUE,
  xAxis.legend  = "t [s]",
  yAxis.legend  = sprintf("AT(H1) [%s/s2]", SRS_UNITS),
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

rm(Record, SRS, COLS, MISS)
# nolint end
