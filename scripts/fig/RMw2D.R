# nolint start
RMw <- RMwTable
if ("siteID" %in% names(RMw) && exists("siteID.target", inherits = FALSE)) {
  RMw <- RMw[siteID %in% siteID.target]
}
if ("siteID" %in% names(RMw) && uniqueN(RMw$siteID, na.rm = TRUE) > 1L) {
  stop("RMw2D: set siteID.target to one siteID.")
}
if ("ID" %in% names(RMw)) {
  ID.target <- .resolveIDTarget(
    RMw,
    "RMw2D",
    target = .currentTarget("ID.target"),
    siteID = .currentTarget("siteID.target"),
    base = TRUE
  )
  RMw <- RMw[ID %in% ID.target]
}

DT <- RMw[Tn == Tn.target & TR == TR.target]
if (!nrow(DT)) {
  AUX       <- sort(unique(RMw$TR))
  TR.target <- AUX[which.min(abs(AUX - TR.target))]
  DT        <- RMw[Tn == Tn.target & TR == TR.target]
  rm(AUX)
}
DT[, pct := p / sum(p) * 100]

Widest <- RMw[Tn == Tn.target & TR == sort(unique(RMw[Tn == Tn.target]$TR))[1] & p > 0]
RStep  <- unique(diff(sort(unique(RMw$R))))[1]
MwStep <- unique(diff(sort(unique(RMw$Mw))))[1]
Rmax   <- min(max(Widest$R), RStep * 16L)
NICE   <- c(50, 100, 150, 200, 250, 300, 400, 500, 750, 1000)
AUX    <- NICE[which(NICE >= Rmax)[1]]
if (!is.na(AUX)) Rmax <- AUX
MwSpan <- max(Widest$Mw) - min(Widest$Mw)
MwPad  <- max(0, (8L * MwStep - MwSpan) / 2)
MwMin  <- floor((min(Widest$Mw) - MwPad) / MwStep) * MwStep
MwMax  <- ceiling((max(Widest$Mw) + MwPad) / MwStep) * MwStep
DT     <- DT[R <= Rmax & Mw >= MwMin & Mw <= MwMax]
rm(Widest, Rmax, NICE, AUX, MwSpan, MwPad, MwMin, MwMax)


rm(RStep, MwStep)

DT <- .rmwBlocks(DT[, .(Mw, R, p = pct)])[, .(X = R, Y = Mw, Z = round(p, 2))]

# Constant color scale across every (Tn, TR) panel of the site, so
# colors are comparable between tabs: site-wide max block contribution.
ZMAX <- RMw[, {
  AUX <- .rmwBlocks(.SD[, .(Mw, R, p)])
  max(AUX$p / sum(AUX$p) * 100)
}, by = .(Tn, TR)][, max(V1)]

PLOT <- NGR::buildHeatmap(
  .data          = DT,
  xAxis.legend   = "R [km]",
  yAxis.legend   = "Mw",
  colorAxis.min  = 0,
  colorAxis.max  = ceiling(ZMAX),
  series.name    = "[%]",
  tooltip.format = "R = <b>{point.xLabel}</b> km | Mw = <b>{point.yLabel}</b><br><b>{point.value}%</b>",
  plot.theme     = NGR::hc_theme_538_gridlines()
) |> highcharter::hc_size(height = 750)
# nolint end
rm(RMw, DT, ZMAX)
