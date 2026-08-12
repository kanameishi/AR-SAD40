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
  absoluteMaximum <- function(caseID, resultantID) {
    Value <- Extrema$value[
      Extrema$caseID == caseID &
        Extrema$resultantID == resultantID &
        Extrema$statisticID == "absolute-maximum"
    ]
    if (length(Value) != 1L) {
      stop("An expected absolute maximum is missing or duplicated.", call. = FALSE)
    }
    Value
  }
  Output <- do.call(rbind, lapply(seq_len(nrow(Cases)), function(i) {
    CaseID <- Cases$caseID[i]
    Alpha <- Cases$alpha[i]
    data.frame(
      Prescripcion = paste0(
        "Componente tangencial: α = ",
        formatC(Alpha, format = "f", digits = 2)
      ),
      NClaveInferior = valueAt(CaseID, "N", 0),
      NLaterales = valueAt(CaseID, "N", pi / 2),
      MClaveInferior = valueAt(CaseID, "M", 0),
      MLaterales = valueAt(CaseID, "M", pi / 2),
      QMax = absoluteMaximum(CaseID, "Q"),
      check.names = FALSE,
      stringsAsFactors = FALSE
    )
  }))
  knitr::kable(
    Output,
    digits = c(0, 1, 1, 2, 2, 2),
    col.names = c(
      "Prescripción", "$N_\\theta$ clave/fondo ($\\mathrm{kN/m}$)",
      "$N_\\theta$ puntos laterales ($\\mathrm{kN/m}$)",
      "$M_\\theta$ clave/fondo ($\\mathrm{kN\\,m/m}$)",
      "$M_\\theta$ puntos laterales ($\\mathrm{kN\\,m/m}$)",
      "$\\lvert Q_\\theta\\rvert_{\\max}$ ($\\mathrm{kN/m}$)"
    ),
    align = c("l", rep("r", 5)),
    escape = FALSE
  )
}
