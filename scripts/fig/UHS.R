# nolint start
if (!exists("p.target") || !length(p.target)) p.target <- p.gmdp
# MCE spectra carry no TR: an absent TR.target selects the scenario table.
MCE <- !exists("TR.target", inherits = FALSE)
UHS <- if (MCE) {
  MCETable[ID %in% ID.target & Vs30 %in% Vs30.target & .matchP(p, p.target)]
} else {
  UHSTable[ID %in% ID.target & Vs30 %in% Vs30.target & TR %in% TR.target & .matchP(p, p.target)]
}
if ("siteID" %in% names(UHS) && exists("siteID.target", inherits = FALSE)) {
  UHS <- UHS[siteID %in% siteID.target]
} else if ("siteID" %in% names(UHS)) {
  SITE_ID <- unique(UHS[!is.na(siteID) & nzchar(siteID), siteID])
  if (length(SITE_ID) == 1L) UHS <- UHS[siteID %in% SITE_ID]
  rm(SITE_ID)
}
SITE_BY <- "siteID" %in% names(UHS) && uniqueN(UHS$siteID, na.rm = TRUE) > 1L
TR_BY <- !MCE && "TR" %in% names(UHS) && uniqueN(UHS$TR) > 1L
TR_LEVELS <- if (TR_BY) sort(unique(UHS$TR)) else numeric()
TR_STYLES <- c(
  "ShortDot", "Dot", "ShortDash", "ShortDashDot",
  "DashDot", "Dash", "LongDash", "Solid"
)
TR_STYLE <- setNames(
  rep(TR_STYLES, length.out = length(TR_LEVELS)),
  as.character(TR_LEVELS)
)
FILL <- if (exists("fill.target", inherits = FALSE)) {
  isTRUE(fill.target)
} else {
  uniqueN(UHS$p) > 1L
}

DATA <- UHS[, .(
  ID    = if (TR_BY) {
    paste0("TR ", prettyNum(round(TR, 0), big.mark = ","), " yr")
  } else if (SITE_BY) {
    paste(siteID, ID, if (!MCE) TR, Vs30, p)
  } else {
    paste(ID, if (!MCE) TR, Vs30, p)
  },
  X     = Tn,
  Y     = SaF,
  SeriesOrder = if (TR_BY) match(TR, TR_LEVELS) else 1L,
  style = if (TR_BY) {
    unname(TR_STYLE[as.character(TR)])
  } else if (MCE) {
    fifelse(
      p == "mean",
      "Solid",
      fifelse(p %in% c("0.05", "0.95"), "Dot", "ShortDashDot")
    )
  } else {
    fifelse(p == "mean", "Solid", "ShortDashDot")
  },
  size  = fifelse(p == "mean", THICK_LINE_SIZE, THIN_LINE_SIZE)
)]
if (TR_BY) {
  setorder(DATA, SeriesOrder, X)
} else {
  setorder(DATA, ID, X)
}
DATA[, SeriesOrder := NULL]
DATA <- unique(DATA)

DUP <- DATA[, .N, by = .(ID, X)][N > 1]
if (nrow(DUP)) {
  stop("UHS.R: more than one Sa ordinate found for at least one plotted series/Tn.")
}

PLOT <- buildPlot(
  line.type     = "spline",
  plot.height   = 500,
  legend.layout = "horizontal",
  legend.show   = TRUE,
  xAxis.log     = TRUE,
  yAxis.log     = Sa.log,
  xAxis.log.zero.label = "PGA",
  xAxis.legend  = "Tn [s]",
  yAxis.legend  = "Sa [g]",
  group.legend  = "ID",
  plot.theme    = NGR::hc_theme_538_gridlines(),
  fill.legend   = "min–max",
  fill.minmax   = FILL,
  fill.max.style = "Dot",
  fill.min.style = "Dot",
  fill.max.size = THIN_LINE_SIZE,
  fill.min.size = THIN_LINE_SIZE,
  data.lines    = DATA
)
rm(
  UHS, DATA, DUP, SITE_BY, TR_BY, TR_LEVELS, TR_STYLES, TR_STYLE, FILL, MCE
)
# nolint end
