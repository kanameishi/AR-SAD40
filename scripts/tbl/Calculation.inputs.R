buildCalculationInputsTable <- function(path) {
  if (!file.exists(path)) {
    stop("The calculation-input file is not available.", call. = FALSE)
  }
  data <- utils::read.csv(path, check.names = FALSE)
  required <- c(
    "group", "magnitude", "symbol", "value", "unit", "evidenceLevel",
    "condition"
  )
  if (length(setdiff(required, names(data))) > 0L) {
    stop("The calculation-input file has an invalid schema.", call. = FALSE)
  }
  symbolLabels <- c(
    "D_i" = "$D_i$",
    "R" = "$R$",
    "perfil" = "—",
    "t_0" = "$t_0$",
    "t_b" = "$t_b$",
    "A_p" = "$A_p$",
    "I_p" = "$I_p$",
    "E_theta" = "$E_\\theta$",
    "EA_theta" = "$EA_\\theta$",
    "EI_theta" = "$EI_\\theta$",
    "eta_s" = "$\\eta_s$",
    "t_eq" = "$t_{eq}$",
    "E_eq" = "$E_{eq}$",
    "sigma'_v,A" = "$\\sigma'_{v,A}$",
    "K_0" = "$K_0$",
    "Delta u_A" = "$\\Delta u_A$",
    "sigma'_h,A" = "$\\sigma'_{h,A}$",
    "p_m" = "$p_m$",
    "Delta sigma" = "$\\Delta\\sigma$",
    "alpha" = "$\\alpha$"
  )
  unitLabels <- c(
    "m" = "$\\mathrm{m}$",
    "mm" = "$\\mathrm{mm}$",
    "mm2/mm" = "$\\mathrm{mm^2/mm}$",
    "mm4/mm" = "$\\mathrm{mm^4/mm}$",
    "GPa" = "$\\mathrm{GPa}$",
    "kN/m" = "$\\mathrm{kN/m}$",
    "kN m2/m" = "$\\mathrm{kN\\,m^2/m}$",
    "-" = "—",
    "kPa" = "$\\mathrm{kPa}$"
  )
  symbols <- unname(symbolLabels[data$symbol])
  units <- unname(unitLabels[data$unit])
  if (anyNA(symbols) || anyNA(units)) {
    stop("The public symbol or unit mapping is incomplete.", call. = FALSE)
  }
  formatScientificLatex <- function(value, digits) {
    exponent <- floor(log10(abs(value)))
    mantissa <- value / 10^exponent
    mantissaText <- format(
      signif(mantissa, digits), trim = TRUE, scientific = FALSE
    )
    paste0("$", mantissaText, "\\times10^{", exponent, "}$")
  }
  values <- data$value
  values[data$symbol == "EA_theta"] <- formatScientificLatex(
    as.numeric(values[data$symbol == "EA_theta"]), 6L
  )
  values[data$symbol == "eta_s"] <- formatScientificLatex(
    as.numeric(values[data$symbol == "eta_s"]), 4L
  )
  conditions <- data$condition
  conditions[conditions ==
    "Aproximación D_i/2; no es radio centroidal confirmado"] <-
    "Aproximación $D_i/2$; radio centroidal pendiente de confirmación"
  conditions[conditions == "Hipótesis condicional t_0 = t_b"] <-
    "Hipótesis condicional $t_0=t_b$"
  conditions[conditions == "Interpolación de NCSPA bajo t_0 = t_b"] <-
    "Interpolación de NCSPA bajo $t_0=t_b$"
  output <- data.frame(
    Grupo = data$group,
    Magnitud = data$magnitude,
    Simbolo = symbols,
    Valor = values,
    Unidad = units,
    Condicion = conditions,
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  knitr::kable(
    output,
    col.names = c("Grupo", "Magnitud", "Símbolo", "Valor", "Unidad", "Condición"),
    align = c("l", "l", "c", "r", "c", "l"),
    escape = FALSE
  )
}
