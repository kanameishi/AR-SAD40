buildCalculationInputsTable <- function(pathInputs, pathSection, pathStress) {
  Paths <- c(pathInputs, pathSection, pathStress)
  if (any(!file.exists(Paths))) {
    stop("One or more calculation input products are not available.", call. = FALSE)
  }
  Inputs <- utils::read.csv(pathInputs, check.names = FALSE, na.strings = "")
  Section <- utils::read.csv(pathSection, check.names = FALSE, na.strings = "")
  Stress <- utils::read.csv(pathStress, check.names = FALSE, na.strings = "")
  RequiredInputs <- c(
    "parameterID", "numericValue", "textValue", "unit", "evidenceLevel",
    "conditionCode"
  )
  RequiredSection <- c(
    "analysisBaseThicknessMm", "areaMm2PerMm", "inertiaMm4PerMm",
    "circumferentialYoungModulusGPa", "extensionalRigidityKnPerM",
    "flexuralRigidityKnM2PerM", "sectionRatio", "analysisRadiusM"
  )
  RequiredStress <- c(
    "modelID", "effectiveVerticalKPa", "k0Applied",
    "horizontalIncrementStatus", "effectiveHorizontalKPa",
    "waterPressureDifferenceKPa", "k0EvidenceLevel"
  )
  if (length(setdiff(RequiredInputs, names(Inputs))) > 0L ||
      length(setdiff(RequiredSection, names(Section))) > 0L ||
      length(setdiff(RequiredStress, names(Stress))) > 0L ||
      nrow(Section) != 1L || nrow(Stress) != 1L) {
    stop("The calculation input products have an invalid schema.", call. = FALSE)
  }
  inputNumber <- function(parameterID) {
    Value <- Inputs$numericValue[Inputs$parameterID == parameterID]
    if (length(Value) != 1L || !is.finite(Value)) {
      stop("Missing numeric input: ", parameterID, ".", call. = FALSE)
    }
    Value
  }
  inputText <- function(parameterID) {
    Value <- Inputs$textValue[Inputs$parameterID == parameterID]
    if (length(Value) != 1L || is.na(Value) || !nzchar(Value)) {
      stop("Missing text input: ", parameterID, ".", call. = FALSE)
    }
    Value
  }
  formatGeneral <- function(value, digits = 6L) {
    format(signif(value, digits), trim = TRUE, scientific = FALSE)
  }
  formatScientificLatex <- function(value, digits) {
    Exponent <- floor(log10(abs(value)))
    Mantissa <- value / 10^Exponent
    paste0(
      "$", format(signif(Mantissa, digits), trim = TRUE, scientific = FALSE),
      "\\times10^{", Exponent, "}$"
    )
  }
  row <- function(group, magnitude, symbol, value, unit, condition) {
    data.frame(
      Grupo = group,
      Magnitud = magnitude,
      Simbolo = symbol,
      Valor = value,
      Unidad = unit,
      Condicion = condition,
      check.names = FALSE,
      stringsAsFactors = FALSE
    )
  }
  ModelLabels <- c(
    "adopted-constant" = "Valor constante adoptado",
    "elastic-confined" = "Idealización elástica confinada",
    "jaky-nc" = "Relación de Jáky para carga primaria",
    "mayne-kulhawy-unloading" = "Relación de descarga de Mayne--Kulhawy",
    "mayne-kulhawy-reload" = "Relación de recarga de Mayne--Kulhawy"
  )
  ModelLabel <- unname(ModelLabels[Stress$modelID])
  if (is.na(ModelLabel)) {
    stop("The public K0 model mapping is incomplete.", call. = FALSE)
  }
  AlphaValues <- Inputs$numericValue[Inputs$parameterID == "tangential-multiplier"]
  AlphaText <- paste(format(sort(AlphaValues), trim = TRUE), collapse = "; ")
  ProfileText <- paste0(
    formatGeneral(inputNumber("nominal-corrugation-pitch")),
    " × ",
    formatGeneral(inputNumber("nominal-corrugation-depth"))
  )
  Output <- do.call(rbind, list(
    row("Geometría", "Diámetro interior nominal", "$D_i$", formatGeneral(inputNumber("inside-diameter")), "$\\mathrm{m}$", "Parámetro nominal suministrado"),
    row("Geometría", "Radio empleado", "$R$", formatGeneral(Section$analysisRadiusM), "$\\mathrm{m}$", "Aproximación $D_i/2$; radio centroidal pendiente de confirmación"),
    row("Geometría", "Corrugación nominal", "—", ProfileText, "$\\mathrm{mm}$", "Parámetro nominal suministrado"),
    row("Geometría", "Espesor informado", "$t_0$", formatGeneral(inputNumber("reported-thickness")), "$\\mathrm{mm}$", "Categoría pendiente"),
    row("Sección corrugada", "Espesor base del escenario", "$t_b$", formatGeneral(Section$analysisBaseThicknessMm), "$\\mathrm{mm}$", "Hipótesis condicional $t_0=t_b$"),
    row("Sección corrugada", "Área por unidad de longitud", "$A_p$", formatGeneral(Section$areaMm2PerMm), "$\\mathrm{mm^2/mm}$", "Interpolación de NCSPA bajo $t_0=t_b$"),
    row("Sección corrugada", "Momento de inercia por unidad de longitud", "$I_p$", formatGeneral(Section$inertiaMm4PerMm), "$\\mathrm{mm^4/mm}$", "Interpolación de NCSPA bajo $t_0=t_b$"),
    row("Sección corrugada", "Módulo circunferencial", "$E_\\theta$", formatGeneral(Section$circumferentialYoungModulusGPa), "$\\mathrm{GPa}$", "Valor adoptado"),
    row("Sección corrugada", "Rigidez extensional circunferencial", "$EA_\\theta$", formatScientificLatex(Section$extensionalRigidityKnPerM, 6L), "$\\mathrm{kN/m}$", "Resultado derivado"),
    row("Sección corrugada", "Rigidez flexional circunferencial", "$EI_\\theta$", formatGeneral(Section$flexuralRigidityKnM2PerM), "$\\mathrm{kN\\,m^2/m}$", "Resultado derivado"),
    row("Sección corrugada", "Razón seccional", "$\\eta_s$", formatScientificLatex(Section$sectionRatio, 4L), "—", "Resultado derivado"),
    row("Estado de tensiones y acciones", "Rama de empuje en reposo", "—", ModelLabel, "—", "Selección declarada"),
    row("Estado de tensiones y acciones", "Tensión vertical efectiva en el eje", "$\\sigma'_{v,A}$", formatGeneral(Stress$effectiveVerticalKPa), "$\\mathrm{kPa}$", "Escenario analítico"),
    row("Estado de tensiones y acciones", "Coeficiente de empuje aplicado", "$K_0$", formatGeneral(Stress$k0Applied), "—", if (Stress$k0EvidenceLevel == "HA") "Valor adoptado para el escenario" else "Resultado de la rama seleccionada"),
    row("Estado de tensiones y acciones", "Incremento horizontal residual", "$\\Delta\\sigma'_{h,c}$", "No modelado", "—", "Magnitud física no caracterizada"),
    row("Estado de tensiones y acciones", "Diferencia de presión de agua", "$\\Delta u_A$", formatGeneral(Stress$waterPressureDifferenceKPa), "$\\mathrm{kPa}$", "Escenario analítico"),
    row("Estado de tensiones y acciones", "Tensión horizontal efectiva en el eje", "$\\sigma'_{h,A}$", formatGeneral(Stress$effectiveHorizontalKPa), "$\\mathrm{kPa}$", "Resultado derivado"),
    row("Estado de tensiones y acciones", "Multiplicador de la componente tangencial", "$\\alpha$", AlphaText, "—", "Casos de carga prescritos")
  ))
  knitr::kable(
    Output,
    col.names = c("Grupo", "Magnitud", "Símbolo", "Valor", "Unidad", "Condición"),
    align = c("l", "l", "c", "r", "c", "l"),
    escape = FALSE
  )
}
