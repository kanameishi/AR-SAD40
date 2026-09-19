# nolint start
# ASCE-7 demands panel - MCER, Design (2/3 MCER) and the code-form
# spectrum of Section 11.4.5, on one Vs30 cell. No fill: the MCER-Design
# separation is the fixed 2/3 factor, not an uncertainty band. The deterministic MCE and the MDE belong to the DSHA and
# criteria chapters and are not repeated here. Consumes ASCETable.

MCER <- .selectASCETable(
  ASCETable,
  "MCE.MDE.R",
  idTarget = .currentTarget("ID.target"),
  siteID = .currentTarget("siteID.target"),
  vs30 = Vs30.target,
  p = "mean",
  spectrum = "mcer"
)
DESIGN <- .selectASCETable(
  ASCETable,
  "MCE.MDE.R",
  idTarget = .currentTarget("ID.target"),
  siteID = .currentTarget("siteID.target"),
  vs30 = Vs30.target,
  p = "mean",
  spectrum = "design"
)
CODE <- .selectASCETable(
  ASCETable,
  "MCE.MDE.R",
  idTarget = .currentTarget("ID.target"),
  siteID = .currentTarget("siteID.target"),
  vs30 = Vs30.target,
  p = "mean",
  spectrum = "code"
)



DATA <- rbindlist(list(
  MCER[, .(
    ID = "MCER", X = Tn, Y = SaF, SeriesOrder = 1L,
    style = "LongDashDot", size = THICK_LINE_SIZE, fill = FALSE
  )],
  DESIGN[, .(
    ID = "2/3 MCER", X = Tn, Y = SaF, SeriesOrder = 2L,
    style = "Solid", size = THICK_LINE_SIZE, fill = FALSE
  )],
  CODE[, .(
    ID = "ASCE §11.4.5", X = Tn, Y = SaF, SeriesOrder = 3L,
    style = "ShortDashDot", size = MID_LINE_SIZE, fill = FALSE
  )]
), use.names = TRUE) |> unique()
setorder(DATA, SeriesOrder, X)

DUP <- DATA[, .N, by = .(ID, X)][N > 1]
if (nrow(DUP)) {
  stop("MCE.MDE.R: more than one Sa ordinate found for at least one plotted series/Tn.")
}
DATA[, SeriesOrder := NULL]

PLOT <- buildPlot(
  line.type     = "spline",
  plot.height   = 500,
  legend.layout = "horizontal",
  legend.show   = TRUE,
  xAxis.log     = Tn.log,
  yAxis.log     = Sa.log,
  xAxis.log.zero.label = "PGA",
  xAxis.legend  = "Tn [s]",
  yAxis.legend  = "Sa [g]",
  group.legend  = "ID",
  plot.theme    = NGR::hc_theme_538_gridlines(),
  data.lines    = DATA
)
rm(DATA, DUP, MCER, DESIGN, CODE)
# nolint end
