# Public engineering-input boundary for the deterministic cover calculation.

.coverCaseRequireObject <- function(value, path) {
  if (!is.list(value) || is.data.frame(value) || is.null(names(value))) {
    stop(path, " must be one named object.", call. = FALSE)
  }
  value
}

.coverCaseRequireFields <- function(value, required, path) {
  Value <- .coverCaseRequireObject(value, path)
  Missing <- setdiff(required, names(Value))
  Extra <- setdiff(names(Value), required)
  if (length(Missing) > 0L) {
    stop(
      path, " is missing: ", paste(Missing, collapse = ", "), ".",
      call. = FALSE
    )
  }
  if (length(Extra) > 0L) {
    stop(
      path, " contains unsupported fields: ",
      paste(Extra, collapse = ", "), ".",
      call. = FALSE
    )
  }
  Value
}

.coverCaseReadNumber <- function(
  value,
  name,
  path,
  minimum = -Inf,
  maximum = Inf,
  strictMinimum = FALSE,
  strictMaximum = FALSE
) {
  Value <- value[[name, exact = TRUE]]
  if (!is.numeric(Value) || length(Value) != 1L || !is.finite(Value)) {
    stop(path, ".", name, " must be one finite number.", call. = FALSE)
  }
  MinimumFailure <- if (strictMinimum) Value <= minimum else Value < minimum
  MaximumFailure <- if (strictMaximum) Value >= maximum else Value > maximum
  if (MinimumFailure || MaximumFailure) {
    stop(path, ".", name, " is outside its supported range.", call. = FALSE)
  }
  as.numeric(Value)
}

.coverCaseReadID <- function(value, name, path) {
  Value <- value[[name, exact = TRUE]]
  if (!is.character(Value) || length(Value) != 1L || is.na(Value) ||
      !nzchar(Value)) {
    stop(path, ".", name, " must be one non-empty identifier.", call. = FALSE)
  }
  Value
}

.coverCaseReadFlag <- function(value, name, path) {
  Value <- value[[name, exact = TRUE]]
  if (!is.logical(Value) || length(Value) != 1L || is.na(Value)) {
    stop(path, ".", name, " must be TRUE or FALSE.", call. = FALSE)
  }
  Value
}

.coverCaseNumberToken <- function(value) {
  Text <- format(value, scientific = FALSE, trim = TRUE, digits = 12)
  Text <- sub("[.]0+$", "", Text)
  Text <- sub("([.][0-9]*?)0+$", "\\1", Text)
  gsub("[.]", "p", Text)
}

.coverCaseTextToken <- function(value) {
  Text <- tolower(gsub("[^A-Za-z0-9]+", "-", value))
  gsub("(^-+|-+$)", "", Text)
}

