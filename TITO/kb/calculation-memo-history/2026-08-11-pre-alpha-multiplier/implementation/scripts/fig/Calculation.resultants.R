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
  if (!"interfaceFrictionCoefficient" %in% names(Curves)) {
    stop(
      "The calculation curves require interfaceFrictionCoefficient.",
      call. = FALSE
    )
  }
  Coefficients <- tapply(
    Curves$interfaceFrictionCoefficient,
    Curves$case,
    unique
  )
  if (any(lengths(Coefficients) != 1L) ||
      any(!is.finite(unlist(Coefficients)))) {
    stop(
      "Each calculation case requires one interface friction coefficient.",
      call. = FALSE
    )
  }
  CaseOrder <- names(sort(unlist(Coefficients), decreasing = TRUE))
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
  graphicAmplification = 1
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
    raysPerCircle = 36L
  )
}

buildCalculationResultantsInteractive <- function(
  pathCurves,
  pathScales,
  radius,
  graphicAmplification = 1
) {
  MinimumNgrVersion <- package_version("0.3.10")
  if (!requireNamespace("NGR", quietly = TRUE) ||
      utils::packageVersion("NGR") < MinimumNgrVersion ||
      !exists(
        "buildSectionResultantsPlot",
        envir = asNamespace("NGR"),
        inherits = FALSE
      )) {
    stop(
      "NGR 0.3.10 or later with buildSectionResultantsPlot() is required.",
      call. = FALSE
    )
  }
  Geometry <- .readResultantGeometry(
    pathCurves,
    pathScales,
    radius,
    graphicAmplification
  )
  Cases <- unique(Geometry$case)
  Rays <- prepareRingRays(
    geometry = Geometry,
    baselineRadius = radius,
    raysPerCircle = 36L,
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
      right = "Hastial",
      bottom = "Solera",
      left = "Hastial"
    ),
    subtitle = paste0(
      "Coeficiente de interfaz αδ = tan(δ); amplificación gráfica Ag = ",
      AmplificationLabel,
      ". La lectura interactiva conserva las magnitudes físicas."
    ),
    plotHeight = 560
  )
}
