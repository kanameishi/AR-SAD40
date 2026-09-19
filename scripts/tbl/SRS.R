# nolint start
if (!exists("PathSRS", inherits = FALSE)) {
  stop("SRS table: set PathSRS before sourcing scripts/tbl/SRS.R.", call. = FALSE)
}
if (!requireNamespace("jsonlite", quietly = TRUE)) {
  stop("SRS table: package jsonlite is required.", call. = FALSE)
}
if (!exists("N", inherits = FALSE)) N <- Inf
FILE <- file.path(PathSRS, "metadata", "runMatch.json")
if (!file.exists(FILE)) {
  stop(sprintf("SRS table requires gmsp metadata: %s.", FILE), call. = FALSE)
}
Config <- jsonlite::fromJSON(FILE, simplifyVector = FALSE)
Units <- Config$units$psa
if (is.null(Units) || !nzchar(Units)) {
  stop(sprintf("SRS table requires units.psa in %s.", FILE), call. = FALSE)
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
  stop(sprintf("SRS table: unsupported units.psa '%s' in %s.", Units, FILE), call. = FALSE)
)

FILE <- file.path(PathSRS, "match", "stage.csv")
Head <- names(data.table::fread(FILE, nrows = 0L))
Missing <- setdiff(c("mode", "bandWeight", "insideFraction", "meanViolation", "maxViolation"), Head)
if (length(Missing)) {
  stop(sprintf("SRS table: V4 stage.csv missing columns: %s.", paste(Missing, collapse = ", ")),
       call. = FALSE)
}
Stage <- data.table::fread(FILE, select = "mode")
if (nrow(Stage) != 1L || !identical(Stage$mode[1L], "global")) {
  stop("SRS table requires gmsp runMatch V4 stage.csv with one global row.", call. = FALSE)
}

FILE <- file.path(PathSRS, "metadata", "MasterIndex.csv")
Master <- data.table::fread(
  FILE,
  select = c(
    "RecordID", "DIR", "EventID", "EventName", "EventMagnitude", "Repi",
    "PGA", "AI", "CAV", "CAV5"
  )
)

FILE <- file.path(PathSRS, "match", "scale.csv")
if (!file.exists(FILE)) {
  stop("SRS table requires gmsp Stage B output match/scale.csv.", call. = FALSE)
}
Scale <- data.table::fread(FILE, select = c("RecordID", "scaleFactor"))

DT <- Master[DIR == "H1"]
DT[, EventLabel := trimws(as.character(EventName))]
DT[is.na(EventLabel) | !nzchar(EventLabel), EventLabel := trimws(as.character(EventID))]
if (any(is.na(DT$EventLabel) | !nzchar(DT$EventLabel))) {
  stop("SRS table: every H1 record requires EventName or EventID.", call. = FALSE)
}
DT <- merge(DT, Scale, by = "RecordID", all.x = TRUE, sort = FALSE)
if (any(!is.finite(DT$scaleFactor))) {
  stop("SRS table: match/scale.csv must contain scaleFactor for all H1 records.", call. = FALSE)
}
DT <- DT[order(-PGA)]
if (is.finite(N)) DT <- DT[seq_len(min(as.integer(N), .N))]

AUX <- DT[, .(
  RecordID = RecordID,
  Event = EventLabel,
  Mw = round(EventMagnitude, 2),
  Repi = round(Repi, 1),
  PGA = signif(PGA / SrsG, 3),
  AI = signif(AI, 3),
  CAV = signif(CAV, 3),
  CAV5 = signif(CAV5, 3),
  SF = round(scaleFactor, 3)
)]

TBL <- AUX |> buildTable(
  library          = "flextable",
  align.body       = "center",
  font.size.body   = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |> .mathHeader(c(
  RecordID = "\\mathrm{ID}_i",
  Mw       = "M_w",
  Repi     = "R_{epi}",
  PGA      = "\\mathrm{PGA}",
  AI       = "I_A",
  CAV      = "\\mathrm{CAV}",
  CAV5     = "\\mathrm{CAV}_5",
  SF       = "c_i"
)) |> flextable::set_table_properties(layout = "autofit")

TBL <- flextable::align(TBL, j = "Event", align = "left", part = "body")
TBL <- flextable::bold(TBL, j = "RecordID", part = "body")
TBL <- flextable::bold(TBL, j = "RecordID", part = "header")

rm(DT, AUX, Master, Scale, Stage, FILE, Config, Units, SrsG, Head, Missing)
# nolint end
