# Rebuilds the auditable benchmark tables used by the ring methodology.
#
# Outputs are written only to TITO/kb/benchmarks. Existing files with the
# declared names are overwritten. The corrugated-section table includes one
# explicitly labelled preliminary geometry for numerical evaluation; it is not
# a project demand or an as-built property. Run from any directory with:
#
#   Rscript scripts/R/runRingBenchmarks.R

Arguments <- commandArgs(trailingOnly = FALSE)
FileArgument <- grep("^--file=", Arguments, value = TRUE)
if (length(FileArgument) != 1L) {
  stop("Run with Rscript scripts/R/runRingBenchmarks.R.", call. = FALSE)
}
ScriptPath <- normalizePath(sub("^--file=", "", FileArgument))
ProjectRoot <- normalizePath(file.path(dirname(ScriptPath), "..", ".."))
OutputDirectory <- file.path(ProjectRoot, "TITO", "kb", "benchmarks")
if (!dir.exists(OutputDirectory)) {
  dir.create(OutputDirectory, recursive = TRUE)
}

source(file.path(ProjectRoot, "scripts", "R", "ringDirect.R"))
source(file.path(ProjectRoot, "scripts", "R", "ringLoads.R"))
source(file.path(ProjectRoot, "scripts", "R", "ringInteraction.R"))

writeBenchmark <- function(table, fileName) {
  Path <- file.path(OutputDirectory, fileName)
  write.csv(table, Path, row.names = FALSE, na = "UNKNOWN")
  Path
}

# ---------------------------------------------------------------------------
# 1. Mechanics: exact solutions and Baker's published ring tables.
# ---------------------------------------------------------------------------

Theta <- (0:180) * 2 * pi / 181
Radius <- 2
Pressure <- 12.3
UniformLoad <- newRingLoad(
  radial = function(theta) rep(-Pressure, length(theta)),
  label = "uniform pressure benchmark",
  source = "thin-ring equilibrium",
  representation = "uniform radial pressure"
)
Uniform <- solveRingDirect(
  load = UniformLoad,
  radius = Radius,
  theta = Theta,
  integrationSteps = 4096L
)

MechanicsRows <- list(data.frame(
  case = "uniform pressure",
  quantity = c("N", "M", "Q"),
  maximumAbsoluteError = c(
    max(abs(Uniform$values$normalForce + Pressure * Radius)),
    max(abs(Uniform$values$bendingMoment)),
    max(abs(Uniform$values$shearForce))
  ),
  reference = c("N=-pR", "M=0", "Q=0"),
  tolerance = 2e-8,
  stringsAsFactors = FALSE
))

for (Interface in c("fullTraction", "normalOnly")) {
  K0Load <- k0TensorLoad(
    effectiveVertical = 100,
    k0 = 0.5,
    porePressure = 20,
    interface = Interface
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
    interface = Interface,
    sectionRatio = 0.02
  )
  MechanicsRows[[length(MechanicsRows) + 1L]] <- data.frame(
    case = paste("K0 direct versus closed", Interface),
    quantity = c("N", "M", "Q"),
    maximumAbsoluteError = c(
      max(abs(Direct$values$normalForce - Closed$values$normalForce)),
      max(abs(Direct$values$bendingMoment - Closed$values$bendingMoment)),
      max(abs(Direct$values$shearForce - Closed$values$shearForce))
    ),
    reference = "closed n=0+n=2 solution",
    tolerance = 3e-8,
    stringsAsFactors = FALSE
  )
}
MechanicsTable <- do.call(rbind, MechanicsRows)

bakerLoad <- function(halfAngleDeg) {
  HalfAngle <- halfAngleDeg * pi / 180
  Breakpoints <- c(
    HalfAngle,
    pi - HalfAngle,
    pi + HalfAngle,
    2 * pi - HalfAngle
  )
  newRingLoad(
    radial = function(theta) {
      Active <- theta <= HalfAngle |
        theta >= 2 * pi - HalfAngle |
        (theta >= pi - HalfAngle & theta <= pi + HalfAngle)
      -Active / (2 * HalfAngle)
    },
    label = paste("Baker diametric patches", halfAngleDeg, "degrees"),
    source = "Baker (1968), Tables XIII-XIV",
    representation = "two opposite uniform radial patches",
    breakpoints = sort(unique(Breakpoints))
  )
}

