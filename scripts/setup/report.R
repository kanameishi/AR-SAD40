.reportSites <- function(config, context = "report") {
  if (is.null(config) || !is.list(config) || !length(config) ||
      !all(vapply(config, is.list, logical(1)))) {
    stop(sprintf(
      "%s: params.report.sites is required; declare the report sites in params.yml.",
      context
    ), call. = FALSE)
  }
  OK <- vapply(config, function(x) {
      COLS <- names(x)
      !is.null(COLS) &&
        !anyDuplicated(COLS) &&
        all(c("siteID", "label") %in% COLS) &&
        all(COLS %in% c("siteID", "label", "SRS", "siteID.storage")) &&
        length(x$siteID) == 1L && !is.list(x$siteID) &&
        length(x$label) == 1L && !is.list(x$label) &&
        (!("SRS" %in% COLS) ||
         (length(x$SRS) == 1L && !is.list(x$SRS))) &&
        (!("siteID.storage" %in% COLS) ||
         (length(x$siteID.storage) == 1L && !is.list(x$siteID.storage) &&
          !is.na(x$siteID.storage) &&
          nzchar(trimws(as.character(x$siteID.storage)))))
    }, logical(1))
  if (!all(OK)) {
    stop(sprintf(
      paste0(
        "%s: each params.report.sites entry must define one scalar siteID, ",
        "one scalar label, and at most one scalar SRS and siteID.storage."
      ),
      context
    ), call. = FALSE)
  }
    DT <- data.table::rbindlist(config, fill = TRUE, use.names = TRUE)
    if (!"SRS" %in% names(DT)) DT[, SRS := NA_character_]
    if (!"siteID.storage" %in% names(DT)) {
      DT[, siteID.storage := NA_character_]
    }
    DT <- DT[, .(
      siteID = trimws(as.character(siteID)),
      label = trimws(as.character(label)),
      SRS = trimws(as.character(SRS)),
      siteID.storage = trimws(as.character(siteID.storage))
    )]
    if (anyNA(DT$siteID) || any(!nzchar(DT$siteID)) ||
        anyNA(DT$label) || any(!nzchar(DT$label))) {
      stop(sprintf(
        "%s: params.report.sites siteID and label values must be non-empty.",
        context
      ), call. = FALSE)
    }
    if (anyDuplicated(DT$siteID)) {
      stop(sprintf("%s: params.report.sites contains duplicate siteID values.",
                   context), call. = FALSE)
    }
  DT[is.na(siteID.storage), siteID.storage := siteID]

  DT[, key := tolower(gsub("[^[:alnum:]_.-]+", "-", siteID))]
  DT[, key := gsub("(^[-.]+|[-.]+$)", "", key)]
  if (any(!nzchar(DT$key)) || anyDuplicated(DT$key)) {
    stop(sprintf(
      "%s: configured siteID values do not produce unique report keys.",
      context
    ), call. = FALSE)
  }
  DT[]
}

.reportSite <- function(x, i, stem, vars = list(), context = "report") {
  if (!data.table::is.data.table(x) ||
      !all(c("siteID", "label", "SRS", "siteID.storage", "key") %in%
           names(x))) {
    stop(sprintf("%s: SiteTable does not satisfy the report contract.", context),
         call. = FALSE)
  }
  if (length(i) != 1L || is.na(i) || i < 1L || i > nrow(x)) {
    stop(sprintf("%s: site row index is invalid.", context), call. = FALSE)
  }
  if (length(stem) != 1L || is.na(stem) || !nzchar(stem)) {
    stop(sprintf("%s: stem must be one non-empty value.", context),
         call. = FALSE)
  }
  if (!is.list(vars) ||
      (length(vars) &&
       (is.null(names(vars)) || any(!nzchar(names(vars)))))) {
    stop(sprintf("%s: vars must be a named list.", context), call. = FALSE)
  }
  COLS <- intersect(
    c("siteID.target", "siteID.storage", "ReportContext"),
    names(vars)
  )
  if (length(COLS)) {
    stop(sprintf(
      "%s: report context variables are owned by SiteTable: %s.",
      context, paste(COLS, collapse = ", ")
    ), call. = FALSE)
  }
  AUX <- nrow(x) > 1L
  ReportContext <- .newReportContext(
    multiple = AUX,
    key = x$key[[i]],
    label = x$label[[i]],
    context = context
  )
  vars$siteID.target <- x$siteID[[i]]
  vars$siteID.storage <- x$siteID.storage[[i]]
  vars$ReportContext <- ReportContext
  list(
    siteID = x$siteID[[i]],
    siteID.storage = x$siteID.storage[[i]],
    SRS = x$SRS[[i]],
    context = ReportContext,
    stem = if (ReportContext$multiple) {
      paste(ReportContext$key, stem, sep = "-")
    } else {
      stem
    },
    labels = if (ReportContext$multiple) "rewrite" else "keep",
    vars = vars
  )
}

