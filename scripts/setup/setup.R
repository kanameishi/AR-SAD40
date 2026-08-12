if (!exists("projectRoot", inherits = FALSE)) {
  projectRoot <- normalizePath(".", mustWork = TRUE)
}
projectRoot <- normalizePath(projectRoot, mustWork = TRUE)

source(file.path(projectRoot, "scripts", "setup", "utils.R"))
source(file.path(projectRoot, "scripts", "R", "ringDirect.R"))
source(file.path(projectRoot, "scripts", "R", "ringLoads.R"))
source(file.path(projectRoot, "scripts", "R", "calculationData.R"))

CalculationRun <- buildCalculationData(
  configPath = file.path(projectRoot, "calculation.json"),
  outputDirectory = file.path(projectRoot, "data", "calculation"),
  projectRoot = projectRoot
)
