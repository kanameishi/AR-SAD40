# Verifies the public calculation boundary used by report and Wolfram.

Arguments <- commandArgs(trailingOnly = FALSE)
FileArgument <- grep("^--file=", Arguments, value = TRUE)
if (length(FileArgument) != 1L) {
  stop(
    "Run with Rscript scripts/R/testCoverConfiguration.R.",
    call. = FALSE
  )
}
ScriptPath <- normalizePath(sub("^--file=", "", FileArgument))
projectRoot <- normalizePath(file.path(dirname(ScriptPath), "..", ".."))
source(
  file.path(projectRoot, "scripts", "setup", "calculationFunctions.R"),
  local = TRUE
)

Config <- readCalculationJson(file.path(
  projectRoot,
  "scripts",
  "config",
  "cover.method.mesh.2026-08-16.json"
))
stopifnot(
  identical(
    Config[["methodProfileID", exact = TRUE]],
    "ar-sad40-cover-mesh-2026-08-16"
  ),
  identical(Config[["methodProfileVersion", exact = TRUE]], "1.4.0")
)
Config[["methodProfileID"]] <- NULL
Config[["methodProfileVersion"]] <- NULL
Manifest <- readCalculationJson(file.path(projectRoot, "calculation.json"))
Config[["classicalComparison"]] <- Manifest[["inputs", exact = TRUE]][[
  "classicalComparison",
  exact = TRUE
]]
Result <- evaluateCoverConfiguration(
  config = Config,
  projectRoot = projectRoot
)
stopifnot(
  identical(Result$schemaVersion, "3.1.0"),
  identical(Result$scenarioID, Config$scenarioID),
  nrow(Result$stress) == 1L,
  nrow(Result$section) == 1L,
  nrow(Result$interaction) == nrow(Config$interfaceCases),
  nrow(Result$resultants) > 0L,
  nrow(Result$extrema) > 0L,
  nrow(Result$controls) > 0L
)
ConfiguredShotcrete <- Result[["additionalLinings", exact = TRUE]][[
  "shotcrete",
  exact = TRUE
]]
ConfiguredReinforced <- Result[["additionalLinings", exact = TRUE]][[
  "reinforcedConcrete",
  exact = TRUE
]]
stopifnot(
  ConfiguredShotcrete[["section", exact = TRUE]][[
    "thicknessM",
    exact = TRUE
  ]] == 0.10,
  ConfiguredShotcrete[["section", exact = TRUE]][[
    "centroidalRadiusM",
    exact = TRUE
  ]] == 1.265,
  abs(
    ConfiguredShotcrete[["section", exact = TRUE]][[
      "youngModulusKPa",
      exact = TRUE
    ]] - 4700 * sqrt(30) * 1000
  ) < 1e-8,
  ConfiguredShotcrete[["section", exact = TRUE]][[
    "stiffnessBasisID",
    exact = TRUE
  ]] == "aci-318-25-cracked-wall-0p35-ig",
  abs(ConfiguredShotcrete[["section", exact = TRUE]][[
    "inertiaReductionFactor",
    exact = TRUE
  ]] - 0.35) < 1e-12,
  all(
    ConfiguredShotcrete[["summary", exact = TRUE]][[
      "minimumReinforcementStatus",
      exact = TRUE
    ]] == "not-applicable"
  ),
  all(ConfiguredShotcrete[["summary", exact = TRUE]][[
    "shotcreteLocalStrengthUtilization",
    exact = TRUE
  ]] > 1),
  all(ConfiguredShotcrete[["summary", exact = TRUE]][[
    "shotcreteNormativeStatus",
    exact = TRUE
  ]] == "not-evaluated"),
  all(ConfiguredShotcrete[["summary", exact = TRUE]][[
    "shotcreteLocalStrengthStatus",
    exact = TRUE
  ]] == "not-satisfied"),
  nrow(ConfiguredShotcrete[["assessment", exact = TRUE]][[
    "aci",
    exact = TRUE
  ]][["summary", exact = TRUE]]) == 8L,
  setequal(
    ConfiguredShotcrete[["assessment", exact = TRUE]][[
      "aci",
      exact = TRUE
    ]][["summary", exact = TRUE]][["interfaceID", exact = TRUE]],
    c("full-slip", "no-slip")
  ),
  setequal(
    ConfiguredShotcrete[["assessment", exact = TRUE]][[
      "aci",
      exact = TRUE
    ]][["summary", exact = TRUE]][["strengthCaseID", exact = TRUE]],
    c(
      "ev130-eh135", "ev130-eh090",
      "ev090-eh135", "ev090-eh090"
    )
  )
)
ApplicabilityChecks <- ConfiguredShotcrete[["assessment", exact = TRUE]][[
  "aci",
  exact = TRUE
]][["checks", exact = TRUE]]
ApplicabilityChecks <- ApplicabilityChecks[
  ApplicabilityChecks[["checkID", exact = TRUE]] %in% c(
    "structural-classification", "plain-concrete-permission"
  ),
  ,
  drop = FALSE
]
stopifnot(
  nrow(ApplicabilityChecks) == 16L,
  all(ApplicabilityChecks[["calculationStatus", exact = TRUE]] ==
    "not-evaluated"),
  all(ApplicabilityChecks[["checkStatus", exact = TRUE]] == "blocked"),
  setequal(
    ApplicabilityChecks[["blockReason", exact = TRUE]],
    c(
      "structural-classification-not-characterized",
      "plain-concrete-permission-not-characterized"
    )
  )
)
stopifnot(
  ConfiguredReinforced[["section", exact = TRUE]][[
    "thicknessM",
    exact = TRUE
  ]] == 0.15,
  ConfiguredReinforced[["section", exact = TRUE]][[
    "centroidalRadiusM",
    exact = TRUE
  ]] == 1.24,
  ConfiguredReinforced[["assessment", exact = TRUE]][[
    "minimumReinforcement",
    exact = TRUE
  ]][["requiredAreaPerDirectionMm2", exact = TRUE]] == 270,
  ConfiguredReinforced[["assessment", exact = TRUE]][[
    "minimumReinforcement",
    exact = TRUE
  ]][["requiredAreaPerFaceMm2", exact = TRUE]] == 135,
  abs(ConfiguredReinforced[["assessment", exact = TRUE]][[
    "minimumReinforcement",
    exact = TRUE
  ]][["circumferentialInteriorAreaMm2", exact = TRUE]] -
    188.4955592153876) < 1e-12,
  all(ConfiguredReinforced[["summary", exact = TRUE]][[
    "minimumReinforcementStatus",
    exact = TRUE
  ]] == "satisfied"),
  all(is.finite(ConfiguredReinforced[["summary", exact = TRUE]][[
    "shotcreteLocalStrengthUtilization",
    exact = TRUE
  ]])),
  all(ConfiguredReinforced[["summary", exact = TRUE]][[
    "shotcreteLocalStrengthStatus",
    exact = TRUE
  ]] == ifelse(
    ConfiguredReinforced[["summary", exact = TRUE]][[
      "shotcreteLocalStrengthUtilization",
      exact = TRUE
    ]] <= 1,
    "satisfied",
    "not-satisfied"
  )),
  all(ConfiguredReinforced[["assessment", exact = TRUE]][[
    "mechanical",
    exact = TRUE
  ]][["convergenceStatus", exact = TRUE]] == "not-applicable"),
  all(ConfiguredReinforced[["assessment", exact = TRUE]][[
    "mechanical",
    exact = TRUE
  ]][["axialLimitStatus", exact = TRUE]] == "not-applicable"),
  all(is.na(ConfiguredReinforced[["assessment", exact = TRUE]][[
    "mechanical",
    exact = TRUE
  ]][["localStrengthUtilization", exact = TRUE]])),
  all(ConfiguredReinforced[["assessment", exact = TRUE]][[
    "aci",
    exact = TRUE
  ]][["controls", exact = TRUE]][["convergenceStatus", exact = TRUE]] ==
    "satisfied"),
  all(ConfiguredReinforced[["assessment", exact = TRUE]][[
    "aci",
    exact = TRUE
  ]][["controls", exact = TRUE]][["convergenceRelativeDifference", exact = TRUE]] <=
    ConfiguredReinforced[["assessment", exact = TRUE]][[
      "aci",
      exact = TRUE
    ]][["controls", exact = TRUE]][["convergenceTolerance", exact = TRUE]]),
  all(ConfiguredReinforced[["assessment", exact = TRUE]][[
    "aci",
    exact = TRUE
  ]][["controls", exact = TRUE]][["axialLimitStatus", exact = TRUE]] ==
    "applied"),
  setequal(
    ConfiguredReinforced[["summary", exact = TRUE]][[
      "interfaceID",
      exact = TRUE
    ]],
    c("full-slip", "no-slip")
  )
)

