Arguments <- commandArgs(trailingOnly = FALSE)
FileArgument <- grep("^--file=", Arguments, value = TRUE)
if (length(FileArgument) != 1L) {
  stop("Run with Rscript scripts/R/testRingMethod.R.", call. = FALSE)
}
ScriptPath <- normalizePath(sub("^--file=", "", FileArgument))
ProjectRoot <- normalizePath(file.path(dirname(ScriptPath), "..", ".."))

source(file.path(ProjectRoot, "scripts", "R", "ringDirect.R"))
source(file.path(ProjectRoot, "scripts", "R", "ringLoads.R"))
source(file.path(ProjectRoot, "scripts", "R", "ringInteraction.R"))
source(file.path(ProjectRoot, "scripts", "R", "ringMonteCarlo.R"))

assertNear <- function(actual, expected, tolerance, label) {
  if (length(actual) != length(expected)) {
    if (length(expected) == 1L) {
      expected <- rep(expected, length(actual))
    } else if (length(actual) == 1L) {
      actual <- rep(actual, length(expected))
    } else {
      stop(label, ": incompatible lengths.", call. = FALSE)
    }
  }
  if (!is.null(dim(actual)) && !is.null(dim(expected)) &&
      !identical(dim(actual), dim(expected))) {
    stop(label, ": incompatible dimensions.", call. = FALSE)
  }
  Error <- max(abs(actual - expected))
  if (!is.finite(Error) || Error > tolerance) {
    stop(
      sprintf("%s: max error %.12g exceeds %.12g.", label, Error, tolerance),
      call. = FALSE
    )
  }
  invisible(Error)
}

assertError <- function(operation, label, pattern = NULL) {
  Error <- tryCatch(
    {
      operation()
      NULL
    },
    error = function(condition) condition
  )
  if (is.null(Error)) {
    stop(label, ": expected an error.", call. = FALSE)
  }
  if (!is.null(pattern) && !grepl(pattern, conditionMessage(Error))) {
    stop(
      label,
      ": unexpected error: ",
      conditionMessage(Error),
      call. = FALSE
    )
  }
  invisible(Error)
}

assertTrue <- function(value, label) {
  if (!isTRUE(value)) {
    stop(label, " failed.", call. = FALSE)
  }
  invisible(value)
}

Theta <- (0:180) * 2 * pi / 181
Radius <- 2

# Internal equation controls; these values are not published project results.
assertNear(k0NormallyConsolidated(30), 0.5, 1e-14, "Jaky K0")
assertNear(k0ElasticConfined(1 / 3), 0.5, 1e-14, "elastic K0")
assertNear(
  k0MayneKulhawyUnloading(30, 1),
  k0NormallyConsolidated(30),
  1e-14,
  "unloading NC boundary"
)
assertNear(
  k0MayneKulhawyUnloading(30, 4),
  1,
  1e-14,
  "unloading K0"
)
assertNear(
  k0MayneKulhawyUnloading(30, 9),
  1.5,
  1e-14,
  "unloading permits K0 above one"
)
assertNear(
  k0MayneKulhawyReload(30, 4, 4),
  k0MayneKulhawyUnloading(30, 4),
  1e-14,
  "reload at maximum OCR"
)
assertNear(
  k0MayneKulhawyReload(30, 1, 1),
  k0NormallyConsolidated(30),
  1e-14,
  "reload NC boundary"
)
assertNear(
  k0MayneKulhawyReload(30, 2, 4),
  0.6875,
  1e-14,
  "reload intermediate state"
)
K0Domain <- checkK0PassiveDomain(30, 4)
assertTrue(K0Domain$valid, "passive-domain valid state")
assertTrue(
  identical(K0Domain$domainStatus, "withinDomain"),
  "passive-domain status"
)
assertNear(
  K0Domain$passiveCoefficient,
  3,
  1e-14,
  "passive K0 limit"
)
assertNear(K0Domain$ocrLimit, 36, 1e-12, "passive OCR limit")
K0Boundary <- checkK0PassiveDomain(30, 36)
assertTrue(!K0Boundary$valid, "passive-domain boundary state")
assertTrue(
  identical(K0Boundary$domainStatus, "passiveLimitReached"),
  "passive-domain boundary status"
)
assertError(
  function() k0MayneKulhawyUnloading(30, 0.99),
  "unloading OCR lower bound",
  "at least 1"
)
assertError(
  function() k0MayneKulhawyUnloading(30, 36),
  "unloading passive limit",
  "passive limit"
)
assertError(
  function() k0MayneKulhawyReload(30, 4.01, 4),
  "reloading OCR order",
  "must not exceed"
)
assertError(
  function() k0MayneKulhawyReload(30, 1, 36),
  "reloading passive limit",
  "passive limit"
)
assertError(
  function() checkK0PassiveDomain(0, 1),
  "passive-domain friction lower bound",
  "greater than 0"
)
assertError(
  function() checkK0PassiveDomain(90, 1),
  "passive-domain friction upper bound",
  "less than 90"
)
assertError(
  function() checkK0PassiveDomain(30, c(1, 2)),
  "passive-domain scalar OCR",
  "one finite numeric value"
)

# Mai (2013), PDF p. 23: published 152 x 51 x 3 mm section and its
# equivalent plain shell. Units here are N and mm, per mm projected width.
MaiSection <- calculateRingSection(
  youngModulus = 200000,
  area = 3.522,
  inertia = 1057.25,
  radius = 1315
)
assertNear(
  MaiSection$extensionalRigidity,
  704400,
  1e-9,
  "Mai section EA"
)
assertNear(
  MaiSection$flexuralRigidity,
  211450000,
  1e-6,
  "Mai section EI"
)
assertNear(
  MaiSection$equivalentThickness,
  60,
  0.05,
  "Mai equivalent thickness"
)
assertNear(
  MaiSection$equivalentYoungModulus / 1000,
  11.74,
  0.01,
  "Mai equivalent Young modulus"
)

