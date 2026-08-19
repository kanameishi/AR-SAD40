source("scripts/fig/Resultants.R")

buildCalculationClassicalComparisonFigure <- function(
    data,
    liningID,
    methodID,
    radialFraction = 0.25) {
  Required <- c(
    "liningID", "methodID", "caseID", "thetaIndex", "thetaRad",
    "thetaDeg", "resultantID", "value", "unit"
  )
  if (!is.data.frame(data) || any(!Required %in% names(data))) {
    stop(
      "The classical-comparison curves have an invalid schema.",
      call. = FALSE
    )
  }
  Method <- switch(
    methodID,
    `official-hybrid` = list(
      modelID = "schwartz-einstein-balanced-gradient-hybrid",
      caseIDs = c("slip", "no-slip"),
      interfaceIDs = c("full-slip", "no-slip"),
      labels = c(
        "Híbrido: Slip (S)",
        "Híbrido: No Slip (NS)"
      )
    ),
    `schwartz-einstein-uniform` = list(
      modelID = "schwartz-einstein-external-loading",
      caseIDs = c(
        "schwartz-einstein-full-slip",
        "schwartz-einstein-no-slip"
      ),
      interfaceIDs = c("full-slip", "no-slip"),
      labels = c(
        "E–S uniforme: Slip (S)",
        "E–S uniforme: No Slip (NS)"
      )
    ),
    `prescribed-k0-ring` = list(
      modelID = "prescribed-biaxial-direct-integration",
      caseIDs = c("slip", "no-slip"),
      interfaceIDs = c("full-traction", "normal-only"),
      labels = c(
        "K0 prescrito: proyección tangencial",
        "K0 prescrito: acción normal"
      )
    ),
    stop("The requested comparison method is unavailable.", call. = FALSE)
  )
  Data <- data[
    data$liningID == liningID & data$methodID == methodID,
    ,
    drop = FALSE
  ]
  if (nrow(Data) == 0L ||
      !setequal(unique(Data$caseID), Method$caseIDs)) {
    stop("The requested comparison curves are incomplete.", call. = FALSE)
  }
  InterfaceMap <- stats::setNames(
    Method$interfaceIDs,
    Method$caseIDs
  )
  Curves <- data.frame(
    caseID = Data$caseID,
    interfaceID = unname(InterfaceMap[Data$caseID]),
    stageID = "completed-fill",
    interactionModelID = Method$modelID,
    resultantID = Data$resultantID,
    thetaIndex = Data$thetaIndex,
    thetaRad = Data$thetaRad,
    thetaDeg = Data$thetaDeg,
    value = Data$value,
    unit = Data$unit,
    evidenceLevel = "DE",
    stringsAsFactors = FALSE
  )
  Resultants <- c("N", "M", "Q")
  Maximums <- vapply(Resultants, function(ResultantID) {
    max(abs(Curves$value[Curves$resultantID == ResultantID]))
  }, numeric(1))
  Units <- vapply(Resultants, function(ResultantID) {
    Current <- unique(Curves$unit[Curves$resultantID == ResultantID])
    if (length(Current) != 1L || is.na(Current) || !nzchar(Current)) {
      stop("Every comparison resultant requires one unit.", call. = FALSE)
    }
    Current
  }, character(1))
  if (any(!is.finite(Maximums)) || any(Maximums <= 0)) {
    stop("Every comparison resultant requires a non-zero scale.", call. = FALSE)
  }
  ReferenceRadius <- 1
  Scales <- data.frame(
    resultantID = Resultants,
    displayScale = radialFraction * ReferenceRadius / Maximums,
    maximumAbsoluteValue = Maximums,
    resultantUnit = Units,
    radialFraction = radialFraction,
    stringsAsFactors = FALSE
  )
  Labels <- stats::setNames(Method$labels, Method$caseIDs)
  Plot <- buildCalculationResultantsInteractive(
    pathCurves = NULL,
    pathScales = NULL,
    radius = ReferenceRadius,
    graphicAmplification = 1,
    raysPerCircle = 24L,
    scaleMode = "provided",
    curves = Curves,
    scales = Scales,
    caseLabels = Labels
  )
  attr(Plot, "comparisonMethodID") <- methodID
  Plot
}
