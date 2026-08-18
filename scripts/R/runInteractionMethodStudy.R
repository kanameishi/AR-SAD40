# Reproducible controls for the relationship between the Schwartz--Einstein
# interaction solution, the balanced geostatic-gradient correction and the
# prescribed-load ring solvers used by the project calculation.
#
# Run from any directory with:
#
#   Rscript scripts/R/runInteractionMethodStudy.R

Arguments <- commandArgs(trailingOnly = FALSE)
FileArgument <- grep("^--file=", Arguments, value = TRUE)
if (length(FileArgument) != 1L) {
  stop(
    "Run with Rscript scripts/R/runInteractionMethodStudy.R.",
    call. = FALSE
  )
}
ScriptPath <- normalizePath(sub("^--file=", "", FileArgument))
projectRoot <- normalizePath(file.path(dirname(ScriptPath), "..", ".."))
OutputDirectory <- file.path(projectRoot, "TITO", "kb", "benchmarks")

source(
  file.path(projectRoot, "scripts", "setup", "calculationFunctions.R"),
  local = TRUE
)
Fourier <- new.env(parent = environment())
sys.source(
  file.path(projectRoot, "scripts", "R", "ringFourier.R"),
  envir = Fourier
)

readMethodProfile <- function() {
  Profile <- readCalculationJson(file.path(
    projectRoot,
    "scripts",
    "config",
    "cover.method.mesh.2026-08-16.json"
  ))
  Profile[["methodProfileID"]] <- NULL
  Profile[["methodProfileVersion"]] <- NULL
  Profile
}

# Refuse to study a stale method profile: calculation.json remains the human
# input boundary and must resolve to the same validated calculation profile.
Manifest <- readCalculationJson(file.path(projectRoot, "calculation.json"))
Resolution <- resolveCoverCaseConfig(
  inputs = Manifest[["inputs", exact = TRUE]],
  projectRoot = projectRoot,
  methodID = Manifest[["methodID", exact = TRUE]]
)
Profile <- readMethodProfile()
stopifnot(identical(
  Resolution[["config", exact = TRUE]],
  validateCoverCalculationConfig(Profile)
))
Evaluation <- evaluateCoverConfiguration(Profile, projectRoot)

withLiningID <- function(Table, liningID) {
  if (!"liningID" %in% names(Table)) {
    Table <- cbind(liningID = liningID, Table, stringsAsFactors = FALSE)
  }
  Table
}

SectionMap <- rbind(
  data.frame(
    liningID = "steel",
    sectionID = Evaluation$section$sectionID,
    centroidalRadiusM = Evaluation$section$centroidalRadiusM,
    stringsAsFactors = FALSE
  ),
  do.call(rbind, lapply(names(Evaluation$additionalLinings), function(Name) {
    Section <- Evaluation$additionalLinings[[Name]]$section
    data.frame(
      liningID = Name,
      sectionID = Section$sectionID,
      centroidalRadiusM = Section$centroidalRadiusM,
      stringsAsFactors = FALSE
    )
  }))
)

SchwartzEinstein <- rbind(
  withLiningID(Evaluation$schwartzEinsteinComparison, "steel"),
  do.call(rbind, lapply(names(Evaluation$additionalLinings), function(Name) {
    withLiningID(
      Evaluation$additionalLinings[[Name]]$schwartzEinsteinComparison,
      Name
    )
  }))
)
Prescribed <- rbind(
  withLiningID(Evaluation$interaction, "steel"),
  do.call(rbind, lapply(names(Evaluation$additionalLinings), function(Name) {
    withLiningID(Evaluation$additionalLinings[[Name]]$interaction, Name)
  }))
)

radiusFor <- function(liningID) {
  Radius <- SectionMap$centroidalRadiusM[match(liningID, SectionMap$liningID)]
  if (length(Radius) != 1L || !is.finite(Radius)) {
    stop("No unique radius for liningID = ", liningID, ".", call. = FALSE)
  }
  Radius
}

