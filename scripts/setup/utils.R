# nolint start
readFile <- function(file, hint, readFun, ...) {
  if (!file.exists(file)) stop(paste0("Missing data: ", basename(file), ". ", hint))
  readFun(file, ...)
}

readCaption <- function(caption) {
  paste(
    readLines(
      file.path(root, "_captions", paste0(caption, ".md")),
      warn = FALSE
    ),
    collapse = " "
  )
}

.fmt <- function(x, d = 2) formatC(x, format = "f", digits = d)

# Annex note for a results block: `text` is the full sentence with one %s
# placeholder that receives the markdown link [name](https://domain), with
# the domain resolved from the project manifest (alias -> domain). Empty
# when the manifest, the alias, or its domain is absent, so every surface
# renders without the sentence.
.deckNote <- function(alias, name, text) {
  FILE <- file.path(root, "manifest.json")
  if (!file.exists(FILE) || !requireNamespace("jsonlite", quietly = TRUE)) {
    return("")
  }
  LIST <- tryCatch(
    jsonlite::fromJSON(FILE, simplifyVector = FALSE)$artifacts,
    error = function(e) NULL
  )
  for (x in LIST) {
    if (identical(x$alias, alias) && !is.null(x$domain) && nzchar(x$domain)) {
      return(sprintf(text, sprintf("[%s](https://%s)", name, x$domain)))
    }
  }
  ""
}

.fmti <- function(x) formatC(x, format = "d", big.mark = ",")

.matchP <- function(p, target) {
  TOL <- 1e-10
  PText <- trimws(as.character(p))
  TargetText <- trimws(as.character(target))
  PNum <- suppressWarnings(as.numeric(PText))
  TargetNum <- suppressWarnings(as.numeric(TargetText))

  OK <- rep(FALSE, length(PText))
  Text <- tolower(TargetText[!is.finite(TargetNum)])
  Text <- Text[!is.na(Text) & nzchar(Text)]
  if (length(Text)) OK <- OK | tolower(PText) %in% Text

  TargetNum <- TargetNum[is.finite(TargetNum)]
  if (length(TargetNum)) {
    OK <- OK | vapply(PNum, function(x) {
      is.finite(x) && any(abs(x - TargetNum) <= TOL)
    }, logical(1))
  }
  OK
}

.formatNumber <- function(x, digits = 0) {
  if (digits == 0) .fmti(round(as.numeric(x))) else .fmt(as.numeric(x), digits)
}

formatRange <- function(x, digits = 0, unit = NULL) {
  OUT <- paste(.formatNumber(range(as.numeric(x), na.rm = TRUE), digits), collapse = " to ")
  if (is.null(unit) || !nzchar(unit)) OUT else paste(OUT, unit)
}

.formatAEP <- function(TR) paste0("1/", .fmti(as.numeric(TR)))

.convertKmax <- function(x, units) {
  if (units %in% c("cm", "cm/s2", "cm/s**2", "cm/s^2")) round(x * 980.665, 0)
  else if (units == "g") round(x, 3)
  else x
}

.fmtSa <- function(x, units) {
  .fmt(.convertKmax(x, units), if (units == "g") 3L else 0L)
}

# The Newmark products carry the model ID with its return period, and the MCE
# with none. One label for legends and table rows, in the form the UHS and AF
# figures already use for return periods.
# One dash style per return period, from the shortest to the longest, so a
# demand keeps its trace in every panel; the MCE, the deterministic anchor, is
# the solid line. NGR knows nine dash styles and the family has eight members.
.demandStyle <- function(TR, levels) {
  STYLES <- c(
    "ShortDot", "Dot", "ShortDash", "ShortDashDot",
    "DashDot", "Dash", "LongDash", "LongDashDotDot"
  )
  Levels <- sort(unique(levels))
  fifelse(
    is.na(TR),
    "Solid",
    rep(STYLES, length.out = length(Levels))[match(TR, Levels)]
  )
}

.demandLabel <- function(ID, TR) {
  fifelse(
    is.na(TR),
    as.character(ID),
    paste0("TR ", prettyNum(round(TR, 0), big.mark = ","), " yr")
  )
}

.currentTarget <- function(name, envir = parent.frame()) {
  if (exists(name, envir = envir, inherits = TRUE)) get(name, envir = envir, inherits = TRUE) else NULL
}

.cleanTarget <- function(x) {
  x <- unique(as.character(x))
  x[!is.na(x) & nzchar(x)]
}

.sourceChunkLabel <- function(options) {
  Code <- options$yaml.code
  Line <- grep("^#\\|[[:space:]]*label:", Code, value = TRUE)
  if (!length(Line)) return(options$label)
  trimws(sub(
    "^#\\|[[:space:]]*label:[[:space:]]*",
    "",
    Line[[1L]]
  ))
}

