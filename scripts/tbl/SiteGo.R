# nolint start
DT <- data.table::copy(newmark::ShearModelParameters)[
  , .(
    ModelID,
    GroupID,
    Material = NameID,
    Author = AuthorID,
    A,
    Ce,
    n
  )
]

GroupOrder <- c("Sands", "Fines", "Gravels")
DT[, GroupOrder := match(GroupID, GroupOrder)]
if (anyNA(DT$GroupOrder)) {
  stop("Unexpected soil family in newmark::ShearModelParameters.", call. = FALSE)
}
data.table::setorder(DT, GroupOrder, ModelID)
DT[, GroupOrder := NULL]
DT[, GroupID := unname(SiteGo.groups[GroupID])]

data.table::setnames(
  DT,
  old = c("ModelID", "GroupID", "Material", "Author"),
  new = SiteGo.headers
)

TBL <- DT |>
  buildTable(
    library = "flextable",
    font.size.body = FONT.SIZE.BODY,
    font.size.header = FONT.SIZE.HEADER
  ) |>
  .mathHeader(c(Ce = "C_e"))
TBL <- flextable::set_table_properties(TBL, layout = "autofit")
rm(DT, GroupOrder)
# nolint end
