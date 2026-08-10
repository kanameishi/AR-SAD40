buildRingExtremaTable <- function(path, caseLabels) {
  if (!is.character(path) || length(path) != 1L || !nzchar(path) ||
      !file.exists(path)) {
    stop("path must identify the ring-extrema CSV.", call. = FALSE)
  }
  if (!is.character(caseLabels) || is.null(names(caseLabels)) ||
      any(!nzchar(names(caseLabels))) || any(!nzchar(caseLabels)) ||
      anyDuplicated(names(caseLabels))) {
    stop("caseLabels must be a uniquely named character vector.", call. = FALSE)
  }

  Data <- read.csv(path, check.names = FALSE)
  Required <- c(
    "resultant", "statistic", "value", "thetaDeg", "case", "unit"
  )
  Missing <- setdiff(Required, names(Data))
  if (length(Missing) > 0L) {
    stop(
      "Ring-extrema CSV is missing: ",
      paste(Missing, collapse = ", "),
      ".",
      call. = FALSE
    )
  }
  Missing <- setdiff(names(caseLabels), unique(Data$case))
  if (length(Missing) > 0L) {
    stop(
      "Ring-extrema CSV does not contain cases: ",
      paste(Missing, collapse = ", "),
      ".",
      call. = FALSE
    )
  }

  Resultants <- c("N", "M", "Q")
  Statistics <- c("minimum", "maximum", "absoluteMaximum")
  OUT <- do.call(rbind, lapply(names(caseLabels), function(caseName) {
    do.call(rbind, lapply(Resultants, function(resultantName) {
      Current <- Data[
        Data$case == caseName & Data$resultant == resultantName,
      ]
      Counts <- table(factor(Current$statistic, levels = Statistics))
      if (any(Counts != 1L)) {
        stop(
          "Expected one minimum, maximum and absoluteMaximum for ",
          caseName,
          " / ",
          resultantName,
          ".",
          call. = FALSE
        )
      }
      Minimum <- Current[Current$statistic == "minimum", ]
      Maximum <- Current[Current$statistic == "maximum", ]
      Absolute <- Current[Current$statistic == "absoluteMaximum", ]
      data.frame(
        Caso = unname(caseLabels[[caseName]]),
        Resultante = resultantName,
        Minimo = Minimum$value,
        `theta min (deg)` = Minimum$thetaDeg,
        Maximo = Maximum$value,
        `theta max (deg)` = Maximum$thetaDeg,
        `Maximo absoluto` = Absolute$value,
        `theta abs (deg)` = Absolute$thetaDeg,
        Unidad = Absolute$unit,
        check.names = FALSE,
        stringsAsFactors = FALSE
      )
    }))
  }))
  rownames(OUT) <- NULL

  knitr::kable(OUT, digits = 5, align = c("l", "c", rep("r", 6), "l"))
}
