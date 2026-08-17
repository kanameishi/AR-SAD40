# Verifies the project boundary for the scalar USACE thrust relation.

Arguments <- commandArgs(trailingOnly = FALSE)
FileArgument <- grep("^--file=", Arguments, value = TRUE)
if (length(FileArgument) != 1L) {
  stop("Run with Rscript scripts/R/testPrismThrust.R.", call. = FALSE)
}

ScriptPath <- normalizePath(sub("^--file=", "", FileArgument))
ProjectRoot <- normalizePath(file.path(dirname(ScriptPath), "..", ".."))
projectRoot <- ProjectRoot
source(
  file.path(ProjectRoot, "scripts", "setup", "calculationFunctions.R"),
  local = TRUE
)

Result <- calculatePrismThrust(
  unitWeightKnPerM3 = 20,
  coverCrownM = 5,
  spanM = 2.63,
  deadLoadFactor = 1,
  demandModifier = 1,
  factorBasis = "synthetic service control",
  combinationID = "synthetic-control",
  stageID = "completed-fill",
  forceEffectStatus = "unfactored-reference-state"
)
Values <- Result[["values", exact = TRUE]]

stopifnot(
  identical(
    Values$quantityID,
    c(
      "dead-crown-pressure", "dead-service-thrust", "live-service-thrust",
      "factored-thrust", "modified-demand"
    )
  ),
  identical(Values$value, c(100, 131.5, 0, 131.5, 131.5)),
  identical(Values$unit, c("kPa", rep("kN/m", 4L))),
  all(Values$factorBasis == "synthetic service control"),
  all(Values$liveDistributionFactor == 0),
  identical(
    Values$forceEffectBasis,
    c(
      "unfactored-input", "unfactored-service", "unfactored-service",
      "factored-demand", "modified-factored-demand"
    )
  ),
  all(Values$angularDistributionStatus ==
    "not-defined-by-source-relation"),
  all(Values$combinationID == "synthetic-control"),
  all(Values$stageID == "completed-fill"),
  all(Values$forceEffectStatus == "unfactored-reference-state")
)

Result.factored <- calculatePrismThrust(
  unitWeightKnPerM3 = 20,
  coverCrownM = 5,
  spanM = 2.63,
  deadLoadFactor = 1.25,
  demandModifier = 1.1,
  factorBasis = "synthetic factored control",
  combinationID = "synthetic-factored-control",
  stageID = "completed-fill",
  forceEffectStatus = "factored-control",
  liveCrownPressureKPa = 10,
  liveLoadedWidthM = 2,
  liveLoadFactor = 1.5
)
Values.factored <- Result.factored[["values", exact = TRUE]]
stopifnot(
  max(abs(Values.factored$value - c(
    100, 131.5, 10, 179.375, 197.3125
  ))) < 1e-12,
  all(Values.factored$factorBasis == "synthetic factored control"),
  all(Values.factored$liveDistributionFactor == 1),
  identical(
    Values.factored$forceEffectBasis,
    c(
      "unfactored-input", "unfactored-service", "unfactored-service",
      "factored-demand", "modified-factored-demand"
    )
  ),
  all(Values.factored$combinationID == "synthetic-factored-control"),
  all(Values.factored$forceEffectStatus == "factored-control")
)

Width.invalid <- tryCatch(
  calculatePrismThrust(
    unitWeightKnPerM3 = 20,
    coverCrownM = 5,
    spanM = 2.63,
    deadLoadFactor = 1.25,
    demandModifier = 1.1,
    factorBasis = "synthetic invalid control",
    combinationID = "synthetic-invalid-control",
    stageID = "completed-fill",
    forceEffectStatus = "factored-control",
    liveCrownPressureKPa = 10,
    liveLoadedWidthM = 3,
    liveLoadFactor = 1.5
  ),
  error = function(e) conditionMessage(e)
)
stopifnot(identical(
  Width.invalid,
  "liveLoadedWidthM must not exceed spanM."
))

Result.geometric <- calculatePrismThrust(
  unitWeightKnPerM3 = 20,
  coverCrownM = 5,
  spanM = 2.63,
  deadLoadFactor = 1,
  demandModifier = 1,
  factorBasis = "synthetic geometric-factor control",
  combinationID = "synthetic-geometric-factor-control",
  stageID = "completed-fill",
  forceEffectStatus = "factored-control",
  liveCrownPressureKPa = 10,
  liveLoadedWidthM = 1,
  liveLoadFactor = 1
)
Values.geometric <- Result.geometric[["values", exact = TRUE]]
stopifnot(all(
  Values.geometric$liveDistributionFactor == 0.75 * 2.63
))

Result.minimum <- calculatePrismThrust(
  unitWeightKnPerM3 = 20,
  coverCrownM = 5,
  spanM = 0.20,
  deadLoadFactor = 1,
  demandModifier = 1,
  factorBasis = "synthetic minimum-factor control",
  combinationID = "synthetic-minimum-factor-control",
  stageID = "completed-fill",
  forceEffectStatus = "factored-control",
  liveCrownPressureKPa = 10,
  liveLoadedWidthM = 0.20,
  liveLoadFactor = 1
)
Values.minimum <- Result.minimum[["values", exact = TRUE]]
stopifnot(all(
  Values.minimum$liveDistributionFactor == 0.381 / 0.20
))

cat("PASS: scalar prism-thrust adapter.\n")