.normaliseCoverCaseInputs <- function(inputs) {
  Inputs <- .coverCaseRequireFields(
    inputs,
    c(
      "cover", "ground", "steel", "seam", "plainConcrete",
      "reinforcedConcrete"
    ),
    "inputs"
  )
  Cover <- .coverCaseRequireFields(
    Inputs[["cover", exact = TRUE]],
    c("coverCrownM", "crownToAxisM"),
    "inputs.cover"
  )
  Ground <- .coverCaseRequireFields(
    Inputs[["ground", exact = TRUE]],
    c(
      "effectiveUnitWeightKnPerM3", "effectiveSurchargeKPa", "modulusKPa",
      "poisson", "k0ModelID", "frictionAngleDeg", "ocr",
      "waterPressureDifferenceKPa"
    ),
    "inputs.ground"
  )
  Steel <- .coverCaseRequireFields(
    Inputs[["steel", exact = TRUE]],
    c(
      "sectionReferenceID", "centroidalRadiusM", "remainingBaseThicknessMm",
      "youngModulusKPa", "poisson", "yieldStrengthMPa",
      "tensileStrengthMPa"
    ),
    "inputs.steel"
  )
  Seam <- .coverCaseRequireFields(
    Inputs[["seam", exact = TRUE]],
    c(
      "resistanceReferenceID", "fastenerDiameterMm",
      "fastenerDiameterLossRatio"
    ),
    "inputs.seam"
  )
  Plain <- .coverCaseRequireFields(
    Inputs[["plainConcrete", exact = TRUE]],
    c(
      "outerRadiusM", "thicknessM", "poisson", "compressiveStrengthMPa",
      "castAgainstSoil"
    ),
    "inputs.plainConcrete"
  )
  Reinforced <- .coverCaseRequireFields(
    Inputs[["reinforcedConcrete", exact = TRUE]],
    c(
      "outerRadiusM", "thicknessM", "poisson", "compressiveStrengthMPa",
      "reinforcementGradeID", "barDiameterMm", "barSpacingMm",
      "clearCoverRatio", "reinforcementModulusMPa"
    ),
    "inputs.reinforcedConcrete"
  )

  CoverCrown <- .coverCaseReadNumber(
    Cover, "coverCrownM", "inputs.cover", minimum = 0
  )
  CrownToAxis <- .coverCaseReadNumber(
    Cover, "crownToAxisM", "inputs.cover", minimum = 0,
    strictMinimum = TRUE
  )
  GroundPoisson <- .coverCaseReadNumber(
    Ground, "poisson", "inputs.ground", minimum = -1, maximum = 0.5,
    strictMinimum = TRUE, strictMaximum = TRUE
  )
  K0ModelID <- .coverCaseReadID(
    Ground,
    "k0ModelID",
    "inputs.ground"
  )
  if (!(K0ModelID %in% c("jaky-nc", "mayne-kulhawy-unloading"))) {
    stop(
      "Unsupported inputs.ground.k0ModelID: ",
      K0ModelID,
      ".",
      call. = FALSE
    )
  }
  FrictionAngle <- .coverCaseReadNumber(
    Ground,
    "frictionAngleDeg",
    "inputs.ground",
    minimum = 0,
    maximum = 90,
    strictMinimum = TRUE,
    strictMaximum = TRUE
  )
  Ocr <- .coverCaseReadNumber(
    Ground,
    "ocr",
    "inputs.ground",
    minimum = 1
  )
  if (K0ModelID == "jaky-nc" && Ocr != 1) {
    stop(
      paste(
        "inputs.ground.ocr must equal 1 for k0ModelID = jaky-nc;",
        "select mayne-kulhawy-unloading for OCR greater than 1."
      ),
      call. = FALSE
    )
  }
  SteelPoisson <- .coverCaseReadNumber(
    Steel, "poisson", "inputs.steel", minimum = -1, maximum = 0.5,
    strictMinimum = TRUE, strictMaximum = TRUE
  )
  PlainOuterRadius <- .coverCaseReadNumber(
    Plain, "outerRadiusM", "inputs.plainConcrete", minimum = 0,
    strictMinimum = TRUE
  )
  PlainThickness <- .coverCaseReadNumber(
    Plain, "thicknessM", "inputs.plainConcrete", minimum = 0,
    strictMinimum = TRUE
  )
  ReinforcedOuterRadius <- .coverCaseReadNumber(
    Reinforced, "outerRadiusM", "inputs.reinforcedConcrete", minimum = 0,
    strictMinimum = TRUE
  )
  ReinforcedThickness <- .coverCaseReadNumber(
    Reinforced, "thicknessM", "inputs.reinforcedConcrete", minimum = 0,
    strictMinimum = TRUE
  )
  if (PlainThickness >= 2 * PlainOuterRadius) {
    stop(
      "inputs.plainConcrete.thicknessM is incompatible with outerRadiusM.",
      call. = FALSE
    )
  }
  if (ReinforcedThickness >= 2 * ReinforcedOuterRadius) {
    stop(
      paste(
        "inputs.reinforcedConcrete.thicknessM is incompatible with",
        "outerRadiusM."
      ),
      call. = FALSE
    )
  }
  ReinforcementGradeID <- .coverCaseReadID(
    Reinforced,
    "reinforcementGradeID",
    "inputs.reinforcedConcrete"
  )
  if (!identical(ReinforcementGradeID, "Grade-60")) {
    stop(
      "Unsupported reinforcedConcrete.reinforcementGradeID: ",
      ReinforcementGradeID,
      ".",
      call. = FALSE
    )
  }
  BarDiameter <- .coverCaseReadNumber(
    Reinforced,
    "barDiameterMm",
    "inputs.reinforcedConcrete",
    minimum = 0,
    strictMinimum = TRUE
  )
  BarSpacing <- .coverCaseReadNumber(
    Reinforced,
    "barSpacingMm",
    "inputs.reinforcedConcrete",
    minimum = 0,
    strictMinimum = TRUE
  )
  ClearCoverRatio <- .coverCaseReadNumber(
    Reinforced,
    "clearCoverRatio",
    "inputs.reinforcedConcrete",
    minimum = 0,
    maximum = 0.5,
    strictMinimum = TRUE,
    strictMaximum = TRUE
  )
  ReinforcementModulus <- .coverCaseReadNumber(
    Reinforced,
    "reinforcementModulusMPa",
    "inputs.reinforcedConcrete",
    minimum = 0,
    strictMinimum = TRUE
  )
  calculateSymmetricReinforcementMesh(
    thicknessM = ReinforcedThickness,
    barDiameterMm = BarDiameter,
    barSpacingMm = BarSpacing,
    clearCoverRatio = ClearCoverRatio,
    reinforcementGradeID = ReinforcementGradeID,
    reinforcementModulusMPa = ReinforcementModulus
  )

  list(
    cover = list(
      coverCrownM = CoverCrown,
      crownToAxisM = CrownToAxis
    ),
    ground = list(
      effectiveUnitWeightKnPerM3 = .coverCaseReadNumber(
        Ground,
        "effectiveUnitWeightKnPerM3",
        "inputs.ground",
        minimum = 0,
        strictMinimum = TRUE
      ),
      effectiveSurchargeKPa = .coverCaseReadNumber(
        Ground,
        "effectiveSurchargeKPa",
        "inputs.ground",
        minimum = 0
      ),
      modulusKPa = .coverCaseReadNumber(
        Ground, "modulusKPa", "inputs.ground", minimum = 0,
        strictMinimum = TRUE
      ),
      poisson = GroundPoisson,
      k0ModelID = K0ModelID,
      frictionAngleDeg = FrictionAngle,
      ocr = Ocr,
      waterPressureDifferenceKPa = .coverCaseReadNumber(
        Ground,
        "waterPressureDifferenceKPa",
        "inputs.ground"
      )
    ),
    steel = list(
      sectionReferenceID = .coverCaseReadID(
        Steel, "sectionReferenceID", "inputs.steel"
      ),
      centroidalRadiusM = .coverCaseReadNumber(
        Steel, "centroidalRadiusM", "inputs.steel", minimum = 0,
        strictMinimum = TRUE
      ),
      remainingBaseThicknessMm = .coverCaseReadNumber(
        Steel, "remainingBaseThicknessMm", "inputs.steel", minimum = 0,
        strictMinimum = TRUE
      ),
      youngModulusKPa = .coverCaseReadNumber(
        Steel, "youngModulusKPa", "inputs.steel", minimum = 0,
        strictMinimum = TRUE
      ),
      poisson = SteelPoisson,
      yieldStrengthMPa = .coverCaseReadNumber(
        Steel, "yieldStrengthMPa", "inputs.steel", minimum = 0,
        strictMinimum = TRUE
      ),
      tensileStrengthMPa = .coverCaseReadNumber(
        Steel, "tensileStrengthMPa", "inputs.steel", minimum = 0,
        strictMinimum = TRUE
      )
    ),
    seam = list(
      resistanceReferenceID = .coverCaseReadID(
        Seam, "resistanceReferenceID", "inputs.seam"
      ),
      fastenerDiameterMm = .coverCaseReadNumber(
        Seam, "fastenerDiameterMm", "inputs.seam", minimum = 0,
        strictMinimum = TRUE
      ),
      fastenerDiameterLossRatio = .coverCaseReadNumber(
        Seam, "fastenerDiameterLossRatio", "inputs.seam", minimum = 0,
        maximum = 1, strictMaximum = TRUE
      )
    ),
    plainConcrete = list(
      outerRadiusM = PlainOuterRadius,
      thicknessM = PlainThickness,
      poisson = .coverCaseReadNumber(
        Plain, "poisson", "inputs.plainConcrete", minimum = -1,
        maximum = 0.5, strictMinimum = TRUE, strictMaximum = TRUE
      ),
      compressiveStrengthMPa = .coverCaseReadNumber(
        Plain, "compressiveStrengthMPa", "inputs.plainConcrete", minimum = 0,
        strictMinimum = TRUE
      ),
      castAgainstSoil = .coverCaseReadFlag(
        Plain, "castAgainstSoil", "inputs.plainConcrete"
      )
    ),
    reinforcedConcrete = list(
      outerRadiusM = ReinforcedOuterRadius,
      thicknessM = ReinforcedThickness,
      poisson = .coverCaseReadNumber(
        Reinforced, "poisson", "inputs.reinforcedConcrete", minimum = -1,
        maximum = 0.5, strictMinimum = TRUE, strictMaximum = TRUE
      ),
      compressiveStrengthMPa = .coverCaseReadNumber(
        Reinforced,
        "compressiveStrengthMPa",
        "inputs.reinforcedConcrete",
        minimum = 0,
        strictMinimum = TRUE
      ),
      reinforcementGradeID = ReinforcementGradeID,
      barDiameterMm = BarDiameter,
      barSpacingMm = BarSpacing,
      clearCoverRatio = ClearCoverRatio,
      reinforcementModulusMPa = ReinforcementModulus
    )
  )
}

