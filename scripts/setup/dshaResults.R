# nolint start
if (!exists("PSA_Units", inherits = FALSE)) PSA_Units <- "g"
DSHASummary <- local({
  AUX <- .currentTarget("siteID.target")
  if (length(AUX)) siteID.target <- AUX
  rm(AUX)
  sys.source(
    file.path(root, "scripts", "setup", "dsha.R"),
    envir = environment()
  )
  if (is.null(DSHA.scn)) {
    stop("dsha summary: MCETable is required for the executive results paragraph.", call. = FALSE)
  }
  list(
    scenarios = DSHA.scn,
    envelope = DSHA.mce,
    probabilisticPGA = DSHA.uhs,
    governorMean = DSHA.gov.mean
  )
})
# nolint end
