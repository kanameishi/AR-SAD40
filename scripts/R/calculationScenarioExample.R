# Fixed deterministic scenario shown as a sequence of calculation stages.

Arguments <- commandArgs(trailingOnly = FALSE)
FileArgument <- grep("^--file=", Arguments, value = TRUE)
if (length(FileArgument) != 1L) {
  stop(
    "Run with Rscript scripts/R/calculationScenarioExample.R.",
    call. = FALSE
  )
}

ScriptPath <- normalizePath(sub("^--file=", "", FileArgument))
projectRoot <- normalizePath(file.path(dirname(ScriptPath), "..", ".."))
source(
  file.path(projectRoot, "scripts", "setup", "calculationFunctions.R"),
  local = TRUE
)

Config <- validateCalculationConfig(readCalculationJson(
  file.path(projectRoot, "calculation.json")
))
SectionConfig <- Config[["section", exact = TRUE]]
StressConfig <- Config[["stressState", exact = TRUE]]
Numerics <- Config[["numerics", exact = TRUE]]
Model <- StressConfig[["k0Model", exact = TRUE]]
Cases <- Config[["loadCases", exact = TRUE]]
Radius <- Config[["geometry", exact = TRUE]][[
  "insideDiameterM",
  exact = TRUE
]] / 2

Reference <- utils::read.csv(
  file.path(projectRoot, SectionConfig[["propertyTable", exact = TRUE]]),
  check.names = FALSE,
  stringsAsFactors = FALSE
)

# 1. Angular mesh.
Theta <- buildThetaMesh(
  pointCount = Numerics[["baseThetaPointCount", exact = TRUE]],
  criticalAnglesDeg = Numerics[["criticalAnglesDeg", exact = TRUE]]
)

# 2. At-rest earth-pressure coefficient selected for this scenario.
COLS.K0 <- c("k0", "frictionAngleDeg", "poissonRatio", "ocr", "ocrMaximum")
LIST <- Model[intersect(COLS.K0, names(Model))]
K0State <- do.call(
  estimateK0,
  c(list(modelID = Model[["modelID", exact = TRUE]]), LIST)
)

# 3. Effective stress state.
StressState <- calculateEffectiveStressState(
  effectiveVerticalKPa = StressConfig[["effectiveVerticalKPa", exact = TRUE]],
  k0State = K0State,
  waterPressureDifferenceKPa =
    StressConfig[["waterPressureDifferenceKPa", exact = TRUE]],
  horizontalIncrementKPa = NA_real_,
  horizontalIncrementStatus =
    StressConfig[["horizontalIncrementMode", exact = TRUE]]
)

# 4. Corrugated-section properties and circumferential rigidities.
CorrugatedSection <- selectCorrugatedSection(
  reference = Reference,
  profileID = SectionConfig[["referenceProfileID", exact = TRUE]],
  referenceRowID = SectionConfig[["referenceRowID", exact = TRUE]]
)
SectionRigidity <- calculateRingSection(
  youngModulus = Config[["material", exact = TRUE]][[
    "circumferentialYoungModulusGPa",
    exact = TRUE
  ]] * 1e6,
  area = CorrugatedSection[["areaMm2PerMm", exact = TRUE]] * 1e-3,
  inertia = CorrugatedSection[["inertiaMm4PerMm", exact = TRUE]] * 1e-9,
  radius = Radius
)

# 5-7. Perimeter actions, section resultants, and extrema for each alpha.
Actions <- lapply(Cases[["alpha", exact = TRUE]], function(x) {
  calculatePerimeterActions(
    stressState = StressState,
    alpha = x,
    theta = Theta
  )
})
Responses <- lapply(Actions, function(AUX) {
  calculateSectionResultants(
    load = AUX[["load", exact = TRUE]],
    radius = Radius,
    theta = Theta,
    sectionRatio = SectionRigidity[["sectionRatio", exact = TRUE]],
    integrationSteps = Numerics[["integrationSteps", exact = TRUE]],
    balanceTolerance = Numerics[["balanceTolerance", exact = TRUE]]
  )
})
Extrema <- lapply(Responses, summarizeSectionResultants)
names(Actions) <- Cases[["caseID", exact = TRUE]]
names(Responses) <- Cases[["caseID", exact = TRUE]]
names(Extrema) <- Cases[["caseID", exact = TRUE]]

# 8. The compact facade returns the same stages for one realization.
Context <- list(
  k0ModelID = Model[["modelID", exact = TRUE]],
  horizontalIncrementKPa = NA_real_,
  horizontalIncrementStatus =
    StressConfig[["horizontalIncrementMode", exact = TRUE]],
  sectionReference = Reference,
  profileID = SectionConfig[["referenceProfileID", exact = TRUE]],
  sectionPropertyModelID =
    SectionConfig[["propertyModelID", exact = TRUE]],
  referenceRowID = SectionConfig[["referenceRowID", exact = TRUE]],
  youngModulusKPa = Config[["material", exact = TRUE]][[
    "circumferentialYoungModulusGPa",
    exact = TRUE
  ]] * 1e6,
  radiusM = Radius,
  theta = Theta,
  integrationSteps = Numerics[["integrationSteps", exact = TRUE]],
  balanceTolerance = Numerics[["balanceTolerance", exact = TRUE]]
)
Realization <- c(
  list(
    effectiveVerticalKPa =
      StressConfig[["effectiveVerticalKPa", exact = TRUE]],
    waterPressureDifferenceKPa =
      StressConfig[["waterPressureDifferenceKPa", exact = TRUE]],
    alpha = Cases[["alpha", exact = TRUE]][1L]
  ),
  LIST
)
Scenario <- calculateScenario(
  realization = Realization,
  context = Context
)
stopifnot(isTRUE(all.equal(
  Scenario[["sectionResultants", exact = TRUE]][["values", exact = TRUE]],
  Responses[[1L]][["values", exact = TRUE]],
  tolerance = Numerics[["closedFormTolerance", exact = TRUE]],
  check.attributes = TRUE
)))

StressTable <- data.frame(
  sigmaV = StressState[["effectiveVerticalKPa", exact = TRUE]],
  K0 = K0State[["k0Applied", exact = TRUE]],
  sigmaH = StressState[["effectiveHorizontalKPa", exact = TRUE]],
  deltaU = StressState[["waterPressureDifferenceKPa", exact = TRUE]]
)
SectionTable <- data.frame(
  area = CorrugatedSection[["areaMm2PerMm", exact = TRUE]],
  inertia = CorrugatedSection[["inertiaMm4PerMm", exact = TRUE]],
  EA = SectionRigidity[["extensionalRigidity", exact = TRUE]],
  EI = SectionRigidity[["flexuralRigidity", exact = TRUE]],
  sectionRatio = SectionRigidity[["sectionRatio", exact = TRUE]]
)
ExtremaTable <- do.call(rbind, lapply(seq_len(nrow(Cases)), function(i) {
  OUT <- Extrema[[i]]
  OUT$caseID <- Cases[["caseID", exact = TRUE]][i]
  OUT$alpha <- Cases[["alpha", exact = TRUE]][i]
  OUT[, c(
    "caseID", "alpha", "resultant", "statistic", "value", "signedValue",
    "thetaDeg"
  )]
}))

print(StressTable, row.names = FALSE)
print(SectionTable, row.names = FALSE)
print(ExtremaTable, row.names = FALSE)
cat("PASS: staged calculation and calculateScenario() agree.\n")
