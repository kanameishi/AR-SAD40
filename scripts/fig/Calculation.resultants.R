source("scripts/R/ringFigureData.R")
source("scripts/fig/ringStatic.R")
source("scripts/fig/ringParametric.R")

.readResultantGeometry <- function(
  pathCurves,
  pathScales,
  radius,
  graphicAmplification = 1
) {
  if (!file.exists(pathCurves) || !file.exists(pathScales)) {
    stop("The calculation result files are not available.", call. = FALSE)
  }
  Curves <- utils::read.csv(pathCurves, check.names = FALSE)
  Scales <- utils::read.csv(pathScales, check.names = FALSE)
  RequiredCurves <- c(
    "caseID", "alpha", "resultantID", "thetaIndex", "thetaRad", "thetaDeg",
    "value", "unit", "evidenceLevel"
  )
  RequiredScales <- c(
    "resultantID", "displayScale", "maximumAbsoluteValue", "resultantUnit",
    "radialFraction"
  )
  if (length(setdiff(RequiredCurves, names(Curves))) > 0L ||
      length(setdiff(RequiredScales, names(Scales))) > 0L) {
    stop(
      "The calculation result files have an invalid schema.",
      call. = FALSE
    )
  }
  Curves <- data.frame(
    case = Curves$caseID,
    stage = "Estado biaxial uniforme",
    model = "Acciones prescritas",
    prescription = paste0(
      "Componente tangencial: α = ",
      formatC(Curves$alpha, format = "f", digits = 2)
    ),
    tangentialMultiplier = Curves$alpha,
    resultant = Curves$resultantID,
    thetaIndex = Curves$thetaIndex,
    theta = Curves$thetaRad,
    thetaDeg = Curves$thetaDeg,
    value = Curves$value,
    unit = Curves$unit,
    evidenceLevel = Curves$evidenceLevel,
    stringsAsFactors = FALSE
  )
  Scales <- data.frame(
    resultant = Scales$resultantID,
    displayScale = Scales$displayScale,
    maximumAbsoluteValue = Scales$maximumAbsoluteValue,
    unit = Scales$resultantUnit,
    radialFraction = Scales$radialFraction,
    stringsAsFactors = FALSE
  )
  Multipliers <- tapply(
    Curves$tangentialMultiplier,
    Curves$case,
    unique
  )
  if (any(lengths(Multipliers) != 1L) ||
      any(!is.finite(unlist(Multipliers)))) {
    stop(
      "Each calculation case requires one tangential multiplier.",
      call. = FALSE
    )
  }
  CaseOrder <- names(sort(unlist(Multipliers), decreasing = TRUE))
  Geometry <- prepareRingDiagram(
    Curves,
    Scales,
    radius,
    graphicAmplification = graphicAmplification
  )
  Geometry <- Geometry[order(
    match(as.character(Geometry$case), CaseOrder),
    match(as.character(Geometry$resultant), c("N", "M", "Q")),
    Geometry$thetaIndex
  ), , drop = FALSE]
  rownames(Geometry) <- NULL
  Geometry
}

buildCalculationResultants <- function(
  pathCurves,
  pathScales,
  radius,
  graphicAmplification = 1,
  raysPerCircle = 36L
) {
  Geometry <- .readResultantGeometry(
    pathCurves,
    pathScales,
    radius,
    graphicAmplification
  )
  buildRingStaticPlot(
    geometry = Geometry,
    baselineRadius = radius,
    raysPerCircle = raysPerCircle
  )
}

buildCalculationResultantsInteractive <- function(
  pathCurves,
  pathScales,
  radius,
  graphicAmplification = 1,
  raysPerCircle = 36L,
  resultant = c("N", "M", "Q")
) {
  Geometry <- .readResultantGeometry(
    pathCurves,
    pathScales,
    radius,
    graphicAmplification
  )
  Resultants <- c("N", "M", "Q")
  if (!is.character(resultant) || length(resultant) == 0L ||
      anyNA(resultant) || any(!resultant %in% Resultants)) {
    stop("resultant must contain one or more of N, M, and Q.", call. = FALSE)
  }
  Resultants <- Resultants[Resultants %in% unique(resultant)]
  Geometry <- Geometry[
    Geometry$resultant %in% Resultants,
    ,
    drop = FALSE
  ]
  Cases <- unique(Geometry$case)
  Rays <- prepareRingRays(
    geometry = Geometry,
    baselineRadius = radius,
    raysPerCircle = raysPerCircle,
    phaseDegByCase = stats::setNames(
      ((seq_along(Cases) - 1L) * 5) %% 10,
      Cases
    )
  )
  AmplificationLabel <- if (length(graphicAmplification) == 1L) {
    format(graphicAmplification, trim = TRUE)
  } else {
    paste(
      paste0(
        names(graphicAmplification),
        " = ",
        format(graphicAmplification, trim = TRUE)
      ),
      collapse = ", "
    )
  }
  NGR::buildSectionResultantsPlot(
    curves = Geometry,
    rays = Rays,
    referenceRadius = radius,
    panelTitles = c(
      N = "Fuerza normal, Nθ [kN/m]",
      M = "Momento flector, Mθ [kN·m/m]",
      Q = "Fuerza cortante, Qθ [kN/m]"
    ),
    positionLabels = c(
      top = "Clave",
      right = "Lateral der.",
      bottom = "Fondo",
      left = "Lateral izq."
    ),
    subtitle = paste0(
      "Multiplicador tangencial α; amplificación gráfica Ag = ",
      AmplificationLabel,
      ". La lectura interactiva conserva las magnitudes físicas."
    ),
    plotHeight = 560
  )
}