Theta <- (0:720) * 2 * pi / 721
EquivalenceRows <- lapply(seq_len(nrow(SchwartzEinstein)), function(Index) {
  Case <- SchwartzEinstein[Index, , drop = FALSE]
  Radius <- radiusFor(Case$liningID)
  Normal0 <- Case$normalMeanKnPerM
  Normal2 <- Case$normalCosineKnPerM
  Moment2 <- Case$momentCosineKnMPerM
  Shear2 <- Case$shearSineKnPerM

  # These tractions are not a new interaction law. They are the unique n=0
  # and n=2 load coefficients recovered from the E--S resultants by the ring
  # equilibrium equations used in the methodology.
  Radial0 <- Normal0 / Radius
  Radial2 <- Normal2 / Radius - 4 * Moment2 / Radius^2
  Tangential2 <- 2 * Normal2 / Radius - 2 * Moment2 / Radius^2

  Spectrum <- Fourier$newRingSpectrum(2L)
  Spectrum$radialCos[Spectrum$mode == 0L] <- Radial0
  Spectrum$radialCos[Spectrum$mode == 2L] <- Radial2
  Spectrum$tangentialSin[Spectrum$mode == 2L] <- Tangential2
  FourierResponse <- Fourier$solveRingSpectrum(
    spectrum = Spectrum,
    radius = Radius,
    uniformMoment = "membrane"
  )
  FourierValues <- Fourier$evaluateRingResponse(FourierResponse, Theta)
  FourierResidual <- Fourier$ringEquilibriumResidual(
    spectrum = Spectrum,
    responseSpectrum = FourierResponse,
    radius = Radius,
    theta = Theta
  )

  Load <- newRingLoad(
    radial = function(theta) Radial0 + Radial2 * cos(2 * theta),
    tangential = function(theta) Tangential2 * sin(2 * theta),
    label = "E-S resultants reconstructed as equivalent tractions",
    source = "derived from Schwartz--Einstein resultants by ring equilibrium",
    representation = "methodology-only n=0+n=2 control"
  )
  Direct <- calculateSectionResultants(
    load = Load,
    radius = Radius,
    theta = Theta,
    sectionRatio = 0,
    integrationSteps = 4096L,
    balanceTolerance = 1e-9
  )

  Target <- data.frame(
    normalForce = Normal0 + Normal2 * cos(2 * Theta),
    bendingMoment = Moment2 * cos(2 * Theta),
    shearForce = Shear2 * sin(2 * Theta)
  )
  ForceScale <- Case$effectiveVerticalStressKPa * Radius
  MomentScale <- Case$effectiveVerticalStressKPa * Radius^2
  normalizedError <- function(Observed) {
    max(c(
      abs(Observed$normalForce - Target$normalForce) / ForceScale,
      abs(Observed$bendingMoment - Target$bendingMoment) / MomentScale,
      abs(Observed$shearForce - Target$shearForce) / ForceScale
    ))
  }
  ResidualMaximum <- max(c(
    abs(FourierResidual$momentBalance) / MomentScale,
    abs(FourierResidual$radialBalance) / ForceScale,
    abs(FourierResidual$tangentialBalance) / ForceScale
  ))

  data.frame(
    liningID = Case$liningID,
    sectionID = Case$sectionID,
    interfaceID = Case$interfaceID,
    modes = "0,2",
    radialMode0KPa = Radial0,
    radialMode2KPa = Radial2,
    tangentialMode2KPa = Tangential2,
    fourierMaximumNormalizedDifference = normalizedError(FourierValues),
    directMaximumNormalizedDifference = normalizedError(Direct$values),
    fourierMaximumNormalizedEquilibriumResidual = ResidualMaximum,
    fourierStatus = if (normalizedError(FourierValues) <= 1e-12) {
      "satisfied"
    } else {
      "not-satisfied"
    },
    directStatus = if (normalizedError(Direct$values) <= 1e-7) {
      "satisfied"
    } else {
      "not-satisfied"
    },
    interpretation = paste(
      "equilibrium reconstruction only; E-S supplies the interaction",
      "coefficients and Fourier/direct integration add no soil stiffness"
    ),
    stringsAsFactors = FALSE
  )
})
Equivalence <- do.call(rbind, EquivalenceRows)
stopifnot(
  all(Equivalence$fourierStatus == "satisfied"),
  all(Equivalence$directStatus == "satisfied")
)