SteelVariationConfig <- Config
SteelVariationLining <- SteelVariationConfig[["lining", exact = TRUE]]
SteelVariationLining[["sectionID"]] <-
  "cspi-76x25-2.8-remaining-t1p98"
SteelVariationLining[["remainingBaseThicknessMm"]] <- 1.98
SteelVariationConfig[["lining"]] <- SteelVariationLining
SteelVariationResult <- evaluateCoverConfiguration(
  config = SteelVariationConfig,
  projectRoot = projectRoot
)
stopifnot(
  !identical(
    SteelVariationResult[["resultants", exact = TRUE]],
    Result[["resultants", exact = TRUE]]
  ),
  identical(
    SteelVariationResult[["additionalLinings", exact = TRUE]][[
      "shotcrete",
      exact = TRUE
    ]][["resultants", exact = TRUE]],
    ConfiguredShotcrete[["resultants", exact = TRUE]]
  ),
  identical(
    SteelVariationResult[["additionalLinings", exact = TRUE]][[
      "reinforcedConcrete",
      exact = TRUE
    ]][["resultants", exact = TRUE]],
    ConfiguredReinforced[["resultants", exact = TRUE]]
  )
)

ConcreteVariationConfig <- Config
ConcreteVariationLinings <- ConcreteVariationConfig[[
  "additionalLinings",
  exact = TRUE
]]
ConcreteVariationLining <- ConcreteVariationLinings[[
  "shotcrete",
  exact = TRUE
]]
ConcreteVariationLining[["sectionID"]] <- "shotcrete-t0.12-fc25-plain"
ConcreteVariationLining[["thicknessM"]] <- 0.12
ConcreteVariationLinings[["shotcrete"]] <- ConcreteVariationLining
ConcreteVariationConfig[["additionalLinings"]] <- ConcreteVariationLinings
ConcreteVariationResult <- evaluateCoverConfiguration(
  config = ConcreteVariationConfig,
  projectRoot = projectRoot
)
stopifnot(
  identical(
    ConcreteVariationResult[["resultants", exact = TRUE]],
    Result[["resultants", exact = TRUE]]
  ),
  !identical(
    ConcreteVariationResult[["additionalLinings", exact = TRUE]][[
      "shotcrete",
      exact = TRUE
    ]][["resultants", exact = TRUE]],
    ConfiguredShotcrete[["resultants", exact = TRUE]]
  ),
  identical(
    ConcreteVariationResult[["additionalLinings", exact = TRUE]][[
      "reinforcedConcrete",
      exact = TRUE
    ]][["resultants", exact = TRUE]],
    ConfiguredReinforced[["resultants", exact = TRUE]]
  )
)

