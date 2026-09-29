Epistemic uncertainty is represented through the logic trees of the regional source model and of the GMMs. Each branch specifies an alternative characterization with a non-negative weight, and the weights of each set sum to one. OpenQuake evaluates the hazard integral for the tree realizations and forms the requested statistics by weighting the resulting curves [@OpenQuakeManual2024]. The recurrence, geometry, and maximum-magnitude parameters of each source enter the integral through the magnitude and distance densities. The GMM trees represent the active tectonic regimes separately and weight their prediction models; record-to-record aleatory variability remains in the standard deviation of each GMM.

```{r}
#| echo: false
#| results: asis
SOURCE.BRANCH <- if (is.finite(Hazard.config$ssmBranches) && Hazard.config$ssmBranches > 1L) {
  sprintf(", whose logic tree comprises %s branches", Hazard.config$ssmBranches)
} else {
  ""
}
GMM.COUNTS <- GMM.active[, sprintf(
  "**%s** (%s branches)",
  TRT,
  lengths(models)
)]
OUTPUT.STAT <- if (length(Hazard.config$rockQuantiles)) {
  sprintf(
    "the mean and the %s quantiles",
    paste(Hazard.config$rockQuantiles, collapse = ", ")
  )
} else if (isTRUE(Hazard.config$rockMean)) {
  "the mean curve"
} else {
  "the statistics requested by the configuration"
}
MODEL.LABEL <- if (!is.na(Hazard.config$ssmLabel) && nzchar(Hazard.config$ssmLabel)) {
  sprintf("the assessment adopted the **%s** model%s", Hazard.config$ssmLabel, SOURCE.BRANCH)
} else {
  "the assessment adopted the regional source model"
}
cat(sprintf(
  paste0(
    "In this assessment, %s; the GMM trees ",
    "comprise %s. The probabilistic output at reference rock ",
    "($V_{S30}=760$ m/s) reports %s.\n"
  ),
  MODEL.LABEL,
  paste(GMM.COUNTS, collapse = ", "),
  OUTPUT.STAT
))
rm(SOURCE.BRANCH, GMM.COUNTS, OUTPUT.STAT, MODEL.LABEL)
```
