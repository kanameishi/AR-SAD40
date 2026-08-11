# Produces the deterministic numerical application for the calculation memo.
# The scenario is analytical and conditional; no project demand or probability
# model is introduced here.

arguments <- commandArgs(trailingOnly = FALSE)
fileArgument <- grep("^--file=", arguments, value = TRUE)
if (length(fileArgument) != 1L) {
  stop("Run with Rscript scripts/R/runCalculationMemo.R.", call. = FALSE)
}

scriptPath <- normalizePath(sub("^--file=", "", fileArgument))
projectRoot <- normalizePath(file.path(dirname(scriptPath), "..", ".."))
outputDirectory <- file.path(
  projectRoot,
  "TITO",
  "kb",
  "calculation-memo",
  "results"
)
if (!dir.exists(outputDirectory)) {
  dir.create(outputDirectory, recursive = TRUE)
}

source(file.path(projectRoot, "scripts", "R", "ringDirect.R"))
source(file.path(projectRoot, "scripts", "R", "ringLoads.R"))

writeResult <- function(value, fileName) {
  utils::write.csv(
    value,
    file.path(outputDirectory, fileName),
    row.names = FALSE,
    na = ""
  )
}

radius <- 1.315
area <- 3.7304717948718e-3
inertia <- 287.902153723077e-9
youngModulus <- 200e6
effectiveVertical <- 100
k0 <- 0.50
porePressure <- 0
interfaceAdhesion <- 0

section <- calculateRingSection(
  youngModulus = youngModulus,
  area = area,
  inertia = inertia,
  radius = radius
)

criticalAngles <- seq(0, 7 * pi / 4, by = pi / 4)
theta <- sort(unique(c((0:720) * 2 * pi / 721, criticalAngles)))

caseDefinitions <- data.frame(
  case = c("interface-alpha-1", "interface-alpha-0"),
  prescription = c("Interfaz: αδ = 1.00", "Interfaz: αδ = 0.00"),
  interfaceFrictionCoefficient = c(1, 0),
  closedInterface = c("fullTraction", "normalOnly"),
  stringsAsFactors = FALSE
)

caseLoads <- lapply(seq_len(nrow(caseDefinitions)), function(index) {
  k0InterfaceFrictionLoad(
    effectiveVertical = effectiveVertical,
    k0 = k0,
    porePressure = porePressure,
    interfaceFrictionCoefficient =
      caseDefinitions$interfaceFrictionCoefficient[index],
    interfaceAdhesion = interfaceAdhesion
  )
})
names(caseLoads) <- caseDefinitions$case

responses <- lapply(seq_len(nrow(caseDefinitions)), function(index) {
  solveRingDirect(
    load = caseLoads[[index]],
    radius = radius,
    theta = theta,
    sectionRatio = section$sectionRatio,
    integrationSteps = 8192L,
    balanceTolerance = 1e-9
  )
})
names(responses) <- caseDefinitions$case

quantityColumns <- c(
  N = "normalForce",
  M = "bendingMoment",
  Q = "shearForce"
)
quantityUnits <- c(N = "kN/m", M = "kN m/m", Q = "kN/m")

curves <- do.call(rbind, lapply(seq_len(nrow(caseDefinitions)), function(index) {
  values <- responses[[index]]$values
  do.call(rbind, lapply(names(quantityColumns), function(resultant) {
    data.frame(
      case = caseDefinitions$case[index],
      stage = "Estado biaxial uniforme",
      model = "Acciones prescritas",
      prescription = caseDefinitions$prescription[index],
      interfaceFrictionCoefficient =
        caseDefinitions$interfaceFrictionCoefficient[index],
      resultant = resultant,
      thetaIndex = seq_len(nrow(values)) - 1L,
      theta = values$theta,
      thetaDeg = values$thetaDeg,
      value = values[[quantityColumns[[resultant]]]],
      unit = quantityUnits[[resultant]],
      evidenceLevel = "DE",
      stringsAsFactors = FALSE
    )
  }))
}))
rownames(curves) <- NULL
writeResult(curves, "ring-curves.csv")

