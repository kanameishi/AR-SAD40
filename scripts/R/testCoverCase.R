# Regression checks for the public engineering-input boundary.

Arguments <- commandArgs(trailingOnly = FALSE)
FileArgument <- grep("^--file=", Arguments, value = TRUE)
if (length(FileArgument) != 1L) {
  stop("Run with Rscript scripts/R/testCoverCase.R.", call. = FALSE)
}
ScriptPath <- normalizePath(sub("^--file=", "", FileArgument))
projectRoot <- normalizePath(file.path(dirname(ScriptPath), "..", ".."))
source(
  file.path(projectRoot, "scripts", "setup", "calculationFunctions.R"),
  local = TRUE
)

countCoverCaseLeaves <- function(value) {
  if (!is.list(value)) return(1L)
  sum(vapply(value, countCoverCaseLeaves, integer(1)))
}

copyCoverCaseInputs <- function(inputs) {
  unserialize(serialize(inputs, NULL))
}

readCoverCaseMethodProfile <- function(projectRoot) {
  OUT <- readCalculationJson(file.path(
    projectRoot,
    "scripts",
    "config",
    "cover.method.mesh.2026-08-16.json"
  ))
  stopifnot(
    identical(
      OUT[["methodProfileID", exact = TRUE]],
      "ar-sad40-cover-mesh-2026-08-16"
    ),
    identical(OUT[["methodProfileVersion", exact = TRUE]], "1.3.0")
  )
  OUT[["methodProfileID"]] <- NULL
  OUT[["methodProfileVersion"]] <- NULL
  OUT
}

Manifest <- readCalculationJson(file.path(projectRoot, "calculation.json"))
Inputs <- Manifest[["inputs", exact = TRUE]]
stopifnot(
  identical(Manifest[["contractVersion", exact = TRUE]], "cover-case-2"),
  identical(
    Manifest[["methodID", exact = TRUE]],
    "ar-sad40-cover-current"
  ),
  countCoverCaseLeaves(Inputs) == 39L,
  identical(
    names(Inputs),
    c(
      "cover", "ground", "steel", "seam", "classicalComparison",
      "plainConcrete", "reinforcedConcrete"
    )
  )
)

Resolution <- resolveCoverCaseConfig(
  inputs = Inputs,
  projectRoot = projectRoot,
  methodID = Manifest[["methodID", exact = TRUE]]
)
ExpectedProfile <- readCoverCaseMethodProfile(projectRoot)
ExpectedProfile[["classicalComparison"]] <- Inputs[["classicalComparison"]]
ExpectedConfig <- validateCoverCalculationConfig(ExpectedProfile)
stopifnot(
  identical(Resolution[["config", exact = TRUE]], ExpectedConfig),
  identical(
    Resolution[["methodBasis", exact = TRUE]][[
      "methodProfileID",
      exact = TRUE
    ]],
    "ar-sad40-cover-mesh-2026-08-16"
  ),
  identical(
    Resolution[["methodBasis", exact = TRUE]][[
      "methodProfileVersion",
      exact = TRUE
    ]],
    "1.3.0"
  ),
  abs(Resolution[["derived", exact = TRUE]][[
    "reinforcedAreaMm2PerFaceAndDirection",
    exact = TRUE
  ]] - 188.4955592153876) < 1e-12,
  abs(Resolution[["derived", exact = TRUE]][[
    "reinforcedBarAreaMm2",
    exact = TRUE
  ]] - 28.27433388230814) < 1e-12,
  Resolution[["derived", exact = TRUE]][[
    "reinforcedClearCoverMm",
    exact = TRUE
  ]] == 22.5,
  Resolution[["derived", exact = TRUE]][[
    "reinforcedLayerCentroidCoverMm",
    exact = TRUE
  ]] == 25.5,
  Resolution[["derived", exact = TRUE]][[
    "reinforcedInteriorLayerCoordinateMm",
    exact = TRUE
  ]] == -49.5,
  Resolution[["derived", exact = TRUE]][[
    "reinforcedExteriorLayerCoordinateMm",
    exact = TRUE
  ]] == 49.5,
  Resolution[["derived", exact = TRUE]][[
    "reinforcementYieldStrengthMPa",
    exact = TRUE
  ]] == 414,
  Resolution[["derived", exact = TRUE]][["steelSpanM", exact = TRUE]] == 2.63
)

