# Release regression for the causal effect of every numerical case input.

Arguments <- commandArgs(trailingOnly = FALSE)
FileArgument <- grep("^--file=", Arguments, value = TRUE)
if (length(FileArgument) != 1L) {
  stop("Run with Rscript scripts/R/testCoverCaseCausality.R.", call. = FALSE)
}
ScriptPath <- normalizePath(sub("^--file=", "", FileArgument))
projectRoot <- normalizePath(file.path(dirname(ScriptPath), "..", ".."))
source(
  file.path(projectRoot, "scripts", "setup", "calculationFunctions.R"),
  local = TRUE
)

copyCoverCaseInputs <- function(inputs) {
  unserialize(serialize(inputs, NULL))
}

mutateCoverCaseInput <- function(inputs, path, value) {
  OUT <- copyCoverCaseInputs(inputs)
  OUT[[path[1L]]][[path[2L]]] <- value
  OUT
}

Manifest <- readCalculationJson(file.path(projectRoot, "calculation.json"))
Inputs <- Manifest[["inputs", exact = TRUE]]
MethodID <- Manifest[["methodID", exact = TRUE]]
Context <- prepareCoverCaseContext(
  inputs = Inputs,
  projectRoot = projectRoot,
  methodID = MethodID
)
Baseline <- evaluateCoverSample(inputs = Inputs, context = Context)
Surfaces <- c(
  "stress", "section", "interaction", "resultants", "extrema", "controls",
  "aashto", "additionalLinings"
)
Mutations <- list(
  list(path = c("cover", "coverCrownM"), value = 8.1),
  list(path = c("cover", "crownToAxisM"), value = 1.325),
  list(path = c("ground", "effectiveUnitWeightKnPerM3"), value = 19.1),
  list(path = c("ground", "upperLayerHeightM"), value = 5.8),
  list(path = c("ground", "upperLayerUnitWeightKnPerM3"), value = 14.8),
  list(path = c("ground", "modulusKPa"), value = 31000),
  list(path = c("ground", "poisson"), value = 0.31),
  list(path = c("ground", "frictionAngleDeg"), value = 31),
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
    path = c("reinforcedConcrete", "clearCoverMm"),
    value = 16
  ),
  list(
    path = c("reinforcedConcrete", "reinforcementModulusMPa"),
    value = 201000
  )
)

stopifnot(length(Mutations) == 28L)
for (i in seq_along(Mutations)) {
  AUX <- Mutations[[i]]
  Variant <- mutateCoverCaseInput(
    inputs = Inputs,
    path = AUX[["path", exact = TRUE]],
    value = AUX[["value", exact = TRUE]]
  )
  Observed <- evaluateCoverSample(
    inputs = Variant,
    context = Context
  )
  Changed <- vapply(
    Surfaces,
    function(s) !identical(Observed[[s]], Baseline[[s]]),
    logical(1)
  )
  if (!any(Changed)) {
    stop(
      "No calculation output changed for: ",
      paste(AUX[["path", exact = TRUE]], collapse = "."),
      ".",
      call. = FALSE
    )
  }
}

cat("PASS: all 28 numerical or conditional inputs change an output.\n")
