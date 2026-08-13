buildCalculationExtremaTable <- function(pathResultants, pathExtrema) {
  if (!file.exists(pathResultants) || !file.exists(pathExtrema)) {
    stop("The numerical-result products are not available.", call. = FALSE)
  }
  Resultants <- utils::read.csv(pathResultants, check.names = FALSE)
  Extrema <- utils::read.csv(pathExtrema, check.names = FALSE)
  RequiredResultants <- c(
    "caseID", "alpha", "resultantID", "thetaRad", "value"
  )
  RequiredExtrema <- c(
    "caseID", "alpha", "resultantID", "statisticID", "value"
  )
  if (length(setdiff(RequiredResultants, names(Resultants))) > 0L ||
      length(setdiff(RequiredExtrema, names(Extrema))) > 0L) {
    stop("The numerical-result products have an invalid schema.", call. = FALSE)
  }
  Cases <- unique(Resultants[, c("caseID", "alpha")])
  valueAt <- function(caseID, resultantID, angle) {
    Data <- Resultants[
      Resultants$caseID == caseID & Resultants$resultantID == resultantID,
      ,
      drop = FALSE
    ]
    Data$value[which.min(abs(Data$thetaRad - angle))]
  }
  extremum <- function(caseID, resultantID, statisticID) {
    Value <- Extrema$value[
      Extrema$caseID == caseID &
        Extrema$resultantID == resultantID &
        Extrema$statisticID == statisticID
    ]
    if (length(Value) != 1L) {
      stop("An expected resultant extremum is missing or duplicated.", call. = FALSE)
    }
    Value
  }
  Output <- do.call(rbind, lapply(seq_len(nrow(Cases)), function(i) {
    CaseID <- Cases$caseID[i]
    Alpha <- Cases$alpha[i]
    data.frame(
      Alpha = Alpha,
      NormalA = valueAt(CaseID, "N", 0),
      NormalB = valueAt(CaseID, "N", pi / 2),
      MomentA = valueAt(CaseID, "M", 0),
      MomentB = valueAt(CaseID, "M", pi / 2),
      QMaximum = extremum(CaseID, "Q", "absolute-maximum"),
      check.names = FALSE,
      stringsAsFactors = FALSE
    )
  }))
  Output <- Output[order(Output$Alpha, decreasing = TRUE), , drop = FALSE]
  knitr::kable(
    Output,
    digits = c(0, 4, 4, 4, 4, 4),
    col.names = c(
      "$\\alpha$", "$N_A$", "$N_B$", "$M_A$", "$M_B$",
      "$\\lvert Q_\\theta\\rvert_{\\max}$"
    ),
    align = rep("r", 6),
    escape = FALSE
  )
}