.coverCaseMethodProfile <- function(projectRoot, methodID) {
  MethodProfiles <- c(
    `ar-sad40-cover-mesh-2026-08-16` =
      "cover.method.mesh.2026-08-16.json"
  )
  ResolvedMethodID <- methodID
  if (identical(methodID, "ar-sad40-cover-current")) {
    AliasPath <- file.path(
      projectRoot, "scripts", "config", "cover.method.current.json"
    )
    Alias <- .coverCaseRequireFields(
      readCalculationJson(AliasPath),
      c("aliasID", "methodProfileID", "profileFile"),
      "cover method alias"
    )
    if (!identical(Alias[["aliasID", exact = TRUE]], methodID)) {
      stop("The cover method alias identity is inconsistent.", call. = FALSE)
    }
    ResolvedMethodID <- Alias[["methodProfileID", exact = TRUE]]
    RegisteredFile <- unname(MethodProfiles[ResolvedMethodID])
    if (length(RegisteredFile) != 1L || is.na(RegisteredFile) ||
        !identical(Alias[["profileFile", exact = TRUE]], RegisteredFile)) {
      stop("The cover method alias target is not registered.", call. = FALSE)
    }
  }
  ProfileFile <- unname(MethodProfiles[ResolvedMethodID])
  if (length(ProfileFile) != 1L || is.na(ProfileFile)) {
    stop("Unsupported methodID: ", methodID, ".", call. = FALSE)
  }
  ProfilePath <- file.path(projectRoot, "scripts", "config", ProfileFile)
  if (!file.exists(ProfilePath)) {
    stop("The cover method profile is not available.", call. = FALSE)
  }
  Profile <- readCalculationJson(ProfilePath)
  ProfileID <- Profile[["methodProfileID", exact = TRUE]]
  ProfileVersion <- Profile[["methodProfileVersion", exact = TRUE]]
  if (!identical(ProfileID, ResolvedMethodID) ||
      !is.character(ProfileVersion) || length(ProfileVersion) != 1L ||
      is.na(ProfileVersion) || !nzchar(ProfileVersion)) {
    stop("The cover method profile identity is inconsistent.", call. = FALSE)
  }
  Profile[["methodProfileID"]] <- NULL
  Profile[["methodProfileVersion"]] <- NULL
  list(
    path = normalizePath(ProfilePath, mustWork = TRUE),
    requestedMethodID = methodID,
    methodProfileID = ProfileID,
    methodProfileVersion = ProfileVersion,
    config = Profile
  )
}

