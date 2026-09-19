# nolint start
# Site comparison of the design spectrum: Sa(Tn) ordinates, one column per
# site, at one return period, one site condition and one statistic.
# Expects: ID.target, TR.target, Vs30.target, p.target (one value each),
# Tn.target, siteID.target, PSA_Units
if (length(TR.target) != 1L || length(Vs30.target) != 1L || length(p.target) != 1L) {
  stop("PSA.sites.R: TR.target, Vs30.target and p.target must be one value each.", call. = FALSE)
}
DT <- UHSTable[
  Tn %in% Tn.target & .matchP(p, p.target) & ID %in% ID.target &
    siteID %in% siteID.target & Vs30 %in% Vs30.target & TR %in% TR.target,
  .(siteID, Tn, PSA = SaF)
]
if (!nrow(DT)) stop("PSA.sites.R: no rows for the selected targets.", call. = FALSE)
if (anyDuplicated(DT, by = c("siteID", "Tn"))) {
  stop("PSA.sites.R: duplicated ordinate per site and Tn.", call. = FALSE)
}
if (PSA_Units %in% c("cm", "cm/s2", "cm/s**2", "cm/s^2")) DT[, PSA := round(PSA * 980.665, 0)]
if (PSA_Units %in% c("g"))                                  DT[, PSA := round(PSA, 3)]

AUX <- dcast(DT, Tn ~ siteID, value.var = "PSA")[order(Tn)]
setcolorder(AUX, c("Tn", intersect(siteID.target, names(AUX))))

TBL <- AUX |> buildTable(
  library          = "flextable",
  align.body       = "center",
  font.size.body   = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |> .mathHeader(c(
  Tn = "T_n"
)) |> flextable::set_table_properties(layout = "autofit")

rm(DT, AUX)
# nolint end
