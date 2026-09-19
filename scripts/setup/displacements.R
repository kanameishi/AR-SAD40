# nolint start
DisplacementsSummary <- local({
  SiteID <- .requireOneTarget(
    .resolveSiteIDTarget(
      DnTable,
      "displacements summary",
      target = .currentTarget("siteID.target")
    ),
    "siteID.target",
    "displacements summary"
  )
  siteID.target <- SiteID
  # Reference yield accelerations declared by the executive sentence; the
  # published range per anchor is the envelope of both demand scenarios
  # (ruling 2026-08-07: no MDE/MCE discrimination; two anchors).
  Ky.ref <- c(0.1, 0.2)
  TR.target <- TR.MDE

  DT <- data.table::as.data.table(DnTable)[
    IDn == "ensemble" & as.character(p) == "mean" & (ID == "MCE" | TR %in% TR.target)
  ]
  if ("siteID" %in% names(DT)) DT <- DT[siteID %in% SiteID]
  if (!nrow(DT)) {
    stop("displacements summary: no ensemble mean Dn curves.", call. = FALSE)
  }

  AtRef <- DT[, {
    OK <- is.finite(ky) & is.finite(Dn) & ky > 0 & Dn > 0
    X <- ky[OK]
    Y <- Dn[OK]
    .(ky.ref = Ky.ref, Dn = vapply(Ky.ref, function(k) {
      if (length(X) < 2L || k < min(X) || k > max(X)) {
        NA_real_
      } else {
        exp(approx(log(X), log(Y), xout = log(k), ties = "ordered")$y)
      }
    }, numeric(1L)))
  }, by = .(ID, TR, IDg, IDm)]
  if (anyNA(AtRef$Dn)) {
    stop(sprintf(
      "displacements summary: %d curve(s) do not cover a reference ky.",
      sum(is.na(AtRef$Dn))
    ), call. = FALSE)
  }

  list(
    dn = AtRef[, .(minimum = min(Dn), maximum = max(Dn)), by = .(ky = ky.ref)][order(ky)]
  )
})
# nolint end
