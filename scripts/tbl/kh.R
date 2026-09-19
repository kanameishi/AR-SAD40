# nolint start

KT <- kmaxTable
if ("siteID" %in% names(KT)) {
  if (!exists("siteID.target", inherits = FALSE) && uniqueN(KT$siteID, na.rm = TRUE) > 1L) {
    stop("kh.R: set siteID.target to one siteID before building a table without siteID columns.")
  }
}
if ("siteID" %in% names(KT) && exists("siteID.target", inherits = FALSE)) {
  if (length(unique(siteID.target)) != 1L) stop("kh.R: siteID.target must select one siteID.")
  KT <- KT[siteID %in% siteID.target]
}
if (length(unique(IDm.target)) != 1L) {
  stop("kh.R: IDm.target must select one material model. Call the table once per material.")
}
IDg.target <- .requireOneTarget(IDg.target, "IDg.target", "kh table")
if (length(unique(as.character(p.target))) != 1L) {
  stop("kh.R: p.target must select one probability level.")
}
KT <- KT[
  IDn %in% IDn.target &
    IDm %in% IDm.target &
    Da %in% Da.target &
    IDg %in% IDg.target &
    (ID == "MCE" | TR %in% TR.target)
][.matchP(p, p.target)]

DT <- KT[, .(ID = .demandLabel(ID, TR), TR, IDn, IDg, Ts, Vs30, Da, Kh = 100 * Kh)]

GEO <- ShearTable[
  IDg %in% IDg.target,
  .(Hs = unique(Hs)[1]),
  by = IDg
]
DT <- GEO[DT, on = "IDg"]

# Da in cm over Hs in m equals Da/H expressed in percent; signif() keeps the
# column headers readable without moving the values.
DT[, DaH := signif(Da / Hs, 3L)]
# The table reports the damage thresholds only; oqt computes whatever grid the
# project declares, and that grid must contain the thresholds.
LEVELS <- signif(DAMAGE.CUTS, 3L)
DT <- DT[DaH %in% LEVELS]
MISSING <- setdiff(LEVELS, unique(DT$DaH))
if (length(MISSING)) {
  stop(sprintf(
    "kh.R: no Da/H level %s for IDg=%s IDm=%s. Declare it in DaH.gmdp and re-run oqt --process --steps dn,kmax.",
    paste(MISSING, collapse = ", "), IDg.target, IDm.target
  ))
}
DUP <- DT[, .N, by = .(ID, IDn, DaH)][N > 1L]
if (nrow(DUP)) {
  stop("kh.R: more than one coefficient found for at least one hazard/Newmark-scenario/Da-H cell.")
}

DT[, Kh := round(Kh, 1)]

AUX <- data.table::dcast(
  DT,
  ID + TR + IDn + Ts + Vs30 ~ DaH,
  value.var = "Kh"
)
AUX <- AUX[base::order(ID == "MCE", TR, IDn)]
AUX[, TR := NULL]

TBL <- AUX |>
  buildTable(
    library          = "flextable",
    align.body       = "center",
    font.size.body   = FONT.SIZE.BODY,
    font.size.header = FONT.SIZE.HEADER
  ) |>
  .mathHeader(c(
    Ts   = "T_s",
    Vs30 = "V_{S30}"
  )) |>
  .damageTable(DAMAGE.CUTS, DAMAGE.COLORS) |>
  flextable::set_table_properties(layout = "autofit")
rm(list = intersect(c(
  "KT", "DT", "GEO", "AUX", "DUP", "LEVELS", "MISSING"
), ls()))
# nolint end
