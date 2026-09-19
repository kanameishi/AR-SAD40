# nolint start
if (!exists("ID.target") || !length(ID.target)) {
  ID.target <- .resolveIDTarget(
    UHSTable,
    "AF.R",
    base = TRUE,
    siteID = .currentTarget("siteID.target")
  )
}

DT <- UHSTable[
  Tn %in% Tn.target & .matchP(p, p.target) &
  ID %in% ID.target & Vs30 %in% Vs30.target & TR %in% TR.target,
]
if ("siteID" %in% names(DT) && exists("siteID.target", inherits = FALSE)) {
  DT <- DT[siteID %in% siteID.target]
}
SITE_BY <- "siteID" %in% names(DT) && uniqueN(DT$siteID, na.rm = TRUE) > 1L
DT <- DT[
  ,
  c(if (SITE_BY) "siteID", "TR", "Vs30", "AF", "Tn", "p"),
  with = FALSE
][order(as.numeric(Vs30))]

DT[, AF := round(AF, 2)]

DT <- DT[, .(AF = max(AF, na.rm = FALSE)), by = c(if (SITE_BY) "siteID", "Tn", "Vs30", "TR", "p")]
TR.COLS <- sort(as.numeric(unique(DT$TR)))
DT[, TR := as.character(TR)]

# The MCE envelope carries no TR: it enters as one additional column when
# the project has deterministic products.
if (exists("MCETable", inherits = TRUE) && !is.null(MCETable) && nrow(MCETable)) {
  MCE <- MCETable[
    ID == "MCE" & Tn %in% Tn.target & .matchP(p, p.target) & Vs30 %in% Vs30.target
  ]
  if ("siteID" %in% names(MCE) && exists("siteID.target", inherits = FALSE)) {
    MCE <- MCE[siteID %in% siteID.target]
  }
  if (nrow(MCE)) {
    MCE <- MCE[
      ,
      c(if (SITE_BY) "siteID", "Tn", "Vs30", "AF", "p"),
      with = FALSE
    ][, .(AF = round(max(AF, na.rm = FALSE), 2), TR = "MCE"),
      by = c(if (SITE_BY) "siteID", "Tn", "Vs30", "p")]
    DT <- rbindlist(list(DT, MCE), use.names = TRUE)
    TR.COLS <- c(TR.COLS, "MCE")
  }
}

AUX <- dcast(
  DT,
  stats::as.formula(paste(paste(c(if (SITE_BY) "siteID", "Tn", "Vs30", "p"), collapse = " + "), "~ TR")),
  value.var = "AF"
)
setcolorder(AUX, c(if (SITE_BY) "siteID", "Tn", "Vs30", TR.COLS, "p"))

SYMBOLS <- c(Tn = "T_n", Vs30 = "V_{S30}", p = "p")
SYMBOLS <- SYMBOLS[names(SYMBOLS) %in% names(AUX)]

TBL <- AUX |> buildTable(
  library          = "flextable",
  align.body       = "center",
  font.size.body   = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |> .mathHeader(SYMBOLS) |> flextable::set_table_properties(layout = "autofit")

rm(list = intersect(c("DT", "AUX", "SITE_BY", "SYMBOLS", "TR.COLS", "MCE"), ls()))
# nolint end
