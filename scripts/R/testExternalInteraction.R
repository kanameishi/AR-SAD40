# Verifies the coordinate and sign adapter for external ground--lining
# interaction without assigning project soil or cover data.

Arguments <- commandArgs(trailingOnly = FALSE)
FileArgument <- grep("^--file=", Arguments, value = TRUE)
if (length(FileArgument) != 1L) {
  stop("Run with Rscript scripts/R/testExternalInteraction.R.", call. = FALSE)
}

ScriptPath <- normalizePath(sub("^--file=", "", FileArgument))
ProjectRoot <- normalizePath(file.path(dirname(ScriptPath), "..", ".."))
projectRoot <- ProjectRoot
source(
  file.path(ProjectRoot, "scripts", "setup", "calculationFunctions.R"),
  local = TRUE
)

Theta <- (0:720) * 2 * pi / 721
Inputs <- list(
  theta = Theta,
  effectiveVerticalStressKPa = 100,
  effectiveHorizontalStressKPa = 50,
  stressReferenceID = "axis-reference",
  radiusM = 1.315,
  groundModulusKPa = 30000,
  groundPoisson = 0.3,
  liningModulusKPa = 200000000,
  liningPoisson = 0.3,
  liningAreaM2PerM = 3.281e-3,
  liningInertiaM4PerM = 249.73e-9,
  combinationID = "synthetic-control",
  stageID = "external-loading",
  forceEffectStatus = "unfactored-reference-state"
)

for (Interface in c("fullSlip", "noSlip")) {
  Result <- do.call(
    calculateExternalInteraction,
    c(Inputs, list(interface = Interface))
  )
  Result.source <- Result[["source", exact = TRUE]]
  Response.source <- Result.source[["response", exact = TRUE]]
  Amplitudes <- Result.source[["amplitudes", exact = TRUE]]
  Values <- Result[["values", exact = TRUE]]
  Summary <- summarizeExternalInteraction(Result)
  CStar.expected <- Inputs$groundModulusKPa * Inputs$radiusM *
    (1 - Inputs$liningPoisson^2) /
    (Inputs$liningModulusKPa * Inputs$liningAreaM2PerM *
      (1 - Inputs$groundPoisson^2))
  FStar.expected <- Inputs$groundModulusKPa * Inputs$radiusM^3 *
    (1 - Inputs$liningPoisson^2) /
    (Inputs$liningModulusKPa * Inputs$liningInertiaM4PerM *
      (1 - Inputs$groundPoisson^2))
  N.expected <- -Inputs$effectiveVerticalStressKPa * Inputs$radiusM *
    Amplitudes[["thrust0", exact = TRUE]] +
    Inputs$effectiveVerticalStressKPa * Inputs$radiusM *
      Amplitudes[["thrust2", exact = TRUE]] * cos(2 * Theta)
  M.expected <- Inputs$effectiveVerticalStressKPa * Inputs$radiusM^2 *
    Amplitudes[["moment2", exact = TRUE]] * cos(2 * Theta)
  Q.expected <- -2 * Inputs$effectiveVerticalStressKPa * Inputs$radiusM *
    Amplitudes[["moment2", exact = TRUE]] * sin(2 * Theta)

  stopifnot(
    identical(Values$thetaRad, Theta),
    identical(Values$thetaDeg, Theta * 180 / pi),
    identical(Values$normalForceKnPerM, -Response.source$thrust),
    identical(Values$bendingMomentKnMPerM, -Response.source$moment),
    identical(Values$shearForceKnPerM, Response.source$shear),
    max(abs(Values$normalForceKnPerM - N.expected)) < 1e-12,
    max(abs(Values$bendingMomentKnMPerM - M.expected)) < 1e-12,
    max(abs(Values$shearForceKnPerM - Q.expected)) < 1e-12,
    abs(Result$stiffness$cStar - CStar.expected) < 1e-12,
    abs(Result$stiffness$fStar - FStar.expected) < 1e-12,
    all(Values$longitudinalBasis == "per-projected-metre"),
    all(Values$combinationID == "synthetic-control"),
    all(Values$stageID == "external-loading"),
    all(Values$forceEffectStatus == "unfactored-reference-state"),
    all(Values$stressReferenceID == "axis-reference"),
    all(Values$stressBasis == "effective-plus-net-water-pressure"),
    all(Values$hydraulicActionTreatment == "uniform-net-pressure-superposed"),
    all(Values$stressRatio == 0.5),
    nrow(Summary) == 9L,
    identical(sort(unique(Summary$resultantID)), c("M", "N", "Q")),
    all(Summary$effectiveVerticalStressKPa == 100),
    all(Summary$effectiveHorizontalStressKPa == 50),
    all(Summary$stressRatio == 0.5)
  )

  Summary.N <- Summary[Summary$resultantID == "N", ]
  Summary.M <- Summary[Summary$resultantID == "M", ]
  Summary.Q <- Summary[Summary$resultantID == "Q", ]
  NMean.expected <- -Inputs$effectiveVerticalStressKPa * Inputs$radiusM *
    Amplitudes[["thrust0", exact = TRUE]]
  NAmplitude.expected <- Inputs$effectiveVerticalStressKPa *
    Inputs$radiusM * Amplitudes[["thrust2", exact = TRUE]]
  NExtrema.expected <- c(
    NMean.expected - abs(NAmplitude.expected),
    NMean.expected + abs(NAmplitude.expected)
  )
  MAbsolute.expected <- abs(
    Inputs$effectiveVerticalStressKPa * Inputs$radiusM^2 *
      Amplitudes[["moment2", exact = TRUE]]
  )
  QAbsolute.expected <- abs(
    2 * Inputs$effectiveVerticalStressKPa * Inputs$radiusM *
      Amplitudes[["moment2", exact = TRUE]]
  )
  stopifnot(
    max(abs(Summary.N$value[1:2] - NExtrema.expected)) < 1e-7,
    abs(Summary.M$value[1] + MAbsolute.expected) < 1e-12,
    abs(Summary.M$value[2] - MAbsolute.expected) < 1e-12,
    abs(Summary.Q$value[1] + QAbsolute.expected) < 1e-12,
    abs(Summary.Q$value[2] - QAbsolute.expected) < 1e-12,
    all(Summary$thetaDeg %in% c(0, 45, 90, 135))
  )

  IDX.crown <- which.min(abs(Theta))
  IDX.right <- which.min(abs(Theta - pi / 2))
  IDX.crownSource <- which.min(abs(Response.source$theta - pi / 2))
  IDX.rightSource <- which.min(abs(Response.source$theta))
  stopifnot(
    abs(Values$normalForceKnPerM[IDX.crown] +
      Response.source$thrust[IDX.crownSource]) < 1e-12,
    abs(Values$normalForceKnPerM[IDX.right] +
      Response.source$thrust[IDX.rightSource]) < 1e-12,
    abs(Values$bendingMomentKnMPerM[IDX.crown] +
      Response.source$moment[IDX.crownSource]) < 1e-12,
    abs(Values$shearForceKnPerM[IDX.crown]) < 1e-12
  )
}

