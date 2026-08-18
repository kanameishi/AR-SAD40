source("scripts/R/ringFigureData.R")

.readLinerResultantGeometry <- function(
  pathCurves,
  pathScales,
  radius,
  graphicAmplification = 1,
  liningID = NULL
) {
  if (!file.exists(pathCurves) || !file.exists(pathScales)) {
    stop("The calculation result files are not available.", call. = FALSE)
  }
  Curves <- utils::read.csv(pathCurves, check.names = FALSE)
  Scales <- utils::read.csv(pathScales, check.names = FALSE)
  RequiredCurves <- c(
    "caseID", "resultantID", "thetaIndex", "thetaRad", "thetaDeg",
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
  if (!is.null(liningID)) {
    if (!is.character(liningID) || length(liningID) != 1L ||
        !nzchar(liningID) ||
        !("liningID" %in% names(Curves)) ||
        !("liningID" %in% names(Scales))) {
      stop("liningID must identify one concrete alternative.", call. = FALSE)
    }
    Curves <- Curves[
      Curves[["liningID", exact = TRUE]] == liningID,
      ,
      drop = FALSE
    ]
    Scales <- Scales[
      Scales[["liningID", exact = TRUE]] == liningID,
      ,
      drop = FALSE
    ]
    if (nrow(Curves) == 0L || nrow(Scales) == 0L) {
      stop("The requested concrete diagram is unavailable.", call. = FALSE)
    }
  }
  if ("interfaceID" %in% names(Curves)) {
    Fields <- c("stageID", "interactionModelID")
    Missing <- setdiff(Fields, names(Curves))
    if (length(Missing) > 0L) {
      stop("The interaction resultants lack their stage or model.", call. = FALSE)
    }
    InterfaceLabels <- c(
      fullTraction = "Proyección tangencial completa (α = 1)",
      `full-traction` = "Proyección tangencial completa (α = 1)",
      normalOnly = "Acción exclusivamente normal (α = 0)",
      `normal-only` = "Acción exclusivamente normal (α = 0)",
      fullSlip = "Schwartz–Einstein: deslizamiento libre",
      `full-slip` = "Schwartz–Einstein: deslizamiento libre",
      noSlip = "Schwartz–Einstein: sin deslizamiento",
      `no-slip` = "Schwartz–Einstein: sin deslizamiento"
    )
    Prescriptions <- unname(InterfaceLabels[Curves$interfaceID])
    StageLabels <- c(`completed-fill` = "Relleno completado")
    ModelLabels <- c(
      `prescribed-biaxial-direct-integration` = "Integración directa",
      `schwartz-einstein-external-loading` =
        "Interacción elástica de carga externa",
      `schwartz-einstein-balanced-gradient-hybrid` =
        "Interacción E–S con gradiente geostático equilibrado"
    )
    Stages <- unname(StageLabels[Curves$stageID])
    Models <- unname(ModelLabels[Curves$interactionModelID])
    if (anyNA(Prescriptions) || anyNA(Stages) || anyNA(Models)) {
      stop("A public interaction label is not available.", call. = FALSE)
    }
    CaseOrder <- unique(Curves$caseID)
    Curves <- data.frame(
      case = Curves$caseID,
      stage = Stages,
      model = Models,
      prescription = Prescriptions,
      interfaceID = Curves$interfaceID,
      resultant = Curves$resultantID,
      thetaIndex = Curves$thetaIndex,
      theta = Curves$thetaRad,
      thetaDeg = Curves$thetaDeg,
      value = Curves$value,
      unit = Curves$unit,
      evidenceLevel = Curves$evidenceLevel,
      stringsAsFactors = FALSE
    )
  } else {
    if (!("alpha" %in% names(Curves))) {
      stop("The calculation cases lack an interface or alpha.", call. = FALSE)
    }
    Multipliers <- tapply(Curves$alpha, Curves$caseID, unique)
    if (any(lengths(Multipliers) != 1L) ||
        any(!is.finite(unlist(Multipliers)))) {
      stop(
        "Each biaxial-control case requires one tangential multiplier.",
        call. = FALSE
      )
    }
    CaseOrder <- names(sort(unlist(Multipliers), decreasing = TRUE))
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
  }
  Scales <- data.frame(
    resultant = Scales$resultantID,
    displayScale = Scales$displayScale,
    maximumAbsoluteValue = Scales$maximumAbsoluteValue,
    unit = Scales$resultantUnit,
    radialFraction = Scales$radialFraction,
    stringsAsFactors = FALSE
  )
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

buildLinerResultantsPlot <- function(
  pathCurves,
  pathScales,
  radius,
  graphicAmplification = 1,
  raysPerCircle = 36L,
  resultant = c("N", "M", "Q"),
  liningID = NULL
) {
  Geometry <- .readLinerResultantGeometry(
    pathCurves = pathCurves,
    pathScales = pathScales,
    radius = radius,
    graphicAmplification = graphicAmplification,
    liningID = liningID
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
  SubtitlePrefix <- if ("interfaceID" %in% names(Geometry)) {
    "Proyecciones de la acción prescrita"
  } else {
    "Multiplicador tangencial α"
  }
  Plot <- NGR::buildSectionResultantsPlot(
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
      SubtitlePrefix, "; amplificación gráfica Ag = ",
      AmplificationLabel,
      ". La lectura interactiva conserva las magnitudes físicas."
    ),
    plotHeight = 560
  )
  highcharter::hc_tooltip(
    Plot,
    useHTML = TRUE,
    formatter = htmlwidgets::JS(paste0(
      "function () {",
      "if (!this.point.custom) return false;",
      "return '<b>' + this.series.name + '</b><br/>' + ",
      "'&theta; = ' + Highcharts.numberFormat(this.point.custom.thetaDeg, 1) + '&deg;<br/>' + ",
      "this.point.custom.resultant + ' = ' + Highcharts.numberFormat(this.point.custom.value, 0) + ' ' + this.point.custom.unit;",
      "}"
    ))
  )
}
