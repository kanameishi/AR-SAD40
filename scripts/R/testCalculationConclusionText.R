# Verifies that public conclusion text follows calculated assessment states.

Arguments <- commandArgs(trailingOnly = FALSE)
ArgumentFile <- grep("^--file=", Arguments, value = TRUE)
if (length(ArgumentFile) != 1L) {
  stop(
    "Run with Rscript scripts/R/testCalculationConclusionText.R.",
    call. = FALSE
  )
}

ScriptPath <- normalizePath(sub("^--file=", "", ArgumentFile))
Root <- normalizePath(file.path(dirname(ScriptPath), "..", ".."))
projectRoot <- Root

source(file.path(projectRoot, "scripts", "setup", "calculationFunctions.R"))
source(file.path(
  projectRoot,
  "scripts",
  "setup",
  "coverCalculationResults.R"
))

ChecksAll <- data.frame(
  checkStatus = rep("satisfied", 2L),
  stringsAsFactors = FALSE
)
ChecksNone <- data.frame(
  checkStatus = rep("not-satisfied", 2L),
  stringsAsFactors = FALSE
)
ChecksSome <- data.frame(
  checkStatus = c("satisfied", "not-satisfied", "not-evaluated"),
  stringsAsFactors = FALSE
)
ChecksUnknown <- data.frame(
  checkStatus = rep("not-evaluated", 2L),
  stringsAsFactors = FALSE
)
ConcreteAll <- data.frame(
  shotcreteLocalStrengthStatus = rep("satisfied", 2L),
  minimumReinforcementStatus = rep("satisfied", 2L),
  stringsAsFactors = FALSE
)
ConcreteNone <- data.frame(
  shotcreteLocalStrengthStatus = rep("not-satisfied", 2L),
  minimumReinforcementStatus = rep("not-satisfied", 2L),
  stringsAsFactors = FALSE
)
ConcreteSome <- data.frame(
  shotcreteLocalStrengthStatus = c("satisfied", "not-satisfied"),
  minimumReinforcementStatus = rep("satisfied", 2L),
  stringsAsFactors = FALSE
)

stopifnot(
  identical(
    buildAashtoStatusSummary(ChecksAll),
    "Los 2 controles numéricos evaluados satisfacen sus límites."
  ),
  grepl(
    "^Ninguno de los 2 controles numéricos evaluados",
    buildAashtoStatusSummary(ChecksNone)
  ),
  grepl("^Algunos controles", buildAashtoStatusSummary(ChecksSome)),
  grepl(
    "^Ninguno de los 2 controles numéricos pudo evaluarse",
    buildAashtoStatusSummary(ChecksUnknown)
  ),
  grepl(
    "en las 2 condiciones de interfaz",
    buildConcreteLocalStatusSummary(ConcreteAll, "plain-concrete"),
    fixed = TRUE
  ),
  grepl(
    "en ninguna de las 2 condiciones de interfaz",
    buildConcreteLocalStatusSummary(ConcreteNone, "plain-concrete"),
    fixed = TRUE
  ),
  grepl(
    "en 1 de las 2 condiciones de interfaz",
    buildConcreteLocalStatusSummary(ConcreteSome, "reinforced-concrete"),
    fixed = TRUE
  ),
  grepl(
    "satisface la cuantía mínima",
    buildMinimumReinforcementStatusSummary(ConcreteAll),
    fixed = TRUE
  ),
  grepl(
    "no satisface la cuantía mínima",
    buildMinimumReinforcementStatusSummary(ConcreteNone),
    fixed = TRUE
  )
)

SteelChapterPath <- file.path(
  projectRoot,
  "TITO",
  "kb",
  "calculation-memo",
  "chapters",
  "calculation.steel.review.es.qmd"
)
SteelChapterSource <- paste(
  readLines(SteelChapterPath, warn = FALSE),
  collapse = "\n"
)
ResultLoaderPath <- file.path(
  projectRoot,
  "scripts",
  "setup",
  "coverCalculationResults.R"
)
ResultLoaderSource <- paste(
  readLines(ResultLoaderPath, warn = FALSE),
  collapse = "\n"
)
RejectedStatements <- c(
  "es compresiva en toda la sección transversal",
  "en ambos casos gobierna la tracción"
)
stopifnot(
  !any(vapply(
    RejectedStatements,
    grepl,
    logical(1),
    x = paste(SteelChapterSource, ResultLoaderSource),
    fixed = TRUE
  )),
  grepl(
    "buildAashtoStatusSummary(AashtoChecks)",
    ResultLoaderSource,
    fixed = TRUE
  ),
  grepl(
    "LocalStatusSummaryMarkdown",
    ResultLoaderSource,
    fixed = TRUE
  ),
  !grepl("resistencia local; gobierna", ResultLoaderSource, fixed = TRUE)
)

cat("PASS: calculation conclusion text follows calculated states.\n")
