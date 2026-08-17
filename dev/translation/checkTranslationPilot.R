readText <- function(path) {
  paste(readLines(path, warn = FALSE, encoding = "UTF-8"), collapse = "\n")
}

extractOrderedMatches <- function(text, pattern) {
  Locations <- gregexpr(pattern, text, perl = TRUE)[[1L]]
  if (identical(Locations[[1L]], -1L)) {
    return(character())
  }

  Length <- attr(Locations, "match.length")
  substring(text, Locations, Locations + Length - 1L)
}

normaliseMath <- function(blocks) {
  gsub("[[:space:]]+", "", blocks, perl = TRUE)
}

assertIdentical <- function(actual, expected, label) {
  if (!identical(actual, expected)) {
    stop(sprintf("Translation pilot parity failed: %s differ.", label), call. = FALSE)
  }
}

ProjectRoot <- normalizePath(".", winslash = "/", mustWork = TRUE)
SpanishPath <- file.path(ProjectRoot, "dev", "translation", "pilot", "calculation.pilot.review.es.md")
EnglishPath <- file.path(ProjectRoot, "dev", "translation", "pilot", "calculation.pilot.review.en.md")
LedgerPath <- file.path(ProjectRoot, "dev", "translation", "terminology.ledger.csv")

Spanish <- readText(SpanishPath)
English <- readText(EnglishPath)
Ledger <- read.csv(LedgerPath, stringsAsFactors = FALSE, check.names = FALSE,
                   fileEncoding = "UTF-8")

RequiredColumns <- c(
  "conceptID", "domainID", "englishTerm", "spanishTerm", "definition",
  "context", "sourceKey", "sourceLocator", "evidenceLevel", "status",
  "rejectedTerms", "rejectionReason"
)
assertIdentical(names(Ledger), RequiredColumns, "ledger columns")

if (anyDuplicated(Ledger$conceptID)) {
  stop("Translation pilot parity failed: conceptID is not unique.", call. = FALSE)
}

AllowedStatus <- c("approved", "provisional", "unknown", "rejected")
if (any(!Ledger$status %in% AllowedStatus)) {
  stop("Translation pilot parity failed: unsupported ledger status.", call. = FALSE)
}

IDPattern <- "\\{#(?:sec|eq|tbl)-[A-Za-z0-9._-]+\\}"
CitationPattern <- "\\[@[^]]+\\]"
MathPattern <- "(?s)\\$\\$.*?\\$\\$"
InlineMathPattern <- "(?<!\\$)\\$(?!\\$)(?:\\\\.|[^$])*?\\$(?!\\$)"
NumberPattern <- "(?<![A-Za-z])(?:[0-9]+(?:\\.[0-9]+)?)(?![A-Za-z])"
CrossReferencePattern <- "(?:@(?:tbl|fig|sec|eq)-[A-Za-z0-9._-]+|(?<=\\]\\(#)(?:sec|eq|tbl)-[A-Za-z0-9._-]+(?=\\)))"

assertIdentical(
  extractOrderedMatches(Spanish, IDPattern),
  extractOrderedMatches(English, IDPattern),
  "section, equation, and table identifiers"
)
assertIdentical(
  extractOrderedMatches(Spanish, CitationPattern),
  extractOrderedMatches(English, CitationPattern),
  "citation order"
)
assertIdentical(
  normaliseMath(extractOrderedMatches(Spanish, MathPattern)),
  normaliseMath(extractOrderedMatches(English, MathPattern)),
  "display mathematics"
)
assertIdentical(
  normaliseMath(extractOrderedMatches(Spanish, InlineMathPattern)),
  normaliseMath(extractOrderedMatches(English, InlineMathPattern)),
  "inline mathematics"
)
assertIdentical(
  extractOrderedMatches(Spanish, CrossReferencePattern),
  extractOrderedMatches(English, CrossReferencePattern),
  "cross-reference targets"
)
assertIdentical(
  extractOrderedMatches(Spanish, NumberPattern),
  extractOrderedMatches(English, NumberPattern),
  "numeric tokens"
)