BakerAnglesDeg <- c(0, 30, 60, 90)
BakerPublished <- list(
  `30` = list(
    N = c(-0.128, -0.239, -0.413, -0.477),
    M = c(0.190, 0.080, -0.095, -0.159),
    sourceLocation = "printed p. 50/PDF p. 54"
  ),
  `60` = list(
    N = c(-0.239, -0.271, -0.358, -0.413),
    M = c(0.080, 0.048, -0.040, -0.095),
    sourceLocation = "printed p. 51/PDF p. 55"
  )
)
BakerRows <- lapply(c(30, 60), function(HalfAngleDeg) {
  Published <- BakerPublished[[as.character(HalfAngleDeg)]]
  Response <- solveRingDirect(
    load = bakerLoad(HalfAngleDeg),
    radius = 1,
    theta = BakerAnglesDeg * pi / 180,
    integrationSteps = 16384L
  )
  data.frame(
    halfAngleDeg = HalfAngleDeg,
    thetaDeg = BakerAnglesDeg,
    publishedNbar = Published$N,
    calculatedNbar = Response$values$normalForce,
    errorNbar = Response$values$normalForce - Published$N,
    publishedMbar = Published$M,
    calculatedMbar = Response$values$bendingMoment,
    errorMbar = Response$values$bendingMoment - Published$M,
    sourceLocation = Published$sourceLocation,
    stringsAsFactors = FALSE
  )
})
BakerTable <- do.call(rbind, BakerRows)

# ---------------------------------------------------------------------------
# 2. USACE: scalar CMP thrust, kept separate from angular load surrogates.
# ---------------------------------------------------------------------------

Usace <- usaceCmpThrust(
  deadCrownPressure = usaceCrownPressure(120, 30),
  span = 3,
  deadLoadFactor = 1.95,
  demandModifier = 1.10,
  factorBasis = "Appendix D4 literal values"
)
UsaceTable <- data.frame(
  quantity = c(
    "dead crown pressure",
    "dead service thrust",
    "factored thrust",
    "modified design demand"
  ),
  publishedValue = c(3600, NA, 10530, 11583),
  calculatedValue = c(
    Usace$deadCrownPressure,
    Usace$deadServiceThrust,
    Usace$factoredThrust,
    Usace$designDemand
  ),
  unit = c("lb/ft2", "lb/ft", "lb/ft", "lb/ft"),
  evidence = c("published", "derived from Eq. 4-20", "published", "published"),
  sourceLocation = c(
    "Appendix D4 printed p. 332/PDF p. 346",
    "Eq. 4-20 printed p. 86/PDF p. 100",
    "Appendix D4 printed p. 333/PDF p. 347",
    "Appendix D4 printed p. 333/PDF p. 347"
  ),
  stringsAsFactors = FALSE
)

# ---------------------------------------------------------------------------
# 3. FHWA: construction-stage pressure, soil stiffness, and response tables.
# ---------------------------------------------------------------------------

FhwaCompaction <- data.frame(
  forceKn = c(20.5, 20.5, 5.2, 5.2, 5.2, 5.2, 4, 4, 4),
  phiDeg = c(36, 28, 36, 28, 36, 28, 36, 28, 36),
  centroidalDiameterMm = c(970, 970, 970, 970, 1575, 1575, 970, 970, 1575),
  publishedKpa = c(3.4, 7.2, 0.9, 1.8, 0.3, 0.5, 0.7, 1.4, 0.2),
  stringsAsFactors = FALSE
)
FhwaCompaction$calculatedKpa <- vapply(
  seq_len(nrow(FhwaCompaction)),
  function(Index) {
    fhwaCompactionPressure(
      compactorForceKn = FhwaCompaction$forceKn[Index],
      looseFrictionAngleDeg = FhwaCompaction$phiDeg[Index],
      centroidalDiameterMm = FhwaCompaction$centroidalDiameterMm[Index]
    )
  },
  numeric(1)
)
FhwaCompaction$roundedCalculatedKpa <- round(FhwaCompaction$calculatedKpa, 1)
FhwaCompaction$errorToPublishedKpa <-
  FhwaCompaction$roundedCalculatedKpa - FhwaCompaction$publishedKpa
FhwaCompaction$sourceLocation <-
  "Eq. 5.1 and Table 5.5, printed pp. 177-178/PDF pp. 192-193"
FhwaCompaction$note <- c(
  rep("", 8),
  "The apparent printed phi=28 deg does not reproduce 0.2 kPa; phi=36 deg does"
)

