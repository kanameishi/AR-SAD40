if (!exists("buildReportTable", mode = "function", inherits = TRUE)) {
  source(file.path("scripts", "tbl", "table.R"), local = TRUE)
}

buildCalculationExtremaTable <- function(
  pathResultants,
  pathExtrema,
  liningID = NULL
) {
  if (!file.exists(pathResultants) || !file.exists(pathExtrema)) {
    stop("The numerical-result products are not available.", call. = FALSE)
  }
  Resultants <- utils::read.csv(pathResultants, check.names = FALSE)
  Extrema <- utils::read.csv(pathExtrema, check.names = FALSE)
  RequiredResultants <- c(
    "caseID", "resultantID", "thetaRad", "value"
  )
  RequiredExtrema <- c(
    "caseID", "resultantID", "statisticID", "value", "thetaDeg", "unit"
  )
  if (length(setdiff(RequiredResultants, names(Resultants))) > 0L ||
      length(setdiff(RequiredExtrema, names(Extrema))) > 0L) {
    stop("The numerical-result products have an invalid schema.", call. = FALSE)
  }
  if (!is.null(liningID)) {
    if (!is.character(liningID) || length(liningID) != 1L ||
        !nzchar(liningID) ||
        !("liningID" %in% names(Resultants)) ||
        !("liningID" %in% names(Extrema))) {
      stop("liningID must identify one concrete alternative.", call. = FALSE)
    }
    Resultants <- Resultants[
      Resultants[["liningID", exact = TRUE]] == liningID,
      ,
      drop = FALSE
    ]
    Extrema <- Extrema[
      Extrema[["liningID", exact = TRUE]] == liningID,
      ,
      drop = FALSE
    ]
    if (nrow(Resultants) == 0L || nrow(Extrema) == 0L) {
      stop("The requested concrete resultants are unavailable.", call. = FALSE)
    }
  }
  if ("interfaceID" %in% names(Extrema)) {
    InterfaceCodes <- c(
      fullTraction = "PT",
      `full-traction` = "PT",
      normalOnly = "PN",
      `normal-only` = "PN",
      fullSlip = "S",
      `full-slip` = "S",
      noSlip = "NS",
      `no-slip` = "NS"
    )
    ResultantLabels <- c(
      N = "$N_\\theta$",
      M = "$M_\\theta$",
      Q = "$Q_\\theta$"
    )
    Cases <- unique(Extrema[, c("caseID", "interfaceID")])
    Value <- function(caseID, resultantID, statisticID, field) {
      Data <- Extrema[
        Extrema$caseID == caseID &
          Extrema$resultantID == resultantID &
          Extrema$statisticID == statisticID,
        ,
        drop = FALSE
      ]
      if (nrow(Data) != 1L) {
        stop("An expected interaction extremum is missing or duplicated.", call. = FALSE)
      }
      Data[[field]][1L]
    }
    Rows <- lapply(seq_len(nrow(Cases)), function(i) {
      CaseID <- Cases$caseID[i]
      InterfaceID <- Cases$interfaceID[i]
      do.call(rbind, lapply(c("N", "M", "Q"), function(ResultantID) {
        Unit <- Value(CaseID, ResultantID, "minimum", "unit")
        data.frame(
          Interface = unname(InterfaceCodes[InterfaceID]),
          Resultant = unname(ResultantLabels[ResultantID]),
          Minimum = Value(CaseID, ResultantID, "minimum", "value"),
          MinimumAngle = Value(CaseID, ResultantID, "minimum", "thetaDeg"),
          Maximum = Value(CaseID, ResultantID, "maximum", "value"),
          MaximumAngle = Value(CaseID, ResultantID, "maximum", "thetaDeg"),
          AbsoluteMaximum = Value(
            CaseID,
            ResultantID,
            "absolute-maximum",
            "value"
          ),
          AbsoluteMaximumAngle = Value(
            CaseID,
            ResultantID,
            "absolute-maximum",
            "thetaDeg"
          ),
          Unit = Unit,
          check.names = FALSE,
          stringsAsFactors = FALSE
        )
      }))
    })
    Output <- do.call(rbind, Rows)
    if (anyNA(Output$Interface) || anyNA(Output$Resultant)) {
      stop("The public interface or resultant mapping is incomplete.", call. = FALSE)
    }
    return(buildReportTable(
      data = Output,
      headers = c(
        "$I$", "$X$", "$X_{\\min}$", "$\\theta_{\\min}$",
        "$X_{\\max}$", "$\\theta_{\\max}$",
        "$\\lvert X\\rvert_{\\max}$", "$\\theta_*$", "$u_X$"
      ),
      align = c("c", "c", "r", "r", "r", "r", "r", "r", "c"),
      digits = c(0, 0, 0, 1, 0, 1, 0, 1, 0)
    ))
  }
  if (!("tangentialMultiplier" %in% names(Resultants)) ||
      !("tangentialMultiplier" %in% names(Extrema))) {
    stop(
      "The biaxial-control products lack the tangential multiplier.",
      call. = FALSE
    )
  }
  Cases <- unique(Resultants[, c("caseID", "tangentialMultiplier")])
  valueAt <- function(caseID, resultantID, angle) {
    Data <- Resultants[
      Resultants$caseID == caseID & Resultants$resultantID == resultantID,
      ,
      drop = FALSE
    ]
    Data$value[which.min(abs(Data$thetaRad - angle))]
  }
  extremum <- function(caseID, resultantID, statisticID) {
    Value <- Extrema$value[
      Extrema$caseID == caseID &
        Extrema$resultantID == resultantID &
        Extrema$statisticID == statisticID
    ]
    if (length(Value) != 1L) {
      stop("An expected resultant extremum is missing or duplicated.", call. = FALSE)
    }
    Value
  }
  Output <- do.call(rbind, lapply(seq_len(nrow(Cases)), function(i) {
    CaseID <- Cases$caseID[i]
    TangentialMultiplier <- Cases$tangentialMultiplier[i]
    data.frame(
      TangentialMultiplier = TangentialMultiplier,
      NormalA = valueAt(CaseID, "N", 0),
      NormalB = valueAt(CaseID, "N", pi / 2),
      MomentA = valueAt(CaseID, "M", 0),
      MomentB = valueAt(CaseID, "M", pi / 2),
      QMaximum = extremum(CaseID, "Q", "absolute-maximum"),
      check.names = FALSE,
      stringsAsFactors = FALSE
    )
  }))
  Output <- Output[
    order(Output$TangentialMultiplier, decreasing = TRUE),
    ,
    drop = FALSE
  ]
  buildReportTable(
    data = Output,
    headers = c(
      "$\\lambda_t$", "$N_A$", "$N_B$", "$M_A$", "$M_B$",
      "$\\lvert Q_\\theta\\rvert_{\\max}$"
    ),
    align = rep("r", 6),
    digits = c(0, 0, 0, 0, 0, 0)
  )
}
