buildCalculationVerificationSummary <- function(path) {
  if (!file.exists(path)) {
    stop("The verification-summary file is not available.", call. = FALSE)
  }
  data <- utils::read.csv(path, check.names = FALSE)
  required <- c("reference", "magnitude", "evidence", "result")
  if (length(setdiff(required, names(data))) > 0L) {
    stop("The verification-summary file has an invalid schema.", call. = FALSE)
  }
  resultLabels <- c(
    "Baker (1968)" = paste0(
      "Errores absolutos máximos: $4.97\\times10^{-4}$ en $N_\\theta$ ",
      "y $4.23\\times10^{-4}$ en $M_\\theta$."
    ),
    "USACE, ejemplo D4" = paste0(
      "$3\\,600\\ \\mathrm{lb/ft^2}$, $10\\,530\\ \\mathrm{lb/ft}$ y ",
      "$11\\,583\\ \\mathrm{lb/ft}$ reproducidos; ",
      "$5\\,400\\ \\mathrm{lb/ft}$ es un resultado derivado."
    ),
    "FHWA-RD-98-191" = paste0(
      "Ocho de nueve filas reproducidas al redondear a ",
      "$0.1\\ \\mathrm{kPa}$; se conserva una inconsistencia de impresión."
    ),
    "Schwartz--Einstein, HP97" = paste0(
      "Cuatro combinaciones reproducidas; la fuente no tabula ",
      "fuerza cortante."
    ),
    "Núñez (2000)" = paste0(
      "Diferencia relativa máxima de $1.31\\,\\%$ respecto de valores ",
      "redondeados."
    )
  )
  results <- unname(resultLabels[data$reference])
  if (anyNA(results)) {
    stop("The public verification-result mapping is incomplete.", call. = FALSE)
  }
  output <- data.frame(
    Referencia = data$reference,
    Magnitud = data$magnitude,
    Resultado = results,
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  knitr::kable(
    output, align = c("l", "l", "l"), escape = FALSE
  )
}
