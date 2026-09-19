# nolint start
source(file.path(root, "scripts", "setup", "hazardContext.R"))

if (!exists("ID.target", inherits = FALSE) || !length(ID.target)) {
  ID.target <- .resolveIDTarget(
    UHSTable,
    "hazard summary",
    base = TRUE,
    siteID = .currentTarget("siteID.target")
  )
}
if (!exists("p.target", inherits = FALSE) || !length(p.target)) p.target <- "mean"

UHS <- UHSTable
if ("siteID" %in% names(UHS)) {
  if (!exists("siteID.target", inherits = FALSE)) {
    siteID.target <- .resolveSiteIDTarget(UHS, "hazard summary")
  }
  if (length(siteID.target) != 1L) stop("hazard summary: set siteID.target to one siteID.")
  UHS <- UHS[siteID %in% siteID.target]
}

PGA <- UHS[
  ID == ID.target & Tn == Tn.PGA & .matchP(p, p.target),
  .(Vs30, TR, p, SaF)
][order(Vs30, TR, p)]

DUP <- PGA[, .N, by = .(Vs30, TR, p)][N != 1L]
if (nrow(DUP)) stop("hazard summary: PGA is not unique by Vs30, TR, p.")

# Mean spectral peak in reference rock. The classical calculation does not
# provide rock fractiles at Vs30 = 760 m/s.
SaPeak <- UHS[
  ID == ID.target & Vs30 == 760 & .matchP(p, "mean"),
  .(SaF = max(SaF), Tn = Tn[which.max(SaF)]),
  by = .(TR, p)
][order(TR, p)]

Hazard.TR.selected <- c(500, 10000)
Hazard.Tn.selected <- c(Tn.PGA, 1)
ROCK <- UHS[ID == ID.target & Vs30 == 760 & .matchP(p, "mean")]
MISSING.TR <- setdiff(Hazard.TR.selected, unique(ROCK$TR))
MISSING.TN <- setdiff(Hazard.Tn.selected, unique(ROCK$Tn))
if (length(MISSING.TR)) {
  stop(sprintf(
    "hazard summary: reference-rock mean is missing required TR: %s.",
    paste(MISSING.TR, collapse = ", ")
  ))
}
if (length(MISSING.TN)) {
  stop(sprintf(
    "hazard summary: reference-rock mean is missing required Tn: %s.",
    paste(MISSING.TN, collapse = ", ")
  ))
}

