# nolint start
# Deterministic-hazard PGA summary at reference rock: one row per scenario
# plus the canonical MCE envelope, with Tn = 0 and p fractile columns.
if (!exists("p.target") || !length(p.target)) {
  p.target <- c("0.50", "0.84", "0.90", "0.95", "mean")
}
if (!exists("ID.target") || !length(ID.target)) {
  stop("MCE.PGA.R: set ID.target to scenario base IDs.", call. = FALSE)
}

DT <- MCETable[ID %in% ID.target & Vs30 == 760 & .matchP(p, p.target)]
if ("siteID" %in% names(DT) && exists("siteID.target", inherits = FALSE)) {
  DT <- DT[siteID %in% siteID.target]
}
if (!nrow(DT)) stop("MCE.PGA.R: no rock rows for the selected scenario.", call. = FALSE)
DT <- DT[Tn == 0, .(ID, Tn, p, PGA = SaF)]
if (!nrow(DT)) stop("MCE.PGA.R: no Tn = 0 rows for the selected scenario.", call. = FALSE)
if (PSA_Units %in% c("cm", "cm/s2", "cm/s**2", "cm/s^2")) DT[, PGA := round(PGA * 980.665, 0)]
if (PSA_Units %in% c("g"))                                DT[, PGA := round(PGA, 3)]

AUX <- dcast(DT, ID + Tn ~ p, value.var = "PGA")
AUX[, IDX := match(ID, ID.target)]
setorder(AUX, IDX)
AUX[, IDX := NULL]
P_COLS <- intersect(c("0.05", "0.16", "0.50", "0.84", "0.90", "0.95", "mean"), names(AUX))
setcolorder(AUX, c("ID", "Tn", P_COLS))

TBL <- AUX |> buildTable(
  library          = "flextable",
  align.body       = "center",
  font.size.body   = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |> .mathHeader(c(
  ID = "e",
  Tn = "T_n"
)) |> flextable::set_table_properties(layout = "autofit")
if ("mean" %in% names(AUX)) TBL <- flextable::bold(TBL, j = "mean", part = "header")

rm(DT, AUX, P_COLS)
# nolint end
