# nolint start
TBL <- NBC2020Table |> buildTable(library="flextable",font.size.body = FONT.SIZE.BODY,font.size.header = FONT.SIZE.HEADER)
TBL <- flextable::set_table_properties(TBL,layout = "autofit")

# nolint end
