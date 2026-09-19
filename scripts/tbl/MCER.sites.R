# nolint start
DT <- ASCETable[
  ID %in% ID.target & siteID %in% siteID.target & Vs30 %in% Vs30.target &
    Spectrum == "mcer" & Tn == min(Tn) & .matchP(p, "mean"),
  .(siteID, Vs30, PGA.MCER = SaF, SMS, SM1, SDS, SD1,
    T0 = round(0.2 * SD1 / SDS, 3L), TS = round(SD1 / SDS, 3L))
][order(match(siteID, siteID.target), Vs30)]
COLS <- c("PGA.MCER", "SMS", "SM1", "SDS", "SD1")
DT[, (COLS) := lapply(.SD, .convertKmax, units = PSA_Units), .SDcols = COLS]

TBL <- DT |> buildTable(
  library          = "flextable",
  align.body       = "center",
  font.size.body   = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |> .mathHeader(c(
  Vs30 = "V_{S30}", PGA.MCER = "S_{aM}(0)",
  SMS = "S_{MS}", SM1 = "S_{M1}", SDS = "S_{DS}", SD1 = "S_{D1}",
  T0 = "T_0", TS = "T_S"
)) |> flextable::set_table_properties(layout = "autofit")

rm(DT, COLS)
# nolint end
