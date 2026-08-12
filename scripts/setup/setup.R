if (!exists("projectRoot", inherits = FALSE)) {
  projectRoot <- normalizePath(".", mustWork = TRUE)
}
projectRoot <- normalizePath(projectRoot, mustWork = TRUE)

source(
  file.path(projectRoot, "scripts", "setup", "calculationFunctions.R"),
  local = TRUE
)

CalculationRun <- buildCalculationData(
  configPath = file.path(projectRoot, "calculation.json"),
  outputDirectory = file.path(projectRoot, "data", "calculation"),
  projectRoot = projectRoot
)
