if (!exists("readCalculationJson", mode = "function", inherits = TRUE)) {
  stop(
    paste(
      "Source scripts/setup/utils.R before",
      "scripts/R/calculationData.R."
    ),
    call. = FALSE
  )
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
  OUT <- list(modelID = ModelID)
  if ("k0" %in% BranchFields) {
    OUT$k0 <- .readNumber(model, "k0", Path, minimum = 0)
  }
  if ("frictionAngleDeg" %in% BranchFields) {
    OUT$frictionAngleDeg <- .readNumber(
      model,
      "frictionAngleDeg",
      Path,
      minimum = 0,
      maximum = 90,
      strictMinimum = TRUE
    )
    if (OUT$frictionAngleDeg >= 90) {
      stop(Path, ".frictionAngleDeg must be less than 90.", call. = FALSE)
    }
  }
  if ("poissonRatio" %in% BranchFields) {
    OUT$poissonRatio <- .readNumber(
      model,
      "poissonRatio",
      Path,
      minimum = 0,
      maximum = 0.5
    )
    if (OUT$poissonRatio >= 0.5) {
      stop(Path, ".poissonRatio must be less than 0.5.", call. = FALSE)
    }
  }
  if ("ocr" %in% BranchFields) {
    OUT$ocr <- .readNumber(model, "ocr", Path, minimum = 1)
  }
  if ("ocrMaximum" %in% BranchFields) {
    OUT$ocrMaximum <- .readNumber(model, "ocrMaximum", Path, minimum = 1)
  }
  OUT
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

.writeCalculationProducts <- function(
  products,
  configPath,
  outputDirectory,
  config = NULL
) {
  Parent <- dirname(outputDirectory)
  if (!dir.exists(Parent)) {
    dir.create(Parent, recursive = TRUE)
  }
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
  ConfigTarget <- file.path(Stage, "calculation.config.json")
  if (is.null(config)) {
    if (!file.copy(configPath, ConfigTarget)) {
      stop(
        "Could not stage the calculation configuration snapshot.",
        call. = FALSE
      )
    }
  } else {
    jsonlite::write_json(
      config,
      ConfigTarget,
      auto_unbox = TRUE,
      pretty = TRUE,
      digits = NA
    )
    if (!file.exists(ConfigTarget)) {
      stop(
        "Could not stage the calculation configuration snapshot.",
        call. = FALSE
      )
    }
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
    # The staged products are flat files; subdirectories such as the ring
    # benchmark set are separately owned and must survive the swap.
    for (s in list.dirs(Backup, full.names = FALSE, recursive = FALSE)) {
      if (!nzchar(s)) next
      if (!file.rename(file.path(Backup, s), file.path(outputDirectory, s))) {
        stop(
          "Could not preserve the ", s, " products during the swap; they ",
          "remain at ", Backup, ".",
          call. = FALSE
        )
      }
    }
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
  Manifest <- readCalculationJson(ConfigPath)
  ConfigSnapshot <- NULL
  if (identical(
    Manifest[["contractVersion", exact = TRUE]],
    "cover-case-2"
  )) {
    if (!exists("resolveCoverCaseConfig", mode = "function", inherits = TRUE)) {
      stop(
        paste(
          "Source scripts/R/coverCase.R before building a cover-case-2",
          "calculation."
        ),
        call. = FALSE
      )
    }
    .coverCaseRequireFields(
      Manifest,
      c("contractVersion", "methodID", "inputs"),
      "calculation.json"
    )
    Resolved <- resolveCoverCaseConfig(
      inputs = Manifest[["inputs", exact = TRUE]],
      projectRoot = ProjectRoot,
      methodID = Manifest[["methodID", exact = TRUE]]
    )
    Config <- Resolved[["config", exact = TRUE]]
    ConfigSnapshot <- Resolved[["configSource", exact = TRUE]]
  } else {
    if (!exists(
      "validateCoverCalculationConfig",
      mode = "function",
      inherits = TRUE
    )) {
      stop(
        paste(
          "Source scripts/R/coverCalculationData.R before validating",
          "a resolved cover calculation."
        ),
        call. = FALSE
      )
    }
    Config <- validateCoverCalculationConfig(Manifest)
  }
  if (!(Config[["schemaVersion", exact = TRUE]] %in% c("3.0.0", "3.1.0"))) {
    stop(
      "Unsupported calculation schemaVersion: ",
      Config[["schemaVersion", exact = TRUE]],
      ".",
      call. = FALSE
    )
  }
  if (!exists(
    ".buildCoverCalculationProducts",
    mode = "function",
    inherits = TRUE
  )) {
    stop(
      paste(
        "Source scripts/R/coverCalculationData.R before building",
        "cover calculation products."
      ),
      call. = FALSE
    )
  }
  Products <- .buildCoverCalculationProducts(
    config = Config,
    projectRoot = ProjectRoot
  )
  .writeCalculationProducts(
    products = Products,
    configPath = ConfigPath,
    outputDirectory = outputDirectory,
    config = ConfigSnapshot
  )
  list(
    config = Config,
    products = Products,
    outputDirectory = normalizePath(outputDirectory, mustWork = TRUE)
  )
}