.siteChunkLabel <- function(label, envir = knitr::knit_global()) {
  if (length(label) != 1L || is.na(label) ||
      !grepl("^(fig|tbl)-", label)) {
    return(label)
  }
  SiteID <- trimws(.cleanTarget(
    .currentTarget("siteID.target", envir = envir)
  ))
  if (!length(SiteID)) return(label)
  if (length(SiteID) != 1L ||
      !nzchar(SiteID) ||
      grepl("[^[:alnum:]_.-]", SiteID)) {
    stop(
      "literal multisite chunk labels require one valid siteID.target.",
      call. = FALSE
    )
  }
  Kind <- sub("^((fig|tbl)-).*", "\\1", label)
  Stem <- sub("^(fig|tbl)-", "", label)
  Prefix <- paste0(Kind, tolower(SiteID), "-")
  if (startsWith(label, Prefix)) label else paste0(Prefix, Stem)
}

.siteChunkLabelHook <- function(options) {
  options$label <- .siteChunkLabel(.sourceChunkLabel(options))
  options
}

.installSiteChunkLabelHook <- function() {
  if (!isTRUE(getOption("psha.multisite.literal.includes"))) {
    return(invisible(FALSE))
  }
  Hook <- knitr::opts_hooks$get("label")
  if (is.function(Hook) &&
      isTRUE(attr(Hook, "psha.multisite.literal.includes"))) {
    return(invisible(TRUE))
  }
  if (!is.null(Hook)) {
    stop(
      "literal multisite labels cannot replace an existing knitr label hook.",
      call. = FALSE
    )
  }
  Hook <- .siteChunkLabelHook
  attr(Hook, "psha.multisite.literal.includes") <- TRUE
  knitr::opts_hooks$set(label = Hook)
  invisible(TRUE)
}

.validateReportContext <- function(x, context = "report context") {
  COLS <- c("multiple", "key", "label")
  if (!is.list(x) || !identical(names(x), COLS)) {
    stop(sprintf(
      "%s: ReportContext must contain exactly: %s.",
      context, paste(COLS, collapse = ", ")
    ), call. = FALSE)
  }
  if (!is.logical(x$multiple) || length(x$multiple) != 1L ||
      is.na(x$multiple)) {
    stop(sprintf("%s: ReportContext multiple must be TRUE or FALSE.",
                 context), call. = FALSE)
  }
  if (!is.character(x$key) || length(x$key) != 1L ||
      is.na(x$key) || !nzchar(trimws(x$key)) ||
      grepl("[^[:alnum:]_.-]", x$key)) {
    stop(sprintf("%s: ReportContext key is invalid.", context),
         call. = FALSE)
  }
  if (!is.character(x$label) || length(x$label) != 1L ||
      is.na(x$label) || !nzchar(trimws(x$label))) {
    stop(sprintf("%s: ReportContext label must be one non-empty value.",
                 context), call. = FALSE)
  }
  list(
    multiple = x$multiple,
    key = trimws(x$key),
    label = trimws(x$label)
  )
}

.newReportContext <- function(multiple, key, label, context = "report") {
  .validateReportContext(
    list(
      multiple = multiple,
      key = key,
      label = label
    ),
    context = context
  )
}

.currentReportContext <- function(envir = parent.frame()) {
  if (!exists("ReportContext", envir = envir, inherits = TRUE)) return(NULL)
  .validateReportContext(
    get("ReportContext", envir = envir, inherits = TRUE)
  )
}

.reportLabel <- function(envir = parent.frame()) {
  Target <- trimws(.cleanTarget(
    .currentTarget("siteLabel.target", envir = envir)
  ))
  if (length(Target)) {
    if (length(Target) != 1L || !nzchar(Target)) {
      stop("siteLabel.target must be one non-empty value.", call. = FALSE)
    }
    return(Target)
  }
  OUT <- .currentReportContext(envir = envir)
  if (is.null(OUT)) "" else OUT$label
}

.reportMultiple <- function(envir = parent.frame()) {
  OUT <- .currentReportContext(envir = envir)
  !is.null(OUT) && OUT$multiple
}

.composeTargetStem <- function(stem, envir = parent.frame()) {
  if (length(stem) != 1L || is.na(stem) || !nzchar(stem)) {
    stop("target stem must be one non-empty value.", call. = FALSE)
  }
  OUT <- .currentReportContext(envir = envir)
  if (!is.null(OUT)) {
    if (!OUT$multiple) return(stem)
    return(paste(OUT$key, stem, sep = "-"))
  }
  AUX <- .cleanTarget(.currentTarget("siteID.target", envir = envir))
  AUX <- tolower(AUX)
  if (!length(AUX)) return(stem)
  if (length(AUX) != 1L) {
    stop("target stem requires one site key.", call. = FALSE)
  }
  paste(AUX, stem, sep = "-")
}

# Shared core of the per-context knit blocks: optional multisite heading,
# scoped variable swap in the knit global environment, and the child knit.
# Multisite heading of a per-site block: emitted only when the report has
# several sites. A chapter that wraps several blocks under one site heading
# (a tabset per model) calls it before the wrapper.
# These definitions live in setup helpers so standalone decks can use
# selection context without running report-level SiteTable initialization.
.reportHeading <- function(AUX, heading, level, anchor, context, kind) {
  if (!AUX$context$multiple || is.null(heading)) return(invisible(NULL))
  if (length(heading) != 1L || is.na(heading) || !nzchar(heading) ||
      length(anchor) != 1L || is.na(anchor) || !nzchar(anchor) ||
      length(level) != 1L || is.na(level) || level < 1L) {
    stop(sprintf(
      "%s: %s heading requires scalar heading, level, and anchor.",
      context, kind
    ), call. = FALSE)
  }
  cat(sprintf(
    "%s %s {#%s-%s}\n\n",
    strrep("#", as.integer(level)), AUX$context$label, anchor,
    AUX$context$key
  ))
  invisible(NULL)
}

