# nolint start
.loadOQ <- function(name) {
  FILE <- file.path(root, "oq", "data", paste0(name, ".Rds"))
  if (!file.exists(FILE)) return(NULL)
  DT <- readRDS(FILE)
  if ("p" %in% names(DT)) DT[p == "0.1", p := "0.10"]
  DT
}

if (!exists("UHSTable"))   UHSTable   <- .loadOQ("UHSTable")
if (!exists("GMPETable"))  GMPETable  <- .loadOQ("GMPETable")
if (!exists("ScenarioGMPETable")) ScenarioGMPETable <- .loadOQ("ScenarioGMPETable")
if (!exists("ScenarioTable")) ScenarioTable <- .loadOQ("ScenarioTable")
if (!exists("MCETable"))   MCETable   <- .loadOQ("MCETable")
if (!exists("AEPTable"))   AEPTable   <- .loadOQ("AEPTable")
if (!exists("AEPSTable"))  AEPSTable  <- .loadOQ("AEPSTable")
if (!exists("DnTable"))    DnTable    <- .loadOQ("DnTable")
if (!exists("kmaxTable"))  kmaxTable  <- .loadOQ("kmaxTable")
if (!exists("ShearTable")) ShearTable <- .loadOQ("ShearTable")
if (!exists("RMwTable"))   RMwTable   <- .loadOQ("RMwTable")
if (!exists("DEQTable"))   DEQTable   <- .loadOQ("DEQTable")
if (!exists("ASCETable"))  ASCETable  <- .loadOQ("ASCETable")
rm(.loadOQ)

# ── UHSTable ──────────────────────────────────────────────────────────────────
if (!is.null(UHSTable) && !exists("Tn.PGA")) {
  TR.data    <- sort(as.numeric(unique(UHSTable$TR)))
  Tn.gmdp    <- sort(unique(UHSTable$Tn))
  p.gmdp     <- unique(UHSTable[p != "std"]$p)
  Tn.PGA     <- min(UHSTable$Tn)
  Vref.data  <- sort(as.numeric(unique(UHSTable[grepl("\\.site$", ID)]$Vref)))
  Vs30.gmdp  <- sort(setdiff(as.numeric(unique(UHSTable$Vs30)), Vref.data))

  AUX <- c("1500"="A/B","1250"="B","800"="B","760"="B/C","560"="C","360"="C/D","270"="D","180"="D/E")
  Site.gmdp  <- AUX[as.character(Vs30.gmdp)]
  Site.gmdp[is.na(Site.gmdp)] <- paste0("Vs30=", Vs30.gmdp[is.na(Site.gmdp)])
  Site.label <- paste0(Site.gmdp, " (", Vs30.gmdp, ")")
  rm(AUX)

  if ("siteID" %in% names(UHSTable)) {
    siteID.data <- sort(unique(as.character(UHSTable$siteID)))
    siteID.data <- siteID.data[!is.na(siteID.data) & nzchar(siteID.data)]
    if (!exists("siteID.gmdp")) {
      siteID.gmdp <- siteID.data
    } else {
      siteID.gmdp <- as.character(siteID.gmdp)
      OK <- siteID.gmdp %in% siteID.data
      if (any(!OK)) {
        stop(sprintf(
          "siteID.gmdp not in UHSTable$siteID: %s. Available: %s",
          paste(siteID.gmdp[!OK], collapse = ", "),
          paste(siteID.data, collapse = ", ")
        ))
      }
      rm(OK)
    }
  }

  if (!exists("TR.gmdp")) {
    TR.gmdp <- TR.data
  } else {
    TR.gmdp <- sort(unique(as.numeric(TR.gmdp)))
    OK <- TR.gmdp %in% TR.data
    if (any(!OK)) stop(sprintf("TR.gmdp not in UHSTable$TR: %s", paste(TR.gmdp[!OK], collapse = ", ")))
    rm(OK)
  }

  if (!exists("Vref.gmdp")) {
    Vref.gmdp <- Vref.data
  } else {
    Vref.gmdp <- sort(unique(as.numeric(Vref.gmdp)))
    OK <- sapply(Vref.gmdp, function(v) any(abs(Vref.data - v) < 1e-10))
    if (any(!OK)) stop(sprintf("Vref.gmdp not in UHSTable$Vref: %s", paste(Vref.gmdp[!OK], collapse = ", ")))
    rm(OK)
  }

  TR.label <- prettyNum(TR.gmdp, big.mark = ",", scientific = FALSE)
}

# ── DnTable ───────────────────────────────────────────────────────────────────
if (!is.null(DnTable) && !exists("IDg.gmdp")) {
  IDg.gmdp <- unique(DnTable$IDg)
  IDm.gmdp <- unique(DnTable$IDm)
  IDn.gmdp <- setdiff(unique(DnTable$IDn), "ensemble")
  IDg.gmdp <- IDg.gmdp[order(as.numeric(sub("^S", "", IDg.gmdp)))]
  if (!exists("Dn_units")) Dn_units <- "mm"
}

# ── kmaxTable ─────────────────────────────────────────────────────────────────
if (!is.null(kmaxTable) && !exists("Da.data")) {
  Da.data <- sort(as.numeric(unique(kmaxTable$Da)))
  if (!exists("Da.gmdp")) {
    Da.gmdp <- Da.data
  } else {
    Da.gmdp <- sort(unique(as.numeric(Da.gmdp)))
    OK <- sapply(Da.gmdp, function(v) any(abs(Da.data - v) < 1e-10))
    if (any(!OK)) stop(sprintf(
      "Da.gmdp not in kmaxTable$Da: %s. Update oq/data/data.R",
      paste(Da.gmdp[!OK], collapse = ", ")
    ))
    rm(OK)
  }
}
# nolint end
