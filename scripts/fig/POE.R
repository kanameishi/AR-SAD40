# nolint start
AEP <- AEPTable[ID %in% ID.target & Tn %in% Tn.target & Vs30 %in% Vs30.target & .matchP(p, "mean")]
if ("siteID" %in% names(AEP) && exists("siteID.target", inherits = FALSE)) {
  AEP <- AEP[siteID %in% siteID.target]
}
SITE_BY <- "siteID" %in% names(AEP) && uniqueN(AEP$siteID, na.rm = TRUE) > 1L


DATA <- AEP[, .(
    ID = if (SITE_BY) {
        paste0("Tn=", Tn, " (", siteID, "-", Vs30, "-", ID, ")")
    } else {
        paste0("Tn=", Tn, " (", Vs30, "-", ID, ")")
    },
    Y = POE,
    X = Sa,
    style = "Solid",
    size = MID_LINE_SIZE
)][order(X)][order(ID)] |> unique()


PLOT <- buildPlot(
  xAxis.label = TRUE,
  yAxis.label = TRUE,
  plot.height = 750,
  legend.layout = "horizontal",
  legend.show = TRUE,
  line.size = MID_LINE_SIZE,
  xAxis.log = TRUE,
  yAxis.log = FALSE,
  yAxis.legend = "POE",
  xAxis.legend = "Sa(Tn) [g]",
  group.legend = "ID",
  plot.theme = NGR::hc_theme_538_gridlines(),
  data.lines = DATA
)

rm(AEP, DATA, SITE_BY)