Interface.invalid <- tryCatch(
  do.call(
    calculateExternalInteraction,
    c(Inputs, list(interface = "partialSlip"))
  ),
  error = function(e) conditionMessage(e)
)
stopifnot(identical(
  Interface.invalid,
  "interface must be fullSlip or noSlip."
))

Inputs.coarse <- Inputs
Inputs.coarse$theta <- c(0.1, 0.9, 2.2, 4.8)
Result.coarse <- do.call(
  calculateExternalInteraction,
  c(Inputs.coarse, list(interface = "fullSlip"))
)
Result.fine <- do.call(
  calculateExternalInteraction,
  c(Inputs, list(interface = "fullSlip"))
)
stopifnot(identical(
  summarizeExternalInteraction(Result.coarse),
  summarizeExternalInteraction(Result.fine)
))

Baseline <- do.call(
  calculateExternalInteraction,
  c(Inputs, list(interface = "fullSlip"))
)
Hybrid <- addBalancedGeostaticGradient(
  interaction = Baseline,
  radiusM = Inputs$radiusM,
  verticalStressGradientKPaPerM = 20,
  horizontalStressGradientKPaPerM = 10
)
Delta <- 10
N1 <- -Inputs$radiusM^2 * Delta / 4
N3 <- -Inputs$radiusM^2 * Delta / 8
M3 <- -Inputs$radiusM^3 * Delta / 24
Q3 <- Inputs$radiusM^2 * Delta / 8
stopifnot(
  all(Hybrid$values$interactionModelID ==
    "schwartz-einstein-balanced-gradient-hybrid"),
  max(abs(
    Hybrid$values$normalForceKnPerM -
      Baseline$values$normalForceKnPerM -
      N1 * cos(Theta) - N3 * cos(3 * Theta)
  )) < 1e-12,
  max(abs(
    Hybrid$values$bendingMomentKnMPerM -
      Baseline$values$bendingMomentKnMPerM -
      M3 * cos(3 * Theta)
  )) < 1e-12,
  max(abs(
    Hybrid$values$shearForceKnPerM -
      Baseline$values$shearForceKnPerM -
      Q3 * sin(3 * Theta)
  )) < 1e-12,
  abs(Hybrid$gradient$supportRadialMode1KPa +
    Inputs$radiusM * 20) < 1e-12,
  abs(Hybrid$gradient$balancedVerticalForceKnPerM) < 1e-12,
  Hybrid$gradient$equilibriumStatus == "satisfied",
  Hybrid$gradient$prescribedCompressionStatus == "satisfied"
)

cat("PASS: external interaction convention adapter.\n")
