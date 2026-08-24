if (!exists("buildReportTable", mode = "function", inherits = TRUE)) {
  source(file.path("scripts", "tbl", "table.R"), local = TRUE)
}

buildCalculationInteractionTable <- function(path, liningID = NULL) {
  if (!file.exists(path)) {
    stop("The interaction-parameter product is not available.", call. = FALSE)
  }
  Data <- utils::read.csv(
    path,
    check.names = FALSE,
    stringsAsFactors = FALSE,
    na.strings = ""
  )
  Required <- c(
    "interfaceID", "tangentialMultiplier", "sectionRatio",
    "normalMeanKnPerM", "normalCosineKnPerM", "momentMeanKnMPerM",
    "momentCosineKnMPerM", "shearSineKnPerM"
  )
  Missing <- setdiff(Required, names(Data))
  if (length(Missing) > 0L || nrow(Data) == 0L) {
    stop("The interaction-parameter product has an invalid schema.", call. = FALSE)
  }
  if (!is.null(liningID)) {
    if (!is.character(liningID) || length(liningID) != 1L ||
        !nzchar(liningID) || !("liningID" %in% names(Data))) {
      stop("liningID must identify one concrete alternative.", call. = FALSE)
    }
    Data <- Data[Data[["liningID", exact = TRUE]] == liningID, , drop = FALSE]
    if (nrow(Data) == 0L) {
      stop("The requested concrete interaction is unavailable.", call. = FALSE)
    }
  }
  InterfaceCodes <- c(`full-traction` = "Completa", `normal-only` = "Normal")
  Output <- data.frame(
    Projection = unname(InterfaceCodes[Data$interfaceID]),
    TangentialMultiplier = Data$tangentialMultiplier,
    Eta = Data$sectionRatio,
    N0 = round(Data$normalMeanKnPerM),
    N2 = round(Data$normalCosineKnPerM),
    M0 = round(Data$momentMeanKnMPerM),
    M2 = round(Data$momentCosineKnMPerM),
    Q2 = round(Data$shearSineKnPerM),
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  if (anyNA(Output$Projection) || any(!is.finite(as.matrix(Output[-1L])))) {
    stop("The interaction parameters are incomplete.", call. = FALSE)
  }
  buildReportTable(
    data = Output,
    headers = c(
      "Proyección", "$\\lambda_t$", "$\\eta_s$", "$N_0$ (kN/m)",
      "$N_2$ (kN/m)", "$M_0$ (kN·m/m)", "$M_2$ (kN·m/m)",
      "$Q_2$ (kN/m)"
    ),
    align = c("l", "r", "r", "r", "r", "r", "r", "r"),
    digits = c(0, 0, 6, 0, 0, 0, 0, 0)
  )
}

buildCalculationSchwartzEinsteinTable <- function(path, liningID = NULL) {
  if (!file.exists(path)) {
    stop("The Schwartz-Einstein product is not available.", call. = FALSE)
  }
  Data <- utils::read.csv(
    path,
    check.names = FALSE,
    stringsAsFactors = FALSE,
    na.strings = ""
  )
  Required <- c(
    "interfaceID", "cStar", "fStar", "t0", "t2", "m2",
    "normalMeanKnPerM", "normalCosineKnPerM",
    "momentCosineKnMPerM", "shearSineKnPerM"
  )
  Missing <- setdiff(Required, names(Data))
  if (length(Missing) > 0L || nrow(Data) == 0L) {
    stop("The Schwartz-Einstein product has an invalid schema.", call. = FALSE)
  }
  if (!is.null(liningID)) {
    if (!is.character(liningID) || length(liningID) != 1L ||
        !nzchar(liningID) || !("liningID" %in% names(Data))) {
      stop("liningID must identify one concrete alternative.", call. = FALSE)
    }
    Data <- Data[Data[["liningID", exact = TRUE]] == liningID, , drop = FALSE]
  }
  if (nrow(Data) != 2L) {
    stop("The Schwartz-Einstein interface envelope is incomplete.", call. = FALSE)
  }
  InterfaceCodes <- c(`full-slip` = "S", `no-slip` = "NS")
  Output <- data.frame(
    Interface = unname(InterfaceCodes[Data$interfaceID]),
    CStar = Data$cStar,
    FStar = Data$fStar,
    T0 = Data$t0,
    T2 = Data$t2,
    M2 = Data$m2,
    N0 = round(Data$normalMeanKnPerM),
    N2 = round(Data$normalCosineKnPerM),
    Moment2 = round(Data$momentCosineKnMPerM),
    Shear2 = round(Data$shearSineKnPerM),
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  if (anyNA(Output) || any(!is.finite(as.matrix(Output[-1L])))) {
    stop("The Schwartz-Einstein parameters are incomplete.", call. = FALSE)
  }
  buildReportTable(
    data = Output,
    headers = c(
      "$I$", "$C^*$", "$F^*$", "$t_0$", "$t_2$", "$m_2$",
      "$N_0$ (kN/m)", "$N_2$ (kN/m)", "$M_2$ (kN·m/m)",
      "$Q_2$ (kN/m)"
    ),
    align = c("l", rep("r", 9L)),
    digits = c(0, 4, 1, 4, 4, 4, 0, 0, 0, 0)
  )
}
