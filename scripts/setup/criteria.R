# nolint start
if (!exists("Standard.target", inherits = FALSE)) Standard.target <- c("GISTM", "CDA", "ANCOLD")
if (!exists("Stage.target", inherits = FALSE)) Stage.target <- c("Operation", "Closure", "Post-Closure")
if (!exists("ID.target", inherits = FALSE) || !length(ID.target)) {
  ID.target <- .resolveIDTarget(
    DEQTable,
    "criteria summary",
    base = TRUE,
    siteID = .currentTarget("siteID.target")
  )
}
if (!exists("Tn.target", inherits = FALSE)) Tn.target <- Tn.PGA
if (!exists("PSA_Units", inherits = FALSE)) PSA_Units <- "cm/s2"

REQUIRED <- c(
  "ID", "Standard", "Class", "Stage", "Vs30", "p", "Tn", "Bound", "SaF",
  "SaF.design"
)
AUX <- setdiff(REQUIRED, names(DEQTable))
if (length(AUX)) {
  stop("criteria summary: DEQTable is missing column(s): ", paste(AUX, collapse = ", "))
}
DEQ0 <- DEQTable
if ("siteID" %in% names(DEQ0)) {
  if (!exists("siteID.target", inherits = FALSE)) {
    siteID.target <- .resolveSiteIDTarget(DEQ0, "criteria summary")
  }
  if (length(siteID.target) != 1L) stop("criteria summary: set siteID.target to one siteID.")
  DEQ0 <- DEQ0[siteID %in% siteID.target]
}

DEQ <- DEQ0[
  ID == ID.target &
    Standard %in% Standard.target &
    Stage %in% Stage.target &
    Tn == Tn.target &
    p == fifelse(
      Standard == "ANCOLD" & Stage == "Closure" & Class == "Extreme",
      "0.84",
      "mean"
    ),
  .(
    ID, Standard, Stage, Class, Vs30, Bound, p, SaF, SaF.design
  )
][order(Standard, Stage, Class, Bound, Vs30, p)]

DEQ[, PGA.design := .convertKmax(SaF.design, PSA_Units)]

DUP <- DEQ[
  ,
  .(
    N = .N,
    N.bound = uniqueN(Bound),
    Bounds.valid = setequal(Bound, c("lower", "upper")),
    Order.valid = SaF[Bound == "lower"] <= SaF[Bound == "upper"],
    Design.valid =
      uniqueN(SaF.design) == 1L &&
      all(is.finite(SaF.design)) &&
      isTRUE(all.equal(SaF.design[[1L]], mean(SaF)))
  ),
  by = .(ID, Standard, Stage, Class, Vs30, p)
][
  N != 2L | N.bound != 2L | !Bounds.valid | !Order.valid | !Design.valid
]
if (nrow(DUP)) {
  stop("criteria summary: invalid bounds or design value for at least one criterion.")
}
DEQ <- unique(
  DEQ[
    ,
    .(ID, Standard, Stage, Class, Vs30, p, SaF.design, PGA.design)
  ]
)
setorder(DEQ, Standard, Stage, Class, Vs30, p)
rm(DUP, DEQ0, REQUIRED, AUX)
# nolint end
