# nolint start
if (length(uscs) != length(ZONE)) {
  stop(
    "IDm.R: the TSF-zone legend has ", length(ZONE),
    " entries but data.R declares ", length(uscs), " material scenarios."
  )
}

DT <- data.table(
  IDm = names(uscs),
  USCS = vapply(uscs, paste, character(1), collapse = " "),
  Zone = ZONE
)
setnames(DT, "Zone", HEADER)

TBL <- DT |> buildTable(
  library          = "flextable",
  font.size.body   = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |> flextable::set_table_properties(layout = "autofit")

rm(DT)
# nolint end
