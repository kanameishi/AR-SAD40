.classicalDash <- function(value, digits = 1L) {
  ifelse(
    is.na(value),
    "—",
    formatC(value, format = "f", digits = digits, big.mark = " ")
  )
}

.classicalLiningLabel <- c(
  steel = "Chapa corrugada",
  shotcrete = "Hormigón proyectado de 100 mm",
  reinforcedConcrete = "Hormigón proyectado de 150 mm"
)

.classicalMethodLabel <- c(
  `official-hybrid` = "Modelo híbrido",
  `schwartz-einstein-uniform` = "Schwartz–Einstein uniforme",
  `prescribed-k0-ring` = "Anillo con campo $K_0$ prescrito",
  `nunez-2000` = "Núñez (2000)",
  `nunez-2014` = "Núñez, Sfriso y Laiún (2014)",
  `aashto-usace` = "AASHTO/USACE"
)

.classicalCaseLabel <- c(
  `alpha-1` = "Deslizamiento libre / proyección tangencial",
  `alpha-0` = "Sin deslizamiento / acción normal",
  `schwartz-einstein-full-slip` = "Deslizamiento libre",
  `schwartz-einstein-no-slip` = "Sin deslizamiento",
  `nunez-project-sensitivity` = "Parámetros de la base común",
  `aashto-service-thrust` = "Empuje de servicio",
  `aashto-modified-factored-demand` = "Demanda mayorada modificada"
)

buildCalculationClassicalInputsTable <- function(data) {
  if (!is.data.frame(data) || nrow(data) != 1L) {
    stop("The classical-comparison input row is unavailable.", call. = FALSE)
  }
  Output <- data.frame(
    Magnitud = c(
      "Tapada sobre clave", "Profundidad al eje", "Peso unitario efectivo",
      "Sobrecarga efectiva", "Tensión vertical al eje",
      "Tensión horizontal al eje", "$K_0$", "Módulo del terreno",
      "Coeficiente de Poisson", "$\\eta_N$", "$\\chi_N$"
    ),
    Valor = c(
      .classicalDash(data$coverCrownM, 1L),
      .classicalDash(data$depthAxisM, 1L),
      .classicalDash(data$effectiveUnitWeightKnPerM3, 1L),
      .classicalDash(data$effectiveSurchargeKPa, 1L),
      .classicalDash(data$effectiveVerticalStressKPa, 1L),
      .classicalDash(data$effectiveHorizontalStressKPa, 1L),
      .classicalDash(data$k0Applied, 2L),
      .classicalDash(data$groundModulusKPa / 1000, 1L),
      .classicalDash(data$groundPoisson, 2L),
      .classicalDash(data$nunezRelaxationFactor, 1L),
      .classicalDash(data$nunezContactFactor, 1L)
    ),
    Unidad = c(
      "m", "m", "$\\mathrm{kN/m^3}$", "kPa", "kPa", "kPa", "—",
      "MPa", "—", "—", "—"
    ),
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  knitr::kable(Output, align = c("l", "r", "c"), escape = FALSE)
}

buildCalculationClassicalSectionsTable <- function(data) {
  if (!is.data.frame(data) || nrow(data) != 3L) {
    stop("The three comparison sections are unavailable.", call. = FALSE)
  }
  Output <- data.frame(
    Seccion = unname(.classicalLiningLabel[data$liningID]),
    Diametro = .classicalDash(data$centroidalDiameterM, 1L),
    Espesor = .classicalDash(1000 * data$structuralThicknessM, 0L),
    EspesorNunez = .classicalDash(1000 * data$nunezEquivalentThicknessM, 0L),
    Modulo = .classicalDash(data$youngModulusKPa / 1e6, 1L),
    EA = .classicalDash(data$extensionalRigidityKnPerM, 1L),
    EI = .classicalDash(data$flexuralRigidityKnM2PerM, 1L),
    aN = .classicalDash(data$nunezInteractionRatio, 3L),
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  if (anyNA(Output$Seccion)) stop("A section label is missing.", call. = FALSE)
  knitr::kable(
    Output,
    col.names = c(
      "Sección", "$D_c$ [m]", "$t$ [mm]", "$e_N$ [mm]",
      "$E_\\ell$ [GPa]", "$EA$ [kN/m]", "$EI$ [kN·m²/m]", "$a_N$"
    ),
    align = c("l", rep("r", 7)),
    escape = FALSE
  )
}

buildCalculationClassicalSummaryTable <- function(data, liningID) {
  Data <- data[data$liningID == liningID, , drop = FALSE]
  if (nrow(Data) == 0L) stop("The requested comparison is unavailable.", call. = FALSE)
  MethodOrder <- c(
    "official-hybrid", "schwartz-einstein-uniform", "prescribed-k0-ring",
    "nunez-2000", "nunez-2014", "aashto-usace"
  )
  CaseOrder <- c(
    "alpha-1", "alpha-0", "schwartz-einstein-full-slip",
    "schwartz-einstein-no-slip", "nunez-project-sensitivity",
    "aashto-service-thrust", "aashto-modified-factored-demand"
  )
  Data <- Data[order(match(Data$methodID, MethodOrder), match(Data$caseID, CaseOrder)), ]
  Output <- data.frame(
    Metodo = unname(.classicalMethodLabel[Data$methodID]),
    Caso = unname(.classicalCaseLabel[Data$caseID]),
    N = .classicalDash(Data$normalAbsoluteMaxKnPerM, 1L),
    M = .classicalDash(Data$momentAbsoluteMaxKnMPerM, 1L),
    Q = .classicalDash(Data$shearAbsoluteMaxKnPerM, 1L),
    rN = .classicalDash(Data$normalRatioToOfficialEnvelope, 2L),
    rM = .classicalDash(Data$momentRatioToOfficialEnvelope, 2L),
    rQ = .classicalDash(Data$shearRatioToOfficialEnvelope, 2L),
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  if (anyNA(Output[, c("Metodo", "Caso")])) {
    stop("A comparison label is missing.", call. = FALSE)
  }
  knitr::kable(
    Output,
    col.names = c(
      "Formulación", "Caso", "$|N|_{\\max}$ [kN/m]",
      "$|M|_{\\max}$ [kN·m/m]", "$|Q|_{\\max}$ [kN/m]",
      "$r_N$", "$r_M$", "$r_Q$"
    ),
    align = c("l", "l", rep("r", 6)),
    escape = FALSE
  )
}

buildCalculationClassicalPointsTable <- function(data) {
  PointLabel <- c(crown = "Clave", springline = "Lateral", invert = "Solera", maximum = "Máximo")
  ResultantLabel <- c(N = "$N$", M = "$M_{\\max}$")
  UnitLabel <- c("kN/m" = "kN/m", "kN-m/m" = "kN·m/m")
  Output <- data.frame(
    Seccion = unname(.classicalLiningLabel[data$liningID]),
    Metodo = unname(.classicalMethodLabel[data$methodID]),
    Posicion = unname(PointLabel[data$pointID]),
    Magnitud = unname(ResultantLabel[data$resultantID]),
    Valor = .classicalDash(data$value, 1L),
    Unidad = unname(UnitLabel[data$unit]),
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  if (anyNA(Output)) stop("A point-resultant label is missing.", call. = FALSE)
  knitr::kable(
    Output,
    col.names = c("Sección", "Formulación", "Posición", "Magnitud", "Valor", "Unidad"),
    align = c("l", "l", "l", "c", "r", "c"),
    escape = FALSE
  )
}