Expected <- evaluateCoverConfiguration(
  config = ExpectedProfile,
  projectRoot = projectRoot
)
Observed <- evaluateCoverCase(
  inputs = Inputs,
  projectRoot = projectRoot,
  methodID = Manifest[["methodID", exact = TRUE]]
)
Surfaces <- c(
  "theta", "stress", "section", "interaction",
  "schwartzEinsteinComparison", "resultants", "extrema", "controls",
  "aashto", "additionalLinings"
)
stopifnot(all(vapply(
  Surfaces,
  function(s) identical(Observed[[s]], Expected[[s]]),
  logical(1)
)))
stopifnot(
  is.data.frame(Observed[["schwartzEinsteinComparison", exact = TRUE]]),
  nrow(Observed[["schwartzEinsteinComparison", exact = TRUE]]) == 2L,
  all(c(
    "interfaceID", "normalMeanKnPerM", "normalCosineKnPerM",
    "momentCosineKnMPerM", "shearSineKnPerM"
  ) %in% names(Observed[["schwartzEinsteinComparison", exact = TRUE]])),
  identical(
    names(Observed[["reinforcementStudy", exact = TRUE]]),
    c("domains", "summary", "governingDemands")
  ),
  nrow(Observed[["reinforcementStudy", exact = TRUE]][[
    "summary",
    exact = TRUE
  ]]) == 8L
)
Study <- Observed[["reinforcementStudy", exact = TRUE]]
stopifnot(
  all(c(
    "liningID", "reinforcementCaseID", "domainPointIndex",
    "axialStrengthKnPerM", "bendingStrengthKnMPerM"
  ) %in% names(Study[["domains", exact = TRUE]])),
  all(c(
    "liningID", "reinforcementCaseID", "reinforcementCaseOrder",
    "reinforcementRatio", "circumferentialAreaTotalMm2PerM",
    "maximumRadialUtilization", "localPMStatus", "isLowerReferenceCase"
  ) %in% names(Study[["summary", exact = TRUE]])),
  all(c(
    "liningID", "demandOrder", "interfaceID", "strengthCaseID",
    "thetaDeg", "axialDemandKnPerM", "bendingDemandKnMPerM",
    "radialUtilization"
  ) %in% names(Study[["governingDemands", exact = TRUE]])),
  identical(sort(unique(Study[["summary"]][["liningID"]])), c(
    "reinforcedConcrete", "shotcrete"
  ))
)

Contaminated <- copyCoverCaseInputs(Inputs)
Contaminated[["ground"]][["deadLoadFactor"]] <- 1.95
ContaminationMessage <- tryCatch(
  resolveCoverCaseConfig(
    inputs = Contaminated,
    projectRoot = projectRoot,
    methodID = Manifest[["methodID", exact = TRUE]]
  ),
  error = function(e) conditionMessage(e)
)
stopifnot(grepl("unsupported fields", ContaminationMessage, fixed = TRUE))

mutateCoverCaseInput <- function(inputs, path, value) {
  OUT <- copyCoverCaseInputs(inputs)
  if (length(path) == 2L) {
    OUT[[path[1L]]][[path[2L]]] <- value
  } else {
    stop("A two-level input path is required.", call. = FALSE)
  }
  OUT
}

