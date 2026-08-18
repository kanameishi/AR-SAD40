# Verifies the ACI 318-25 reinforced-strip calculation and its ACI 318.2-14
# minimum-shell-reinforcement gate.

Arguments <- commandArgs(trailingOnly = FALSE)
FileArgument <- grep("^--file=", Arguments, value = TRUE)
if (length(FileArgument) != 1L) {
  stop(
    "Run with Rscript scripts/R/testConcreteAci31825.R.",
    call. = FALSE
  )
}
ScriptPath <- normalizePath(sub("^--file=", "", FileArgument))
projectRoot <- normalizePath(file.path(dirname(ScriptPath), "..", ".."))
source(
  file.path(projectRoot, "scripts", "setup", "calculationFunctions.R"),
  local = TRUE
)

expectError <- function(expression) {
  Error <- try(force(expression), silent = TRUE)
  stopifnot(inherits(Error, "try-error"))
}

YieldStrain <- 414 / 200000
stopifnot(
  calculateAci31825Beta1(28) == 0.85,
  calculateAci31825Beta1(42) == 0.75,
  calculateAci31825Beta1(55) == 0.65,
  calculateAci31825StrengthReductionFactor(
    YieldStrain,
    YieldStrain
  ) == 0.65,
  calculateAci31825StrengthReductionFactor(
    YieldStrain + 0.0015,
    YieldStrain
  ) == 0.775,
  calculateAci31825StrengthReductionFactor(
    YieldStrain + 0.003,
    YieldStrain
  ) == 0.90
)

Circumferential <- data.frame(
  layerID = c("circumferential-interior", "circumferential-exterior"),
  areaMm2 = c(90, 90),
  coordinateMm = c(-35, 35),
  yieldStrengthMPa = c(414, 414),
  modulusMPa = c(200000, 200000),
  stringsAsFactors = FALSE
)
Orthogonal <- data.frame(
  layerID = c("orthogonal-interior", "orthogonal-exterior"),
  areaMm2 = c(90, 90),
  coordinateMm = c(-35, 35),
  yieldStrengthMPa = c(414, 414),
  modulusMPa = c(200000, 200000),
  stringsAsFactors = FALSE
)
Minimum <- checkAci318214SymmetricShellReinforcement(
  thicknessMm = 100,
  stripWidthMm = 1000,
  circumferentialReinforcement = Circumferential,
  orthogonalReinforcement = Orthogonal
)
stopifnot(
  Minimum$requiredAreaPerDirectionMm2 == 180,
  Minimum$requiredAreaPerFaceMm2 == 90,
  Minimum$circumferentialInteriorAreaMm2 == 90,
  Minimum$circumferentialExteriorAreaMm2 == 90,
  Minimum$orthogonalInteriorAreaMm2 == 90,
  Minimum$orthogonalExteriorAreaMm2 == 90,
  Minimum$minimumReinforcementStatus == "satisfied"
)

Mesh <- calculateSymmetricReinforcementMesh(
  thicknessM = 0.12,
  barDiameterMm = 6,
  barSpacingMm = 150,
  clearCoverRatio = 0.15,
  reinforcementGradeID = "Grade-60",
  reinforcementModulusMPa = 200000
)
MeshMinimum <- checkAci318214SymmetricShellReinforcement(
  thicknessMm = 120,
  stripWidthMm = 1000,
  circumferentialReinforcement = do.call(
    rbind,
    lapply(Mesh$circumferentialReinforcement, as.data.frame)
  ),
  orthogonalReinforcement = do.call(
    rbind,
    lapply(Mesh$orthogonalReinforcement, as.data.frame)
  )
)
stopifnot(
  MeshMinimum$requiredAreaPerDirectionMm2 == 216,
  abs(MeshMinimum$circumferentialInteriorAreaMm2 -
    188.4955592153876) < 1e-12,
  MeshMinimum$minimumReinforcementStatus == "satisfied"
)

Insufficient <- Circumferential
Insufficient$areaMm2[1L] <- 89
MinimumInsufficient <- checkAci318214SymmetricShellReinforcement(
  thicknessMm = 100,
  stripWidthMm = 1000,
  circumferentialReinforcement = Insufficient,
  orthogonalReinforcement = Orthogonal
)
stopifnot(
  MinimumInsufficient$circumferentialTotalStatus == "not-satisfied",
  MinimumInsufficient$circumferentialFaceEqualityStatus == "not-satisfied",
  MinimumInsufficient$minimumReinforcementStatus == "not-satisfied"
)

WrongGrade <- Circumferential
WrongGrade$yieldStrengthMPa <- 420
expectError(checkAci318214SymmetricShellReinforcement(
  thicknessMm = 100,
  stripWidthMm = 1000,
  circumferentialReinforcement = WrongGrade,
  orthogonalReinforcement = Orthogonal
))

Domains <- buildAci31825ReinforcedSectionDomains(
  thicknessMm = 100,
  stripWidthMm = 1000,
  compressiveStrengthMPa = 25,
  reinforcement = Circumferential
)
UniformTension <- Domains$refined[
  Domains$refined$stateID == "uniform-tension",
  ,
  drop = FALSE
][1L, , drop = FALSE]
UniformCompression <- Domains$refined[
  Domains$refined$stateID == "uniform-compression",
  ,
  drop = FALSE
]
ExpectedNominalTension <- -sum(
  Circumferential$areaMm2 * Circumferential$yieldStrengthMPa
)
ExpectedPureAxialCompression <-
  0.85 * 25 * (100 * 1000 - sum(Circumferential$areaMm2)) +
  sum(Circumferential$areaMm2 * Circumferential$yieldStrengthMPa)