normalizeInteraction <- function(Table, methodID, stiffnessFeedback) {
  do.call(rbind, lapply(seq_len(nrow(Table)), function(Index) {
    Case <- Table[Index, , drop = FALSE]
    Radius <- radiusFor(Case$liningID)
    ForceScale <- Case$effectiveVerticalStressKPa * Radius
    MomentScale <- Case$effectiveVerticalStressKPa * Radius^2
    Moment0 <- if ("momentMeanKnMPerM" %in% names(Case)) {
      Case$momentMeanKnMPerM
    } else {
      0
    }
    data.frame(
      liningID = Case$liningID,
      sectionID = Case$sectionID,
      methodID = methodID,
      interfaceID = Case$interfaceID,
      stiffnessFeedback = stiffnessFeedback,
      modes = "0,2",
      cStar = if ("cStar" %in% names(Case)) Case$cStar else NA_real_,
      fStar = if ("fStar" %in% names(Case)) Case$fStar else NA_real_,
      normalMode0Ratio = Case$normalMeanKnPerM / ForceScale,
      normalMode2Ratio = Case$normalCosineKnPerM / ForceScale,
      momentMode0Ratio = Moment0 / MomentScale,
      momentMode2Ratio = Case$momentCosineKnMPerM / MomentScale,
      shearMode2Ratio = Case$shearSineKnPerM / ForceScale,
      stringsAsFactors = FALSE
    )
  }))
}
InteractionComparison <- rbind(
  normalizeInteraction(
    Prescribed,
    "prescribed-uniform-k0",
    "absent"
  ),
  normalizeInteraction(
    SchwartzEinstein,
    "schwartz-einstein-external-loading",
    "present-through-cstar-fstar-and-interface"
  )
)

Gamma <- Profile$cover$effectiveUnitWeightKnPerM3
K0 <- Evaluation$stress$k0Applied[1L]
VerticalAxis <- Evaluation$stress$effectiveVerticalStressKPa[1L]
HorizontalAxis <- Evaluation$stress$effectiveHorizontalStressKPa[1L]
GradientRows <- lapply(seq_len(nrow(SectionMap)), function(Index) {
  Section <- SectionMap[Index, , drop = FALSE]
  Radius <- Section$centroidalRadiusM
  VerticalGradient <- Gamma
  HorizontalGradient <- K0 * Gamma
  Difference <- VerticalGradient - HorizontalGradient
  Radial1Unbalanced <- Radius * (3 * VerticalGradient + HorizontalGradient) / 4
  Tangential1 <- -Radius * Difference / 4
  Radial3 <- Radius * Difference / 4
  Tangential3 <- -Radius * Difference / 4
  SupportRadial1 <- Tangential1 - Radial1Unbalanced
  Radial1Balanced <- Radial1Unbalanced + SupportRadial1

  UnbalancedSpectrum <- Fourier$newRingSpectrum(3L)
  UnbalancedSpectrum$radialCos[UnbalancedSpectrum$mode == 1L] <-
    Radial1Unbalanced
  UnbalancedSpectrum$tangentialSin[UnbalancedSpectrum$mode == 1L] <-
    Tangential1
  UnbalancedSpectrum$radialCos[UnbalancedSpectrum$mode == 3L] <- Radial3
  UnbalancedSpectrum$tangentialSin[UnbalancedSpectrum$mode == 3L] <- Tangential3
  UnbalancedGlobal <- Fourier$ringGlobalLoads(UnbalancedSpectrum, Radius)

  BalancedSpectrum <- UnbalancedSpectrum
  BalancedSpectrum$radialCos[BalancedSpectrum$mode == 1L] <- Radial1Balanced
  BalancedGlobal <- Fourier$ringGlobalLoads(BalancedSpectrum, Radius)
  BalancedResponse <- Fourier$solveRingSpectrum(
    spectrum = BalancedSpectrum,
    radius = Radius,
    uniformMoment = "membrane"
  )
  Mode1 <- BalancedResponse[BalancedResponse$mode == 1L, , drop = FALSE]
  Mode3 <- BalancedResponse[BalancedResponse$mode == 3L, , drop = FALSE]

  rbind(
    data.frame(
      liningID = Section$liningID,
      sectionID = Section$sectionID,
      gradientCaseID = "full-geostatic-linear-gradient-unbalanced",
      modes = "1,3",
      radialMode1KPa = Radial1Unbalanced,
      tangentialMode1KPa = Tangential1,
      radialMode3KPa = Radial3,
      tangentialMode3KPa = Tangential3,
      supportRadialMode1KPa = 0,
      globalVerticalForceKnPerM = UnbalancedGlobal$forceZ,
      normalMode1KnPerM = NA_real_,
      normalMode3KnPerM = NA_real_,
      momentMode3KnMPerM = NA_real_,
      shearMode3KnPerM = NA_real_,
      stiffnessFeedback = "absent",
      admissibility = "requires-explicit-body-force-or-support-reaction",
      stringsAsFactors = FALSE
    ),
    data.frame(
      liningID = Section$liningID,
      sectionID = Section$sectionID,
      gradientCaseID = "balanced-full-geostatic-linear-gradient",
      modes = "1,3",
      radialMode1KPa = Radial1Balanced,
      tangentialMode1KPa = Tangential1,
      radialMode3KPa = Radial3,
      tangentialMode3KPa = Tangential3,
      supportRadialMode1KPa = SupportRadial1,
      globalVerticalForceKnPerM = BalancedGlobal$forceZ,
      normalMode1KnPerM = Mode1$nCos,
      normalMode3KnPerM = Mode3$nCos,
      momentMode3KnMPerM = Mode3$mCos,
      shearMode3KnPerM = Mode3$qSin,
      stiffnessFeedback = "absent",
      admissibility = "balanced-production-gradient-correction",
      stringsAsFactors = FALSE
    )
  )
})
GradientModes <- do.call(rbind, GradientRows)
stopifnot(max(abs(
  GradientModes$globalVerticalForceKnPerM[
    GradientModes$gradientCaseID ==
      "balanced-full-geostatic-linear-gradient"
  ]
)) < 1e-12)