auditPrehydratedCoverCase <- function(inputCases, context) {
  Functions <- c(
    "readCalculationJson",
    ".readCoverSectionReference",
    "buildAci31825ReinforcedSectionDomains",
    ".evaluateCoverReinforcementStudy"
  )
  FunctionEnvironment <- environment(evaluateCoverSample)
  stopifnot(all(vapply(
    Functions,
    exists,
    logical(1),
    envir = FunctionEnvironment,
    inherits = FALSE
  )))
  Originals <- mget(
    Functions,
    envir = FunctionEnvironment,
    inherits = FALSE
  )
  Calls <- stats::setNames(integer(length(Functions)), Functions)
  on.exit(
    list2env(Originals, envir = FunctionEnvironment),
    add = TRUE
  )
  for (s in Functions) {
    local({
      Name <- s
      Original <- Originals[[Name]]
      assign(
        Name,
        function(...) {
          Calls[[Name]] <<- Calls[[Name]] + 1L
          Original(...)
        },
        envir = FunctionEnvironment
      )
    })
  }
  Results <- lapply(
    inputCases,
    evaluateCoverSample,
    context = context
  )
  list(results = Results, calls = Calls)
}

Context <- prepareCoverCaseContext(
  inputs = Inputs,
  projectRoot = projectRoot,
  methodID = Manifest[["methodID", exact = TRUE]]
)
GroundInputs <- copyCoverCaseInputs(Inputs)
GroundInputs[["ground"]][["modulusKPa"]] <- 31000
Prehydrated <- auditPrehydratedCoverCase(
  inputCases = list(Inputs, GroundInputs),
  context = Context
)
stopifnot(
  all(Prehydrated[["calls", exact = TRUE]] == 0L),
  identical(
    Prehydrated[["results", exact = TRUE]][[1L]][Surfaces],
    Observed[Surfaces]
  ),
  !identical(
    Prehydrated[["results", exact = TRUE]][[2L]][Surfaces],
    Observed[Surfaces]
  )
)

Mutations <- list(
  list(path = c("cover", "coverCrownM"), value = 8.1),
  list(path = c("cover", "crownToAxisM"), value = 1.325),
  list(path = c("ground", "effectiveUnitWeightKnPerM3"), value = 19.1),
  list(path = c("ground", "effectiveSurchargeKPa"), value = 1),
  list(path = c("ground", "modulusKPa"), value = 31000),
  list(path = c("ground", "poisson"), value = 0.31),
  list(path = c("ground", "k0ModelID"), value = "jaky-nc"),
  list(path = c("ground", "frictionAngleDeg"), value = 31),
  list(path = c("ground", "ocr"), value = 1.1),
  list(path = c("ground", "waterPressureDifferenceKPa"), value = 1),
  list(path = c("steel", "centroidalRadiusM"), value = 1.325),
  list(path = c("steel", "remainingBaseThicknessMm"), value = 2.60),
  list(path = c("steel", "youngModulusKPa"), value = 201000000),
  list(path = c("steel", "poisson"), value = 0.31),
  list(path = c("steel", "yieldStrengthMPa"), value = 251),
  list(path = c("steel", "tensileStrengthMPa"), value = 401),
  list(path = c("seam", "fastenerDiameterMm"), value = 12.6),
  list(path = c("seam", "fastenerDiameterLossRatio"), value = 0.10),
  list(path = c("plainConcrete", "outerRadiusM"), value = 1.325),
  list(path = c("plainConcrete", "thicknessM"), value = 0.11),
  list(path = c("plainConcrete", "poisson"), value = 0.21),
  list(path = c("plainConcrete", "compressiveStrengthMPa"), value = 26),
  list(path = c("reinforcedConcrete", "outerRadiusM"), value = 1.325),
  list(path = c("reinforcedConcrete", "thicknessM"), value = 0.13),
  list(path = c("reinforcedConcrete", "poisson"), value = 0.21),
  list(path = c("reinforcedConcrete", "compressiveStrengthMPa"), value = 26),
  list(
    path = c("reinforcedConcrete", "barDiameterMm"),
    value = 8
  ),
  list(
    path = c("reinforcedConcrete", "barSpacingMm"),
    value = 140
  ),
  list(
    path = c("reinforcedConcrete", "clearCoverRatio"),
    value = 0.16
  ),
  list(
    path = c("reinforcedConcrete", "reinforcementModulusMPa"),
    value = 201000
  ),
  list(
    path = c("reinforcedConcrete", "reinforcementRatioGrid"),
    value = list(0.0018, 0.008, 0.016, 0.024)
  )
)
stopifnot(length(Mutations) == 31L)
for (i in seq_along(Mutations)) {
  AUX <- Mutations[[i]]
  Variant <- mutateCoverCaseInput(
    inputs = Inputs,
    path = AUX[["path", exact = TRUE]],
    value = AUX[["value", exact = TRUE]]
  )
  VariantConfig <- resolveCoverCaseConfig(
    inputs = Variant,
    projectRoot = projectRoot,
    methodID = Manifest[["methodID", exact = TRUE]]
  )[["config", exact = TRUE]]
  stopifnot(!identical(VariantConfig, ExpectedConfig))
}

