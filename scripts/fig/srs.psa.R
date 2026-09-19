# nolint start
# SRS PSA figure context: run selection, PSW/target tables, target-band
# legend from runMatch.json.
if (!exists("PathSRS", inherits = FALSE)) {
  if (exists("SRS.target", inherits = FALSE)) {
    PathSRS <- file.path(root, "gmsp", "match", SRS.target)
  } else {
    SRS_ROOT <- file.path(root, "gmsp", "match")
    if (!dir.exists(SRS_ROOT)) {
      stop("SRS plot requires gmsp/match or PathSRS.", call. = FALSE)
    }
    SRS_RUNS <- list.dirs(SRS_ROOT, full.names = TRUE, recursive = FALSE)
    if (length(SRS_RUNS) != 1L) {
      stop("SRS plot: set SRS.target or PathSRS before including _fig/srs.psa.qmd.", call. = FALSE)
    }
    PathSRS <- SRS_RUNS[[1L]]
    SRS.target <- basename(PathSRS)
  }
}
if (!exists("SRS_UNITS", inherits = FALSE)) SRS_UNITS <- "mm"

PSW_FILE <- file.path(PathSRS, "data", "PSW.csv")
if (!file.exists(PSW_FILE)) {
  stop(sprintf("SRS plot input not found: %s", PSW_FILE), call. = FALSE)
}
PSWTable <- data.table::fread(PSW_FILE)

TARGET_FILE <- file.path(PathSRS, "match", "target.csv")
if (exists("TargetTable", inherits = FALSE)) rm(TargetTable)
if (file.exists(TARGET_FILE)) {
  TargetTable <- data.table::fread(TARGET_FILE)
}

TARGET_META_FILE <- file.path(PathSRS, "metadata", "runMatch.json")
SRS_TARGET_FILL_LEGEND <- "min–max"
if (file.exists(TARGET_META_FILE)) {
  SRS_TARGET_CONFIG <- jsonlite::read_json(TARGET_META_FILE, simplifyVector = TRUE)
  SRS_TARGET_LOWER <- SRS_TARGET_CONFIG$target$envelope$lower
  SRS_TARGET_UPPER <- SRS_TARGET_CONFIG$target$envelope$upper
  .srsFormatProbability <- function(x) {
    VALUE <- suppressWarnings(as.numeric(sub("^[pP]", "", as.character(x))))
    if (!length(VALUE) || !is.finite(VALUE[[1L]])) return(NA_character_)
    VALUE <- VALUE[[1L]]
    if (VALUE <= 1) VALUE <- 100 * VALUE
    format(VALUE, trim = TRUE, scientific = FALSE, nsmall = 0)
  }
  SRS_TARGET_LOWER_LABEL <- .srsFormatProbability(SRS_TARGET_LOWER)
  SRS_TARGET_UPPER_LABEL <- .srsFormatProbability(SRS_TARGET_UPPER)
  if (!is.na(SRS_TARGET_LOWER_LABEL) && !is.na(SRS_TARGET_UPPER_LABEL)) {
    SRS_TARGET_FILL_LEGEND <- sprintf(
      "p%s–p%s",
      SRS_TARGET_LOWER_LABEL,
      SRS_TARGET_UPPER_LABEL
    )
  }
}

ID <- "PSA"
DIR <- "H1"

# nolint end
