source("scripts/R/ringFigureData.R")

.readResultantGeometry <- function(
  pathCurves,
  pathScales,
  radius,
  graphicAmplification = 1,
  liningID = NULL,
  scaleMode = c("provided", "local-by-lining-and-resultant"),
  curves = NULL,
  scales = NULL
) {
  scaleMode <- match.arg(scaleMode)
  UseData <- !is.null(curves) || !is.null(scales)
  if (UseData) {
    if (!is.data.frame(curves) || !is.data.frame(scales)) {
      stop("curves and scales must both be data frames.", call. = FALSE)
    }
    Curves <- curves
    Scales <- scales
  } else {
    if (!file.exists(pathCurves) || !file.exists(pathScales)) {
      stop("The calculation result files are not available.", call. = FALSE)
    }
    Curves <- utils::read.csv(pathCurves, check.names = FALSE)
    Scales <- utils::read.csv(pathScales, check.names = FALSE)
  }
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
    ModelLabels <- c(
      `prescribed-biaxial-direct-integration` = "Integración directa",
      `schwartz-einstein-external-loading` =
        "Schwartz–Einstein uniforme",
      `schwartz-einstein-balanced-gradient-hybrid` =
        "Modelo híbrido"
    )
    InterfaceLabels <- c(
      fullTraction = "proyección tangencial completa",
      `full-traction` = "proyección tangencial completa",
      normalOnly = "proyección normal",
      `normal-only` = "proyección normal",
      fullSlip = "Slip (S)",
      `full-slip` = "Slip (S)",
      noSlip = "No Slip (NS)",
      `no-slip` = "No Slip (NS)"
    )
    StageLabels <- c(`completed-fill` = "Relleno completado")
    Stages <- unname(StageLabels[Curves$stageID])
    Models <- unname(ModelLabels[Curves$interactionModelID])
    Interfaces <- unname(InterfaceLabels[Curves$interfaceID])
    if (anyNA(Interfaces) || anyNA(Stages) || anyNA(Models)) {
      stop("A public interaction label is not available.", call. = FALSE)
    }
    Prescriptions <- paste(Models, Interfaces, sep = ": ")
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
    if (!("tangentialMultiplier" %in% names(Curves))) {
      stop(
        "The calculation cases lack an interface or tangential multiplier.",
        call. = FALSE
      )
    }
    Multipliers <- tapply(
      Curves$tangentialMultiplier,
      Curves$caseID,
      unique
    )
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
        "Multiplicador tangencial: ",
        formatC(Curves$tangentialMultiplier, format = "f", digits = 2)
      ),
      tangentialMultiplier = Curves$tangentialMultiplier,
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
  if (identical(scaleMode, "local-by-lining-and-resultant")) {
    if (any(!is.finite(Scales$maximumAbsoluteValue)) ||
        any(Scales$maximumAbsoluteValue <= 0)) {
      stop(
        "Local display scaling requires positive resultant maxima.",
        call. = FALSE
      )
    }
    Scales$displayScale <-
      Scales$radialFraction * radius / Scales$maximumAbsoluteValue
  }
  Geometry <- prepareRingDiagram(
    Curves,
    Scales,
    radius,
    graphicAmplification = graphicAmplification
  )
  Geometry$scaleMode <- scaleMode
  Geometry <- Geometry[order(
    match(as.character(Geometry$case), CaseOrder),
    match(as.character(Geometry$resultant), c("N", "M", "Q")),
    Geometry$thetaIndex
  ), , drop = FALSE]
  rownames(Geometry) <- NULL
  Geometry
}

buildCalculationResultantsInteractive <- function(
  pathCurves,
  pathScales,
  radius,
  graphicAmplification = 1,
  raysPerCircle = 36L,
  resultant = c("N", "M", "Q"),
  liningID = NULL,
  scaleMode = c("provided", "local-by-lining-and-resultant"),
  curves = NULL,
  scales = NULL,
  caseLabels = NULL
) {
  scaleMode <- match.arg(scaleMode)
  Geometry <- .readResultantGeometry(
    pathCurves = pathCurves,
    pathScales = pathScales,
    radius = radius,
    graphicAmplification = graphicAmplification,
    liningID = liningID,
    scaleMode = scaleMode,
    curves = curves,
    scales = scales
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
  if (!is.null(caseLabels)) {
    if (!is.character(caseLabels) || is.null(names(caseLabels)) ||
        !setequal(names(caseLabels), as.character(Cases)) ||
        anyNA(caseLabels) || any(!nzchar(caseLabels))) {
      stop(
        "caseLabels must assign one label to every case.",
        call. = FALSE
      )
    }
    Geometry$prescription <- unname(
      caseLabels[as.character(Geometry$case)]
    )
  }
  Rays <- prepareRingRays(
    geometry = Geometry,
    baselineRadius = radius,
    raysPerCircle = raysPerCircle,
    phaseDegByCase = stats::setNames(
      ((seq_along(Cases) - 1L) * 5) %% 10,
      Cases
    )
  )
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
    plotHeight = 560
  )
  highcharter::hc_tooltip(
    Plot,
    useHTML = TRUE,
    formatter = htmlwidgets::JS(paste0(
      "function () {",
      "if (!this.point.custom) return false;",
      "return '<b>' + this.series.name + '</b><br/>' +",
      "'&theta; = ' + Highcharts.numberFormat(this.point.custom.thetaDeg, 1) + '&deg;<br/>' +",
      "this.point.custom.resultant + ' = ' + Highcharts.numberFormat(this.point.custom.value, 1) + ' ' + this.point.custom.unit;",
      "}"
    ))
  )
}
