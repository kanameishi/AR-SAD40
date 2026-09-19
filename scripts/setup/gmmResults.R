# nolint start
GMMSummary <- local({
  sys.source(
    file.path(root, "scripts", "setup", "gmpe.R"),
    envir = environment()
  )
  Epistemic <- data.table::rbindlist(lapply(seq_len(nrow(GMPE.ref)), function(i) {
    Cell <- GMPE.ref[i]
    Branches <- GMPETable[
      TRT == Cell$TRT & model != "ensemble" &
        Mw == Cell$Mw & Repi == Cell$Repi & dep == Cell$dep & Tn == 0 &
        is.finite(Sa) & Sa > 0
    ]
    Median <- Branches[.matchP(p, "0.50"), .(Sa = Sa[[1L]]), by = model]
    Sigma <- merge(
      Branches[.matchP(p, "0.16"), .(lo = Sa[[1L]]), by = model],
      Branches[.matchP(p, "0.84"), .(hi = Sa[[1L]]), by = model],
      by = "model"
    )[, .(model, sigma = log(hi / lo) / 2)]
    if (!nrow(Median) || !nrow(Sigma)) {
      stop(sprintf("gmmResults.R: incomplete branch fractiles for %s.", Cell$TRT), call. = FALSE)
    }
    data.table::data.table(
      TRT = Cell$TRT,
      models = nrow(Median),
      weight = 1 / nrow(Median),
      sigma.min = min(Sigma$sigma),
      sigma.max = max(Sigma$sigma)
    )
  }))
  list(epistemic = Epistemic)
})
# nolint end