loads <- do.call(rbind, lapply(seq_len(nrow(caseDefinitions)), function(index) {
  evaluated <- evaluateRingLoad(responses[[index]]$load, theta)
  rbind(
    data.frame(
      case = caseDefinitions$case[index],
      prescription = caseDefinitions$prescription[index],
      interfaceFrictionCoefficient =
        caseDefinitions$interfaceFrictionCoefficient[index],
      component = "P_r",
      thetaIndex = seq_len(nrow(evaluated)) - 1L,
      theta = evaluated$theta,
      thetaDeg = evaluated$theta * 180 / pi,
      value = evaluated$radialOutward,
      unit = "kPa",
      evidenceLevel = "DE",
      stringsAsFactors = FALSE
    ),
    data.frame(
      case = caseDefinitions$case[index],
      prescription = caseDefinitions$prescription[index],
      interfaceFrictionCoefficient =
        caseDefinitions$interfaceFrictionCoefficient[index],
      component = "P_t",
      thetaIndex = seq_len(nrow(evaluated)) - 1L,
      theta = evaluated$theta,
      thetaDeg = evaluated$theta * 180 / pi,
      value = evaluated$tangentialPositive,
      unit = "kPa",
      evidenceLevel = "DE",
      stringsAsFactors = FALSE
    )
  )
}))
rownames(loads) <- NULL
writeResult(loads, "ring-loads.csv")

extrema <- do.call(rbind, lapply(seq_len(nrow(caseDefinitions)), function(index) {
  current <- summarizeRingGrid(responses[[index]])
  current$case <- caseDefinitions$case[index]
  current$prescription <- caseDefinitions$prescription[index]
  current$interfaceFrictionCoefficient <-
    caseDefinitions$interfaceFrictionCoefficient[index]
  current$stage <- "Estado biaxial uniforme"
  current$unit <- unname(quantityUnits[current$resultant])
  current$evidenceLevel <- "DE"
  current[, c(
    "case", "stage", "prescription", "interfaceFrictionCoefficient",
    "resultant", "statistic", "value", "signedValue", "theta",
    "thetaDeg", "unit", "evidenceLevel"
  )]
}))
rownames(extrema) <- NULL
writeResult(extrema, "ring-extrema.csv")

meanPressure <- porePressure + effectiveVertical * (1 + k0) / 2
stressDifference <- effectiveVertical * (1 - k0)
effectiveHorizontal <- k0 * effectiveVertical
requiredInterfaceCoefficient <- abs(stressDifference) /
  (2 * sqrt(effectiveVertical * effectiveHorizontal))
meanMoment <- -radius^2 * meanPressure *
  section$sectionRatio / (1 + section$sectionRatio)

inputs <- data.frame(
  group = c(
    rep("Geometría", 4), rep("Sección corrugada", 7),
    rep("Estado de tensiones e interfaz", 8)
  ),
  magnitude = c(
    "Diámetro interior nominal", "Radio empleado", "Corrugación nominal",
    "Espesor informado", "Espesor base del escenario", "Área por unidad de longitud",
    "Momento de inercia por unidad de longitud", "Módulo circunferencial",
    "Rigidez extensional circunferencial", "Rigidez flexional circunferencial",
    "Razón seccional", "Tensión vertical efectiva en el eje",
    "Coeficiente de empuje en reposo",
    "Diferencia de presión de agua", "Tensión horizontal efectiva en el eje",
    "Presión media", "Diferencia de tensiones",
    "Coeficiente de fricción de interfaz", "Coeficiente requerido para transferir la proyección completa"
  ),
  symbol = c(
    "D_i", "R", "perfil", "t_0", "t_b", "A_p", "I_p", "E_theta",
    "EA_theta", "EI_theta", "eta_s", "sigma'_v,A",
    "K_0", "Delta u_A", "sigma'_h,A", "p_m", "Delta sigma",
    "alpha_delta", "alpha_delta_req"
  ),
  value = c(
    "2.63", format(radius, digits = 5), "76 × 25", "3.0", "3.0",
    format(area * 1e3, digits = 5), format(inertia * 1e9, digits = 6), "200",
    format(section$extensionalRigidity, digits = 6),
    format(section$flexuralRigidity, digits = 5),
    format(section$sectionRatio, scientific = TRUE, digits = 4),
    format(effectiveVertical, digits = 5), format(k0, digits = 3),
    format(porePressure, digits = 3), format(k0 * effectiveVertical, digits = 5),
    format(meanPressure, digits = 5), format(stressDifference, digits = 5),
    "0; 1", format(requiredInterfaceCoefficient, digits = 4)
  ),
  unit = c(
    "m", "m", "mm", "mm", "mm", "mm2/mm", "mm4/mm", "GPa", "kN/m",
    "kN m2/m", "-", "kPa", "-", "kPa", "kPa", "kPa", "kPa",
    "-", "-"
  ),
  evidenceLevel = c(
    "PN", "DE", "PN", "PN", "HA", "DE", "DE", "HA", "DE", "DE",
    "DE", "HA", "HA", "HA", "DE", "DE", "DE", "HA", "DE"
  ),
  condition = c(
    "Parámetro nominal suministrado",
    "Aproximación D_i/2; no es radio centroidal confirmado",
    "Parámetro nominal suministrado", "Categoría pendiente",
    "Hipótesis condicional t_0 = t_b",
    "Interpolación de NCSPA bajo t_0 = t_b",
    "Interpolación de NCSPA bajo t_0 = t_b", "Valor adoptado",
    "Resultado derivado", "Resultado derivado", "Resultado derivado",
    "Escenario analítico", "Escenario analítico", "Escenario analítico",
    "Resultado derivado", "Resultado derivado", "Resultado derivado",
    "Extremos de sensibilidad; αδ = tan(δ)",
    "Resultado derivado para el escenario de comprobación"
  ),
  stringsAsFactors = FALSE
)
writeResult(inputs, "calculation-inputs.csv")

