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
    sheetFlexuralBound = file.path(
      CalculationDirectory,
      "sheet.flexural.bound.csv"
    ),
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
  SectionFields <- if (
    Config$section$propertyModelID == "published-exact-row"
  ) {
    c(
      "referenceRowID", "nominalPitchMm", "nominalDepthMm",
      "actualPitchMm", "actualDepthMm", "corrugationRadiusMm",
      "specifiedThicknessMm", "designBaseThicknessMm", "tangentLengthMm",
      "tangentAngleDeg", "sectionModulusMm3PerMm", "gyrationRadiusMm",
      "developedWidthFactor", "propertyEvidenceLevel",
      "rigidityEvidenceLevel"
    )
  } else {
    c(
      "analysisBaseThicknessMm", "lowerReferenceRowID",
      "upperReferenceRowID", "interpolationFraction"
    )
  }
  SectionData <- readProduct(
    Paths$section,
    c(
      "scenarioID", "sectionID", "profileID", "propertyModelID",
      SectionFields, "areaMm2PerMm", "inertiaMm4PerMm",
      "circumferentialYoungModulusGPa", "analysisRadiusM",
      "extensionalRigidityKnPerM", "flexuralRigidityKnM2PerM", "sectionRatio",
      "evidenceLevel", "sourceKey", "sourceLocator", "domainStatus"
    )
  )
  StressData <- readProduct(
    Paths$stress,
    c(
      "scenarioID", "stressStateID", "modelID", "actionModelID",
      "statePointID", "layerID",
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
      "scenarioID", "caseID", "sectionID", "stressStateID", "alpha",
      "resultantID", "thetaIndex", "thetaRad", "thetaDeg", "value", "unit",
      "evidenceLevel"
    )
  )
  ExtremaData <- readProduct(
    Paths$extrema,
    c(
      "scenarioID", "caseID", "alpha", "resultantID", "statisticID", "value",
      "signedValue", "thetaRad", "thetaDeg", "unit", "evidenceLevel"
    )
  )
  Controls <- readProduct(
    Paths$controls,
    c(
      "scenarioID", "caseID", "alpha", "controlID", "resultantID", "metricID",
      "observedValue", "comparison", "limitValue", "unit", "pass",
      "thetaPointCount", "integrationSteps", "evidenceLevel"
    )
  )
  Scales <- readProduct(
    Paths$scales,
    c(
      "scenarioID", "resultantID", "referenceRadiusM", "displayScale",
      "maximumAbsoluteValue", "resultantUnit", "radialFraction",
      "graphicAmplification", "ordinateCount", "evidenceLevel"
    )
  )
  SheetFlexural <- if (is.null(Config$sheetAssessment)) {
    NULL
  } else {
    readProduct(
      Paths$sheetFlexuralBound,
      c(
        "scenarioID", "caseID", "alpha", "sectionID", "thetaRad",
        "thetaDeg", "normalForceKnPerM", "shearForceKnPerM",
        "normalBranchID", "standardID", "materialSpecificationID",
        "forceEffectStatus", "boundScopeID", "yieldStrengthMPa",
        "areaMm2PerMm", "inertiaMm4PerMm",
        "sectionModulusMm3PerMm", "bendingMomentKnMPerM",
        "absoluteMomentKnMPerM", "extremeFiberDistanceMm",
        "plasticModulusBoundMm3PerMm", "reserveBoundKnMPerM",
        "plasticBoundKnMPerM", "nominalBoundKnMPerM", "boundBasisID",
        "demandBoundRatio", "screenStatus", "evidenceLevel", "sourceKey",
        "sourceLocator"
      )
    )
  }
  if (nrow(SectionData) != 1L || nrow(StressData) != 1L ||
      nrow(Resultants) == 0L || nrow(ExtremaData) == 0L ||
      nrow(Controls) == 0L || nrow(Scales) != 3L) {
    stop("The calculation products have incompatible row counts.", call. = FALSE)
  }
  if (!is.null(SheetFlexural) &&
      (nrow(SheetFlexural) != nrow(Config$loadCases) ||
        anyDuplicated(SheetFlexural$caseID))) {
    stop("The sheet-flexural product has incompatible rows.", call. = FALSE)
  }
  ScenarioIDs <- unique(c(
    SectionData$scenarioID,
    StressData$scenarioID,
    Resultants$scenarioID,
    ExtremaData$scenarioID,
    Controls$scenarioID,
    Scales$scenarioID,
    if (!is.null(SheetFlexural)) SheetFlexural$scenarioID
  ))
  if (length(ScenarioIDs) != 1L || ScenarioIDs != Config$scenarioID) {
    stop("The calculation products do not share the configured scenarioID.", call. = FALSE)
  }
  if (!all(Controls$pass)) {
    stop("One or more materialized numerical controls failed.", call. = FALSE)
  }
  ClosedControls <- Controls[
    Controls$controlID == "closed-form-resultants",
    ,
    drop = FALSE
  ]
  BalanceControls <- Controls[
    Controls$controlID == "global-equilibrium",
    ,
    drop = FALSE
  ]
  if (nrow(ClosedControls) == 0L || nrow(BalanceControls) == 0L ||
      length(unique(ClosedControls$limitValue)) != 1L ||
      length(unique(BalanceControls$limitValue)) != 1L) {
    stop("The materialized numerical controls are incomplete.", call. = FALSE)
  }
  maximumClosedDifference <- function(resultantID) {
    Values <- ClosedControls$observedValue[
      ClosedControls$resultantID == resultantID
    ]
    if (length(Values) == 0L || any(!is.finite(Values))) {
      stop("A closed-form control is missing.", call. = FALSE)
    }
    max(Values)
  }

  ReferencePath <- file.path(Root, Config$section$propertyTable)
  Reference <- utils::read.csv(
    ReferencePath,
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  if (Config$section$propertyModelID == "published-exact-row") {
    ReferenceRow <- Reference[
      Reference$referenceRowID == SectionData$referenceRowID,
      ,
      drop = FALSE
    ]
    if (nrow(ReferenceRow) != 1L) {
      stop("The section product does not resolve to one reference row.", call. = FALSE)
    }
  } else {
    Lower <- Reference[
      Reference$referenceRowID == SectionData$lowerReferenceRowID,
      ,
      drop = FALSE
    ]
    Upper <- Reference[
      Reference$referenceRowID == SectionData$upperReferenceRowID,
      ,
      drop = FALSE
    ]
    if (nrow(Lower) != 1L || nrow(Upper) != 1L) {
      stop("The section product does not resolve to two reference rows.", call. = FALSE)
    }
  }

  valueAt <- function(caseID, resultantID, angle) {
    Data <- Resultants[
      Resultants$caseID == caseID & Resultants$resultantID == resultantID,
      ,
      drop = FALSE
    ]
    Data$value[which.min(abs(Data$thetaRad - angle))]
  }
  extremumAt <- function(caseID, resultantID, statisticID, field = "value") {
    Data <- ExtremaData[
      ExtremaData$caseID == caseID &
        ExtremaData$resultantID == resultantID &
        ExtremaData$statisticID == statisticID,
      ,
      drop = FALSE
    ]
    if (nrow(Data) != 1L) {
      stop("An expected resultant extremum is missing or duplicated.", call. = FALSE)
    }
    Data[[field]][1L]
  }
  CaseRows <- lapply(seq_len(nrow(Config$loadCases)), function(i) {
    CaseID <- Config$loadCases$caseID[i]
    Alpha <- Config$loadCases$alpha[i]
    MomentMinimum <- extremumAt(CaseID, "M", "minimum")
    MomentMaximum <- extremumAt(CaseID, "M", "maximum")
    data.frame(
      caseID = CaseID,
      prescription = paste0(
        "Componente tangencial: α = ",
        formatC(Alpha, format = "f", digits = 2)
      ),
      tangentialMultiplier = Alpha,
      normalCrownInvert = valueAt(CaseID, "N", 0),
      normalSidewalls = valueAt(CaseID, "N", pi / 2),
      normalMinimum = extremumAt(CaseID, "N", "minimum"),
      normalMaximum = extremumAt(CaseID, "N", "maximum"),
      momentCrownInvert = valueAt(CaseID, "M", 0),
      momentSidewalls = valueAt(CaseID, "M", pi / 2),
      momentMinimum = MomentMinimum,
      momentMaximum = MomentMaximum,
      maximumAbsoluteShear = extremumAt(CaseID, "Q", "absolute-maximum"),
      meanNormal = (
        extremumAt(CaseID, "N", "minimum") +
          extremumAt(CaseID, "N", "maximum")
      ) / 2,
      meanMoment = (MomentMinimum + MomentMaximum) / 2,
      stringsAsFactors = FALSE
    )
  })
  Extrema <- do.call(rbind, CaseRows)

  CaseParagraphs <- vapply(seq_len(nrow(Extrema)), function(i) {
    Row <- Extrema[i, , drop = FALSE]
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
    NormalMaximumZero <- max(abs(c(
      Extrema$normalMinimum[Zero], Extrema$normalMaximum[Zero]
    )))
    NormalMaximumOne <- max(abs(c(
      Extrema$normalMinimum[One], Extrema$normalMaximum[One]
    )))
    MomentMaximumZero <- max(abs(c(
      Extrema$momentMinimum[Zero], Extrema$momentMaximum[Zero]
    )))
    MomentMaximumOne <- max(abs(c(
      Extrema$momentMinimum[One], Extrema$momentMaximum[One]
    )))
    EndpointComparison <- paste0(
      "Entre $\\alpha=0$ y $\\alpha=1$, la máxima compresión ",
      "circunferencial aumenta de ",
      formatCalculationFixed(NormalMaximumZero, 4L), " a ",
      formatCalculationFixed(NormalMaximumOne, 4L),
      " kN/m; el máximo absoluto del momento aumenta de ",
      formatCalculationFixed(MomentMaximumZero, 4L), " a ",
      formatCalculationFixed(MomentMaximumOne, 4L),
      " kN·m/m; y el máximo absoluto de la fuerza cortante aumenta de ",
      formatCalculationFixed(Extrema$maximumAbsoluteShear[Zero], 4L), " a ",
      formatCalculationFixed(Extrema$maximumAbsoluteShear[One], 4L),
      " kN/m."
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
  RadialMinimum <- -MeanPressure - abs(StressDifference / 2)
  RadialMaximum <- -MeanPressure + abs(StressDifference / 2)
  ActionCaseParagraphs <- vapply(
    sort(unique(Config$loadCases$alpha), decreasing = TRUE),
    function(alpha) {
      TangentialMaximum <- abs(alpha * StressDifference / 2)
      if (TangentialMaximum == 0) {
        return(paste0(
          "Para $\\alpha=", formatCalculationGeneral(alpha, 4L),
          "$ la componente tangencial es nula."
        ))
      }
      paste0(
        "Para $\\alpha=", formatCalculationGeneral(alpha, 4L),
        "$ la componente tangencial varía entre $",
        formatCalculationGeneral(-TangentialMaximum, 6L), "$ y $",
        formatCalculationGeneral(TangentialMaximum, 6L), "$ kPa."
      )
    },
    character(1)
  )
  ActionRangeMarkdown <- paste0(
    "La componente radial varía entre $",
    formatCalculationGeneral(RadialMinimum, 6L), "$ y $",
    formatCalculationGeneral(RadialMaximum, 6L), "$ kPa. ",
    paste(ActionCaseParagraphs, collapse = " ")
  )
  Section <- as.list(SectionData[1L, , drop = FALSE])
  Section$nominalProfile <- paste0(
    formatCalculationGeneral(Config$section$nominalCorrugationPitchMm),
    "\\times",
    formatCalculationGeneral(Config$section$nominalCorrugationDepthMm)
  )
  if (Config$section$propertyModelID == "published-exact-row") {
    Section$specifiedThicknessMm <- ReferenceRow$specifiedThicknessMm
    Section$designBaseThicknessMm <- ReferenceRow$designBaseThicknessMm
  } else {
    Section$reportedThicknessMm <- Config$section$reportedThicknessMm
    Section$lowerThicknessMm <- Lower$baseThicknessMm
    Section$upperThicknessMm <- Upper$baseThicknessMm
    Section$lowerAreaMm2PerMm <- Lower$areaMm2PerMm
    Section$upperAreaMm2PerMm <- Upper$areaMm2PerMm
    Section$lowerInertiaMm4PerMm <- Lower$inertiaMm4PerMm
    Section$upperInertiaMm4PerMm <- Upper$inertiaMm4PerMm
  }
  K0Description <- if (StressData$modelID == "adopted-constant") {
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
  SheetMaterialLabel <- ""
  SheetFlexuralSummary <- ""
  SheetFlexuralConclusion <- ""
  if (!is.null(SheetFlexural)) {
    MaterialLabels <- c(
      "ASTM-A36-assumed" = "acero ASTM A36, adoptado como hipótesis"
    )
    MaterialID <- unique(SheetFlexural$materialSpecificationID)
    if (length(MaterialID) != 1L || !(MaterialID %in% names(MaterialLabels))) {
      stop("The sheet material label is not available.", call. = FALSE)
    }
    SheetMaterialLabel <- unname(MaterialLabels[[MaterialID]])
    Count <- nrow(SheetFlexural)
    Count.exceeded <- sum(
      SheetFlexural$screenStatus == "prescriptive-bound-exceeded"
    )
    Compression <- sum(SheetFlexural$normalBranchID == "compression")
    Ratio.min <- min(SheetFlexural$demandBoundRatio)
    Ratio.max <- max(SheetFlexural$demandBoundRatio)
    SheetFlexuralSummary <- if (
      Count.exceeded == Count && Compression == Count
    ) {
      paste0(
        "En los ", Count,
        " casos, el máximo absoluto del momento ocurre con compresión ",
        "concurrente y supera la cota nominal. Los cocientes $\\rho_M$ ",
        "varían entre ", formatCalculationFixed(Ratio.min, 3L), " y ",
        formatCalculationFixed(Ratio.max, 3L), "."
      )
    } else if (Count.exceeded > 0L) {
      paste0(
        "La cota nominal se supera en ", Count.exceeded, " de ", Count,
        " casos. Los cocientes $\\rho_M$ varían entre ",
        formatCalculationFixed(Ratio.min, 3L), " y ",
        formatCalculationFixed(Ratio.max, 3L), "."
      )
    } else {
      paste0(
        "Ninguno de los ", Count,
        " casos supera la cota nominal; este resultado no demuestra ",
        "suficiencia resistente."
      )
    }
    SheetFlexuralConclusion <- if (
      Count.exceeded == Count && Compression == Count
    ) {
      paste(
        "La demanda de momento excede, por sí sola, la cota superior de las",
        "rutas prescriptivas F2--F4. La compresión concurrente sólo",
        "incrementa la relación H1.2; por ello, completar los modos de pandeo",
        "no puede revertir este descarte."
      )
    } else if (Count.exceeded > 0L) {
      paste(
        "Los casos con $\\rho_M>1$ exceden la cota superior de las rutas",
        "prescriptivas F2--F4. Los demás casos requieren calcular las",
        "resistencias aplicables antes de formular una conclusión."
      )
    } else {
      paste(
        "La cota superior no fue superada. Esta comparación unilateral no",
        "demuestra suficiencia y deben calcularse las resistencias aplicables."
      )
    }
  }
  list(
    scenarioID = Config$scenarioID,
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
      tangentialHarmonicKPa = StressDifference / 2,
      rangeMarkdown = ActionRangeMarkdown
    ),
    numerics = list(
      maximumControlDifference = max(ClosedControls$observedValue),
      maximumNormalDifference = maximumClosedDifference("N"),
      maximumMomentDifference = maximumClosedDifference("M"),
      maximumShearDifference = maximumClosedDifference("Q"),
      controlTolerance = unique(ClosedControls$limitValue),
      maximumGlobalEquilibriumResidual = max(BalanceControls$observedValue),
      balanceTolerance = unique(BalanceControls$limitValue),
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
    sheetFlexural = SheetFlexural,
    sheetMaterialLabel = SheetMaterialLabel,
    sheetFlexuralSummaryMarkdown = SheetFlexuralSummary,
    sheetFlexuralConclusionMarkdown = SheetFlexuralConclusion,
    caseSummaryMarkdown = paste(CaseParagraphs, collapse = "\n\n"),
    endpointComparisonMarkdown = EndpointComparison
  )
}

if (!exists("calculationResultsLoadOnly", inherits = FALSE) ||
    !isTRUE(calculationResultsLoadOnly)) {
  CalculationDirectory <- if (exists("calculationDirectory", inherits = FALSE)) {
    calculationDirectory
  } else {
    file.path(projectRoot, "data", "calculation")
  }
  Calculation <- loadCalculationResults(projectRoot, CalculationDirectory)
}
