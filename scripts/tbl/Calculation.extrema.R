buildCalculationExtremaTable <- function(pathResultants, pathExtrema) {
  if (!file.exists(pathResultants) || !file.exists(pathExtrema)) {
    stop("The numerical-result products are not available.", call. = FALSE)
  }
  Resultants <- utils::read.csv(pathResultants, check.names = FALSE)
  Extrema <- utils::read.csv(pathExtrema, check.names = FALSE)
  RequiredResultants <- c(
    "caseId", "alpha", "resultantId", "thetaRad", "value"
  )
  RequiredExtrema <- c(
    "caseId", "alpha", "resultantId", "statisticId", "value"
  )
  if (length(setdiff(RequiredResultants, names(Resultants))) > 0L ||
      length(setdiff(RequiredExtrema, names(Extrema))) > 0L) {
    stop("The numerical-result products have an invalid schema.", call. = FALSE)
  }
  Cases <- unique(Resultants[, c("caseId", "alpha")])
  valueAt <- function(caseId, resultantId, angle) {
    Data <- Resultants[
      Resultants$caseId == caseId & Resultants$resultantId == resultantId,
      ,
      drop = FALSE
    ]
    Data$value[which.min(abs(Data$thetaRad - angle))]
  }
  absoluteMaximum <- function(caseId, resultantId) {
    Value <- Extrema$value[
      Extrema$caseId == caseId &
        Extrema$resultantId == resultantId &
        Extrema$statisticId == "absolute-maximum"
    ]
    if (length(Value) != 1L) {
      stop("An expected absolute maximum is missing or duplicated.", call. = FALSE)
    }
    Value
  }
  Output <- do.call(rbind, lapply(seq_len(nrow(Cases)), function(Index) {
    CaseId <- Cases$caseId[Index]
    Alpha <- Cases$alpha[Index]
    data.frame(
      Prescripcion = paste0(
        "Componente tangencial: α = ",
        formatC(Alpha, format = "f", digits = 2)
      ),
      NClaveInferior = valueAt(CaseId, "N", 0),
      NLaterales = valueAt(CaseId, "N", pi / 2),
      MClaveInferior = valueAt(CaseId, "M", 0),
      MLaterales = valueAt(CaseId, "M", pi / 2),
      QMax = absoluteMaximum(CaseId, "Q"),
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
