# nolint start
if (!exists("PSA_Units", inherits = FALSE)) PSA_Units <- "g"
HazardSummary <- local({
  ID.target <- ID.gmdp
  AUX <- .currentTarget("siteID.target")
  if (length(AUX)) siteID.target <- AUX
  rm(AUX)
  sys.source(
    file.path(root, "scripts", "setup", "hazard.R"),
    envir = environment()
  )

  list(pga = PGA)
})
# nolint end
