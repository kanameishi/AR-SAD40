DT <- ShearTable[
  IDg %in% IDg.target & .matchP(level, p.target),
  .(IDm, USCS, IDg, Hs, b, s, lo, mo, a1 = an, Go, VSo, Ts)
] |> unique()


TBL <- DT |> buildTable(
    library = "flextable",
    align.body = "center",
    font.size.body = FONT.SIZE.BODY,
    font.size.header = FONT.SIZE.HEADER
) |> .mathHeader(c(
  Hs = "H_s",
  b = "b",
  s = "s",
  lo = "\\lambda_o",
  mo = "m_o",
  a1 = "a_1",
  Go = "G_o",
  VSo = "V_S^o",
  Ts = "T_s"
)) |> flextable::set_table_properties(layout = "autofit")
rm(DT)