ReinforcedVariationConfig <- Config
ReinforcedVariationLinings <- ReinforcedVariationConfig[[
  "additionalLinings",
  exact = TRUE
]]
ReinforcedVariationLining <- ReinforcedVariationLinings[[
  "reinforcedConcrete",
  exact = TRUE
]]
ReinforcedVariationLining[["sectionID"]] <-
  "shotcrete-t0.13-fc25-parametric-pm"
ReinforcedVariationLining[["thicknessM"]] <- 0.13
ReinforcedVariationMesh <- calculateSymmetricReinforcementMesh(
  thicknessM = 0.13,
  barDiameterMm = 6,
  barSpacingMm = 150,
  clearCoverRatio = 0.1,
  reinforcementGradeID = "Grade-60",
  reinforcementModulusMPa = 200000
)
ReinforcedVariationLining[["reinforcement"]] <- ReinforcedVariationMesh[[
  "circumferentialReinforcement",
  exact = TRUE
]]
ReinforcedVariationLining[["orthogonalReinforcement"]] <-
  ReinforcedVariationMesh[["orthogonalReinforcement", exact = TRUE]]
ReinforcedVariationLinings[["reinforcedConcrete"]] <-
  ReinforcedVariationLining
ReinforcedVariationConfig[["additionalLinings"]] <-
  ReinforcedVariationLinings
