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
  source(file.path(Root, "scripts", "R", "calculationData.R"))
  projectRoot <- Root
  source(
    file.path(Root, "scripts", "setup", "calculationResults.R"),
    local = environment()
  )
  source(file.path(Root, "scripts", "tbl", "Calculation.inputs.R"))
  source(file.path(Root, "scripts", "tbl", "Calculation.extrema.R"))
  source(file.path(Root, "scripts", "tbl", "Calculation.controls.R"))
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
      error = function(Error) conditionMessage(Error)
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
    "calculation.g0.json"
  )
  ManifestPath <- file.path(
    Root,
    "scripts",
    "R",
    "fixtures",
    "calculation.g0.products.json"
  )
  BaselineJson <- readCalculationJson(FixturePath)
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
  Manifest <- jsonlite::fromJSON(ManifestPath)
  Environment <- Manifest$serializationEnvironment
  OpenSslAvailable <- requireNamespace("openssl", quietly = TRUE)
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
    OpenSslAvailable,
    OpenSslAvailable && identical(
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
  stopifnot(nrow(Section) == 1L, nrow(Stress) == 1L)
  assertNear(Section$interpolationFraction, 0.451847365233192, 1e-14, "section interpolation")
  assertNear(Section$areaMm2PerMm, 3.7304717948718, 1e-13, "section area")
  assertNear(Section$inertiaMm4PerMm, 287.902153723077, 1e-11, "section inertia")
  stopifnot(
    Stress$modelId == "adopted-constant",
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

  Vertical <- buildVariant("vertical-110", function(Config) {
    Config$stressState$effectiveVerticalKPa <- 110
    Config
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

  K0 <- buildVariant("k0-060", function(Config) {
    Config$stressState$k0Model$k0 <- 0.6
    Config
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

  Jaky <- buildVariant("jaky-30", function(Config) {
    Config$stressState$k0Model <- list(
      modelId = "jaky-nc",
      frictionAngleDeg = 30
    )
    Config
  })
  JakyStress <- readProduct(Jaky, "stress.state.csv")
  stopifnot(
    is.na(JakyStress$k0Input),
    JakyStress$k0EvidenceLevel == "DE",
    JakyStress$sourceKey == "ChristopherEtAl2006"
  )
  assertNear(JakyStress$k0Derived, 0.5, 1e-14, "Jaky K0")
  assertNear(
    readProduct(Jaky, "section.resultants.csv")$value,
    BaselineResultants$value,
    5e-10,
    "adopted versus Jaky equivalence"
  )

  Thickness <- buildVariant("thickness-3-1", function(Config) {
    Config$section$analysisBaseThicknessMm <- 3.1
    Config
  })
  ThicknessSection <- readProduct(Thickness, "section.properties.csv")
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

  Alpha <- buildVariant("alpha-050", function(Config) {
    Config$loadCases[[2L]] <- list(caseId = "middle", alpha = 0.5)
    Config
  })
  AlphaResultants <- readProduct(Alpha, "section.resultants.csv")
  stopifnot(
    length(unique(AlphaResultants$caseId)) == 2L,
    "0.5 y 1" == Alpha$calculation$actions$tangentialMultiplierText
  )
  FullTransfer <- BaselineResultants[
    BaselineResultants$caseId == "alpha-1",
    ,
    drop = FALSE
  ]
  NoTransfer <- BaselineResultants[
    BaselineResultants$caseId == "alpha-0",
    ,
    drop = FALSE
  ]
  MiddleTransfer <- AlphaResultants[
    AlphaResultants$caseId == "middle",
    ,
    drop = FALSE
  ]
  stopifnot(
    identical(FullTransfer$resultantId, NoTransfer$resultantId),
    identical(FullTransfer$resultantId, MiddleTransfer$resultantId),
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
    grepl("α = 0.50", AlphaControls, fixed = TRUE),
    grepl("α = 0.50", AlphaExtrema, fixed = TRUE),
    !grepl("middle", AlphaControls, fixed = TRUE),
    !grepl("middle", AlphaExtrema, fixed = TRUE)
  )
  AlphaFigure <- buildVariantFigure(Alpha)
  AlphaLegends <- Filter(
    function(Series) isTRUE(Series$showInLegend),
    AlphaFigure$x$hc_opts$series
  )
  AlphaLegendNames <- vapply(AlphaLegends, `[[`, character(1), "name")
  stopifnot("Componente tangencial: α = 0.50" %in% AlphaLegendNames)

  Water <- buildVariant("water-minus-10", function(Config) {
    Config$stressState$waterPressureDifferenceKPa <- -10
    Config
  })
  WaterLoads <- readProduct(Water, "perimeter.loads.csv")
  CrownRadial <- WaterLoads$valueKPa[
    WaterLoads$caseId == "alpha-1" &
      WaterLoads$componentId == "radial" &
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
    modelId,
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
    Result <- list(
      modelId = modelId,
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
    Result$k0Applied <- k0Applied
    Result
  }
  K0Cases <- list(
    list(
      model = list(modelId = "adopted-constant", k0 = 0.5),
      expected = expectedK0(
        modelId = "adopted-constant",
        k0Input = 0.5,
        k0EvidenceLevel = "HA",
        k0Applied = 0.5
      )
    ),
    list(
      model = list(modelId = "elastic-confined", poissonRatio = 0.25),
      expected = expectedK0(
        modelId = "elastic-confined",
        poissonRatio = 0.25,
        k0Derived = 1 / 3,
        sourceKey = "ChristopherEtAl2006",
        sourceLocator = "Section 5.4.9, Eq. 5.37",
        k0Applied = 1 / 3
      )
    ),
    list(
      model = list(modelId = "jaky-nc", frictionAngleDeg = 30),
      expected = expectedK0(
        modelId = "jaky-nc",
        frictionAngleDeg = 30,
        k0Derived = 0.5,
        sourceKey = "ChristopherEtAl2006",
        sourceLocator = "Section 5.4.9, Eq. 5.38",
        k0Applied = 0.5
      )
    ),
    list(
      model = list(
        modelId = "mayne-kulhawy-unloading",
        frictionAngleDeg = 30,
        ocr = 4
      ),
      expected = expectedK0(
        modelId = "mayne-kulhawy-unloading",
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
        modelId = "mayne-kulhawy-reload",
        frictionAngleDeg = 30,
        ocr = 2,
        ocrMaximum = 4
      ),
      expected = expectedK0(
        modelId = "mayne-kulhawy-reload",
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
  for (Case in K0Cases) {
    stopifnot(identical(
      do.call(resolveCalculationK0, list(Case$model)),
      Case$expected
    ))
  }

  assertError(function() {
    Config <- copyObject(BaselineJson)
    Config$stressState$k0Model <- list(modelId = "measured", k0 = 0.5)
    validateCalculationConfig(Config)
  }, "Unsupported K0 modelId", "deferred measured branch")
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
    Config <- copyObject(BaselineJson)
    Config$loadCases[[1L]]$alpha <- 1.1
    validateCalculationConfig(Config)
  }, "at most 1", "alpha domain")
  assertError(function() {
    resolveCalculationK0(list(
      modelId = "mayne-kulhawy-unloading",
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