ExpectedNominalCompression <- 0.80 * ExpectedPureAxialCompression
stopifnot(
  identical(
    unique(Domains$base$domainPrimitiveID),
    unique(Domains$refined$domainPrimitiveID)
  ),
  all(vapply(c("interior", "exterior"), function(faceID) {
    Rows <- Domains$refined[
      Domains$refined$stateID == "compatibility" &
        Domains$refined$compressionFaceID == faceID,
      ,
      drop = FALSE
    ]
    min(abs(Rows$netTensileStrain - YieldStrain)) <= 1e-10
  }, logical(1))),
  abs(UniformTension$nominalAxialStrengthN -
    ExpectedNominalTension) < 1e-9,
  abs(UniformTension$nominalBendingStrengthNmm) < 1e-9,
  UniformTension$strengthReductionFactor == 0.90,
  nrow(UniformCompression) == 1L,
  abs(UniformCompression$nominalAxialStrengthN -
    ExpectedNominalCompression) < 1e-9,
  abs(UniformCompression$pureAxialNominalStrengthN -
    ExpectedPureAxialCompression) < 1e-9,
  abs(UniformCompression$maximumDesignAxialStrengthN -
    0.65 * ExpectedNominalCompression) < 1e-9,
  abs(UniformCompression$nominalBendingStrengthNmm) < 1e-9,
  UniformCompression$strengthReductionFactor == 0.65
)

Demand <- evaluateAci31825ReinforcedSectionDemand(
  normalForceKnPerM = c(-20, -20),
  bendingMomentKnMPerM = c(15, -15),
  stripWidthM = 1,
  sectionDomains = Domains,
  forceEffectStatus = "lrfd-factored",
  convergenceTolerance = 0.01
)
stopifnot(
  all(Demand$convergenceStatus == "satisfied"),
  abs(diff(Demand$radialUtilization)) <= 1e-10,
  all(Demand$localStrengthStatus == "not-satisfied")
)

Actions <- mapAciShellActions(
  normalForceKnPerM = c(-20, -20),
  bendingMomentKnMPerM = c(15, -15),
  shearForceKnPerM = c(8, -8),
  stripWidthM = 1,
  thetaRad = c(0, pi),
  thetaDeg = c(0, 180),
  combinationID = rep("aci-test", 2L),
  stageID = rep("completed-fill", 2L),
  forceEffectStatus = "lrfd-factored",
  interfaceID = rep("full-slip", 2L)
)
Evaluation <- evaluateAci31825ReinforcedShellStrip(
  actions = Actions,
  thicknessMm = 100,
  stripWidthMm = 1000,
  compressiveStrengthMPa = 25,
  circumferentialReinforcement = Circumferential,
  orthogonalReinforcement = Orthogonal,
  convergenceTolerance = 0.01,
  shellClassificationStatus = "applicable",
  longitudinalBoundaryConditionID = "not-characterized",
  seismicDesignCategoryID = "not-characterized",
  jointingStatus = "not-characterized",
  openingStatus = "not-characterized"
)
stopifnot(
  Evaluation$summary$concreteTypeID == "reinforced-concrete",
  Evaluation$summary$localStrengthStatus == "not-satisfied",
  Evaluation$summary$normativeStatus == "not-satisfied",
  Evaluation$controls$convergenceStatus == "satisfied",
  Evaluation$controls$convergenceRelativeDifference <=
    Evaluation$controls$convergenceTolerance,
  Evaluation$controls$strengthReductionStatus == "applied",
  Evaluation$controls$axialLimitStatus == "applied",
  Evaluation$minimumReinforcement$minimumReinforcementStatus == "satisfied",
  identical(
    Evaluation$interactionDiagram$domain$domainPrimitiveID,
    Domains$refined$domainPrimitiveID
  ),
  all(Evaluation$interactionDiagram$domain$axialStrengthKnPerM ==
    Domains$refined$axialStrengthN / 1000),
  all(Evaluation$interactionDiagram$domain$bendingStrengthKnMPerM ==
    Domains$refined$bendingStrengthNmm / 1e6),
  all(Evaluation$interactionDiagram$demands$axialDemandKnPerM ==
    -Actions$normalForceKnPerM),
  all(Evaluation$interactionDiagram$demands$bendingDemandKnMPerM ==
    Actions$bendingMomentKnMPerM),
  Evaluation$gateChecks$checkStatus[
    Evaluation$gateChecks$checkID == "current-shell-code"
  ] == "blocked",
  !any(Evaluation$checks$checkID == "one-way-shear")
)

Actions$forceEffectStatus <- "unfactored"
expectError(evaluateAci31825ReinforcedShellStrip(
  actions = Actions,
  thicknessMm = 100,
  stripWidthMm = 1000,
  compressiveStrengthMPa = 25,
  circumferentialReinforcement = Circumferential,
  orthogonalReinforcement = Orthogonal,
  convergenceTolerance = 0.01,
  shellClassificationStatus = "applicable",
  longitudinalBoundaryConditionID = "not-characterized",
  seismicDesignCategoryID = "not-characterized",
  jointingStatus = "not-characterized",
  openingStatus = "not-characterized"
))

cat("PASS: ACI 318-25 reinforced shell-strip calculation.\n")