# 1. Exact mechanics: uniform pressure and both K0 interface branches.
UniformPressure <- 12.3
UniformLoad <- newRingLoad(
  radial = function(theta) rep(-UniformPressure, length(theta)),
  label = "uniform pressure benchmark",
  source = "thin-ring equilibrium",
  representation = "uniform normal pressure"
)
Uniform <- solveRingDirect(
  load = UniformLoad,
  radius = Radius,
  theta = Theta,
  integrationSteps = 4096L
)
assertNear(
  Uniform$values$normalForce,
  rep(-UniformPressure * Radius, length(Theta)),
  2e-8,
  "uniform pressure N"
)
assertNear(Uniform$values$bendingMoment, 0, 2e-8, "uniform pressure M")
assertNear(Uniform$values$shearForce, 0, 2e-8, "uniform pressure Q")
Theta.tied <- c(0, pi / 2, pi, 3 * pi / 2)
Values.tied <- data.frame(
  theta = Theta.tied,
  thetaDeg = Theta.tied * 180 / pi,
  normalForce = c(-5, 5, -5, 5),
  bendingMoment = c(7, -7, 7, -7),
  shearForce = c(0, 3, -3, 3)
)
Response.tied <- list(values = Values.tied)
class(Response.tied) <- "ringDirectResponse"
Summary.expected <- data.frame(
  resultant = rep(c("N", "M", "Q"), each = 3L),
  statistic = rep(c("minimum", "maximum", "absoluteMaximum"), 3L),
  value = c(-5, 5, 5, -7, 7, 7, -3, 3, 3),
  signedValue = c(-5, 5, -5, -7, 7, 7, -3, 3, 3),
  theta = c(0, pi / 2, 0, pi / 2, 0, 0, pi, pi / 2, pi / 2),
  thetaDeg = c(0, 90, 0, 90, 0, 0, 180, 90, 90),
  stringsAsFactors = FALSE
)
Summary.actual <- summarizeSectionResultants(Response.tied)
assertTrue(
  identical(Summary.actual, Summary.expected),
  "section resultant extrema and first-index ties"
)
assertTrue(
  identical(summarizeRingGrid(Response.tied), Summary.actual),
  "historical grid summary compatibility"
)
assertError(
  function() summarizeSectionResultants(list()),
  "section resultant summary class",
  "solveRingDirect"
)
UniformCombined <- solveRingDirect(
  load = combineRingLoads(list(
    scaleRingLoad(UniformLoad, 0.4),
    scaleRingLoad(UniformLoad, 0.6)
  )),
  radius = Radius,
  theta = Theta,
  integrationSteps = 4096L
)
assertNear(
  as.matrix(UniformCombined$values[, c(
    "normalForce", "bendingMoment", "shearForce"
  )]),
  as.matrix(Uniform$values[, c(
    "normalForce", "bendingMoment", "shearForce"
  )]),
  2e-8,
  "load combination and scaling"
)

for (s in c("fullTraction", "normalOnly")) {
  K0Load <- k0TensorLoad(
    effectiveVertical = 100,
    k0 = 0.5,
    porePressure = 20,
    interface = s
  )
  Direct <- solveRingDirect(
    load = K0Load,
    radius = Radius,
    theta = Theta,
    sectionRatio = 0.02,
    integrationSteps = 4096L
  )
  Closed <- solveK0Closed(
    effectiveVertical = 100,
    k0 = 0.5,
    porePressure = 20,
    radius = Radius,
    theta = Theta,
    interface = s,
    sectionRatio = 0.02
  )
  assertNear(
    as.matrix(Direct$values[, c("normalForce", "bendingMoment", "shearForce")]),
    as.matrix(Closed$values[, c("normalForce", "bendingMoment", "shearForce")]),
    3e-8,
    paste("direct versus closed K0", s)
  )
}

# The multiplier reproduces both prescribed-load endpoints.  For intermediate
# values, direct integration must recover the closed response obtained by
# linear superposition.
MultiplierEndpointLoads <- list(
  fullTraction = k0TangentialMultiplierLoad(
    effectiveVertical = 100,
    k0 = 0.5,
    porePressure = 20,
    tangentialMultiplier = 1
  ),
  normalOnly = k0TangentialMultiplierLoad(
    effectiveVertical = 100,
    k0 = 0.5,
    porePressure = 20,
    tangentialMultiplier = 0
  )
)
for (s in names(MultiplierEndpointLoads)) {
  MultiplierValues <- evaluateRingLoad(
    MultiplierEndpointLoads[[s]],
    Theta
  )
  TensorValues <- evaluateRingLoad(
    k0TensorLoad(
      effectiveVertical = 100,
      k0 = 0.5,
      porePressure = 20,
      interface = s
    ),
    Theta
  )
  assertNear(
    MultiplierValues$radialOutward,
    TensorValues$radialOutward,
    5e-14,
    paste("tangential multiplier radial endpoint", s)
  )
  assertNear(
    MultiplierValues$tangentialPositive,
    TensorValues$tangentialPositive,
    5e-14,
    paste("tangential multiplier endpoint", s)
  )
}
IntermediateMultiplier <- 0.2
IntermediateLoad <- k0TangentialMultiplierLoad(
  effectiveVertical = 100,
  k0 = 0.5,
  porePressure = 20,
  tangentialMultiplier = IntermediateMultiplier
)
IntermediateValues <- evaluateRingLoad(IntermediateLoad, Theta)
FullValues <- evaluateRingLoad(MultiplierEndpointLoads$fullTraction, Theta)
assertNear(
  IntermediateValues$tangentialPositive,
  IntermediateMultiplier * FullValues$tangentialPositive,
  5e-14,
  "scaled tangential component"
)
IntermediateResponse <- solveRingDirect(
  load = IntermediateLoad,
  radius = Radius,
  theta = Theta,
  sectionRatio = 0.02,
  integrationSteps = 4096L
)
IntermediateReference <- solveRingDirect(
  load = IntermediateLoad,
  radius = Radius,
  theta = Theta,
  sectionRatio = 0.02,
  integrationSteps = 8192L
)
assertTrue(
  isTRUE(IntermediateResponse$diagnostics$valid),
  "tangential multiplier direct response"
)
assertTrue(
  all(is.finite(as.matrix(IntermediateResponse$values[, c(
    "normalForce", "bendingMoment", "shearForce"
  )]))),
  "tangential multiplier finite resultants"
)
MeanPressure <- 20 + (100 + 50) / 2
Difference <- 100 - 50
SectionRatio <- 0.02
MeanMoment <- -Radius^2 * MeanPressure *
  SectionRatio / (1 + SectionRatio)
