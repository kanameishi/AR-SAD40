# Verifies the source-specific reference cases reproduced in the memo.

Arguments <- commandArgs(trailingOnly = FALSE)
FileArgument <- grep("^--file=", Arguments, value = TRUE)
if (length(FileArgument) != 1L) {
  stop("Run with Rscript scripts/R/testReferenceCases.R.", call. = FALSE)
}
ScriptPath <- normalizePath(sub("^--file=", "", FileArgument))
ProjectRoot <- normalizePath(file.path(dirname(ScriptPath), "..", ".."))
source(file.path(ProjectRoot, "scripts", "R", "ringDirect.R"))
source(file.path(ProjectRoot, "scripts", "R", "ringLoads.R"))
source(file.path(ProjectRoot, "scripts", "R", "ringInteraction.R"))
source(file.path(ProjectRoot, "scripts", "R", "referenceCases.R"))
source(file.path(ProjectRoot, "scripts", "tbl", "Calculation.reference.cases.R"))

assertNear <- function(actual, expected, tolerance, label) {
  Error <- max(abs(actual - expected))
  if (!is.finite(Error) || Error > tolerance) {
    stop(label, " failed; maximum error = ", Error, ".", call. = FALSE)
  }
}
expectError <- function(expression, pattern, label) {
  Message <- tryCatch(
    {
      expression()
      NA_character_
    },
    error = function(e) conditionMessage(e)
  )
  if (is.na(Message) || !grepl(pattern, Message, fixed = TRUE)) {
    stop(label, " did not produce the expected error.", call. = FALSE)
  }
}
readProduct <- function(directory, fileName) {
  utils::read.csv(
    file.path(directory, fileName),
    check.names = FALSE,
    stringsAsFactors = FALSE,
    na.strings = ""
  )
}
readFixture <- function(fileName) {
  utils::read.csv(
    file.path(ProjectRoot, "data", "reference", fileName),
    check.names = FALSE,
    stringsAsFactors = FALSE,
    na.strings = ""
  )
}

TestDirectory <- tempfile("reference-case-test-")
dir.create(TestDirectory)
on.exit(unlink(TestDirectory, recursive = TRUE, force = TRUE), add = TRUE)
OutputDirectory <- file.path(TestDirectory, "products")
invisible(buildReferenceCaseData(
  referenceDirectory = file.path(ProjectRoot, "data", "reference"),
  outputDirectory = OutputDirectory
))
ExpectedFiles <- c(
  "fhwa.compaction.eq.5.1.csv",
  "nunez.2000.circular.csv",
  "schwartz.einstein.hp97.csv",
  "usace.d4.csv"
)
stopifnot(identical(sort(list.files(OutputDirectory)), ExpectedFiles))

USACE <- readProduct(OutputDirectory, "usace.d4.csv")
assertNear(
  USACE$calculatedValue,
  c(3600, 5400, 10530, 11583),
  1e-9,
  "USACE D4"
)
stopifnot(sum(is.na(USACE$publishedValue)) == 1L)

FHWA <- readProduct(OutputDirectory, "fhwa.compaction.eq.5.1.csv")
stopifnot(
  sum(FHWA$comparisonStatus == "rounded-match") == 8L,
  sum(FHWA$comparisonStatus ==
    "published-input-mismatch-alternative-match") == 1L
)
Discrepancy <- FHWA[FHWA$caseID == "fhwa-09", , drop = FALSE]
assertNear(
  Discrepancy$calculatedPublishedInputKPa,
  0.416141529390081,
  1e-14,
  "FHWA printed-input case"
)
assertNear(
  Discrepancy$calculatedAlternativeKPa,
  0.195202615182827,
  1e-14,
  "FHWA alternative-input case"
)

Nunez <- readProduct(OutputDirectory, "nunez.2000.circular.csv")
stopifnot(nrow(Nunez) == 10L, sum(!is.na(Nunez$publishedValue)) == 9L)
stopifnot(
  all(Nunez$evidenceClass[Nunez$quantityID == "interaction-ratio"] ==
    "published-datum"),
  all(Nunez$evidenceClass[
    Nunez$quantityID %in% c(
      "interaction-fraction", "maximum-moment", "normal-crown"
    )
  ] == "published-result-reproduced"),
  Nunez$evidenceClass[
    Nunez$quantityID == "normal-side" & Nunez$liningID == "primary"
  ] == "study-derived-result"
)
assertNear(
  max(abs(Nunez$relativeDifferencePercent), na.rm = TRUE),
  1.30819075996409,
  1e-12,
  "Nunez maximum relative difference"
)

SchwartzEinstein <- readProduct(
  OutputDirectory,
  "schwartz.einstein.hp97.csv"
)
assertNear(
  SchwartzEinstein$calculatedThrustRatio,
  c(0.735909301696487, 0.811805900676952, 0.887060744050176, 1.01716919944526),
  1e-14,
  "Schwartz-Einstein thrust ratios"
)
assertNear(
  SchwartzEinstein$calculatedMomentRatio,
  c(0.00774336283185842, 0.0070657146266757, 0.0132743362831858, 0.0121126536457298),
  1e-14,
  "Schwartz-Einstein moment ratios"
)
stopifnot(!any(grepl("cande|shear", names(SchwartzEinstein), ignore.case = TRUE)))

USACEFixture <- readFixture("usace.d4.csv")
USACEChanged <- USACEFixture
USACEChanged$coverCrownFt <- 31
stopifnot(!identical(
  .calculateUSACED4Reference(USACEFixture)$calculatedValue,
  .calculateUSACED4Reference(USACEChanged)$calculatedValue
))
FHWAFixture <- readFixture("fhwa.compaction.eq.5.1.csv")
FHWAChanged <- FHWAFixture
FHWAChanged$compactorForceKn[1L] <- 21
stopifnot(!identical(
  .calculateFHWACompactionReference(FHWAFixture)$calculatedPublishedInputKPa,
  .calculateFHWACompactionReference(FHWAChanged)$calculatedPublishedInputKPa
))
expectError(function() {
  .calculateUSACED4Reference(USACEFixture[-1L])
}, "is missing", "USACE fixture schema")

TableText <- c(
  buildCalculationUSACEReferenceTable(
    file.path(OutputDirectory, "usace.d4.csv")
  ),
  buildCalculationFHWAReferenceTable(
    file.path(OutputDirectory, "fhwa.compaction.eq.5.1.csv")
  ),
  buildCalculationNunezReferenceTable(
    file.path(OutputDirectory, "nunez.2000.circular.csv")
  ),
  buildCalculationSchwartzEinsteinReferenceTable(
    file.path(OutputDirectory, "schwartz.einstein.hp97.csv")
  )
)
stopifnot(length(TableText) > 0L)

cat("PASS: source-specific reference cases and public tables.\n")
