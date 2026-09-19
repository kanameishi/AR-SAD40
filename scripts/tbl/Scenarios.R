# nolint start
# Deterministic scenarios: the declared rupture parameters of each scenario
# specification, read from oq/calcs/scenario/<siteID>/*.json. Each variant
# inherits the ruptureBase fields it does not override; multi-branch values
# are listed. A field no specification declares yields no column, so the
# table publishes only what the project actually declares.
# Expects: siteID.target (one)
SITE_ID <- if (exists("siteID.target", inherits = FALSE)) siteID.target else NULL
if (length(SITE_ID) != 1L) stop("Scenarios.R: set siteID.target to one siteID.", call. = FALSE)

FILES <- sort(Sys.glob(file.path(root, "oq", "calcs", "scenario", SITE_ID, "*.json")))
if (!length(FILES)) {
  stop("Scenarios.R: no scenario specifications for the selected site.", call. = FALSE)
}

# Display codes for the declared magnitude scaling relations; the caption
# carries the legend. An undeclared relation keeps its full identifier.
MSR_CODES <- c(
  AllenHayesInterfaceBilinear = "AH",
  Leonard2014_SCR             = "L14",
  StrasserInterface           = "STF",
  StrasserIntraslab           = "STS",
  ThingbaijamReverseFault     = "THR",
  WC1994                      = "WC94"
)

LIST <- lapply(FILES, function(FILE) {
  AUX <- jsonlite::fromJSON(FILE, simplifyVector = TRUE)
  BASE <- AUX$ruptureBase
  VAR <- AUX$ruptureVariants
  n <- max(1L, NROW(VAR))
  # Effective values of one field across the variants; zero length when no
  # specification declares it.
  eff <- function(field) {
    x <- if (is.null(BASE[[field]])) rep(NA, n) else rep(BASE[[field]], n)
    if (!is.null(VAR) && field %in% names(VAR)) {
      OK <- !is.na(VAR[[field]])
      x[OK] <- VAR[[field]][OK]
    }
    sort(unique(x[!is.na(x)]))
  }
  .range <- function(field, digits) {
    x <- eff(field)
    if (!length(x)) return(NA_character_)
    x <- round(x, digits)
    if (length(unique(x)) > 1L) paste0(min(x), "–", max(x)) else as.character(x[[1L]])
  }
  .list <- function(field, digits) {
    x <- eff(field)
    if (!length(x)) return(NA_character_)
    paste(round(x, digits), collapse = "/")
  }
  MSR <- eff("msr")
  MSR <- if (!length(MSR)) {
    NA_character_
  } else {
    paste(fifelse(MSR %in% names(MSR_CODES), MSR_CODES[MSR], MSR), collapse = "/")
  }
  data.table(
    ID       = AUX$modelID,
    TRT      = paste(names(AUX$TRT), collapse = "/"),
    Mw       = if (is.null(BASE$mag)) NA_character_ else sprintf("%.1f", BASE$mag),
    Repi     = NA_character_,
    Depth    = .range("dep", 2),
    Strike   = .range("strike", 0),
    Dip      = .range("dip", 1),
    Rake     = .list("rake", 0),
    MSR      = MSR,
    Aspect   = .range("aspectRatio", 2),
    Variants = n
  )
})
AUX <- rbindlist(LIST, use.names = TRUE)[order(ID)]

# The epicentral distance is the one adopted parameter the specs do not
# declare in structured form; ScenarioTable publishes it as the median over
# the rupture variants, in km.
DT <- ScenarioTable[siteID %in% SITE_ID, .(ID, Repi.km = sprintf("%.0f", Repi))]
AUX[DT, Repi := i.Repi.km, on = "ID"]

# A parameter no specification of this site declares carries no information.
COLS <- names(AUX)[vapply(AUX, function(x) all(is.na(x)), logical(1L))]
if (length(COLS)) AUX[, (COLS) := NULL]

TBL <- AUX |> buildTable(
  library          = "flextable",
  align.body       = "center",
  font.size.body   = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |> .mathHeader(c(
  ID = "e",
  Mw = "M_w",
  Repi = "R_{epi}"
)) |> flextable::set_table_properties(layout = "autofit")

rm(AUX, DT, LIST, FILES, SITE_ID, MSR_CODES, COLS)
# nolint end
