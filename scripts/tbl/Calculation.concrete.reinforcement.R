if (!exists("buildReportTable", mode = "function", inherits = TRUE)) {
  source(file.path("scripts", "tbl", "table.R"), local = TRUE)
}

buildCalculationConcreteReinforcementTable <- function(path, liningID) {
  if (!file.exists(path)) {
    stop("The calculation-input product is not available.", call. = FALSE)
  }
  if (!is.character(liningID) || length(liningID) != 1L ||
      !nzchar(liningID)) {
    stop("liningID must identify one concrete alternative.", call. = FALSE)
  }
  Data <- utils::read.csv(
    path,
    check.names = FALSE,
    stringsAsFactors = FALSE,
    na.strings = ""
  )
  Required <- c(
    "caseID", "groupID", "parameterID", "numericValue", "unit"
  )
  Missing <- setdiff(Required, names(Data))
  if (length(Missing) > 0L) {
    stop("The calculation-input product has an invalid schema.", call. = FALSE)
  }
  Data <- Data[
    which(Data[["caseID", exact = TRUE]] == liningID),
    ,
    drop = FALSE
  ]
  if (nrow(Data) == 0L) {
    stop("The requested concrete inputs are unavailable.", call. = FALSE)
  }
  inputValue <- function(groupID, parameterID) {
    Values <- Data[
      which(
        Data[["groupID", exact = TRUE]] == groupID &
          Data[["parameterID", exact = TRUE]] == parameterID
      ),
      "numericValue",
      drop = TRUE
    ]
    if (length(Values) != 1L || !is.finite(Values)) {
      stop("A concrete reinforcement input is missing or duplicated.", call. = FALSE)
    }
    Values
  }
  LayoutGroupID <- "shotcrete-reinforcement-layout"
  Output <- data.frame(
    Symbol = c(
      "$t_c$", "$f'_c$", "$b$", "$c/t_c$", "$c$", "$f_y$", "$E_s$"
    ),
    Value = c(
      inputValue("shotcrete", "thickness"),
      inputValue("shotcrete", "compressive-strength"),
      inputValue("shotcrete", "strip-width"),
      inputValue(LayoutGroupID, "clear-cover-ratio"),
      inputValue(LayoutGroupID, "clear-cover") / 10,
      inputValue(
        "shotcrete-reinforcement-circumferential",
        "yield-strength-circumferential-interior"
      ),
      inputValue(
        "shotcrete-reinforcement-circumferential",
        "modulus-circumferential-interior"
      )
    ),
    Unit = c(
      "$\\mathrm{mm}$", "$\\mathrm{MPa}$", "$\\mathrm{mm}$",
      "$-$", "$\\mathrm{cm}$",
      rep("$\\mathrm{MPa}$", 2L)
    ),
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  Output$Value <- vapply(seq_len(nrow(Output)), function(i) {
    if (Output$Unit[i] == "$\\mathrm{mm}$") {
      return(formatC(round(Output$Value[i]), format = "f", digits = 0L))
    }
    format(Output$Value[i], trim = TRUE, scientific = FALSE)
  }, character(1))
  buildReportTable(
    data = Output,
    headers = c("Magnitud", "Valor", "Unidad"),
    align = c("l", "r", "c")
  )
}