FhwaModulus <- fhwaSuggestedConstrainedModulus()
FhwaModulus$sourceLocation <- attr(FhwaModulus, "source")
FhwaBurnsRichard <- fhwaMetalBurnsRichardBenchmark()

# ---------------------------------------------------------------------------
# 4. Nunez: point resultants, not a published angular traction distribution.
# ---------------------------------------------------------------------------

NunezCases <- list(
  primary = list(
    relaxation = 0.5,
    interactionRatio = 0.0270,
    published = c(
      a = 0.027,
      A = 0.0263,
      Mmax = 1.21,
      NC = 54.5,
      "NA" = NA_real_
    )
  ),
  permanent = list(
    relaxation = 1,
    interactionRatio = 0.10976,
    published = c(
      a = 0.11,
      A = 0.10,
      Mmax = 9,
      NC = 103.4,
      "NA" = 147.5
    )
  )
)
NunezRows <- lapply(names(NunezCases), function(CaseName) {
  Case <- NunezCases[[CaseName]]
  Result <- nunez2000CircularResultants(
    diameter = 10,
    depthAxis = 15,
    unitWeight = 1.9,
    surfaceLoad = 1,
    k0 = 0.5,
    relaxation = Case$relaxation,
    interactionRatio = Case$interactionRatio
  )
  Calculated <- c(
    a = Result$interactionRatio,
    A = Result$interactionFraction,
    Mmax = Result$momentCrown,
    NC = Result$normalCrown,
    "NA" = Result$normalSpringline
  )
  data.frame(
    case = CaseName,
    quantity = names(Calculated),
    publishedRounded = unname(Case$published[names(Calculated)]),
    calculated = unname(Calculated),
    unit = c("-", "-", "Tn m/m", "Tn/m", "Tn/m"),
    sourceLocation = "Nunez (2000) PDF pp. 14-15",
    note = paste(
      "Dry circular arithmetic benchmark using the 2000 equations;",
      "Nunez eta represents NATM excavation relaxation"
    ),
    stringsAsFactors = FALSE
  )
})
NunezTable <- do.call(rbind, NunezRows)

NunezVersionRows <- lapply(names(NunezCases), function(CaseName) {
  Case <- NunezCases[[CaseName]]
  Arguments <- list(
    diameter = 10,
    depthAxis = 15,
    unitWeight = 1.9,
    surfaceLoad = 1,
    k0 = 0.5,
    relaxation = Case$relaxation,
    interactionRatio = Case$interactionRatio
  )
  Result2000 <- do.call(nunez2000CircularResultants, Arguments)
  Result2014 <- do.call(nunez2014Resultants, Arguments)
  Values2000 <- c(
    M = Result2000$momentCrown,
    NC = Result2000$normalCrown,
    "NA" = Result2000$normalSpringline
  )
  Values2014 <- c(
    M = Result2014$momentMaximum,
    NC = Result2014$normalCrown,
    "NA" = Result2014$normalSpringline
  )
  data.frame(
    case = CaseName,
    quantity = names(Values2000),
    version2000 = unname(Values2000),
    version2014 = unname(Values2014),
    difference2014Minus2000 = unname(Values2014 - Values2000),
    unit = c("Tn m/m", "Tn/m", "Tn/m"),
    note = paste(
      "The equations are version-specific;",
      "agreement in M does not imply agreement in N"
    ),
    stringsAsFactors = FALSE
  )
})
NunezVersionTable <- do.call(rbind, NunezVersionRows)

Nunez2014Table <- data.frame(
  case = rep(1:7, each = 4),
  resultant = rep(c("NC", "NA", "MC", "MA"), times = 7),
  analytical = c(
    620, 670, 4.8, 5.9,
    365, 450, 1.5, 1.6,
    720, 680, 10.2, 13.8,
    1080, 1180, 17.0, 21.0,
    120, 160, 0.5, 0.5,
    825, 870, 6.4, 7.9,
    1070, 1025, 18.0, 24.2
  ),
  finiteElement = c(
    740, 615, 2.2, 6.5,
    380, 385, 0.5, 1.6,
    500, 780, 10.0, 65.0,
    1070, 600, 8.0, 35.0,
    110, 125, 0.5, 0.9,
    905, 955, 2.0, 2.5,
    985, 1235, 6.9, 67.0
  ),
  unit = rep(c("kN/m", "kN/m", "kN m/m", "kN m/m"), times = 7),
  independentlyReproducible = FALSE,
  sourceLocation = "Nunez, Sfriso and Laiun (2014), Table 3, PDF p. 7",
  note = "Published analytical/FEM comparison; source omits inputs needed for full reproduction",
  stringsAsFactors = FALSE
)

