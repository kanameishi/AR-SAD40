# nolint start
ClassificationSummary <- local({
  Vs30 <- sort(unique(as.numeric(Vs30.gmdp)))
  Vs30 <- Vs30[is.finite(Vs30)]
  list(
    count = length(Vs30),
    minimum = min(Vs30),
    maximum = max(Vs30)
  )
})
# nolint end
