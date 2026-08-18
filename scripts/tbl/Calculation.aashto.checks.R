buildCalculationAashtoChecksTable <- function(path) {
  if (!file.exists(path)) {
    stop("The AASHTO-check product is not available.", call. = FALSE)
  }
  Data <- utils::read.csv(
    path,
    check.names = FALSE,
    stringsAsFactors = FALSE,
    na.strings = ""
  )
  Required <- c(
    "checkID", "observedValue", "limitValue", "unit", "utilization",
    "checkStatus"
  )
  Missing <- setdiff(Required, names(Data))
  if (length(Missing) > 0L || nrow(Data) != 5L) {
    stop("The AASHTO-check product has an invalid schema.", call. = FALSE)
  }
  CheckLabels <- c(
    `wall-yield` = "Fluencia de la pared",
    `wall-buckling` = "Pandeo de la pared",
    seam = "Resistencia de la costura",
    flexibility = "Flexibilidad",
    `minimum-cover` = "Tapada mínima"
  )
  StatusLabels <- c(
    satisfied = "Satisface",
    `not-satisfied` = "No satisface",
    `not-evaluated` = "No evaluado"
  )
  Format <- function(value, digits) {
    ifelse(
      is.finite(value),
      formatC(value, format = "f", digits = digits),
      "—"
    )
  }
  ForceRow <- Data[["unit", exact = TRUE]] %in% c("kN", "kN/m", "kN m/m")
  ValueDigits <- ifelse(ForceRow, 0L, 3L)
  Output <- data.frame(
    Check = unname(CheckLabels[Data[["checkID", exact = TRUE]]]),
    Value = mapply(Format, Data[["observedValue", exact = TRUE]], ValueDigits),
    Limit = mapply(Format, Data[["limitValue", exact = TRUE]], ValueDigits),
    Utilization = Format(Data[["utilization", exact = TRUE]], 2L),
    Unit = Data[["unit", exact = TRUE]],
    Status = unname(StatusLabels[Data[["checkStatus", exact = TRUE]]]),
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  if (anyNA(Output[["Check", exact = TRUE]]) ||
      anyNA(Output[["Status", exact = TRUE]])) {
    stop("The AASHTO-check mapping is incomplete.", call. = FALSE)
  }
  knitr::kable(
    Output,
    col.names = c(
      "Comprobación", "Demanda o valor", "Resistencia o límite",
      "Demanda/límite", "Unidad", "Resultado"
    ),
    align = c("l", "r", "r", "r", "c", "l"),
    escape = FALSE
  )
}
