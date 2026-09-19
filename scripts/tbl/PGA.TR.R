# nolint start
# Executive hazard summary: mean PGA by return period and site condition,
# one row per TR plus the mean and 84th-percentile MCE envelopes.
# Expects: ID.target, TR.target, Vs30.target, PSA_Units
DT <- UHSTable[
  .matchP(p, "mean") & ID %in% ID.target &
    Vs30 %in% Vs30.target & TR %in% TR.target
]
if ("siteID" %in% names(DT) && exists("siteID.target", inherits = FALSE)) {
  DT <- DT[siteID %in% siteID.target]
}
if (!nrow(DT)) stop("PGA.TR.R: no rows for the selected targets.", call. = FALSE)
SITE_BY <- "siteID" %in% names(DT) && uniqueN(DT$siteID, na.rm = TRUE) > 1L
Tn.pga <- min(DT$Tn)
DT <- DT[Tn == Tn.pga, c(if (SITE_BY) "siteID", "TR", "Vs30", "SaF"), with = FALSE]
DT[, TR := prettyNum(TR, big.mark = ",", scientific = FALSE)]

if (exists("MCETable", inherits = FALSE)) {
  MCE <- MCETable[ID == "MCE" & .matchP(p, c("mean", "0.84")) & Vs30 %in% Vs30.target]
  if ("siteID" %in% names(MCE) && exists("siteID.target", inherits = FALSE)) {
    MCE <- MCE[siteID %in% siteID.target]
  }
  if (nrow(MCE)) {
    MCE <- MCE[
      Tn == min(Tn),
      c(if (SITE_BY) "siteID", "p", "Vs30", "SaF"),
      with = FALSE
    ]
    MCE[, TR := fifelse(.matchP(p, "mean"), "MCE", "MCE (84%)")][, p := NULL]
    DT <- rbindlist(list(DT, MCE), use.names = TRUE)
  }
}

KEY <- c(if (SITE_BY) "siteID", "TR", "Vs30")
if (anyDuplicated(DT, by = KEY)) {
  stop("PGA.TR.R: duplicated PGA per TR and Vs30.", call. = FALSE)
}
if (PSA_Units %in% c("cm", "cm/s2", "cm/s**2", "cm/s^2")) DT[, SaF := round(SaF * 980.665, 0)]
if (PSA_Units %in% c("g"))                                DT[, SaF := round(SaF, 3)]

AUX <- dcast(
  DT,
  stats::as.formula(paste(paste(c(if (SITE_BY) "siteID", "TR"), collapse = " + "), "~ Vs30")),
  value.var = "SaF"
)
ORD <- suppressWarnings(as.numeric(gsub(",", "", AUX$TR)))
AUX <- AUX[order(is.na(ORD), ORD, TR)]
VS_COLS <- setdiff(names(AUX), c("siteID", "TR"))
setcolorder(AUX, c(if (SITE_BY) "siteID", "TR", VS_COLS[order(as.numeric(VS_COLS))]))

TBL <- AUX |> buildTable(
  library          = "flextable",
  align.body       = "center",
  font.size.body   = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |> .mathHeader(c(
  TR = "T_R"
)) |> flextable::set_table_properties(layout = "autofit")

rm(DT, AUX, KEY, ORD, VS_COLS, SITE_BY, Tn.pga)
rm(list = intersect("MCE", ls()))
# nolint end
