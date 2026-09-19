# nolint start
if (!exists("RecordID.target", inherits = FALSE)) {
  stop("RecordID.target must be set before sourcing IPSA.R.", call. = FALSE)
}
if (!exists("IPSATable", inherits = FALSE)) {
  stop("IPSATable must be loaded before sourcing IPSA.R.", call. = FALSE)
}
COLS <- c("RecordID", "OCID", "Tn", "ID", "PSA")
MISS <- setdiff(COLS, names(IPSATable))
if (length(MISS)) {
  stop(sprintf("IPSA.csv missing columns: %s.", paste(MISS, collapse = ", ")),
       call. = FALSE)
}

Record <- as.character(RecordID.target)
SRS <- IPSATable[RecordID == Record & OCID == "H1", .(
  ID    = ID,
  X     = Tn,
  Y     = PSA,
  style = fifelse(ID == "signal", "Solid", "ShortDashDot"),
  size  = fifelse(ID == "signal", THICK_LINE_SIZE, MID_LINE_SIZE)
)][is.finite(X) & is.finite(Y) & Y > 0]
if (!nrow(SRS)) stop(sprintf("IPSA has no H1 rows for %s.", Record), call. = FALSE)

SRS[, ID := factor(ID, levels = unique(c("signal", as.character(ID))))]
setorder(SRS, ID, X)
SRS[, ID := as.character(ID)]

PLOT <- buildPlot(
  line.type     = "spline",
  plot.height   = 750,
  legend.layout = "horizontal",
  legend.show   = TRUE,
  xAxis.log     = TRUE,
  yAxis.log     = TRUE,
  xAxis.log.zero = TRUE,
  xAxis.log.zero.label = "PGA",
  xAxis.legend  = "Tn [s]",
  yAxis.legend  = sprintf("PSA(H1) [%s/s2]", SRS_UNITS),
  group.legend  = "ID",
  plot.theme    = NGR::hc_theme_538_gridlines(),
  data.lines    = SRS
)

rm(Record, SRS, COLS, MISS)
# nolint end