for (v in list(
  c("steel", "sectionReferenceID"),
  c("seam", "resistanceReferenceID"),
  c("reinforcedConcrete", "reinforcementGradeID")
)) {
  Variant <- mutateCoverCaseInput(
    inputs = Inputs,
    path = v,
    value = "unsupported-reference"
  )
  SelectionMessage <- tryCatch(
    resolveCoverCaseConfig(
      inputs = Variant,
      projectRoot = projectRoot,
      methodID = Manifest[["methodID", exact = TRUE]]
    ),
    error = function(e) conditionMessage(e)
  )
  stopifnot(grepl("Unsupported", SelectionMessage, fixed = TRUE))
}

FastenerInputs <- mutateCoverCaseInput(
  inputs = Inputs,
  path = c("seam", "fastenerDiameterMm"),
  value = 11.7
)
FastenerResult <- evaluateCoverSample(
  inputs = FastenerInputs,
  context = Context
)
Calculation <- Observed[["aashto", exact = TRUE]][[
  "calculation",
  exact = TRUE
]]
CalculationFastener <- FastenerResult[["aashto", exact = TRUE]][[
  "calculation",
  exact = TRUE
]]
Unaffected <- setdiff(
  names(Calculation),
  c("fastenerDiameterMm", "remainingFastenerDiameterMm")
)
stopifnot(
  CalculationFastener[["fastenerDiameterMm", exact = TRUE]] == 11.7,
  CalculationFastener[["remainingFastenerDiameterMm", exact = TRUE]] == 11.7,
  identical(Calculation[Unaffected], CalculationFastener[Unaffected])
)

InvalidClearCover <- mutateCoverCaseInput(
  inputs = Inputs,
  path = c("reinforcedConcrete", "clearCoverRatio"),
  value = 0.49
)
InvalidClearCover[["reinforcedConcrete"]][["barDiameterMm"]] <- 10
ClearCoverMessage <- tryCatch(
  resolveCoverCaseConfig(
    inputs = InvalidClearCover,
    projectRoot = projectRoot,
    methodID = Manifest[["methodID", exact = TRUE]]
  ),
  error = function(e) conditionMessage(e)
)
stopifnot(grepl("outside the concrete section", ClearCoverMessage, fixed = TRUE))

InvalidSpacing <- mutateCoverCaseInput(
  inputs = Inputs,
  path = c("reinforcedConcrete", "barSpacingMm"),
  value = 6
)
SpacingMessage <- tryCatch(
  resolveCoverCaseConfig(
    inputs = InvalidSpacing,
    projectRoot = projectRoot,
    methodID = Manifest[["methodID", exact = TRUE]]
  ),
  error = function(e) conditionMessage(e)
)
stopifnot(grepl("must exceed", SpacingMessage, fixed = TRUE))

cat("PASS: cover-case-2 input boundary and full calculation parity.\n")
