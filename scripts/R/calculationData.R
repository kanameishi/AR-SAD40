if (!exists("calculateRingSection", mode = "function") ||
    !exists("estimateK0", mode = "function") ||
    !exists("calculateEffectiveStressState", mode = "function") ||
    !exists("interpolateCorrugatedSection", mode = "function") ||
    !exists("buildThetaMesh", mode = "function") ||
    !exists("calculatePerimeterActions", mode = "function") ||
    !exists("readCalculationJson", mode = "function")) {
  stop(
    paste(
      "Source scripts/setup/utils.R, scripts/R/ringDirect.R and",
      "scripts/R/ringLoads.R, scripts/R/k0Models.R and",
      "scripts/R/stressState.R, scripts/R/corrugatedSection.R and",
      "scripts/R/perimeterActions.R before scripts/R/calculationData.R."
    ),
    call. = FALSE
  )
}

.buildPerimeterLoadTable <- function(actions, cases, scenarioId, stressStateId) {
  LIST <- lapply(seq_len(nrow(cases)), function(i) {
    Values <- actions[[i]]$values
    rbind(
      data.frame(
        scenarioId = scenarioId,
        caseId = cases$caseId[i],
        stressStateId = stressStateId,
        alpha = cases$alpha[i],
        componentId = "radial",
        thetaIndex = seq_len(nrow(Values)) - 1L,
        thetaRad = Values$theta,
        thetaDeg = Values$theta * 180 / pi,
        valueKPa = Values$radialOutward,
        evidenceLevel = "DE",
        stringsAsFactors = FALSE
      ),
      data.frame(
        scenarioId = scenarioId,
        caseId = cases$caseId[i],
        stressStateId = stressStateId,
        alpha = cases$alpha[i],
        componentId = "tangential",
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
    required = "modelId",
    optional = c("k0", "frictionAngleDeg", "poissonRatio", "ocr", "ocrMaximum"),
    path = Path
  )
  ModelId <- .readText(model, "modelId", Path)
  BranchFields <- switch(
    ModelId,
    "adopted-constant" = "k0",
    "elastic-confined" = "poissonRatio",
    "jaky-nc" = "frictionAngleDeg",
    "mayne-kulhawy-unloading" = c("frictionAngleDeg", "ocr"),
    "mayne-kulhawy-reload" = c("frictionAngleDeg", "ocr", "ocrMaximum"),
    stop("Unsupported K0 modelId: ", ModelId, ".", call. = FALSE)
  )
  .requireFields(model, c("modelId", BranchFields), path = Path)
  Result <- list(modelId = ModelId)
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
  Rows <- lapply(seq_along(loadCases), function(Index) {
    Path <- paste0("loadCases[", Index, "]")
    Case <- loadCases[[Index]]
    .requireFields(Case, c("caseId", "alpha"), path = Path)
    data.frame(
      caseId = .readText(Case, "caseId", Path),
      alpha = .readNumber(Case, "alpha", Path, minimum = 0, maximum = 1),
      stringsAsFactors = FALSE
    )
  })
  Result <- do.call(rbind, Rows)
  if (anyDuplicated(Result$caseId)) {
    stop("loadCases.caseId values must be unique.", call. = FALSE)
  }
  if (anyDuplicated(Result$alpha)) {
    stop("loadCases.alpha values must be unique.", call. = FALSE)
  }
  Result
}

validateCalculationConfig <- function(config) {
  .requireFields(
    config,
    c(
      "schemaVersion", "scenarioId", "geometry", "section", "material",
      "stressState", "loadCases", "numerics", "graphics"
    ),
    path = "calculation.json"
  )
  SchemaVersion <- .readText(config, "schemaVersion", "calculation.json")
  if (SchemaVersion != "1.0.0") {
    stop("Unsupported calculation schemaVersion: ", SchemaVersion, ".", call. = FALSE)
  }

  Geometry <- .requireObject(config$geometry, "geometry")
  .requireFields(Geometry, c("insideDiameterM", "analysisRadiusRule"), path = "geometry")
  RadiusRule <- .readText(Geometry, "analysisRadiusRule", "geometry")
  if (RadiusRule != "inside-diameter-half") {
    stop("Unsupported geometry.analysisRadiusRule: ", RadiusRule, ".", call. = FALSE)
  }

  Section <- .requireObject(config$section, "section")
  .requireFields(
    Section,
    c(
      "nominalCorrugationPitchMm", "nominalCorrugationDepthMm",
      "reportedThicknessMm", "analysisBaseThicknessMm", "referenceProfileId",
      "propertyModelId", "propertyTable"
    ),
    path = "section"
  )
  PropertyModel <- .readText(Section, "propertyModelId", "section")
  if (PropertyModel != "linear-interpolation-base-thickness") {
    stop("Unsupported section.propertyModelId: ", PropertyModel, ".", call. = FALSE)
  }

  Material <- .requireObject(config$material, "material")
  .requireFields(Material, "circumferentialYoungModulusGPa", path = "material")

  Stress <- .requireObject(config$stressState, "stressState")
  .requireFields(
    Stress,
    c(
      "statePointId", "effectiveVerticalKPa", "waterPressureDifferenceKPa",
      "horizontalIncrementMode", "k0Model"
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
    scenarioId = .readText(config, "scenarioId", "calculation.json"),
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
    section = list(
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
      ),
      referenceProfileId = .readText(Section, "referenceProfileId", "section"),
      propertyModelId = PropertyModel,
      propertyTable = .readText(Section, "propertyTable", "section")
    ),
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
      statePointId = .readText(Stress, "statePointId", "stressState"),
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

resolveCalculationK0 <- function(model) {
  ModelId <- model[["modelId", exact = TRUE]]
  ModelFields <- intersect(
    names(model),
    c("k0", "frictionAngleDeg", "poissonRatio", "ocr", "ocrMaximum")
  )
  K0State <- do.call(
    estimateK0,
    c(list(modelId = ModelId), model[ModelFields])
  )
  OUT <- list(
    modelId = K0State$modelId,
    frictionAngleDeg = K0State$frictionAngleDeg,
    poissonRatio = K0State$poissonRatio,
    ocr = K0State$ocr,
    ocrMaximum = K0State$ocrMaximum,
    k0Input = K0State$k0Input,
    k0Derived = K0State$k0Derived,
    domainStatus = K0State$domainStatus,
    k0EvidenceLevel = "DE",
    sourceKey = NA_character_,
    sourceLocator = NA_character_
  )
  if (K0State$modelId == "adopted-constant") {
    OUT$k0EvidenceLevel <- "HA"
  } else if (K0State$modelId == "elastic-confined") {
    OUT$sourceKey <- "ChristopherEtAl2006"
    OUT$sourceLocator <- "Section 5.4.9, Eq. 5.37"
  } else if (K0State$modelId == "jaky-nc") {
    OUT$sourceKey <- "ChristopherEtAl2006"
    OUT$sourceLocator <- "Section 5.4.9, Eq. 5.38"
  } else if (K0State$modelId == "mayne-kulhawy-unloading") {
    OUT$sourceKey <- "MayneKulhawy1982"
    OUT$sourceLocator <- "Eq. 10; domain control Eqs. 11-12"
  } else if (K0State$modelId == "mayne-kulhawy-reload") {
    OUT$sourceKey <- "MayneKulhawy1982"
    OUT$sourceLocator <- "Eq. 18; domain control Eqs. 11-12"
  }
  OUT$k0Applied <- K0State$k0Applied
  OUT
}

readCalculationSection <- function(config, projectRoot) {
  Path <- file.path(projectRoot, config$section$propertyTable)
  if (!file.exists(Path)) {
    stop("The corrugation property table is not available: ", Path, call. = FALSE)
  }
  Reference <- utils::read.csv(
    Path,
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  CorrugatedSection <- interpolateCorrugatedSection(
    reference = Reference,
    profileId = config$section$referenceProfileId,
    baseThicknessMm = config$section$analysisBaseThicknessMm
  )
  Radius <- config$geometry$insideDiameterM / 2
  YoungModulusKPa <- config$material$circumferentialYoungModulusGPa * 1e6
  RingSection <- calculateRingSection(
    youngModulus = YoungModulusKPa,
    area = CorrugatedSection$areaMm2PerMm * 1e-3,
    inertia = CorrugatedSection$inertiaMm4PerMm * 1e-9,
    radius = Radius
  )
  data.frame(
    scenarioId = config$scenarioId,
    sectionId = "circumferential-section",
    profileId = CorrugatedSection$profileId,
    propertyModelId = config$section$propertyModelId,
    analysisBaseThicknessMm = CorrugatedSection$analysisBaseThicknessMm,
    lowerReferenceRowId = CorrugatedSection$lowerReferenceRowId,
    upperReferenceRowId = CorrugatedSection$upperReferenceRowId,
    interpolationFraction = CorrugatedSection$interpolationFraction,
    areaMm2PerMm = CorrugatedSection$areaMm2PerMm,
    inertiaMm4PerMm = CorrugatedSection$inertiaMm4PerMm,
    circumferentialYoungModulusGPa =
      config$material$circumferentialYoungModulusGPa,
    analysisRadiusM = Radius,
    extensionalRigidityKnPerM = RingSection$extensionalRigidity,
    flexuralRigidityKnM2PerM = RingSection$flexuralRigidity,
    sectionRatio = RingSection$sectionRatio,
    evidenceLevel = "DE",
    sourceKey = CorrugatedSection$sourceKey,
    sourceLocator = CorrugatedSection$sourceLocator,
    domainStatus = CorrugatedSection$domainStatus,
    stringsAsFactors = FALSE
  )
}

.inputRow <- function(
  scenarioId,
  caseId,
  groupId,
  parameterId,
  symbol,
  numericValue = NA_real_,
  textValue = NA_character_,
  unit = "-",
  evidenceLevel,
  conditionCode
) {
  data.frame(
    scenarioId = scenarioId,
    caseId = caseId,
    groupId = groupId,
    parameterId = parameterId,
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
  Id <- config$scenarioId
  Rows <- list(
    .inputRow(Id, NA, "geometry", "inside-diameter", "D_i", config$geometry$insideDiameterM, unit = "m", evidenceLevel = "PN", conditionCode = "provided-nominal"),
    .inputRow(Id, NA, "geometry", "analysis-radius-rule", "radiusRule", textValue = config$geometry$analysisRadiusRule, evidenceLevel = "HA", conditionCode = "adopted-rule"),
    .inputRow(Id, NA, "section", "nominal-corrugation-pitch", "pitch", config$section$nominalCorrugationPitchMm, unit = "mm", evidenceLevel = "PN", conditionCode = "provided-nominal"),
    .inputRow(Id, NA, "section", "nominal-corrugation-depth", "depth", config$section$nominalCorrugationDepthMm, unit = "mm", evidenceLevel = "PN", conditionCode = "provided-nominal"),
    .inputRow(Id, NA, "section", "reported-thickness", "t_0", config$section$reportedThicknessMm, unit = "mm", evidenceLevel = "PN", conditionCode = "provided-nominal"),
    .inputRow(Id, NA, "section", "analysis-base-thickness", "t_b", config$section$analysisBaseThicknessMm, unit = "mm", evidenceLevel = "HA", conditionCode = "adopted-base-thickness"),
    .inputRow(Id, NA, "section", "reference-profile", "profileId", textValue = config$section$referenceProfileId, evidenceLevel = "HA", conditionCode = "selected-reference"),
    .inputRow(Id, NA, "section", "property-model", "propertyModelId", textValue = config$section$propertyModelId, evidenceLevel = "HA", conditionCode = "adopted-model"),
    .inputRow(Id, NA, "material", "circumferential-young-modulus", "E_theta", config$material$circumferentialYoungModulusGPa, unit = "GPa", evidenceLevel = "HA", conditionCode = "adopted-value"),
    .inputRow(Id, NA, "stress-state", "state-point", "statePointId", textValue = config$stressState$statePointId, evidenceLevel = "HA", conditionCode = "analytical-scenario"),
    .inputRow(Id, NA, "stress-state", "effective-vertical", "sigma'_v,A", config$stressState$effectiveVerticalKPa, unit = "kPa", evidenceLevel = "HA", conditionCode = "analytical-scenario"),
    .inputRow(Id, NA, "stress-state", "water-pressure-difference", "Delta u_A", config$stressState$waterPressureDifferenceKPa, unit = "kPa", evidenceLevel = "HA", conditionCode = "analytical-scenario"),
    .inputRow(Id, NA, "stress-state", "horizontal-increment-mode", "horizontalIncrementMode", textValue = config$stressState$horizontalIncrementMode, evidenceLevel = "HA", conditionCode = "unknown-not-modeled"),
    .inputRow(Id, NA, "stress-state", "k0-model", "modelId", textValue = config$stressState$k0Model$modelId, evidenceLevel = "HA", conditionCode = "selected-branch")
  )
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
  ParameterIds <- c(
    k0 = "k0-value",
    frictionAngleDeg = "friction-angle",
    poissonRatio = "poisson-ratio",
    ocr = "ocr",
    ocrMaximum = "ocr-maximum"
  )
  for (Name in intersect(ModelValues, names(Model))) {
    Rows[[length(Rows) + 1L]] <- .inputRow(
      Id,
      NA,
      "stress-state",
      ParameterIds[[Name]],
      Symbols[[Name]],
      Model[[Name]],
      unit = Units[[Name]],
      evidenceLevel = "HA",
      conditionCode = "branch-primitive"
    )
  }
  for (Index in seq_len(nrow(config$loadCases))) {
    Rows[[length(Rows) + 1L]] <- .inputRow(
      Id,
      config$loadCases$caseId[Index],
      "load-case",
      "tangential-multiplier",
      "alpha",
      config$loadCases$alpha[Index],
      evidenceLevel = "HA",
      conditionCode = "prescribed-load-case"
    )
  }
  Rows <- c(
    Rows,
    list(
      .inputRow(Id, NA, "numerics", "base-theta-point-count", "n_theta", config$numerics$baseThetaPointCount, evidenceLevel = "HA", conditionCode = "numerical-setting"),
      .inputRow(Id, NA, "numerics", "critical-angles", "theta_c", textValue = paste(config$numerics$criticalAnglesDeg, collapse = "; "), unit = "deg", evidenceLevel = "HA", conditionCode = "numerical-setting"),
      .inputRow(Id, NA, "numerics", "integration-steps", "n_int", config$numerics$integrationSteps, evidenceLevel = "HA", conditionCode = "numerical-setting"),
      .inputRow(Id, NA, "numerics", "balance-tolerance", "epsilon_b", config$numerics$balanceTolerance, evidenceLevel = "HA", conditionCode = "numerical-setting"),
      .inputRow(Id, NA, "numerics", "closed-form-tolerance", "epsilon_c", config$numerics$closedFormTolerance, evidenceLevel = "HA", conditionCode = "numerical-setting"),
      .inputRow(Id, NA, "graphics", "graphic-amplification", "A_g", config$graphics$graphicAmplification, evidenceLevel = "HA", conditionCode = "display-setting"),
      .inputRow(Id, NA, "graphics", "radial-fraction", "f_r", config$graphics$radialFraction, evidenceLevel = "HA", conditionCode = "display-setting"),
      .inputRow(Id, NA, "graphics", "ordinate-count", "n_o", config$graphics$ordinateCount, evidenceLevel = "HA", conditionCode = "display-setting")
    )
  )
  do.call(rbind, Rows)
}

.writeCalculationProducts <- function(products, configPath, outputDirectory) {
  Parent <- dirname(outputDirectory)
  if (!dir.exists(Parent)) dir.create(Parent, recursive = TRUE)
  Stage <- tempfile("calculation-data-", tmpdir = Parent)
  if (!dir.create(Stage)) {
    stop("Could not create the calculation staging directory.", call. = FALSE)
  }
  on.exit(unlink(Stage, recursive = TRUE, force = TRUE), add = TRUE)
  for (FileName in names(products)) {
    utils::write.csv(
      products[[FileName]],
      file.path(Stage, FileName),
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
  Section <- readCalculationSection(Config, ProjectRoot)
  K0State <- resolveCalculationK0(Config$stressState$k0Model)
  EffectiveState <- calculateEffectiveStressState(
    effectiveVerticalKPa = Config$stressState$effectiveVerticalKPa,
    k0State = K0State,
    waterPressureDifferenceKPa =
      Config$stressState$waterPressureDifferenceKPa,
    horizontalIncrementKPa = NA_real_,
    horizontalIncrementStatus =
      Config$stressState$horizontalIncrementMode
  )
  StressStateId <- paste0(Config$scenarioId, "-", Config$stressState$statePointId)
  Stress <- data.frame(
    scenarioId = Config$scenarioId,
    stressStateId = StressStateId,
    modelId = K0State$modelId,
    statePointId = Config$stressState$statePointId,
    layerId = NA_character_,
    thetaIndex = NA_integer_,
    thetaRad = NA_real_,
    depthM = NA_real_,
    effectiveVerticalKPa = EffectiveState$effectiveVerticalKPa,
    frictionAngleDeg = K0State$frictionAngleDeg,
    poissonRatio = K0State$poissonRatio,
    ocr = K0State$ocr,
    ocrMaximum = K0State$ocrMaximum,
    k0Input = K0State$k0Input,
    k0Derived = K0State$k0Derived,
    k0Applied = K0State$k0Applied,
    horizontalIncrementKPa = EffectiveState$horizontalIncrementKPa,
    horizontalIncrementStatus = EffectiveState$horizontalIncrementStatus,
    effectiveHorizontalKPa = EffectiveState$effectiveHorizontalKPa,
    waterPressureDifferenceKPa =
      EffectiveState$waterPressureDifferenceKPa,
    domainStatus = K0State$domainStatus,
    k0EvidenceLevel = K0State$k0EvidenceLevel,
    evidenceLevel = "DE",
    sourceKey = K0State$sourceKey,
    sourceLocator = K0State$sourceLocator,
    stringsAsFactors = FALSE
  )

  Theta <- buildThetaMesh(
    pointCount = Config$numerics$baseThetaPointCount,
    criticalAnglesDeg = Config$numerics$criticalAnglesDeg
  )
  Cases <- Config$loadCases
  Actions <- lapply(seq_len(nrow(Cases)), function(i) {
    calculatePerimeterActions(
      stressState = EffectiveState,
      alpha = Cases$alpha[i],
      theta = Theta
    )
  })
  Responses <- lapply(seq_len(nrow(Cases)), function(i) {
    solveRingDirect(
      load = Actions[[i]]$load,
      radius = Section$analysisRadiusM,
      theta = Theta,
      sectionRatio = Section$sectionRatio,
      integrationSteps = Config$numerics$integrationSteps,
      balanceTolerance = Config$numerics$balanceTolerance
    )
  })
  names(Responses) <- Cases$caseId
  QuantityColumns <- c(N = "normalForce", M = "bendingMoment", Q = "shearForce")
  QuantityUnits <- c(N = "kN/m", M = "kN m/m", Q = "kN/m")

  PerimeterLoads <- .buildPerimeterLoadTable(
    actions = Actions,
    cases = Cases,
    scenarioId = Config$scenarioId,
    stressStateId = StressStateId
  )

  Resultants <- do.call(rbind, lapply(seq_len(nrow(Cases)), function(Index) {
    Values <- Responses[[Index]]$values
    do.call(rbind, lapply(names(QuantityColumns), function(ResultantId) {
      data.frame(
        scenarioId = Config$scenarioId,
        caseId = Cases$caseId[Index],
        sectionId = Section$sectionId,
        stressStateId = StressStateId,
        alpha = Cases$alpha[Index],
        resultantId = ResultantId,
        thetaIndex = seq_len(nrow(Values)) - 1L,
        thetaRad = Values$theta,
        thetaDeg = Values$thetaDeg,
        value = Values[[QuantityColumns[[ResultantId]]]],
        unit = QuantityUnits[[ResultantId]],
        evidenceLevel = "DE",
        stringsAsFactors = FALSE
      )
    }))
  }))
  rownames(Resultants) <- NULL

  Extrema <- do.call(rbind, lapply(seq_len(nrow(Cases)), function(Index) {
    Values <- Responses[[Index]]$values
    do.call(rbind, lapply(names(QuantityColumns), function(ResultantId) {
      Column <- Values[[QuantityColumns[[ResultantId]]]]
      Indices <- c(which.min(Column), which.max(Column), which.max(abs(Column)))
      Statistics <- c("minimum", "maximum", "absolute-maximum")
      Signed <- Column[Indices]
      data.frame(
        scenarioId = Config$scenarioId,
        caseId = Cases$caseId[Index],
        alpha = Cases$alpha[Index],
        resultantId = ResultantId,
        statisticId = Statistics,
        value = c(Signed[1L], Signed[2L], abs(Signed[3L])),
        signedValue = Signed,
        thetaRad = Values$theta[Indices],
        thetaDeg = Values$thetaDeg[Indices],
        unit = QuantityUnits[[ResultantId]],
        evidenceLevel = "DE",
        stringsAsFactors = FALSE
      )
    }))
  }))
  rownames(Extrema) <- NULL

  Controls <- do.call(rbind, lapply(seq_len(nrow(Cases)), function(Index) {
    Closed <- solveBiaxialTangentialMultiplierClosed(
      effectiveVertical = Stress$effectiveVerticalKPa,
      effectiveHorizontal = Stress$effectiveHorizontalKPa,
      waterPressureDifference = Stress$waterPressureDifferenceKPa,
      radius = Section$analysisRadiusM,
      tangentialMultiplier = Cases$alpha[Index],
      theta = Theta,
      sectionRatio = Section$sectionRatio
    )
    Direct <- Responses[[Index]]
    do.call(rbind, lapply(names(QuantityColumns), function(ResultantId) {
      Error <- max(abs(
        Direct$values[[QuantityColumns[[ResultantId]]]] -
          Closed$values[[QuantityColumns[[ResultantId]]]]
      ))
      data.frame(
        scenarioId = Config$scenarioId,
        caseId = Cases$caseId[Index],
        alpha = Cases$alpha[Index],
        controlId = "closed-form-resultants",
        resultantId = ResultantId,
        metricId = "maximum-absolute-difference",
        observedValue = Error,
        comparison = "<=",
        limitValue = Config$numerics$closedFormTolerance,
        unit = QuantityUnits[[ResultantId]],
        pass = Error <= Config$numerics$closedFormTolerance,
        thetaPointCount = length(Theta),
        integrationSteps = Config$numerics$integrationSteps,
        evidenceLevel = "CI",
        stringsAsFactors = FALSE
      )
    }))
  }))
  rownames(Controls) <- NULL
  if (!all(Controls$pass)) {
    stop("One or more closed-form numerical controls failed.", call. = FALSE)
  }

  DisplayScales <- do.call(rbind, lapply(names(QuantityColumns), function(ResultantId) {
    Current <- Resultants[Resultants$resultantId == ResultantId, , drop = FALSE]
    Maximum <- max(abs(Current$value))
    data.frame(
      scenarioId = Config$scenarioId,
      resultantId = ResultantId,
      referenceRadiusM = Section$analysisRadiusM,
      displayScale = Config$graphics$radialFraction *
        Section$analysisRadiusM / Maximum,
      maximumAbsoluteValue = Maximum,
      resultantUnit = QuantityUnits[[ResultantId]],
      radialFraction = Config$graphics$radialFraction,
      graphicAmplification = Config$graphics$graphicAmplification,
      ordinateCount = Config$graphics$ordinateCount,
      evidenceLevel = "DE",
      stringsAsFactors = FALSE
    )
  }))

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
