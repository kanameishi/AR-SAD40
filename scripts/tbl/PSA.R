# nolint start
if (!exists("ID.target") || !length(ID.target)) {
  ID.target <- .resolveIDTarget(
    UHSTable,
    "PSA.R",
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
  c(if (SITE_BY) "siteID", "TR", "Vs30", "SaF", "Tn", "p", "ID"),
  with = FALSE
][, PSA := SaF][, SaF := NULL][order(as.numeric(Vs30))]

if (PSA_Units %in% c("cm", "cm/s2", "cm/s**2", "cm/s^2")) DT[, PSA := round(PSA * 980.665, 0)]
if (PSA_Units %in% c("g"))                                  DT[, PSA := round(PSA, 3)]

DT <- DT[, .(PSA = max(PSA, na.rm = FALSE)), by = c(if (SITE_BY) "siteID", "Tn", "Vs30", "TR", "p")]
AUX <- dcast(
  DT,
  stats::as.formula(paste(paste(c(if (SITE_BY) "siteID", "Tn", "Vs30", "p"), collapse = " + "), "~ TR")),
  value.var = "PSA"
)
setcolorder(AUX, c(if (SITE_BY) "siteID", "Tn", "Vs30", sort(as.numeric(unique(DT$TR))), "p"))

TBL <- AUX |> buildTable(
  library          = "flextable",
  align.body       = "center",
  font.size.body   = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |> .mathHeader(c(
  siteID = "\\mathrm{ID}",
  Tn     = "T_n",
  Vs30   = "V_{S30}",
  p      = "p"
)) |> flextable::set_table_properties(layout = "autofit")

rm(DT, AUX, SITE_BY)
# nolint end
