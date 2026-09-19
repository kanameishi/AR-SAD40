# nolint start
# Project-specific PSHA context shared by Methodology, Results and the
# executive summary. The calculation JSON is the source of truth; table
# contents provide safe fallbacks for older projects.

.hazardDefault <- function(x, default) {
  if (is.null(x) || !length(x)) default else x
}

ID.base <- if (exists("ID.gmdp", inherits = TRUE) && length(ID.gmdp) == 1L) {
  ID.gmdp
} else {
  sub("\\.max$", "", .currentTarget("ID.target")[1L])
}

Hazard.config <- list(
  modelID = ID.base,
  siteLabel = NA_character_,
  description = NA_character_,
  ssmFile = NA_character_,
  ssmLabel = NA_character_,
  ssmBranches = NA_integer_,
  gmmFile = NA_character_,
  gmmLabel = NA_character_,
  trt = character(),
  minimumMagnitude = NA_real_,
  maximumDistance = NA_real_,
  truncationLevel = NA_real_,
  outputMean = NA,
  outputStd = NA,
  individualCurves = NA,
  outputQuantiles = numeric(),
  rockMean = NA,
  rockQuantiles = numeric()
)
Hazard.sourceIndex <- data.table(
  providerID = character(),
  sourceLabel = character(),
  tectonicRegion = character()
)

SITE.candidates <- if (exists("params", inherits = TRUE)) {
  c(params$site, params$location, params$project_id)
} else {
  character()
}
SITE.candidates <- as.character(SITE.candidates)
SITE.candidates <- SITE.candidates[
  !is.na(SITE.candidates) & nzchar(trimws(SITE.candidates))
]
if (length(SITE.candidates)) Hazard.config$siteLabel <- SITE.candidates[1L]

CALC.dir <- file.path(root, "oq", "calcs", "classical")
CALC.files <- if (dir.exists(CALC.dir)) {
  sort(list.files(CALC.dir, pattern = "\\.json$", full.names = TRUE))
} else {
  character()
}

CALC <- NULL
if (length(CALC.files) && requireNamespace("jsonlite", quietly = TRUE)) {
  for (FILE in CALC.files) {
    AUX <- tryCatch(jsonlite::fromJSON(FILE, simplifyVector = FALSE), error = function(e) NULL)
    if (!is.null(AUX) && identical(as.character(AUX$modelID), as.character(ID.base))) {
      CALC <- AUX
      break
    }
  }
}