# Leading by-source contributions at the same UHS ordinates used in the
# executive result paragraph. Contributions are interpolated in log-log space
# on each provider curve and normalized across the available providers.
Hazard.source <- data.table(
  TR = numeric(), Tn = numeric(), providerID = character(),
  AEP = numeric(), share = numeric(), rank = integer(),
  sourceLabel = character(), tectonicRegion = character(),
  sourceRegime = character(), sourceDisplay = character(),
  sourceRegimeEN = character(), sourceDisplayEN = character()
)
if (
  exists("AEPSTable", inherits = TRUE) &&
  !is.null(AEPSTable) &&
  nrow(AEPSTable) &&
  "providerID" %in% names(AEPSTable)
) {
  AS <- AEPSTable[ID == Hazard.config$modelID & Vs30 == 760 & .matchP(p, "mean")]
  if ("siteID" %in% names(AS)) AS <- AS[siteID %in% siteID.target]

  .interpSourceAEP <- function(sa, aep, target) {
    DT <- unique(data.table(sa = as.numeric(sa), aep = as.numeric(aep)))
    DT <- DT[is.finite(sa) & is.finite(aep) & sa > 0 & aep > 0][order(sa)]
    if (nrow(DT) < 2L || target < min(DT$sa) || target > max(DT$sa)) return(NA_real_)
    exp(approx(log(DT$sa), log(DT$aep), xout = log(target), ties = "ordered")$y)
  }

  CASES <- UHS[
    ID == ID.target &
      Vs30 == 760 &
      TR %in% Hazard.TR.selected &
      Tn %in% Hazard.Tn.selected &
      .matchP(p, "mean"),
    .(TR, Tn, SaF)
  ]

  if (nrow(CASES)) {
    SOURCE <- rbindlist(lapply(seq_len(nrow(CASES)), function(i) {
      CASE <- CASES[i]
      RATE <- AS[Tn == CASE$Tn, .(
        AEP = .interpSourceAEP(Sa, AEP, CASE$SaF)
      ), by = providerID][is.finite(AEP) & AEP > 0][order(-AEP)]
      if (!nrow(RATE)) return(NULL)
      RATE[, share := AEP / sum(AEP)]
      RATE[, rank := seq_len(.N)]
      RATE[rank <= 3L, .(TR = CASE$TR, Tn = CASE$Tn, providerID, AEP, share, rank)]
    }), use.names = TRUE, fill = TRUE)
    if (nrow(SOURCE)) {
      Hazard.source <- SOURCE
      Hazard.source[, sourceLabel := providerID]
      Hazard.source[, tectonicRegion := NA_character_]
      if (nrow(Hazard.sourceIndex)) {
        Hazard.source[Hazard.sourceIndex, on = "providerID", `:=`(
        sourceLabel = i.sourceLabel,
        tectonicRegion = i.tectonicRegion
        )]
      }
      TRT.LOWER <- tolower(Hazard.source$tectonicRegion)
      Hazard.source[, sourceRegime := fifelse(
        grepl("stable continental|\\bscc\\b", TRT.LOWER),
        "corteza continental estable",
        fifelse(
          grepl("active shallow|\\basc\\b", TRT.LOWER),
          "corteza superficial activa",
          fifelse(
            grepl("intraslab|intra-slab|\\bsis\\b", TRT.LOWER),
            "intraplaca de subducción",
            fifelse(
              grepl("subduction interface|\\bsif\\b", TRT.LOWER),
              "interfaz de subducción",
              NA_character_
            )
          )
        )
      )]
      Hazard.source[, sourceDisplay := ifelse(
        !is.na(sourceRegime) & nzchar(sourceRegime),
        sprintf("fuente `%s` (%s)", providerID, sourceRegime),
        sprintf("fuente `%s`", providerID)
      )]
      Hazard.source[, sourceRegimeEN := fifelse(
        grepl("stable continental|\\bscc\\b", TRT.LOWER),
        "stable continental crust",
        fifelse(
          grepl("active shallow|\\basc\\b", TRT.LOWER),
          "active shallow crust",
          fifelse(
            grepl("intraslab|intra-slab|\\bsis\\b", TRT.LOWER),
            "subduction intraslab",
            fifelse(
              grepl("subduction interface|\\bsif\\b", TRT.LOWER),
              "subduction interface",
              NA_character_
            )
          )
        )
      )]
      Hazard.source[, sourceDisplayEN := ifelse(
        !is.na(sourceRegimeEN) & nzchar(sourceRegimeEN),
        sprintf("source `%s` (%s)", providerID, sourceRegimeEN),
        sprintf("source `%s`", providerID)
      )]
      rm(TRT.LOWER)
    }
    rm(SOURCE)
  }

  rm(AS, CASES, .interpSourceAEP)
}

# Scope is resolved after the site target, so multisitio projects cannot mix
# exposure intervals from different manual site blocks.
AEP.scope <- if (exists("AEPTable", inherits = TRUE) &&
                 !is.null(AEPTable) && nrow(AEPTable)) {
  AEPTable[ID == Hazard.config$modelID]
} else {
  data.table()
}
if (nrow(AEP.scope) && "siteID" %in% names(AEP.scope)) {
  AEP.scope <- AEP.scope[siteID %in% siteID.target]
}
Hazard.scope <- list(
  TR = sort(unique(UHS$TR)),
  Tn = sort(unique(UHS$Tn)),
  Vs30 = sort(unique(UHS$Vs30)),
  ITo = if (nrow(AEP.scope) && "ITo" %in% names(AEP.scope)) {
    sort(unique(AEP.scope$ITo))
  } else {
    numeric()
  }
)
Hazard.PoE <- CJ(TR = Hazard.TR.selected, ITo = Hazard.scope$ITo)
Hazard.PoE[, POE := 1 - exp(-ITo / TR)]

rm(DUP, UHS, ROCK, MISSING.TR, MISSING.TN, AEP.scope)
# nolint end
