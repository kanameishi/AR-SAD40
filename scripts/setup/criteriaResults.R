# nolint start
CriteriaSummary <- local({
  AUX <- .currentTarget("siteID.target")
  if (length(AUX)) siteID.target <- AUX
  rm(AUX)
  Standard.target <- c("GISTM", "CDA", "ANCOLD")
  Stage.target <- c("Operation", "Closure", "Post-Closure")
  ID.target <- .resolveIDTarget(
    DEQTable,
    "criteria summary",
    base = TRUE,
    target = .currentTarget("ID.target"),
    siteID = .currentTarget("siteID.target")
  )
  Tn.target <- Tn.PGA
  PSA_Units <- "cm/s2"

  sys.source(
    file.path(root, "scripts", "setup", "criteria.R"),
    envir = environment()
  )

  # Executive banding: one criterion = (Standard, Stage, Class) at the
  # reference rock condition, split into three PGA terciles across all
  # standards (ruling 2026-08-05: three PAR ranges, no per-standard filter).
  Vs30.band <- 760
  ROCK <- unique(DEQ[Vs30 == Vs30.band, .(Standard, Stage, Class, SaF.design)])
  if (nrow(ROCK) < 3L) {
    stop("criteria summary: fewer than three criteria at the reference rock condition.", call. = FALSE)
  }
  setorder(ROCK, SaF.design)
  ROCK[, band := cut(seq_len(.N), breaks = 3L, labels = FALSE)]
  Bands <- ROCK[, .(
    criteria = .N,
    PGA.min = min(SaF.design),
    PGA.max = max(SaF.design)
  ), by = band][order(band)]

  list(
    standards = Standard.target,
    bandsVs30 = Vs30.band,
    bands = Bands
  )
})
# nolint end
