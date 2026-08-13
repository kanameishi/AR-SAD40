if (!exists("calculateRingSection", mode = "function") ||
    !exists("estimateK0", mode = "function") ||
    !exists("calculateEffectiveStressState", mode = "function") ||
    !exists("selectCorrugatedSection", mode = "function") ||
    !exists("interpolateCorrugatedSection", mode = "function") ||
    !exists("buildThetaMesh", mode = "function") ||
    !exists("calculatePerimeterActions", mode = "function") ||
    !exists("calculateSectionResultants", mode = "function") ||
    !exists("calculateScenario", mode = "function") ||
    !exists("readCalculationJson", mode = "function")) {
  stop(
    paste(
      "Source scripts/setup/utils.R, scripts/R/ringDirect.R and",
      "scripts/R/ringLoads.R, scripts/R/k0Models.R and",
      "scripts/R/stressState.R, scripts/R/corrugatedSection.R and",
      "scripts/R/perimeterActions.R, scripts/R/sectionResultants.R and",
      "scripts/R/calculateScenario.R before",
      "scripts/R/calculationData.R."
    ),
    call. = FALSE
  )
}

.buildPerimeterLoadTable <- function(actions, cases, scenarioID, stressStateID) {
  LIST <- lapply(seq_len(nrow(cases)), function(i) {
    Values <- actions[[i]]$values
    rbind(
      data.frame(
        scenarioID = scenarioID,
        caseID = cases$caseID[i],
        stressStateID = stressStateID,
        alpha = cases$alpha[i],
        componentID = "radial",
        thetaIndex = seq_len(nrow(Values)) - 1L,
        thetaRad = Values$theta,
        thetaDeg = Values$theta * 180 / pi,
        valueKPa = Values$radialOutward,
        evidenceLevel = "DE",
        stringsAsFactors = FALSE
      ),
      data.frame(
        scenarioID = scenarioID,
        caseID = cases$caseID[i],
        stressStateID = stressStateID,
        alpha = cases$alpha[i],
        componentID = "tangential",
        thetaIndex = seq_len(nrow(Values)) - 1L,
        thetaRad = Values$theta,
        thetaDeg = Values$theta * 180 / pi,
        valueKPa = Values$tangentialPositive,
        evidenceLevel = "DE",
        stringsAsFactors = FALSE
      )
    )
  })
  OUT <- do.call(rbind, LIST)
  rownames(OUT) <- NULL
  OUT
}

.requireObject <- function(value, path) {
  if (!is.list(value) || is.null(names(value))) {
    stop(path, " must be one named JSON object.", call. = FALSE)
  }
  value
}

.requireFields <- function(object, required, optional = character(), path) {
  Names <- names(.requireObject(object, path))
  Missing <- setdiff(required, Names)
  Unexpected <- setdiff(Names, c(required, optional))
  if (length(Missing) > 0L) {
    stop(path, " is missing: ", paste(Missing, collapse = ", "), ".", call. = FALSE)
  }
  if (length(Unexpected) > 0L) {
    stop(
      path, " contains unsupported fields: ",
      paste(Unexpected, collapse = ", "), ".",
      call. = FALSE
    )
  }
  invisible(object)
}

.readText <- function(object, name, path) {
  Value <- object[[name]]
  if (!is.character(Value) || length(Value) != 1L || !nzchar(Value)) {
    stop(path, ".", name, " must be one non-empty string.", call. = FALSE)
  }
  Value
}

.readNumber <- function(
  object,
  name,
  path,
  minimum = -Inf,
  maximum = Inf,
  strictMinimum = FALSE,
  integer = FALSE
) {
  Value <- object[[name]]
  if (!is.numeric(Value) || length(Value) != 1L || !is.finite(Value)) {
    stop(path, ".", name, " must be one finite number.", call. = FALSE)
  }
  Below <- if (strictMinimum) Value <= minimum else Value < minimum
  if (Below || Value > maximum) {
    Relation <- if (strictMinimum) "greater than" else "at least"
    stop(
      path, ".", name, " must be ", Relation, " ", minimum,
      " and at most ", maximum, ".",
      call. = FALSE
    )
  }
  if (integer && Value != as.integer(Value)) {
    stop(path, ".", name, " must be an integer.", call. = FALSE)
  }
  if (integer) as.integer(Value) else as.numeric(Value)
}

.readNumberArray <- function(
  object,
  name,
  path,
  minimum = -Inf,
  maximum = Inf
) {
  Value <- object[[name]]
  if (!is.list(Value) && !is.numeric(Value)) {
    stop(path, ".", name, " must be a non-empty numeric array.", call. = FALSE)
  }
  Value <- unlist(Value, use.names = FALSE)
  if (length(Value) == 0L || !is.numeric(Value) || any(!is.finite(Value)) ||
      any(Value < minimum) || any(Value > maximum)) {
    stop(
      path, ".", name, " must contain finite values in [",
      minimum, ", ", maximum, "].",
      call. = FALSE
    )
  }
  as.numeric(Value)
}

