# nolint start
DynamicsSummary <- local({
  IDgSel <- .cleanTarget(.currentTarget("IDg.target"))
  if (!length(IDgSel)) IDgSel <- .cleanTarget(IDg.gmdp)

  LevelSel <- .cleanTarget(.currentTarget("level.target"))
  if (!length(LevelSel)) LevelSel <- "mean"

  Periods <- .slopePeriods(
    ShearTable,
    idg = IDgSel,
    level = LevelSel,
    context = "dynamics summary"
  )

  Materials <- data.table::as.data.table(ShearTable)[
    IDg %in% IDgSel & level %in% LevelSel,
    .(
      Go.min = min(Go, na.rm = TRUE),
      Go.max = max(Go, na.rm = TRUE),
      VSo.min = min(VSo, na.rm = TRUE),
      VSo.max = max(VSo, na.rm = TRUE)
    ),
    by = IDm
  ][order(IDm)]
  if (!nrow(Materials)) {
    stop("dynamics summary: no material rows for the IDg and level targets.", call. = FALSE)
  }

  list(periods = Periods, materials = Materials)
})
# nolint end