IntermediateClosed <- data.frame(
  normalForce = -Radius * MeanPressure +
    Radius * Difference * (1 + 2 * IntermediateMultiplier) / 6 *
      cos(2 * Theta),
  bendingMoment = MeanMoment +
    Radius^2 * Difference * (2 + IntermediateMultiplier) / 12 *
      cos(2 * Theta),
  shearForce = -Radius * Difference * (2 + IntermediateMultiplier) / 6 *
    sin(2 * Theta)
)
assertNear(
  as.matrix(IntermediateResponse$values[, c(
    "normalForce", "bendingMoment", "shearForce"
  )]),
  as.matrix(IntermediateClosed),
  3e-8,
  "tangential multiplier closed response"
)
assertNear(
  as.matrix(IntermediateResponse$values[, c(
    "normalForce", "bendingMoment", "shearForce"
  )]),
  as.matrix(IntermediateReference$values[, c(
    "normalForce", "bendingMoment", "shearForce"
  )]),
  5e-6,
  "tangential multiplier integration convergence"
)
assertError(
  function() {
    k0TangentialMultiplierLoad(
      effectiveVertical = 100,
      k0 = 0.5,
      tangentialMultiplier = 1.01
    )
  },
  "tangential multiplier upper bound",
  "must not exceed 1"
)

# Independent n=3 field that exercises radial and tangential tractions.
HarmonicAmplitude <- 7
HarmonicLoad <- newRingLoad(
  radial = function(theta) {
    -9 * HarmonicAmplitude / Radius^2 * cos(3 * theta)
  },
  tangential = function(theta) {
    -3 * HarmonicAmplitude / Radius^2 * sin(3 * theta)
  },
  label = "analytic n=3 benchmark",
  source = "equilibrium-derived test field",
  representation = "combined radial and tangential harmonic"
)
Harmonic <- solveRingDirect(
  load = HarmonicLoad,
  radius = Radius,
  theta = Theta,
  integrationSteps = 4096L
)
assertNear(Harmonic$values$normalForce, 0, 2e-8, "n=3 N")
assertNear(
  Harmonic$values$bendingMoment,
  HarmonicAmplitude * cos(3 * Theta),
  2e-8,
  "n=3 M"
)
assertNear(
  Harmonic$values$shearForce,
  -3 * HarmonicAmplitude / Radius * sin(3 * Theta),
  2e-8,
  "n=3 Q"
)

# An unbalanced load remains visible in diagnostics; it is never projected
# away silently.
Unbalanced <- newRingLoad(
  radial = function(theta) cos(theta),
  label = "unbalanced diagnostic",
  source = "test",
  representation = "first harmonic"
)
assertError(
  function() solveRingDirect(
    load = Unbalanced,
    radius = 1,
    theta = Theta,
    integrationSteps = 2048L
  ),
  "unbalanced load rejected",
  "non-zero global resultant"
)
UnbalancedResult <- solveRingDirect(
  load = Unbalanced,
  radius = 1,
  theta = Theta,
  integrationSteps = 2048L,
  allowUnbalanced = TRUE
)
assertTrue(!UnbalancedResult$diagnostics$valid, "unbalanced validity flag")
assertTrue(
  identical(UnbalancedResult$diagnostics$residualType, "globalLoad"),
  "unbalanced residual classification"
)
assertNear(
  UnbalancedResult$diagnostics$globalLoads["forceZ"],
  -pi,
  2e-8,
  "unbalanced global force"
)
assertNear(
  UnbalancedResult$diagnostics$closureConsistencyResidual,
  0,
  2e-10,
  "unbalanced physical versus numerical closure"
)
SmallUnbalance <- newRingLoad(
  radial = function(theta) -1 + 5e-9 * cos(theta),
  label = "small first harmonic imbalance",
  source = "adversarial test",
  representation = "uniform plus first radial harmonic"
)
SmallUnbalanceAccepted <- solveRingDirect(
  load = SmallUnbalance,
  radius = 1,
  theta = Theta,
  integrationSteps = 4096L
)
assertTrue(
  identical(SmallUnbalanceAccepted$diagnostics$residualType, "none"),
  "small imbalance below declared tolerance"
)
assertError(
  function() solveRingDirect(
    load = SmallUnbalance,
    radius = 1,
    theta = Theta,
    integrationSteps = 4096L,
    balanceTolerance = 1e-10
  ),
  "small imbalance above tightened tolerance",
  "non-zero global resultant"
)

# 2. Baker (1968), Tables XIII-XIV, printed pp. 50-51/PDF pp. 54-55.
bakerLoad <- function(halfAngleDeg) {
  HalfAngle <- halfAngleDeg * pi / 180
  Breakpoints <- c(
    HalfAngle,
    pi - HalfAngle,
    pi + HalfAngle,
    2 * pi - HalfAngle
  )
  Breakpoints <- Breakpoints[Breakpoints > 0 & Breakpoints < 2 * pi]
  newRingLoad(
    radial = function(theta) {
      Active <- theta <= HalfAngle |
        theta >= 2 * pi - HalfAngle |
        (theta >= pi - HalfAngle & theta <= pi + HalfAngle)
      -Active / (2 * HalfAngle)
    },
    label = paste("Baker patch", halfAngleDeg, "deg"),
    source = "Baker (1968)",
    representation = "two opposite uniform radial patches",
    breakpoints = sort(unique(Breakpoints))
  )
}

BakerAngles <- c(0, 30, 60, 90) * pi / 180
BakerPublished <- list(
  `30` = list(
    N = c(-0.128, -0.239, -0.413, -0.477),
    M = c(0.190, 0.080, -0.095, -0.159)
  ),
  `60` = list(
    N = c(-0.239, -0.271, -0.358, -0.413),
    M = c(0.080, 0.048, -0.040, -0.095)
  )
)
for (x in c(30, 60)) {
  Baker <- solveRingDirect(
    load = bakerLoad(x),
    radius = 1,
    theta = BakerAngles,
    integrationSteps = 16384L
  )
  Published <- BakerPublished[[as.character(x)]]
  assertNear(
    Baker$values$normalForce,
    Published$N,
    6e-4,
    paste("Baker N", x)
  )
  assertNear(
    Baker$values$bendingMoment,
    Published$M,
    6e-4,
    paste("Baker M", x)
  )
}

