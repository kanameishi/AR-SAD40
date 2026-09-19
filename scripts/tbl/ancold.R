# nolint start
TBL <- AncoldTable |> buildTable(
    library = "flextable",
    align.body = "center",
    font.size.body = FONT.SIZE.BODY,
    font.size.header = FONT.SIZE.HEADER
)  |> flextable::set_table_properties(layout = "autofit") |>
  flextable::align(align = "left", part = "all")   # left–justify everything
# nolint end
