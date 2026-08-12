# Verifies pure function loading and the historical setup compatibility effect.

Arguments <- commandArgs(trailingOnly = FALSE)
Argument.file <- grep("^--file=", Arguments, value = TRUE)
if (length(Argument.file) != 1L) {
  stop("Run with Rscript scripts/R/testCalculationLoading.R.", call. = FALSE)
}

Path.script <- normalizePath(sub("^--file=", "", Argument.file))
Root <- normalizePath(file.path(dirname(Path.script), "..", ".."))
Directory.products <- file.path(Root, "data", "calculation")

snapshotProducts <- function(path) {
  FILES <- sort(list.files(path, full.names = TRUE))
  OUT <- tools::md5sum(FILES)
  names(OUT) <- basename(names(OUT))
  OUT
}

Products.expected <- snapshotProducts(Directory.products)
Seed.exists <- exists(".Random.seed", envir = .GlobalEnv, inherits = FALSE)
if (Seed.exists) {
  Seed.expected <- get(".Random.seed", envir = .GlobalEnv, inherits = FALSE)
}

projectRoot <- Root
source(file.path(projectRoot, "scripts", "setup", "calculationFunctions.R"))

stopifnot(
  exists("calculateScenario", mode = "function", inherits = FALSE),
  exists("calculateSheetNormalStress", mode = "function", inherits = FALSE),
  exists("buildCalculationData", mode = "function", inherits = FALSE),
  !exists("CalculationRun", inherits = FALSE),
  !exists("Calculation", inherits = FALSE),
  identical(snapshotProducts(Directory.products), Products.expected),
  identical(
    exists(".Random.seed", envir = .GlobalEnv, inherits = FALSE),
    Seed.exists
  )
)
if (Seed.exists) {
  stopifnot(identical(
    get(".Random.seed", envir = .GlobalEnv, inherits = FALSE),
    Seed.expected
  ))
}

source(file.path(projectRoot, "scripts", "setup", "setup.R"))

stopifnot(
  exists("CalculationRun", inherits = FALSE),
  identical(
    names(CalculationRun),
    c("config", "products", "outputDirectory")
  ),
  identical(snapshotProducts(Directory.products), Products.expected),
  identical(
    exists(".Random.seed", envir = .GlobalEnv, inherits = FALSE),
    Seed.exists
  )
)
if (Seed.exists) {
  stopifnot(identical(
    get(".Random.seed", envir = .GlobalEnv, inherits = FALSE),
    Seed.expected
  ))
}

Environment.setup <- new.env(parent = globalenv())
Environment.setup$projectRoot <- Root
source(
  file.path(Root, "scripts", "setup", "setup.R"),
  local = Environment.setup
)

stopifnot(
  exists("CalculationRun", envir = Environment.setup, inherits = FALSE),
  identical(Environment.setup$CalculationRun, CalculationRun),
  identical(snapshotProducts(Directory.products), Products.expected)
)

cat("PASS: calculation loading is inert and legacy setup remains compatible.\n")
