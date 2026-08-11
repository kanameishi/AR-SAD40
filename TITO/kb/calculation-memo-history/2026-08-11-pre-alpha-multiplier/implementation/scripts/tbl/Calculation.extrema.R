buildCalculationExtremaTable <- function(path) {
  if (!file.exists(path)) {
    stop("The numerical-result file is not available.", call. = FALSE)
  }
  data <- utils::read.csv(path, check.names = FALSE)
  required <- c(
    "prescription", "normalCrownInvert", "normalSidewalls",
    "momentCrownInvert", "momentSidewalls", "maximumAbsoluteShear",
    "evidenceLevel"
  )
  if (length(setdiff(required, names(data))) > 0L) {
    stop("The numerical-result file has an invalid schema.", call. = FALSE)
  }
  output <- data.frame(
    Prescripcion = data$prescription,
    NClaveSolera = data$normalCrownInvert,
    NHastiales = data$normalSidewalls,
    MClaveSolera = data$momentCrownInvert,
    MHastiales = data$momentSidewalls,
    QMax = data$maximumAbsoluteShear,
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  knitr::kable(
    output,
    digits = c(0, 1, 1, 2, 2, 2),
    col.names = c(
      "Prescripción", "$N_\\theta$ clave/solera ($\\mathrm{kN/m}$)",
      "$N_\\theta$ hastiales ($\\mathrm{kN/m}$)",
      "$M_\\theta$ clave/solera ($\\mathrm{kN\\,m/m}$)",
      "$M_\\theta$ hastiales ($\\mathrm{kN\\,m/m}$)",
      "$\\lvert Q_\\theta\\rvert_{\\max}$ ($\\mathrm{kN/m}$)"
    ),
    align = c("l", rep("r", 5)),
    escape = FALSE
  )
}
