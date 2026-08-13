buildCalculationSheetStressTable <- function(pathExtrema) {
  if (!file.exists(pathExtrema)) {
    stop("The sheet-stress extrema product is not available.", call. = FALSE)
  }
  Extrema <- utils::read.csv(
    pathExtrema,
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  Required <- c(
    "alpha", "minimumStressMPa", "minimumThetaDeg", "minimumFiberID",
    "maximumStressMPa", "maximumThetaDeg", "maximumFiberID",
    "maximumAbsoluteStressMPa"
  )
  if (nrow(Extrema) == 0L || length(setdiff(Required, names(Extrema))) > 0L) {
    stop("The sheet-stress extrema product has an invalid schema.", call. = FALSE)
  }
  FibreSymbol <- c(outer = "$e$", inner = "$i$")
  if (any(!(Extrema$minimumFiberID %in% names(FibreSymbol))) ||
      any(!(Extrema$maximumFiberID %in% names(FibreSymbol)))) {
    stop("The sheet-stress extrema product has an invalid fibre ID.", call. = FALSE)
  }
  Extrema <- Extrema[order(Extrema$alpha, decreasing = TRUE), , drop = FALSE]
  Output <- data.frame(
    Alpha = Extrema$alpha,
    Minimum = Extrema$minimumStressMPa,
    MinimumAngle = Extrema$minimumThetaDeg,
    MinimumFibre = unname(FibreSymbol[Extrema$minimumFiberID]),
    Maximum = Extrema$maximumStressMPa,
    MaximumAngle = Extrema$maximumThetaDeg,
    MaximumFibre = unname(FibreSymbol[Extrema$maximumFiberID]),
    AbsoluteMaximum = Extrema$maximumAbsoluteStressMPa,
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  knitr::kable(
    Output,
    digits = c(2, 2, 1, 0, 2, 1, 0, 2),
    col.names = c(
      "$\\alpha$", "$\\sigma_{\\min}$", "$\\theta_{\\min}$",
      "$f_{\\min}$", "$\\sigma_{\\max}$", "$\\theta_{\\max}$",
      "$f_{\\max}$", "$\\lvert\\sigma\\rvert_{\\max}$"
    ),
    align = c("r", "r", "r", "c", "r", "r", "c", "r"),
    escape = FALSE
  )
}
