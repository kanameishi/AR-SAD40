# nolint start
# Seismic-hazard comparison at one site and target Vs30. Deterministic
# scenarios and MCE come from MCETable; MDE is the TR = 10,000 PSHA
# spectrum, read from the base ID at Vs30 = 760 and from the .site
# lineage at other target conditions.
SITE_ID <- .cleanTarget(.currentTarget("siteID.target"))
if (length(SITE_ID) != 1L) {
  stop("UHS.compare.R: set siteID.target to one siteID.", call. = FALSE)
}
if (!exists("Vs30.target", inherits = FALSE) || length(Vs30.target) != 1L) {
  Vs30.target <- 760
}
if (!exists("p.target", inherits = FALSE) || !length(p.target)) {
  p.target <- "mean"
}
ID.target <- .resolveIDTarget(
  UHSTable,
  "UHS.compare.R",
  target = .currentTarget("ID.target"),
  siteID = SITE_ID,
  base = TRUE
)

MDE_ID <- if (Vs30.target == 760) ID.target else paste0(ID.target, ".site")

# Un plot de diseño publica el espectro, no su descomposición: los escenarios
# que componen el MCE quedan fuera.
MCE <- MCETable[
  siteID %in% SITE_ID & ID == "MCE" & Vs30 == Vs30.target &
    .matchP(p, p.target),
  .(Product = "MCE", p, Tn, Sa = SaF)
]
MDE <- UHSTable[
  siteID %in% SITE_ID & ID %in% MDE_ID & TR == 10000 &
    Vs30 == Vs30.target & .matchP(p, p.target),
  .(Product = "MDE", p, Tn, Sa = SaF)
]

DT <- rbindlist(list(MCE, MDE), use.names = TRUE)
if (!nrow(MCE) || !nrow(MDE)) {
  stop("UHS.compare.R: MCE or MDE spectra are missing.", call. = FALSE)
}
PRODUCTS <- c("MCE", "MDE")
P_LEVELS <- unique(as.character(p.target))
P_STYLES <- c(
  "0.05" = "Dot",
  "0.10" = "ShortDash",
  "0.16" = "ShortDashDot",
  "0.50" = "Dash",
  "0.84" = "DashDot",
  "0.90" = "LongDash",
  "0.95" = "LongDashDotDot",
  "mean" = "Solid"
)
DT[, `:=`(
  ProductOrder = match(Product, PRODUCTS),
  POrder = match(as.character(p), P_LEVELS)
)]
setorder(DT, ProductOrder, POrder, Tn)
DATA <- DT[, .(
  ID = paste(Product, ifelse(p == "mean", "mean", paste0("p=", p))),
  X = Tn,
  Y = Sa,
  style = unname(P_STYLES[as.character(p)]),
  size = fifelse(p == "mean", THICK_LINE_SIZE, THIN_LINE_SIZE)
)]

DUP <- DATA[, .N, by = .(ID, X)][N > 1L]
if (nrow(DUP)) {
  stop(
    "UHS.compare.R: duplicate ordinates for at least one series/Tn.",
    call. = FALSE
  )
}

PLOT <- buildPlot(
  line.type     = "spline",
  plot.height   = 500,
  legend.layout = "horizontal",
  legend.show   = TRUE,
  xAxis.log     = TRUE,
  yAxis.log     = TRUE,
  xAxis.log.zero.label = "PGA",
  xAxis.legend  = "Tn [s]",
  yAxis.legend  = "Sa [g]",
  group.legend  = "ID",
  plot.theme    = NGR::hc_theme_538_gridlines(),
  fill.minmax   = FALSE,
  data.lines    = DATA
)
COLORS <- c(
  S1 = "#E41A1C",
  S2 = "#377EB8",
  S3 = "#4DAF4A",
  SREF = "#984EA3",
  MCE = "#000000",
  MDE = "#FF7F00"
)
PLOT$x$hc_opts$series <- lapply(PLOT$x$hc_opts$series, function(Series) {
  Product <- sub(" .*", "", Series$name)
  if (Product %in% names(COLORS)) Series$color <- unname(COLORS[[Product]])
  Series
})
rm(
  SITE_ID, MDE_ID, MCE, MDE, DT, DATA, DUP,
  PRODUCTS, P_LEVELS, P_STYLES, COLORS
)
# nolint end
