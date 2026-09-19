# nolint start
#

AEPS <- AEPSTable[ID %in% ID.target & Tn %in% Tn.target & Vs30 %in% Vs30.target & p == "mean"]
if ("siteID" %in% names(AEPS) && exists("siteID.target", inherits = FALSE)) {
  AEPS <- AEPS[siteID %in% siteID.target]
}
SITE_BY <- "siteID" %in% names(AEPS) && uniqueN(AEPS$siteID, na.rm = TRUE) > 1L
TN_BY <- uniqueN(AEPS$Tn, na.rm = TRUE) > 1L
AEPS <- AEPS[AEP >= 1e-6]
AEPS_ALL <- AEPS

# Drop sources whose POE at min(Sa) is below POE_MIN
KEEP_BY <- c(if (SITE_BY) "siteID", if (TN_BY) "Tn", "providerID")
KEEP_GROUP <- setdiff(KEEP_BY, "providerID")
keepProviders <- AEPS[, .(POE_at_minSa = POE[which.min(Sa)]), by = KEEP_BY]
if (length(KEEP_GROUP)) {
  keepProviders[, rank := frank(-POE_at_minSa, ties.method = "first"), by = KEEP_GROUP]
} else {
  keepProviders[, rank := frank(-POE_at_minSa, ties.method = "first")]
}
keepProviders <- keepProviders[POE_at_minSa >= POE_MIN | rank <= 5L]
AEPS <- merge(AEPS, keepProviders[, KEEP_BY, with = FALSE], by = KEEP_BY)

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
    Y = POE,
    X = Sa,
    style = "Solid",
    size = THIN_LINE_SIZE
)][order(X)][order(ID)] |> unique()

# Total curve: POE from summed AEP at each Sa (all sources)
TOTAL_BY <- c(if (SITE_BY) "siteID", if (TN_BY) "Tn", "Sa")
TOTAL <- AEPS_ALL[, .(AEP = sum(AEP)), by = TOTAL_BY][order(Sa)]
TOTAL <- TOTAL[AEP >= 1e-6]
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
    Y = 1 - exp(-AEP * ITo),
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
  xAxis.log = TRUE,
  yAxis.log = FALSE,
  yAxis.legend = "POE",
  xAxis.legend = "Sa(Tn) [g]",
  group.legend = "ID",
  plot.theme = NGR::hc_theme_538_gridlines(),
  data.lines = DATA
)
# nolint end
rm(AEPS, AEPS_ALL, DATA, TOTAL, TOTAL_BY, KEEP_BY, KEEP_GROUP, keepProviders, SITE_BY, TN_BY)