VerificationRows <- lapply(seq_len(nrow(SectionMap)), function(Index) {
  Section <- SectionMap[Index, , drop = FALSE]
  Radius <- Section$centroidalRadiusM
  Balanced <- GradientModes[
    GradientModes$liningID == Section$liningID &
      GradientModes$gradientCaseID ==
        "balanced-full-geostatic-linear-gradient",
    ,
    drop = FALSE
  ]
  Spectrum <- Fourier$newRingSpectrum(3L)
  Spectrum$radialCos[Spectrum$mode == 1L] <- Balanced$radialMode1KPa
  Spectrum$tangentialSin[Spectrum$mode == 1L] <- Balanced$tangentialMode1KPa
  Spectrum$radialCos[Spectrum$mode == 3L] <- Balanced$radialMode3KPa
  Spectrum$tangentialSin[Spectrum$mode == 3L] <- Balanced$tangentialMode3KPa
  FourierSpectrum <- Fourier$solveRingSpectrum(
    spectrum = Spectrum,
    radius = Radius,
    uniformMoment = "membrane"
  )
  FourierValues <- Fourier$evaluateRingResponse(FourierSpectrum, Theta)
  Residual <- Fourier$ringEquilibriumResidual(
    spectrum = Spectrum,
    responseSpectrum = FourierSpectrum,
    radius = Radius,
    theta = Theta
  )
  Load <- newRingLoad(
    radial = function(theta) {
      Balanced$radialMode1KPa * cos(theta) +
        Balanced$radialMode3KPa * cos(3 * theta)
    },
    tangential = function(theta) {
      Balanced$tangentialMode1KPa * sin(theta) +
        Balanced$tangentialMode3KPa * sin(3 * theta)
    },
    label = "balanced geostatic gradient",
    source = "project equilibrium derivation",
    representation = "n=1+n=3 with full-circumference radial reaction"
  )
  Direct <- calculateSectionResultants(
    load = Load,
    radius = Radius,
    theta = Theta,
    sectionRatio = 0,
    integrationSteps = 8192L,
    balanceTolerance = 1e-9
  )
  ForceScale <- max(VerticalAxis * Radius, 1)
  MomentScale <- max(VerticalAxis * Radius^2, 1)
  DifferenceMaximum <- max(c(
    abs(FourierValues$normalForce - Direct$values$normalForce) / ForceScale,
    abs(FourierValues$bendingMoment - Direct$values$bendingMoment) /
      MomentScale,
    abs(FourierValues$shearForce - Direct$values$shearForce) / ForceScale
  ))
  ResidualMaximum <- max(c(
    abs(Residual$radialBalance) / ForceScale,
    abs(Residual$tangentialBalance) / ForceScale,
    abs(Residual$momentBalance) / MomentScale
  ))
  PrescribedCompression <- VerticalAxis * cos(Theta)^2 +
    HorizontalAxis * sin(Theta)^2 -
    Balanced$radialMode1KPa * cos(Theta) -
    Balanced$radialMode3KPa * cos(3 * Theta)
  data.frame(
    liningID = Section$liningID,
    sectionID = Section$sectionID,
    centroidalRadiusM = Radius,
    verticalAxisStressKPa = VerticalAxis,
    horizontalAxisStressKPa = HorizontalAxis,
    verticalGradientKPaPerM = Gamma,
    horizontalGradientKPaPerM = K0 * Gamma,
    horizontalResultantOffsetBelowAxisM =
      K0 * Gamma * Radius^2 / (3 * HorizontalAxis),
    supportRadialMode1KPa = Balanced$supportRadialMode1KPa,
    balancedGlobalVerticalForceKnPerM = Balanced$globalVerticalForceKnPerM,
    fourierDirectMaximumNormalizedDifference = DifferenceMaximum,
    fourierMaximumNormalizedEquilibriumResidual = ResidualMaximum,
    minimumPrescribedCompressivePressureKPa = min(PrescribedCompression),
    maximumPrescribedCompressivePressureKPa = max(PrescribedCompression),
    parityStatus = if (DifferenceMaximum <= 1e-7) {
      "satisfied"
    } else {
      "not-satisfied"
    },
    equilibriumStatus = if (ResidualMaximum <= 1e-10) {
      "satisfied"
    } else {
      "not-satisfied"
    },
    prescribedCompressionStatus = if (min(PrescribedCompression) >= -1e-9) {
      "satisfied"
    } else {
      "not-satisfied"
    },
    stringsAsFactors = FALSE
  )
})
GradientVerification <- do.call(rbind, VerificationRows)
stopifnot(
  all(GradientVerification$parityStatus == "satisfied"),
  all(GradientVerification$equilibriumStatus == "satisfied"),
  all(GradientVerification$prescribedCompressionStatus == "satisfied")
)

