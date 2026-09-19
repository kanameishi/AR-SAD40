# nolint start
# [1] 0.050 0.075 0.100 0.120 0.150 0.180 0.200 0.220 0.250 0.280 0.300 0.350 0.400
#[14] 0.450 0.500 0.600 0.700 0.750 0.850 0.900 1.000 1.250 1.500 1.750 2.000 2.500
# [27] 3.000 3.500 4.000 4.500 5.000

#
AEP <- AEPTable[ID %in% ID.target & Tn %in% Tn.target & Vs30 %in% Vs30.target & .matchP(p, "mean")]
if ("siteID" %in% names(AEP) && exists("siteID.target", inherits = FALSE)) {
  AEP <- AEP[siteID %in% siteID.target]
}
SITE_BY <- "siteID" %in% names(AEP) && uniqueN(AEP$siteID, na.rm = TRUE) > 1L
AEP <- AEP[AEP >= 1e-6]

DATA <- AEP[, .(
    ID = if (SITE_BY) {
        paste0("Tn=", Tn, " (", siteID, "-", Vs30, "-", ID, ")")
    } else {
        paste0("Tn=", Tn, " (", Vs30, "-", ID, ")")
    },
    Y = AEP,
    X = Sa,
    style = "Solid",
    size = MID_LINE_SIZE
)][order(X)][order(ID)] |> unique() # paleosimic limits

PLOT <- buildPlot(
  xAxis.label = TRUE,
  yAxis.label = TRUE,
  plot.height = 750,
  legend.layout = "horizontal",
  legend.show = TRUE,
  line.size = MID_LINE_SIZE,
  yAxis.log = AEP.log,
  xAxis.log = Sa.log,
  yAxis.legend  = "AEP [1/yr]",
  yAxis2.legend = "TR [yr]",
  yAxis2.transform = ~ 1 / Y,
  yAxis2.decimals = 0,
  xAxis.legend = "Sa(Tn) [g]",
  group.legend = "ID",
  plot.theme = NGR::hc_theme_538_gridlines(),
  data.lines = DATA
)
rm(AEP, DATA, SITE_BY)