.normaliseK0Model <- function(model) {
  Path <- "stressState.k0Model"
  .requireFields(
    model,
    required = "modelID",
    optional = c("k0", "frictionAngleDeg", "poissonRatio", "ocr", "ocrMaximum"),
    path = Path
  )
  ModelID <- .readText(model, "modelID", Path)
  BranchFields <- switch(
    ModelID,
    "adopted-constant" = "k0",
    "elastic-confined" = "poissonRatio",
    "jaky-nc" = "frictionAngleDeg",
    "mayne-kulhawy-unloading" = c("frictionAngleDeg", "ocr"),
    "mayne-kulhawy-reload" = c("frictionAngleDeg", "ocr", "ocrMaximum"),
    stop("Unsupported K0 modelID: ", ModelID, ".", call. = FALSE)
  )
  .requireFields(model, c("modelID", BranchFields), path = Path)
  Result <- list(modelID = ModelID)
  if ("k0" %in% BranchFields) {
    Result$k0 <- .readNumber(model, "k0", Path, minimum = 0)
  }
  if ("frictionAngleDeg" %in% BranchFields) {
    Result$frictionAngleDeg <- .readNumber(
      model,
      "frictionAngleDeg",
      Path,
      minimum = 0,
      maximum = 90,
      strictMinimum = TRUE
    )
    if (Result$frictionAngleDeg >= 90) {
      stop(Path, ".frictionAngleDeg must be less than 90.", call. = FALSE)
    }
  }
  if ("poissonRatio" %in% BranchFields) {
    Result$poissonRatio <- .readNumber(
      model,
      "poissonRatio",
      Path,
      minimum = 0,
      maximum = 0.5
    )
    if (Result$poissonRatio >= 0.5) {
      stop(Path, ".poissonRatio must be less than 0.5.", call. = FALSE)
    }
  }
  if ("ocr" %in% BranchFields) {
    Result$ocr <- .readNumber(model, "ocr", Path, minimum = 1)
  }
  if ("ocrMaximum" %in% BranchFields) {
    Result$ocrMaximum <- .readNumber(model, "ocrMaximum", Path, minimum = 1)
  }
  Result
}

.normaliseLoadCases <- function(loadCases) {
  if (!is.list(loadCases) || length(loadCases) == 0L) {
    stop("loadCases must be a non-empty array.", call. = FALSE)
  }
  Rows <- lapply(seq_along(loadCases), function(i) {
    Path <- paste0("loadCases[", i, "]")
    Case <- loadCases[[i]]
    .requireFields(Case, c("caseID", "alpha"), path = Path)
    data.frame(
      caseID = .readText(Case, "caseID", Path),
      alpha = .readNumber(Case, "alpha", Path, minimum = 0, maximum = 1),
      stringsAsFactors = FALSE
    )
  })
  Result <- do.call(rbind, Rows)
  if (anyDuplicated(Result$caseID)) {
    stop("loadCases.caseID values must be unique.", call. = FALSE)
  }
  if (anyDuplicated(Result$alpha)) {
    stop("loadCases.alpha values must be unique.", call. = FALSE)
  }
  Result
}

validateCalculationConfig <- function(config) {
  .requireObject(config, "calculation.json")
  if (!("schemaVersion" %in% names(config))) {
    stop("calculation.json is missing: schemaVersion.", call. = FALSE)
  }
  SchemaVersion <- .readText(config, "schemaVersion", "calculation.json")
  if (SchemaVersion != "2.1.0") {
    stop("Unsupported calculation schemaVersion: ", SchemaVersion, ".", call. = FALSE)
  }
  .requireFields(
    config,
    c(
      "schemaVersion", "scenarioID", "geometry", "section", "material",
      "stressState", "loadCases", "numerics", "graphics"
    ),
    path = "calculation.json"
  )

  Geometry <- .requireObject(config$geometry, "geometry")
  .requireFields(Geometry, c("insideDiameterM", "analysisRadiusRule"), path = "geometry")
  RadiusRule <- .readText(Geometry, "analysisRadiusRule", "geometry")
  if (RadiusRule != "inside-diameter-half") {
    stop("Unsupported geometry.analysisRadiusRule: ", RadiusRule, ".", call. = FALSE)
  }

  Section <- .requireObject(config$section, "section")
  PropertyModel <- .readText(Section, "propertyModelID", "section")
  Fields.section <- switch(
    PropertyModel,
    "published-exact-row" = c(
      "specifiedThicknessMm", "designBaseThicknessMm", "referenceRowID"
    ),
    "linear-interpolation-base-thickness" = c(
      "reportedThicknessMm", "analysisBaseThicknessMm"
    ),
    stop("Unsupported section.propertyModelID: ", PropertyModel, ".", call. = FALSE)
  )
  .requireFields(
    Section,
    c(
      "nominalCorrugationPitchMm", "nominalCorrugationDepthMm",
      "referenceProfileID", "propertyModelID", "propertyTable",
      Fields.section
    ),
    path = "section"
  )

  Material <- .requireObject(config$material, "material")
  .requireFields(Material, "circumferentialYoungModulusGPa", path = "material")

  Stress <- .requireObject(config$stressState, "stressState")
  .requireFields(
    Stress,
    c(
      "statePointID", "actionModelID", "effectiveVerticalKPa",
      "waterPressureDifferenceKPa", "horizontalIncrementMode", "k0Model"
    ),
    path = "stressState"
  )
  IncrementMode <- .readText(Stress, "horizontalIncrementMode", "stressState")
  if (IncrementMode != "unknown-not-modeled") {
    stop(
      "Unsupported stressState.horizontalIncrementMode: ", IncrementMode, ".",
      call. = FALSE
    )
  }
  ActionModelID <- .readText(Stress, "actionModelID", "stressState")
  if (ActionModelID != "prescribed-biaxial-stress-projection") {
    stop("Unsupported stressState.actionModelID: ", ActionModelID, ".", call. = FALSE)
  }

  Numerics <- .requireObject(config$numerics, "numerics")
  .requireFields(
    Numerics,
    c(
      "baseThetaPointCount", "criticalAnglesDeg", "integrationSteps",
      "balanceTolerance", "closedFormTolerance"
    ),
    path = "numerics"
  )
  Angles <- .readNumberArray(
    Numerics,
    "criticalAnglesDeg",
    "numerics",
    minimum = 0,
    maximum = 360
  )
  if (any(Angles >= 360) || anyDuplicated(Angles)) {
    stop("numerics.criticalAnglesDeg must be unique on [0, 360).", call. = FALSE)
  }

  Graphics <- .requireObject(config$graphics, "graphics")
  .requireFields(
    Graphics,
    c("graphicAmplification", "radialFraction", "ordinateCount"),
    path = "graphics"
  )

  list(
    schemaVersion = SchemaVersion,
    scenarioID = .readText(config, "scenarioID", "calculation.json"),
    geometry = list(
      insideDiameterM = .readNumber(
        Geometry,
        "insideDiameterM",
        "geometry",
        minimum = 0,
        strictMinimum = TRUE
      ),
      analysisRadiusRule = RadiusRule
    ),
    section = c(list(
      nominalCorrugationPitchMm = .readNumber(
        Section,
        "nominalCorrugationPitchMm",
        "section",
        minimum = 0,
        strictMinimum = TRUE
      ),
      nominalCorrugationDepthMm = .readNumber(
        Section,
        "nominalCorrugationDepthMm",
        "section",
        minimum = 0,
        strictMinimum = TRUE
      ),
      referenceProfileID = .readText(Section, "referenceProfileID", "section"),
      propertyModelID = PropertyModel,
      propertyTable = .readText(Section, "propertyTable", "section")
    ), if (PropertyModel == "published-exact-row") {
      list(
        specifiedThicknessMm = .readNumber(
          Section,
          "specifiedThicknessMm",
          "section",
          minimum = 0,
          strictMinimum = TRUE
        ),
        designBaseThicknessMm = .readNumber(
          Section,
          "designBaseThicknessMm",
          "section",
          minimum = 0,
          strictMinimum = TRUE
        ),
        referenceRowID = .readText(Section, "referenceRowID", "section")
      )
    } else {
      list(
        reportedThicknessMm = .readNumber(
          Section,
          "reportedThicknessMm",
          "section",
          minimum = 0,
          strictMinimum = TRUE
        ),
        analysisBaseThicknessMm = .readNumber(
          Section,
          "analysisBaseThicknessMm",
          "section",
          minimum = 0,
          strictMinimum = TRUE
        )
      )
    }),
    material = list(
      circumferentialYoungModulusGPa = .readNumber(
        Material,
        "circumferentialYoungModulusGPa",
        "material",
        minimum = 0,
        strictMinimum = TRUE
      )
    ),
    stressState = list(
      statePointID = .readText(Stress, "statePointID", "stressState"),
      actionModelID = ActionModelID,
      effectiveVerticalKPa = .readNumber(
        Stress,
        "effectiveVerticalKPa",
        "stressState",
        minimum = 0
      ),
      waterPressureDifferenceKPa = .readNumber(
        Stress,
        "waterPressureDifferenceKPa",
        "stressState"
      ),
      horizontalIncrementMode = IncrementMode,
      k0Model = .normaliseK0Model(Stress$k0Model)
    ),
    loadCases = .normaliseLoadCases(config$loadCases),
    numerics = list(
      baseThetaPointCount = .readNumber(
        Numerics,
        "baseThetaPointCount",
        "numerics",
        minimum = 3,
        integer = TRUE
      ),
      criticalAnglesDeg = Angles,
      integrationSteps = .readNumber(
        Numerics,
        "integrationSteps",
        "numerics",
        minimum = 1,
        integer = TRUE
      ),
      balanceTolerance = .readNumber(
        Numerics,
        "balanceTolerance",
        "numerics",
        minimum = 0,
        strictMinimum = TRUE
      ),
      closedFormTolerance = .readNumber(
        Numerics,
        "closedFormTolerance",
        "numerics",
        minimum = 0,
        strictMinimum = TRUE
      )
    ),
    graphics = list(
      graphicAmplification = .readNumber(
        Graphics,
        "graphicAmplification",
        "graphics",
        minimum = 0,
        strictMinimum = TRUE
      ),
      radialFraction = .readNumber(
        Graphics,
        "radialFraction",
        "graphics",
        minimum = 0,
        strictMinimum = TRUE
      ),
      ordinateCount = .readNumber(
        Graphics,
        "ordinateCount",
        "graphics",
        minimum = 1,
        integer = TRUE
      )
    )
  )
}

