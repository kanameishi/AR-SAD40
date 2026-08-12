if (!exists("projectRoot", inherits = FALSE)) {
  stop("projectRoot must be defined before loading calculation results.", call. = FALSE)
}

loadCalculationResults <- function(
  projectRoot,
  calculationDirectory = file.path(projectRoot, "data", "calculation")
) {
  Root <- normalizePath(projectRoot, mustWork = TRUE)
  CalculationDirectory <- normalizePath(
    calculationDirectory,
    mustWork = TRUE
  )
  Paths <- list(
    inputs = file.path(CalculationDirectory, "calculation.inputs.csv"),
    section = file.path(CalculationDirectory, "section.properties.csv"),
    stress = file.path(CalculationDirectory, "stress.state.csv"),
    loads = file.path(CalculationDirectory, "perimeter.loads.csv"),
    resultants = file.path(CalculationDirectory, "section.resultants.csv"),
    extrema = file.path(CalculationDirectory, "section.extrema.csv"),
    controls = file.path(CalculationDirectory, "numerical.controls.csv"),
    scales = file.path(CalculationDirectory, "display.scales.csv"),
    config = file.path(CalculationDirectory, "calculation.config.json")
  )
  readProduct <- function(path, required) {
    if (!file.exists(path)) {
      stop("The calculation product is not available: ", path, call. = FALSE)
    }
    Data <- utils::read.csv(
      path,
      check.names = FALSE,
      stringsAsFactors = FALSE,
      na.strings = ""
    )
    Missing <- setdiff(required, names(Data))
    if (length(Missing) > 0L) {
      stop(
        basename(path), " is missing: ", paste(Missing, collapse = ", "), ".",
        call. = FALSE
      )
    }
    Data
  }

  Config <- validateCalculationConfig(readCalculationJson(Paths$config))
  SectionData <- readProduct(
    Paths$section,
    c(
      "scenarioId", "sectionId", "profileId", "propertyModelId",
      "analysisBaseThicknessMm", "lowerReferenceRowId", "upperReferenceRowId",
      "interpolationFraction", "areaMm2PerMm", "inertiaMm4PerMm",
      "circumferentialYoungModulusGPa", "analysisRadiusM",
      "extensionalRigidityKnPerM", "flexuralRigidityKnM2PerM", "sectionRatio",
      "evidenceLevel", "sourceKey", "sourceLocator", "domainStatus"
    )
  )
  StressData <- readProduct(
    Paths$stress,
    c(
      "scenarioId", "stressStateId", "modelId", "statePointId", "layerId",
      "thetaIndex", "thetaRad", "depthM", "effectiveVerticalKPa",
      "frictionAngleDeg", "poissonRatio", "ocr", "ocrMaximum", "k0Input",
      "k0Derived", "k0Applied", "horizontalIncrementKPa",
      "horizontalIncrementStatus", "effectiveHorizontalKPa",
      "waterPressureDifferenceKPa", "domainStatus", "k0EvidenceLevel",
      "evidenceLevel", "sourceKey", "sourceLocator"
    )
  )
  Resultants <- readProduct(
    Paths$resultants,
    c(
      "scenarioId", "caseId", "sectionId", "stressStateId", "alpha",
      "resultantId", "thetaIndex", "thetaRad", "thetaDeg", "value", "unit",
      "evidenceLevel"
    )
  )
  ExtremaData <- readProduct(
    Paths$extrema,
    c(
      "scenarioId", "caseId", "alpha", "resultantId", "statisticId", "value",
      "signedValue", "thetaRad", "thetaDeg", "unit", "evidenceLevel"
    )
  )
  Controls <- readProduct(
    Paths$controls,
    c(
      "scenarioId", "caseId", "alpha", "controlId", "resultantId", "metricId",
      "observedValue", "comparison", "limitValue", "unit", "pass",
      "thetaPointCount", "integrationSteps", "evidenceLevel"
    )
  )
  Scales <- readProduct(
    Paths$scales,
    c(
      "scenarioId", "resultantId", "referenceRadiusM", "displayScale",
      "maximumAbsoluteValue", "resultantUnit", "radialFraction",
      "graphicAmplification", "ordinateCount", "evidenceLevel"
    )
  )
  if (nrow(SectionData) != 1L || nrow(StressData) != 1L ||
      nrow(Resultants) == 0L || nrow(ExtremaData) == 0L ||
      nrow(Controls) == 0L || nrow(Scales) != 3L) {
    stop("The calculation products have incompatible row counts.", call. = FALSE)
  }
  ScenarioIds <- unique(c(
    SectionData$scenarioId,
    StressData$scenarioId,
    Resultants$scenarioId,
    ExtremaData$scenarioId,
    Controls$scenarioId,
    Scales$scenarioId
  ))
  if (length(ScenarioIds) != 1L || ScenarioIds != Config$scenarioId) {
    stop("The calculation products do not share the configured scenarioId.", call. = FALSE)
  }
  if (!all(Controls$pass)) {
    stop("One or more materialized numerical controls failed.", call. = FALSE)
  }

  ReferencePath <- file.path(Root, Config$section$propertyTable)
  Reference <- utils::read.csv(
    ReferencePath,
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  Lower <- Reference[
    Reference$referenceRowId == SectionData$lowerReferenceRowId,
    ,
    drop = FALSE
  ]
  Upper <- Reference[
    Reference$referenceRowId == SectionData$upperReferenceRowId,
    ,
    drop = FALSE
  ]
  if (nrow(Lower) != 1L || nrow(Upper) != 1L) {
    stop("The section product does not resolve to two reference rows.", call. = FALSE)
  }

  valueAt <- function(caseId, resultantId, angle) {
    Data <- Resultants[
      Resultants$caseId == caseId & Resultants$resultantId == resultantId,
      ,
      drop = FALSE
    ]
    Data$value[which.min(abs(Data$thetaRad - angle))]
  }
  extremumAt <- function(caseId, resultantId, statisticId, field = "value") {
    Data <- ExtremaData[
      ExtremaData$caseId == caseId &
        ExtremaData$resultantId == resultantId &
        ExtremaData$statisticId == statisticId,
      ,
      drop = FALSE
    ]
    if (nrow(Data) != 1L) {
      stop("An expected resultant extremum is missing or duplicated.", call. = FALSE)
    }
    Data[[field]][1L]
  }
  CaseRows <- lapply(seq_len(nrow(Config$loadCases)), function(Index) {
    CaseId <- Config$loadCases$caseId[Index]
    Alpha <- Config$loadCases$alpha[Index]
    MomentMinimum <- extremumAt(CaseId, "M", "minimum")
    MomentMaximum <- extremumAt(CaseId, "M", "maximum")
    data.frame(
      caseId = CaseId,
      prescription = paste0(
        "Componente tangencial: α = ",
        formatC(Alpha, format = "f", digits = 2)
      ),
      tangentialMultiplier = Alpha,
      normalCrownInvert = valueAt(CaseId, "N", 0),
      normalSidewalls = valueAt(CaseId, "N", pi / 2),
      normalMinimum = extremumAt(CaseId, "N", "minimum"),
      normalMaximum = extremumAt(CaseId, "N", "maximum"),
      momentCrownInvert = valueAt(CaseId, "M", 0),
      momentSidewalls = valueAt(CaseId, "M", pi / 2),
      momentMinimum = MomentMinimum,
      momentMaximum = MomentMaximum,
      maximumAbsoluteShear = extremumAt(CaseId, "Q", "absolute-maximum"),
      meanMoment = (MomentMinimum + MomentMaximum) / 2,
      stringsAsFactors = FALSE
    )
  })
  Extrema <- do.call(rbind, CaseRows)

  CaseParagraphs <- vapply(seq_len(nrow(Extrema)), function(Index) {
    Row <- Extrema[Index, , drop = FALSE]
    paste0(
      "Para $\\alpha=", formatCalculationGeneral(Row$tangentialMultiplier, 4L),
      "$ se obtiene\n\n$$\n",
      formatCalculationFixed(Row$normalMinimum, 1L),
      "\\le N_\\theta\\le ",
      formatCalculationFixed(Row$normalMaximum, 1L),
      "\\ \\mathrm{kN/m},\\qquad\n",
      formatCalculationFixed(Row$momentMinimum, 2L),
      "\\le M_\\theta\\le ",
      formatCalculationFixed(Row$momentMaximum, 2L),
      "\\ \\mathrm{kN\\,m/m},\n$$\n\n",
      "con $|Q_\\theta|_{\\max}=",
      formatCalculationFixed(Row$maximumAbsoluteShear, 2L),
      "$ kN/m."
    )
  }, character(1))

  EndpointComparison <- ""
  Zero <- which(abs(Extrema$tangentialMultiplier) < 1e-12)
  One <- which(abs(Extrema$tangentialMultiplier - 1) < 1e-12)
  if (length(Zero) == 1L && length(One) == 1L) {
    NormalAmplitudeZero <-
      (Extrema$normalMaximum[Zero] - Extrema$normalMinimum[Zero]) / 2
    NormalAmplitudeOne <-
      (Extrema$normalMaximum[One] - Extrema$normalMinimum[One]) / 2
    MomentAmplitudeZero <-
      (Extrema$momentMaximum[Zero] - Extrema$momentMinimum[Zero]) / 2
    MomentAmplitudeOne <-
      (Extrema$momentMaximum[One] - Extrema$momentMinimum[One]) / 2
    EndpointComparison <- paste0(
      "Entre $\\alpha=0$ y $\\alpha=1$, la amplitud variable de ",
      "$N_\\theta$ aumenta por un factor ",
      formatCalculationGeneral(NormalAmplitudeOne / NormalAmplitudeZero, 4L),
      " y las amplitudes de $M_\\theta$ y $Q_\\theta$ por factores ",
      formatCalculationGeneral(MomentAmplitudeOne / MomentAmplitudeZero, 4L),
      " y ",
      formatCalculationGeneral(
        Extrema$maximumAbsoluteShear[One] /
          Extrema$maximumAbsoluteShear[Zero],
        4L
      ),
      ", respectivamente. Estos factores corresponden al estado de tensiones ",
      "declarado; la selección de $\\alpha$ para el revestimiento existente ",
      "requiere una hipótesis de transferencia tangencial compatible con el ",
      "relleno y el procedimiento constructivo."
    )
  }

  EffectiveMean <-
    (StressData$effectiveVerticalKPa + StressData$effectiveHorizontalKPa) / 2
  MeanPressure <- EffectiveMean + StressData$waterPressureDifferenceKPa
  StressDifference <-
    StressData$effectiveVerticalKPa - StressData$effectiveHorizontalKPa
  AlphaLabels <- paste0(
    "$\\alpha=",
    vapply(
      sort(Config$loadCases$alpha),
      formatCalculationGeneral,
      character(1),
      digits = 4L
    ),
    "$"
  )
  AlphaMarkdown <- if (length(AlphaLabels) == 1L) {
    AlphaLabels
  } else if (length(AlphaLabels) == 2L) {
    paste(AlphaLabels, collapse = " y ")
  } else {
    paste0(
      paste(utils::head(AlphaLabels, -1L), collapse = ", "),
      " y ",
      AlphaLabels[length(AlphaLabels)]
    )
  }
  Section <- as.list(SectionData[1L, , drop = FALSE])
  Section$nominalProfile <- paste0(
    formatCalculationGeneral(Config$section$nominalCorrugationPitchMm),
    "\\times",
    formatCalculationGeneral(Config$section$nominalCorrugationDepthMm)
  )
  Section$reportedThicknessMm <- Config$section$reportedThicknessMm
  Section$lowerThicknessMm <- Lower$baseThicknessMm
  Section$upperThicknessMm <- Upper$baseThicknessMm
  Section$lowerAreaMm2PerMm <- Lower$areaMm2PerMm
  Section$upperAreaMm2PerMm <- Upper$areaMm2PerMm
  Section$lowerInertiaMm4PerMm <- Lower$inertiaMm4PerMm
  Section$upperInertiaMm4PerMm <- Upper$inertiaMm4PerMm
  K0Description <- if (StressData$modelId == "adopted-constant") {
    paste(
      "El valor de $K_0$ es una hipótesis del escenario de comprobación y no",
      "el resultado de una estimación del relleno existente mediante la",
      "@sec-calculation-k0-estimation."
    )
  } else {
    paste(
      "El valor de $K_0$ se obtiene con la rama geotécnica declarada para el",
      "escenario. La selección de esa rama y de sus variables primitivas debe",
      "ser representativa del relleno existente."
    )
  }

  list(
    scenarioId = Config$scenarioId,
    config = Config,
    paths = Paths,
    geometry = list(
      insideDiameterM = Config$geometry$insideDiameterM,
      radiusM = SectionData$analysisRadiusM
    ),
    section = Section,
    stress = StressData[1L, , drop = FALSE],
    k0DescriptionMarkdown = K0Description,
    actions = list(
      tangentialMultipliers = Config$loadCases$alpha,
      tangentialMultiplierText = formatCalculationList(sort(Config$loadCases$alpha)),
      tangentialMultiplierMarkdown = AlphaMarkdown,
      meanPressureKPa = MeanPressure,
      stressDifferenceKPa = StressDifference,
      radialConstantKPa = -MeanPressure,
      radialHarmonicKPa = -StressDifference / 2,
      tangentialHarmonicKPa = StressDifference / 2
    ),
    numerics = list(
      maximumControlDifference = max(Controls$observedValue),
      controlTolerance = unique(Controls$limitValue),
      gridPoints = unique(Controls$thetaPointCount),
      integrationSteps = unique(Controls$integrationSteps)
    ),
    display = list(
      graphicAmplification = unique(Scales$graphicAmplification),
      raysPerCircle = unique(Scales$ordinateCount),
      radialFraction = unique(Scales$radialFraction)
    ),
    extrema = Extrema,
    controls = Controls,
    scales = Scales,
    caseSummaryMarkdown = paste(CaseParagraphs, collapse = "\n\n"),
    endpointComparisonMarkdown = EndpointComparison
  )
}

CalculationDirectory <- if (exists("calculationDirectory", inherits = FALSE)) {
  calculationDirectory
} else {
  file.path(projectRoot, "data", "calculation")
}
Calculation <- loadCalculationResults(projectRoot, CalculationDirectory)
