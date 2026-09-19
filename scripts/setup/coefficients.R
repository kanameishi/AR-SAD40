# nolint start
CoefficientsSummary <- local({
  SiteID <- .requireOneTarget(
    .resolveSiteIDTarget(
      kmaxTable,
      "coefficients summary",
      target = .currentTarget("siteID.target")
    ),
    "siteID.target",
    "coefficients summary"
  )
  siteID.target <- SiteID
  TR.target <- TR.MDE
  IDn.target <- "ensemble"
  IDg.target <- IDg.gmdp
  IDm.target <- IDm.gmdp
  level.target <- "mean"
  Da.target <- sort(unique(Da.gmdp))
  p.target <- "mean"
  PSA_Units <- "g"

  sys.source(
    file.path(root, "scripts", "setup", "slope.R"),
    envir = environment()
  )

  # Three performance regimes anchored on the owner's kh targets (rulings
  # 2026-08-07): near the PGA (low allowable displacement), the 50-66%
  # band, and the 25-35% band. The Da of each regime is selected from the
  # product grid by the median kh pooled over BOTH demand scenarios, and
  # each regime reports the envelope of MDE and MCE (no discrimination).
  KhMedian <- Kh[, .(kh.median = stats::median(Kh)), by = Da]
  Regimes <- rbindlist(list(
    KhMedian[which.min(abs(kh.median - 100)), .(Da, regime = "low")],
    KhMedian[which.min(abs(kh.median - 58)), .(Da, regime = "mid")],
    KhMedian[which.min(abs(kh.median - 30)), .(Da, regime = "high")]
  ))
  Regimes <- merge(
    Regimes,
    kmax[, .(kmax.min = min(kmax), kmax.max = max(kmax)), by = Da],
    by = "Da"
  )
  Regimes <- merge(
    Regimes,
    Kh[, .(kh.min = min(Kh), kh.max = max(Kh)), by = Da],
    by = "Da"
  )
  Regimes <- Regimes[base::order(match(Regimes$regime, c("low", "mid", "high")))]
  # Da in cm over Hs in m equals Da/H expressed in percent.
  GEO <- ShearTable[IDg %in% IDg.gmdp, .(Hs = unique(Hs)[1L]), by = IDg]
  Regimes[, DaH.min := Da / max(GEO$Hs)]
  Regimes[, DaH.max := Da / min(GEO$Hs)]

  list(
    siteID = SiteID,
    geometryCount = uniqueN(kmax$IDg),
    materialCount = uniqueN(kmax$IDm),
    regimes = Regimes
  )
})
# nolint end
