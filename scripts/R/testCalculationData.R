runCalculationDataTests <- function() {
  Arguments <- commandArgs(trailingOnly = FALSE)
  FileArgument <- grep("^--file=", Arguments, value = TRUE)
  if (length(FileArgument) != 1L) {
    stop("Run with Rscript scripts/R/testCalculationData.R.", call. = FALSE)
  }
  ScriptPath <- normalizePath(sub("^--file=", "", FileArgument))
  Root <- normalizePath(file.path(dirname(ScriptPath), "..", ".."))
  source(file.path(Root, "scripts", "setup", "utils.R"))
  source(file.path(Root, "scripts", "R", "ringDirect.R"))
  source(file.path(Root, "scripts", "R", "ringLoads.R"))
  source(file.path(Root, "scripts", "R", "k0Models.R"))
  source(file.path(Root, "scripts", "R", "stressState.R"))
  source(file.path(Root, "scripts", "R", "corrugatedSection.R"))
  source(file.path(Root, "scripts", "R", "perimeterActions.R"))
  source(file.path(Root, "scripts", "R", "sectionResultants.R"))
  source(file.path(Root, "scripts", "R", "calculateScenario.R"))
  source(file.path(Root, "scripts", "R", "calculationData.R"))
  LoaderEnvironment <- new.env(parent = environment())
  LoaderEnvironment$projectRoot <- Root
  sys.source(
    file.path(Root, "scripts", "setup", "calculationResults.R"),
    envir = LoaderEnvironment
  )
  loadCalculationResults <- LoaderEnvironment$loadCalculationResults
  source(file.path(Root, "scripts", "tbl", "Calculation.inputs.R"))
  source(file.path(Root, "scripts", "tbl", "Calculation.extrema.R"))
  source(file.path(Root, "scripts", "tbl", "Calculation.controls.R"))
  source(file.path(Root, "scripts", "tbl", "Calculation.section.reference.R"))
  source(file.path(Root, "scripts", "fig", "Calculation.resultants.R"))

  assertNear <- function(actual, expected, tolerance, label) {
    Error <- max(abs(actual - expected))
    if (!is.finite(Error) || Error > tolerance) {
      stop(label, " failed; maximum error = ", Error, ".", call. = FALSE)
    }
  }
  assertError <- function(expression, pattern, label) {
    Message <- tryCatch(
      {
        expression()
        NA_character_
      },
      error = function(e) conditionMessage(e)
    )
    if (is.na(Message) || !grepl(pattern, Message, fixed = TRUE)) {
      stop(label, " did not produce the expected error.", call. = FALSE)
    }
  }
  copyObject <- function(value) unserialize(serialize(value, NULL))
  TestDirectory <- tempfile("calculation-data-test-")
  dir.create(TestDirectory)
  on.exit(unlink(TestDirectory, recursive = TRUE, force = TRUE), add = TRUE)
  FixturePath <- file.path(
    Root,
    "scripts",
    "R",
    "fixtures",
    "calculation.schema.json"
  )
  ManifestPath <- file.path(
    Root,
    "scripts",
    "R",
    "fixtures",
    "calculation.schema.products.json"
  )
  BaselineJson <- readCalculationJson(FixturePath)
  LegacyJson <- readCalculationJson(file.path(
    Root,
    "scripts",
    "R",
    "fixtures",
    "calculation.g0.json"
  ))
  assertError(function() {
    validateCalculationConfig(LegacyJson)
  }, "Unsupported calculation schemaVersion: 1.0.0", "legacy identifier schema")
  SectionReference <- utils::read.csv(
    file.path(Root, BaselineJson$section$propertyTable),
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  buildVariant <- function(name, change = identity) {
    Config <- change(copyObject(BaselineJson))
    ConfigPath <- file.path(TestDirectory, paste0(name, ".json"))
    OutputDirectory <- file.path(TestDirectory, name)
    jsonlite::write_json(
      Config,
      ConfigPath,
      auto_unbox = TRUE,
      pretty = TRUE,
      digits = NA
    )
    buildCalculationData(ConfigPath, OutputDirectory, Root)
    list(
      configPath = ConfigPath,
      outputDirectory = OutputDirectory,
      calculation = loadCalculationResults(Root, OutputDirectory)
    )
  }
  readProduct <- function(variant, fileName) {
    utils::read.csv(
      file.path(variant$outputDirectory, fileName),
      check.names = FALSE,
      na.strings = ""
    )
  }
  tableText <- function(value) paste(value, collapse = "\n")
  buildVariantFigure <- function(variant, resultant = "N") {
    buildCalculationResultantsInteractive(
      pathCurves = variant$calculation$paths$resultants,
      pathScales = variant$calculation$paths$scales,
      radius = variant$calculation$geometry$radiusM,
      graphicAmplification =
        variant$calculation$display$graphicAmplification,
      raysPerCircle = variant$calculation$display$raysPerCircle,
      resultant = resultant
    )
  }

  BaselineDirectory <- file.path(TestDirectory, "baseline")
  buildCalculationData(FixturePath, BaselineDirectory, Root)
  Baseline <- list(
    configPath = FixturePath,
    outputDirectory = BaselineDirectory,
    calculation = loadCalculationResults(Root, BaselineDirectory)
  )
  ExactConfigPath <- file.path(Root, "calculation.json")
  ExactConfig <- validateCalculationConfig(readCalculationJson(ExactConfigPath))
  ExactReference <- utils::read.csv(
    file.path(Root, ExactConfig$section$propertyTable),
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  ExactSelected <- selectCorrugatedSection(
    reference = ExactReference,
    profileID = ExactConfig$section$referenceProfileID,
    referenceRowID = ExactConfig$section$referenceRowID
  )
  ExactDirectory <- file.path(TestDirectory, "published-exact-row")
  buildCalculationData(ExactConfigPath, ExactDirectory, Root)
  ExactSection <- utils::read.csv(
    file.path(ExactDirectory, "section.properties.csv"),
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  stopifnot(
    ExactConfig$section$propertyModelID == "published-exact-row",
    ExactSelected$referenceRowID == "cspi-76x25-2.8",
    ExactSection$referenceRowID == ExactSelected$referenceRowID,
    ExactSection$domainStatus == "exact-published-row"
  )
  assertNear(
    c(
      ExactSection$specifiedThicknessMm,
      ExactSection$designBaseThicknessMm,
      ExactSection$areaMm2PerMm,
      ExactSection$inertiaMm4PerMm,
      ExactSection$sectionModulusMm3PerMm
    ),
    c(2.8, 2.64, 3.281, 249.73, 17.81),
    0,
    "published exact section row"
  )
  ExactMismatch <- copyObject(readCalculationJson(ExactConfigPath))
  ExactMismatch$section$designBaseThicknessMm <- 2.65
  ExactMismatchPath <- file.path(TestDirectory, "published-exact-mismatch.json")
  jsonlite::write_json(
    ExactMismatch,
    ExactMismatchPath,
    auto_unbox = TRUE,
    pretty = TRUE,
    digits = NA
  )
  assertError(function() {
    buildCalculationData(
      ExactMismatchPath,
      file.path(TestDirectory, "published-exact-mismatch"),
      Root
    )
  }, "does not match the selected published row", "exact row consistency")
  Manifest <- jsonlite::fromJSON(ManifestPath)
  Environment <- Manifest$serializationEnvironment
  OpenSSLAvailable <- requireNamespace("openssl", quietly = TRUE)
  EnvironmentMatches <- all(
    identical(R.version.string, Environment$rVersion),
    identical(R.version$platform, Environment$platform),
    identical(
      paste(Sys.info()[c("sysname", "release", "machine")], collapse = " "),
      Environment$system
    ),
    identical(Sys.getlocale(), Environment$locale),
    identical(getOption("digits"), Environment$digits),
    identical(getOption("scipen"), Environment$scipen),
    identical(as.character(utils::packageVersion("jsonlite")), Environment$jsonliteVersion),
    OpenSSLAvailable,
    OpenSSLAvailable && identical(
      as.character(utils::packageVersion("openssl")),
      Environment$opensslVersion
    ),
    identical(unname(.libPaths()), unname(Environment$libraryPaths))
  )
  if (EnvironmentMatches) {
    hashFile <- function(path) {
      Connection <- file(path, "rb")
      on.exit(close(Connection))
      as.character(openssl::sha256(Connection))
    }
    ExpectedProducts <- Manifest$products
    stopifnot(identical(
      sort(list.files(BaselineDirectory)),
      sort(ExpectedProducts$fileName)
    ))
    ActualHashes <- vapply(
      file.path(BaselineDirectory, ExpectedProducts$fileName),
      hashFile,
      character(1)
    )
    stopifnot(identical(unname(ActualHashes), ExpectedProducts$sha256))
  }
  Section <- readProduct(Baseline, "section.properties.csv")
  Stress <- readProduct(Baseline, "stress.state.csv")
  Inputs <- readProduct(Baseline, "calculation.inputs.csv")
  Controls <- readProduct(Baseline, "numerical.controls.csv")
  InputsTable <- tableText(buildCalculationInputsTable(
    Baseline$calculation$paths$inputs,
    Baseline$calculation$paths$section,
    Baseline$calculation$paths$stress
  ))
  SectionReferenceTable <- tableText(buildCalculationSectionReferenceTable(
    file.path(Root, BaselineJson$section$propertyTable),
    Baseline$calculation$paths$section
  ))
  ClosedControls <- Controls[
    Controls$controlID == "closed-form-resultants",
    ,
    drop = FALSE
  ]
  BalanceControls <- Controls[
    Controls$controlID == "global-equilibrium",
    ,
    drop = FALSE
  ]
  stopifnot(nrow(Section) == 1L, nrow(Stress) == 1L)
  stopifnot(grepl("ncspa-3x1", InputsTable, fixed = TRUE))
  stopifnot(
    grepl("2.65684", SectionReferenceTable, fixed = TRUE),
    grepl("3.4163", SectionReferenceTable, fixed = TRUE),
    !grepl("ncspa-3x1-0.109", SectionReferenceTable, fixed = TRUE)
  )
  stopifnot(
    nrow(Controls) == 12L,
    nrow(ClosedControls) == 6L,
    nrow(BalanceControls) == 6L,
    all(Controls$pass),
    identical(sort(unique(ClosedControls$resultantID)), c("M", "N", "Q")),
    identical(sort(unique(BalanceControls$resultantID)), c("Fx", "Fz", "Mc")),
    identical(unique(BalanceControls$metricID), "absolute-normalized-residual"),
    identical(unique(BalanceControls$unit), "-"),
    identical(unique(BalanceControls$limitValue), 1e-9),
    all(table(BalanceControls$caseID) == 3L)
  )
  Config.balance <- validateCalculationConfig(copyObject(BaselineJson))
  ExpectedCaseIDs <- rep(Config.balance$loadCases$caseID, each = 3L)
  ExpectedAlphas <- rep(Config.balance$loadCases$alpha, each = 3L)
  Theta.balance <- buildThetaMesh(
    pointCount = Config.balance$numerics$baseThetaPointCount,
    criticalAnglesDeg = Config.balance$numerics$criticalAnglesDeg
  )
  stopifnot(
    identical(BalanceControls$caseID, ExpectedCaseIDs),
    identical(as.numeric(BalanceControls$alpha), ExpectedAlphas),
    identical(unique(BalanceControls$comparison), "<="),
    identical(
      unique(BalanceControls$thetaPointCount),
      as.integer(length(Theta.balance))
    ),
    identical(
      unique(BalanceControls$integrationSteps),
      as.integer(BaselineJson$numerics$integrationSteps)
    ),
    identical(unique(BalanceControls$evidenceLevel), "CI")
  )
  Section.balance <- readCalculationSection(Config.balance, Root)
  ExpectedBalance <- do.call(rbind, lapply(seq_len(nrow(Config.balance$loadCases)), function(i) {
    ActionsForControl <- calculatePerimeterActions(
      stressState = list(
        effectiveVerticalKPa = Stress$effectiveVerticalKPa,
        effectiveHorizontalKPa = Stress$effectiveHorizontalKPa,
        waterPressureDifferenceKPa = Stress$waterPressureDifferenceKPa
      ),
      alpha = Config.balance$loadCases$alpha[i],
      theta = Theta.balance
    )
    ResponseForControl <- calculateSectionResultants(
      load = ActionsForControl$load,
      radius = Section.balance$analysisRadiusM,
      theta = Theta.balance,
      sectionRatio = Section.balance$sectionRatio,
      integrationSteps = Config.balance$numerics$integrationSteps,
      balanceTolerance = Config.balance$numerics$balanceTolerance
    )
    data.frame(
      caseID = Config.balance$loadCases$caseID[i],
      alpha = Config.balance$loadCases$alpha[i],
      resultantID = c("Fx", "Fz", "Mc"),
      observedValue = abs(unname(
        ResponseForControl$diagnostics$normalizedGlobalLoads[
          c("forceX", "forceZ", "momentCenter")
        ]
      )),
      stringsAsFactors = FALSE
    )
  }))
  stopifnot(
    identical(BalanceControls$caseID, ExpectedBalance$caseID),
    identical(as.numeric(BalanceControls$alpha), ExpectedBalance$alpha),
    identical(BalanceControls$resultantID, ExpectedBalance$resultantID)
  )
  assertNear(
    BalanceControls$observedValue,
    ExpectedBalance$observedValue,
    1e-28,
    "materialized global equilibrium diagnostics"
  )
  stopifnot(
    max(BalanceControls$observedValue) <= 1e-9,
    Baseline$calculation$numerics$maximumControlDifference ==
      max(ClosedControls$observedValue),
    Baseline$calculation$numerics$controlTolerance == 1e-7,
    Baseline$calculation$numerics$maximumGlobalEquilibriumResidual ==
      max(BalanceControls$observedValue),
    Baseline$calculation$numerics$balanceTolerance == 1e-9
  )
  assertNear(Section$interpolationFraction, 0.451847365233192, 1e-14, "section interpolation")
  assertNear(Section$areaMm2PerMm, 3.7304717948718, 1e-13, "section area")
  assertNear(Section$inertiaMm4PerMm, 287.902153723077, 1e-11, "section inertia")
  InterpolatedSection <- interpolateCorrugatedSection(
    reference = SectionReference,
    profileID = BaselineJson$section$referenceProfileID,
    baseThicknessMm = BaselineJson$section$analysisBaseThicknessMm
  )
  stopifnot(
    InterpolatedSection$lowerReferenceRowID == Section$lowerReferenceRowID,
    InterpolatedSection$upperReferenceRowID == Section$upperReferenceRowID,
    InterpolatedSection$sourceKey == Section$sourceKey,
    InterpolatedSection$sourceLocator == Section$sourceLocator,
    InterpolatedSection$domainStatus == Section$domainStatus
  )
  assertNear(
    InterpolatedSection$interpolationFraction,
    Section$interpolationFraction,
    1e-14,
    "pure section interpolation fraction"
  )
  assertNear(
    InterpolatedSection$areaMm2PerMm,
    Section$areaMm2PerMm,
    1e-13,
    "pure section area"
  )
  assertNear(
    InterpolatedSection$inertiaMm4PerMm,
    Section$inertiaMm4PerMm,
    1e-11,
    "pure section inertia"
  )
  LowerBoundary <- interpolateCorrugatedSection(
    reference = SectionReference,
    profileID = BaselineJson$section$referenceProfileID,
    baseThicknessMm = min(SectionReference$baseThicknessMm)
  )
  UpperBoundary <- interpolateCorrugatedSection(
    reference = SectionReference,
    profileID = BaselineJson$section$referenceProfileID,
    baseThicknessMm = max(SectionReference$baseThicknessMm)
  )
  stopifnot(
    LowerBoundary$interpolationFraction == 0,
    UpperBoundary$interpolationFraction == 1,
    LowerBoundary$lowerReferenceRowID == SectionReference$referenceRowID[1L],
    LowerBoundary$upperReferenceRowID == SectionReference$referenceRowID[2L],
    UpperBoundary$lowerReferenceRowID == SectionReference$referenceRowID[1L],
    UpperBoundary$upperReferenceRowID == SectionReference$referenceRowID[2L],
    LowerBoundary$sourceKey == UpperBoundary$sourceKey,
    LowerBoundary$sourceLocator == UpperBoundary$sourceLocator
  )
  assertNear(
    c(LowerBoundary$areaMm2PerMm, UpperBoundary$areaMm2PerMm),
    SectionReference$areaMm2PerMm,
    0,
    "section interpolation boundaries"
  )
  assertNear(
    c(LowerBoundary$inertiaMm4PerMm, UpperBoundary$inertiaMm4PerMm),
    SectionReference$inertiaMm4PerMm,
    0,
    "section inertia boundaries"
  )
  stopifnot(
    Stress$modelID == "adopted-constant",
    Stress$actionModelID == "prescribed-biaxial-stress-projection",
    Stress$k0Input == 0.5,
    is.na(Stress$k0Derived),
    Stress$k0Applied == 0.5,
    is.na(Stress$horizontalIncrementKPa),
    Stress$horizontalIncrementStatus == "unknown-not-modeled",
    Stress$effectiveHorizontalKPa == 50,
    Stress$k0EvidenceLevel == "HA",
    Stress$evidenceLevel == "DE"
  )
  stopifnot(xor(is.na(Inputs$numericValue), is.na(Inputs$textValue)) |> all())
  stopifnot(identical(
    readBin(Baseline$configPath, "raw", file.info(Baseline$configPath)$size),
    readBin(
      file.path(Baseline$outputDirectory, "calculation.config.json"),
      "raw",
      file.info(Baseline$configPath)$size
    )
  ))
  ExchangeDirectory <- file.path(TestDirectory, "directory-exchange")
  buildCalculationData(Baseline$configPath, ExchangeDirectory, Root)
  Sentinel <- file.path(ExchangeDirectory, "stale-product.txt")
  stopifnot(file.create(Sentinel))
  ExchangeConfig <- copyObject(BaselineJson)
  ExchangeConfig$stressState$k0Model$k0 <- 0.6
  ExchangeConfigPath <- file.path(TestDirectory, "directory-exchange.json")
  jsonlite::write_json(
    ExchangeConfig,
    ExchangeConfigPath,
    auto_unbox = TRUE,
    pretty = TRUE,
    digits = NA
  )
  buildCalculationData(ExchangeConfigPath, ExchangeDirectory, Root)
  ExchangeStress <- utils::read.csv(
    file.path(ExchangeDirectory, "stress.state.csv"),
    check.names = FALSE,
    na.strings = ""
  )
  stopifnot(!file.exists(Sentinel), ExchangeStress$k0Applied == 0.6)

  Vertical <- buildVariant("vertical-110", function(config) {
    config$stressState$effectiveVerticalKPa <- 110
    config
  })
  VerticalStress <- readProduct(Vertical, "stress.state.csv")
  assertNear(VerticalStress$effectiveHorizontalKPa, 55, 1e-12, "vertical stress propagation")
  BaselineResultants <- readProduct(Baseline, "section.resultants.csv")
  VerticalResultants <- readProduct(Vertical, "section.resultants.csv")
  assertNear(
    VerticalResultants$value,
    1.1 * BaselineResultants$value,
    5e-10,
    "vertical resultant scaling"
  )
  stopifnot(identical(
    readProduct(Vertical, "section.properties.csv"),
    readProduct(Baseline, "section.properties.csv")
  ))
  VerticalTable <- tableText(buildCalculationInputsTable(
    Vertical$calculation$paths$inputs,
    Vertical$calculation$paths$section,
    Vertical$calculation$paths$stress
  ))
  stopifnot(grepl("110", VerticalTable, fixed = TRUE))

  K0 <- buildVariant("k0-060", function(config) {
    config$stressState$k0Model$k0 <- 0.6
    config
  })
  K0Stress <- readProduct(K0, "stress.state.csv")
  assertNear(K0Stress$effectiveHorizontalKPa, 60, 1e-12, "K0 propagation")
  stopifnot(!identical(
    readProduct(K0, "perimeter.loads.csv")$valueKPa,
    readProduct(Baseline, "perimeter.loads.csv")$valueKPa
  ))
  stopifnot(!identical(
    K0$calculation$caseSummaryMarkdown,
    Baseline$calculation$caseSummaryMarkdown
  ))
  K0Figure <- buildVariantFigure(K0)
  stopifnot(inherits(K0Figure, "highchart"))

  Jaky <- buildVariant("jaky-30", function(config) {
    config$stressState$k0Model <- list(
      modelID = "jaky-nc",
      frictionAngleDeg = 30
    )
    config
  })
  JakyStress <- readProduct(Jaky, "stress.state.csv")
  JakyInputsTable <- tableText(buildCalculationInputsTable(
    Jaky$calculation$paths$inputs,
    Jaky$calculation$paths$section,
    Jaky$calculation$paths$stress
  ))
  stopifnot(
    is.na(JakyStress$k0Input),
    JakyStress$k0EvidenceLevel == "DE",
    JakyStress$sourceKey == "ChristopherEtAl2006",
    grepl("Jáky, carga primaria", JakyInputsTable, fixed = TRUE),
    grepl("30", JakyInputsTable, fixed = TRUE),
    !grepl("Valor adoptado", JakyInputsTable, fixed = TRUE)
  )
  assertNear(JakyStress$k0Derived, 0.5, 1e-14, "Jaky K0")
  assertNear(
    readProduct(Jaky, "section.resultants.csv")$value,
    BaselineResultants$value,
    5e-10,
    "adopted versus Jaky equivalence"
  )

  UnloadingVariant <- buildVariant("unloading-4", function(config) {
    config$stressState$k0Model <- list(
      modelID = "mayne-kulhawy-unloading",
      frictionAngleDeg = 30,
      ocr = 4
    )
    config
  })
  UnloadingInputsTable <- tableText(buildCalculationInputsTable(
    UnloadingVariant$calculation$paths$inputs,
    UnloadingVariant$calculation$paths$section,
    UnloadingVariant$calculation$paths$stress
  ))
  stopifnot(
    grepl(
      "Mayne--Kulhawy, descarga primaria",
      UnloadingInputsTable,
      fixed = TRUE
    ),
    grepl("Anterior al límite pasivo", UnloadingInputsTable, fixed = TRUE)
  )

  Thickness <- buildVariant("thickness-3-1", function(config) {
    config$section$analysisBaseThicknessMm <- 3.1
    config
  })
  ThicknessSection <- readProduct(Thickness, "section.properties.csv")
  InterpolatedThickness <- interpolateCorrugatedSection(
    reference = SectionReference,
    profileID = BaselineJson$section$referenceProfileID,
    baseThicknessMm = 3.1
  )
  assertNear(
    ThicknessSection$interpolationFraction,
    0.583519869380876,
    1e-14,
    "3.1 mm section interpolation"
  )
  assertNear(
    ThicknessSection$areaMm2PerMm,
    3.85533244147157,
    1e-13,
    "3.1 mm section area"
  )
  assertNear(
    ThicknessSection$inertiaMm4PerMm,
    298.259237335117,
    1e-11,
    "3.1 mm section inertia"
  )
  assertNear(
    ThicknessSection$sectionRatio,
    4.47384119920317e-05,
    1e-18,
    "3.1 mm section ratio"
  )
  assertNear(
    InterpolatedThickness$areaMm2PerMm,
    ThicknessSection$areaMm2PerMm,
    1e-13,
    "pure 3.1 mm section area"
  )
  assertNear(
    InterpolatedThickness$inertiaMm4PerMm,
    ThicknessSection$inertiaMm4PerMm,
    1e-11,
    "pure 3.1 mm section inertia"
  )
  stopifnot(
    InterpolatedThickness$lowerReferenceRowID ==
      ThicknessSection$lowerReferenceRowID,
    InterpolatedThickness$upperReferenceRowID ==
      ThicknessSection$upperReferenceRowID,
    InterpolatedThickness$sourceKey == ThicknessSection$sourceKey,
    InterpolatedThickness$sourceLocator == ThicknessSection$sourceLocator,
    InterpolatedThickness$domainStatus == ThicknessSection$domainStatus
  )
  stopifnot(
    ThicknessSection$areaMm2PerMm != Section$areaMm2PerMm,
    ThicknessSection$inertiaMm4PerMm != Section$inertiaMm4PerMm,
    ThicknessSection$sectionRatio != Section$sectionRatio
  )
  stopifnot(!identical(
    readProduct(Thickness, "section.resultants.csv")$value,
    BaselineResultants$value
  ))
  ThicknessInputs <- tableText(buildCalculationInputsTable(
    Thickness$calculation$paths$inputs,
    Thickness$calculation$paths$section,
    Thickness$calculation$paths$stress
  ))
  stopifnot(
    grepl("3.1", ThicknessInputs, fixed = TRUE),
    inherits(buildVariantFigure(Thickness, "M"), "highchart")
  )

  Alpha <- buildVariant("alpha-050", function(config) {
    config$loadCases[[2L]] <- list(caseID = "middle", alpha = 0.5)
    config
  })
  AlphaResultants <- readProduct(Alpha, "section.resultants.csv")
  stopifnot(
    length(unique(AlphaResultants$caseID)) == 2L,
    "0.5 y 1" == Alpha$calculation$actions$tangentialMultiplierText
  )
  FullTransfer <- BaselineResultants[
    BaselineResultants$caseID == "alpha-1",
    ,
    drop = FALSE
  ]
  NoTransfer <- BaselineResultants[
    BaselineResultants$caseID == "alpha-0",
    ,
    drop = FALSE
  ]
  MiddleTransfer <- AlphaResultants[
    AlphaResultants$caseID == "middle",
    ,
    drop = FALSE
  ]
  stopifnot(
    identical(FullTransfer$resultantID, NoTransfer$resultantID),
    identical(FullTransfer$resultantID, MiddleTransfer$resultantID),
    identical(FullTransfer$thetaIndex, NoTransfer$thetaIndex),
    identical(FullTransfer$thetaIndex, MiddleTransfer$thetaIndex)
  )
  assertNear(
    MiddleTransfer$value,
    NoTransfer$value + 0.5 * (FullTransfer$value - NoTransfer$value),
    5e-10,
    "alpha 0.5 superposition"
  )
  AlphaControls <- tableText(buildCalculationControlsTable(
    Alpha$calculation$paths$controls
  ))
  AlphaExtrema <- tableText(buildCalculationExtremaTable(
    Alpha$calculation$paths$resultants,
    Alpha$calculation$paths$extrema
  ))
  stopifnot(
    grepl("0.5", AlphaControls, fixed = TRUE),
    grepl("0.5", AlphaExtrema, fixed = TRUE),
    !grepl("Prescripción", AlphaControls, fixed = TRUE),
    !grepl("Prescripción", AlphaExtrema, fixed = TRUE),
    !grepl("middle", AlphaControls, fixed = TRUE),
    !grepl("middle", AlphaExtrema, fixed = TRUE)
  )
  AlphaFigure <- buildVariantFigure(Alpha)
  AlphaLegends <- Filter(
    function(series) isTRUE(series$showInLegend),
    AlphaFigure$x$hc_opts$series
  )
  AlphaLegendNames <- vapply(AlphaLegends, `[[`, character(1), "name")
  stopifnot("Componente tangencial: α = 0.50" %in% AlphaLegendNames)

  Water <- buildVariant("water-minus-10", function(config) {
    config$stressState$waterPressureDifferenceKPa <- -10
    config
  })
  WaterLoads <- readProduct(Water, "perimeter.loads.csv")
  CrownRadial <- WaterLoads$valueKPa[
    WaterLoads$caseID == "alpha-1" &
      WaterLoads$componentID == "radial" &
      WaterLoads$thetaIndex == 0
  ]
  assertNear(CrownRadial, -90, 1e-12, "signed water-pressure difference")
  assertNear(
    Water$calculation$actions$radialConstantKPa,
    -65,
    1e-12,
    "single water-pressure contribution"
  )
  WaterInputs <- tableText(buildCalculationInputsTable(
    Water$calculation$paths$inputs,
    Water$calculation$paths$section,
    Water$calculation$paths$stress
  ))
  WaterExtrema <- tableText(buildCalculationExtremaTable(
    Water$calculation$paths$resultants,
    Water$calculation$paths$extrema
  ))
  BaselineExtrema <- tableText(buildCalculationExtremaTable(
    Baseline$calculation$paths$resultants,
    Baseline$calculation$paths$extrema
  ))
  stopifnot(
    grepl("-10", WaterInputs, fixed = TRUE),
    !identical(
      Water$calculation$caseSummaryMarkdown,
      Baseline$calculation$caseSummaryMarkdown
    ),
    !identical(WaterExtrema, BaselineExtrema),
    inherits(buildVariantFigure(Water), "highchart")
  )

  expectedK0 <- function(
    modelID,
    frictionAngleDeg = NA_real_,
    poissonRatio = NA_real_,
    ocr = NA_real_,
    ocrMaximum = NA_real_,
    k0Input = NA_real_,
    k0Derived = NA_real_,
    k0EvidenceLevel = "DE",
    sourceKey = NA_character_,
    sourceLocator = NA_character_,
    k0Applied,
    domainStatus = "not-applicable"
  ) {
    OUT <- list(
      modelID = modelID,
      frictionAngleDeg = frictionAngleDeg,
      poissonRatio = poissonRatio,
      ocr = ocr,
      ocrMaximum = ocrMaximum,
      k0Input = k0Input,
      k0Derived = k0Derived,
      domainStatus = domainStatus,
      k0EvidenceLevel = k0EvidenceLevel,
      sourceKey = sourceKey,
      sourceLocator = sourceLocator
    )
    OUT$k0Applied <- k0Applied
    OUT
  }
  K0Cases <- list(
    list(
      model = list(modelID = "adopted-constant", k0 = 0.5),
      expected = expectedK0(
        modelID = "adopted-constant",
        k0Input = 0.5,
        k0EvidenceLevel = "HA",
        k0Applied = 0.5
      )
    ),
    list(
      model = list(modelID = "elastic-confined", poissonRatio = 0.25),
      expected = expectedK0(
        modelID = "elastic-confined",
        poissonRatio = 0.25,
        k0Derived = 1 / 3,
        sourceKey = "ChristopherEtAl2006",
        sourceLocator = "Section 5.4.9, Eq. 5.37",
        k0Applied = 1 / 3
      )
    ),
    list(
      model = list(modelID = "jaky-nc", frictionAngleDeg = 30),
      expected = expectedK0(
        modelID = "jaky-nc",
        frictionAngleDeg = 30,
        k0Derived = 0.5,
        sourceKey = "ChristopherEtAl2006",
        sourceLocator = "Section 5.4.9, Eq. 5.38",
        k0Applied = 0.5
      )
    ),
    list(
      model = list(
        modelID = "mayne-kulhawy-unloading",
        frictionAngleDeg = 30,
        ocr = 4
      ),
      expected = expectedK0(
        modelID = "mayne-kulhawy-unloading",
        frictionAngleDeg = 30,
        ocr = 4,
        k0Derived = 1,
        sourceKey = "MayneKulhawy1982",
        sourceLocator = "Eq. 10; domain control Eqs. 11-12",
        k0Applied = 1,
        domainStatus = "within-domain"
      )
    ),
    list(
      model = list(
        modelID = "mayne-kulhawy-reload",
        frictionAngleDeg = 30,
        ocr = 2,
        ocrMaximum = 4
      ),
      expected = expectedK0(
        modelID = "mayne-kulhawy-reload",
        frictionAngleDeg = 30,
        ocr = 2,
        ocrMaximum = 4,
        k0Derived = 0.6875,
        sourceKey = "MayneKulhawy1982",
        sourceLocator = "Eq. 18; domain control Eqs. 11-12",
        k0Applied = 0.6875,
        domainStatus = "within-domain"
      )
    )
  )
  for (v in K0Cases) {
    Resolved <- resolveCalculationK0(v$model)
    stopifnot(identical(Resolved, v$expected))
    LIST <- v$model
    LIST$modelID <- NULL
    Estimated <- do.call(
      estimateK0,
      c(list(modelID = v$model$modelID), LIST)
    )
    CoreFields <- c(
      "frictionAngleDeg", "poissonRatio", "ocr", "ocrMaximum",
      "k0Input", "k0Derived", "k0Applied", "domainStatus"
    )
    stopifnot(identical(Estimated$modelID, v$expected$modelID))
    stopifnot(identical(
      unname(Estimated[CoreFields]),
      unname(v$expected[CoreFields])
    ))
    stopifnot(!any(c(
      "k0EvidenceLevel",
      "sourceKey",
      "sourceLocator"
    ) %in% names(Estimated)))
  }
  Unloading <- do.call(
    estimateK0,
    c(
      list(modelID = K0Cases[[4L]]$model$modelID),
      K0Cases[[4L]]$model[setdiff(names(K0Cases[[4L]]$model), "modelID")]
    )
  )
  assertNear(Unloading$passiveCoefficient, 3, 1e-14, "unloading passive coefficient")
  assertNear(Unloading$ocrLimit, 36, 1e-12, "unloading OCR limit")

  EffectiveState <- calculateEffectiveStressState(
    effectiveVerticalKPa = 100,
    k0State = list(k0Applied = 1.5),
    waterPressureDifferenceKPa = -10,
    horizontalIncrementKPa = NA_real_,
    horizontalIncrementStatus = "unknown-not-modeled"
  )
  stopifnot(identical(
    EffectiveState,
    list(
      effectiveVerticalKPa = 100,
      baseEffectiveHorizontalKPa = 150,
      horizontalIncrementKPa = NA_real_,
      horizontalIncrementStatus = "unknown-not-modeled",
      effectiveHorizontalKPa = 150,
      waterPressureDifferenceKPa = -10
    )
  ))
  Numerics <- validateCalculationConfig(BaselineJson)$numerics
  Theta <- buildThetaMesh(
    pointCount = Numerics$baseThetaPointCount,
    criticalAnglesDeg = Numerics$criticalAnglesDeg
  )
  Theta.expected <- sort(unique(c(
    (0:(Numerics$baseThetaPointCount - 1L)) * 2 * pi /
      Numerics$baseThetaPointCount,
    Numerics$criticalAnglesDeg * pi / 180
  )))
  stopifnot(
    identical(Theta, Theta.expected),
    length(Theta) == 728L,
    identical(
      buildThetaMesh(
        pointCount = 8,
        criticalAnglesDeg = c(270, 13, 0, 180, 90)
      ),
      sort(unique(c((0:7) * 2 * pi / 8, c(270, 13, 0, 180, 90) * pi / 180)))
    )
  )

  StressStates <- list(
    vertical = list(
      effectiveVerticalKPa = 100,
      effectiveHorizontalKPa = 50,
      waterPressureDifferenceKPa = 20
    ),
    horizontal = list(
      effectiveVerticalKPa = 50,
      effectiveHorizontalKPa = 100,
      waterPressureDifferenceKPa = 20
    ),
    isotropic = list(
      effectiveVerticalKPa = 80,
      effectiveHorizontalKPa = 80,
      waterPressureDifferenceKPa = 20
    )
  )
  Theta.control <- (0:7) * pi / 4
  for (s in names(StressStates)) {
    for (x in c(0, 0.5, 1)) {
      Actions <- calculatePerimeterActions(
        stressState = StressStates[[s]],
        alpha = x,
        theta = Theta.control
      )
      Load.expected <- biaxialStressTangentialMultiplierLoad(
        effectiveVertical = StressStates[[s]]$effectiveVerticalKPa,
        effectiveHorizontal = StressStates[[s]]$effectiveHorizontalKPa,
        waterPressureDifference =
          StressStates[[s]]$waterPressureDifferenceKPa,
        tangentialMultiplier = x
      )
      stopifnot(
        inherits(Actions$load, "ringLoad"),
        identical(names(Actions$load), names(Load.expected)),
        identical(Actions$load$label, Load.expected$label),
        identical(Actions$load$source, Load.expected$source),
        identical(Actions$load$representation, Load.expected$representation),
        identical(Actions$load$breakpoints, Load.expected$breakpoints),
        identical(Actions$load$metadata, Load.expected$metadata),
        identical(Actions$values, evaluateRingLoad(Load.expected, Theta.control))
      )
    }
  }
  Actions.vertical <- calculatePerimeterActions(
    stressState = StressStates$vertical,
    alpha = 1,
    theta = Theta.control
  )$values
  Actions.horizontal <- calculatePerimeterActions(
    stressState = StressStates$horizontal,
    alpha = 1,
    theta = Theta.control
  )$values
  Actions.isotropic <- calculatePerimeterActions(
    stressState = StressStates$isotropic,
    alpha = 0.5,
    theta = Theta.control
  )$values
  assertNear(
    Actions.vertical$radialOutward[c(1L, 3L)],
    c(-120, -70),
    1e-14,
    "vertically dominant radial actions"
  )
  assertNear(
    Actions.horizontal$radialOutward[c(1L, 3L)],
    c(-70, -120),
    1e-14,
    "horizontally dominant radial actions"
  )
  assertNear(
    c(Actions.vertical$tangentialPositive[2L],
      Actions.horizontal$tangentialPositive[2L]),
    c(25, -25),
    1e-14,
    "biaxial tangential signs"
  )
  assertNear(Actions.isotropic$radialOutward, rep(-100, 8L), 0, "isotropic radial actions")
  assertNear(Actions.isotropic$tangentialPositive, rep(0, 8L), 0, "isotropic tangential actions")

  Actions.resultants <- calculatePerimeterActions(
    stressState = StressStates$vertical,
    alpha = 0.5,
    theta = Theta.control
  )
  Resultants.expected <- solveRingDirect(
    load = Actions.resultants$load,
    radius = 1.315,
    theta = Theta.control,
    sectionRatio = 0.0001,
    integrationSteps = 4096L,
    balanceTolerance = 1e-8,
    allowUnbalanced = FALSE
  )
  SectionResultants <- calculateSectionResultants(
    load = Actions.resultants$load,
    radius = 1.315,
    theta = Theta.control,
    sectionRatio = 0.0001,
    integrationSteps = 4096L,
    balanceTolerance = 1e-8,
    allowUnbalanced = FALSE
  )
  stopifnot(identical(SectionResultants, Resultants.expected))

  Config.scenario <- validateCalculationConfig(copyObject(BaselineJson))
  Context.scenario <- list(
    k0ModelID = "adopted-constant",
    horizontalIncrementKPa = NA_real_,
    horizontalIncrementStatus = "unknown-not-modeled",
    sectionReference = SectionReference,
    profileID = Config.scenario$section$referenceProfileID,
    youngModulusKPa =
      Config.scenario$material$circumferentialYoungModulusGPa * 1e6,
    radiusM = Config.scenario$geometry$insideDiameterM / 2,
    theta = buildThetaMesh(
      pointCount = Config.scenario$numerics$baseThetaPointCount,
      criticalAnglesDeg = Config.scenario$numerics$criticalAnglesDeg
    ),
    integrationSteps = Config.scenario$numerics$integrationSteps,
    balanceTolerance = Config.scenario$numerics$balanceTolerance
  )
  Realization.scenario <- list(
    k0 = Config.scenario$stressState$k0Model$k0,
    effectiveVerticalKPa = Config.scenario$stressState$effectiveVerticalKPa,
    waterPressureDifferenceKPa =
      Config.scenario$stressState$waterPressureDifferenceKPa,
    baseThicknessMm = Config.scenario$section$analysisBaseThicknessMm,
    alpha = 0.5
  )
  Context.expected <- copyObject(Context.scenario)
  Realization.expected <- copyObject(Realization.scenario)
  Scenario <- calculateScenario(
    realization = Realization.scenario,
    context = Context.scenario
  )
  K0State.expected <- estimateK0(
    modelID = Context.scenario$k0ModelID,
    k0 = Realization.scenario$k0
  )
  StressState.expected <- calculateEffectiveStressState(
    effectiveVerticalKPa = Realization.scenario$effectiveVerticalKPa,
    k0State = K0State.expected,
    waterPressureDifferenceKPa =
      Realization.scenario$waterPressureDifferenceKPa,
    horizontalIncrementKPa = Context.scenario$horizontalIncrementKPa,
    horizontalIncrementStatus = Context.scenario$horizontalIncrementStatus
  )
  CorrugatedSection.expected <- interpolateCorrugatedSection(
    reference = Context.scenario$sectionReference,
    profileID = Context.scenario$profileID,
    baseThicknessMm = Realization.scenario$baseThicknessMm
  )
  SectionRigidity.expected <- calculateRingSection(
    youngModulus = Context.scenario$youngModulusKPa,
    area = CorrugatedSection.expected$areaMm2PerMm * 1e-3,
    inertia = CorrugatedSection.expected$inertiaMm4PerMm * 1e-9,
    radius = Context.scenario$radiusM
  )
  PerimeterActions.expected <- calculatePerimeterActions(
    stressState = StressState.expected,
    alpha = Realization.scenario$alpha,
    theta = Context.scenario$theta
  )
  SectionResultants.expected <- calculateSectionResultants(
    load = PerimeterActions.expected$load,
    radius = Context.scenario$radiusM,
    theta = Context.scenario$theta,
    sectionRatio = SectionRigidity.expected$sectionRatio,
    integrationSteps = Context.scenario$integrationSteps,
    balanceTolerance = Context.scenario$balanceTolerance
  )
  ResultantExtrema.expected <- summarizeSectionResultants(
    SectionResultants.expected
  )
  stopifnot(
    identical(names(Scenario), c(
      "k0State", "stressState", "corrugatedSection", "sectionRigidity",
      "perimeterActions", "sectionResultants", "resultantExtrema"
    )),
    identical(Scenario$k0State, K0State.expected),
    identical(Scenario$stressState, StressState.expected),
    identical(Scenario$corrugatedSection, CorrugatedSection.expected),
    identical(Scenario$sectionRigidity, SectionRigidity.expected),
    identical(
      Scenario$perimeterActions$values,
      PerimeterActions.expected$values
    ),
    identical(
      Scenario$perimeterActions$load$metadata,
      PerimeterActions.expected$load$metadata
    ),
    identical(
      Scenario$sectionResultants$values,
      SectionResultants.expected$values
    ),
    identical(
      Scenario$sectionResultants$diagnostics,
      SectionResultants.expected$diagnostics
    ),
    identical(Scenario$resultantExtrema, ResultantExtrema.expected),
    identical(Context.scenario, Context.expected),
    identical(Realization.scenario, Realization.expected)
  )

  assertError(function() {
    calculateEffectiveStressState(
      effectiveVerticalKPa = 100,
      k0State = list(k0Applied = 0.5),
      waterPressureDifferenceKPa = 0,
      horizontalIncrementKPa = 0,
      horizontalIncrementStatus = "unknown-not-modeled"
    )
  }, "must remain NA", "unknown horizontal increment")
  assertError(function() {
    buildThetaMesh(pointCount = 2, criticalAnglesDeg = 0)
  }, "must be at least 3", "theta mesh point count")
  assertError(function() {
    buildThetaMesh(pointCount = 8.5, criticalAnglesDeg = 0)
  }, "must be an integer", "integer theta mesh point count")
  assertError(function() {
    buildThetaMesh(pointCount = 8, criticalAnglesDeg = c(0, 0))
  }, "must be unique", "theta mesh critical-angle uniqueness")
  assertError(function() {
    calculatePerimeterActions(
      stressState = list(effectiveVerticalKPa = 100),
      alpha = 0,
      theta = Theta.control
    )
  }, "stressState is missing", "effective stress fields")
  assertError(function() {
    calculateSectionResultants(
      load = Actions.resultants$load,
      radius = 0,
      theta = Theta.control
    )
  }, "must be greater than 0", "section resultant radius")
  assertError(function() {
    calculateScenario(
      realization = Realization.scenario[names(Realization.scenario) != "alpha"],
      context = Context.scenario
    )
  }, "realization is missing: alpha", "scenario realization fields")
  assertError(function() {
    calculateScenario(
      realization = Realization.scenario,
      context = Context.scenario[names(Context.scenario) != "theta"]
    )
  }, "context is missing: theta", "scenario context fields")
  assertError(function() {
    estimateK0(modelID = "adopted-constant")
  }, "missing: k0", "missing K0 branch primitive")
  assertError(function() {
    estimateK0(
      modelID = "adopted-constant",
      k0 = 0.5,
      frictionAngleDeg = 30
    )
  }, "unsupported parameters", "exclusive direct K0 branch")
  assertError(function() {
    estimateK0(modelID = "adopted-constant", k0 = -0.1)
  }, "must be at least 0", "negative adopted K0")

  assertError(function() {
    Config <- copyObject(BaselineJson)
    Config$stressState$k0Model <- list(modelID = "measured", k0 = 0.5)
    validateCalculationConfig(Config)
  }, "Unsupported K0 modelID", "deferred measured branch")
  assertError(function() {
    Config <- copyObject(BaselineJson)
    Config$stressState$k0Model$frictionAngleDeg <- 30
    validateCalculationConfig(Config)
  }, "unsupported fields", "exclusive K0 branch")
  assertError(function() {
    Config <- copyObject(BaselineJson)
    Config$section$analysisBaseThicknessMm <- 5
    Path <- file.path(TestDirectory, "invalid-thickness.json")
    jsonlite::write_json(Config, Path, auto_unbox = TRUE)
    buildCalculationData(Path, file.path(TestDirectory, "invalid-thickness"), Root)
  }, "outside the published range", "section interpolation domain")
  assertError(function() {
    InvalidReference <- SectionReference
    InvalidReference$inertiaMm4PerMm <- NULL
    interpolateCorrugatedSection(
      reference = InvalidReference,
      profileID = BaselineJson$section$referenceProfileID,
      baseThicknessMm = 3
    )
  }, "property table is missing", "section reference schema")
  assertError(function() {
    interpolateCorrugatedSection(
      reference = SectionReference,
      profileID = "unknown-profile",
      baseThicknessMm = 3
    )
  }, "At least two rows", "section reference profile")
  assertError(function() {
    InvalidReference <- SectionReference
    InvalidReference$areaMm2PerMm[1L] <- 0
    interpolateCorrugatedSection(
      reference = InvalidReference,
      profileID = BaselineJson$section$referenceProfileID,
      baseThicknessMm = 3
    )
  }, "must be finite and positive", "section reference values")
  assertError(function() {
    InvalidReference <- SectionReference
    InvalidReference$baseThicknessMm[2L] <-
      InvalidReference$baseThicknessMm[1L]
    interpolateCorrugatedSection(
      reference = InvalidReference,
      profileID = BaselineJson$section$referenceProfileID,
      baseThicknessMm = InvalidReference$baseThicknessMm[1L]
    )
  }, "must be unique", "section reference uniqueness")
  assertError(function() {
    InvalidReference <- SectionReference
    InvalidReference$sourceLocator[2L] <- "different locator"
    interpolateCorrugatedSection(
      reference = InvalidReference,
      profileID = BaselineJson$section$referenceProfileID,
      baseThicknessMm = 3
    )
  }, "share one source and locator", "section reference provenance")
  assertError(function() {
    Config <- copyObject(BaselineJson)
    Config$loadCases[[1L]]$alpha <- 1.1
    validateCalculationConfig(Config)
  }, "at most 1", "alpha domain")
  assertError(function() {
    resolveCalculationK0(list(
      modelID = "mayne-kulhawy-unloading",
      frictionAngleDeg = 30,
      ocr = 36
    ))
  }, "passive limit", "K0 passive domain")
  assertError(function() {
    Config <- copyObject(BaselineJson)
    Config$stressState$effectiveVerticalKPa <- NULL
    validateCalculationConfig(Config)
  }, "stressState is missing", "required configuration field")
  FailedControlDirectory <- file.path(TestDirectory, "failed-control")
  assertError(function() {
    Config <- copyObject(BaselineJson)
    Config$numerics$closedFormTolerance <- 1e-16
    Path <- file.path(TestDirectory, "failed-control.json")
    jsonlite::write_json(Config, Path, auto_unbox = TRUE)
    buildCalculationData(Path, FailedControlDirectory, Root)
  }, "numerical controls failed", "failed numerical control")
  stopifnot(!dir.exists(FailedControlDirectory))

  MissingDirectory <- file.path(TestDirectory, "missing-product")
  dir.create(MissingDirectory)
  BaselineFiles <- list.files(Baseline$outputDirectory, full.names = TRUE)
  file.copy(
    BaselineFiles[basename(BaselineFiles) != "stress.state.csv"],
    MissingDirectory
  )
  assertError(function() {
    loadCalculationResults(Root, MissingDirectory)
  }, "stress.state.csv", "missing materialized product")

  InvalidSchemaDirectory <- file.path(TestDirectory, "invalid-schema")
  dir.create(InvalidSchemaDirectory)
  file.copy(BaselineFiles, InvalidSchemaDirectory)
  InvalidScales <- utils::read.csv(
    file.path(InvalidSchemaDirectory, "display.scales.csv"),
    check.names = FALSE
  )
  InvalidScales$ordinateCount <- NULL
  utils::write.csv(
    InvalidScales,
    file.path(InvalidSchemaDirectory, "display.scales.csv"),
    row.names = FALSE
  )
  assertError(function() {
    loadCalculationResults(Root, InvalidSchemaDirectory)
  }, "ordinateCount", "incompatible materialized schema")

  ConfigNames <- names(BaselineJson)
  stopifnot(!any(c("distributions", "monteCarlo", "modelProbabilities") %in% ConfigNames))

  cat("PASS: deterministic calculation-data contract and propagation.\n")
}

runCalculationDataTests()
