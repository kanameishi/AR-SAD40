# Verifies the current ACI concrete assessment.

Arguments <- commandArgs(trailingOnly = FALSE)
FileArgument <- grep("^--file=", Arguments, value = TRUE)
if (length(FileArgument) != 1L) {
  stop("Run with Rscript scripts/R/testConcreteAciShell.R.", call. = FALSE)
}
ScriptPath <- normalizePath(sub("^--file=", "", FileArgument))
projectRoot <- normalizePath(file.path(dirname(ScriptPath), "..", ".."))
source(
  file.path(projectRoot, "scripts", "setup", "calculationFunctions.R"),
  local = TRUE
)

runConcreteAciShellTests <- function() {
  stopifnot(abs(
    calculateAci31825NormalWeightConcreteModulus(25) - 23500000
  ) < 1e-12)
  Actions <- mapAciShellActions(
    normalForceKnPerM = c(-100, -20),
    bendingMomentKnMPerM = c(20, -50),
    shearForceKnPerM = c(-30, 5),
    stripWidthM = 1,
    thetaRad = c(0, pi / 2),
    thetaDeg = c(0, 90),
    combinationID = "factored-test",
    stageID = "completed-fill",
    forceEffectStatus = "factored-strength",
    interfaceID = "full-slip"
  )
  stopifnot(
    identical(Actions$axialForceKn, c(100, 20)),
    identical(Actions$bendingMomentKnM, c(20, -50)),
    identical(Actions$shearDemandKn, c(30, 5)),
    identical(Actions$shearDirectionSign, c(-1, 1)),
    Actions$axialForceKn[1L] == 100,
    Actions$bendingMomentKnM[2L] == -50,
    Actions$shearDemandKn[1L] == 30
  )

  Current <- evaluateAciShotcrete(
    normalForceKnPerM = -20,
    bendingMomentKnMPerM = 1,
    shearForceKnPerM = 8,
    stripWidthM = 1,
    thetaRad = 0,
    thetaDeg = 0,
    combinationID = "aci-strength-control",
    stageID = "completed-fill",
    forceEffectStatus = "lrfd-factored",
    interfaceID = "full-slip",
    thicknessMm = 100,
    compressiveStrengthMPa = 25,
    concreteTypeID = "plain-concrete",
    circumferentialAreaMm2 = 0,
    longitudinalAreaMm2 = 0,
    reinforcementGradeID = "Grade-60",
    standardSetID = "aci-318-25-plain-concrete",
    shellClassificationStatus = "not-applicable",
    longitudinalBoundaryConditionID = "not-characterized",
    castAgainstSoil = FALSE,
    lambda = 1,
    compressionLengthMm = 1600,
    structuralClassificationID = "underground-member-arch-strip",
    plainConcretePermissionBasisID = "continuously-supported",
    seismicDesignCategoryID = "A",
    jointingStatus = "requirements-satisfied",
    openingStatus = "none"
  )
  CurrentChecks <- setNames(
    Current$checks$utilization,
    Current$checks$checkID
  )
  stopifnot(
    abs(Current$section$grossAreaMm2 - 100000) < 1e-12,
    abs(Current$section$sectionModulusMm3 - 1000 * 100^2 / 6) < 1e-9,
    abs(Current$capacities$designMomentKnM - 2.1) < 1e-12,
    abs(Current$capacities$designAxialKn - 675) < 1e-12,
    abs(Current$capacities$designShearKn - 33) < 1e-12,
    abs(CurrentChecks[["tension-face"]] - 0.317460317460317) < 1e-12,
    abs(CurrentChecks[["compression-face"]] - 0.0766884531590414) < 1e-12,
    abs(CurrentChecks[["one-way-shear"]] - 0.242424242424242) < 1e-12,
    Current$summary$localStrengthStatus == "satisfied",
    Current$summary$normativeStatus == "not-evaluated"
  )

  Uncharacterized <- evaluateAci31825PlainConcreteStrip(
    actions = Current$actions,
    specifiedThicknessMm = 100,
    stripWidthMm = 1000,
    compressiveStrengthMPa = 25,
    lambda = 1,
    castAgainstSoil = FALSE,
    compressionLengthMm = 1600,
    structuralClassificationID = "not-characterized",
    plainConcretePermissionBasisID = "not-characterized",
    seismicDesignCategoryID = "A",
    jointingStatus = "requirements-satisfied",
    openingStatus = "none"
  )
  Classification <- Uncharacterized$gateChecks[
    Uncharacterized$gateChecks$checkID == "structural-classification",
    ,
    drop = FALSE
  ]
  Permission <- Uncharacterized$gateChecks[
    Uncharacterized$gateChecks$checkID == "plain-concrete-permission",
    ,
    drop = FALSE
  ]
  stopifnot(
    Uncharacterized$summary$localStrengthStatus == "satisfied",
    Uncharacterized$summary$normativeStatus == "not-evaluated",
    Classification$calculationStatus == "not-evaluated",
    Classification$checkStatus == "blocked",
    Classification$blockReason ==
      "structural-classification-not-characterized",
    Permission$calculationStatus == "not-evaluated",
    Permission$checkStatus == "blocked",
    Permission$blockReason ==
      "plain-concrete-permission-not-characterized"
  )

  FlexureLimit <- evaluateAciShotcrete(
    normalForceKnPerM = 0,
    bendingMomentKnMPerM = 2.1,
    shearForceKnPerM = 0,
    stripWidthM = 1,
    thetaRad = 0,
    thetaDeg = 0,
    combinationID = "aci-flexure-limit",
    stageID = "completed-fill",
    forceEffectStatus = "lrfd-factored",
    interfaceID = "no-slip",
    thicknessMm = 100,
    compressiveStrengthMPa = 25,
    concreteTypeID = "plain-concrete",
    circumferentialAreaMm2 = 0,
    longitudinalAreaMm2 = 0,
    reinforcementGradeID = "Grade-60",
    standardSetID = "aci-318-25-plain-concrete",
    shellClassificationStatus = "not-applicable",
    longitudinalBoundaryConditionID = "not-characterized",
    castAgainstSoil = FALSE,
    compressionLengthMm = 1600,
    structuralClassificationID = "underground-member-arch-strip",
    plainConcretePermissionBasisID = "continuously-supported",
    seismicDesignCategoryID = "A",
    jointingStatus = "requirements-satisfied",
    openingStatus = "none"
  )
  stopifnot(abs(
    FlexureLimit$checks$utilization[
      FlexureLimit$checks$checkID == "tension-face"
    ] - 1
  ) < 1e-12)

  AgainstSoilMessage <- tryCatch(
    evaluateAci31825PlainConcreteStrip(
      actions = Current$actions,
      specifiedThicknessMm = 100,
      stripWidthMm = 1000,
      compressiveStrengthMPa = 25,
      lambda = 1,
      castAgainstSoil = TRUE,
      compressionLengthMm = 800,
      structuralClassificationID = "underground-member-arch-strip",
      plainConcretePermissionBasisID = "continuously-supported",
      seismicDesignCategoryID = "A",
      jointingStatus = "requirements-satisfied",
      openingStatus = "none"
    ),
    error = function(e) conditionMessage(e)
  )
  stopifnot(grepl(
    "castAgainstSoil = TRUE is outside this evaluator's scope",
    AgainstSoilMessage,
    fixed = TRUE
  ))

  Service <- Current$actions
  Service$forceEffectStatus <- "unfactored-reference-state"
  ServiceAssessment <- evaluateAci31825PlainConcreteStrip(
    actions = Service,
    specifiedThicknessMm = 100,
    stripWidthMm = 1000,
    compressiveStrengthMPa = 25,
    lambda = 1,
    castAgainstSoil = FALSE,
    compressionLengthMm = 1600,
    structuralClassificationID = "underground-member-arch-strip",
    plainConcretePermissionBasisID = "continuously-supported",
    seismicDesignCategoryID = "A",
    jointingStatus = "requirements-satisfied",
    openingStatus = "none"
  )
  stopifnot(
    all(ServiceAssessment$checks$checkStatus == "blocked"),
    ServiceAssessment$summary$localStrengthStatus == "not-evaluated"
  )

  OpeningFailure <- evaluateAci31825PlainConcreteStrip(
    actions = Current$actions,
    specifiedThicknessMm = 100,
    stripWidthMm = 1000,
    compressiveStrengthMPa = 25,
    lambda = 1,
    castAgainstSoil = FALSE,
    compressionLengthMm = 1600,
    structuralClassificationID = "underground-member-arch-strip",
    plainConcretePermissionBasisID = "continuously-supported",
    seismicDesignCategoryID = "A",
    jointingStatus = "requirements-satisfied",
    openingStatus = "requirements-not-satisfied"
  )
  JointingFailure <- evaluateAci31825PlainConcreteStrip(
    actions = Current$actions,
    specifiedThicknessMm = 100,
    stripWidthMm = 1000,
    compressiveStrengthMPa = 25,
    lambda = 1,
    castAgainstSoil = FALSE,
    compressionLengthMm = 1600,
    structuralClassificationID = "underground-member-arch-strip",
    plainConcretePermissionBasisID = "continuously-supported",
    seismicDesignCategoryID = "A",
    jointingStatus = "requirements-not-satisfied",
    openingStatus = "none"
  )
  stopifnot(
    OpeningFailure$gateChecks$checkStatus[
      OpeningFailure$gateChecks$checkID == "openings"
    ] == "not-satisfied",
    OpeningFailure$summary$normativeStatus == "not-satisfied",
    JointingFailure$gateChecks$checkStatus[
      JointingFailure$gateChecks$checkID == "jointing"
    ] == "not-satisfied",
    JointingFailure$summary$normativeStatus == "not-satisfied",
    identical(
      formals(evaluateAciShotcrete)[["castAgainstSoil", exact = TRUE]],
      alist(x = )[["x", exact = TRUE]]
    ),
    identical(
      formals(evaluateAciShotcrete)[[
        "structuralClassificationID",
        exact = TRUE
      ]],
      "not-characterized"
    ),
    identical(
      formals(evaluateAciShotcrete)[[
        "plainConcretePermissionBasisID",
        exact = TRUE
      ]],
      "not-characterized"
    )
  )

  Unsupported.error <- tryCatch(
    evaluateAciShotcrete(
      normalForceKnPerM = -1,
      bendingMomentKnMPerM = 0,
      shearForceKnPerM = 0,
      stripWidthM = 1,
      thetaRad = 0,
      thetaDeg = 0,
      combinationID = "test",
      stageID = "test",
      forceEffectStatus = "factored-strength",
      interfaceID = "full-slip",
      thicknessMm = 100,
      compressiveStrengthMPa = 25,
      concreteTypeID = "plain-concrete",
      circumferentialAreaMm2 = 0,
      longitudinalAreaMm2 = 0,
      reinforcementGradeID = "Grade-60",
      standardSetID = "aci-318.2-25+318-25",
      shellClassificationStatus = "applicable",
      longitudinalBoundaryConditionID = "not-characterized",
      castAgainstSoil = FALSE
    ),
    error = function(e) conditionMessage(e)
  )
  stopifnot(grepl("standardSetID must be", Unsupported.error, fixed = TRUE))
  invisible(TRUE)
}

runConcreteAciShellTests()
cat("PASS: versioned ACI concrete assessment.\n")
