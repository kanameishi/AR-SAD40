# nolint start
if (!exists("TR.target", inherits = FALSE) || !length(TR.target)) TR.target <- TR.MDE
if (!exists("IDn.target", inherits = FALSE)) IDn.target <- "ensemble"
if (!exists("IDg.target", inherits = FALSE)) IDg.target <- IDg.gmdp
if (!exists("IDm.target", inherits = FALSE)) IDm.target <- IDm.gmdp
if (!exists("Da.target", inherits = FALSE)) Da.target <- Da.gmdp
if (!exists("p.target", inherits = FALSE)) p.target <- c("mean", "0.84")
if (!exists("PSA_Units", inherits = FALSE)) PSA_Units <- "cm/s2"

KMAX <- kmaxTable
siteID.target <- .requireOneTarget(
  .resolveSiteIDTarget(
    KMAX,
    "slope summary",
    target = .currentTarget("siteID.target")
  ),
  "siteID.target",
  "slope summary"
)
KMAX <- KMAX[siteID %in% siteID.target]

if ("IDn" %in% names(KMAX)) {
  if (length(IDn.target) != 1L) stop("slope summary: IDn.target must select one IDn scenario.")
  KMAX <- KMAX[IDn %in% IDn.target]
  if (!nrow(KMAX)) stop(sprintf("slope summary: no kmax rows for IDn.target = %s.", IDn.target))
}

kmax <- KMAX[
  (ID == "MCE" | TR %in% TR.target) &
    IDg %in% IDg.target &
    IDm %in% IDm.target &
    Da %in% Da.target &
    .matchP(p, p.target),
  .(ID, TR, IDg, IDm, Ts, Vs30, Da, p, kmax = .convertKmax(kmax, PSA_Units))
]
ORD <- base::order(kmax$ID == "MCE", kmax$TR, kmax$IDg, kmax$IDm, kmax$Da, kmax$p)
kmax <- kmax[ORD]

Kh <- KMAX[
  (ID == "MCE" | TR %in% TR.target) &
    IDg %in% IDg.target &
    IDm %in% IDm.target &
    Da %in% Da.target &
    .matchP(p, p.target),
  .(ID, TR, IDg, IDm, Ts, Vs30, Da, p, Kh = 100 * Kh)
]
ORD <- base::order(Kh$ID == "MCE", Kh$TR, Kh$IDg, Kh$IDm, Kh$Da, Kh$p)
Kh <- Kh[ORD]

DUP <- kmax[, .N, by = .(ID, TR, IDg, IDm, Da, p)][N != 1L]
if (nrow(DUP)) {
  stop("slope summary: kmax is not unique by ID, TR, IDg, IDm, Da, p.")
}
DUP <- Kh[, .N, by = .(ID, TR, IDg, IDm, Da, p)][N != 1L]
if (nrow(DUP)) {
  stop("slope summary: Kh is not unique by ID, TR, IDg, IDm, Da, p.")
}
rm(list = intersect(c(
  "DUP", "KMAX", "ModelID", "DRAW.FILE", "DRAW.COLS",
  "DRAW.REQUIRED", "BM.ACTIVE", "ENSEMBLE.MODELS", "SUPPORT"
), ls()))
# nolint end
