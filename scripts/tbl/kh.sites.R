# nolint start
DT <- kmaxTable[
  siteID %in% siteID.target & IDg %in% IDg.target & IDm %in% IDm.target &
    ID == "MCE" & IDn == "ensemble" & .matchP(p, "mean"),
  .(siteID, IDg, Da, Kh)
]
AUX <- unique(ShearTable[IDg %in% IDg.target, .(IDg, Hs)])
DT <- AUX[DT, on = "IDg"]
DT[, DaH := signif(Da / Hs, 3L)]
DT <- DT[DaH %in% signif(DAMAGE.CUTS, 3L),
  .(Kh = paste0(
    .fmt(round(100 * mean(Kh), 1L), 1L), " [",
    .fmt(round(100 * min(Kh), 1L), 1L), "–",
    .fmt(round(100 * max(Kh), 1L), 1L), "]"
  )), by = .(siteID, Hs, DaH)]
DT <- dcast(DT, siteID + Hs ~ DaH, value.var = "Kh")
DT <- DT[order(match(siteID, siteID.target), Hs)]

TBL <- DT |> buildTable(
  library          = "flextable",
  align.body       = "center",
  font.size.body   = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |> .mathHeader(c(Hs = "H_s")) |>
  .damageTable(DAMAGE.CUTS, DAMAGE.COLORS) |>
  flextable::set_table_properties(layout = "autofit")

rm(DT, AUX)
# nolint end
