if (!exists("buildReportTable", mode = "function", inherits = TRUE)) {
  source(file.path("scripts", "tbl", "table.R"), local = TRUE)
}

.sensitivityRead <- function(path, required) {
  if (!file.exists(path)) {
    stop("The sensitivity product is not available: ", path, call. = FALSE)
  }
  DATA <- utils::read.csv(
    path,
    check.names = FALSE,
    stringsAsFactors = FALSE,
    na.strings = ""
  )
  Missing <- setdiff(required, names(DATA))
  if (length(Missing) > 0L) {
    stop("The sensitivity product has an invalid schema.", call. = FALSE)
  }
  DATA
}

.sensitivityModuli <- function(data) {
  Moduli <- sort(unique(data$modulusMPa))
  if (length(Moduli) < 2L || any(!is.finite(Moduli))) {
    stop("The sensitivity moduli are unavailable.", call. = FALSE)
  }
  Moduli
}

.sensitivityWide <- function(data, keys, moduli, digits) {
  Rows <- unique(data[keys])
  OUT <- Rows
  for (e in moduli) {
    Values <- vapply(seq_len(nrow(Rows)), function(i) {
      OK <- data$modulusMPa == e
      for (s in keys) OK <- OK & data[[s]] == Rows[[s]][i]
      Value <- data$value[OK]
      if (length(Value) != 1L || !is.finite(Value)) {
        stop("A sensitivity value is missing.", call. = FALSE)
      }
      Value
    }, numeric(1))
    OUT[[paste0("E", e)]] <- formatC(Values, format = "f", digits = digits)
  }
  OUT
}

buildCalculationSensitivitySteelTable <- function(path) {
  DATA <- .sensitivityRead(
    path,
    c("modulusMPa", "caseID", "resultantID", "value", "unit")
  )
  Moduli <- .sensitivityModuli(DATA)
  CaseCodes <- c(slip = "S", `no-slip` = "NS")
  ResultantLabels <- c(
    N = "$|N_\\theta|_{\\max}$",
    M = "$|M_\\theta|_{\\max}$",
    Q = "$|Q_\\theta|_{\\max}$"
  )
  UnitLabels <- c(
    "kN/m" = "kN/m",
    "kN-m/m" = "kN·m/m",
    "kN m/m" = "kN·m/m"
  )
  DATA <- DATA[
    order(
      match(DATA$caseID, names(CaseCodes)),
      match(DATA$resultantID, names(ResultantLabels))
    ),
    ,
    drop = FALSE
  ]
  Wide <- .sensitivityWide(DATA, c("caseID", "resultantID"), Moduli, 1L)
  Units <- vapply(seq_len(nrow(Wide)), function(i) {
    unname(UnitLabels[unique(DATA$unit[
      DATA$caseID == Wide$caseID[i] & DATA$resultantID == Wide$resultantID[i]
    ])])
  }, character(1))
  Output <- cbind(
    data.frame(
      Interface = unname(CaseCodes[Wide$caseID]),
      Resultant = unname(ResultantLabels[Wide$resultantID]),
      Unit = Units,
      stringsAsFactors = FALSE
    ),
    Wide[, paste0("E", Moduli), drop = FALSE]
  )
  if (anyNA(Output)) {
    stop("The steel sensitivity mapping is incomplete.", call. = FALSE)
  }
  buildReportTable(
    data = Output,
    headers = c("$I$", "$X$", "$u_X$", as.character(Moduli)),
    align = c("c", "l", "c", rep("r", length(Moduli)))
  )
}

buildCalculationSensitivityPlainTable <- function(path) {
  DATA <- .sensitivityRead(
    path,
    c("modulusMPa", "liningID", "checkID", "utilization", "checkStatus")
  )
  DATA$value <- DATA$utilization
  Moduli <- .sensitivityModuli(DATA)
  LiningLabels <- c(shotcrete = "100", plainConcrete150 = "150")
  CheckLabels <- c(
    `tension-face` = "$U_{N-M,\\max}$",
    `one-way-shear` = "$U_{V,\\max}$"
  )
  DATA <- DATA[
    order(
      match(DATA$liningID, names(LiningLabels)),
      match(DATA$checkID, names(CheckLabels))
    ),
    ,
    drop = FALSE
  ]
  Wide <- .sensitivityWide(DATA, c("liningID", "checkID"), Moduli, 2L)
  Output <- cbind(
    data.frame(
      Thickness = unname(LiningLabels[Wide$liningID]),
      Check = unname(CheckLabels[Wide$checkID]),
      stringsAsFactors = FALSE
    ),
    Wide[, paste0("E", Moduli), drop = FALSE]
  )
  if (anyNA(Output)) {
    stop("The plain-concrete sensitivity mapping is incomplete.", call. = FALSE)
  }
  buildReportTable(
    data = Output,
    headers = c("$h$ [mm]", "$U$", as.character(Moduli)),
    align = c("r", "l", rep("r", length(Moduli)))
  )
}

buildCalculationSensitivityPmTable <- function(path, liningID) {
  DATA <- .sensitivityRead(
    path,
    c(
      "modulusMPa", "liningID", "reinforcementCaseID",
      "reinforcementCaseOrder", "barDiameterMm", "barSpacingMm",
      "reinforcementArrangementID", "maximumRadialUtilization",
      "localPMStatus", "maximumShearUtilization", "shearStatus"
    )
  )
  DATA <- DATA[DATA$liningID == liningID, , drop = FALSE]
  if (nrow(DATA) == 0L) {
    stop("The requested P-M sensitivity is unavailable.", call. = FALSE)
  }
  Moduli <- .sensitivityModuli(DATA)
  DATA <- DATA[
    order(DATA$reinforcementCaseOrder, DATA$modulusMPa),
    ,
    drop = FALSE
  ]
  if (any(DATA$reinforcementArrangementID != "symmetric-two-face")) {
    stop("The P-M sensitivity requires symmetric meshes.", call. = FALSE)
  }
  DATA$configurationID <- paste0(
    "S",
    trimws(formatC(DATA$barDiameterMm, format = "fg", digits = 6L))
  )
  DATA$value <- DATA$maximumRadialUtilization
  WidePm <- .sensitivityWide(DATA, "configurationID", Moduli, 2L)
  DATA$value <- DATA$maximumShearUtilization
  WideShear <- .sensitivityWide(DATA, "configurationID", Moduli, 2L)
  WideShear <- WideShear[, paste0("E", Moduli), drop = FALSE]
  names(WideShear) <- paste0("V", Moduli)
  Output <- cbind(
    data.frame(ID = WidePm$configurationID, stringsAsFactors = FALSE),
    WidePm[, paste0("E", Moduli), drop = FALSE],
    WideShear
  )
  if (anyNA(Output)) {
    stop("The P-M sensitivity mapping is incomplete.", call. = FALSE)
  }
  buildReportTable(
    data = Output,
    headers = c(
      "$i$",
      paste0("$U_{PM}^{", Moduli, "}$"),
      paste0("$U_{V}^{", Moduli, "}$")
    ),
    align = c("c", rep("r", 2L * length(Moduli)))
  )
}
