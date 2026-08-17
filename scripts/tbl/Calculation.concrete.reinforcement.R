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
  CircumferentialGroupID <- "shotcrete-reinforcement-circumferential"
  LayoutGroupID <- "shotcrete-reinforcement-layout"
  Output <- data.frame(
    Symbol = c(
      "$t_c$", "$f'_c$", "$b$",
      "$\\phi$", "$s$", "$c/t_c$", "$c$", "$A_s$",
      "$z_i$", "$z_e$", "$f_y$", "$E_s$"
    ),
    Value = c(
      inputValue("shotcrete", "thickness"),
      inputValue("shotcrete", "compressive-strength"),
      inputValue("shotcrete", "strip-width"),
      inputValue(LayoutGroupID, "bar-diameter"),
      inputValue(LayoutGroupID, "bar-spacing"),
      inputValue(LayoutGroupID, "clear-cover-ratio"),
      inputValue(LayoutGroupID, "clear-cover"),
      inputValue(LayoutGroupID, "area-per-face-direction") / 100,
      inputValue(
        CircumferentialGroupID,
        "coordinate-circumferential-interior"
      ),
      inputValue(
        CircumferentialGroupID,
        "coordinate-circumferential-exterior"
      ),
      inputValue(
        CircumferentialGroupID,
        "yield-strength-circumferential-interior"
      ),
      inputValue(
        CircumferentialGroupID,
        "modulus-circumferential-interior"
      )
    ),
    Unit = c(
      "$\\mathrm{mm}$", "$\\mathrm{MPa}$", "$\\mathrm{mm}$",
      "$\\mathrm{mm}$", "$\\mathrm{mm}$", "$-$",
      "$\\mathrm{mm}$", "$\\mathrm{cm^2/m}$",
      rep("$\\mathrm{mm}$", 2L),
      rep("$\\mathrm{MPa}$", 2L)
    ),
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  Output$Value <- vapply(seq_len(nrow(Output)), function(i) {
    if (i == 8L) {
      return(formatC(Output$Value[i], format = "f", digits = 2L))
    }
    if (Output$Unit[i] == "$\\mathrm{mm}$") {
      return(formatC(round(Output$Value[i]), format = "f", digits = 0L))
    }
    format(Output$Value[i], trim = TRUE, scientific = FALSE)
  }, character(1))
  knitr::kable(
    Output,
    col.names = c("$x_i$", "$v_i$", "$u_i$"),
    align = c("c", "r", "c"),
    escape = FALSE
  )
}
