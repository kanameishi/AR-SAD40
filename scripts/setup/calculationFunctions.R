if (!exists("projectRoot", inherits = FALSE)) {
  stop("projectRoot must be defined before loading calculation functions.", call. = FALSE)
}
projectRoot <- normalizePath(projectRoot, mustWork = TRUE)

source(file.path(projectRoot, "scripts", "setup", "utils.R"))
source(file.path(projectRoot, "scripts", "R", "ringDirect.R"))
source(file.path(projectRoot, "scripts", "R", "ringLoads.R"))
source(file.path(projectRoot, "scripts", "R", "k0Models.R"))
source(file.path(projectRoot, "scripts", "R", "stressState.R"))
source(file.path(projectRoot, "scripts", "R", "corrugatedSection.R"))
source(file.path(projectRoot, "scripts", "R", "perimeterActions.R"))
source(file.path(projectRoot, "scripts", "R", "sectionResultants.R"))
source(file.path(projectRoot, "scripts", "R", "sheetStress.R"))
source(file.path(projectRoot, "scripts", "R", "calculateScenario.R"))
source(file.path(projectRoot, "scripts", "R", "calculationData.R"))
