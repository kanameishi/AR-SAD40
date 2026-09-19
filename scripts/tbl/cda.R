# nolint start
TBL <- CdaTable |> buildTable(
    library = "flextable",
    align.body = "center",
    font.size.body = FONT.SIZE.BODY,
    font.size.header = FONT.SIZE.HEADER
) |>
  flextable::set_table_properties(layout = "autofit") |>
  flextable::align(align = "left", part = "all") |>
  flextable::footnote(
    i = 1, j = 3L, part = "header",
    value = flextable::as_paragraph(CdaNotes[[1L]]),
    ref_symbols = "*"
  ) |>
  flextable::footnote(
    i = 1, j = 4L, part = "header",
    value = flextable::as_paragraph(CdaNotes[[2L]], CdaNotes[[3L]]),
    ref_symbols = "†"
  ) |>
  flextable::footnote(
    i = 1, j = 5L, part = "header",
    value = flextable::as_paragraph(CdaNotes[[4L]], CdaNotes[[5L]]),
    ref_symbols = "‡"
  )
# nolint end
