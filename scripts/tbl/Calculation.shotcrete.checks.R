buildCalculationShotcreteChecksTable <- function(path, liningID) {
  if (!file.exists(path)) {
    stop("The shotcrete-check product is not available.", call. = FALSE)
  }
  Data <- utils::read.csv(
    path,
    check.names = FALSE,
    stringsAsFactors = FALSE,
    na.strings = ""
  )
  Required <- c(
    "interfaceID", "checkID", "calculationStatus", "checkStatus",
    "verticalStressFactor", "horizontalStressFactor", "demandValue",
    "capacityValue", "unit", "utilization"
  )
  Missing <- setdiff(Required, names(Data))
  if (length(Missing) > 0L) {
    stop("The shotcrete-check product has an invalid schema.", call. = FALSE)
  }
  if (!is.character(liningID) || length(liningID) != 1L ||
      !nzchar(liningID) || !("liningID" %in% names(Data))) {
    stop("liningID must identify one concrete alternative.", call. = FALSE)
  }
  Data <- Data[
    Data[["liningID", exact = TRUE]] == liningID &
    Data[["checkID", exact = TRUE]] %in% c(
      "tension-face", "compression-face", "one-way-shear", "axial-flexure"
    ) & Data[["calculationStatus", exact = TRUE]] == "calculated",
    ,
    drop = FALSE
  ]
  if (nrow(Data) == 0L || any(!is.finite(Data[["utilization", exact = TRUE]]))) {
    stop("The calculated shotcrete checks are unavailable.", call. = FALSE)
  }
  InterfaceCodes <- c(`full-traction` = "1", `normal-only` = "0")
  CheckCodes <- c(
    `tension-face` = "T",
    `compression-face` = "C",
    `one-way-shear` = "V",
    `axial-flexure` = "NM"
  )
  StatusLabels <- c(
    satisfied = "Satisface",
    `not-satisfied` = "No satisface"
  )
  UnitLabels <- c(
    MPa = "$\\mathrm{MPa}$",
    kN = "$\\mathrm{kN}$",
    `-` = "$-$"
  )
  formatDemand <- function(value, unit) {
    ifelse(
      unit == "kN",
      formatC(round(value), format = "f", digits = 0L),
      formatC(value, format = "f", digits = 2L)
    )
  }
  Output <- data.frame(
    Interface = unname(InterfaceCodes[Data[["interfaceID", exact = TRUE]]]),
    Check = unname(CheckCodes[Data[["checkID", exact = TRUE]]]),
    VerticalFactor = formatC(
      Data[["verticalStressFactor", exact = TRUE]],
      format = "fg",
      digits = 3L
    ),
    HorizontalFactor = formatC(
      Data[["horizontalStressFactor", exact = TRUE]],
      format = "fg",
      digits = 3L
    ),
    Demand = formatDemand(
      Data[["demandValue", exact = TRUE]],
      Data[["unit", exact = TRUE]]
    ),
    Resistance = formatDemand(
      Data[["capacityValue", exact = TRUE]],
      Data[["unit", exact = TRUE]]
    ),
    Unit = unname(UnitLabels[Data[["unit", exact = TRUE]]]),
    Utilization = formatC(
      Data[["utilization", exact = TRUE]],
      format = "f",
      digits = 4L
    ),
    Status = unname(StatusLabels[Data[["checkStatus", exact = TRUE]]]),
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  if (anyNA(Output)) {
    stop("The shotcrete-check mapping is incomplete.", call. = FALSE)
  }
  knitr::kable(
    Output,
    col.names = c(
      "$\\alpha$", "$C$", "$f_v$", "$f_h$", "$D$", "$R$", "$u$", "$U$",
      "$S$"
    ),
    align = c("c", "c", "r", "r", "r", "r", "c", "r", "l"),
    escape = FALSE
  )
}

buildCalculationReinforcementChecksTable <- function(path, liningID) {
  if (!file.exists(path)) {
    stop("The shotcrete-check product is not available.", call. = FALSE)
  }
  Data <- utils::read.csv(
    path,
    check.names = FALSE,
    stringsAsFactors = FALSE,
    na.strings = ""
  )
  Required <- c(
    "liningID", "checkID", "calculationStatus", "checkStatus",
    "demandValue", "capacityValue", "unit"
  )
  Missing <- setdiff(Required, names(Data))
  if (length(Missing) > 0L) {
    stop("The reinforcement-check product has an invalid schema.", call. = FALSE)
  }
  if (!is.character(liningID) || length(liningID) != 1L ||
      !nzchar(liningID)) {
    stop("liningID must identify one concrete alternative.", call. = FALSE)
  }
  CheckIDs <- c(
    "minimum-circumferential-reinforcement",
    "minimum-longitudinal-reinforcement",
    "equal-reinforcement-at-opposite-faces"
  )
  Data <- Data[
    Data[["liningID", exact = TRUE]] == liningID &
      Data[["checkID", exact = TRUE]] %in% CheckIDs &
      Data[["calculationStatus", exact = TRUE]] == "calculated",
    Required[-1L],
    drop = FALSE
  ]
  Data <- unique(Data)
  Data <- Data[match(CheckIDs, Data[["checkID", exact = TRUE]]), , drop = FALSE]
  if (nrow(Data) != length(CheckIDs) || anyNA(Data[["checkID", exact = TRUE]]) ||
      any(!is.finite(Data[["demandValue", exact = TRUE]])) ||
      any(!is.finite(Data[["capacityValue", exact = TRUE]]))) {
    stop("The calculated reinforcement checks are incomplete.", call. = FALSE)
  }
  CheckLabels <- c(
    `minimum-circumferential-reinforcement` = "Cuantía circunferencial",
    `minimum-longitudinal-reinforcement` = "Cuantía ortogonal",
    `equal-reinforcement-at-opposite-faces` = "Igualdad entre caras"
  )
  StatusLabels <- c(
    satisfied = "Satisface",
    `not-satisfied` = "No satisface"
  )
  UnitLabels <- c(`mm2/m` = "$\\mathrm{cm^2/m}$")
  Output <- data.frame(
    Control = unname(CheckLabels[Data[["checkID", exact = TRUE]]]),
    Requirement = formatC(
      Data[["demandValue", exact = TRUE]] / 100,
      format = "f",
      digits = 2L
    ),
    Provided = formatC(
      Data[["capacityValue", exact = TRUE]] / 100,
      format = "f",
      digits = 2L
    ),
    Unit = unname(UnitLabels[Data[["unit", exact = TRUE]]]),
    Status = unname(StatusLabels[Data[["checkStatus", exact = TRUE]]]),
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  if (anyNA(Output)) {
    stop("The reinforcement-check mapping is incomplete.", call. = FALSE)
  }
  knitr::kable(
    Output,
    col.names = c("Control", "Requerido", "Provisto o calculado", "$u$", "$S$"),
    align = c("l", "r", "r", "c", "l"),
    escape = FALSE
  )
}