if (!is.null(CALC)) {
  Hazard.config$modelID <- as.character(CALC$modelID)
  Hazard.config$description <- as.character(.hazardDefault(CALC$description, NA_character_))
  Hazard.config$ssmFile <- as.character(.hazardDefault(CALC$ssmFile, NA_character_))
  Hazard.config$gmmFile <- as.character(.hazardDefault(CALC$gmmFile, NA_character_))
  Hazard.config$trt <- names(.hazardDefault(CALC$TRT, list()))
  Hazard.config$minimumMagnitude <- as.numeric(
    .hazardDefault(CALC$job$calculation$minimum_magnitude, NA_real_)
  )
  Hazard.config$maximumDistance <- as.numeric(
    unlist(
      .hazardDefault(CALC$job$calculation$maximum_distance, NA_real_),
      use.names = FALSE
    )[1L]
  )
  Hazard.config$truncationLevel <- as.numeric(
    .hazardDefault(CALC$job$calculation$truncation_level, NA_real_)
  )
  Hazard.config$outputMean <- isTRUE(CALC$job$output$mean)
  Hazard.config$outputStd <- isTRUE(CALC$job$output$std)
  Hazard.config$individualCurves <- isTRUE(CALC$job$output$individual_curves)
  Hazard.config$outputQuantiles <- as.numeric(unlist(.hazardDefault(
    CALC$job$output$quantile_hazard_curves,
    numeric()
  )))

  if (!is.na(Hazard.config$ssmFile)) {
    Hazard.config$ssmLabel <- sub(
      "^ssmLT_", "",
      tools::file_path_sans_ext(basename(Hazard.config$ssmFile))
    )
    SSM.path <- path.expand(file.path(
      as.character(.hazardDefault(CALC$ssmDir, "")),
      Hazard.config$ssmFile
    ))
    if (file.exists(SSM.path)) {
      TXT <- paste(readLines(SSM.path, warn = FALSE), collapse = " ")
      POS <- regexpr(
        "<logicTreeBranchSet[^>]*uncertaintyType=\"sourceModel\"[^>]*>.*?</logicTreeBranchSet>",
        TXT,
        perl = TRUE
      )
      if (POS[1L] > 0L) {
        BLOCK <- regmatches(TXT, POS)
        HITS <- gregexpr("<logicTreeBranch[[:space:]]+branchID=", BLOCK, perl = TRUE)[[1L]]
        Hazard.config$ssmBranches <- if (HITS[1L] < 0L) 0L else length(HITS)
      }
      rm(TXT, POS)
      if (exists("BLOCK", inherits = FALSE)) rm(BLOCK)
      if (exists("HITS", inherits = FALSE)) rm(HITS)
    }
    INDEX.path <- file.path(
      dirname(dirname(SSM.path)),
      "support",
      sprintf("%s_sources_index.csv", Hazard.config$ssmLabel)
    )
    if (file.exists(INDEX.path)) {
      INDEX <- tryCatch(
        data.table::fread(INDEX.path, showProgress = FALSE),
        error = function(e) NULL
      )
      REQUIRED <- c("provider_id", "model_id", "model_name", "source_name", "tectonic_region")
      if (!is.null(INDEX) && all(REQUIRED %in% names(INDEX))) {
        Hazard.sourceIndex <- unique(INDEX[, .(
          providerID = as.character(provider_id),
          sourceLabel = ifelse(
            provider_id == model_id & !is.na(model_name) & nzchar(model_name),
            as.character(model_name),
            as.character(source_name)
          ),
          tectonicRegion = as.character(tectonic_region)
        )])
        Hazard.sourceIndex[
          is.na(sourceLabel) | !nzchar(sourceLabel),
          sourceLabel := providerID
        ]
      }
      if (exists("INDEX", inherits = FALSE)) rm(INDEX)
      rm(REQUIRED)
    }
    rm(INDEX.path)
    rm(SSM.path)
  }
  if (!is.na(Hazard.config$gmmFile)) {
    Hazard.config$gmmLabel <- sub(
      "^gmmLT_", "",
      tools::file_path_sans_ext(basename(Hazard.config$gmmFile))
    )
  }
}

if (!length(Hazard.config$trt) &&
    exists("GMPETable", inherits = TRUE) &&
    !is.null(GMPETable) && nrow(GMPETable)) {
  Hazard.config$trt <- sort(unique(GMPETable$TRT))
}

# The SSM exists for every project: the classical-calculation metadata that
# describes it is a producer contract, never an optional extra.
if (is.na(Hazard.config$ssmLabel) || !nzchar(Hazard.config$ssmLabel) ||
    !is.finite(Hazard.config$minimumMagnitude) ||
    !is.finite(Hazard.config$maximumDistance) ||
    !is.finite(Hazard.config$truncationLevel)) {
  stop(
    "hazardContext: incomplete classical calculation metadata for model ",
    Hazard.config$modelID,
    " - oq/calcs/classical/<ID>.json must declare ssmFile, minimum_magnitude, ",
    "maximum_distance and truncation_level.",
    call. = FALSE
  )
}

if (exists("UHSTable", inherits = TRUE) &&
    !is.null(UHSTable) && nrow(UHSTable)) {
  # The classical rock product is the base model at Vs30 = 760 m/s. Site
  # amplification products (including the quantiles available at 800 m/s)
  # must never be used to infer statistics for reference rock.
  BASE <- UHSTable[ID == Hazard.config$modelID & Vs30 == 760]
  SITE.target <- .currentTarget("siteID.target")
  if ("siteID" %in% names(BASE) && length(SITE.target) == 1L) {
    BASE <- BASE[siteID %in% SITE.target]
  }
  BASE.p <- unique(BASE[, as.character(p)])
  Hazard.config$rockMean <- "mean" %in% BASE.p
  Hazard.config$rockQuantiles <- suppressWarnings(as.numeric(setdiff(BASE.p, "mean")))
  Hazard.config$rockQuantiles <- Hazard.config$rockQuantiles[
    is.finite(Hazard.config$rockQuantiles)
  ]
  if (is.na(Hazard.config$outputMean)) {
    Hazard.config$outputMean <- "mean" %in% BASE.p
  }
  if (!length(Hazard.config$outputQuantiles)) {
    Hazard.config$outputQuantiles <- suppressWarnings(as.numeric(setdiff(BASE.p, "mean")))
    Hazard.config$outputQuantiles <- Hazard.config$outputQuantiles[
      is.finite(Hazard.config$outputQuantiles)
    ]
  }
  rm(BASE, BASE.p, SITE.target)
}

