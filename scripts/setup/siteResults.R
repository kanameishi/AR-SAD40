# nolint start
if (!exists("PSA_Units", inherits = FALSE)) PSA_Units <- "g"
SiteSummary <- local({
  AUX <- .currentTarget("siteID.target")
  if (length(AUX)) siteID.target <- AUX
  rm(AUX)
  sys.source(
    file.path(root, "scripts", "setup", "site.R"),
    envir = environment()
  )

  # The executive paragraph publishes the design-demand PGA across the site
  # conditions at the MDE return period; the per-TR ranges and spectral peaks
  # remain chapter-level products of site.R.
  if (!TR.MDE %in% SITE_TR) {
    stop("site summary: the MDE return period (10,000 years) is not available.", call. = FALSE)
  }
  PGA.MDE <- SITE_MAX[
    abs(Tn - SITE_TN_PGA) <= 1e-12 & TR == TR.MDE, .(Vs30, SaF)
  ][order(Vs30)]
  if (!nrow(PGA.MDE)) {
    stop("site summary: no mean PGA rows at the MDE return period.", call. = FALSE)
  }

  list(
    scope = SITE_SCOPE,
    siteConditions = SITE_VS30,
    returnPeriods = SITE_TR,
    returnPeriodMDE = TR.MDE,
    pgaMDE = PGA.MDE
  )
})
# nolint end
