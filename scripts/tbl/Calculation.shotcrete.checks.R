if (!exists("buildReportTable", mode = "function", inherits = TRUE)) {
  source(file.path("scripts", "tbl", "table.R"), local = TRUE)
}

buildCalculationShotcreteChecksTable <- function(
  path,
  liningID,
  thicknessMm = NULL
) {
  if (!file.exists(path)) {
    stop("The shotcrete-check product is not available.", call. = FALSE)
  }
  Data <- utils::read.csv(
    path,
    check.names = FALSE,
    stringsAsFactors = FALSE,
    na.strings = ""
  )
  Required <- c(
    "interfaceID", "checkID", "calculationStatus", "checkStatus",
    "verticalStressFactor", "horizontalStressFactor", "demandValue",
    "capacityValue", "unit", "utilization"
  )
  Missing <- setdiff(Required, names(Data))
  if (length(Missing) > 0L) {
    stop("The shotcrete-check product has an invalid schema.", call. = FALSE)
  }
  if (!is.character(liningID) || length(liningID) == 0L ||
      anyNA(liningID) || any(!nzchar(liningID)) || anyDuplicated(liningID) ||
      !("liningID" %in% names(Data))) {
    stop("liningID must identify concrete alternatives.", call. = FALSE)
  }
  PlainIDs <- c("shotcrete", "plainConcrete150")
  IsPlain <- all(liningID %in% PlainIDs)
  IsReinforced <- identical(liningID, "reinforcedConcrete")
  if (!IsPlain && !IsReinforced) {
    stop(
      "Unsupported concrete alternative: ",
      paste(liningID, collapse = ", "),
      call. = FALSE
    )
  }
  AllowedChecks <- if (IsPlain) {
    c("tension-face", "one-way-shear")
  } else {
    c("axial-flexure", "one-way-shear")
  }
  Data <- Data[
    Data[["liningID", exact = TRUE]] %in% liningID &
    Data[["checkID", exact = TRUE]] %in% AllowedChecks &
      Data[["calculationStatus", exact = TRUE]] == "calculated",
    ,
    drop = FALSE
  ]
  if (nrow(Data) == 0L || any(!is.finite(Data[["utilization", exact = TRUE]]))) {
    stop("The calculated shotcrete checks are unavailable.", call. = FALSE)
  }
  InterfaceCodes <- c(
    `full-slip` = "S",
    `no-slip` = "NS"
  )
  CheckCodes <- c(
    `tension-face` = "$\\sigma_{t,\\max}$",
    `one-way-shear` = "$V_u$",
    `axial-flexure` = "$P$--$M$"
  )
  StatusCodes <- c(
    satisfied = "OK",
    `not-satisfied` = "FAIL"
  )
  if (IsPlain) {
    if (is.null(thicknessMm) || !is.numeric(thicknessMm) ||
        any(!is.finite(thicknessMm)) || any(thicknessMm <= 0) ||
        is.null(names(thicknessMm)) ||
        !setequal(names(thicknessMm), liningID)) {
      stop(
        "thicknessMm must provide one positive value per plain lining.",
        call. = FALSE
      )
    }
    InterfaceIDs <- c("full-slip", "no-slip")
    RowKeys <- expand.grid(
      liningID = liningID,
      interfaceID = InterfaceIDs,
      stringsAsFactors = FALSE
    )
    Rows <- lapply(seq_len(nrow(RowKeys)), function(RowIndex) {
      LiningID <- RowKeys$liningID[RowIndex]
      InterfaceID <- RowKeys$interfaceID[RowIndex]
      Current <- Data[
        Data[["liningID", exact = TRUE]] == LiningID &
          Data[["interfaceID", exact = TRUE]] == InterfaceID,
        ,
        drop = FALSE
      ]
      Tension <- Current[
        Current[["checkID", exact = TRUE]] == "tension-face",
        ,
        drop = FALSE
      ]
      Shear <- Current[
        Current[["checkID", exact = TRUE]] == "one-way-shear",
        ,
        drop = FALSE
      ]
      if (nrow(Tension) == 0L || nrow(Shear) == 0L) {
        stop(
          "The plain-concrete N-M and shear checks are incomplete.",
          call. = FALSE
        )
      }
      Tension <- Tension[which.max(Tension$utilization), , drop = FALSE]
      Shear <- Shear[which.max(Shear$utilization), , drop = FALSE]
      TensionStatus <- unname(StatusCodes[Tension$checkStatus])
      ShearStatus <- unname(StatusCodes[Shear$checkStatus])
      data.frame(
        Thickness = formatC(
          unname(thicknessMm[LiningID]),
          format = "f",
          digits = 0L
        ),
        Interface = unname(InterfaceCodes[InterfaceID]),
        Flexure = formatC(Tension$utilization, format = "f", digits = 2L),
        FlexureStatus = TensionStatus,
        Shear = formatC(Shear$utilization, format = "f", digits = 2L),
        ShearStatus = ShearStatus,
        OverallStatus = if (
          identical(TensionStatus, "OK") && identical(ShearStatus, "OK")
        ) "OK" else "FAIL",
        check.names = FALSE,
        stringsAsFactors = FALSE
      )
    })
    Output <- do.call(rbind, Rows)
    rownames(Output) <- NULL
    return(buildReportTable(
      data = Output,
      headers = c(
        "$h$", "$I$", "$U_{N-M,\\max}$", "$E_{N-M}$",
        "$U_{V,\\max}$", "$E_V$", "$E$"
      ),
      align = c("r", "c", "r", "c", "r", "c", "c")
    ))
  }
  UnitLabels <- c(
    MPa = "$\\mathrm{MPa}$",
    kN = "$\\mathrm{kN}$",
    `-` = "$-$"
  )
  formatDemand <- function(value, unit) {
    ifelse(
      unit == "kN",
      formatC(round(value), format = "f", digits = 0L),
      formatC(value, format = "f", digits = 2L)
    )
  }
  RowGroups <- split(
    seq_len(nrow(Data)),
    paste(Data$interfaceID, Data$checkID, sep = "\r")
  )
  GoverningRows <- vapply(
    RowGroups,
    function(Index) Index[which.max(Data$utilization[Index])],
    integer(1)
  )
  Data <- Data[GoverningRows, , drop = FALSE]
  Data <- Data[
    order(
      match(Data$interfaceID, c("full-slip", "no-slip")),
      match(Data$checkID, AllowedChecks)
    ),
    ,
    drop = FALSE
  ]
  Output <- data.frame(
    Interface = unname(InterfaceCodes[Data[["interfaceID", exact = TRUE]]]),
    Check = unname(CheckCodes[Data[["checkID", exact = TRUE]]]),
    VerticalFactor = formatC(
      Data[["verticalStressFactor", exact = TRUE]],
      format = "fg",
      digits = 3L
    ),
    HorizontalFactor = formatC(
      Data[["horizontalStressFactor", exact = TRUE]],
      format = "fg",
      digits = 3L
    ),
    Demand = formatDemand(
      Data[["demandValue", exact = TRUE]],
      Data[["unit", exact = TRUE]]
    ),
    Resistance = formatDemand(
      Data[["capacityValue", exact = TRUE]],
      Data[["unit", exact = TRUE]]
    ),
    Unit = unname(UnitLabels[Data[["unit", exact = TRUE]]]),
    Utilization = formatC(
      Data[["utilization", exact = TRUE]],
      format = "f",
      digits = 2L
    ),
    Status = unname(StatusCodes[Data[["checkStatus", exact = TRUE]]]),
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  if (anyNA(Output)) {
    stop("The shotcrete-check mapping is incomplete.", call. = FALSE)
  }
  buildReportTable(
    data = Output,
    headers = c(
      "$I$", "$i$", "$f_{EV}$", "$f_{EH}$",
      "$D$", "$R$", "$u$", "$U=D/R$", "$E$"
    ),
    align = c("c", "c", "r", "r", "r", "r", "c", "r", "c")
  )
}
