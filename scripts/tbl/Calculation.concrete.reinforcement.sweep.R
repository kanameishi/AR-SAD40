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
    "maximumRadialUtilization", "localPMStatus",
    "maximumShearUtilization", "shearStatus",
    "radialTensionUtilization", "radialTensionStatus",
    "overallLocalStatus",
    "governingInterfaceID", "governingVerticalStressFactor",
    "governingHorizontalStressFactor", "governingThetaDeg",
    "isLowerReferenceCase", "isParametricCase", "calculationStatus"
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
      sum(Data$isLowerReferenceCase) != 1L ||
      sum(!Data$isParametricCase) > 1L) {
    stop("The reinforcement P-M family is incomplete.", call. = FALSE)
  }
  Role <- vapply(seq_len(nrow(Data)), function(i) {
    if (!Data$isParametricCase[i]) {
      "Chapa existente + Ø8/150 interior"
    } else if (Data$isLowerReferenceCase[i]) {
      "Cuantía mínima de referencia"
    } else {
      "Cuantía evaluada"
    }
  }, character(1))
  InterfaceLabels <- c(
    `full-slip` = "Deslizamiento libre",
    `no-slip` = "Sin deslizamiento"
  )
  StatusLabels <- c(
    satisfied = "Dentro del dominio",
    `not-satisfied` = "Excede el dominio"
  )
  CheckStatusLabels <- c(
    satisfied = "Satisface",
    `not-satisfied` = "No satisface"
  )
  Output <- data.frame(
    Role = Role,
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
    Status = unname(StatusLabels[Data$localPMStatus]),
    Shear = formatC(
      Data$maximumShearUtilization,
      format = "f",
      digits = 2L
    ),
    ShearStatus = unname(CheckStatusLabels[Data$shearStatus]),
    Radial = formatC(
      Data$radialTensionUtilization,
      format = "f",
      digits = 2L
    ),
    RadialStatus = unname(CheckStatusLabels[Data$radialTensionStatus]),
    Overall = unname(CheckStatusLabels[Data$overallLocalStatus]),
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  if (anyNA(Output)) {
    stop("The reinforcement P-M public mapping is incomplete.", call. = FALSE)
  }
  knitr::kable(
    Output,
    col.names = c(
      "Caso", "Área circunferencial total [cm²/m]", "Cuantía [%]",
      "U P–M", "P–M", "U corte", "Corte", "U tracción radial",
      "Tracción radial", "Resultado local"
    ),
    align = c("l", "r", "r", "r", "l", "r", "l", "r", "l", "l"),
    escape = FALSE
  )
}