GMM.active <- if (exists("GMPETable", inherits = TRUE) &&
                  !is.null(GMPETable) && nrow(GMPETable)) {
  GMPETable[
    model != "ensemble" & TRT %in% Hazard.config$trt,
    .(models = list(sort(unique(gsub("^\\[|\\]$", "", model))))),
    by = TRT
  ][order(TRT)]
} else {
  data.table(TRT = character(), models = list())
}

Hazard.scope <- list(
  TR = sort(unique(UHSTable$TR)),
  Tn = sort(unique(UHSTable$Tn)),
  Vs30 = sort(unique(UHSTable$Vs30)),
  ITo = if (exists("AEPTable", inherits = TRUE) &&
            !is.null(AEPTable) && nrow(AEPTable)) {
    sort(unique(AEPTable$ITo))
  } else {
    numeric()
  }
)

rm(ID.base, SITE.candidates, CALC.dir, CALC.files, CALC, .hazardDefault)
if (exists("FILE", inherits = FALSE)) rm(FILE)
if (exists("AUX", inherits = FALSE)) rm(AUX)

# Logic-tree clause shared by the methodology chapters and the executive
# summary; empty for single-branch models (SAM), populated for ARB and AUS.
TREE.ES <- ""
TREE.EN <- ""
if (is.finite(Hazard.config$ssmBranches) && Hazard.config$ssmBranches > 1L) {
  TREE.ES <- sprintf(", cuyo árbol lógico comprende %s ramas", Hazard.config$ssmBranches)
  TREE.EN <- sprintf(", with a logic tree comprising %s branches", Hazard.config$ssmBranches)
}

# Adopted-model paragraph hydrated inline by the methodology chapters.
MODEL.ES <- sprintf(
  paste0(
    "Se adoptó el modelo regional de fuentes **%s**%s, junto con árboles ",
    "GMM para los regímenes %s. El dominio de cálculo comienza ",
    "en $M_w$ %s, considera fuentes hasta %s km y trunca la distribución ",
    "residual de los GMM en $\\pm%s\\sigma$."
  ),
  Hazard.config$ssmLabel,
  TREE.ES,
  paste(Hazard.config$trt, collapse = ", "),
  .fmt(Hazard.config$minimumMagnitude, 1),
  .fmti(Hazard.config$maximumDistance),
  .fmt(Hazard.config$truncationLevel, 1)
)
MODEL.EN <- sprintf(
  paste0(
    "The assessment adopted the regional source model **%s**%s, together ",
    "with GMM trees for the %s regimes. The calculation domain begins ",
    "at $M_w$ %s, considers sources up to %s km, and truncates the ",
    "residual distribution of the GMMs at $\\pm%s\\sigma$."
  ),
  Hazard.config$ssmLabel,
  TREE.EN,
  paste(Hazard.config$trt, collapse = ", "),
  .fmt(Hazard.config$minimumMagnitude, 1),
  .fmti(Hazard.config$maximumDistance),
  .fmt(Hazard.config$truncationLevel, 1)
)

BRANCH.ES <- sprintf(
  paste0(
    "Se adoptó el modelo regional de fuentes **%s**%s. ",
    "El cálculo considera magnitudes desde $M_w$ %s, distancias fuente--sitio ",
    "de hasta %s km y trunca la distribución residual de los GMM en ",
    "$\\pm%s\\sigma$."
  ),
  Hazard.config$ssmLabel,
  TREE.ES,
  .fmt(Hazard.config$minimumMagnitude, 1),
  .fmti(Hazard.config$maximumDistance),
  .fmt(Hazard.config$truncationLevel, 1)
)
BRANCH.EN <- sprintf(
  paste0(
    "The analysis adopted the regional seismic source model **%s**%s. ",
    "Calculations use a minimum moment magnitude of $M_w=%s$ and a maximum ",
    "source-to-site integration distance of %s km; the GMM residual distribution ",
    "is truncated at $\\pm%s\\sigma$."
  ),
  Hazard.config$ssmLabel,
  TREE.EN,
  .fmt(Hazard.config$minimumMagnitude, 1),
  .fmti(Hazard.config$maximumDistance),
  .fmt(Hazard.config$truncationLevel, 1)
)
# nolint end
