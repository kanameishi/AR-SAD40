# Regression checks for cover calculation schemas 3.0.0 and 3.1.0.
# Every numerical value in this file is a synthetic test fixture, not project
# data and not an adopted design scenario.

Arguments <- commandArgs(trailingOnly = FALSE)
FileArgument <- grep("^--file=", Arguments, value = TRUE)
if (length(FileArgument) != 1L) {
  stop("Run with Rscript scripts/R/testCoverCalculationData.R.", call. = FALSE)
}
ScriptPath <- normalizePath(sub("^--file=", "", FileArgument))
projectRoot <- normalizePath(file.path(dirname(ScriptPath), "..", ".."))
source(
  file.path(projectRoot, "scripts", "setup", "calculationFunctions.R"),
  local = TRUE
)

runCoverCalculationDataTests <- function() {
  TestDirectory <- tempfile("cover-calculation-data-test-")
  dir.create(TestDirectory)
  on.exit(unlink(TestDirectory, recursive = TRUE, force = TRUE), add = TRUE)

  Config <- list(
    schemaVersion = "3.0.0",
    analysisModelID = "prescribed-biaxial-direct-integration",
    scenarioID = "synthetic-cover-regression",
    cover = list(
      coverCrownM = 2,
      crownToAxisM = 1.315,
      effectiveUnitWeightKnPerM3 = 20,
      effectiveSurchargeKPa = 0,
      referencePositionID = "axis"
    ),
    ground = list(
      modulusKPa = 30000,
      poisson = 0.30,
      k0 = list(modelID = "adopted-constant", k0 = 0.50)
    ),
    action = list(
      combinationID = "synthetic-unfactored-combination",
      stageID = "synthetic-completed-fill",
      forceEffectStatus = "unfactored-reference-state",
      loadCombinationBasisID = "synthetic-unfactored-basis",
      waterPressureDifferenceKPa = 0
    ),
    interfaceCases = list(
      list(
        caseID = "alpha-1",
        interfaceID = "full-traction",
        tangentialMultiplier = 1,
        comparisonInterfaceID = "full-slip"
      ),
      list(
        caseID = "alpha-0",
        interfaceID = "normal-only",
        tangentialMultiplier = 0,
        comparisonInterfaceID = "no-slip"
      )
    ),
    sectionReference = list(
      propertyTable = "data/reference/cspi.corrugation.section.properties.csv",
      profileID = "cspi-76x25-csp-sheet",
      referenceRowID = "cspi-76x25-2.8"
    ),
    lining = list(
      liningTypeID = "corrugated-steel",
      sectionID = "synthetic-cspi-76x25-2.8",
      centroidalRadiusM = 1.315,
      poisson = 0.30,
      remainingBaseThicknessMm = 2.64,
      youngModulusKPa = 200e6,
      yieldStrengthMPa = 250
    ),
    numerics = list(
      thetaPointCount = 72L,
      criticalAnglesDeg = c(0, 45, 90, 135, 180, 225, 270, 315),
      integrationSteps = 4096L,
      balanceTolerance = 1e-9,
      closedFormTolerance = 1e-7,
      controlTolerance = 1e-10
    ),
    graphics = list(
      graphicAmplification = 1,
      radialFraction = 0.25,
      ordinateCount = 24L
    )
  )

  buildVariant <- function(name, config) {
    ConfigPath <- file.path(TestDirectory, paste0(name, ".json"))
    OutputDirectory <- file.path(TestDirectory, name)
    jsonlite::write_json(
      config,
      ConfigPath,
      auto_unbox = TRUE,
      pretty = TRUE,
      digits = NA
    )
    buildCalculationData(
      configPath = ConfigPath,
      outputDirectory = OutputDirectory,
      projectRoot = projectRoot
    )
  }
  readProduct <- function(variant, fileName) {
    utils::read.csv(
      file.path(variant$outputDirectory, fileName),
      check.names = FALSE,
      na.strings = ""
    )
  }

  Baseline <- buildVariant("cover-h2", Config)
  Files <- c(
    "calculation.config.json", "calculation.inputs.csv", "stress.state.csv",
    "section.properties.csv", "interaction.parameters.csv",
    "section.resultants.csv", "section.extrema.csv", "aisi.checks.csv",
    "aisi.capacity.usage.csv", "aisi.summary.csv", "display.scales.csv",
    "numerical.controls.csv"
  )
  stopifnot(all(file.exists(file.path(Baseline$outputDirectory, Files))))

  Stress <- readProduct(Baseline, "stress.state.csv")
  Section <- readProduct(Baseline, "section.properties.csv")
  Interaction <- readProduct(Baseline, "interaction.parameters.csv")
  Resultants <- readProduct(Baseline, "section.resultants.csv")
  Extrema <- readProduct(Baseline, "section.extrema.csv")
  Checks <- readProduct(Baseline, "aisi.checks.csv")
  Usage <- readProduct(Baseline, "aisi.capacity.usage.csv")
  AisiSummary <- readProduct(Baseline, "aisi.summary.csv")
  Controls <- readProduct(Baseline, "numerical.controls.csv")

  stopifnot(
    nrow(Stress) == 1L,
    nrow(Section) == 1L,
    nrow(Interaction) == 2L,
    nrow(Resultants) == 2L * 3L * 72L,
    nrow(Extrema) == 2L * 3L * 3L,
    nrow(Checks) == 0L,
    nrow(Usage) == 0L,
    nrow(AisiSummary) == 2L,
    nrow(Controls) == 2L * 6L,
    all(Controls$pass),
    all(is.finite(Interaction$sectionRatio)),
    all(is.finite(Interaction$tangentialMultiplier)),
    identical(
      sort(unique(Resultants$interfaceID)),
      c("full-traction", "normal-only")
    ),
    all(is.na(AisiSummary$aisiWallMemberUtilization)),
    all(AisiSummary$aisiWallMemberStatus == "not-evaluated-capacities"),
    all(AisiSummary$aisiSystemStatus == "not-evaluated-capacities"),
    Section$profileID == "cspi-76x25-csp-sheet",
    Section$referenceRowID == "cspi-76x25-2.8",
    abs(Section$areaMm2PerMm - 3.281) < 1e-12,
    abs(Section$inertiaMm4PerMm - 249.73) < 1e-12,
    abs(Section$sectionModulusMm3PerMm - 17.81) < 1e-12
  )

  AisiFixturePath <- file.path(
    projectRoot,
    "scripts", "R", "fixtures", "calculation.schema3.aisi.synthetic.json"
  )
  AisiVariant <- buildCalculationData(
    configPath = AisiFixturePath,
    outputDirectory = file.path(TestDirectory, "cover-aisi"),
    projectRoot = projectRoot
  )
  AisiChecks <- readProduct(AisiVariant, "aisi.checks.csv")
  AisiUsage <- readProduct(AisiVariant, "aisi.capacity.usage.csv")
  AisiResultSummary <- readProduct(AisiVariant, "aisi.summary.csv")
  stopifnot(
    nrow(AisiChecks) > 0L,
    nrow(AisiUsage) > 0L,
    all(is.finite(AisiResultSummary$aisiWallMemberUtilization)),
    all(AisiResultSummary$aisiWallMemberStatus %in% c("pass", "fail")),
    all(AisiResultSummary$aisiSystemStatus == "blocked"),
    all(AisiResultSummary$capacityStatus == "provided"),
    all(AisiResultSummary$standardID == "ANSI-SDI-AISI-S100-24"),
    all(AisiResultSummary$designMethodID == "ASD")
  )

  AashtoVariant <- buildCalculationData(
    configPath = file.path(projectRoot, "calculation.json"),
    outputDirectory = file.path(TestDirectory, "cover-aashto"),
    projectRoot = projectRoot
  )
  AashtoFiles <- c(
    "calculation.config.json", "calculation.inputs.csv", "stress.state.csv",
    "section.properties.csv", "interaction.parameters.csv",
    "section.resultants.csv", "section.extrema.csv", "aashto.inputs.csv",
    "aashto.thrust.csv", "aashto.calculation.csv", "aashto.checks.csv",
    "aashto.summary.csv", "display.scales.csv", "numerical.controls.csv",
    "shotcrete.section.properties.csv",
    "shotcrete.interaction.parameters.csv",
    "shotcrete.section.resultants.csv", "shotcrete.section.extrema.csv",
    "shotcrete.display.scales.csv",
    "shotcrete.numerical.controls.csv",
    "shotcrete.checks.csv", "shotcrete.summary.csv",
    "shotcrete.axial.flexure.domain.csv",
    "shotcrete.axial.flexure.demands.csv",
    "shotcrete.axial.flexure.reinforcement.domains.csv",
    "shotcrete.axial.flexure.reinforcement.sweep.csv",
    "shotcrete.axial.flexure.reinforcement.configured.demands.csv"
  )
  stopifnot(
    all(file.exists(file.path(AashtoVariant$outputDirectory, AashtoFiles))),
    !file.exists(file.path(AashtoVariant$outputDirectory, "aisi.summary.csv"))
  )
  AashtoChecks <- readProduct(AashtoVariant, "aashto.checks.csv")
  AashtoSummary <- readProduct(AashtoVariant, "aashto.summary.csv")
  AashtoCalculation <- readProduct(
    AashtoVariant,
    "aashto.calculation.csv"
  )
  ShotcreteSection <- readProduct(
    AashtoVariant,
    "shotcrete.section.properties.csv"
  )
  ShotcreteScales <- readProduct(
    AashtoVariant,
    "shotcrete.display.scales.csv"
  )
  ShotcreteChecks <- readProduct(AashtoVariant, "shotcrete.checks.csv")
  ShotcreteSummary <- readProduct(AashtoVariant, "shotcrete.summary.csv")
  AxialFlexureDomain <- readProduct(
    AashtoVariant,
    "shotcrete.axial.flexure.domain.csv"
  )
  AxialFlexureDemands <- readProduct(
    AashtoVariant,
    "shotcrete.axial.flexure.demands.csv"
  )
  ReinforcementDomains <- readProduct(
    AashtoVariant,
    "shotcrete.axial.flexure.reinforcement.domains.csv"
  )
  ReinforcementSweep <- readProduct(
    AashtoVariant,
    "shotcrete.axial.flexure.reinforcement.sweep.csv"
  )
  ReinforcementConfiguredDemands <- readProduct(
    AashtoVariant,
    "shotcrete.axial.flexure.reinforcement.configured.demands.csv"
  )
  PlainSection <- ShotcreteSection[
    ShotcreteSection$liningID == "shotcrete",
    ,
    drop = FALSE
  ]
  ReinforcedSection <- ShotcreteSection[
    ShotcreteSection$liningID == "reinforcedConcrete",
    ,
    drop = FALSE
  ]
  PlainScales <- ShotcreteScales[
    ShotcreteScales$liningID == "shotcrete",
    ,
    drop = FALSE
  ]
  ReinforcedScales <- ShotcreteScales[
    ShotcreteScales$liningID == "reinforcedConcrete",
    ,
    drop = FALSE
  ]
  PlainChecks <- ShotcreteChecks[
    ShotcreteChecks$liningID == "shotcrete",
    ,
    drop = FALSE
  ]
  ReinforcedChecks <- ShotcreteChecks[
    ShotcreteChecks$liningID == "reinforcedConcrete",
    ,
    drop = FALSE
  ]
  PlainSummary <- ShotcreteSummary[
    ShotcreteSummary$liningID == "shotcrete",
    ,
    drop = FALSE
  ]
  PlainApplicabilityChecks <- PlainChecks[
    PlainChecks$checkID %in% c(
      "structural-classification", "plain-concrete-permission"
    ),
    ,
    drop = FALSE
  ]
  ReinforcedSummary <- ShotcreteSummary[
    ShotcreteSummary$liningID == "reinforcedConcrete",
    ,
    drop = FALSE
  ]
  LoaderEnvironment <- new.env(parent = globalenv())
  LoaderEnvironment$projectRoot <- projectRoot
  LoaderEnvironment$calculationDirectory <- AashtoVariant$outputDirectory
  sys.source(
    file.path(projectRoot, "scripts", "setup", "coverCalculationResults.R"),
    envir = LoaderEnvironment
  )
  stopifnot(
    nrow(AashtoChecks) == 5L,
    nrow(AashtoSummary) == 1L,
    nrow(AashtoCalculation) == 1L,
    AashtoSummary$wallStatus == "satisfied",
    AashtoSummary$seamStatus == "satisfied",
    AashtoSummary$flexibilityStatus == "satisfied",
    AashtoSummary$minimumCoverStatus == "satisfied",
    AashtoSummary$systemStatus == "not-evaluated-specification",
    AashtoSummary$governingCheckID == "seam",
    abs(
      AashtoChecks$utilization[AashtoChecks$checkID == "seam"] -
        AashtoCalculation$designThrustKnPerM / (0.67 * 769)
    ) < 1e-12,
    AashtoCalculation$designThrustKnPerM > 0,
    AashtoCalculation$minimumCoverM > 0,
    nzchar(LoaderEnvironment$Calculation$aashto$resultMarkdown),
    nrow(ShotcreteSection) == 2L,
    nrow(PlainSection) == 1L,
    nrow(ReinforcedSection) == 1L,
    PlainSection$thicknessM == 0.10,
    ReinforcedSection$thicknessM == 0.15,
    PlainSection$centroidalRadiusM == 1.265,
    ReinforcedSection$centroidalRadiusM == 1.24,
    abs(PlainSection$youngModulusKPa - 23500000) < 1e-12,
    abs(ReinforcedSection$youngModulusKPa - 23500000) < 1e-12,
    nrow(ShotcreteScales) == 6L,
    nrow(PlainScales) == 3L,
    nrow(ReinforcedScales) == 3L,
    all(
      PlainScales$referenceRadiusM == PlainSection$centroidalRadiusM
    ),
    all(
      ReinforcedScales$referenceRadiusM ==
        ReinforcedSection$centroidalRadiusM
    ),
    nrow(ShotcreteChecks) == 96L,
    !any(grepl("reinforcement", PlainChecks$checkID, fixed = TRUE)),
    nrow(PlainChecks[
      PlainChecks$calculationStatus == "calculated" &
        PlainChecks$checkID %in% c(
          "tension-face", "compression-face", "one-way-shear"
        ),
      ,
      drop = FALSE
    ]) == 8L,
    nrow(ReinforcedChecks[
      ReinforcedChecks$calculationStatus == "calculated" &
        ReinforcedChecks$checkID == "axial-flexure",
      ,
      drop = FALSE
    ]) == 4L,
    nrow(ShotcreteSummary) == 4L,
    all(PlainSummary$concreteTypeID == "plain-concrete"),
    all(PlainSummary$shotcreteMechanicalStatus == "not-applicable"),
    all(PlainSummary$minimumReinforcementStatus == "not-applicable"),
    all(PlainSummary$shotcreteLocalStrengthUtilization > 1),
    all(PlainSummary$shotcreteLocalStrengthStatus == "not-satisfied"),
    all(PlainSummary$shotcreteNormativeStatus == "not-evaluated"),
    nrow(PlainApplicabilityChecks) == 8L,
    all(PlainApplicabilityChecks$calculationStatus == "not-evaluated"),
    all(PlainApplicabilityChecks$checkStatus == "blocked"),
    all(PlainSummary$shotcreteGoverningStrengthCaseID == "d14-h09"),
    all(PlainSummary$shotcreteGoverningCheckID == "tension-face"),
    all(ReinforcedSummary$concreteTypeID == "reinforced-concrete"),
    all(ReinforcedSummary$shotcreteMechanicalStatus == "not-applicable"),
    all(ReinforcedSummary$minimumReinforcementStatus == "satisfied"),
    all(is.finite(ReinforcedSummary$shotcreteLocalStrengthUtilization)),
    all(ReinforcedSummary$shotcreteLocalStrengthStatus == ifelse(
      ReinforcedSummary$shotcreteLocalStrengthUtilization <= 1,
      "satisfied",
      "not-satisfied"
    )),
    all(ReinforcedSummary$shotcreteNormativeStatus %in%
      c("not-evaluated", "not-satisfied")),
    all(nzchar(ReinforcedSummary$shotcreteGoverningStrengthCaseID)),
    all(ReinforcedSummary$shotcreteGoverningCheckID == "axial-flexure"),
    all(AxialFlexureDomain$liningID == "reinforcedConcrete"),
    length(unique(AxialFlexureDomain$domainPrimitiveID)) == 1L,
    isTRUE(all.equal(
      as.numeric(AxialFlexureDomain[1L, c(
        "bendingStrengthKnMPerM", "axialStrengthKnPerM"
      )]),
      as.numeric(AxialFlexureDomain[nrow(AxialFlexureDomain), c(
        "bendingStrengthKnMPerM", "axialStrengthKnPerM"
      )]),
      tolerance = 1e-12
    )),
    nrow(AxialFlexureDemands) == 2L * 2L * 720L,
    all(table(
      AxialFlexureDemands$interfaceID,
      AxialFlexureDemands$strengthCaseID
    ) == 720L),
    setequal(
      AxialFlexureDemands$interfaceID,
      c("full-traction", "normal-only")
    ),
    setequal(AxialFlexureDemands$strengthCaseID, c("d14-h16", "d14-h09")),
    nrow(ReinforcementSweep) == 5L,
    nrow(ReinforcementConfiguredDemands) == 4L,
    length(unique(ReinforcementDomains$reinforcementCaseID)) == 5L,
    all(table(ReinforcementDomains$reinforcementCaseID) == 807L),
    sum(ReinforcementSweep$isConfiguredCase) == 1L,
    sum(ReinforcementSweep$isMinimumHistoricalCase) == 1L,
    ReinforcementSweep$localPMStatus[
      ReinforcementSweep$reinforcementRatio == 0.01
    ] == "not-satisfied",
    ReinforcementSweep$localPMStatus[
      ReinforcementSweep$reinforcementRatio == 0.02
    ] == "satisfied",
    identical(
      LoaderEnvironment$Calculation$reinforcedConcrete$axialFlexureDomain,
      AxialFlexureDomain
    ),
    identical(
      LoaderEnvironment$Calculation$reinforcedConcrete$axialFlexureDemands,
      AxialFlexureDemands
    ),
    identical(
      LoaderEnvironment$Calculation$reinforcedConcrete$
        reinforcementSweep$domains,
      ReinforcementDomains
    ),
    identical(
      LoaderEnvironment$Calculation$reinforcedConcrete$
        reinforcementSweep$summary,
      ReinforcementSweep
    ),
    identical(
      LoaderEnvironment$Calculation$reinforcedConcrete$
        reinforcementSweep$configuredGoverningDemands,
      ReinforcementConfiguredDemands
    ),
    nzchar(LoaderEnvironment$Calculation$shotcrete$resultMarkdown),
    nzchar(LoaderEnvironment$Calculation$reinforcedConcrete$resultMarkdown)
  )

  ConfigH4 <- unserialize(serialize(Config, NULL))
  ConfigH4$scenarioID <- "synthetic-cover-regression-h4"
  ConfigH4$cover$coverCrownM <- 4
  CoverH4 <- buildVariant("cover-h4", ConfigH4)
  StressH4 <- readProduct(CoverH4, "stress.state.csv")
  ExtremaH4 <- readProduct(CoverH4, "section.extrema.csv")
  NBaseline <- max(abs(Extrema$signedValue[Extrema$resultantID == "N"]))
  NH4 <- max(abs(ExtremaH4$signedValue[ExtremaH4$resultantID == "N"]))
  stopifnot(
    StressH4$effectiveVerticalStressKPa > Stress$effectiveVerticalStressKPa,
    NH4 > NBaseline
  )

  Invalid <- unserialize(serialize(Config, NULL))
  Invalid$interfaceCases[[1L]]$interfaceID <- "full-slip"
  InvalidMessage <- tryCatch(
    validateCalculationConfig(Invalid),
    error = function(e) conditionMessage(e)
  )
  stopifnot(grepl("full-traction or normal-only", InvalidMessage, fixed = TRUE))

  Legacy <- validateCalculationConfig(readCalculationJson(file.path(
    projectRoot,
    "scripts", "R", "fixtures", "calculation.schema.json"
  )))
  stopifnot(Legacy$schemaVersion %in% c("2.1.0", "2.2.0"))
  invisible(TRUE)
}

runCoverCalculationDataTests()
cat("PASS: cover calculation data schemas 3.0.0 and 3.1.0.\n")
