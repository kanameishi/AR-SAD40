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
        caseID = "slip",
        interfaceID = "full-traction",
        tangentialMultiplier = 1,
        comparisonInterfaceID = "full-slip"
      ),
      list(
        caseID = "no-slip",
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
  Scales <- readProduct(Baseline, "display.scales.csv")

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
      c("full-slip", "no-slip")
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
    "shotcrete.axial.flexure.reinforcement.governing.demands.csv",
    "shotcrete.axial.flexure.reinforcement.limit.checks.csv",
    "classical.comparison.inputs.csv", "classical.comparison.sections.csv",
    "classical.comparison.curves.csv", "classical.comparison.points.csv",
    "classical.comparison.summary.csv"
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
  AashtoScales <- readProduct(AashtoVariant, "display.scales.csv")
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
  ReinforcementGoverningDemands <- readProduct(
    AashtoVariant,
    "shotcrete.axial.flexure.reinforcement.governing.demands.csv"
  )
  ReinforcementLimitChecks <- readProduct(
    AashtoVariant,
    "shotcrete.axial.flexure.reinforcement.limit.checks.csv"
  )
  ClassicalInputs <- readProduct(
    AashtoVariant, "classical.comparison.inputs.csv"
  )
  ClassicalSections <- readProduct(
    AashtoVariant, "classical.comparison.sections.csv"
  )
  ClassicalCurves <- readProduct(
    AashtoVariant, "classical.comparison.curves.csv"
  )
  ClassicalPoints <- readProduct(
    AashtoVariant, "classical.comparison.points.csv"
  )
  ClassicalSummary <- readProduct(
    AashtoVariant, "classical.comparison.summary.csv"
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
  AllDisplayScales <- rbind(
    AashtoScales[, c("resultantID", "displayScale", "scaleBasisID")],
    ShotcreteScales[, c("resultantID", "displayScale", "scaleBasisID")]
  )
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
  Plain150Checks <- ShotcreteChecks[
    ShotcreteChecks$liningID == "plainConcrete150",
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
    nrow(ClassicalInputs) == 1L,
    nrow(ClassicalSections) == 3L,
    nrow(ClassicalCurves) > 0L,
    nrow(ClassicalPoints) == 21L,
    nrow(ClassicalSummary) == 30L,
    setequal(
      unique(ClassicalSummary$methodID),
      c(
        "official-hybrid", "schwartz-einstein-uniform",
        "prescribed-k0-ring", "nunez-2000", "nunez-2014",
        "aashto-usace"
      )
    ),
    nrow(AashtoSummary) == 1L,
    nrow(AashtoCalculation) == 1L,
    AashtoSummary$wallStatus == "satisfied",
    AashtoSummary$seamStatus == "not-satisfied",
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
    abs(PlainSection$youngModulusKPa - 4700 * sqrt(30) * 1000) < 1e-8,
    abs(ReinforcedSection$youngModulusKPa - 4700 * sqrt(30) * 1000) < 1e-8,
    all(ShotcreteSection$stiffnessBasisID ==
      "aci-318-25-cracked-wall-0p35-ig"),
    all(abs(ShotcreteSection$inertiaReductionFactor - 0.35) < 1e-12),
    nrow(ShotcreteScales) == 6L,
    nrow(PlainScales) == 3L,
    nrow(ReinforcedScales) == 3L,
    all(AllDisplayScales$scaleBasisID ==
      "common-by-resultant-across-linings"),
    all(vapply(split(
      AllDisplayScales$displayScale,
      AllDisplayScales$resultantID
    ), function(x) length(unique(x)) == 1L, logical(1))),
    all(
      PlainScales$referenceRadiusM == PlainSection$centroidalRadiusM
    ),
    all(
      ReinforcedScales$referenceRadiusM ==
        ReinforcedSection$centroidalRadiusM
    ),
    nrow(ShotcreteChecks) == 216L,
    !any(grepl("reinforcement", PlainChecks$checkID, fixed = TRUE)),
    nrow(PlainChecks[
      PlainChecks$calculationStatus == "calculated" &
        PlainChecks$checkID %in% c(
          "tension-face", "compression-face", "one-way-shear"
        ),
      ,
      drop = FALSE
    ]) == 16L,
    nrow(Plain150Checks) == 24L,
    nrow(Plain150Checks[
      Plain150Checks$calculationStatus == "calculated" &
        Plain150Checks$checkID %in% c("tension-face", "one-way-shear"),
      ,
      drop = FALSE
    ]) == 16L,
    all(Plain150Checks$calculationStatus[
      Plain150Checks$checkID == "compression-face"
    ] == "not-evaluated"),
    nrow(ReinforcedChecks[
      ReinforcedChecks$calculationStatus == "calculated" &
        ReinforcedChecks$checkID == "axial-flexure",
      ,
      drop = FALSE
    ]) == 8L,
    nrow(ShotcreteSummary) == 4L,
    all(PlainSummary$concreteTypeID == "plain-concrete"),
    all(PlainSummary$shotcreteMechanicalStatus == "not-applicable"),
    all(PlainSummary$minimumReinforcementStatus == "not-applicable"),
    all(PlainSummary$shotcreteLocalStrengthUtilization > 1),
    all(PlainSummary$shotcreteLocalStrengthStatus == "not-satisfied"),
    all(PlainSummary$shotcreteNormativeStatus == "not-evaluated"),
    nrow(PlainApplicabilityChecks) == 16L,
    all(PlainApplicabilityChecks$calculationStatus == "not-evaluated"),
    all(PlainApplicabilityChecks$checkStatus == "blocked"),
    all(PlainSummary$shotcreteGoverningStrengthCaseID %in% c(
      "ev130-eh135", "ev130-eh090",
      "ev090-eh135", "ev090-eh090"
    )),
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
    nrow(AxialFlexureDemands) == 2L * 4L * 720L,
    all(table(
      AxialFlexureDemands$interfaceID,
      AxialFlexureDemands$strengthCaseID
    ) == 720L),
    setequal(
      AxialFlexureDemands$interfaceID,
      c("full-slip", "no-slip")
    ),
    setequal(AxialFlexureDemands$strengthCaseID, c(
      "ev130-eh135", "ev130-eh090",
      "ev090-eh135", "ev090-eh090"
    )),
    nrow(ReinforcementSweep) == 8L,
    nrow(ReinforcementGoverningDemands) == 16L,
    nrow(ReinforcementLimitChecks) == 16L,
    all(table(ReinforcementSweep$liningID) == 4L),
    all(table(ReinforcementGoverningDemands$liningID) == 8L),
    all(table(ReinforcementLimitChecks$liningID) == 8L),
    all(table(
      ReinforcementGoverningDemands$liningID,
      ReinforcementGoverningDemands$reinforcementCaseID
    )[table(
      ReinforcementGoverningDemands$liningID,
      ReinforcementGoverningDemands$reinforcementCaseID
    ) > 0L] == 2L),
    all(table(
      ReinforcementDomains$liningID,
      ReinforcementDomains$reinforcementCaseID
    )[table(
      ReinforcementDomains$liningID,
      ReinforcementDomains$reinforcementCaseID
    ) > 0L] %in% c(1207L, 1211L)),
    sum(ReinforcementSweep$isParametricCase) == 6L,
    sum(!ReinforcementSweep$isParametricCase) == 2L,
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
      ReinforcementDomains[
        ReinforcementDomains$liningID == "reinforcedConcrete",
        ,
        drop = FALSE
      ]
    ),
    identical(
      LoaderEnvironment$Calculation$reinforcedConcrete$
        reinforcementSweep$summary,
      ReinforcementSweep[
        ReinforcementSweep$liningID == "reinforcedConcrete",
        ,
        drop = FALSE
      ]
    ),
    identical(
      LoaderEnvironment$Calculation$reinforcedConcrete$
        reinforcementSweep$governingDemands,
      ReinforcementGoverningDemands[
        ReinforcementGoverningDemands$liningID == "reinforcedConcrete",
        ,
        drop = FALSE
      ]
    ),
    identical(
      LoaderEnvironment$Calculation$reinforcedConcrete$
        reinforcementSweep$limitChecks,
      ReinforcementLimitChecks[
        ReinforcementLimitChecks$liningID == "reinforcedConcrete",
        ,
        drop = FALSE
      ]
    ),
    identical(
      LoaderEnvironment$Calculation$shotcrete$reinforcementSweep$summary,
      ReinforcementSweep[
        ReinforcementSweep$liningID == "shotcrete",
        ,
        drop = FALSE
      ]
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
    validateCoverCalculationConfig(Invalid),
    error = function(e) conditionMessage(e)
  )
  stopifnot(grepl("full-traction or normal-only", InvalidMessage, fixed = TRUE))
  invisible(TRUE)
}

runCoverCalculationDataTests()
cat("PASS: cover calculation data schemas 3.0.0 and 3.1.0.\n")
