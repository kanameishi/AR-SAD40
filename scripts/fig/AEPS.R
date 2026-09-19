# nolint start
#
AEPS <- AEPSTable[ID %in% ID.target & Tn %in% Tn.target & Vs30 %in% Vs30.target & p == "mean"]
if ("siteID" %in% names(AEPS) && exists("siteID.target", inherits = FALSE)) {
  AEPS <- AEPS[siteID %in% siteID.target]
}
SITE_BY <- "siteID" %in% names(AEPS) && uniqueN(AEPS$siteID, na.rm = TRUE) > 1L
TN_BY <- uniqueN(AEPS$Tn, na.rm = TRUE) > 1L
AEPS <- AEPS[AEP >= 1e-6]

DATA <- AEPS[, .(
    ID = if (SITE_BY && TN_BY) {
        paste(siteID, paste0("Tn=", Tn), providerID)
    } else if (SITE_BY) {
        paste(siteID, providerID)
    } else if (TN_BY) {
        paste(paste0("Tn=", Tn), providerID)
    } else {
        providerID
    },
    Y = AEP,
    X = Sa,
    style = "Solid",
    size = THIN_LINE_SIZE
)][order(X)][order(ID)] |> unique()

# Total curve: sum of all sources at each Sa (full range)
TOTAL_BY <- c(if (SITE_BY) "siteID", if (TN_BY) "Tn", "Sa")
TOTAL <- AEPS[, .(Y = sum(AEP)), by = TOTAL_BY][order(Sa)]
TOTAL <- TOTAL[Y >= 1e-6]
TOTAL <- TOTAL[, .(
    ID = if (SITE_BY && TN_BY) {
        paste(siteID, paste0("Tn=", Tn), "Total")
    } else if (SITE_BY) {
        paste(siteID, "Total")
    } else if (TN_BY) {
        paste(paste0("Tn=", Tn), "Total")
    } else {
        "Total"
    },
    Y = Y,
    X = Sa,
    style = "Dash",
    size = THICK_LINE_SIZE
)]

DATA <- data.table::rbindlist(list(TOTAL, DATA), use.names = TRUE)

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
# nolint end
rm(AEPS, DATA, TOTAL, TOTAL_BY, SITE_BY, TN_BY)