SpanishUnits <- extractOrderedMatches(
  gsub("adimensional", "dimensionless", Spanish, fixed = TRUE),
  "(?:kN·m/m|kN/m³|kN/m|MPa|kPa|dimensionless|(?<=\\| )m(?= \\|))"
)
EnglishUnits <- extractOrderedMatches(
  English,
  "(?:kN·m/m|kN/m³|kN/m|MPa|kPa|dimensionless|(?<=\\| )m(?= \\|))"
)
assertIdentical(SpanishUnits, EnglishUnits, "units")

SpanishHeadings <- grep("^#{1,3} ", strsplit(Spanish, "\n", fixed = TRUE)[[1L]], value = TRUE)
EnglishHeadings <- grep("^#{1,3} ", strsplit(English, "\n", fixed = TRUE)[[1L]], value = TRUE)
if (any(!grepl("\\{#sec-[A-Za-z0-9._-]+\\}$", SpanishHeadings)) ||
    any(!grepl("\\{#sec-[A-Za-z0-9._-]+\\}$", EnglishHeadings))) {
  stop("Translation pilot parity failed: every heading must have an explicit shared section ID.",
       call. = FALSE)
}

assertIdentical(
  length(grep("^\\|", strsplit(Spanish, "\n", fixed = TRUE)[[1L]])),
  length(grep("^\\|", strsplit(English, "\n", fixed = TRUE)[[1L]])),
  "table-row count"
)

CitationKeys <- unique(sub(
  "^@", "", extractOrderedMatches(paste(extractOrderedMatches(Spanish, CitationPattern), collapse = " "), "@[A-Za-z0-9:_-]+")
))
Bibliography <- readText(file.path(ProjectRoot, "bib", "references.bib"))
BibliographyKeys <- sub(
  "^@[A-Za-z]+\\{([^,]+),$", "\\1",
  grep("^@[A-Za-z]+\\{[^,]+,$", strsplit(Bibliography, "\n", fixed = TRUE)[[1L]], value = TRUE)
)
MissingCitations <- setdiff(CitationKeys, BibliographyKeys)
if (length(MissingCitations)) {
  stop(
    sprintf(
      "Translation pilot parity failed: unresolved citation keys: %s.",
      paste(MissingCitations, collapse = ", ")
    ),
    call. = FALSE
  )
}

Rejected <- trimws(unlist(strsplit(Ledger$rejectedTerms, ";", fixed = TRUE)))
Rejected <- unique(Rejected[nzchar(Rejected)])
FoundRejected <- Rejected[vapply(
  Rejected,
  function(x) grepl(tolower(x), tolower(Spanish), fixed = TRUE),
  logical(1L)
)]
if (length(FoundRejected)) {
  stop(
    sprintf(
      "Translation pilot parity failed: rejected Spanish terms found: %s.",
      paste(FoundRejected, collapse = ", ")
    ),
    call. = FALSE
  )
}

InternalLanguage <- c(
  "solver", "builder", "pipeline", "canónico", "no-FEM", "metadata",
  "JSON", "API", "fixture", "guardrail"
)
FoundInternal <- InternalLanguage[vapply(
  InternalLanguage,
  function(x) grepl(tolower(x), tolower(Spanish), fixed = TRUE),
  logical(1L)
)]
if (length(FoundInternal)) {
  stop(
    sprintf(
      "Translation pilot parity failed: internal language found: %s.",
      paste(FoundInternal, collapse = ", ")
    ),
    call. = FALSE
  )
}

message(sprintf(
  "PASS: translation pilot parity (%d concepts; %d identifiers; %d equations).",
  nrow(Ledger),
  length(extractOrderedMatches(Spanish, IDPattern)),
  length(extractOrderedMatches(Spanish, MathPattern))
))