.prepareCoverMethod <- function(
  projectRoot,
  methodID = "ar-sad40-cover-current"
) {
  ProjectRoot <- normalizePath(projectRoot, mustWork = TRUE)
  list(
    contextVersion = "cover-method-context-1",
    projectRoot = ProjectRoot,
    methodID = methodID,
    profile = .coverCaseMethodProfile(ProjectRoot, methodID)
  )
}

.resolveCoverCaseProfile <- function(inputs, method) {
  if (!is.list(method) ||
      !identical(method[["contextVersion", exact = TRUE]],
                 "cover-method-context-1") ||
      !is.list(method[["profile", exact = TRUE]])) {
    stop("method must be returned by .prepareCoverMethod().", call. = FALSE)
  }
  methodID <- method[["methodID", exact = TRUE]]
  Inputs <- .normaliseCoverCaseInputs(inputs)
  Profile <- method[["profile", exact = TRUE]]
  Config <- Profile[["config", exact = TRUE]]

  SectionReferenceID <- Inputs[["steel", exact = TRUE]][[
    "sectionReferenceID",
    exact = TRUE
  ]]
  ProfileReferenceID <- Config[["sectionReference", exact = TRUE]][[
    "referenceRowID",
    exact = TRUE
  ]]
  if (!identical(SectionReferenceID, ProfileReferenceID)) {
    stop(
      "Unsupported steel.sectionReferenceID: ", SectionReferenceID, ".",
      call. = FALSE
    )
  }
  SeamReferenceID <- Inputs[["seam", exact = TRUE]][[
    "resistanceReferenceID",
    exact = TRUE
  ]]
  ProfileSeamID <- Config[["aashto", exact = TRUE]][["seam", exact = TRUE]][[
    "seamID",
    exact = TRUE
  ]]
  if (!identical(SeamReferenceID, ProfileSeamID)) {
    stop(
      "Unsupported seam.resistanceReferenceID: ", SeamReferenceID, ".",
      call. = FALSE
    )
  }

  Cover <- Inputs[["cover", exact = TRUE]]
  Ground <- Inputs[["ground", exact = TRUE]]
  Steel <- Inputs[["steel", exact = TRUE]]
  Seam <- Inputs[["seam", exact = TRUE]]
  Plain <- Inputs[["plainConcrete", exact = TRUE]]
  Reinforced <- Inputs[["reinforcedConcrete", exact = TRUE]]

  Config[["scenarioID"]] <- paste0(
    "deterministic-cover-h",
    .coverCaseNumberToken(Cover[["coverCrownM", exact = TRUE]])
  )
  Config[["cover"]][["coverCrownM"]] <- Cover[["coverCrownM", exact = TRUE]]
  Config[["cover"]][["crownToAxisM"]] <- Cover[["crownToAxisM", exact = TRUE]]
  Config[["cover"]][["effectiveUnitWeightKnPerM3"]] <- Ground[[
    "effectiveUnitWeightKnPerM3",
    exact = TRUE
  ]]
  Config[["cover"]][["effectiveSurchargeKPa"]] <- Ground[[
    "effectiveSurchargeKPa",
    exact = TRUE
  ]]
  Config[["ground"]][["modulusKPa"]] <- Ground[["modulusKPa", exact = TRUE]]
  Config[["ground"]][["poisson"]] <- Ground[["poisson", exact = TRUE]]
  Config[["ground"]][["k0"]] <- if (
    Ground[["k0ModelID", exact = TRUE]] == "jaky-nc"
  ) {
    list(
      modelID = "jaky-nc",
      frictionAngleDeg = Ground[["frictionAngleDeg", exact = TRUE]]
    )
  } else {
    list(
      modelID = "mayne-kulhawy-unloading",
      frictionAngleDeg = Ground[["frictionAngleDeg", exact = TRUE]],
      ocr = Ground[["ocr", exact = TRUE]]
    )
  }
  Config[["action"]][["waterPressureDifferenceKPa"]] <- Ground[[
    "waterPressureDifferenceKPa",
    exact = TRUE
  ]]

  Config[["lining"]][["sectionID"]] <- paste0(
    SectionReferenceID,
    "-remaining-t",
    .coverCaseNumberToken(Steel[["remainingBaseThicknessMm", exact = TRUE]])
  )
  Config[["lining"]][["centroidalRadiusM"]] <- Steel[[
    "centroidalRadiusM",
    exact = TRUE
  ]]
  Config[["lining"]][["remainingBaseThicknessMm"]] <- Steel[[
    "remainingBaseThicknessMm",
    exact = TRUE
  ]]
  Config[["lining"]][["youngModulusKPa"]] <- Steel[[
    "youngModulusKPa",
    exact = TRUE
  ]]
  Config[["lining"]][["poisson"]] <- Steel[["poisson", exact = TRUE]]
  Config[["lining"]][["yieldStrengthMPa"]] <- Steel[[
    "yieldStrengthMPa",
    exact = TRUE
  ]]

  Config[["aashto"]][["totalUnitWeightKnPerM3"]] <- Ground[[
    "effectiveUnitWeightKnPerM3",
    exact = TRUE
  ]]
  Config[["aashto"]][["spanM"]] <- 2 * Steel[[
    "centroidalRadiusM",
    exact = TRUE
  ]]
  Config[["aashto"]][["tensileStrengthMPa"]] <- Steel[[
    "tensileStrengthMPa",
    exact = TRUE
  ]]
  Config[["aashto"]][["materialID"]] <- paste0(
    "adopted-steel-fy",
    .coverCaseNumberToken(Steel[["yieldStrengthMPa", exact = TRUE]]),
    "-fu",
    .coverCaseNumberToken(Steel[["tensileStrengthMPa", exact = TRUE]])
  )
  Config[["aashto"]][["seam"]][["fastenerDiameterMm"]] <- Seam[[
    "fastenerDiameterMm",
    exact = TRUE
  ]]
  Config[["aashto"]][["seam"]][["fastenerDiameterLossRatio"]] <- Seam[[
    "fastenerDiameterLossRatio",
    exact = TRUE
  ]]

  Config[["additionalLinings"]][["shotcrete"]][["outerRadiusM"]] <- Plain[[
    "outerRadiusM",
    exact = TRUE
  ]]
  Config[["additionalLinings"]][["shotcrete"]][["thicknessM"]] <- Plain[[
    "thicknessM",
    exact = TRUE
  ]]
  Config[["additionalLinings"]][["shotcrete"]][["poisson"]] <- Plain[[
    "poisson",
    exact = TRUE
  ]]
  Config[["additionalLinings"]][["shotcrete"]][[
    "compressiveStrengthMPa"
  ]] <- Plain[["compressiveStrengthMPa", exact = TRUE]]
  Config[["additionalLinings"]][["shotcrete"]][["aci"]][[
    "castAgainstSoil"
  ]] <- Plain[["castAgainstSoil", exact = TRUE]]
  Config[["additionalLinings"]][["shotcrete"]][["sectionID"]] <- paste0(
    "shotcrete-t",
    formatC(Plain[["thicknessM", exact = TRUE]], format = "f", digits = 2L),
    "-fc",
    .coverCaseNumberToken(Plain[["compressiveStrengthMPa", exact = TRUE]]),
    "-plain"
  )

  ReinforcedMesh <- calculateSymmetricReinforcementMesh(
    thicknessM = Reinforced[["thicknessM", exact = TRUE]],
    barDiameterMm = Reinforced[["barDiameterMm", exact = TRUE]],
    barSpacingMm = Reinforced[["barSpacingMm", exact = TRUE]],
    clearCoverRatio = Reinforced[["clearCoverRatio", exact = TRUE]],
    reinforcementGradeID = Reinforced[["reinforcementGradeID", exact = TRUE]],
    reinforcementModulusMPa = Reinforced[[
      "reinforcementModulusMPa",
      exact = TRUE
    ]]
  )
  ReinforcedConfig <- Config[["additionalLinings", exact = TRUE]][[
    "reinforcedConcrete",
    exact = TRUE
  ]]
  ReinforcedConfig[["outerRadiusM"]] <- Reinforced[[
    "outerRadiusM",
    exact = TRUE
  ]]
  ReinforcedConfig[["thicknessM"]] <- Reinforced[["thicknessM", exact = TRUE]]
  ReinforcedConfig[["poisson"]] <- Reinforced[["poisson", exact = TRUE]]
  ReinforcedConfig[["compressiveStrengthMPa"]] <- Reinforced[[
    "compressiveStrengthMPa",
    exact = TRUE
  ]]
  ReinforcedConfig[["sectionID"]] <- paste0(
    "shotcrete-t",
    formatC(
      Reinforced[["thicknessM", exact = TRUE]],
      format = "f",
      digits = 2L
    ),
    "-fc",
    .coverCaseNumberToken(Reinforced[[
      "compressiveStrengthMPa",
      exact = TRUE
    ]]),
    "-reinforced-d",
    .coverCaseNumberToken(Reinforced[["barDiameterMm", exact = TRUE]]),
    "-s",
    .coverCaseNumberToken(Reinforced[["barSpacingMm", exact = TRUE]]),
    "-c",
    .coverCaseNumberToken(Reinforced[["clearCoverRatio", exact = TRUE]]),
    "-",
    .coverCaseTextToken(Reinforced[["reinforcementGradeID", exact = TRUE]])
  )
  ReinforcedConfig[["reinforcementGradeID"]] <- Reinforced[[
    "reinforcementGradeID",
    exact = TRUE
  ]]
  ReinforcedConfig[["reinforcementLayout"]] <- list(
    barDiameterMm = Reinforced[["barDiameterMm", exact = TRUE]],
    barSpacingMm = Reinforced[["barSpacingMm", exact = TRUE]],
    clearCoverRatio = Reinforced[["clearCoverRatio", exact = TRUE]]
  )
  StrengthCases <- Config[["additionalLinings", exact = TRUE]][[
    "shotcrete",
    exact = TRUE
  ]][["aci", exact = TRUE]][["strengthCases", exact = TRUE]]
  if (!identical(
    StrengthCases,
    ReinforcedConfig[["aci", exact = TRUE]][["strengthCases", exact = TRUE]]
  )) {
    stop("The method profile contains inconsistent ACI strength cases.", call. = FALSE)
  }
  ReinforcedConfig[["aci"]][["strengthCases"]] <- StrengthCases
  ReinforcedConfig[["reinforcement"]] <- ReinforcedMesh[[
    "circumferentialReinforcement",
    exact = TRUE
  ]]
  ReinforcedConfig[["orthogonalReinforcement"]] <- ReinforcedMesh[[
    "orthogonalReinforcement",
    exact = TRUE
  ]]
  Config[["additionalLinings"]][["reinforcedConcrete"]] <- ReinforcedConfig
  ConfigSource <- Config
  Config <- validateCoverCalculationConfig(Config)

  AashtoMethodFields <- c(
    "standardID", "editionID", "errataID", "branchID", "productTypeID",
    "sourceBasisID", "specificationStatus", "editionStatus", "errataStatus",
    "productApplicabilityStatus", "demandBasisID", "factorBasisID",
    "combinationID", "stageID", "forceEffectStatus", "demandSourceKey",
    "demandSourceLocator", "materialSourceKey", "materialSourceLocator",
    "deadLoadFactor", "liveLoadFactor", "demandModifier",
    "liveCrownPressureKPa", "liveLoadedWidthM", "wallResistanceFactor",
    "wallSourceKey", "wallSourceLocator", "seamResistanceFactor",
    "seamFactorSourceKey", "seamFactorSourceLocator", "soilStiffnessFactor",
    "soilSourceKey", "soilSourceLocator", "flexibilityLimitMmPerN",
    "flexibilitySourceKey", "flexibilitySourceLocator",
    "minimumCoverSourceKey", "minimumCoverSourceLocator"
  )
  AashtoBasis <- ConfigSource[["aashto", exact = TRUE]][AashtoMethodFields]
  AashtoBasis[["seamReference"]] <- ConfigSource[["aashto", exact = TRUE]][[
    "seam",
    exact = TRUE
  ]][c("seamID", "nominalResistanceKnPerM", "sourceKey", "sourceLocator")]
  PlainBasis <- ConfigSource[["additionalLinings", exact = TRUE]][[
    "shotcrete",
    exact = TRUE
  ]][["aci", exact = TRUE]]
  PlainBasis[["castAgainstSoil"]] <- NULL
  ReinforcedBasis <- ReinforcedConfig[["aci", exact = TRUE]]
  ReinforcedBasis[["castAgainstSoil"]] <- NULL

  list(
    contractVersion = "cover-case-2",
    methodID = methodID,
    inputs = Inputs,
    configSource = ConfigSource,
    config = Config,
    methodBasis = list(
      requestedMethodID = Profile[["requestedMethodID", exact = TRUE]],
      methodProfileID = Profile[["methodProfileID", exact = TRUE]],
      methodProfileVersion = Profile[["methodProfileVersion", exact = TRUE]],
      profilePath = Profile[["path", exact = TRUE]],
      aashto = AashtoBasis,
      plainConcrete = PlainBasis,
      reinforcedConcrete = ReinforcedBasis
    ),
    derived = list(
      scenarioID = Config[["scenarioID", exact = TRUE]],
      steelSpanM = Config[["aashto", exact = TRUE]][["spanM", exact = TRUE]],
      totalUnitWeightKnPerM3 = Config[["aashto", exact = TRUE]][[
        "totalUnitWeightKnPerM3",
        exact = TRUE
      ]],
      plainConcreteCentroidalRadiusM = Plain[["outerRadiusM", exact = TRUE]] -
        Plain[["thicknessM", exact = TRUE]] / 2,
      reinforcedConcreteCentroidalRadiusM = Reinforced[[
        "outerRadiusM",
        exact = TRUE
      ]] - Reinforced[["thicknessM", exact = TRUE]] / 2,
      reinforcedBarAreaMm2 = ReinforcedMesh[["barAreaMm2", exact = TRUE]],
      reinforcedAreaMm2PerFaceAndDirection = ReinforcedMesh[[
        "areaMm2PerFaceAndDirection",
        exact = TRUE
      ]],
      reinforcedClearCoverMm = ReinforcedMesh[["clearCoverMm", exact = TRUE]],
      reinforcedLayerCentroidCoverMm = ReinforcedMesh[[
        "layerCentroidCoverMm",
        exact = TRUE
      ]],
      reinforcedInteriorLayerCoordinateMm = ReinforcedMesh[[
        "interiorLayerCoordinateMm",
        exact = TRUE
      ]],
      reinforcedExteriorLayerCoordinateMm = ReinforcedMesh[[
        "exteriorLayerCoordinateMm",
        exact = TRUE
      ]],
      reinforcementYieldStrengthMPa = ReinforcedMesh[[
        "yieldStrengthMPa",
        exact = TRUE
      ]]
    )
  )
}

