# nolint start
# MCE has no return period, as in the UHS builder.
MCE <- !exists("TR.target", inherits = FALSE)
STYLES <- setNames(rep(c("Solid", "ShortDot", "Dot", "ShortDash", "Dash", "LongDash"),
                       length.out = length(IDg.gmdp)), IDg.gmdp)
WIDTHS <- setNames(rep(c(MID_LINE_SIZE, THICK_LINE_SIZE), each = 6L,
                       length.out = length(IDg.gmdp)), IDg.gmdp)
COLORS <- setNames(grDevices::hcl.colors(length(IDm.gmdp), palette = "Dark 3"), IDm.gmdp)
IDN_PLOT <- c("ensemble", "rigid", "flexible")
if (!exists("IDn.target") || !length(IDn.target)) IDn.target <- IDN_PLOT
IDn.target <- intersect(as.character(IDn.target), IDN_PLOT)
if (!exists("p.target") || !length(p.target)) p.target <- "mean"
DN_MIN_PLOT <- if (exists("DN_MIN_PLOT", inherits = FALSE)) DN_MIN_PLOT else 1e-4

DN <- DnTable[
  IDg %in% IDg.target & IDm %in% IDm.target &
  IDn %in% IDn.target & (if (MCE) ID == "MCE" else TR %in% TR.target) &
  .matchP(p, p.target)
]
if ("siteID" %in% names(DN) && exists("siteID.target", inherits = FALSE)) {
  DN <- DN[siteID %in% siteID.target]
}
SITE_BY <- "siteID" %in% names(DN) && uniqueN(DN$siteID, na.rm = TRUE) > 1L
GEO <- ShearTable[IDg %in% IDg.target, .(Hs = unique(Hs)[1L]), by = IDg]
DN <- GEO[DN, on = "IDg"]
DN <- DN[Dn > DN_MIN_PLOT]

DATA <- DN[, .(
  ID    = if (SITE_BY) paste(siteID, IDm, IDg, sep = ".") else paste(IDm, IDg, sep = "."),
  Y     = Dn / Hs,
  X     = ky,
  style = unname(STYLES[IDg]),
  size  = unname(WIDTHS[IDg])
)]
setorder(DATA, ID, X)
DATA <- unique(DATA)

DUP <- DATA[, .N, by = .(ID, X)][N > 1L]
if (nrow(DUP)) {
  stop("Dn.R: more than one displacement ordinate found for at least one plotted series/ky.")
}

PLOT <- buildPlot(
  line.type     = "spline",
  plot.height   = PLOT.HEIGHT,
  legend.layout = "horizontal",
  legend.valign = "bottom",
  legend.show   = TRUE,
  xAxis.log     = TRUE,
  yAxis.log     = TRUE,
  yAxis.min     = DN_MIN_PLOT / max(GEO$Hs),
  xAxis.legend  = "ky [g]",
  yAxis.legend  = "Dn/H [%]",
  yAxis.bands   = list(cuts = DAMAGE.CUTS, colors = DAMAGE.COLORS),
  group.legend  = "IDm.IDg",
  plot.theme    = NGR::hc_theme_538_gridlines(),
  data.lines    = DATA
)
PLOT$x$hc_opts$series <- lapply(PLOT$x$hc_opts$series, function(Series) {
  ID <- strsplit(Series$name, ".", fixed = TRUE)[[1L]]
  Series$color <- unname(COLORS[[ID[[if (SITE_BY) 2L else 1L]]]])
  Series
})
rm(STYLES, WIDTHS, COLORS)
rm(DN, DN_MIN_PLOT, DATA, DUP, SITE_BY, IDN_PLOT, GEO, MCE)
# nolint end
