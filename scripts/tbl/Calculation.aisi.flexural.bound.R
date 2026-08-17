buildAisiFlexuralTable <- function(path) {
  if (!file.exists(path)) {
    stop("The flexural-bound product is not available.", call. = FALSE)
  }
  Data <- utils::read.csv(
    path,
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  Required <- c(
    "alpha", "thetaDeg", "normalForceKnPerM", "absoluteMomentKnMPerM",
    "nominalBoundKnMPerM", "demandBoundRatio"
  )
  Missing <- setdiff(Required, names(Data))
  if (length(Missing) > 0L || nrow(Data) == 0L) {
    stop("The flexural-bound product has an invalid schema.", call. = FALSE)
  }
  Data <- Data[order(Data$alpha, decreasing = TRUE), , drop = FALSE]
  Output <- data.frame(
    Alpha = Data$alpha,
    Theta = Data$thetaDeg,
    Normal = Data$normalForceKnPerM,
    Moment = Data$absoluteMomentKnMPerM,
    Bound = Data$nominalBoundKnMPerM,
    Ratio = Data$demandBoundRatio,
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  knitr::kable(
    Output,
    digits = c(2, 1, 2, 2, 2, 3),
    col.names = c(
      "$\\alpha$", "$\\theta^\\star$", "$N_\\theta^\\star$",
      "$\\lvert M_\\theta\\rvert_{\\max}$", "$\\overline M_n$",
      "$\\rho_M$"
    ),
    align = rep("r", 6L),
    escape = FALSE
  )
}