ReinforcedVariationResult <- evaluateCoverConfiguration(
  config = ReinforcedVariationConfig,
  projectRoot = projectRoot
)
stopifnot(
  identical(
    ReinforcedVariationResult[["resultants", exact = TRUE]],
    Result[["resultants", exact = TRUE]]
  ),
  identical(
    ReinforcedVariationResult[["additionalLinings", exact = TRUE]][[
      "shotcrete",
      exact = TRUE
    ]][["resultants", exact = TRUE]],
    ConfiguredShotcrete[["resultants", exact = TRUE]]
  ),
  !identical(
    ReinforcedVariationResult[["additionalLinings", exact = TRUE]][[
      "reinforcedConcrete",
      exact = TRUE
    ]][["resultants", exact = TRUE]],
    ConfiguredReinforced[["resultants", exact = TRUE]]
  )
)

ExpectedThrust <- Config[["aashto", exact = TRUE]][[
  "demandModifier",
  exact = TRUE
]] * Config[["aashto", exact = TRUE]][[
  "deadLoadFactor",
  exact = TRUE
]] * (Config[["aashto", exact = TRUE]][[
  "totalUnitWeightKnPerM3",
  exact = TRUE
]] * Config[["cover", exact = TRUE]][[
  "coverCrownM",
  exact = TRUE
]] + Config[["cover", exact = TRUE]][[
  "effectiveSurchargeKPa",
  exact = TRUE
]]) * Config[["aashto", exact = TRUE]][[
  "spanM",
  exact = TRUE
]] / 2
Demand <- Result$aashto$thrust$value[
  Result$aashto$thrust$quantityID == "modified-demand"
]
Seam <- Result$aashto$checks[
  Result$aashto$checks$checkID == "seam",
  ,
  drop = FALSE
]
stopifnot(
  abs(Demand - ExpectedThrust) < 1e-12,
  identical(Result$aashto$summary$wallStatus, "satisfied"),
  identical(Result$aashto$summary$calculationStatus, "not-satisfied"),
  identical(
    Result$aashto$summary$systemStatus,
    "not-evaluated-specification"
  ),
  identical(Result$aashto$summary$seamStatus, "not-satisfied"),
  identical(Result$aashto$summary$minimumCoverStatus, "satisfied"),
  abs(Seam$utilization - ExpectedThrust / (0.67 * 769)) < 1e-12,
  identical(Result$aashto$summary$governingCheckID, "seam"),
  abs(Result$aashto$calculation$minimumCoverM - 2.63 / 8) < 1e-12
)

