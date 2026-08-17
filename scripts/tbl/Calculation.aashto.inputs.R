buildCalculationAashtoInputsTable <- function(path) {
  if (!file.exists(path)) {
    stop("The AASHTO-input product is not available.", call. = FALSE)
  }
  Data <- utils::read.csv(
    path,
    check.names = FALSE,
    stringsAsFactors = FALSE,
    na.strings = ""
  )
  Required <- c(
    "coverCrownM", "totalUnitWeightKnPerM3", "yieldStrengthMPa",
    "tensileStrengthMPa", "elasticModulusMPa",
    "seamNominalResistanceKnPerM", "fastenerDiameterMm",
    "fastenerDiameterLossRatio"
  )
  Missing <- setdiff(Required, names(Data))
  if (length(Missing) > 0L || nrow(Data) != 1L) {
    stop("The AASHTO-input product has an invalid schema.", call. = FALSE)
  }
  Format <- function(value, unit) {
    if (unit %in% c("$\\mathrm{kN/m^3}$", "$\\mathrm{kN/m}$", "$\\mathrm{mm}$")) {
      return(formatC(round(value), format = "f", digits = 0L))
    }
    format(signif(value, 7L), trim = TRUE, scientific = FALSE)
  }
  Row <- function(symbol, value, unit) {
    data.frame(
      Symbol = symbol,
      Value = Format(value, unit),
      Unit = unit,
      check.names = FALSE,
      stringsAsFactors = FALSE
    )
  }
  Rows <- list(
    Row("$H_0$", Data[["coverCrownM", exact = TRUE]], "$\\mathrm{m}$"),
    Row(
      "$\\gamma_t$",
      Data[["totalUnitWeightKnPerM3", exact = TRUE]],
      "$\\mathrm{kN/m^3}$"
    ),
    Row("$F_y$", Data[["yieldStrengthMPa", exact = TRUE]], "$\\mathrm{MPa}$"),
    Row("$F_u$", Data[["tensileStrengthMPa", exact = TRUE]], "$\\mathrm{MPa}$"),
    Row("$E$", Data[["elasticModulusMPa", exact = TRUE]], "$\\mathrm{MPa}$")
  )
  if (is.finite(Data[["seamNominalResistanceKnPerM", exact = TRUE]])) {
    Rows <- append(
      Rows,
      list(
        Row(
          "$R_{n,0}$",
          Data[["seamNominalResistanceKnPerM", exact = TRUE]],
          "$\\mathrm{kN/m}$"
        ),
        Row(
          "$d_0$",
          Data[["fastenerDiameterMm", exact = TRUE]],
          "$\\mathrm{mm}$"
        ),
        Row(
          "$\\delta_d$",
          Data[["fastenerDiameterLossRatio", exact = TRUE]],
          "—"
        )
      ),
      after = 5L
    )
  }
  Output <- do.call(rbind, Rows)
  knitr::kable(
    Output,
    col.names = c("$x_i$", "$v_i$", "$u_i$"),
    align = c("c", "r", "c"),
    escape = FALSE
  )
}
