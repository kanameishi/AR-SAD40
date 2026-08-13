Arguments <- commandArgs(trailingOnly = FALSE)
FileArgument <- grep("^--file=", Arguments, value = TRUE)
if (length(FileArgument) != 1L) {
  stop(
    "Run with Rscript scripts/R/testCalculationMonteCarloOutput.R.",
    call. = FALSE
  )
}

ScriptPath <- normalizePath(sub("^--file=", "", FileArgument))
ProjectRoot <- normalizePath(file.path(dirname(ScriptPath), "..", ".."))
LoaderEnvironment <- new.env(parent = globalenv())
LoaderEnvironment$projectRoot <- ProjectRoot
sys.source(
  file.path(ProjectRoot, "scripts", "setup", "calculationFunctions.R"),
  envir = LoaderEnvironment
)
source(file.path(ProjectRoot, "scripts", "R", "ringMonteCarlo.R"))
source(
  file.path(ProjectRoot, "scripts", "R", "calculationMonteCarloOutput.R")
)

Config <- validateCalculationConfig(
  readCalculationJson(file.path(
    ProjectRoot,
    "scripts",
    "R",
    "fixtures",
    "calculation.schema.json"
  ))
)
SectionReference <- utils::read.csv(
  file.path(ProjectRoot, Config$section$propertyTable),
  check.names = FALSE,
  stringsAsFactors = FALSE
)
Theta <- buildThetaMesh(
  pointCount = 72L,
  criticalAnglesDeg = Config$numerics$criticalAnglesDeg
)
Context <- list(
  k0ModelID = "jaky-nc",
  horizontalIncrementKPa = NA_real_,
  horizontalIncrementStatus = "unknown-not-modeled",
  sectionReference = SectionReference,
  profileID = Config$section$referenceProfileID,
  youngModulusKPa =
    Config$material$circumferentialYoungModulusGPa * 1e6,
  radiusM = Config$geometry$insideDiameterM / 2,
  theta = Theta,
  integrationSteps = Config$numerics$integrationSteps,
  balanceTolerance = Config$numerics$balanceTolerance
)
Draws <- data.frame(
  frictionAngleDeg = c(28, 32, 36),
  effectiveVerticalKPa = c(90, 100, 110),
  waterPressureDifferenceKPa = c(-5, 0, 5),
  baseThicknessMm = c(3.0, 3.1, 3.2),
  alpha = c(0, 0.5, 1),
  stringsAsFactors = FALSE
)

legacyResponse <- function(draw, theta) {
  K0State <- estimateK0(
    modelID = Context$k0ModelID,
    frictionAngleDeg = draw$frictionAngleDeg
  )
  StressState <- calculateEffectiveStressState(
    effectiveVerticalKPa = draw$effectiveVerticalKPa,
    k0State = K0State,
    waterPressureDifferenceKPa = draw$waterPressureDifferenceKPa,
    horizontalIncrementKPa = Context$horizontalIncrementKPa,
    horizontalIncrementStatus = Context$horizontalIncrementStatus
  )
  CorrugatedSection <- interpolateCorrugatedSection(
    reference = Context$sectionReference,
    profileID = Context$profileID,
    baseThicknessMm = draw$baseThicknessMm
  )
  SectionRigidity <- calculateRingSection(
    youngModulus = Context$youngModulusKPa,
    area = CorrugatedSection$areaMm2PerMm * 1e-3,
    inertia = CorrugatedSection$inertiaMm4PerMm * 1e-9,
    radius = Context$radiusM
  )
  PerimeterActions <- calculatePerimeterActions(
    stressState = StressState,
    alpha = draw$alpha,
    theta = theta
  )
  calculateSectionResultants(
    load = PerimeterActions$load,
    radius = Context$radiusM,
    theta = theta,
    sectionRatio = SectionRigidity$sectionRatio,
    integrationSteps = Context$integrationSteps,
    balanceTolerance = Context$balanceTolerance
  )
}

scenarioResponse <- function(draw, theta) {
  Context.draw <- Context
  Context.draw$theta <- theta
  Scenario <- calculateScenario(
    realization = as.list(draw[1L, , drop = FALSE]),
    context = Context.draw
  )
  Scenario$sectionResultants
}

MonteCarlo.legacy <- runRingMonteCarlo(
  draws = Draws,
  responseFunction = legacyResponse,
  theta = Theta,
  probabilities = c(0.05, 0.50, 0.95),
  modelLabel = "scenario-callback-control",
  keepSampleCurves = TRUE
)
MonteCarlo.scenario <- runRingMonteCarlo(
  draws = Draws,
  responseFunction = scenarioResponse,
  theta = Theta,
  probabilities = c(0.05, 0.50, 0.95),
  modelLabel = "scenario-callback-control",
  keepSampleCurves = TRUE
)

stopifnot(
  identical(MonteCarlo.scenario, MonteCarlo.legacy),
  identical(MonteCarlo.scenario$draws, Draws),
  identical(unique(MonteCarlo.scenario$extremaSamples$sampleID), 1:3)
)

Products <- prepareCalculationMonteCarloProducts(
  MonteCarlo.scenario,
  caseID = "mathematical-control",
  stageID = "single-stage"
)
stopifnot(
  all(Products$pointwiseQuantiles$statisticScope == "pointwise"),
  all(Products$extremaQuantiles$statisticScope == "spatialExtremum"),
  !any(c("theta", "thetaDeg") %in% names(Products$extremaQuantiles)),
  all(Products$extremaQuantiles$sampleCount == nrow(Draws)),
  all(Products$extremaQuantiles$quantileType == 7L),
  all(Products$extremaQuantiles$valueBasis[
    Products$extremaQuantiles$statistic == "absoluteMaximum"
  ] == "absolute")
)

TemporaryDirectory <- tempfile("calculation-monte-carlo-")
Paths <- writeCalculationMonteCarloProducts(Products, TemporaryDirectory)
stopifnot(all(file.exists(Paths)))
unlink(TemporaryDirectory, recursive = TRUE)

cat("PASS: calculation scenario Monte Carlo callback and output adapter.\n")
