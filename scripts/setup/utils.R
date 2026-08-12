readCalculationJson <- function(path) {
  if (!file.exists(path)) {
    stop("The calculation configuration is not available: ", path, call. = FALSE)
  }
  if (!requireNamespace("jsonlite", quietly = TRUE)) {
    stop("The jsonlite package is required to read calculation.json.", call. = FALSE)
  }
  Config <- jsonlite::fromJSON(path, simplifyVector = FALSE)
  if (!is.list(Config) || is.null(names(Config))) {
    stop("calculation.json must contain one named JSON object.", call. = FALSE)
  }
  Config
}

formatCalculationFixed <- function(value, digits) {
  formatC(value, format = "f", digits = digits)
}

formatCalculationGeneral <- function(value, digits = 6L) {
  format(signif(value, digits), trim = TRUE, scientific = FALSE)
}

formatCalculationScientificLatex <- function(value, digits = 3L) {
  if (!is.numeric(value) || length(value) != 1L || !is.finite(value)) {
    stop("A finite scalar is required for scientific formatting.", call. = FALSE)
  }
  if (value == 0) {
    return("0")
  }
  Exponent <- floor(log10(abs(value)))
  Mantissa <- value / 10^Exponent
  paste0(
    format(signif(Mantissa, digits), trim = TRUE, scientific = FALSE),
    "\\times10^{", Exponent, "}"
  )
}

formatCalculationSigned <- function(value, digits = 3L) {
  Sign <- if (value < 0) "-" else "+"
  paste0(Sign, formatCalculationGeneral(abs(value), digits))
}

formatCalculationList <- function(values, digits = 4L) {
  Values <- vapply(
    values,
    formatCalculationGeneral,
    character(1),
    digits = digits
  )
  if (length(Values) == 1L) {
    return(Values)
  }
  if (length(Values) == 2L) {
    return(paste(Values, collapse = " y "))
  }
  paste0(paste(utils::head(Values, -1L), collapse = ", "), " y ", Values[length(Values)])
}
