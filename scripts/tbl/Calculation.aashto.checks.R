if (!exists("buildReportTable", mode = "function", inherits = TRUE)) {
  source(file.path("scripts", "tbl", "table.R"), local = TRUE)
}

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
  CheckCodes <- c(
    `wall-yield` = "A",
    `wall-buckling` = "B",
    seam = "C",
    flexibility = "D",
    `minimum-cover` = "E"
  )
  StatusCodes <- c(
    satisfied = "OK",
    `not-satisfied` = "FAIL",
    `not-evaluated` = "N/A"
  )
  Format <- function(value, digits) {
    ifelse(
      is.finite(value),
      formatC(value, format = "f", digits = digits),
      "—"
    )
  }
  ForceRow <- Data[["unit", exact = TRUE]] %in% c("kN", "kN/m", "kN m/m")
  ValueDigits <- ifelse(ForceRow, 1L, 3L)
  Output <- data.frame(
    Check = unname(CheckCodes[Data[["checkID", exact = TRUE]]]),
    Demand = mapply(Format, Data[["observedValue", exact = TRUE]], ValueDigits),
    Resistance = mapply(Format, Data[["limitValue", exact = TRUE]], ValueDigits),
    Utilization = Format(Data[["utilization", exact = TRUE]], 3L),
    Unit = Data[["unit", exact = TRUE]],
    Status = unname(StatusCodes[Data[["checkStatus", exact = TRUE]]]),
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  if (anyNA(Output[["Check", exact = TRUE]]) ||
      anyNA(Output[["Status", exact = TRUE]])) {
    stop("The AASHTO-check mapping is incomplete.", call. = FALSE)
  }
  buildReportTable(
    data = Output,
    headers = c(
      "$i$", "$D$", "$R$", "$U=D/R$", "$u$", "$E$"
    ),
    align = c("c", "r", "r", "r", "c", "c")
  )
}