# 3. USACE Appendix D4. Factors are passed explicitly because the EM contains
# internal conflicts; this test reproduces D4 literally rather than choosing a
# governing design factor.
Usace <- usaceCmpThrust(
  deadCrownPressure = usaceCrownPressure(120, 30),
  span = 3,
  deadLoadFactor = 1.95,
  demandModifier = 1.10,
  factorBasis = "Appendix D4 literal values"
)
assertNear(Usace$deadCrownPressure, 3600, 1e-10, "USACE D4 crown pressure")
assertNear(Usace$factoredThrust, 10530, 1e-10, "USACE D4 factored thrust")
assertNear(Usace$designDemand, 11583, 1e-10, "USACE D4 modified demand")
UsaceSurrogate <- solveRingDirect(
  load = usaceUniformSurrogate(Usace, "factoredThrust"),
  radius = Usace$equivalentRadius,
  theta = Theta,
  integrationSteps = 4096L
)
assertNear(
  UsaceSurrogate$values$normalForce,
  -Usace$factoredThrust,
  1e-5,
  "USACE equal-thrust surrogate"
)
assertError(
  function() solveRingDirect(
    load = usaceUniformSurrogate(Usace, "factoredThrust"),
    radius = 2 * Usace$equivalentRadius,
    theta = Theta
  ),
  "USACE surrogate radius contract",
  "requires radius"
)

# 4. FHWA Eq. 5.1 and Table 5.5, printed pp. 177-178/PDF pp. 192-193.
Fhwa <- data.frame(
  forceKn = c(20.5, 20.5, 5.2, 5.2, 5.2, 5.2, 4, 4, 4),
  phiDeg = c(36, 28, 36, 28, 36, 28, 36, 28, 36),
  diameterMm = c(970, 970, 970, 970, 1575, 1575, 970, 970, 1575),
  publishedKpa = c(3.4, 7.2, 0.9, 1.8, 0.3, 0.5, 0.7, 1.4, 0.2)
)
Fhwa$calculatedKpa <- vapply(seq_len(nrow(Fhwa)), function(i) {
  fhwaCompactionPressure(
    compactorForceKn = Fhwa$forceKn[i],
    looseFrictionAngleDeg = Fhwa$phiDeg[i],
    centroidalDiameterMm = Fhwa$diameterMm[i]
  )
}, numeric(1))
assertNear(
  round(Fhwa$calculatedKpa, 1),
  Fhwa$publishedKpa,
  0,
  "FHWA Table 5.5 rounded values"
)
assertNear(
  fhwaSuggestedConstrainedModulus()$CL90,
  c(1.76, 2.21, 2.45, 2.72, 3.07, 3.62),
  0,
  "FHWA Table 3.6 CL90"
)

FhwaBand <- fhwaCompactionBandLoad(
  pressureKpa = Fhwa$calculatedKpa[1L],
  radiusM = 0.485,
  fillSurfaceDepthBelowCrownM = 0.485,
  bandDepthM = 0.300
)
FhwaStage <- solveRingDirect(
  load = FhwaBand,
  radius = 0.485,
  theta = Theta,
  integrationSteps = 4096L
)
assertNear(
  FhwaStage$diagnostics$globalLoads,
  0,
  2e-7,
  "FHWA symmetric band global balance"
)
FhwaRefinement <- compareRingRefinement(
  load = FhwaBand,
  radius = 0.485,
  theta = Theta,
  integrationSteps = 2048L
)
assertTrue(
  all(FhwaRefinement$maximumDifference < c(2e-5, 2e-5, 2e-5)),
  "FHWA band refinement"
)
FhwaInvertBand <- fhwaCompactionBandLoad(
  pressureKpa = 10,
  radiusM = 1,
  fillSurfaceDepthBelowCrownM = 1.9,
  bandDepthM = 0.3
)
assertTrue(
  any(abs(FhwaInvertBand$breakpoints - pi) < 1e-14),
  "FHWA invert breakpoint"
)
FhwaInvertStage <- solveRingDirect(
  load = FhwaInvertBand,
  radius = 1,
  theta = Theta,
  integrationSteps = 129L
)
assertNear(
  FhwaInvertStage$diagnostics$normalizedGlobalLoads,
  0,
  2e-9,
  "FHWA invert band balance"
)

# 5. Nunez versions remain separate. The 2000 circular equations reproduce
# their printed examples; the 2014 equations use a different normal-force
# construction. The 2014 tensor surrogate then reproduces only the three
# quantities stated in its contract.
Nunez2000Primary <- nunez2000CircularResultants(
  diameter = 10,
  depthAxis = 15,
  unitWeight = 1.9,
  surfaceLoad = 1,
  k0 = 0.5,
  relaxation = 0.5,
  interactionRatio = 0.027
)
assertNear(
  Nunez2000Primary$momentCrown,
  1.212,
  5e-4,
  "Nunez 2000 primary M"
)
assertNear(
  Nunez2000Primary$normalCrown,
  54.34,
  1e-2,
  "Nunez 2000 primary NC"
)
Nunez2000Permanent <- nunez2000CircularResultants(
  diameter = 10,
  depthAxis = 15,
  unitWeight = 1.9,
  surfaceLoad = 1,
  k0 = 0.5,
  relaxation = 1,
  interactionRatio = 0.10976
)
assertNear(
  Nunez2000Permanent$normalCrown,
  103.33,
  1e-2,
  "Nunez 2000 permanent NC"
)
assertNear(
  Nunez2000Permanent$normalSpringline,
  147.5,
  1e-10,
  "Nunez 2000 permanent NA"
)