ConfigCorrodedSeam <- Config
ConfigCorrodedSeam$aashto$seam$fastenerDiameterLossRatio <- 0.2
ResultCorrodedSeam <- evaluateCoverConfiguration(
  config = ConfigCorrodedSeam,
  projectRoot = projectRoot
)
SeamCorroded <- ResultCorrodedSeam$aashto$checks[
  ResultCorrodedSeam$aashto$checks$checkID == "seam",
  ,
  drop = FALSE
]
stopifnot(
  identical(ResultCorrodedSeam$resultants, Result$resultants),
  abs(
    SeamCorroded$limitValue - Seam$limitValue * (1 - 0.2)^2
  ) < 1e-12,
  abs(
    SeamCorroded$utilization - Seam$utilization / (1 - 0.2)^2
  ) < 1e-12,
  identical(ResultCorrodedSeam$aashto$summary$seamStatus, "not-satisfied"),
  identical(
    ResultCorrodedSeam$aashto$summary$calculationStatus,
    "not-satisfied"
  ),
  identical(
    ResultCorrodedSeam$aashto$summary$systemStatus,
    "not-evaluated-specification"
  )
)

ConfigWeight <- Config
ConfigWeight$aashto$totalUnitWeightKnPerM3 <- 21
ResultWeight <- evaluateCoverConfiguration(
  config = ConfigWeight,
  projectRoot = projectRoot
)
stopifnot(
  identical(ResultWeight$resultants, Result$resultants),
  !identical(ResultWeight$aashto$thrust, Result$aashto$thrust)
)

ConfigCover <- Config
ConfigCover$cover$coverCrownM <- 7
ResultCover <- evaluateCoverConfiguration(
  config = ConfigCover,
  projectRoot = projectRoot
)
ExpectedThrust7 <- ConfigCover[["aashto", exact = TRUE]][[
  "demandModifier",
  exact = TRUE
]] * ConfigCover[["aashto", exact = TRUE]][[
  "deadLoadFactor",
  exact = TRUE
]] * (ConfigCover[["aashto", exact = TRUE]][[
  "totalUnitWeightKnPerM3",
  exact = TRUE
]] * ConfigCover[["cover", exact = TRUE]][[
  "coverCrownM",
  exact = TRUE
]] + ConfigCover[["cover", exact = TRUE]][[
  "effectiveSurchargeKPa",
  exact = TRUE
]]) * ConfigCover[["aashto", exact = TRUE]][[
  "spanM",
  exact = TRUE
]] / 2
Demand7 <- ResultCover$aashto$thrust$value[
  ResultCover$aashto$thrust$quantityID == "modified-demand"
]
stopifnot(
  abs(Demand7 - ExpectedThrust7) < 1e-12,
  !identical(ResultCover$stress, Result$stress),
  !identical(ResultCover$resultants, Result$resultants)
)

InvalidConfig <- Config
InvalidConfig$lining$aisi <- list(unsupportedFixture = TRUE)
Error <- try(
  evaluateCoverConfiguration(
    config = InvalidConfig,
    projectRoot = projectRoot
  ),
  silent = TRUE
)
stopifnot(inherits(Error, "try-error"))

Shotcrete <- list(
  liningTypeID = "shotcrete",
  sectionID = "shotcrete-t0.15",
  concreteTypeID = "plain-concrete",
  centroidalRadiusM = 1.315,
  poisson = 0.20,
  thicknessM = 0.15,
  youngModulusKPa = 25000000,
  stiffnessBasisID = "aci-318-25-cracked-wall-0p35-ig",
  compressiveStrengthMPa = 25,
  stripWidthM = 1,
  reinforcement = data.frame(areaMm2 = numeric()),
  orthogonalReinforcement = data.frame(
    layerID = character(),
    areaMm2 = numeric(),
    coordinateMm = numeric(),
    yieldStrengthMPa = numeric(),
    modulusMPa = numeric(),
    stringsAsFactors = FALSE
  ),
  reinforcementGradeID = "Grade-60",
  orthogonalAreaMm2 = 0,
  convergenceTolerance = 0.01
)
LiningResult <- evaluateCoverConfiguration(
  config = Config,
  projectRoot = projectRoot,
  additionalLinings = list(shotcrete = Shotcrete)
)$additionalLinings$shotcrete
stopifnot(
  identical(LiningResult$summary$interfaceID, c("full-slip", "no-slip")),
  all(
    LiningResult$summary$shotcreteMechanicalStatus == "not-applicable"
  ),
  all(
    LiningResult$summary$shotcreteNormativeStatus ==
      "not-evaluated-code-basis"
  ),
  all(is.na(LiningResult$summary$shotcreteLocalStrengthUtilization)),
  nrow(LiningResult$resultants) == 6L * nrow(Result$theta),
  all(LiningResult$controls$pass),
  !identical(
    LiningResult$section$flexuralRigidityKnM2PerM,
    Result$section$flexuralRigidityKnM2PerM
  )
)

