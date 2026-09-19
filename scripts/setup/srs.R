# nolint start
if (!requireNamespace("jsonlite", quietly = TRUE)) {
  stop("srs summary: package jsonlite is required.", call. = FALSE)
}

if (!exists("PathSRS", inherits = FALSE)) {
  if (exists("SRS.target", inherits = FALSE)) {
    PathSRS <- file.path(root, "gmsp", "match", SRS.target)
  } else {
    SRS_ROOT <- file.path(root, "gmsp", "match")
    SRS_RUNS <- list.dirs(SRS_ROOT, full.names = TRUE, recursive = FALSE)
    if (length(SRS_RUNS) != 1L) {
      stop("srs summary: set SRS.target or PathSRS before sourcing scripts/setup/srs.R.", call. = FALSE)
    }
    PathSRS <- SRS_RUNS[[1L]]
    SRS.target <- basename(PathSRS)
    rm(SRS_ROOT, SRS_RUNS)
  }
} else if (!exists("SRS.target", inherits = FALSE)) {
  SRS.target <- basename(normalizePath(PathSRS, mustWork = FALSE))
}
if (!exists("SRS.PGA.units", inherits = FALSE)) SRS.PGA.units <- "g"
if (!exists("SRS.range.word", inherits = FALSE)) SRS.range.word <- "to"

.srsFile <- function(...) {
  FILE <- file.path(PathSRS, ...)
  if (!file.exists(FILE)) stop(sprintf("srs summary: missing %s.", FILE), call. = FALSE)
  FILE
}

.srsRead <- function(file, cols) {
  Head <- names(data.table::fread(file, nrows = 0L))
  Missing <- setdiff(cols, Head)
  if (length(Missing)) {
    stop(sprintf("srs summary: %s missing columns: %s.", basename(file), paste(Missing, collapse = ", ")),
         call. = FALSE)
  }
  data.table::fread(file, select = cols)
}

.srsRange <- function(x, digits = 0, unit = NULL) {
  x <- as.numeric(x)
  x <- x[is.finite(x)]
  if (!length(x)) return("not available")
  OUT <- paste(.formatNumber(range(x, na.rm = TRUE), digits), collapse = paste0(" ", SRS.range.word, " "))
  if (!is.null(unit) && nzchar(unit)) OUT <- paste(OUT, unit)
  OUT
}

.srsNumber <- function(x, digits = 0, unit = NULL) {
  x <- as.numeric(x)
  if (!length(x) || !is.finite(x[1L])) return("not available")
  OUT <- if (digits == 0) .fmti(round(x[1L])) else .fmt(x[1L], digits)
  if (!is.null(unit) && nzchar(unit)) OUT <- paste(OUT, unit)
  OUT
}

.srsPercent <- function(x, digits = 0) {
  x <- as.numeric(x)
  if (!length(x) || !is.finite(x[1L])) return("not available")
  paste0(.formatNumber(100 * x[1L], digits), "%")
}

.srsAccel <- function(x) {
  if (SRS.PGA.units == "g") return(as.numeric(x) / SrsG)
  as.numeric(x)
}

.srsGet <- function(x, name, default = NA_character_) {
  if (!is.list(x) || is.null(x[[name]])) return(default)
  x[[name]]
}

FILE <- .srsFile("metadata", "runMatch.json")
Config <- jsonlite::fromJSON(FILE, simplifyVector = FALSE)
Units <- .srsGet(.srsGet(Config, "units", list()), "psa", NA_character_)
if (is.na(Units) || !nzchar(Units)) {
  stop(sprintf("srs summary: runMatch metadata must include units.psa in %s.", FILE), call. = FALSE)
}
SrsG <- switch(gsub("\\s+", "", tolower(Units)),
  "g" = 1,
  "m/s2" = 9.80665,
  "m/s^2" = 9.80665,
  "m/s/s" = 9.80665,
  "cm/s2" = 980.665,
  "cm/s^2" = 980.665,
  "cm/s/s" = 980.665,
  "gal" = 980.665,
  "mm/s2" = 9806.65,
  "mm/s^2" = 9806.65,
  "mm/s/s" = 9806.65,
  stop(sprintf("srs summary: unsupported units.psa '%s' in %s.", Units, FILE), call. = FALSE)
)

FILE <- .srsFile("metadata", "MasterIndex.csv")
Master <- .srsRead(
  FILE,
  c("RecordID", "DIR", "OwnerID", "EventID", "EventMagnitude", "Repi",
    "StationVs30", "D0595", "Fs")
)

Master <- Master[DIR == "H1"]
if (!nrow(Master)) stop("srs summary: MasterIndex has no H1 rows.", call. = FALSE)
FS <- unique(Master$Fs[is.finite(Master$Fs)])
if (length(FS) != 1L) {
  stop("srs summary: selected records must have one common Fs value.", call. = FALSE)
}

