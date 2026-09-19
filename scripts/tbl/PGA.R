# nolint start
# Expects: ID.target, Vs30.target (scalar), TR.target, PSA_Units

P_COLS <- c("0.50", "mean", "0.84", "0.90", "0.95")
ITo    <- unique(AEPTable$ITo)[1]

DT <- UHSTable[
  .matchP(p, P_COLS) & ID %in% ID.target &
  Vs30 %in% Vs30.target & TR %in% TR.target
]
if ("siteID" %in% names(DT) && exists("siteID.target", inherits = FALSE)) {
  DT <- DT[siteID %in% siteID.target]
}
SITE_BY <- "siteID" %in% names(DT) && uniqueN(DT$siteID, na.rm = TRUE) > 1L
Tn.pga <- min(DT$Tn)
DT <- DT[
  Tn == Tn.pga,
  c(if (SITE_BY) "siteID", "TR", "SaF", "p", "ID"),
  with = FALSE
][, PGA := SaF][, SaF := NULL][order(as.numeric(TR))]

if (PSA_Units %in% c("cm", "cm/s2", "cm/s**2", "cm/s^2")) DT[, PGA := round(PGA * 980.665, 0)]
if (PSA_Units %in% c("g"))                                  DT[, PGA := round(PGA, 3)]

DT <- DT[, .(PGA = max(PGA, na.rm = FALSE)), by = c(if (SITE_BY) "siteID", "TR", "p")]
AUX <- dcast(
  DT,
  stats::as.formula(paste(paste(c(if (SITE_BY) "siteID", "TR"), collapse = " + "), "~ p")),
  value.var = "PGA",
  fun.aggregate = mean
)

P_PRESENT <- intersect(P_COLS, names(AUX))
POE <- 100 * (1 - exp(-ITo / as.numeric(AUX$TR)))
AUX[, "PoE" := data.table::fifelse(
  POE > 0 & POE < 0.1,
  "<0.1",
  .formatNumber(POE, 1)
)]
setcolorder(AUX, c("TR", "PoE", P_PRESENT))

TBL <- AUX |> buildTable(
  library          = "flextable",
  align.body       = "center",
  font.size.body   = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |> .mathHeader(c(
  TR  = "T_R",
  PoE = "P_T"
)) |> flextable::set_table_properties(layout = "autofit")

if ("mean" %in% names(AUX)) {
  TBL <- flextable::bold(TBL, j = "mean", part = "body")
  TBL <- flextable::bold(TBL, j = "mean", part = "header")
}

rm(DT, AUX, P_COLS, P_PRESENT, POE, ITo, SITE_BY, Tn.pga)
# nolint end
