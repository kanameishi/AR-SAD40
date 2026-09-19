# nolint start
# One deterministic-hazard spectrum table at reference rock: rows Tn,
# columns = p fractiles. The surrounding tab identifies the fixed scenario.
if (!exists("p.target") || !length(p.target)) {
  p.target <- c("0.50", "0.84", "0.90", "0.95", "mean")
}
if (!exists("Tn.target") || !length(Tn.target)) Tn.target <- sort(unique(MCETable$Tn))
if (!exists("ID.target") || length(ID.target) != 1L) {
  stop("MCE.PSA.R: set ID.target to one scenario or MCE.", call. = FALSE)
}

DT <- MCETable[
  ID %in% ID.target & Vs30 == 760 & Tn %in% Tn.target & .matchP(p, p.target)
]
if ("siteID" %in% names(DT) && exists("siteID.target", inherits = FALSE)) {
  DT <- DT[siteID %in% siteID.target]
}
if (!nrow(DT)) stop("MCE.PSA.R: no rock rows for the selected scenario.", call. = FALSE)
DT <- DT[, .(Tn, p, PSA = SaF)]
if (PSA_Units %in% c("cm", "cm/s2", "cm/s**2", "cm/s^2")) DT[, PSA := round(PSA * 980.665, 0)]
if (PSA_Units %in% c("g"))                                DT[, PSA := round(PSA, 3)]

AUX <- dcast(DT, Tn ~ p, value.var = "PSA")
P_COLS <- c("0.05", "0.16", "0.50", "0.84", "0.90", "0.95", "mean")
setcolorder(AUX, c("Tn", intersect(P_COLS, names(AUX))))

# Only the identifying column carries a symbol: the remaining headers are the
# probability labels of the reported statistic and stay as the data provides
# them; the caption states what they are and in which unit.
TBL <- AUX |> buildTable(
  library          = "flextable",
  align.body       = "center",
  font.size.body   = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |> .mathHeader(c(Tn = "T_n")) |> flextable::set_table_properties(layout = "autofit")

rm(DT, AUX, P_COLS)
# nolint end
