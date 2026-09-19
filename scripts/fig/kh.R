# nolint start
# MCE has no return period, as in the UHS builder.
MCE <- !exists("TR.target", inherits = FALSE)
STYLES <- setNames(rep(c("Solid", "ShortDot", "Dot", "ShortDash", "Dash", "LongDash"),
                       length.out = length(IDg.gmdp)), IDg.gmdp)
WIDTHS <- setNames(rep(c(MID_LINE_SIZE, THICK_LINE_SIZE), each = 6L,
                       length.out = length(IDg.gmdp)), IDg.gmdp)
COLORS <- setNames(grDevices::hcl.colors(length(IDm.gmdp), palette = "Dark 3"), IDm.gmdp)
# kh plot (kmaxTable) - Kh vs Da/H

KMT0 <- kmaxTable
if ("siteID" %in% names(KMT0) && exists("siteID.target", inherits = FALSE)) {
  KMT0 <- KMT0[siteID %in% siteID.target]
}
if (!exists("IDn.target") || !length(IDn.target)) IDn.target <- "ensemble"
KMT0 <- KMT0[
  (if (MCE) ID == "MCE" else TR %in% TR.target) &
    IDg %in% IDg.target &
    IDm %in% IDm.target &
    Da %in% Da.target &
    IDn %in% IDn.target
][.matchP(p, p.target)]
GEO <- ShearTable[IDg %in% IDg.target, .(Hs = unique(Hs)[1L]), by = IDg]
KMT0 <- GEO[KMT0, on = "IDg"]
SITE_BY <- "siteID" %in% names(KMT0) && uniqueN(KMT0$siteID, na.rm = TRUE) > 1L
DATA <- KMT0[, .(
  ID    = if (SITE_BY) paste(siteID, IDm, IDg, sep = ".") else paste(IDm, IDg, sep = "."),
  Y     = 100 * Kh,
  # Da in cm over Hs in m equals Da/H expressed in percent; signif() keeps
  # tooltip values readable without visibly moving the curves.
  X     = signif(Da / Hs, 3L),
  style = unname(STYLES[IDg]),
  size  = unname(WIDTHS[IDg])
)]
setorder(DATA, ID, X)
# Coefficients are reported only up to a displacement of 10% of the slope height.
DATA <- DATA[is.finite(Y) & is.finite(X) & X <= 10]
DUP <- DATA[, .N, by = .(ID, X)][N > 1L]
if (nrow(DUP)) {
  stop("kh.R: more than one coefficient found for at least one plotted series/Da/H.")
}

PLOT <- buildPlot(
  yAxis.label = TRUE,
  line.type = "spline",
  plot.height = PLOT.HEIGHT,
  legend.layout = "horizontal",
  legend.valign = "bottom",
  legend.show = TRUE,
  xAxis.log = TRUE,
  line.size = MID_LINE_SIZE,
  xAxis.legend = "Da/H [%]",
  xAxis.bands = list(cuts = DAMAGE.CUTS, colors = DAMAGE.COLORS),
  yAxis.legend = "Kh [% PGA]",
  group.legend = "IDm.IDg",
  plot.theme = NGR::hc_theme_538_gridlines(),
  data.lines = DATA
)
# nolint end
PLOT$x$hc_opts$series <- lapply(PLOT$x$hc_opts$series, function(Series) {
  ID <- strsplit(Series$name, ".", fixed = TRUE)[[1L]]
  Series$color <- unname(COLORS[[ID[[if (SITE_BY) 2L else 1L]]]])
  Series
})
rm(STYLES, WIDTHS, COLORS)
rm(KMT0, GEO, DATA, DUP, SITE_BY, MCE)