.adaptCalculationK0State <- function(k0State) {
  ModelID <- k0State[["modelID", exact = TRUE]]
  OUT <- list(
    modelID = ModelID,
    frictionAngleDeg = k0State[["frictionAngleDeg", exact = TRUE]],
    poissonRatio = k0State[["poissonRatio", exact = TRUE]],
    ocr = k0State[["ocr", exact = TRUE]],
    ocrMaximum = k0State[["ocrMaximum", exact = TRUE]],
    k0Input = k0State[["k0Input", exact = TRUE]],
    k0Derived = k0State[["k0Derived", exact = TRUE]],
    domainStatus = k0State[["domainStatus", exact = TRUE]],
    k0EvidenceLevel = "DE",
    sourceKey = NA_character_,
    sourceLocator = NA_character_
  )
  if (ModelID == "adopted-constant") {
    OUT$k0EvidenceLevel <- "HA"
  } else if (ModelID == "elastic-confined") {
    OUT$sourceKey <- "ChristopherEtAl2006"
    OUT$sourceLocator <- "Section 5.4.9, Eq. 5.37"
  } else if (ModelID == "jaky-nc") {
    OUT$sourceKey <- "ChristopherEtAl2006"
    OUT$sourceLocator <- "Section 5.4.9, Eq. 5.38"
  } else if (ModelID == "mayne-kulhawy-unloading") {
    OUT$sourceKey <- "MayneKulhawy1982"
    OUT$sourceLocator <- "Eq. 10; domain control Eqs. 11-12"
  } else if (ModelID == "mayne-kulhawy-reload") {
    OUT$sourceKey <- "MayneKulhawy1982"
    OUT$sourceLocator <- "Eq. 18; domain control Eqs. 11-12"
  }
  OUT$k0Applied <- k0State[["k0Applied", exact = TRUE]]
  OUT
}

