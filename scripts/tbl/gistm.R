# nolint start
TBL <- GistmTable |> buildTable(
    library = "flextable",
    align.body = "center",
    font.size.body = FONT.SIZE.BODY,
    font.size.header = FONT.SIZE.HEADER
) |>
  flextable::set_table_properties(layout = "autofit") |>
  flextable::align(align = "left", part = "all") |>
  flextable::footnote(
    i = 1, j = 2L, part = "header",
    value = flextable::as_paragraph(GistmNotes[[1L]]),
    ref_symbols = "*"
  ) |>
  flextable::footnote(
    i = 1, j = 4L, part = "header",
    value = flextable::as_paragraph(GistmNotes[[2L]]),
    ref_symbols = "†"
  ) |>
  flextable::footnote(
    i = 1, j = 5L, part = "header",
    value = flextable::as_paragraph(GistmNotes[[3L]]),
    ref_symbols = "‡"
  )
# nolint end