# ---------------------------------------------------------------------------
# 5. Closed elastic interaction: Schwartz-Einstein and CANDE Level 1.
# ---------------------------------------------------------------------------

SchwartzCases <- data.frame(
  sequence = c("excavation", "excavation", "external", "external"),
  interface = c("fullSlip", "noSlip", "fullSlip", "noSlip"),
  publishedThrustRatio = c(0.736, 0.812, 0.887, 1.02),
  publishedMomentRatio = c(0.00774, 0.00707, 0.0133, 0.0121),
  stringsAsFactors = FALSE
)
SchwartzRows <- lapply(seq_len(nrow(SchwartzCases)), function(Index) {
  Case <- SchwartzCases[Index, , drop = FALSE]
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
  data.frame(
    sequence = Case$sequence,
    interface = Case$interface,
    thetaDeg = 30,
    publishedThrustRatio = Case$publishedThrustRatio,
    calculatedThrustRatio = Result$response$thrustRatio,
    publishedMomentRatio = Case$publishedMomentRatio,
    calculatedMomentRatio = Result$response$momentRatio,
    calculatedShearRatio = Result$response$shearRatio,
    shearEvidence = "derived from Q=(1/R)dM/dtheta; not printed in HP97",
    sourceLocation = "Schwartz-Einstein HP97, printed pp. 391-392/PDF p. 407",
    stringsAsFactors = FALSE
  )
})
SchwartzTable <- do.call(rbind, SchwartzRows)

CandeAngles <- c(0, pi / 4, pi / 2)
CandeRows <- lapply(c("bonded", "frictionless"), function(Interface) {
  Result <- candeLevel1Response(
    theta = CandeAngles,
    overburdenPressure = 100,
    radius = 1,
    groundShearModulus = 20000,
    groundPoisson = 1 / 3,
    alpha = 0.2,
    beta = 0.01,
    interface = Interface
  )
  data.frame(
    interface = Interface,
    Result$response,
    evidence = "derived numerical evaluation of published table formulas",
    sourceLocation = "CANDE-2025 Table 1.1.1-1, printed p. 1-2/PDF p. 10",
    stringsAsFactors = FALSE
  )
})
CandeTable <- do.call(rbind, CandeRows)

# ---------------------------------------------------------------------------
# 6. Corrugated section: published properties and preliminary evaluation.
# ---------------------------------------------------------------------------

RadiusSectionMm <- 2630 / 2
ModulusSteelMpa <- 200000
ThicknessTargetMm <- 3
ThicknessBracketMm <- c(0.1046, 0.1345) * 25.4
AreaBracket <- c(1.560, 2.008) / 12 * 25.4
InertiaBracket <- c(0.0154, 0.0202) * 25.4^3
InterpolationFraction <-
  (ThicknessTargetMm - ThicknessBracketMm[1L]) /
  diff(ThicknessBracketMm)
AreaInterpolated <- AreaBracket[1L] +
  InterpolationFraction * diff(AreaBracket)
InertiaInterpolated <- InertiaBracket[1L] +
  InterpolationFraction * diff(InertiaBracket)

SectionTable <- data.frame(
  case = c(
    "NCSPA-3x1-0.109",
    "NCSPA-3x1-0.138",
    "SAD40-3x1-3mm-preliminary",
    "Mai-152x51x3"
  ),
  profile = c("3 x 1 in", "3 x 1 in", "76 x 25 mm", "152 x 51 mm"),
  specifiedThicknessMm = c(0.109, 0.138, 3 / 25.4, 3 / 25.4) * 25.4,
  baseThicknessMm = c(ThicknessBracketMm, ThicknessTargetMm, 3),
  areaMm2PerMm = c(AreaBracket, AreaInterpolated, 3.522),
  inertiaMm4PerMm = c(InertiaBracket, InertiaInterpolated, 1057.25),
  youngModulusMpa = ModulusSteelMpa,
  radiusMm = RadiusSectionMm,
  propertyEvidence = c(
    "published table row",
    "published table row",
    "derived linear interpolation on uncoated thickness",
    "published example"
  ),
  modulusEvidence = c(
    "control input",
    "control input",
    "control input",
    "published example"
  ),
  geometryEvidence = c(
    "published profile",
    "published profile",
    "preliminary project record; not as-built",
    "published profile"
  ),
  sourceLocation = c(
    rep("NCSPA Design Manual Table 2.6, printed p. 32/PDF p. 33", 3),
    "Mai (2013), printed p. 14/PDF p. 23"
  ),
  stringsAsFactors = FALSE
)

