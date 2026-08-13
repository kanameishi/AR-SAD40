buildCalculationControlsTable <- function(path) {
  if (!file.exists(path)) {
    stop("The numerical-control file is not available.", call. = FALSE)
  }
  Data <- utils::read.csv(path, check.names = FALSE)
  Required <- c(
    "caseID", "alpha", "controlID", "resultantID", "observedValue", "unit",
    "limitValue", "pass"
  )
  if (length(setdiff(Required, names(Data))) > 0L) {
    stop("The numerical-control file has an invalid schema.", call. = FALSE)
  }
  ExpectedControls <- c("closed-form-resultants", "global-equilibrium")
  Data <- Data[Data$controlID %in% ExpectedControls, , drop = FALSE]
  if (nrow(Data) != 12L || !all(Data$pass)) {
    stop("The materialized numerical controls are incomplete.", call. = FALSE)
  }
  formatScientificLatex <- function(values, digits) {
    vapply(values, function(value) {
      if (value == 0) return("$0$")
      Exponent <- floor(log10(abs(value)))
      Mantissa <- value / 10^Exponent
      paste0(
        "$", format(signif(Mantissa, digits), trim = TRUE, scientific = FALSE),
        "\\times10^{", Exponent, "}$"
      )
    }, character(1))
  }
  ResultantLabels <- c(
    N = "$N_\\theta$", M = "$M_\\theta$", Q = "$Q_\\theta$",
    Fx = "$F_x$", Fz = "$F_z$", Mc = "$M_c$"
  )
  UnitLabels <- c(
    "kN/m" = "$\\mathrm{kN/m}$",
    "kN m/m" = "$\\mathrm{kN\\,m/m}$",
    "-" = "—"
  )
  Resultants <- unname(ResultantLabels[Data$resultantID])
  Units <- unname(UnitLabels[Data$unit])
  if (anyNA(Resultants) || anyNA(Units)) {
    stop("The public resultant or unit mapping is incomplete.", call. = FALSE)
  }
  if (any(!is.finite(Data$alpha)) || any(Data$alpha < 0) || any(Data$alpha > 1)) {
    stop("The numerical-control alpha values are invalid.", call. = FALSE)
  }
  ControlOrder <- match(
    Data$resultantID,
    c("N", "M", "Q", "Fx", "Fz", "Mc")
  )
  RowOrder <- order(-Data$alpha, ControlOrder)
  Data <- Data[RowOrder, , drop = FALSE]
  Resultants <- Resultants[RowOrder]
  Units <- Units[RowOrder]
  Output <- data.frame(
    Alpha = Data$alpha,
    Resultant = Resultants,
    Residual = formatScientificLatex(Data$observedValue, 4L),
    Limit = formatScientificLatex(Data$limitValue, 2L),
    Unit = Units,
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  knitr::kable(
    Output,
    col.names = c(
      "$\\alpha$", "$X$", "$\\varepsilon_X$",
      "$\\varepsilon_{\\mathrm{lim}}$", "$u_X$"
    ),
    align = c("r", "c", "r", "r", "c"),
    escape = FALSE
  )
}
