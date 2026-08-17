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
    "circumferentialAreaTotalMm2PerM", "reinforcementRatio",
    "areaToMinimumRatio", "maximumRadialUtilization", "localPMStatus",
    "governingInterfaceID", "governingVerticalStressFactor",
    "governingHorizontalStressFactor", "governingThetaDeg",
    "isConfiguredCase", "isMinimumHistoricalCase", "calculationStatus"
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
  if (nrow(Data) < 3L || nrow(Data) > 6L ||
      any(Data$calculationStatus != "calculated") ||
      sum(Data$isConfiguredCase) != 1L ||
      sum(Data$isMinimumHistoricalCase) != 1L) {
    stop("The reinforcement P-M family is incomplete.", call. = FALSE)
  }
  Role <- vapply(seq_len(nrow(Data)), function(i) {
    if (Data$isConfiguredCase[i] && Data$isMinimumHistoricalCase[i]) {
      "Configurada; mínimo histórico"
    } else if (Data$isConfiguredCase[i]) {
      "Configurada"
    } else if (Data$isMinimumHistoricalCase[i]) {
      "Mínimo histórico"
    } else {
      "Referencia paramétrica"
    }
  }, character(1))
  InterfaceLabels <- c(
    `full-traction` = "1",
    `normal-only` = "0"
  )
  StatusLabels <- c(
    satisfied = "Satisface",
    `not-satisfied` = "No satisface"
  )
  Output <- data.frame(
    Role = Role,
    Area = formatC(
      Data$circumferentialAreaTotalMm2PerM / 100,
      format = "f",
      digits = 2L
    ),
    Ratio = formatC(
      100 * Data$reinforcementRatio,
      format = "f",
      digits = 3L
    ),
    MinimumMultiple = formatC(
      Data$areaToMinimumRatio,
      format = "f",
      digits = 3L
    ),
    Utilization = formatC(
      Data$maximumRadialUtilization,
      format = "f",
      digits = 4L
    ),
    Interface = unname(InterfaceLabels[Data$governingInterfaceID]),
    Combination = paste0(
      format(Data$governingVerticalStressFactor, trim = TRUE),
      "V + ",
      format(Data$governingHorizontalStressFactor, trim = TRUE),
      "H"
    ),
    Theta = formatC(Data$governingThetaDeg, format = "f", digits = 1L),
    Status = unname(StatusLabels[Data$localPMStatus]),
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  if (anyNA(Output)) {
    stop("The reinforcement P-M public mapping is incomplete.", call. = FALSE)
  }
  knitr::kable(
    Output,
    col.names = c(
      "Caso", "$A_{s,\\theta}$ [cm²/m]", "$\\rho_\\theta$ [%]",
      "$\\mu$", "$U_{NM,\\max}$", "$\\alpha$", "Combinación",
      "$\\theta$ [°]", "$S$"
    ),
    align = c("l", "r", "r", "r", "r", "c", "c", "r", "l"),
    escape = FALSE
  )
}