Nunez <- nunez2014Resultants(
  diameter = 10,
  depthAxis = 15,
  unitWeight = 1.9,
  surfaceLoad = 1,
  k0 = 0.5,
  relaxation = 0.5,
  interactionRatio = 0.027
)
NunezAngles <- c(0, pi / 2, pi)
NunezEquivalentLoad <- nunezEquivalentTensorLoad(Nunez)
NunezEquivalent <- solveRingDirect(
  load = NunezEquivalentLoad,
  radius = 5,
  theta = NunezAngles,
  integrationSteps = 4096L
)
assertNear(
  NunezEquivalent$values$bendingMoment[1L],
  Nunez$momentMaximum,
  2e-8,
  "Nunez equivalent Mmax"
)
assertNear(
  -NunezEquivalent$values$normalForce[2L],
  Nunez$normalSpringline,
  2e-8,
  "Nunez equivalent springline N"
)
assertNear(
  -mean(NunezEquivalent$values$normalForce[c(1L, 3L)]),
  mean(c(Nunez$normalCrown, Nunez$normalInvert)),
  2e-8,
  "Nunez equivalent mean crown-invert N"
)
assertError(
  function() solveRingDirect(
    load = NunezEquivalentLoad,
    radius = 4.9,
    theta = NunezAngles
  ),
  "Nunez surrogate radius contract",
  "requires radius"
)
assertError(
  function() solveRingDirect(
    load = NunezEquivalentLoad,
    radius = 5,
    theta = NunezAngles,
    sectionRatio = 0.01
  ),
  "Nunez surrogate section contract",
  "requires sectionRatio"
)

# 6. Schwartz-Einstein (1980): four source-native branches and HP97.
SchwartzCases <- data.frame(
  sequence = c("excavation", "excavation", "external", "external"),
  interface = c("fullSlip", "noSlip", "fullSlip", "noSlip"),
  expectedThrust = c(
    0.7359093017,
    0.8118059007,
    0.8870607441,
    1.0171691994
  ),
  expectedMoment = c(
    0.007743362832,
    0.007065714627,
    0.013274336283,
    0.012112653646
  ),
  expectedShearDerived = c(
    -0.02682379569,
    -0.02447635345,
    -0.04598364976,
    -0.04195946306
  ),
  publishedThrust = c(0.736, 0.812, 0.887, 1.02),
  publishedMoment = c(0.00774, 0.00707, 0.0133, 0.0121),
  stringsAsFactors = FALSE
)

for (i in seq_len(nrow(SchwartzCases))) {
  Case <- SchwartzCases[i, , drop = FALSE]
  Result <- schwartzEinsteinResultants(
    theta = pi / 6,
    verticalStress = 1,
    stressRatio = 0.5,
    radius = 1,
    cStar = 0.05,
    fStar = 100,
    groundPoisson = 0.4,
    sequence = Case$sequence,
    interface = Case$interface
  )
  Label <- paste("Schwartz-Einstein HP97", Case$sequence, Case$interface)
  assertNear(Result$response$thrust, Case$expectedThrust, 5e-10, paste(Label, "T"))
  assertNear(Result$response$moment, Case$expectedMoment, 5e-11, paste(Label, "M"))
  assertNear(
    Result$response$shear,
    Case$expectedShearDerived,
    5e-10,
    paste(Label, "derived Q")
  )
  assertNear(
    signif(Result$response$thrust, 3),
    Case$publishedThrust,
    5e-15,
    paste(Label, "published rounded T")
  )
  assertNear(
    signif(Result$response$moment, 3),
    Case$publishedMoment,
    5e-15,
    paste(Label, "published rounded M")
  )
  assertTrue(
    identical(unname(Result$provenance["shear"]), "derivedFromPublishedEquilibrium"),
    paste(Label, "Q provenance")
  )

  Grid <- schwartzEinsteinResultants(
    theta = seq(0, 2 * pi, length.out = 4097),
    verticalStress = 1,
    stressRatio = 0.5,
    radius = 1,
    cStar = 0.05,
    fStar = 100,
    groundPoisson = 0.4,
    sequence = Case$sequence,
    interface = Case$interface
  )
  assertNear(
    c(
      min(Grid$response$thrust),
      max(Grid$response$thrust),
      max(abs(Grid$response$moment)),
      max(abs(Grid$response$shear))
    ),
    Grid$extrema$values[c(
      "thrustMin",
      "thrustMax",
      "momentAbsMax",
      "shearAbsMax"
    )],
    2e-14,
    paste(Label, "analytical extrema")
  )

  DifferenceStep <- 1e-6
  MomentAtDifferencePoints <- schwartzEinsteinResultants(
    theta = pi / 6 + c(-DifferenceStep, DifferenceStep),
    verticalStress = 1,
    stressRatio = 0.5,
    radius = 1,
    cStar = 0.05,
    fStar = 100,
    groundPoisson = 0.4,
    sequence = Case$sequence,
    interface = Case$interface
  )$response$moment
  FiniteDifferenceShear <- diff(MomentAtDifferencePoints) /
    (2 * DifferenceStep)
  assertNear(
    Result$response$shear,
    FiniteDifferenceShear,
    3e-10,
    paste(Label, "finite-difference Q")
  )

  Axisymmetric <- schwartzEinsteinResultants(
    theta = c(0, 0.37, pi / 2),
    verticalStress = 1,
    stressRatio = 1,
    radius = 1,
    cStar = 0.05,
    fStar = 100,
    groundPoisson = 0.4,
    sequence = Case$sequence,
    interface = Case$interface
  )
  assertNear(
    Axisymmetric$amplitudes[c("thrust2", "moment2")],
    0,
    1e-15,
    paste(Label, "K=1 amplitudes")
  )
  assertNear(Axisymmetric$response$moment, 0, 1e-15, paste(Label, "K=1 M"))
  assertNear(Axisymmetric$response$shear, 0, 1e-15, paste(Label, "K=1 Q"))
  assertTrue(
    Axisymmetric$extrema$angles$momentAbsMax$allAngles,
    paste(Label, "K=1 angular degeneracy")
  )
}