.knitContextBlock <- function(AUX, path, root, heading, level, anchor,
                              context, kind) {
  .reportHeading(AUX, heading, level, anchor, context, kind)
  COLS <- names(AUX$vars)
  LIST <- vector("list", length(COLS))
  names(LIST) <- COLS
  OUT <- setNames(logical(length(COLS)), COLS)
  for (COL in COLS) {
    OUT[[COL]] <- exists(COL, envir = knitr::knit_global(), inherits = FALSE)
    if (OUT[[COL]]) {
      LIST[[COL]] <- get(COL, envir = knitr::knit_global(), inherits = FALSE)
    }
    assign(COL, AUX$vars[[COL]], envir = knitr::knit_global())
  }
  on.exit({
    for (COL in rev(COLS)) {
      if (OUT[[COL]]) {
        assign(COL, LIST[[COL]], envir = knitr::knit_global())
      } else if (exists(COL, envir = knitr::knit_global(), inherits = FALSE)) {
        rm(list = COL, envir = knitr::knit_global())
      }
    }
  }, add = TRUE)
  NGR::knitBlock(
    path = path,
    stem = AUX$stem,
    labels = AUX$labels,
    root = root
  )
  invisible(AUX)
}

.reportSelection <- function(x, i, stem, vars = list(), context = "report") {
  if (!data.table::is.data.table(x) ||
      !all(c("SRS", "label", "PathSRS", "siteID.target", "siteLabel.target",
             "key") %in% names(x))) {
    stop(sprintf("%s: SelectionTable does not satisfy the report contract.",
                 context), call. = FALSE)
  }
  if (length(i) != 1L || is.na(i) || i < 1L || i > nrow(x)) {
    stop(sprintf("%s: selection row index is invalid.", context),
         call. = FALSE)
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
    c("SRS.target", "PathSRS", "siteID.target", "siteLabel.target",
      "ReportContext"),
    names(vars)
  )
  if (length(COLS)) {
    stop(sprintf(
      "%s: selection context variables are owned by SelectionTable: %s.",
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
  vars$SRS.target <- x$SRS[[i]]
  vars$PathSRS <- x$PathSRS[[i]]
  vars$siteID.target <- x$siteID.target[[i]]
  # With one selection the captions keep naming the target site, as the
  # single-selection report always did; with several, .reportLabel() must
  # fall through to the selection label or every caption reads the same.
  if (!AUX) vars$siteLabel.target <- x$siteLabel.target[[i]]
  vars$ReportContext <- ReportContext
  list(
    SRS = x$SRS[[i]],
    PathSRS = x$PathSRS[[i]],
    siteID.target = x$siteID.target[[i]],
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

.knitSelectionBlock <- function(path, stem, selections, i, vars = list(),
                                root, heading = NULL, level = 4L,
                                anchor = NULL, context = "report") {
  AUX <- .reportSelection(selections, i, stem, vars, context)
  .knitContextBlock(AUX, path, root, heading, level, anchor, context, "multiselection")
}

.targetChoices <- function(x, n = 12L) {
  x <- .cleanTarget(x)
  OUT <- head(x, n)
  if (length(x) > n) OUT <- c(OUT, sprintf("... %d more", length(x) - n))
  paste(OUT, collapse = ", ")
}

.requireOneTarget <- function(values, targetName, context) {
  Values <- .cleanTarget(values)
  if (length(Values) == 1L) return(Values)
  if (!length(Values)) {
    stop(sprintf("%s: no %s candidates found.", context, targetName), call. = FALSE)
  }
  stop(sprintf(
    "%s: set %s to one of: %s.",
    context, targetName, .targetChoices(Values)
  ), call. = FALSE)
}

# Single definition of the deaggregation display grid: native (Mw, R)
# bins merge into 2x2 blocks by SUM (p is an additive PMF — never
# interpolate). R cannot go finer than 2x: the OpenQuake rupture
# discretization populates alternate 10-km distance bins on interface
# sources (verified on AR-S2L1W), so native-bin display stripes. Steps
# carry diff() float noise: grid and labels rounded. Input: one panel
# with columns Mw, R, p. Output adds MwBlk/RBlk dims.
.rmwBlocks <- function(x) {
  MwBlk <- round(2 * unique(diff(sort(unique(x$Mw))))[1], 3)
  RBlk  <- round(2 * unique(diff(sort(unique(x$R))))[1], 3)
  x[, .(p = sum(p)), by = .(
    Mw = round(MwBlk * floor(Mw / MwBlk) + MwBlk / 2, 2),
    R  = round(RBlk * floor(R / RBlk) + RBlk / 2, 1)
  )][, `:=`(MwBlk = MwBlk, RBlk = RBlk)][]
}

# Deaggregation caption statistics for one (Tn, TR) panel: modal block
# on the DISPLAY grid (.rmwBlocks) plus the grid-invariant mean scenario.
.rmwStats <- function(tn, tr, envir = parent.frame()) {
  # siteID.target vive en el entorno del documento, no en el de esta función.
  # Con exists(inherits = FALSE) la condición era siempre falsa y el filtro por
  # sitio no corría nunca: en un proyecto de un solo sitio pasa inadvertido,
  # pero en uno multisitio promediaba los sitios entre sí y publicaba números
  # mezclados sin fallar. .currentTarget resuelve en la cadena de entornos, que
  # es como el resto del scaffold lee los selectores del documento.
  Tn <- .requireOneTarget(tn, "Tn", "rmw stats")
  TR <- .requireOneTarget(tr, "TR", "rmw stats")
  DT <- RMwTable
  SiteID <- .cleanTarget(.currentTarget("siteID.target", envir = envir))
  if ("siteID" %in% names(DT) && length(SiteID)) {
    DT <- DT[siteID %in% SiteID]
  }
  tn <- as.numeric(Tn)
  tr <- as.numeric(TR)
  AUX <- sort(unique(DT$TR))
  TRo <- AUX[which.min(abs(AUX - tr))]
  DT <- DT[Tn == tn & TR == TRo]
  MwBar <- DT[, sum(p * Mw) / sum(p)]
  RBar  <- DT[, sum(p * R) / sum(p)]
  DT <- .rmwBlocks(DT[, .(Mw, R, p)])
  Modal <- DT[which.max(p)]
  list(
    TR = TRo, MwBlk = Modal$MwBlk, RBlk = Modal$RBlk,
    MwMode = Modal$Mw, RMode = Modal$R,
    pctMode = 100 * Modal$p / sum(DT$p),
    MwBar = MwBar, RBar = RBar
  )
}

.srsAvailable <- function(root) {
  DIR <- file.path(root, "gmsp", "match")
  dir.exists(DIR) && length(list.dirs(DIR, recursive = FALSE)) > 0L
}

# One row per record selection the report must publish. Declared order wins:
# params.report.selections, else the legacy per-site SRS declaration, else
# every run found under gmsp/match (alphabetical) — leaving stale runs there
# publishes them, by owner ruling (2026-08-15).
.srsSelectionTable <- function(params, root, sites = NULL,
                               context = "report SRS") {
  DIR <- file.path(root, "gmsp", "match")
  FILES <- if (dir.exists(DIR)) {
    list.files(DIR, all.files = FALSE, full.names = FALSE, no.. = TRUE)
  } else {
    character()
  }
  FILES <- sort(.cleanTarget(FILES[dir.exists(file.path(DIR, FILES))]))
  Config <- if (is.list(params) && is.list(params$report)) {
    params$report$selections
  } else {
    NULL
  }
  DT <- if (!is.null(Config)) {
    if (!is.list(Config) || !length(Config) ||
        !all(vapply(Config, is.list, logical(1)))) {
      stop(sprintf(
        "%s: params.report.selections must be a list of selection entries.",
        context
      ), call. = FALSE)
    }
    OK <- vapply(Config, function(x) {
      COLS <- names(x)
      !is.null(COLS) && !anyDuplicated(COLS) &&
        "SRS" %in% COLS && all(COLS %in% c("SRS", "label")) &&
        length(x$SRS) == 1L && !is.list(x$SRS) &&
        (!("label" %in% COLS) ||
         (length(x$label) == 1L && !is.list(x$label)))
    }, logical(1))
    if (!all(OK)) {
      stop(sprintf(
        paste0(
          "%s: each params.report.selections entry must define one scalar ",
          "SRS and at most one scalar label."
        ),
        context
      ), call. = FALSE)
    }
    data.table::rbindlist(lapply(Config, function(x) {
      data.table::data.table(
        SRS = trimws(as.character(x$SRS)),
        label = if (is.null(x$label)) {
          NA_character_
        } else {
          trimws(as.character(x$label))
        }
      )
    }))
  } else {
    # The legacy per-site SRS declaration binds every consumer, including
    # decks that never build SiteTable; read it raw from params when the
    # validated table is not supplied.
    AUX <- if (!is.null(sites)) {
      .cleanTarget(sites$SRS)
    } else if (is.list(params) && is.list(params$report) &&
               is.list(params$report$sites)) {
      .cleanTarget(unlist(
        lapply(params$report$sites, function(x) if (is.list(x)) x$SRS),
        use.names = FALSE
      ))
    } else {
      character()
    }
    if (!length(AUX)) AUX <- FILES
    data.table::data.table(SRS = AUX, label = NA_character_)
  }
  if (!nrow(DT) || anyNA(DT$SRS) || any(!nzchar(DT$SRS))) {
    stop(sprintf(
      "%s: no record selection declared and no runs found under gmsp/match.",
      context
    ), call. = FALSE)
  }
  if (anyDuplicated(DT$SRS)) {
    stop(sprintf("%s: the declared selections contain duplicate SRS values.",
                 context), call. = FALSE)
  }
  DT[is.na(label) | !nzchar(label), label := SRS]
  Missing <- setdiff(DT$SRS, FILES)
  if (length(Missing)) {
    stop(sprintf(
      "%s: SRS run not found: %s. Available: %s.",
      context, paste(Missing, collapse = ", "),
      if (length(FILES)) .targetChoices(FILES) else "none"
    ), call. = FALSE)
  }
  DT[, PathSRS := file.path(DIR, SRS)]
  DT[, `:=`(
    siteID.target = NA_character_,
    siteLabel.target = NA_character_
  )]
  for (i in seq_len(nrow(DT))) {
    FILE <- file.path(DT$PathSRS[[i]], "metadata", "runMatch.json")
    if (!file.exists(FILE)) {
      stop(sprintf("%s: missing %s.", context, FILE), call. = FALSE)
    }
    AUX <- .cleanTarget(
      jsonlite::read_json(FILE, simplifyVector = TRUE)$target$siteID
    )
    if (length(AUX) != 1L) {
      stop(sprintf("%s: SRS %s does not declare one target siteID.",
                   context, DT$SRS[[i]]), call. = FALSE)
    }
    if (!is.null(sites)) {
      if (!AUX %in% sites$siteID) {
        stop(sprintf(
          "%s: SRS %s targets siteID %s, which is not a declared report site.",
          context, DT$SRS[[i]], AUX
        ), call. = FALSE)
      }
      data.table::set(DT, i, "siteLabel.target",
                      sites$label[[match(AUX, sites$siteID)]])
    }
    data.table::set(DT, i, "siteID.target", AUX)
  }
  DT[, key := tolower(gsub("[^[:alnum:]_.-]+", "-", SRS))]
  DT[, key := gsub("(^[-.]+|[-.]+$)", "", key)]
  if (any(!nzchar(DT$key)) || anyDuplicated(DT$key)) {
    stop(sprintf(
      "%s: configured SRS values do not produce unique report keys.",
      context
    ), call. = FALSE)
  }
  DT[]
}

# Deck-side resolver: a preset PathSRS (temporary or external run) overrides
# the declared selections and renders that single run, as the decks always
# allowed. Decks skip the report-site cross-check on purpose: they can render
# before params.report.sites exists.
.srsDeckSelections <- function(params, root, path = NULL,
                               context = "SRS deck") {
  if (!is.null(path)) {
    AUX <- basename(normalizePath(path, mustWork = FALSE))
    KEY <- gsub("(^[-.]+|[-.]+$)", "",
                tolower(gsub("[^[:alnum:]_.-]+", "-", AUX)))
    if (!nzchar(KEY)) {
      stop(sprintf("%s: PathSRS does not produce a report key.", context),
           call. = FALSE)
    }
    DT <- data.table::data.table(
      SRS = AUX,
      label = AUX,
      PathSRS = path,
      siteID.target = NA_character_,
      siteLabel.target = NA_character_
    )
    DT[, key := KEY]
    return(DT[])
  }
  .srsSelectionTable(params, root = root, context = context)
}

.tableIDs <- function(x, context, siteID = NULL) {
  if (is.null(x)) stop(sprintf("%s: missing data table.", context), call. = FALSE)
  DT <- x
  SiteID <- .cleanTarget(siteID)
  if (length(SiteID) && "siteID" %in% names(DT)) DT <- DT[DT[["siteID"]] %in% SiteID]
  if (!"ID" %in% names(DT)) stop(sprintf("%s: table has no ID column.", context), call. = FALSE)
  .cleanTarget(DT$ID)
}

.baseIDs <- function(ids) {
  ids <- .cleanTarget(ids)
  ids[!grepl("\\.(site|oq|max)$", ids) & !ids %in% c("max", "min")]
}

.validateIDTarget <- function(target, candidates, context) {
  Target <- .cleanTarget(target)
  if (!length(Target)) return(NULL)
  Missing <- setdiff(Target, candidates)
  if (length(Missing)) {
    stop(sprintf(
      "%s: ID.target not found: %s. Available: %s.",
      context, paste(Missing, collapse = ", "), .targetChoices(candidates)
    ), call. = FALSE)
  }
  Target
}

.resolveIDTarget <- function(x, context, target = NULL, siteID = NULL, base = FALSE) {
  IDs <- .tableIDs(x, context, siteID)
  Candidates <- IDs
  if (base) Candidates <- .baseIDs(Candidates)
  Target <- .cleanTarget(target)
  if (!length(Target)) Target <- .cleanTarget(.currentTarget("ID.gmdp"))
  if (length(Target)) return(.validateIDTarget(Target, Candidates, context))
  .requireOneTarget(Candidates, "ID.target", context)
}

.targetBaseID <- function(target, context) {
  Target <- .cleanTarget(target)
  Target <- Target[!Target %in% c("max", "min")]
  Target <- sub("\\.(site|oq|max)$", "", Target)
  .requireOneTarget(Target, "ID.target", context)
}

.resolveSiteIDTarget <- function(x, context, target = NULL) {
  if (is.null(x) || !"siteID" %in% names(x)) return(character())
  Sites <- .cleanTarget(x$siteID)
  Target <- .cleanTarget(target)
  if (length(Target)) {
    Missing <- setdiff(Target, Sites)
    if (length(Missing)) {
      stop(sprintf(
        "%s: siteID.target not found: %s. Available: %s.",
        context, paste(Missing, collapse = ", "), .targetChoices(Sites)
      ), call. = FALSE)
    }
    return(Target)
  }
  .requireOneTarget(Sites, "siteID.target", context)
}

.resolveSiteIDStorage <- function(siteID, config = NULL, context) {
  SiteID <- .requireOneTarget(siteID, "siteID.target", context)
  if (is.null(config)) return(SiteID)
  if (!is.list(config) || !length(config) ||
      !all(vapply(config, is.list, logical(1)))) {
    stop(sprintf(
      "%s: params.report.sites must be a non-empty YAML list.",
      context
    ), call. = FALSE)
  }
  ConfigID <- vapply(config, function(x) {
    if (is.null(x$siteID) || is.list(x$siteID) || length(x$siteID) != 1L) {
      return(NA_character_)
    }
    trimws(as.character(x$siteID))
  }, character(1))
  if (anyNA(ConfigID) || any(!nzchar(ConfigID)) || anyDuplicated(ConfigID)) {
    stop(sprintf(
      "%s: params.report.sites must contain unique scalar siteID values.",
      context
    ), call. = FALSE)
  }
  i <- match(SiteID, ConfigID)
  if (is.na(i)) {
    stop(sprintf(
      "%s: siteID.target not configured: %s.",
      context, SiteID
    ), call. = FALSE)
  }
  StorageID <- config[[i]][["siteID.storage"]]
  if (is.null(StorageID)) return(SiteID)
  if (is.list(StorageID) || length(StorageID) != 1L ||
      is.na(StorageID) || !nzchar(trimws(as.character(StorageID)))) {
    stop(sprintf(
      "%s: siteID.storage for %s must be one non-empty value.",
      context, SiteID
    ), call. = FALSE)
  }
  trimws(as.character(StorageID))
}

.slopePeriods <- function(x, idg, level, context) {
  Required <- c("IDg", "level", "Hs", "s", "lo", "b", "IDm", "Ts", "Go", "VSo")
  if (is.null(x) || !is.data.frame(x)) {
    stop(sprintf("%s: ShearTable must be a table.", context), call. = FALSE)
  }
  Missing <- setdiff(Required, names(x))
  if (length(Missing)) {
    stop(sprintf(
      "%s: ShearTable missing columns: %s.",
      context, paste(Missing, collapse = ", ")
    ), call. = FALSE)
  }
  IDgTarget <- .cleanTarget(idg)
  LevelTarget <- .cleanTarget(level)
  if (!length(IDgTarget) || !length(LevelTarget)) {
    stop(sprintf(
      "%s: IDg and level targets must be non-empty.",
      context
    ), call. = FALSE)
  }
  .one <- function(values) {
    Values <- unique(values)
    Values <- Values[!is.na(Values)]
    if (length(Values) != 1L) {
      stop(sprintf(
        "%s: expected one value within each IDg-level group.",
        context
      ), call. = FALSE)
    }
    Values
  }
  OUT <- data.table::as.data.table(x)[
    IDg %in% IDgTarget & level %in% LevelTarget,
    .(
      Hs = .one(Hs),
      s = .one(s),
      lo = .one(lo),
      b = .one(b),
      beta = round(atan(1 / .one(s)) * 180 / pi, 1),
      nIDm = data.table::uniqueN(IDm),
      Ts.min = min(Ts, na.rm = TRUE),
      Ts.max = max(Ts, na.rm = TRUE),
      Ts.med = median(Ts, na.rm = TRUE),
      Go.min = min(Go, na.rm = TRUE),
      Go.max = max(Go, na.rm = TRUE),
      VSo.min = min(VSo, na.rm = TRUE),
      VSo.max = max(VSo, na.rm = TRUE)
    ),
    by = .(IDg, level)
  ][order(IDg, level)]
  if (!nrow(OUT)) {
    stop(sprintf(
      "%s: no rows for IDg and level targets.",
      context
    ), call. = FALSE)
  }
  if (anyDuplicated(OUT[, .(IDg, level)])) {
    stop(sprintf("%s: periods are not unique by IDg and level.", context),
         call. = FALSE)
  }
  OUT
}

.selectASCETable <- function(
  x,
  context,
  idTarget = NULL,
  siteID = NULL,
  vs30,
  p = NULL,
  spectrum = c("design", "mcer")
) {
  if (is.null(x) || !is.data.frame(x) || !nrow(x)) {
    stop(sprintf("%s: ASCETable must be a non-empty table.", context), call. = FALSE)
  }
  Schema <- c(
    "Spectrum", "siteID", "Vs30", "ID", "p", "Tn", "SaF",
    "SDS", "SD1", "SMS", "SM1"
  )
  if (!identical(names(x), Schema)) {
    stop(sprintf(
      "%s: ASCETable schema must be exactly: %s.",
      context, paste(Schema, collapse = ", ")
    ), call. = FALSE)
  }
  Levels <- unique(as.character(x$Spectrum))
  if (!all(c("design", "mcer") %in% Levels) ||
      length(setdiff(Levels, c("design", "mcer", "code")))) {
    stop(sprintf(
      "%s: ASCETable Spectrum must contain design and mcer (code optional).",
      context
    ), call. = FALSE)
  }

  SiteID <- .cleanTarget(siteID)
  SiteID <- .resolveSiteIDTarget(x, context, target = SiteID)
  if (length(SiteID) != 1L) {
    stop(sprintf(
      "%s: siteID.target must select exactly one siteID.",
      context
    ), call. = FALSE)
  }
  IDs <- .resolveIDTarget(
    x,
    context,
    target = idTarget,
    siteID = SiteID
  )
  if (length(IDs) != 1L) {
    stop(sprintf(
      "%s: ID.target must select exactly one ID.",
      context
    ), call. = FALSE)
  }

  Vs30Target <- suppressWarnings(as.numeric(as.character(vs30)))
  SpectrumTarget <- .cleanTarget(spectrum)
  if (!length(Vs30Target) ||
      any(!is.finite(Vs30Target)) ||
      any(Vs30Target <= 0) ||
      anyDuplicated(Vs30Target)) {
    stop(sprintf(
      "%s: Vs30 target must contain unique finite positive values.",
      context
    ), call. = FALSE)
  }
  if (!length(SpectrumTarget)) {
    stop(sprintf(
      "%s: Spectrum target must be non-empty.",
      context
    ), call. = FALSE)
  }

  DT <- data.table::as.data.table(x)[
    ID %in% IDs &
      siteID %in% SiteID &
      Vs30 %in% Vs30Target &
      Spectrum %in% SpectrumTarget
  ]
  if (!nrow(DT)) {
    stop(sprintf(
      "%s: ASCETable has no rows for the selected targets.",
      context
    ), call. = FALSE)
  }
  PTarget <- .cleanTarget(p)
  if (!length(PTarget)) PTarget <- .cleanTarget(DT$p)
  if (!length(PTarget)) {
    stop(sprintf(
      "%s: selected ASCETable cells have no p values.",
      context
    ), call. = FALSE)
  }
  DT <- DT[.matchP(p, PTarget)]
  if (!nrow(DT)) {
    stop(sprintf(
      "%s: ASCETable has no rows for the selected p target.",
      context
    ), call. = FALSE)
  }

  Coverage <- data.table::CJ(
    Spectrum = SpectrumTarget,
    Vs30 = Vs30Target,
    p = PTarget,
    unique = TRUE
  )
  OK <- vapply(seq_len(nrow(Coverage)), function(i) {
    any(
      DT$Spectrum %in% Coverage$Spectrum[[i]] &
        DT$Vs30 %in% Coverage$Vs30[[i]] &
        .matchP(DT$p, Coverage$p[[i]])
    )
  }, logical(1))
  if (any(!OK)) {
    stop(sprintf(
      "%s: ASCETable does not cover every requested Spectrum, Vs30, and p combination.",
      context
    ), call. = FALSE)
  }
  if (anyNA(DT) ||
      any(!is.finite(DT$Vs30)) ||
      any(DT$Vs30 <= 0) ||
      any(!is.finite(DT$Tn)) ||
      any(DT$Tn < 0) ||
      any(!is.finite(DT$SaF)) ||
      any(DT$SaF <= 0) ||
      any(!is.finite(DT$SDS)) ||
      any(DT$SDS <= 0) ||
      any(!is.finite(DT$SD1)) ||
      any(DT$SD1 <= 0) ||
      any(!is.finite(DT$SMS)) ||
      any(DT$SMS <= 0) ||
      any(!is.finite(DT$SM1)) ||
      any(DT$SM1 <= 0)) {
    stop(sprintf(
      paste0(
        "%s: selected ASCETable values must be complete, with nonnegative ",
        "periods and positive finite spectra and design parameters."
      ),
      context
    ), call. = FALSE)
  }
  Parameters <- unique(DT[, .(
    siteID, Vs30, ID, p, SDS, SD1, SMS, SM1
  )])
  if (anyDuplicated(Parameters[, .(siteID, Vs30, ID, p)])) {
    stop(sprintf(
      paste0(
        "%s: SDS, SD1, SMS, and SM1 must be constant within each ",
        "(siteID, Vs30, ID, p) cell."
      ),
      context
    ), call. = FALSE)
  }
  Tolerance <- 1e-10
  SMSExpected <- 1.5 * DT$SDS
  SM1Expected <- 1.5 * DT$SD1
  SMSScale <- pmax(1, abs(DT$SMS), abs(SMSExpected))
  SM1Scale <- pmax(1, abs(DT$SM1), abs(SM1Expected))
  if (any(abs(DT$SMS - SMSExpected) > Tolerance * SMSScale) ||
      any(abs(DT$SM1 - SM1Expected) > Tolerance * SM1Scale)) {
    stop(sprintf(
      "%s: ASCETable must satisfy SMS = 1.5 * SDS and SM1 = 1.5 * SD1.",
      context
    ), call. = FALSE)
  }
  if (anyDuplicated(DT[, .(Spectrum, siteID, Vs30, ID, p, Tn)])) {
    stop(sprintf(
      "%s: selected ASCETable rows duplicate the natural key.",
      context
    ), call. = FALSE)
  }
  DT
}

.resolveValueTarget <- function(values, targetName, context, target = NULL) {
  Values <- .cleanTarget(values)
  Target <- .cleanTarget(target)
  if (length(Target)) {
    Missing <- setdiff(Target, Values)
    if (length(Missing)) {
      stop(sprintf(
        "%s: %s not found: %s. Available: %s.",
        context, targetName, paste(Missing, collapse = ", "), .targetChoices(Values)
      ), call. = FALSE)
    }
    return(Target)
  }
  .requireOneTarget(Values, targetName, context)
}

.captionFormat <- function(x) {
  Num <- suppressWarnings(as.numeric(x))
  if (length(Num) == length(x) && all(is.finite(Num))) {
    return(prettyNum(Num, big.mark = ",", scientific = FALSE))
  }
  as.character(x)
}

.captionField <- function(name, label, envir = parent.frame(), unit = NULL) {
  Value <- .currentTarget(name, envir = envir)
  Value <- .cleanTarget(Value)
  if (!length(Value)) return(character())
  if (length(Value) > 4L) Value <- c(head(Value, 4L), sprintf("... %d more", length(Value) - 4L))
  Text <- paste(.captionFormat(Value), collapse = ", ")
  if (!is.null(unit) && nzchar(unit)) Text <- paste(Text, unit)
  sprintf("%s: %s", label, Text)
}

.captionSite <- function(envir = parent.frame()) {
  Site <- .currentTarget("siteID.target", envir = envir)
  Site <- .captionFormat(.cleanTarget(Site))
  if (length(Site)) return(sprintf("Site: %s", paste(Site, collapse = ", ")))

  Params <- .currentTarget("params", envir = envir)
  if (is.list(Params) && !is.null(Params$site) && nzchar(Params$site)) {
    return(sprintf("Site: %s", Params$site))
  }
  character()
}

# Shared TRT palette and mixture-band recolor for the GMPE figures: one
# definition for report chapters and slide decks alike.
.TrtColors <- c(
  ASC = "#E41A1C",
  SCC = "#377EB8",
  SIF = "#4DAF4A",
  SIS = "#984EA3"
)

.paintFillSeries <- function(plot, color) {
  if (missing(color) || length(color) != 1L || !nzchar(color)) return(plot)
  plot$x$hc_opts$series <- lapply(plot$x$hc_opts$series, function(Series) {
    if (identical(Series$type, "areasplinerange")) Series$color <- color
    Series
  })
  plot
}

# LaTeX table headers: compose one flextable header cell per column from a
# named vector of report-notation symbols (no snake case, no bracketed
# units — units belong in the caption). Requires equatags/katex, both
# resolved at hydration; falls back to the plain names when absent.
.mathHeader <- function(table, symbols) {
  if (!requireNamespace("equatags", quietly = TRUE)) return(table)
  COLS <- intersect(names(symbols), table$header$col_keys)
  for (j in COLS) {
    table <- flextable::compose(
      table,
      part = "header", j = j,
      value = flextable::as_paragraph(flextable::as_equation(symbols[[j]]))
    )
  }
  table
}

# Executive geometries at the minimum, lower central and maximum height.
.summaryIDg <- function(table, target) {
  DT <- unique(table[IDg %in% target, .(IDg, Hs)])
  AUX <- sort(unique(DT$Hs))
  DT[Hs %in% AUX[c(1L, ceiling(length(AUX) / 2), length(AUX))], IDg]
}

# Match performance columns to the plot band ending at each threshold.
# Word cell backgrounds require opaque colors, composited here on white.
.damageTable <- function(table, cuts, colors) {
  COLS <- as.character(signif(cuts, 3L))
  AUX <- vapply(colors[seq_along(cuts)], function(x) {
    x <- as.numeric(strsplit(substr(x, 6L, nchar(x) - 1L), ",", fixed = TRUE)[[1L]])
    x <- round(x[1:3] * x[4] + 255 * (1 - x[4]))
    grDevices::rgb(red = x[1], green = x[2], blue = x[3], maxColorValue = 255)
  }, character(1))
  table <- flextable::set_header_labels(table, values = setNames(paste0(COLS, "%"), COLS))
  for (i in seq_along(COLS)) {
    table <- flextable::bg(table, j = COLS[i], bg = AUX[i], part = "all")
  }
  table
}

# Local project content: chapters under _local/ belong to the project, not
# to the shared scaffold, and hydration never replaces them. A template
# ships blank (an HTML comment only), so a chapter renders only once the
# project writes it. Emits the file when it carries content, nothing when
# it does not, so an unused slot leaves no heading behind.
.localChapter <- function(stem, root, heading = NULL, level = 2L) {
  FILE <- file.path(root, "_local", stem)
  if (!file.exists(FILE)) return(invisible(FALSE))
  TEXT <- readLines(FILE, warn = FALSE)
  BODY <- trimws(sub("<!--.*?-->", "", paste(TEXT, collapse = "\n")))
  if (!nzchar(BODY)) return(invisible(FALSE))
  if (!is.null(heading) && nzchar(heading)) {
    cat("\n", strrep("#", level), " ", heading, "\n\n", sep = "")
  }
  cat(TEXT, sep = "\n")
  cat("\n")
  invisible(TRUE)
}
# nolint end
