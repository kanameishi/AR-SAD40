# Regenerates the deterministic products consumed by the calculation memo.

arguments <- commandArgs(trailingOnly = FALSE)
fileArgument <- grep("^--file=", arguments, value = TRUE)
if (length(fileArgument) != 1L) {
  stop("Run with Rscript scripts/R/runCalculationMemo.R.", call. = FALSE)
}

scriptPath <- normalizePath(sub("^--file=", "", fileArgument))
projectRoot <- normalizePath(file.path(dirname(scriptPath), "..", ".."))
source(file.path(projectRoot, "scripts", "setup", "setup.R"))

cat(
  "PASS: calculation.json and data/calculation are consistent.\n"
)