# The factored external/no-slip expression remains finite close to the
# incompressible limit. The limit nu=0.5 itself remains outside the source
# domain and is rejected.
NearIncompressible <- schwartzEinsteinResultants(
  theta = c(0, 0.4),
  verticalStress = 1,
  stressRatio = 0.5,
  radius = 1,
  cStar = 0.05,
  fStar = 100,
  groundPoisson = 0.499999,
  sequence = "external",
  interface = "noSlip"
)
assertTrue(
  all(is.finite(as.matrix(NearIncompressible$response[, -c(1L, 2L)]))),
  "Schwartz-Einstein stable no-slip expression"
)
assertError(
  function() schwartzEinsteinResultants(
    theta = 0,
    verticalStress = 1,
    stressRatio = 0.5,
    radius = 1,
    cStar = 0.05,
    fStar = 100,
    groundPoisson = 0.5,
    sequence = "external",
    interface = "noSlip"
  ),
  "Schwartz-Einstein Poisson domain",
  "less than 0.5"
)
assertError(
  function() schwartzEinsteinResultants(
    theta = 0,
    verticalStress = c(1, 2),
    stressRatio = 0.5,
    radius = 1,
    cStar = 0.05,
    fStar = 100,
    groundPoisson = 0.4,
    sequence = "external",
    interface = "fullSlip"
  ),
  "Schwartz-Einstein scalar contract",
  "one finite numeric value"
)

# Stable no-slip forms are checked against literal transcriptions of the
# published equations at four stiffness scales. This verifies only the
# algebraic rewrite, not the physical model.
SchwartzStableCases <- data.frame(
  cStar = c(0.01, 0.05, 1, 100),
  fStar = c(1, 100, 10, 0.1),
  poisson = c(0, 0.4, 0.2, 0.49)
)
for (i in seq_len(nrow(SchwartzStableCases))) {
  Case <- SchwartzStableCases[i, , drop = FALSE]
  CStar <- Case$cStar
  FStar <- Case$fStar
  Nu <- Case$poisson
  U <- 1 - Nu

  BHatLiteral <- ((6 + FStar) * CStar * U + 2 * FStar * Nu) /
    (3 * FStar + 3 * CStar + 2 * CStar * FStar * U)
  B2Literal <- CStar * U /
    (2 * (CStar * U + 4 * Nu - 6 * BHatLiteral -
      3 * BHatLiteral * CStar * U))
  A2Literal <- BHatLiteral * B2Literal
  ExcavationStable <- .schwartzEinsteinAmplitudes(
    cStar = CStar,
    fStar = FStar,
    groundPoisson = Nu,
    stressRatio = 0.5,
    sequence = "excavation",
    interface = "noSlip"
  )
  assertNear(
    ExcavationStable$coefficients[c("bHat", "b2Star", "a2Star")],
    c(bHat = BHatLiteral, b2Star = B2Literal, a2Star = A2Literal),
    5e-12,
    paste("Schwartz-Einstein stable excavation no-slip case", i)
  )

  AHatLiteral <- FStar * U / 6 * ((3 - 2 * Nu) + CStar * U) +
    CStar * U / (1 - 2 * Nu) * (2.5 - 8 * Nu + 6 * Nu^2) +
    6 - 8 * Nu
  A2ExternalLiteral <- (
    FStar * U / 6 * ((1 - 2 * Nu) - CStar * U) -
      0.5 * CStar * U * (1 - 2 * Nu) + 2
  ) / AHatLiteral
  A3ExternalLiteral <- (
    FStar * U / 6 * (CStar * U + 1) - 0.5 * CStar * U - 2
  ) / AHatLiteral
  ExternalStable <- .schwartzEinsteinAmplitudes(
    cStar = CStar,
    fStar = FStar,
    groundPoisson = Nu,
    stressRatio = 0.5,
    sequence = "external",
    interface = "noSlip"
  )
  assertNear(
    ExternalStable$coefficients[c("aHat", "a2", "a3")],
    c(aHat = AHatLiteral, a2 = A2ExternalLiteral, a3 = A3ExternalLiteral),
    5e-12,
    paste("Schwartz-Einstein stable external no-slip case", i)
  )
}

Stiffness <- schwartzEinsteinStiffness(
  radius = 2,
  groundModulus = 30,
  groundPoisson = 0.3,
  supportModulus = 200000,
  supportPoisson = 0.25,
  supportArea = 0.01,
  supportInertia = 1e-5
)
SimilarStiffness <- schwartzEinsteinStiffness(
  radius = 6,
  groundModulus = 30,
  groundPoisson = 0.3,
  supportModulus = 200000,
  supportPoisson = 0.25,
  supportArea = 0.03,
  supportInertia = 27e-5
)
assertNear(
  unlist(Stiffness[c("cStar", "fStar")]),
  unlist(SimilarStiffness[c("cStar", "fStar")]),
  1e-13,
  "Schwartz-Einstein geometric similarity"
)

# 7. CANDE-2025 Level 1, Table 1.1.1-1. The numerical case is a
# project-declared formula benchmark, not a numerical result printed by CANDE.
CandeAngles <- c(0, pi / 4, pi / 2)
CandeExpected <- list(
  bonded = data.frame(
    radialPressure = c(20.257481, 16.666667, 13.075853),
    tangentialPressure = c(0, 17.703549, 0),
    radialDisplacement = c(0.621956, 2.083333, 3.544711) / 1000,
    tangentialDisplacement = c(0, 1.283925, 0) / 1000,
    moment = c(2.586987, 0.833333, -0.920320),
    thrust = c(27.272095, 16.666667, 6.061239),
    shear = c(0, -3.507307, 0)
  ),
  frictionless = data.frame(
    radialPressure = c(11.162080, 16.666667, 22.171254),
    tangentialPressure = c(0, 0, 0),
    radialDisplacement = c(0.554281, 2.083333, 3.612385) / 1000,
    tangentialDisplacement = c(0, 0.764526, 0) / 1000,
    moment = c(2.668196, 0.833333, -1.001529),
    thrust = c(18.501529, 16.666667, 14.831804),
    shear = c(0, -3.669725, 0)
  )
)
CandeEquilibriumRadius <- 2.3

