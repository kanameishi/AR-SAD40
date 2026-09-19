# nolint start
# Postulated scenarios and reference-rock PGA results for the DSHA results
# paragraph. Metadata comes from ScenarioTable; every reported intensity
# comes from MCETable or UHSTable.
if (is.null(MCETable) || !nrow(MCETable)) {
  DSHA.scn <- NULL
  DSHA.mce <- NULL
  DSHA.uhs <- NULL
  DSHA.gov.mean <- NULL
} else {
  if (is.null(UHSTable) || !nrow(UHSTable)) {
    stop("dsha summary: UHSTable is required for the probabilistic comparator.", call. = FALSE)
  }
  if (is.null(ScenarioTable) || !nrow(ScenarioTable)) {
    stop("dsha summary: ScenarioTable is required for scenario metadata.", call. = FALSE)
  }
  SITE_ID <- if (exists("siteID.target", inherits = FALSE)) siteID.target else {
    unique(MCETable[!is.na(siteID) & nzchar(siteID), siteID])
  }
  if (length(SITE_ID) != 1L) {
    stop("dsha summary: set siteID.target to one siteID.", call. = FALSE)
  }
  SCN.ID <- sort(unique(MCETable[
    siteID %in% SITE_ID & !ID %in% c("MCE", "max", "min") & !grepl("\\.(site|oq|max)$", ID), ID
  ]))
  if (!length(SCN.ID)) {
    stop("dsha summary: no base scenario IDs for the selected site.", call. = FALSE)
  }
  SCN.COLS <- c("ID", "siteID", "TRT", "Mw", "Repi")
  MISSING <- setdiff(SCN.COLS, names(ScenarioTable))
  if (length(MISSING)) {
    stop(sprintf(
      "dsha summary: ScenarioTable missing columns: %s.",
      paste(MISSING, collapse = ", ")
    ), call. = FALSE)
  }
  DSHA.scn <- ScenarioTable[
    siteID %in% SITE_ID & ID %in% SCN.ID,
    .(ID, TRT, Mw, Repi)
  ]
  if (nrow(DSHA.scn) != length(SCN.ID) || anyDuplicated(DSHA.scn$ID)) {
    stop(sprintf(
      "dsha summary: expected one ScenarioTable row per MCETable scenario. MCETable: %s. ScenarioTable matched: %s.",
      paste(SCN.ID, collapse = ", "),
      paste(sort(DSHA.scn$ID), collapse = ", ")
    ), call. = FALSE)
  }
  if (!setequal(SCN.ID, DSHA.scn$ID)) {
    stop("dsha summary: ScenarioTable and MCETable scenario IDs differ.", call. = FALSE)
  }
  if (anyNA(DSHA.scn[, .(ID, TRT, Mw, Repi)]) ||
      any(!is.finite(DSHA.scn$Mw)) || any(!is.finite(DSHA.scn$Repi)) ||
      any(!nzchar(DSHA.scn$ID)) || any(!nzchar(DSHA.scn$TRT))) {
    stop("dsha summary: incomplete scenario metadata in ScenarioTable.", call. = FALSE)
  }
  setorder(DSHA.scn, ID)
  MCE <- MCETable[
    Tn == 0 & Vs30 == 760 & siteID %in% SITE_ID & ID %in% SCN.ID & .matchP(p, "mean"),
    .(ID, PGA.mean = SaF)
  ]
  DUP <- MCE[, .N, by = ID][N != 1L]
  if (nrow(DUP) || nrow(MCE) != length(SCN.ID)) {
    stop("dsha summary: scenario mean PGA is incomplete or not unique by ID.", call. = FALSE)
  }
  DSHA.scn <- merge(
    DSHA.scn,
    MCE,
    by = "ID",
    all.x = TRUE,
    sort = FALSE
  )
  if (anyNA(DSHA.scn$PGA.mean) || any(!is.finite(DSHA.scn$PGA.mean))) {
    stop("dsha summary: missing scenario mean PGA.", call. = FALSE)
  }

  ENV <- MCETable[
    Tn == 0 & Vs30 == 760 & siteID %in% SITE_ID & ID == "MCE" & .matchP(p, "mean"),
    SaF
  ]
  if (length(ENV) != 1L || !is.finite(ENV)) {
    stop("dsha summary: MCE mean PGA is not unique.", call. = FALSE)
  }
  DSHA.mce <- data.table(PGA.mean = ENV)
  DSHA.gov.mean <- DSHA.scn[which.max(PGA.mean), ID]

  TARGET_HINT <- if (exists("ID.gmdp", inherits = TRUE) && length(ID.gmdp)) {
    ID.gmdp
  } else if (exists("ID.target", inherits = FALSE) && length(ID.target)) {
    ID.target
  } else NULL
  TARGET_ID <- .resolveIDTarget(
    UHSTable,
    "dsha summary",
    target = TARGET_HINT,
    siteID = SITE_ID,
    base = TRUE
  )
  UHS <- UHSTable[
    Tn == 0 & Vs30 == 760 & TR == 10000 & siteID %in% SITE_ID &
      ID %in% TARGET_ID & .matchP(p, "mean"),
    .(ID, SaF)
  ]
  if (nrow(UHS) != 1L || length(unique(UHS$SaF)) != 1L || !is.finite(UHS$SaF)) {
    stop("dsha summary: UHS PGA is not unique for TR = 10,000 years.", call. = FALSE)
  }
  DSHA.uhs <- UHS$SaF
  rm(
    SITE_ID, SCN.ID, SCN.COLS, MISSING, MCE, ENV, DUP,
    TARGET_HINT, TARGET_ID, UHS
  )
}
# nolint end
