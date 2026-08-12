# Regenerates the deterministic products consumed by the calculation memo.

Arguments <- commandArgs(trailingOnly = FALSE)
FileArgument <- grep("^--file=", Arguments, value = TRUE)
if (length(FileArgument) != 1L) {
  stop("Run with Rscript scripts/R/runCalculationMemo.R.", call. = FALSE)
}

ScriptPath <- normalizePath(sub("^--file=", "", FileArgument))
projectRoot <- normalizePath(file.path(dirname(ScriptPath), "..", ".."))
source(
  file.path(projectRoot, "scripts", "setup", "calculationFunctions.R"),
  local = TRUE
)
invisible(buildCalculationData(
  configPath = file.path(projectRoot, "calculation.json"),
  outputDirectory = file.path(projectRoot, "data", "calculation"),
  projectRoot = projectRoot
))

cat(
  "PASS: calculation.json and data/calculation are consistent.\n"
)
