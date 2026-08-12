buildCalculationControlsTable <- function(path) {
  if (!file.exists(path)) {
    stop("The numerical-control file is not available.", call. = FALSE)
  }
  Data <- utils::read.csv(path, check.names = FALSE)
  Required <- c(
    "caseId", "alpha", "resultantId", "observedValue", "unit", "limitValue",
    "pass", "thetaPointCount", "integrationSteps", "evidenceLevel"
  )
  if (length(setdiff(Required, names(Data))) > 0L) {
    stop("The numerical-control file has an invalid schema.", call. = FALSE)
  }
  formatScientificLatex <- function(values, digits) {
    vapply(values, function(Value) {
      if (Value == 0) return("$0$")
      Exponent <- floor(log10(abs(Value)))
      Mantissa <- Value / 10^Exponent
      paste0(
        "$", format(signif(Mantissa, digits), trim = TRUE, scientific = FALSE),
        "\\times10^{", Exponent, "}$"
      )
    }, character(1))
  }
  ResultantLabels <- c(
    N = "$N_\\theta$", M = "$M_\\theta$", Q = "$Q_\\theta$"
  )
  UnitLabels <- c(
    "kN/m" = "$\\mathrm{kN/m}$",
    "kN m/m" = "$\\mathrm{kN\\,m/m}$"
  )
  Resultants <- unname(ResultantLabels[Data$resultantId])
  Units <- unname(UnitLabels[Data$unit])
  if (anyNA(Resultants) || anyNA(Units)) {
    stop("The public resultant or unit mapping is incomplete.", call. = FALSE)
  }
  if (any(!is.finite(Data$alpha)) || any(Data$alpha < 0) || any(Data$alpha > 1)) {
    stop("The numerical-control alpha values are invalid.", call. = FALSE)
  }
  Output <- data.frame(
    Prescripcion = paste0(
      "Componente tangencial: α = ",
      formatC(Data$alpha, format = "f", digits = 2)
    ),
    Resultante = Resultants,
    Diferencia = formatScientificLatex(Data$observedValue, 3L),
    Unidad = Units,
    Tolerancia = formatScientificLatex(Data$limitValue, 2L),
    Malla = Data$thetaPointCount,
    Pasos = Data$integrationSteps,
    Estado = ifelse(Data$pass, "Cumple", "No cumple"),
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  knitr::kable(
    Output,
    col.names = c(
      "Prescripción", "Resultante", "Diferencia máxima", "Unidad",
      "Tolerancia", "Puntos angulares", "Pasos de integración", "Control"
    ),
    align = c("l", "c", "r", "c", "r", "r", "r", "c"),
    escape = FALSE
  )
}