for (s in names(CandeExpected)) {
  Cande <- candeLevel1Response(
    theta = CandeAngles,
    overburdenPressure = 100,
    radius = 1,
    groundShearModulus = 20000,
    groundPoisson = 1 / 3,
    alpha = 0.2,
    beta = 0.01,
    interface = s
  )
  Expected <- CandeExpected[[s]]
  for (v in names(Expected)) {
    Tolerance <- if (grepl("Displacement", v)) 6e-10 else 6e-6
    assertNear(
      Cande$response[[v]],
      Expected[[v]],
      Tolerance,
      paste("CANDE Level 1", s, v)
    )
  }

  DifferenceStep <- 1e-6
  Equilibrium <- candeLevel1Response(
    theta = 0.37 + c(-DifferenceStep, 0, DifferenceStep),
    overburdenPressure = 100,
    radius = CandeEquilibriumRadius,
    groundShearModulus = 20000,
    groundPoisson = 1 / 3,
    alpha = 0.2,
    beta = 0.01,
    interface = s
  )$response
  Derivative <- function(value) diff(value[c(1L, 3L)]) /
    (2 * DifferenceStep)
  Residual <- c(
    tangential = Derivative(Equilibrium$thrust) -
      Equilibrium$shear[2L] +
      CandeEquilibriumRadius * Equilibrium$tangentialPressure[2L],
    radial = Derivative(Equilibrium$shear) +
      Equilibrium$thrust[2L] -
      CandeEquilibriumRadius * Equilibrium$radialPressure[2L],
    moment = Derivative(Equilibrium$moment) -
      CandeEquilibriumRadius * Equilibrium$shear[2L]
  )
  assertNear(
    Residual,
    0,
    2e-8,
    paste(
      "CANDE Level 1",
      s,
      "differential equilibrium at non-unit radius"
    )
  )
}

CandeParameters <- candeLevel1Parameters(
  radius = 1,
  groundShearModulus = 20000,
  groundPoisson = 1 / 3,
  pipeYoungModulus = 187500,
  pipePoisson = 0.25,
  wallArea = 0.04,
  wallInertia = 0.002
)
assertNear(
  unlist(CandeParameters[c("stressRatio", "alpha", "beta")]),
  c(0.5, 0.2, 0.01),
  1e-14,
  "CANDE Level 1 dimensional parameters"
)

# 8. Monte Carlo runner: realized draws in, quantiles and grid extrema out.
Draws <- data.frame(
  effectiveVertical = c(80, 100, 120, 110),
  k0 = c(0.4, 0.5, 0.6, 0.55),
  porePressure = c(0, 10, 20, 5)
)
MonteCarlo <- runRingMonteCarlo(
  draws = Draws,
  responseFunction = function(draw, theta) {
    solveK0Closed(
      effectiveVertical = draw$effectiveVertical,
      k0 = draw$k0,
      porePressure = draw$porePressure,
      radius = Radius,
      theta = theta,
      interface = "fullTraction"
    )
  },
  theta = Theta,
  probabilities = c(0.05, 0.50, 0.95),
  modelLabel = "K0 test",
  keepSampleCurves = TRUE
)
assertTrue(MonteCarlo$sampleCount == nrow(Draws), "Monte Carlo sample count")
assertTrue(
  nrow(MonteCarlo$pointwiseQuantiles) ==
    3L * 3L * length(Theta),
  "Monte Carlo pointwise row count"
)
assertTrue(
  all(MonteCarlo$extremaSamples$value[
    MonteCarlo$extremaSamples$statistic == "absoluteMaximum"
  ] >= 0),
  "Monte Carlo absolute extrema"
)
SingleQuantile <- runRingMonteCarlo(
  draws = Draws[1L, , drop = FALSE],
  responseFunction = function(draw, theta) {
    solveK0Closed(
      effectiveVertical = draw$effectiveVertical,
      k0 = draw$k0,
      porePressure = draw$porePressure,
      radius = Radius,
      theta = theta,
      interface = "fullTraction"
    )
  },
  theta = Theta,
  probabilities = 0.5,
  modelLabel = "single-quantile test"
)
assertTrue(
  nrow(SingleQuantile$pointwiseQuantiles) == 3L * length(Theta),
  "Monte Carlo single probability"
)
ScalarOutput <- runOutputMonteCarlo(
  draws = Draws,
  outputFunction = function(draw) c(
    vertical = draw$effectiveVertical,
    horizontal = draw$effectiveVertical * draw$k0
  ),
  probabilities = 0.5,
  modelLabel = "scalar-output test",
  keepSamples = FALSE
)
assertTrue(nrow(ScalarOutput$quantiles) == 2L, "scalar output Monte Carlo")
assertTrue(is.null(ScalarOutput$samples), "scalar output sample retention")
assertError(
  function() runOutputMonteCarlo(
    draws = Draws,
    outputFunction = function(draw) c(value = draw$k0),
    modelLabel = "invalid keepSamples test",
    keepSamples = NA
  ),
  "scalar output keepSamples validation",
  "keepSamples"
)

# Boundary validation utilities.
assertError(
  function() usaceCmpThrust(
    deadCrownPressure = c(10, 20),
    span = 2,
    deadLoadFactor = 1.5,
    demandModifier = 1,
    factorBasis = "test"
  ),
  "USACE scalar inputs",
  "one finite numeric value"
)
assertError(
  function() nunezInteractionRatio(
    diameter = 2,
    thickness = c(0.1, 0.2),
    liningYoungModulus = 25e6,
    soilYoungModulus = 50e3,
    liningPoisson = 0.2,
    soilPoisson = 0.3,
    contactFactor = 1
  ),
  "Nunez interaction scalar thickness",
  "one finite numeric value"
)
assertError(
  function() nunezInteractionRatio(
    diameter = 2,
    thickness = 0.1,
    liningYoungModulus = 25e6,
    soilYoungModulus = 50e3,
    liningPoisson = c(0.2, 0.25),
    soilPoisson = 0.3,
    contactFactor = 1
  ),
  "Nunez interaction scalar Poisson ratio",
  "one finite numeric value"
)
assertError(
  function() nunez2000CircularResultants(
    diameter = 2,
    depthAxis = c(15, 16),
    unitWeight = 18,
    surfaceLoad = 0,
    k0 = 0.5,
    relaxation = 0.3,
    interactionRatio = 1
  ),
  "Nunez 2000 scalar depth",
  "one finite numeric value"
)
assertError(
  function() nunez2014Resultants(
    diameter = 2,
    depthAxis = 15,
    unitWeight = 18,
    surfaceLoad = 0,
    k0 = c(0.4, 0.5),
    relaxation = 0.3,
    interactionRatio = 1
  ),
  "Nunez 2014 scalar K0",
  "one finite numeric value"
)
assertError(
  function() layeredEffectiveVerticalStress(
    depth = 1,
    layerBottom = c(Inf, Inf),
    effectiveUnitWeight = c(10, 10)
  ),
  "layer bottom validation",
  "increase strictly"
)
Layered <- layeredEffectiveVerticalStress(
  depth = c(0, 2, 5),
  layerBottom = c(3, Inf),
  effectiveUnitWeight = c(10, 20),
  effectiveSurcharge = 5
)
assertNear(Layered, c(5, 25, 75), 1e-14, "layered vertical stress")
AngleEcho <- newRingLoad(
  radial = function(theta) theta,
  label = "angle normalization test",
  source = "test",
  representation = "non-periodic diagnostic function"
)
EchoValues <- evaluateRingLoad(AngleEcho, c(1, 2 * pi + 1))
assertNear(
  EchoValues$radialOutward,
  rep(1, 2),
  1e-14,
  "load evaluation angle normalization"
)