valueAt <- function(response, angle, column) {
  index <- which.min(abs(response$values$theta - angle))
  response$values[[column]][index]
}

exampleResults <- do.call(rbind, lapply(seq_len(nrow(caseDefinitions)), function(index) {
  response <- responses[[index]]
  data.frame(
    prescription = caseDefinitions$prescription[index],
    interfaceFrictionCoefficient =
      caseDefinitions$interfaceFrictionCoefficient[index],
    normalCrownInvert = valueAt(response, 0, "normalForce"),
    normalSidewalls = valueAt(response, pi / 2, "normalForce"),
    momentCrownInvert = valueAt(response, 0, "bendingMoment"),
    momentSidewalls = valueAt(response, pi / 2, "bendingMoment"),
    maximumAbsoluteShear = max(abs(response$values$shearForce)),
    meanMoment = meanMoment,
    evidenceLevel = "DE",
    stringsAsFactors = FALSE
  )
}))
writeResult(exampleResults, "calculation-example-results.csv")

controls <- do.call(rbind, lapply(seq_len(nrow(caseDefinitions)), function(index) {
  closed <- solveK0Closed(
    effectiveVertical = effectiveVertical,
    k0 = k0,
    porePressure = porePressure,
    radius = radius,
    theta = theta,
    interface = caseDefinitions$closedInterface[index],
    sectionRatio = section$sectionRatio
  )
  direct <- responses[[index]]
  do.call(rbind, lapply(names(quantityColumns), function(resultant) {
    error <- max(abs(
      direct$values[[quantityColumns[[resultant]]]] -
        closed$values[[quantityColumns[[resultant]]]]
    ))
    data.frame(
      case = caseDefinitions$case[index],
      prescription = caseDefinitions$prescription[index],
      interfaceFrictionCoefficient =
        caseDefinitions$interfaceFrictionCoefficient[index],
      resultant = resultant,
      metric = "Máxima diferencia absoluta",
      value = error,
      unit = quantityUnits[[resultant]],
      tolerance = 1e-7,
      pass = error <= 1e-7,
      gridPoints = length(theta),
      integrationSteps = 8192L,
      evidenceLevel = "CI",
      stringsAsFactors = FALSE
    )
  }))
}))
writeResult(controls, "ring-controls.csv")

displayScales <- do.call(rbind, lapply(names(quantityColumns), function(resultant) {
  current <- curves[curves$resultant == resultant, ]
  maximum <- max(abs(current$value))
  data.frame(
    resultant = resultant,
    displayScale = 0.25 * radius / maximum,
    maximumAbsoluteValue = maximum,
    unit = quantityUnits[[resultant]],
    radialFraction = 0.25,
    stringsAsFactors = FALSE
  )
}))
writeResult(displayScales, "ring-display-scales.csv")

verification <- data.frame(
  reference = c(
    "Baker (1968)", "USACE, ejemplo D4", "FHWA-RD-98-191",
    "Schwartz--Einstein, HP97", "Núñez (2000)"
  ),
  magnitude = c(
    "Fuerza normal y momento adimensionales", "Presión y fuerza normal",
    "Presión lateral de compactación", "Fuerza normal y momento",
    "Fuerza normal y momento"
  ),
  evidence = c("RP + DE", "DP + RP + DE", "RP", "RP", "RP + DE"),
  result = c(
    "Errores absolutos máximos: 4.97e-4 en N y 4.23e-4 en M.",
    "3600 lb/ft2, 10530 lb/ft y 11583 lb/ft reproducidos; 5400 lb/ft es derivado.",
    "Ocho de nueve filas reproducidas a 0.1 kPa; se conserva una inconsistencia de impresión.",
    "Cuatro combinaciones reproducidas; la fuente no tabula fuerza cortante.",
    "Diferencia relativa máxima de 1.31 % respecto de valores redondeados."
  ),
  stringsAsFactors = FALSE
)
writeResult(verification, "calculation-verification-summary.csv")

cat(
  "PASS: calculation memo deterministic application and products generated.\n"
)