.readCalculationSectionReference <- function(config, projectRoot) {
  Path <- file.path(
    projectRoot,
    config[["section", exact = TRUE]][["propertyTable", exact = TRUE]]
  )
  if (!file.exists(Path)) {
    stop("The corrugation property table is not available: ", Path, call. = FALSE)
  }
  utils::read.csv(
    Path,
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
}

.buildCalculationSectionTable <- function(
  config,
  corrugatedSection,
  sectionRigidity
) {
  Radius <-
    config[["geometry", exact = TRUE]][["insideDiameterM", exact = TRUE]] /
      2
  Common <- data.frame(
    scenarioID = config[["scenarioID", exact = TRUE]],
    sectionID = "circumferential-section",
    profileID = corrugatedSection[["profileID", exact = TRUE]],
    propertyModelID =
      config[["section", exact = TRUE]][["propertyModelID", exact = TRUE]],
    areaMm2PerMm = corrugatedSection[["areaMm2PerMm", exact = TRUE]],
    inertiaMm4PerMm = corrugatedSection[["inertiaMm4PerMm", exact = TRUE]],
    circumferentialYoungModulusGPa =
      config[["material", exact = TRUE]][[
        "circumferentialYoungModulusGPa",
        exact = TRUE
      ]],
    analysisRadiusM = Radius,
    extensionalRigidityKnPerM =
      sectionRigidity[["extensionalRigidity", exact = TRUE]],
    flexuralRigidityKnM2PerM =
      sectionRigidity[["flexuralRigidity", exact = TRUE]],
    sectionRatio = sectionRigidity[["sectionRatio", exact = TRUE]],
    evidenceLevel = "DE",
    sourceKey = corrugatedSection[["sourceKey", exact = TRUE]],
    sourceLocator = corrugatedSection[["sourceLocator", exact = TRUE]],
    domainStatus = corrugatedSection[["domainStatus", exact = TRUE]],
    stringsAsFactors = FALSE
  )
  if (config$section$propertyModelID == "published-exact-row") {
    Configured <- c(
      nominalPitchMm = config$section$nominalCorrugationPitchMm,
      nominalDepthMm = config$section$nominalCorrugationDepthMm,
      specifiedThicknessMm = config$section$specifiedThicknessMm,
      designBaseThicknessMm = config$section$designBaseThicknessMm
    )
    Published <- c(
      nominalPitchMm = corrugatedSection$nominalPitchMm,
      nominalDepthMm = corrugatedSection$nominalDepthMm,
      specifiedThicknessMm = corrugatedSection$specifiedThicknessMm,
      designBaseThicknessMm = corrugatedSection$designBaseThicknessMm
    )
    if (!isTRUE(all.equal(Configured, Published, tolerance = 1e-12))) {
      stop(
        "The configured section does not match the selected published row.",
        call. = FALSE
      )
    }
    Exact <- data.frame(
      referenceRowID = corrugatedSection[["referenceRowID", exact = TRUE]],
      nominalPitchMm = corrugatedSection[["nominalPitchMm", exact = TRUE]],
      nominalDepthMm = corrugatedSection[["nominalDepthMm", exact = TRUE]],
      actualPitchMm = corrugatedSection[["actualPitchMm", exact = TRUE]],
      actualDepthMm = corrugatedSection[["actualDepthMm", exact = TRUE]],
      corrugationRadiusMm =
        corrugatedSection[["corrugationRadiusMm", exact = TRUE]],
      specifiedThicknessMm =
        corrugatedSection[["specifiedThicknessMm", exact = TRUE]],
      designBaseThicknessMm =
        corrugatedSection[["designBaseThicknessMm", exact = TRUE]],
      tangentLengthMm = corrugatedSection[["tangentLengthMm", exact = TRUE]],
      tangentAngleDeg = corrugatedSection[["tangentAngleDeg", exact = TRUE]],
      sectionModulusMm3PerMm =
        corrugatedSection[["sectionModulusMm3PerMm", exact = TRUE]],
      gyrationRadiusMm =
        corrugatedSection[["gyrationRadiusMm", exact = TRUE]],
      developedWidthFactor =
        corrugatedSection[["developedWidthFactor", exact = TRUE]],
      propertyEvidenceLevel =
        corrugatedSection[["evidenceLevel", exact = TRUE]],
      rigidityEvidenceLevel = "DE",
      stringsAsFactors = FALSE
    )
    return(cbind(Common, Exact))
  }
  Interpolated <- data.frame(
    analysisBaseThicknessMm =
      corrugatedSection[["analysisBaseThicknessMm", exact = TRUE]],
    lowerReferenceRowID =
      corrugatedSection[["lowerReferenceRowID", exact = TRUE]],
    upperReferenceRowID =
      corrugatedSection[["upperReferenceRowID", exact = TRUE]],
    interpolationFraction =
      corrugatedSection[["interpolationFraction", exact = TRUE]],
    stringsAsFactors = FALSE
  )
  cbind(
    Common[c(
      "scenarioID", "sectionID", "profileID", "propertyModelID"
    )],
    Interpolated,
    Common[setdiff(names(Common), c(
      "scenarioID", "sectionID", "profileID", "propertyModelID"
    ))]
  )
}

resolveCalculationK0 <- function(model) {
  ModelID <- model[["modelID", exact = TRUE]]
  Fields.model <- intersect(
    names(model),
    c("k0", "frictionAngleDeg", "poissonRatio", "ocr", "ocrMaximum")
  )
  K0State <- do.call(
    estimateK0,
    c(list(modelID = ModelID), model[Fields.model])
  )
  .adaptCalculationK0State(K0State)
}

readCalculationSection <- function(config, projectRoot) {
  Reference <- .readCalculationSectionReference(config, projectRoot)
  CorrugatedSection <- if (
    config$section$propertyModelID == "published-exact-row"
  ) {
    selectCorrugatedSection(
      reference = Reference,
      profileID = config$section$referenceProfileID,
      referenceRowID = config$section$referenceRowID
    )
  } else {
    interpolateCorrugatedSection(
      reference = Reference,
      profileID = config$section$referenceProfileID,
      baseThicknessMm = config$section$analysisBaseThicknessMm
    )
  }
  Radius <- config$geometry$insideDiameterM / 2
  YoungModulusKPa <- config$material$circumferentialYoungModulusGPa * 1e6
  RingSection <- calculateRingSection(
    youngModulus = YoungModulusKPa,
    area = CorrugatedSection$areaMm2PerMm * 1e-3,
    inertia = CorrugatedSection$inertiaMm4PerMm * 1e-9,
    radius = Radius
  )
  .buildCalculationSectionTable(
    config = config,
    corrugatedSection = CorrugatedSection,
    sectionRigidity = RingSection
  )
}

.buildCalculationStressTable <- function(
  config,
  k0State,
  stressState,
  stressStateID
) {
  data.frame(
    scenarioID = config[["scenarioID", exact = TRUE]],
    stressStateID = stressStateID,
    modelID = k0State[["modelID", exact = TRUE]],
    actionModelID =
      config[["stressState", exact = TRUE]][["actionModelID", exact = TRUE]],
    statePointID =
      config[["stressState", exact = TRUE]][["statePointID", exact = TRUE]],
    layerID = NA_character_,
    thetaIndex = NA_integer_,
    thetaRad = NA_real_,
    depthM = NA_real_,
    effectiveVerticalKPa =
      stressState[["effectiveVerticalKPa", exact = TRUE]],
    frictionAngleDeg = k0State[["frictionAngleDeg", exact = TRUE]],
    poissonRatio = k0State[["poissonRatio", exact = TRUE]],
    ocr = k0State[["ocr", exact = TRUE]],
    ocrMaximum = k0State[["ocrMaximum", exact = TRUE]],
    k0Input = k0State[["k0Input", exact = TRUE]],
    k0Derived = k0State[["k0Derived", exact = TRUE]],
    k0Applied = k0State[["k0Applied", exact = TRUE]],
    horizontalIncrementKPa =
      stressState[["horizontalIncrementKPa", exact = TRUE]],
    horizontalIncrementStatus =
      stressState[["horizontalIncrementStatus", exact = TRUE]],
    effectiveHorizontalKPa =
      stressState[["effectiveHorizontalKPa", exact = TRUE]],
    waterPressureDifferenceKPa =
      stressState[["waterPressureDifferenceKPa", exact = TRUE]],
    domainStatus = k0State[["domainStatus", exact = TRUE]],
    k0EvidenceLevel = k0State[["k0EvidenceLevel", exact = TRUE]],
    evidenceLevel = "DE",
    sourceKey = k0State[["sourceKey", exact = TRUE]],
    sourceLocator = k0State[["sourceLocator", exact = TRUE]],
    stringsAsFactors = FALSE
  )
}

.inputRow <- function(
  scenarioID,
  caseID,
  groupID,
  parameterID,
  symbol,
  numericValue = NA_real_,
  textValue = NA_character_,
  unit = "-",
  evidenceLevel,
  conditionCode
) {
  data.frame(
    scenarioID = scenarioID,
    caseID = caseID,
    groupID = groupID,
    parameterID = parameterID,
    symbol = symbol,
    numericValue = numericValue,
    textValue = textValue,
    unit = unit,
    evidenceLevel = evidenceLevel,
    conditionCode = conditionCode,
    stringsAsFactors = FALSE
  )
}

.buildCalculationInputs <- function(config) {
  ScenarioID <- config$scenarioID
  Rows <- list(
    .inputRow(ScenarioID, NA, "geometry", "inside-diameter", "D_i", config$geometry$insideDiameterM, unit = "m", evidenceLevel = "PN", conditionCode = "provided-nominal"),
    .inputRow(ScenarioID, NA, "geometry", "analysis-radius-rule", "radiusRule", textValue = config$geometry$analysisRadiusRule, evidenceLevel = "HA", conditionCode = "adopted-rule"),
    .inputRow(ScenarioID, NA, "section", "nominal-corrugation-pitch", "pitch", config$section$nominalCorrugationPitchMm, unit = "mm", evidenceLevel = "PN", conditionCode = "provided-nominal"),
    .inputRow(ScenarioID, NA, "section", "nominal-corrugation-depth", "depth", config$section$nominalCorrugationDepthMm, unit = "mm", evidenceLevel = "PN", conditionCode = "provided-nominal"),
    .inputRow(ScenarioID, NA, "section", "reference-profile", "profileID", textValue = config$section$referenceProfileID, evidenceLevel = "HA", conditionCode = "selected-reference"),
    .inputRow(ScenarioID, NA, "section", "property-model", "propertyModelID", textValue = config$section$propertyModelID, evidenceLevel = "HA", conditionCode = "adopted-model"),
    .inputRow(ScenarioID, NA, "material", "circumferential-young-modulus", "E_theta", config$material$circumferentialYoungModulusGPa, unit = "GPa", evidenceLevel = "HA", conditionCode = "adopted-value"),
    .inputRow(ScenarioID, NA, "stress-state", "state-point", "statePointID", textValue = config$stressState$statePointID, evidenceLevel = "HA", conditionCode = "analytical-scenario"),
    .inputRow(ScenarioID, NA, "stress-state", "action-model", "actionModelID", textValue = config$stressState$actionModelID, evidenceLevel = "HA", conditionCode = "analytical-scenario"),
    .inputRow(ScenarioID, NA, "stress-state", "effective-vertical", "sigma'_v,A", config$stressState$effectiveVerticalKPa, unit = "kPa", evidenceLevel = "HA", conditionCode = "analytical-scenario"),
    .inputRow(ScenarioID, NA, "stress-state", "water-pressure-difference", "Delta u_A", config$stressState$waterPressureDifferenceKPa, unit = "kPa", evidenceLevel = "HA", conditionCode = "analytical-scenario"),
    .inputRow(ScenarioID, NA, "stress-state", "horizontal-increment-mode", "horizontalIncrementMode", textValue = config$stressState$horizontalIncrementMode, evidenceLevel = "HA", conditionCode = "unknown-not-modeled"),
    .inputRow(ScenarioID, NA, "stress-state", "k0-model", "modelID", textValue = config$stressState$k0Model$modelID, evidenceLevel = "HA", conditionCode = "selected-branch")
  )
  SectionRows <- if (config$section$propertyModelID == "published-exact-row") {
    list(
      .inputRow(ScenarioID, NA, "section", "specified-thickness", "t_s", config$section$specifiedThicknessMm, unit = "mm", evidenceLevel = "DP", conditionCode = "published-exact-row"),
      .inputRow(ScenarioID, NA, "section", "design-base-thickness", "t_d", config$section$designBaseThicknessMm, unit = "mm", evidenceLevel = "DP", conditionCode = "published-exact-row"),
      .inputRow(ScenarioID, NA, "section", "reference-row", "rowID", textValue = config$section$referenceRowID, evidenceLevel = "HA", conditionCode = "selected-reference-row")
    )
  } else {
    list(
      .inputRow(ScenarioID, NA, "section", "reported-thickness", "t_0", config$section$reportedThicknessMm, unit = "mm", evidenceLevel = "PN", conditionCode = "provided-nominal"),
      .inputRow(ScenarioID, NA, "section", "analysis-base-thickness", "t_b", config$section$analysisBaseThicknessMm, unit = "mm", evidenceLevel = "HA", conditionCode = "adopted-base-thickness")
    )
  }
  Rows <- append(Rows, SectionRows, after = 4L)
  Model <- config$stressState$k0Model
  ModelValues <- c("k0", "frictionAngleDeg", "poissonRatio", "ocr", "ocrMaximum")
  Symbols <- c(
    k0 = "K_0",
    frictionAngleDeg = "phi'",
    poissonRatio = "nu_g",
    ocr = "OCR",
    ocrMaximum = "OCR_max"
  )
  Units <- c(k0 = "-", frictionAngleDeg = "deg", poissonRatio = "-", ocr = "-", ocrMaximum = "-")
  ParameterIDs <- c(
    k0 = "k0-value",
    frictionAngleDeg = "friction-angle",
    poissonRatio = "poisson-ratio",
    ocr = "ocr",
    ocrMaximum = "ocr-maximum"
  )
  for (s in intersect(ModelValues, names(Model))) {
    Rows[[length(Rows) + 1L]] <- .inputRow(
      ScenarioID,
      NA,
      "stress-state",
      ParameterIDs[[s]],
      Symbols[[s]],
      Model[[s]],
      unit = Units[[s]],
      evidenceLevel = "HA",
      conditionCode = "branch-primitive"
    )
  }
  for (i in seq_len(nrow(config$loadCases))) {
    Rows[[length(Rows) + 1L]] <- .inputRow(
      ScenarioID,
      config$loadCases$caseID[i],
      "load-case",
      "tangential-multiplier",
      "alpha",
      config$loadCases$alpha[i],
      evidenceLevel = "HA",
      conditionCode = "prescribed-load-case"
    )
  }
  Rows <- c(
    Rows,
    list(
      .inputRow(ScenarioID, NA, "numerics", "base-theta-point-count", "n_theta", config$numerics$baseThetaPointCount, evidenceLevel = "HA", conditionCode = "numerical-setting"),
      .inputRow(ScenarioID, NA, "numerics", "critical-angles", "theta_c", textValue = paste(config$numerics$criticalAnglesDeg, collapse = "; "), unit = "deg", evidenceLevel = "HA", conditionCode = "numerical-setting"),
      .inputRow(ScenarioID, NA, "numerics", "integration-steps", "n_int", config$numerics$integrationSteps, evidenceLevel = "HA", conditionCode = "numerical-setting"),
      .inputRow(ScenarioID, NA, "numerics", "balance-tolerance", "epsilon_b", config$numerics$balanceTolerance, evidenceLevel = "HA", conditionCode = "numerical-setting"),
      .inputRow(ScenarioID, NA, "numerics", "closed-form-tolerance", "epsilon_c", config$numerics$closedFormTolerance, evidenceLevel = "HA", conditionCode = "numerical-setting"),
      .inputRow(ScenarioID, NA, "graphics", "graphic-amplification", "A_g", config$graphics$graphicAmplification, evidenceLevel = "HA", conditionCode = "display-setting"),
      .inputRow(ScenarioID, NA, "graphics", "radial-fraction", "f_r", config$graphics$radialFraction, evidenceLevel = "HA", conditionCode = "display-setting"),
      .inputRow(ScenarioID, NA, "graphics", "ordinate-count", "n_o", config$graphics$ordinateCount, evidenceLevel = "HA", conditionCode = "display-setting")
    )
  )
  do.call(rbind, Rows)
}

.buildSectionExtremaTable <- function(
  summaries,
  cases,
  scenarioID,
  units
) {
  Statistics <- c(
    minimum = "minimum",
    maximum = "maximum",
    absoluteMaximum = "absolute-maximum"
  )
  LIST <- lapply(seq_len(nrow(cases)), function(i) {
    Summary <- summaries[[i]]
    data.frame(
      scenarioID = scenarioID,
      caseID = cases$caseID[i],
      alpha = cases$alpha[i],
      resultantID = Summary$resultant,
      statisticID = unname(Statistics[Summary$statistic]),
      value = Summary$value,
      signedValue = Summary$signedValue,
      thetaRad = Summary$theta,
      thetaDeg = Summary$thetaDeg,
      unit = unname(units[Summary$resultant]),
      evidenceLevel = "DE",
      stringsAsFactors = FALSE
    )
  })
  OUT <- do.call(rbind, LIST)
  rownames(OUT) <- NULL
  OUT
}

.buildSectionResultantTable <- function(
  responses,
  cases,
  scenarioID,
  sectionID,
  stressStateID,
  columns,
  units
) {
  LIST <- lapply(seq_len(nrow(cases)), function(i) {
    Values <- responses[[i]]$values
    do.call(rbind, lapply(names(columns), function(s) {
      data.frame(
        scenarioID = scenarioID,
        caseID = cases$caseID[i],
        sectionID = sectionID,
        stressStateID = stressStateID,
        alpha = cases$alpha[i],
        resultantID = s,
        thetaIndex = seq_len(nrow(Values)) - 1L,
        thetaRad = Values$theta,
        thetaDeg = Values$thetaDeg,
        value = Values[[columns[[s]]]],
        unit = units[[s]],
        evidenceLevel = "DE",
        stringsAsFactors = FALSE
      )
    }))
  })
  OUT <- do.call(rbind, LIST)
  rownames(OUT) <- NULL
  OUT
}

.buildResultantControlTable <- function(
  responses,
  cases,
  stressState,
  section,
  theta,
  numerics,
  scenarioID,
  units
) {
  Columns <- c(N = "normalForce", M = "bendingMoment", Q = "shearForce")
  Components <- c(Fx = "forceX", Fz = "forceZ", Mc = "momentCenter")
  LIST <- lapply(seq_len(nrow(cases)), function(i) {
    Response.closed <- solveBiaxialTangentialMultiplierClosed(
      effectiveVertical = stressState$effectiveVerticalKPa,
      effectiveHorizontal = stressState$effectiveHorizontalKPa,
      waterPressureDifference = stressState$waterPressureDifferenceKPa,
      radius = section$analysisRadiusM,
      tangentialMultiplier = cases$alpha[i],
      theta = theta,
      sectionRatio = section$sectionRatio
    )
    Response.direct <- responses[[i]]
    Rows.closed <- do.call(rbind, lapply(names(Columns), function(s) {
      Error <- max(abs(
        Response.direct$values[[Columns[[s]]]] -
          Response.closed$values[[Columns[[s]]]]
      ))
      data.frame(
        scenarioID = scenarioID,
        caseID = cases$caseID[i],
        alpha = cases$alpha[i],
        controlID = "closed-form-resultants",
        resultantID = s,
        metricID = "maximum-absolute-difference",
        observedValue = Error,
        comparison = "<=",
        limitValue = numerics$closedFormTolerance,
        unit = units[[s]],
        pass = Error <= numerics$closedFormTolerance,
        thetaPointCount = length(theta),
        integrationSteps = numerics$integrationSteps,
        evidenceLevel = "CI",
        stringsAsFactors = FALSE
      )
    }))
    Rows.balance <- do.call(rbind, lapply(names(Components), function(s) {
      Residual <- abs(Response.direct$diagnostics$normalizedGlobalLoads[[
        Components[[s]]
      ]])
      data.frame(
        scenarioID = scenarioID,
        caseID = cases$caseID[i],
        alpha = cases$alpha[i],
        controlID = "global-equilibrium",
        resultantID = s,
        metricID = "absolute-normalized-residual",
        observedValue = Residual,
        comparison = "<=",
        limitValue = numerics$balanceTolerance,
        unit = "-",
        pass = Residual <= numerics$balanceTolerance,
        thetaPointCount = length(theta),
        integrationSteps = numerics$integrationSteps,
        evidenceLevel = "CI",
        stringsAsFactors = FALSE
      )
    }))
    rbind(Rows.closed, Rows.balance)
  })
  OUT <- do.call(rbind, LIST)
  rownames(OUT) <- NULL
  if (!all(OUT$pass)) {
    stop("One or more numerical controls failed.", call. = FALSE)
  }
  OUT
}

.buildDisplayScaleTable <- function(
  resultants,
  scenarioID,
  radius,
  graphics,
  units
) {
  do.call(rbind, lapply(names(units), function(s) {
    AUX <- resultants[resultants$resultantID == s, , drop = FALSE]
    Maximum <- max(abs(AUX$value))
    data.frame(
      scenarioID = scenarioID,
      resultantID = s,
      referenceRadiusM = radius,
      displayScale = graphics$radialFraction * radius / Maximum,
      maximumAbsoluteValue = Maximum,
      resultantUnit = units[[s]],
      radialFraction = graphics$radialFraction,
      graphicAmplification = graphics$graphicAmplification,
      ordinateCount = graphics$ordinateCount,
      evidenceLevel = "DE",
      stringsAsFactors = FALSE
    )
  }))
}

.writeCalculationProducts <- function(products, configPath, outputDirectory) {
  Parent <- dirname(outputDirectory)
  if (!dir.exists(Parent)) dir.create(Parent, recursive = TRUE)
  Stage <- tempfile("calculation-data-", tmpdir = Parent)
  if (!dir.create(Stage)) {
    stop("Could not create the calculation staging directory.", call. = FALSE)
  }
  on.exit(unlink(Stage, recursive = TRUE, force = TRUE), add = TRUE)
  for (s in names(products)) {
    utils::write.csv(
      products[[s]],
      file.path(Stage, s),
      row.names = FALSE,
      na = ""
    )
  }
  if (!file.copy(configPath, file.path(Stage, "calculation.config.json"))) {
    stop("Could not stage the calculation configuration snapshot.", call. = FALSE)
  }
  FileNames <- c(names(products), "calculation.config.json")
  Missing <- FileNames[!file.exists(file.path(Stage, FileNames))]
  if (length(Missing) > 0L) {
    stop("Staged calculation products are incomplete.", call. = FALSE)
  }
  Backup <- tempfile("calculation-data-backup-", tmpdir = Parent)
  HadOutput <- dir.exists(outputDirectory)
  if (HadOutput && !file.rename(outputDirectory, Backup)) {
    stop("Could not preserve the previous calculation products.", call. = FALSE)
  }
  if (!file.rename(Stage, outputDirectory)) {
    Restored <- !HadOutput || file.rename(Backup, outputDirectory)
    if (!Restored) {
      stop(
        "Could not publish or restore the calculation products; the previous ",
        "products remain at ", Backup, ".",
        call. = FALSE
      )
    }
    stop("Could not publish the calculation products.", call. = FALSE)
  }
  if (HadOutput && dir.exists(Backup)) {
    unlink(Backup, recursive = TRUE, force = TRUE)
    if (dir.exists(Backup)) {
      warning("The previous calculation-product backup could not be removed.")
    }
  }
  invisible(file.path(outputDirectory, FileNames))
}

buildCalculationData <- function(configPath, outputDirectory, projectRoot) {
  ConfigPath <- normalizePath(configPath, mustWork = TRUE)
  ProjectRoot <- normalizePath(projectRoot, mustWork = TRUE)
  Config <- validateCalculationConfig(readCalculationJson(ConfigPath))
  Config.section <- Config[["section", exact = TRUE]]
  Config.stress <- Config[["stressState", exact = TRUE]]
  Config.numerics <- Config[["numerics", exact = TRUE]]
  ScenarioID <- Config[["scenarioID", exact = TRUE]]
  Cases <- Config[["loadCases", exact = TRUE]]
  Model <- Config.stress[["k0Model", exact = TRUE]]
  Reference <- .readCalculationSectionReference(Config, ProjectRoot)
  Radius <-
    Config[["geometry", exact = TRUE]][["insideDiameterM", exact = TRUE]] /
      2
  Theta <- buildThetaMesh(
    pointCount = Config.numerics[["baseThetaPointCount", exact = TRUE]],
    criticalAnglesDeg = Config.numerics[["criticalAnglesDeg", exact = TRUE]]
  )
  Fields.k0 <- c(
    "k0", "frictionAngleDeg", "poissonRatio", "ocr", "ocrMaximum"
  )
  Realization.common <- c(
    list(
      effectiveVerticalKPa =
        Config.stress[["effectiveVerticalKPa", exact = TRUE]],
      waterPressureDifferenceKPa =
        Config.stress[["waterPressureDifferenceKPa", exact = TRUE]]
    ),
    if (Config.section[["propertyModelID", exact = TRUE]] ==
        "linear-interpolation-base-thickness") {
      list(baseThicknessMm =
        Config.section[["analysisBaseThicknessMm", exact = TRUE]])
    },
    Model[intersect(Fields.k0, names(Model))]
  )
  Context <- list(
    k0ModelID = Model[["modelID", exact = TRUE]],
    horizontalIncrementKPa = NA_real_,
    horizontalIncrementStatus =
      Config.stress[["horizontalIncrementMode", exact = TRUE]],
    sectionReference = Reference,
    profileID = Config.section[["referenceProfileID", exact = TRUE]],
    sectionPropertyModelID =
      Config.section[["propertyModelID", exact = TRUE]],
    referenceRowID = Config.section[["referenceRowID", exact = TRUE]],
    youngModulusKPa =
      Config[["material", exact = TRUE]][[
        "circumferentialYoungModulusGPa",
        exact = TRUE
      ]] * 1e6,
    radiusM = Radius,
    theta = Theta,
    integrationSteps = Config.numerics[["integrationSteps", exact = TRUE]],
    balanceTolerance = Config.numerics[["balanceTolerance", exact = TRUE]]
  )
  Scenarios <- lapply(seq_len(nrow(Cases)), function(i) {
    AUX <- Realization.common
    AUX$alpha <- Cases[["alpha", exact = TRUE]][i]
    calculateScenario(
      realization = AUX,
      context = Context
    )
  })
  names(Scenarios) <- Cases[["caseID", exact = TRUE]]

  Scenario <- Scenarios[[1L]]
  K0State <- .adaptCalculationK0State(
    Scenario[["k0State", exact = TRUE]]
  )
  Section <- .buildCalculationSectionTable(
    config = Config,
    corrugatedSection = Scenario[["corrugatedSection", exact = TRUE]],
    sectionRigidity = Scenario[["sectionRigidity", exact = TRUE]]
  )
  StressStateID <- paste0(
    ScenarioID,
    "-",
    Config.stress[["statePointID", exact = TRUE]]
  )
  Stress <- .buildCalculationStressTable(
    config = Config,
    k0State = K0State,
    stressState = Scenario[["stressState", exact = TRUE]],
    stressStateID = StressStateID
  )
  Actions <- lapply(Scenarios, function(x) {
    x[["perimeterActions", exact = TRUE]]
  })
  Responses <- lapply(Scenarios, function(x) {
    x[["sectionResultants", exact = TRUE]]
  })
  Summaries <- lapply(Scenarios, function(x) {
    x[["resultantExtrema", exact = TRUE]]
  })
  Columns.resultant <- c(
    N = "normalForce",
    M = "bendingMoment",
    Q = "shearForce"
  )
  Units.resultant <- c(N = "kN/m", M = "kN m/m", Q = "kN/m")

  PerimeterLoads <- .buildPerimeterLoadTable(
    actions = Actions,
    cases = Cases,
    scenarioID = ScenarioID,
    stressStateID = StressStateID
  )
  Resultants <- .buildSectionResultantTable(
    responses = Responses,
    cases = Cases,
    scenarioID = ScenarioID,
    sectionID = Section[["sectionID", exact = TRUE]],
    stressStateID = StressStateID,
    columns = Columns.resultant,
    units = Units.resultant
  )
  Extrema <- .buildSectionExtremaTable(
    summaries = Summaries,
    cases = Cases,
    scenarioID = ScenarioID,
    units = Units.resultant
  )
  Controls <- .buildResultantControlTable(
    responses = Responses,
    cases = Cases,
    stressState = Stress,
    section = Section,
    theta = Theta,
    numerics = Config.numerics,
    scenarioID = ScenarioID,
    units = Units.resultant
  )
  DisplayScales <- .buildDisplayScaleTable(
    resultants = Resultants,
    scenarioID = ScenarioID,
    radius = Section[["analysisRadiusM", exact = TRUE]],
    graphics = Config[["graphics", exact = TRUE]],
    units = Units.resultant
  )

  Products <- list(
    "calculation.inputs.csv" = .buildCalculationInputs(Config),
    "section.properties.csv" = Section,
    "stress.state.csv" = Stress,
    "perimeter.loads.csv" = PerimeterLoads,
    "section.resultants.csv" = Resultants,
    "section.extrema.csv" = Extrema,
    "numerical.controls.csv" = Controls,
    "display.scales.csv" = DisplayScales
  )
  .writeCalculationProducts(Products, ConfigPath, outputDirectory)
  list(
    config = Config,
    products = Products,
    outputDirectory = normalizePath(outputDirectory, mustWork = TRUE)
  )
}
