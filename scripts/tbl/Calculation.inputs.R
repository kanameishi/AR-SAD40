buildCalculationInputsTable <- function(pathInputs, pathSection, pathStress) {
  Paths <- c(pathInputs, pathSection, pathStress)
  if (any(!file.exists(Paths))) {
    stop("One or more calculation input products are not available.", call. = FALSE)
  }
  Inputs <- utils::read.csv(pathInputs, check.names = FALSE, na.strings = "")
  Section <- utils::read.csv(pathSection, check.names = FALSE, na.strings = "")
  Stress <- utils::read.csv(pathStress, check.names = FALSE, na.strings = "")
  RequiredInputs <- c("parameterID", "numericValue", "textValue", "unit")
  CoverModel <- "coverCrownM" %in% names(Stress)
  RequiredSection <- if (CoverModel) {
    c(
      "propertyModelID", "circumferentialYoungModulusGPa",
      "centroidalRadiusM"
    )
  } else {
    c(
      "propertyModelID", "circumferentialYoungModulusGPa",
      "analysisRadiusM"
    )
  }
  RequiredStress <- if (CoverModel) {
    c(
      "k0ModelID", "depthM", "coverCrownM", "crownToAxisM",
      "effectiveUnitWeightKnPerM3", "effectiveSurchargeKPa",
      "effectiveVerticalStressKPa", "frictionAngleDeg", "poissonRatio",
      "ocr", "ocrMaximum", "k0Applied", "effectiveHorizontalStressKPa",
      "domainStatus"
    )
  } else {
    c(
      "modelID", "effectiveVerticalKPa", "frictionAngleDeg",
      "poissonRatio", "ocr", "ocrMaximum", "k0Applied",
      "effectiveHorizontalKPa", "waterPressureDifferenceKPa", "domainStatus"
    )
  }
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
  inputNumberInGroup <- function(groupID, parameterID) {
    Value <- Inputs$numericValue[
      Inputs$groupID == groupID & Inputs$parameterID == parameterID
    ]
    if (length(Value) != 1L || !is.finite(Value)) {
      stop(
        "Missing numeric input: ", groupID, ".", parameterID, ".",
        call. = FALSE
      )
    }
    Value
  }
  formatGeneral <- function(value, digits = 6L) {
    format(signif(value, digits), trim = TRUE, scientific = FALSE)
  }
  row <- function(symbol, value, unit) {
    data.frame(
      Symbol = symbol,
      Value = value,
      Unit = unit,
      check.names = FALSE,
      stringsAsFactors = FALSE
    )
  }
  if (CoverModel) {
    Output <- do.call(rbind, list(
      row("Altura del relleno inferior sobre la clave", formatGeneral(Stress$coverCrownM), "$\\mathrm{m}$"),
      row("Distancia de la clave al centro", formatGeneral(Stress$crownToAxisM), "$\\mathrm{m}$"),
      row(
        "Peso unitario efectivo del relleno inferior",
        formatGeneral(Stress$effectiveUnitWeightKnPerM3),
        "$\\mathrm{kN/m^3}$"
      ),
      if (all(c(
        "upperLayerHeightM", "upperLayerUnitWeightKnPerM3"
      ) %in% names(Stress))) {
        row(
          "Altura de la capa superior de lodo",
          formatGeneral(Stress$upperLayerHeightM),
          "$\\mathrm{m}$"
        )
      } else NULL,
      if (all(c(
        "upperLayerHeightM", "upperLayerUnitWeightKnPerM3"
      ) %in% names(Stress))) {
        row(
          "Peso unitario de la capa superior de lodo",
          formatGeneral(Stress$upperLayerUnitWeightKnPerM3),
          "$\\mathrm{kN/m^3}$"
        )
      } else NULL,
      row("Presión permanente de la capa superior", formatGeneral(Stress$effectiveSurchargeKPa), "$\\mathrm{kPa}$"),
      if (is.finite(Stress$frictionAngleDeg)) {
        row(
          "Ángulo de fricción efectiva",
          formatGeneral(Stress$frictionAngleDeg),
          "$^{\\circ}$"
        )
      } else {
        NULL
      },
      if (is.finite(Stress$ocr)) {
        row("Relación de sobreconsolidación", formatGeneral(Stress$ocr), "—")
      } else {
        NULL
      },
      row("Coeficiente de presión en reposo", formatGeneral(Stress$k0Applied), "—"),
      row(
        "Tensión vertical efectiva en el centro",
        formatGeneral(Stress$effectiveVerticalStressKPa),
        "$\\mathrm{kPa}$"
      ),
      row(
        "Tensión horizontal efectiva en el centro",
        formatGeneral(Stress$effectiveHorizontalStressKPa),
        "$\\mathrm{kPa}$"
      ),
      row(
        "Presión hidráulica neta",
        formatGeneral(inputNumberInGroup("action", "net-water-pressure")),
        "$\\mathrm{kPa}$"
      ),
      row(
        "Módulo de deformación del relleno",
        formatGeneral(inputNumberInGroup("ground", "modulus") / 1000),
        "$\\mathrm{MPa}$"
      ),
      row(
        "Coeficiente de Poisson del relleno",
        formatGeneral(inputNumberInGroup("ground", "poisson-ratio")),
        "—"
      )
    ))
    return(knitr::kable(
      Output,
      col.names = c("Magnitud", "Valor", "Unidad"),
      align = c("l", "r", "c"),
      escape = FALSE
    ))
  }
  AlphaValues <- Inputs$numericValue[Inputs$parameterID == "tangential-multiplier"]
  if (length(AlphaValues) == 0L || any(!is.finite(AlphaValues))) {
    stop("The tangential multiplier inputs are not available.", call. = FALSE)
  }
  AlphaText <- paste(format(sort(unique(AlphaValues)), trim = TRUE), collapse = "; ")
  K0ModelLabels <- c(
    "adopted-constant" = "Valor adoptado (hipótesis del caso)",
    "elastic-confined" = "Elasticidad lineal con deformación lateral impedida",
    "jaky-nc" = "Jáky, carga primaria",
    "mayne-kulhawy-unloading" = "Mayne--Kulhawy, descarga primaria",
    "mayne-kulhawy-reload" = "Mayne--Kulhawy, descarga y recarga"
  )
  if (!(Stress$modelID %in% names(K0ModelLabels))) {
    stop("The calculation K0 model is not supported by the table.", call. = FALSE)
  }
  K0Rows <- list(
    row("$m_{K_0}$", K0ModelLabels[[Stress$modelID]], "—")
  )
  if (is.finite(Stress$frictionAngleDeg)) {
    K0Rows[[length(K0Rows) + 1L]] <- row(
      "$\\phi'$",
      formatGeneral(Stress$frictionAngleDeg),
      "$^{\\circ}$"
    )
  }
  if (is.finite(Stress$poissonRatio)) {
    K0Rows[[length(K0Rows) + 1L]] <- row(
      "$\\nu_g$",
      formatGeneral(Stress$poissonRatio),
      "—"
    )
  }
  if (is.finite(Stress$ocr)) {
    K0Rows[[length(K0Rows) + 1L]] <- row(
      "$\\mathrm{OCR}$",
      formatGeneral(Stress$ocr),
      "—"
    )
  }
  if (is.finite(Stress$ocrMaximum)) {
    K0Rows[[length(K0Rows) + 1L]] <- row(
      "$\\mathrm{OCR}_{\\max}$",
      formatGeneral(Stress$ocrMaximum),
      "—"
    )
  }
  K0Rows[[length(K0Rows) + 1L]] <- row(
    "$K_0$",
    formatGeneral(Stress$k0Applied),
    "—"
  )
  K0Rows[[length(K0Rows) + 1L]] <- row(
    "$\\sigma'_h$",
    formatGeneral(Stress$effectiveHorizontalKPa),
    "$\\mathrm{kPa}$"
  )
  if (Stress$domainStatus != "not-applicable") {
    DomainLabels <- c(
      "within-domain" = "Anterior al límite pasivo",
      "passive-limit-reached" = "Límite pasivo alcanzado"
    )
    if (!(Stress$domainStatus %in% names(DomainLabels))) {
      stop("The calculation K0 domain status is not supported by the table.", call. = FALSE)
    }
    K0Rows[[length(K0Rows) + 1L]] <- row(
      "$d_{K_0}$",
      DomainLabels[[Stress$domainStatus]],
      "—"
    )
  }
  SectionRows <- if (Section$propertyModelID == "published-exact-row") {
    RequiredExact <- c(
      "nominalPitchMm", "nominalDepthMm", "actualPitchMm",
      "actualDepthMm", "corrugationRadiusMm",
      "specifiedThicknessMm", "designBaseThicknessMm"
    )
    if (length(setdiff(RequiredExact, names(Section))) > 0L) {
      stop("The exact section-property product is incomplete.", call. = FALSE)
    }
    list(
      row("$p_c$", formatGeneral(Section$actualPitchMm), "$\\mathrm{mm}$"),
      row("$h_c$", formatGeneral(Section$actualDepthMm), "$\\mathrm{mm}$"),
      row("$r_c$", formatGeneral(Section$corrugationRadiusMm), "$\\mathrm{mm}$"),
      row(
        "$\\mathcal P$",
        paste0(
          "CSPI CSP ", formatGeneral(Section$nominalPitchMm), " × ",
          formatGeneral(Section$nominalDepthMm)
        ),
        "—"
      ),
      row("$t_s$", formatGeneral(Section$specifiedThicknessMm), "$\\mathrm{mm}$"),
      row("$t_d$", formatGeneral(Section$designBaseThicknessMm), "$\\mathrm{mm}$")
    )
  } else {
    if (!("analysisBaseThicknessMm" %in% names(Section))) {
      stop("The interpolated section-property product is incomplete.", call. = FALSE)
    }
    list(
      row("$p_c$", formatGeneral(inputNumber("nominal-corrugation-pitch")), "$\\mathrm{mm}$"),
      row("$h_c$", formatGeneral(inputNumber("nominal-corrugation-depth")), "$\\mathrm{mm}$"),
      row(
        "$\\mathcal P$",
        paste0(
          "Perfil ",
          formatGeneral(inputNumber("nominal-corrugation-pitch")), " × ",
          formatGeneral(inputNumber("nominal-corrugation-depth"))
        ),
        "—"
      ),
      row("$t_b$", formatGeneral(Section$analysisBaseThicknessMm), "$\\mathrm{mm}$")
    )
  }
  SheetRows <- if ("yield-strength" %in% Inputs$parameterID) {
    list(
      row(
        "$F_y$",
        formatGeneral(inputNumber("yield-strength")),
        "$\\mathrm{MPa}$"
      )
    )
  } else {
    list()
  }
  Output <- do.call(rbind, c(list(
    row("$D_i$", formatGeneral(inputNumber("inside-diameter")), "$\\mathrm{m}$"),
    row("$R=D_i/2$", formatGeneral(Section$analysisRadiusM), "$\\mathrm{m}$")
  ), SectionRows, list(
    row("$E_\\theta$", formatGeneral(Section$circumferentialYoungModulusGPa), "$\\mathrm{GPa}$")
  ), SheetRows, list(
    row("$\\sigma'_v$", formatGeneral(Stress$effectiveVerticalKPa), "$\\mathrm{kPa}$")
  ), K0Rows, list(
    row("$\\Delta u$", formatGeneral(Stress$waterPressureDifferenceKPa), "$\\mathrm{kPa}$"),
    row("$\\alpha$", AlphaText, "—")
  )))
  knitr::kable(
    Output,
    col.names = c("$x_i$", "$v_i$", "$u_i$"),
    align = c("c", "r", "c"),
    escape = FALSE
  )
}