resolveCoverCaseConfig <- function(
  inputs,
  projectRoot,
  methodID = "ar-sad40-cover-current"
) {
  Method <- .prepareCoverMethod(
    projectRoot = projectRoot,
    methodID = methodID
  )
  .resolveCoverCaseProfile(inputs = inputs, method = Method)
}

.buildCoverCaseResult <- function(resolved, evaluation) {
  list(
    contractVersion = resolved[["contractVersion", exact = TRUE]],
    scenarioID = evaluation[["scenarioID", exact = TRUE]],
    inputs = resolved[["inputs", exact = TRUE]],
    methodBasis = resolved[["methodBasis", exact = TRUE]],
    derived = c(
      resolved[["derived", exact = TRUE]],
      list(resolvedConfig = resolved[["configSource", exact = TRUE]])
    ),
    theta = evaluation[["theta", exact = TRUE]],
    stress = evaluation[["stress", exact = TRUE]],
    section = evaluation[["section", exact = TRUE]],
    interaction = evaluation[["interaction", exact = TRUE]],
    resultants = evaluation[["resultants", exact = TRUE]],
    extrema = evaluation[["extrema", exact = TRUE]],
    controls = evaluation[["controls", exact = TRUE]],
    aashto = evaluation[["aashto", exact = TRUE]],
    additionalLinings = evaluation[["additionalLinings", exact = TRUE]]
  )
}

