# nolint start
if (is.null(UHSTable) || !nrow(UHSTable)) {
  stop("site summary: UHSTable is required.", call. = FALSE)
}

SITE_ID <- if (exists("siteID.target", inherits = FALSE)) {
  .cleanTarget(siteID.target)
} else {
  .resolveSiteIDTarget(UHSTable, "site summary")
}
if (length(SITE_ID) != 1L) {
  stop("site summary: set siteID.target to one siteID.", call. = FALSE)
}

UHS_SITE <- data.table::copy(UHSTable)
if ("siteID" %in% names(UHS_SITE)) UHS_SITE <- UHS_SITE[siteID %in% SITE_ID]

.siteRange <- function(x, digits = 0L, unit = NULL) {
  VALUES <- range(as.numeric(x), na.rm = TRUE)
  OUT <- if (isTRUE(all.equal(VALUES[1L], VALUES[2L]))) {
    .formatNumber(VALUES[1L], digits)
  } else {
    paste(.formatNumber(VALUES, digits), collapse = " a ")
  }
  if (!is.null(unit) && nzchar(unit)) OUT <- paste(OUT, unit)
  OUT
}

TARGET_HINT <- if (exists("ID.gmdp", inherits = TRUE) && length(ID.gmdp)) {
  ID.gmdp
} else if (exists("ID.target", inherits = TRUE) && length(ID.target)) {
  ID.target
} else {
  NULL
}
TARGET_BASE <- if (length(TARGET_HINT)) {
  .targetBaseID(TARGET_HINT, "site summary")
} else {
  NULL
}
BASE_ID <- .resolveIDTarget(
  UHS_SITE,
  "site summary",
  target = TARGET_BASE,
  base = TRUE
)
# The base ID is the design mixture; .oq and .site are its audit branches.
DIRECT_ID <- paste0(BASE_ID, ".oq")
TRANSFORMED_ID <- paste0(BASE_ID, ".site")
ENVELOPE_ID <- BASE_ID

AVAILABLE_ID <- unique(as.character(UHS_SITE$ID))
MISSING_ID <- setdiff(c(DIRECT_ID, TRANSFORMED_ID, ENVELOPE_ID), AVAILABLE_ID)
if (length(MISSING_ID)) {
  stop(sprintf(
    "site summary: missing required ID values: %s.",
    paste(MISSING_ID, collapse = ", ")
  ), call. = FALSE)
}

SITE_MAX <- UHS_SITE[
  ID == ENVELOPE_ID & .matchP(p, "mean") & is.finite(SaF)
]
if (!nrow(SITE_MAX)) stop("site summary: no mean envelope rows found.", call. = FALSE)

SITE_VS30 <- sort(unique(as.numeric(SITE_MAX$Vs30)))
SITE_TR <- sort(unique(as.numeric(SITE_MAX$TR)))
REQUESTED <- NULL
if (exists("Vs30.gmdp", inherits = TRUE) && length(Vs30.gmdp)) {
  REQUESTED <- intersect(as.numeric(Vs30.gmdp), SITE_VS30)
  if (length(REQUESTED)) SITE_VS30 <- sort(unique(REQUESTED))
}
if (exists("TR.gmdp", inherits = TRUE) && length(TR.gmdp)) {
  REQUESTED <- intersect(as.numeric(TR.gmdp), SITE_TR)
  if (length(REQUESTED)) SITE_TR <- sort(unique(REQUESTED))
}
SITE_MAX <- SITE_MAX[Vs30 %in% SITE_VS30 & TR %in% SITE_TR]

SITE_SCOPE <- data.table::data.table(
  siteID = SITE_ID,
  nVs30 = length(SITE_VS30),
  Vs30 = .siteRange(SITE_VS30, digits = 0, unit = "m/s"),
  nTR = length(SITE_TR),
  TR = .siteRange(SITE_TR, digits = 0, unit = "años")
)

SITE_TN_PGA <- min(SITE_MAX$Tn, na.rm = TRUE)
SITE_PGA <- SITE_MAX[abs(Tn - SITE_TN_PGA) <= 1e-12, .(
  minimum = min(SaF, na.rm = TRUE),
  maximum = max(SaF, na.rm = TRUE)
), by = TR]
SITE_PGA[, range := paste(
  .formatNumber(minimum, 3), "a", .formatNumber(maximum, 3), "g"
)]

SITE_SPECTRAL <- SITE_MAX[Tn > SITE_TN_PGA]
if (!nrow(SITE_SPECTRAL)) SITE_SPECTRAL <- SITE_MAX
SITE_PEAK <- SITE_SPECTRAL[, .SD[which.max(SaF)], by = .(TR, Vs30)]
SITE_PEAK_RANGE <- SITE_PEAK[, .(
  minimum = min(SaF, na.rm = TRUE),
  maximum = max(SaF, na.rm = TRUE),
  period.minimum = min(Tn, na.rm = TRUE),
  period.maximum = max(Tn, na.rm = TRUE)
), by = TR]
SITE_PEAK_RANGE[, `:=`(
  range = paste(.formatNumber(minimum, 3), "a", .formatNumber(maximum, 3), "g"),
  period = paste(.formatNumber(period.minimum, 3), "a", .formatNumber(period.maximum, 3), "s")
)]

SITE_KEYS <- c("TR", "Tn", "Vs30", "p")
SITE_DIRECT <- UHS_SITE[
  ID == DIRECT_ID & .matchP(p, "mean") & Vs30 %in% SITE_VS30 & TR %in% SITE_TR,
  c(SITE_KEYS, "SaF"), with = FALSE
]
data.table::setnames(SITE_DIRECT, "SaF", "Sa.direct")
SITE_TRANSFORMED <- UHS_SITE[
  ID == TRANSFORMED_ID & .matchP(p, "mean") & Vs30 %in% SITE_VS30 & TR %in% SITE_TR,
  c(SITE_KEYS, "SaF"), with = FALSE
]
data.table::setnames(SITE_TRANSFORMED, "SaF", "Sa.transformed")
SITE_COMPARE <- merge(SITE_DIRECT, SITE_TRANSFORMED, by = SITE_KEYS)
if (!nrow(SITE_COMPARE)) {
  stop("site summary: direct and transformed mean branches do not overlap.", call. = FALSE)
}
SITE_COMPARE[, controller := data.table::fcase(
  abs(Sa.direct - Sa.transformed) <= sqrt(.Machine$double.eps) * pmax(abs(Sa.direct), abs(Sa.transformed), 1),
  "empate",
  Sa.direct > Sa.transformed, "rama directa",
  default = "rama transformada"
)]
SITE_CONTROL <- SITE_COMPARE[, .N, by = controller][order(controller)]
SITE_CONTROL[, fraction := N / sum(N)]

rm(
  UHS_SITE, TARGET_HINT, TARGET_BASE, AVAILABLE_ID, MISSING_ID, REQUESTED,
  SITE_DIRECT, SITE_TRANSFORMED, SITE_KEYS, SITE_SPECTRAL, .siteRange
)
# nolint end