# Fourier remains an independent comparator and is sourced in isolation so its
# historical function names cannot replace the production API.
FourierEnvironment <- new.env(parent = globalenv())
sys.source(
  file.path(ProjectRoot, "scripts", "R", "ringFourier.R"),
  envir = FourierEnvironment
)
FourierTheta <- (0:255) * 2 * pi / 256
FourierApplied <- evaluateRingLoad(
  k0TensorLoad(100, 0.5, 20, interface = "fullTraction"),
  FourierTheta
)
FourierSpectrum <- FourierEnvironment$fitRingSpectrum(
  theta = FourierTheta,
  radialOutward = FourierApplied$radialOutward,
  tangentialPositive = FourierApplied$tangentialPositive,
  maxMode = 4L
)
FourierResponse <- FourierEnvironment$solveRingSpectrum(
  spectrum = FourierSpectrum,
  radius = 2,
  uniformMoment = "membrane"
)
FourierValues <- FourierEnvironment$evaluateRingResponse(
  FourierResponse,
  Theta
)
FourierReference <- solveK0Closed(
  effectiveVertical = 100,
  k0 = 0.5,
  porePressure = 20,
  radius = 2,
  theta = Theta,
  interface = "fullTraction"
)
DirectDiagnosticNames <- sort(names(solveRingDirect(
  load = k0TensorLoad(100, 0.5, 20, interface = "fullTraction"),
  radius = 2,
  theta = Theta
)$diagnostics))
assertTrue(
  identical(DirectDiagnosticNames, sort(names(FourierReference$diagnostics))),
  "closed and direct diagnostic schema"
)
assertNear(
  as.matrix(FourierValues[, c("normalForce", "bendingMoment", "shearForce")]),
  as.matrix(FourierReference$values[, c(
    "normalForce", "bendingMoment", "shearForce"
  )]),
  2e-10,
  "isolated Fourier comparator"
)

# Corrugated section closure: the same eta must produce the same n=0+n=2
# resultants in the direct/closed and independent Fourier implementations.
CorrugatedResponse <- FourierEnvironment$solveRingSpectrum(
  spectrum = FourierSpectrum,
  radius = 1.315,
  uniformMoment = "section",
  sectionRatio = MaiSection$sectionRatio
)
CorrugatedValues <- FourierEnvironment$evaluateRingResponse(
  CorrugatedResponse,
  Theta
)
CorrugatedReference <- solveK0Closed(
  effectiveVertical = 100,
  k0 = 0.5,
  porePressure = 20,
  radius = 1.315,
  theta = Theta,
  interface = "fullTraction",
  sectionRatio = MaiSection$sectionRatio
)
assertNear(
  as.matrix(CorrugatedValues[, c(
    "normalForce", "bendingMoment", "shearForce"
  )]),
  as.matrix(CorrugatedReference$values[, c(
    "normalForce", "bendingMoment", "shearForce"
  )]),
  2e-10,
  "corrugated section direct-Fourier parity"
)

# The historical rectangular Baker input remains numerically identical to
# passing its section ratio explicitly.
BakerThickness <- 0.060
BakerRatio <- BakerThickness^2 / (12 * 1.315^2)
BakerResponse <- FourierEnvironment$solveRingSpectrum(
  spectrum = FourierSpectrum,
  radius = 1.315,
  thickness = BakerThickness,
  uniformMoment = "baker"
)
SectionResponse <- FourierEnvironment$solveRingSpectrum(
  spectrum = FourierSpectrum,
  radius = 1.315,
  uniformMoment = "section",
  sectionRatio = BakerRatio
)
assertNear(
  as.matrix(BakerResponse[, c(
    "nCos", "nSin", "mCos", "mSin", "qCos", "qSin"
  )]),
  as.matrix(SectionResponse[, c(
    "nCos", "nSin", "mCos", "mSin", "qCos", "qSin"
  )]),
  1e-14,
  "Baker thickness versus explicit section ratio"
)

# Optional cross-language oracle. Export a CSV with columns theta,N,M,Q from
# scripts/wolfram/soT.nb, then set RING_WOLFRAM_ORACLE to that file.
OraclePath <- Sys.getenv("RING_WOLFRAM_ORACLE", unset = "")
if (nzchar(OraclePath)) {
  if (!file.exists(OraclePath)) {
    stop("RING_WOLFRAM_ORACLE does not exist: ", OraclePath, call. = FALSE)
  }
  Oracle <- read.csv(OraclePath, check.names = FALSE)
  OracleTheta <- Oracle$theta
  RResponse <- solveRingDirect(
    load = k0TensorLoad(100, 0.5, 20, interface = "fullTraction"),
    radius = 2,
    theta = OracleTheta,
    integrationSteps = 8192L
  )
  assertNear(RResponse$values$normalForce, Oracle$N, 2e-8, "R-Wolfram N")
  assertNear(RResponse$values$bendingMoment, Oracle$M, 2e-8, "R-Wolfram M")
  assertNear(RResponse$values$shearForce, Oracle$Q, 2e-8, "R-Wolfram Q")
}

message(
  paste0(
    "PASS: direct mechanics, Fourier, Baker, USACE, FHWA, Nunez, ",
    "Schwartz-Einstein, CANDE, and sample aggregation"
  ),
  if (nzchar(OraclePath)) ", and Wolfram parity." else "."
)