HybridResultants <- rbind(
  withLiningID(Evaluation$resultants, "steel"),
  do.call(rbind, lapply(names(Evaluation$additionalLinings), function(Name) {
    withLiningID(Evaluation$additionalLinings[[Name]]$resultants, Name)
  }))
)
ComparisonRows <- lapply(seq_len(nrow(SchwartzEinstein)), function(Index) {
  Case <- SchwartzEinstein[Index, , drop = FALSE]
  Base <- list(
    N = Case$normalMeanKnPerM +
      Case$normalCosineKnPerM * cos(2 * Evaluation$theta$thetaRad),
    M = Case$momentCosineKnMPerM * cos(2 * Evaluation$theta$thetaRad),
    Q = Case$shearSineKnPerM * sin(2 * Evaluation$theta$thetaRad)
  )
  do.call(rbind, lapply(names(Base), function(ResultantID) {
    Hybrid <- HybridResultants[
      HybridResultants$liningID == Case$liningID &
        HybridResultants$interfaceID == Case$interfaceID &
        HybridResultants$resultantID == ResultantID,
      ,
      drop = FALSE
    ]
    Hybrid <- Hybrid[order(Hybrid$thetaIndex), , drop = FALSE]
    if (nrow(Hybrid) != length(Base[[ResultantID]])) {
      stop("The hybrid resultant mesh is incomplete.", call. = FALSE)
    }
    Difference <- Hybrid$value - Base[[ResultantID]]
    data.frame(
      liningID = Case$liningID,
      sectionID = Case$sectionID,
      interfaceID = Case$interfaceID,
      resultantID = ResultantID,
      schwartzEinsteinAbsoluteMaximum = max(abs(Base[[ResultantID]])),
      hybridAbsoluteMaximum = max(abs(Hybrid$value)),
      absoluteMaximumChange = max(abs(Hybrid$value)) -
        max(abs(Base[[ResultantID]])),
      relativeMaximumChange = if (max(abs(Base[[ResultantID]])) == 0) {
        NA_real_
      } else {
        max(abs(Hybrid$value)) / max(abs(Base[[ResultantID]])) - 1
      },
      maximumPointwiseCorrection = max(abs(Difference)),
      thetaAtHybridAbsoluteMaximumDeg =
        Hybrid$thetaDeg[which.max(abs(Hybrid$value))[1L]],
      stringsAsFactors = FALSE
    )
  }))
})
HybridComparison <- do.call(rbind, ComparisonRows)

Outputs <- list(
  "project-es-fourier-equivalence.csv" = Equivalence,
  "project-uniform-interaction-comparison.csv" = InteractionComparison,
  "project-depth-gradient-modes.csv" = GradientModes,
  "project-hybrid-gradient-verification.csv" = GradientVerification,
  "project-hybrid-resultant-comparison.csv" = HybridComparison
)
for (FileName in names(Outputs)) {
  write.csv(
    Outputs[[FileName]],
    file.path(OutputDirectory, FileName),
    row.names = FALSE,
    na = "UNKNOWN"
  )
}
message(
  "Wrote ",
  length(Outputs),
  " methodology-only interaction tables to ",
  OutputDirectory,
  "."
)
