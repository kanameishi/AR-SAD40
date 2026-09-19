# nolint start
# DSHA comparison table: probabilistic UHS (TR 10,000, mean) vs the
# deterministic scenario means and the MCE envelopes, per Tn.
# The canonical MCETable ID "MCE" supplies the mean and p = 0.84
# deterministic envelopes; the legacy ID "max" is not consumed here.
if (!exists("Vs30.target", inherits = FALSE) || length(Vs30.target) != 1L) Vs30.target <- 760

SITE_ID <- if (exists("siteID.target", inherits = FALSE)) siteID.target else {
  unique(MCETable[!is.na(siteID) & nzchar(siteID), siteID])
}
if (length(SITE_ID) != 1L) stop("DSHA.R: set siteID.target to one siteID.", call. = FALSE)
if (!exists("ID.target", inherits = FALSE) || !length(ID.target)) {
  ID.target <- .resolveIDTarget(UHSTable, "DSHA.R", siteID = SITE_ID, base = TRUE)
}

SCN <- sort(unique(MCETable[
  !ID %in% c("MCE", "max", "min") & !grepl("\\.(site|oq|max)$", ID) &
    siteID %in% SITE_ID, ID
]))
TNS <- intersect(c(0, 0.1, 0.2, 0.5, 1, 2, 5), unique(MCETable$Tn))

DT <- rbindlist(list(
  UHSTable[
    ID %in% ID.target & siteID %in% SITE_ID & Vs30 == Vs30.target &
      TR == 10000 & .matchP(p, "mean") & Tn %in% TNS,
    .(Tn, col = "UHS TR-10,000", DSHA = SaF)
  ],
  MCETable[
    ID %in% SCN & siteID %in% SITE_ID & Vs30 == Vs30.target &
      .matchP(p, "mean") & Tn %in% TNS,
    .(Tn, col = ID, DSHA = SaF)
  ],
  MCETable[
    ID == "MCE" & siteID %in% SITE_ID & Vs30 == Vs30.target &
      .matchP(p, c("mean", "0.84")) & Tn %in% TNS,
    .(Tn, col = fifelse(.matchP(p, "mean"), "MCE", "MCE (84%)"), DSHA = SaF)
  ]
), use.names = TRUE)
if (!nrow(DT)) stop("DSHA.R: no rows for the selected site/Vs30.", call. = FALSE)
if (PSA_Units %in% c("cm", "cm/s2", "cm/s**2", "cm/s^2")) DT[, DSHA := round(DSHA * 980.665, 0)]
if (PSA_Units %in% c("g"))                                DT[, DSHA := round(DSHA, 3)]

AUX <- dcast(DT, Tn ~ col, value.var = "DSHA")
COLS <- intersect(
  c("Tn", "UHS TR-10,000", SCN, "MCE", "MCE (84%)"),
  names(AUX)
)
setcolorder(AUX, COLS)

# The scenario, MCE, and MCE (84%) columns are labelled by the series they
# report; only the period index and the probabilistic column carry a symbol.
SYMBOLS <- c(
  Tn                = "T_n",
  `UHS TR-10,000`   = "\\mathrm{UHS}\\ (T_R = 10{,}000)"
)

TBL <- AUX |> buildTable(
  library          = "flextable",
  align.body       = "center",
  font.size.body   = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |> .mathHeader(SYMBOLS) |> flextable::set_table_properties(layout = "autofit")
TBL <- flextable::bold(TBL, j = intersect(c("MCE", "MCE (84%)"), names(AUX)), part = "header")

rm(DT, AUX, COLS, SYMBOLS, SCN, TNS, SITE_ID)
# nolint end