.knitReportBlock <- function(path, stem, sites, i, vars = list(), root,
                             heading = NULL, level = 4L, anchor = NULL,
                             context = "report") {
  AUX <- .reportSite(sites, i, stem, vars, context)
  .knitContextBlock(AUX, path, root, heading, level, anchor, context, "multisite")
}

# The record selection belongs to the project, not to a site. A multisite
# report publishes everything else per site, but declares and reports a single
# selection. Sites declare that same target; more than one is a contradiction
# and stops instead of being resolved by choice.
.resolveProjectSRS <- function(sites, root, context = "report SRS") {
  DIR <- file.path(root, "gmsp", "match")
  FILES <- if (dir.exists(DIR)) {
    list.files(DIR, all.files = FALSE, full.names = FALSE, no.. = TRUE)
  } else {
    character()
  }
  FILES <- .cleanTarget(FILES[dir.exists(file.path(DIR, FILES))])
  OUT <- unique(.cleanTarget(sites$SRS))
  if (!length(OUT)) {
    if (length(FILES) != 1L) {
      stop(sprintf(
        "%s: declare SRS in params.report.sites; available runs: %s.",
        context, if (length(FILES)) .targetChoices(FILES) else "none"
      ), call. = FALSE)
    }
    OUT <- FILES
  }
  if (length(OUT) != 1L) {
    stop(sprintf(
      "%s: the project declares %s SRS runs (%s); the record selection is one per project.",
      context, length(OUT), paste(OUT, collapse = ", ")
    ), call. = FALSE)
  }
  if (!OUT %in% FILES) {
    stop(sprintf(
      "%s: SRS run not found: %s. Available: %s.",
      context, OUT, if (length(FILES)) .targetChoices(FILES) else "none"
    ), call. = FALSE)
  }
  FILE <- file.path(DIR, OUT, "metadata", "runMatch.json")
  if (!file.exists(FILE)) {
    stop(sprintf("%s: missing %s.", context, FILE), call. = FALSE)
  }
  DT <- jsonlite::read_json(FILE, simplifyVector = TRUE)
  AUX <- .cleanTarget(DT$target$siteID)
  if (length(AUX) != 1L || !AUX %in% sites$siteID) {
    stop(sprintf(
      "%s: SRS %s targets siteID %s, which is not a declared report site.",
      context, OUT, paste(DT$target$siteID, collapse = ", ")
    ), call. = FALSE)
  }
  list(
    SRS.target = OUT,
    PathSRS = dirname(dirname(FILE)),
    siteID.target = AUX,
    siteLabel.target = sites$label[[match(AUX, sites$siteID)]]
  )
}

AUX <- NULL
if (!is.null(params$report)) {
  if (!is.list(params$report)) {
    stop("report: params.report must be a YAML mapping.", call. = FALSE)
  }
  AUX <- params$report$sites
}
SiteTable <- .reportSites(AUX, context = "report")
SelectionTable <- if (.srsAvailable(root) ||
                      (is.list(params$report) &&
                       !is.null(params$report$selections))) {
  .srsSelectionTable(params, root = root, sites = SiteTable,
                     context = "report SRS")
} else {
  NULL
}
rm(AUX)
