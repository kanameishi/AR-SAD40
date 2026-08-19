if (!exists("buildReportTable", mode = "function", inherits = TRUE)) {
  source(file.path("scripts", "tbl", "table.R"), local = TRUE)
}

buildCalculationConcreteReinforcementSweepTable <- function(path, liningID) {
  if (!file.exists(path)) {
    stop("The reinforcement P-M family product is not available.",
      call. = FALSE
    )
  }
  if (!is.character(liningID) || length(liningID) != 1L ||
      is.na(liningID) || !nzchar(liningID)) {
    stop("liningID must identify one concrete alternative.", call. = FALSE)
  }
  Data <- utils::read.csv(
    path,
    check.names = FALSE,
    stringsAsFactors = FALSE,
    na.strings = ""
  )
  Required <- c(
    "liningID", "reinforcementCaseOrder",
    "barDiameterMm", "barSpacingMm", "reinforcementArrangementID",
    "circumferentialAreaTotalMm2PerM", "reinforcementRatio",
    "maximumRadialUtilization", "localPMStatus",
    "maximumShearUtilization", "shearStatus",
    "radialTensionUtilization", "radialTensionStatus",
    "governingInterfaceID", "governingVerticalStressFactor",
    "governingHorizontalStressFactor", "governingThetaDeg",
    "isParametricCase", "calculationStatus"
  )
  if (length(setdiff(Required, names(Data))) > 0L) {
    stop("The reinforcement P-M family has an invalid schema.", call. = FALSE)
  }
  Data <- Data[
    Data[["liningID", exact = TRUE]] == liningID,
    ,
    drop = FALSE
  ]
  Data <- Data[order(Data$reinforcementCaseOrder), , drop = FALSE]
  if (nrow(Data) != 4L ||
      any(Data$calculationStatus != "calculated") ||
      sum(Data$isParametricCase) != 3L ||
      sum(!Data$isParametricCase) != 1L ||
      any(Data$reinforcementArrangementID[Data$isParametricCase] !=
        "symmetric-two-face") ||
      any(Data$reinforcementArrangementID[!Data$isParametricCase] !=
        "existing-sheet-plus-interior-mesh")) {
    stop("The reinforcement P-M family is incomplete.", call. = FALSE)
  }
  ConfigurationID <- ifelse(
    Data$isParametricCase,
    paste0("S", trimws(formatC(Data$barDiameterMm, format = "fg", digits = 6L))),
    paste0("A", trimws(formatC(Data$barDiameterMm, format = "fg", digits = 6L)))
  )
  StatusCodes <- c(
    satisfied = "OK",
    `not-satisfied` = "FAIL"
  )
  OverallStatus <- ifelse(
    Data$localPMStatus == "satisfied" & Data$shearStatus == "satisfied",
    "OK",
    "FAIL"
  )
  Output <- data.frame(
    ConfigurationID = ConfigurationID,
    Mesh = paste0(
      trimws(formatC(Data$barDiameterMm, format = "fg", digits = 6L)),
      "/",
      trimws(formatC(Data$barSpacingMm, format = "fg", digits = 6L))
    ),
    Area = formatC(
      Data$circumferentialAreaTotalMm2PerM / 100,
      format = "f",
      digits = 1L
    ),
    Ratio = formatC(
      100 * Data$reinforcementRatio,
      format = "f",
      digits = 2L
    ),
    Utilization = formatC(
      Data$maximumRadialUtilization,
      format = "f",
      digits = 2L
    ),
    Status = unname(StatusCodes[Data$localPMStatus]),
    Shear = formatC(
      Data$maximumShearUtilization,
      format = "f",
      digits = 2L
    ),
    ShearStatus = unname(StatusCodes[Data$shearStatus]),
    Radial = formatC(
      Data$radialTensionUtilization,
      format = "f",
      digits = 2L
    ),
    RadialStatus = unname(StatusCodes[Data$radialTensionStatus]),
    OverallStatus = OverallStatus,
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  if (anyNA(Output)) {
    stop("The reinforcement P-M public mapping is incomplete.", call. = FALSE)
  }
  buildReportTable(
    data = Output,
    headers = c(
      "$ID$", "$\\phi/s$", "$A_{s,\\theta}$ [cm²/m]", "$\\rho_\\theta$ [%]",
      "$U_{PM,\\max}$", "$E_{PM}$", "$U_{V,\\max}$", "$E_V$",
      "$U_{r,\\max}^{*}$", "$E_r^{*}$", "$E$"
    ),
    align = c(
      "c", "c", "r", "r", "r", "c", "r", "c", "r", "c", "c"
    )
  )
}