Reinforced <- Shotcrete
Reinforced$sectionID <- "shotcrete-t0.15-reinforced"
Reinforced$concreteTypeID <- "reinforced-concrete"
Reinforced$compressiveStrengthMPa <- 30
Reinforced$reinforcement <- data.frame(
  layerID = c("interior", "exterior"),
  areaMm2 = c(135, 135),
  coordinateMm = c(-35, 35),
  yieldStrengthMPa = c(414, 414),
  modulusMPa = c(200000, 200000),
  stringsAsFactors = FALSE
)
Reinforced$orthogonalReinforcement <- data.frame(
  layerID = c("longitudinal-interior", "longitudinal-exterior"),
  areaMm2 = c(135, 135),
  coordinateMm = c(-35, 35),
  yieldStrengthMPa = c(414, 414),
  modulusMPa = c(200000, 200000),
  stringsAsFactors = FALSE
)
Reinforced$orthogonalAreaMm2 <- 270
CompactConfig <- Config
CompactConfig$numerics$thetaPointCount <- 8L
ReinforcedResult <- evaluateCoverConfiguration(
  config = CompactConfig,
  projectRoot = projectRoot,
  additionalLinings = list(shotcrete = Reinforced)
)$additionalLinings$shotcrete
stopifnot(
  !("sectionDomains" %in% names(Reinforced)),
  nrow(ReinforcedResult$assessment$mechanical) == 2L,
  all(is.na(
    ReinforcedResult$assessment$mechanical$mechanicalUtilization
  )),
  all(
    ReinforcedResult$assessment$mechanical$mechanicalStatus ==
      "not-applicable"
  ),
  all(
    ReinforcedResult$assessment$mechanical$normativeStatus ==
      "not-applicable"
  )
)

ReinforcedRecords <- Reinforced
ReinforcedRecords$reinforcement <- lapply(
  seq_len(nrow(Reinforced$reinforcement)),
  function(i) as.list(Reinforced$reinforcement[i, , drop = FALSE])
)
ReinforcedRecords$orthogonalReinforcement <- lapply(
  seq_len(nrow(Reinforced$orthogonalReinforcement)),
  function(i) {
    as.list(Reinforced$orthogonalReinforcement[i, , drop = FALSE])
  }
)
ReinforcedRecordsResult <- evaluateCoverConfiguration(
  config = CompactConfig,
  projectRoot = projectRoot,
  additionalLinings = list(shotcrete = ReinforcedRecords)
)$additionalLinings$shotcrete
stopifnot(identical(ReinforcedRecordsResult, ReinforcedResult))

PlainRecords <- Shotcrete
PlainRecords$reinforcement <- list()
PlainRecordsResult <- evaluateCoverConfiguration(
  config = Config,
  projectRoot = projectRoot,
  additionalLinings = list(shotcrete = PlainRecords)
)$additionalLinings$shotcrete
stopifnot(
  identical(PlainRecordsResult$resultants, LiningResult$resultants),
  identical(PlainRecordsResult$summary, LiningResult$summary)
)

InvalidRecords <- ReinforcedRecords
InvalidRecords$reinforcement[[1L]]$modulusMPa <- NULL
Error <- try(
  evaluateCoverConfiguration(
    config = CompactConfig,
    projectRoot = projectRoot,
    additionalLinings = list(shotcrete = InvalidRecords)
  ),
  silent = TRUE
)
stopifnot(inherits(Error, "try-error"))

cat("PASS: public cover configuration schema 3.1.0.\n")
