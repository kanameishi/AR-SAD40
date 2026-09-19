# nolint start
# Deterministic PGA summary by site condition: the mean PGA of each scenario
# and the mean and 84th-percentile PGA of the MCE envelope.
# Expects: Vs30.target, PSA_Units
SITE_ID <- if (exists("siteID.target", inherits = FALSE)) siteID.target else {
  unique(MCETable[!is.na(siteID) & nzchar(siteID), siteID])
}
if (length(SITE_ID) != 1L) stop("Scenarios.PGA.R: set siteID.target to one siteID.", call. = FALSE)

SCN <- sort(unique(MCETable[
  !ID %in% c("MCE", "max", "min") & !grepl("\\.(site|oq|max)$", ID) &
    siteID %in% SITE_ID, ID
]))
DT <- rbindlist(list(
  MCETable[ID %in% SCN & siteID %in% SITE_ID & .matchP(p, "mean") & Vs30 %in% Vs30.target],
  MCETable[ID == "MCE" & siteID %in% SITE_ID & .matchP(p, c("mean", "0.84")) & Vs30 %in% Vs30.target]
), use.names = TRUE)
if (!nrow(DT)) stop("Scenarios.PGA.R: no rows for the selected targets.", call. = FALSE)
DT <- DT[Tn == min(Tn), .(ID, p, Vs30, SaF)]
DT[, Scenario := fifelse(.matchP(p, "mean"), ID, paste0(ID, " (84%)"))]

if (anyDuplicated(DT, by = c("Scenario", "Vs30"))) {
  stop("Scenarios.PGA.R: duplicated PGA per scenario and Vs30.", call. = FALSE)
}
if (PSA_Units %in% c("cm", "cm/s2", "cm/s**2", "cm/s^2")) DT[, SaF := round(SaF * 980.665, 0)]
if (PSA_Units %in% c("g"))                                DT[, SaF := round(SaF, 3)]

AUX <- dcast(DT, Scenario ~ Vs30, value.var = "SaF")
ORDER <- c(SCN, "MCE", "MCE (84%)")
AUX <- AUX[order(chmatch(Scenario, ORDER))]
VS_COLS <- setdiff(names(AUX), "Scenario")
setcolorder(AUX, c("Scenario", VS_COLS[order(as.numeric(VS_COLS))]))

TBL <- AUX |> buildTable(
  library          = "flextable",
  align.body       = "center",
  font.size.body   = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |> .mathHeader(c(
  Scenario = "e"
)) |> flextable::set_table_properties(layout = "autofit")

rm(DT, AUX, SCN, ORDER, VS_COLS, SITE_ID)
# nolint end