.buildCoverDomainCache <- function(linings) {
  OUT <- lapply(linings, function(lining) {
    DomainInput <- attr(lining, ".aci31825DomainInput", exact = TRUE)
    Domains <- attr(lining, ".aci31825Domains", exact = TRUE)
    if (is.null(DomainInput) || is.null(Domains)) return(NULL)
    list(domainInput = DomainInput, domains = Domains)
  })
  OUT[!vapply(OUT, is.null, logical(1))]
}

prepareCoverCaseContext <- function(
  inputs,
  projectRoot,
  methodID = "ar-sad40-cover-current"
) {
  Method <- .prepareCoverMethod(
    projectRoot = projectRoot,
    methodID = methodID
  )
  Resolved <- .resolveCoverCaseProfile(inputs = inputs, method = Method)
  Config <- Resolved[["config", exact = TRUE]]
  Reference <- .readCoverSectionReference(
    config = Config,
    projectRoot = Method[["projectRoot", exact = TRUE]]
  )
  Numerics <- Config[["numerics", exact = TRUE]]
  Theta <- buildThetaMesh(
    pointCount = Numerics[["thetaPointCount", exact = TRUE]],
    criticalAnglesDeg = Numerics[["criticalAnglesDeg", exact = TRUE]]
  )
  Linings <- .prepareCoverLinings(
    linings = Config[["additionalLinings", exact = TRUE]]
  )
  list(
    contextVersion = "cover-case-context-1",
    contractVersion = Resolved[["contractVersion", exact = TRUE]],
    method = Method,
    reference = Reference,
    theta = Theta,
    domainCache = .buildCoverDomainCache(Linings),
    baselineInputs = Resolved[["inputs", exact = TRUE]],
    baselineResolved = Resolved
  )
}