FILE <- .srsFile("data", "TSW.csv")
TSW <- .srsRead(FILE, c("RecordID", "AT.H1"))
PGA <- TSW[RecordID %in% Master$RecordID, .(
  PGA.H1 = max(abs(AT.H1), na.rm = TRUE)
), by = RecordID]
if (data.table::uniqueN(PGA$RecordID) != data.table::uniqueN(Master$RecordID)) {
  stop("srs summary: TSW.csv must contain AT.H1 rows for all selected records.", call. = FALSE)
}
PgaRange <- .srsRange(.srsAccel(PGA$PGA.H1), digits = 2, unit = SRS.PGA.units)

SRS <- Master[, .(
  records = data.table::uniqueN(RecordID),
  events = data.table::uniqueN(EventID),
  providers = data.table::uniqueN(OwnerID),
  Mw = .srsRange(EventMagnitude, digits = 1),
  Repi = .srsRange(Repi, digits = 0, unit = "km"),
  Vs30 = .srsRange(StationVs30, digits = 0, unit = "m/s"),
  D0595 = .srsRange(D0595, digits = 1, unit = "s"),
  Fs = .srsNumber(FS, digits = 0, unit = "Hz")
)]
SRS[, PGA := PgaRange]

FILE <- .srsFile("match", "target.csv")
Target <- .srsRead(FILE, c("Tn", "Sa.low", "Sa.mean", "Sa.high"))
TargetPGA <- Target[abs(Tn) <= 1e-12]
if (nrow(TargetPGA) != 1L) {
  stop("srs summary: target.csv must contain exactly one Tn = 0 row.", call. = FALSE)
}

SRS.target.PGA <- TargetPGA[, .(
  mean = .srsNumber(.srsAccel(Sa.mean), digits = 2, unit = SRS.PGA.units),
  envelope = paste(
    .srsNumber(.srsAccel(Sa.low), digits = 2),
    SRS.range.word,
    .srsNumber(.srsAccel(Sa.high), digits = 2, unit = SRS.PGA.units)
  )
)]

TargetConfig <- .srsGet(Config, "target", list())
EnvelopeConfig <- .srsGet(TargetConfig, "envelope", list())

SRS.config <- data.table::data.table(
  id = as.character(.srsGet(Config, "id")),
  siteID = as.character(.srsGet(TargetConfig, "siteID")),
  TR = suppressWarnings(as.numeric(.srsGet(TargetConfig, "TR", NA_real_))),
  Vs30 = suppressWarnings(as.numeric(.srsGet(TargetConfig, "Vs30", NA_real_))),
  envelope.low = as.character(.srsGet(EnvelopeConfig, "lower")),
  envelope.high = as.character(.srsGet(EnvelopeConfig, "upper"))
)

if (!is.finite(SRS.config$Vs30)) {
  stop("srs summary: runMatch target metadata must include finite Vs30.", call. = FALSE)
}

SRS.config[, target := if (!is.na(id) && nzchar(id)) id else "project"]
SRS.config[, envelope := {
  LOW <- envelope.low[1L]
  HIGH <- envelope.high[1L]
  if (!is.na(LOW) && !is.na(HIGH) && nzchar(LOW) && nzchar(HIGH)) {
    paste0(LOW, "-", HIGH)
  } else {
    "selected"
  }
}]

FILE <- .srsFile("match", "scale.csv")
Scale <- .srsRead(
  FILE,
  c("RecordID", "scaleFactor")
)

Missing <- setdiff(Master$RecordID, Scale$RecordID)
if (length(Missing)) {
  stop(sprintf("srs summary: scale.csv missing %d selected RecordID values.", length(Missing)), call. = FALSE)
}

Scale <- Scale[RecordID %in% Master$RecordID]
SRS_SCALE <- Scale[, .(
  range = .srsRange(scaleFactor, digits = 2)
)]

FILE <- .srsFile("match", "stage.csv")
Stage <- .srsRead(
  FILE,
  c(
    "mode", "bandWeight", "RMSE", "pgaRatio", "insideFraction",
    "meanViolation", "maxViolation", "scaleMin", "scaleMedian", "scaleMax",
    "nAtMin", "nAtMax"
  )
)
if (nrow(Stage) != 1L) {
  stop("srs summary: V4 stage.csv must contain exactly one global row.", call. = FALSE)
}
if (!identical(Stage$mode[1L], "global")) {
  stop("srs summary: V4 stage.csv must have mode = 'global'.", call. = FALSE)
}

SRS_STAGE <- Stage[, .(
  RMSE = .srsNumber(RMSE, digits = 3),
  pgaRatio = .srsNumber(pgaRatio, digits = 3),
  inside = .srsPercent(insideFraction, digits = 0),
  meanViolation = .srsPercent(meanViolation, digits = 0),
  maxViolation = .srsPercent(maxViolation, digits = 0),
  scale = .srsRange(c(scaleMin, scaleMax), digits = 2)
)]

rm(Master, Scale, Stage, TSW, PGA, PgaRange,
   Target, TargetPGA, Config, TargetConfig, EnvelopeConfig, Missing, FILE, FS,
   Units, SrsG,
   .srsFile, .srsRead, .srsRange, .srsNumber, .srsPercent, .srsAccel, .srsGet)
# nolint end
