buildCalculationControlsTable <- function(path) {
  if (!file.exists(path)) {
    stop("The numerical-control file is not available.", call. = FALSE)
  }
  data <- utils::read.csv(path, check.names = FALSE)
  required <- c(
    "prescription", "resultant", "value", "unit", "tolerance", "pass",
    "gridPoints", "integrationSteps", "evidenceLevel"
  )
  if (length(setdiff(required, names(data))) > 0L) {
    stop("The numerical-control file has an invalid schema.", call. = FALSE)
  }
  formatScientificLatex <- function(values, digits) {
    vapply(values, function(value) {
      if (value == 0) {
        return("$0$")
      }
      exponent <- floor(log10(abs(value)))
      mantissa <- value / 10^exponent
      mantissaText <- format(
        signif(mantissa, digits), trim = TRUE, scientific = FALSE
      )
      paste0("$", mantissaText, "\\times10^{", exponent, "}$")
    }, character(1))
  }
  resultantLabels <- c(
    "N" = "$N_\\theta$", "M" = "$M_\\theta$", "Q" = "$Q_\\theta$"
  )
  unitLabels <- c(
    "kN/m" = "$\\mathrm{kN/m}$",
    "kN m/m" = "$\\mathrm{kN\\,m/m}$"
  )
  resultants <- unname(resultantLabels[data$resultant])
  units <- unname(unitLabels[data$unit])
  if (anyNA(resultants) || anyNA(units)) {
    stop("The public resultant or unit mapping is incomplete.", call. = FALSE)
  }
  output <- data.frame(
    Prescripcion = data$prescription,
    Resultante = resultants,
    Diferencia = formatScientificLatex(data$value, 3L),
    Unidad = units,
    Tolerancia = formatScientificLatex(data$tolerance, 2L),
    Malla = data$gridPoints,
    Pasos = data$integrationSteps,
    Estado = ifelse(data$pass, "Cumple", "No cumple"),
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  knitr::kable(
    output,
    col.names = c(
      "Prescripción", "Resultante", "Diferencia máxima", "Unidad",
      "Tolerancia", "Puntos angulares", "Pasos de integración", "Control"
    ),
    align = c("l", "c", "r", "c", "r", "r", "r", "c"),
    escape = FALSE
  )
}