.useCoverCaseContext <- function(context) {
  Required <- c(
    "contextVersion", "contractVersion", "method", "reference", "theta",
    "domainCache", "baselineInputs", "baselineResolved"
  )
  if (!is.list(context) || any(!Required %in% names(context)) ||
      !identical(
        context[["contextVersion", exact = TRUE]],
        "cover-case-context-1"
      ) ||
      !identical(
        context[["contractVersion", exact = TRUE]],
        "cover-case-2"
      )) {
    stop(
      "context must be returned by prepareCoverCaseContext().",
      call. = FALSE
    )
  }
  context
}

evaluateCoverSample <- function(inputs, context) {
  Context <- .useCoverCaseContext(context)
  Inputs <- .normaliseCoverCaseInputs(inputs)
  Resolved <- if (identical(
    Inputs,
    Context[["baselineInputs", exact = TRUE]]
  )) {
    Context[["baselineResolved", exact = TRUE]]
  } else {
    .resolveCoverCaseProfile(
      inputs = Inputs,
      method = Context[["method", exact = TRUE]]
    )
  }
  Config <- Resolved[["config", exact = TRUE]]
  Linings <- .prepareCoverLinings(
    linings = Config[["additionalLinings", exact = TRUE]],
    domainCache = Context[["domainCache", exact = TRUE]]
  )
  Evaluation <- .evaluateValidatedCoverConfiguration(
    config = Config,
    additionalLinings = Linings,
    reference = Context[["reference", exact = TRUE]],
    theta = Context[["theta", exact = TRUE]]
  )
  .buildCoverCaseResult(resolved = Resolved, evaluation = Evaluation)
}

evaluateCoverCase <- function(
  inputs,
  projectRoot,
  methodID = "ar-sad40-cover-current"
) {
  Context <- prepareCoverCaseContext(
    inputs = inputs,
    projectRoot = projectRoot,
    methodID = methodID
  )
  Result <- evaluateCoverSample(inputs = inputs, context = Context)
  Result[["reinforcementStudy"]] <- .evaluateCoverReinforcementStudy(
    config = Context[["baselineResolved", exact = TRUE]][[
      "config",
      exact = TRUE
    ]],
    additionalLinings = Result[["additionalLinings", exact = TRUE]]
  )
  Result
}