SectionCalculated <- lapply(seq_len(nrow(SectionTable)), function(Index) {
  calculateRingSection(
    youngModulus = SectionTable$youngModulusMpa[Index],
    area = SectionTable$areaMm2PerMm[Index],
    inertia = SectionTable$inertiaMm4PerMm[Index],
    radius = SectionTable$radiusMm[Index]
  )
})
SectionTable$extensionalRigidityKnPerM <- vapply(
  SectionCalculated,
  function(Section) Section$extensionalRigidity,
  numeric(1)
)
SectionTable$flexuralRigidityKnM <- vapply(
  SectionCalculated,
  function(Section) Section$flexuralRigidity * 1e-6,
  numeric(1)
)
SectionTable$sectionRatio <- vapply(
  SectionCalculated,
  function(Section) Section$sectionRatio,
  numeric(1)
)
SectionTable$equivalentThicknessMm <- vapply(
  SectionCalculated,
  function(Section) Section$equivalentThickness,
  numeric(1)
)
SectionTable$equivalentYoungModulusGpa <- vapply(
  SectionCalculated,
  function(Section) Section$equivalentYoungModulus / 1000,
  numeric(1)
)
SectionTable$interpolationFraction <- c(
  NA_real_,
  NA_real_,
  InterpolationFraction,
  NA_real_
)

ThetaSection <- (0:1439) * 2 * pi / 1440
LoadSection <- k0TensorLoad(
  effectiveVertical = 100,
  k0 = 0.5,
  porePressure = 0,
  interface = "fullTraction"
)
CasesSection <- data.frame(
  case = c(
    "membrane-control",
    "SAD40-3x1-3mm-preliminary",
    "Mai-152x51x3"
  ),
  sectionRatio = c(
    0,
    SectionTable$sectionRatio[
      SectionTable$case == "SAD40-3x1-3mm-preliminary"
    ],
    SectionTable$sectionRatio[SectionTable$case == "Mai-152x51x3"]
  ),
  stringsAsFactors = FALSE
)
SectionExtrema <- do.call(rbind, lapply(seq_len(nrow(CasesSection)), function(Index) {
  Response <- solveRingDirect(
    load = LoadSection,
    radius = RadiusSectionMm / 1000,
    theta = ThetaSection,
    sectionRatio = CasesSection$sectionRatio[Index],
    integrationSteps = 4096L
  )
  OUT <- summarizeRingGrid(Response)
  OUT$case <- CasesSection$case[Index]
  OUT$sectionRatio <- CasesSection$sectionRatio[Index]
  OUT$unit <- ifelse(OUT$resultant == "M", "kN m/m", "kN/m")
  OUT$effectiveVerticalKpa <- 100
  OUT$k0 <- 0.5
  OUT$porePressureKpa <- 0
  OUT$interface <- "fullTraction"
  OUT$caseEvidence <- "declared numerical control; not project soil demand"
  OUT
}))

Outputs <- list(
  "ring-mechanics.csv" = MechanicsTable,
  "baker-ring.csv" = BakerTable,
  "usace-d4.csv" = UsaceTable,
  "fhwa-equation-5-1.csv" = FhwaCompaction,
  "fhwa-constrained-modulus.csv" = FhwaModulus,
  "fhwa-burns-richard-metal.csv" = FhwaBurnsRichard,
  "nunez-circular-examples.csv" = NunezTable,
  "nunez-version-difference.csv" = NunezVersionTable,
  "nunez-2014-analytical-fem.csv" = Nunez2014Table,
  "schwartz-einstein-hp97.csv" = SchwartzTable,
  "cande-level1-formula.csv" = CandeTable,
  "corrugated-section.csv" = SectionTable,
  "corrugated-k0-extrema.csv" = SectionExtrema
)
Written <- vapply(names(Outputs), function(FileName) {
  writeBenchmark(Outputs[[FileName]], FileName)
}, character(1))

message(
  "Wrote ",
  length(Written),
  " benchmark tables to ",
  OutputDirectory,
  "."
)
