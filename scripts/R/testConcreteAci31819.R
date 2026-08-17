# Verifies the mechanical P-M adapter against the official ACI example.

Arguments <- commandArgs(trailingOnly = FALSE)
FileArgument <- grep("^--file=", Arguments, value = TRUE)
if (length(FileArgument) != 1L) {
  stop("Run with Rscript scripts/R/testConcreteAci31819.R.", call. = FALSE)
}
ScriptPath <- normalizePath(sub("^--file=", "", FileArgument))
projectRoot <- normalizePath(file.path(dirname(ScriptPath), "..", ".."))
source(
  file.path(projectRoot, "scripts", "setup", "calculationFunctions.R"),
  local = TRUE
)

runConcreteAci31819Tests <- function() {
  stopifnot(
    abs(
      calculateAci31819NormalWeightConcreteModulus(25) - 23500000
    ) < 1e-12,
    abs(calculateAci31819Beta1(28) - 0.85) < 1e-15,
    abs(calculateAci31819Beta1(35) - 0.80) < 1e-15,
    abs(calculateAci31819Beta1(56) - 0.65) < 1e-15,
    calculateAci31819StrengthReductionFactor(0.0021, 0.0021) == 0.65,
    calculateAci31819StrengthReductionFactor(0.0051, 0.0021) == 0.90,
    abs(calculateAci31819StrengthReductionFactor(0.0036, 0.0021) - 0.775) <
      1e-15
  )

  Inch <- 25.4
  Kip <- 4448.2216152605
  Reinforcement <- data.frame(
    layerID = "tension-layer",
    areaMm2 = 0.66 * Inch^2,
    coordinateMm = 15 * Inch / 2 - 12.63 * Inch,
    yieldStrengthMPa = 60 * 6.894757293168,
    modulusMPa = 200000,
    stringsAsFactors = FALSE
  )
  BlockDepthIn <- (9.6 + 0.66 * 60) / (0.85 * 5 * 12)
  NeutralAxisDepth <- BlockDepthIn / 0.80 * Inch
  Depths <- sort(unique(c(
    exp(seq(log(0.001), log(150000), length.out = 101L)),
    NeutralAxisDepth
  )))
  Domain <- buildConcreteSectionDomain(
    thicknessMm = 15 * Inch,
    stripWidthMm = 12 * Inch,
    compressiveStrengthMPa = 5 * 6.894757293168,
    reinforcement = Reinforcement,
    concreteMaximumStrain = 0.003,
    concreteStressFactor = 0.85,
    beta1 = 0.80,
    strengthReductionFactor = function(NetTensileStrain) {
      calculateAci31819StrengthReductionFactor(
        netTensileStrain = NetTensileStrain,
        reinforcementYieldStrain = Reinforcement$yieldStrengthMPa /
          Reinforcement$modulusMPa
      )
    },
    strengthReductionRuleID = "ACI-E702.4-21-example-phi-rule",
    neutralAxisDepthsMm = Depths,
    provisionID = "ACI-E702.4-21-reproduction",
    sourceLocator = "official example pp. 6-7"
  )
  Point <- Domain[
    Domain$compressionFaceID == "exterior" &
      abs(Domain$neutralAxisDepthMm - NeutralAxisDepth) < 1e-10,
  ]
  stopifnot(
    nrow(Point) == 1L,
    abs(Point$nominalAxialStrengthN / Kip - 9.6) < 1e-9,
    abs(Point$bendingStrengthNmm / (Kip * Inch) - 493.5746) < 1e-3,
    Point$strengthReductionFactor == 0.90
  )

  InfiniteStrain.error <- tryCatch(
    calculateAci31819StrengthReductionFactor(Inf, 0.0021),
    error = function(e) conditionMessage(e)
  )
  stopifnot(grepl("nonnegative number", InfiniteStrain.error, fixed = TRUE))

  Shell <- checkAci318214ShellReinforcement(
    thicknessMm = 150,
    stripWidthMm = 1000,
    circumferentialAreaMm2 = 270,
    orthogonalAreaMm2 = NA_real_,
    reinforcementGradeID = "Grade-60"
  )
  stopifnot(
    Shell$requiredAreaMm2 == 270,
    Shell$circumferentialStatus == "satisfied",
    Shell$minimumReinforcementStatus == "incomplete",
    Shell$scopeID == "minimum-shell-reinforcement-only",
    Shell$editionStatus == "historical"
  )
  Shell.none <- checkAci318214ShellReinforcement(
    thicknessMm = 150,
    stripWidthMm = 1000,
    circumferentialAreaMm2 = 0,
    orthogonalAreaMm2 = 0,
    reinforcementGradeID = "Grade-60"
  )
  stopifnot(Shell.none$minimumReinforcementStatus == "not-satisfied")

  Layers <- data.frame(
    layerID = c("interior", "exterior"),
    areaMm2 = c(135, 135),
    coordinateMm = c(-35, 35),
    yieldStrengthMPa = c(420, 420),
    modulusMPa = c(200000, 200000),
    stringsAsFactors = FALSE
  )
  Domains <- buildAciE702421ReinforcedSectionDomains(
    thicknessMm = 150,
    stripWidthMm = 1000,
    compressiveStrengthMPa = 30,
    reinforcement = Layers,
    basePointCount = 201L,
    refinedPointCount = 401L
  )
  Assessment <- evaluateAciE702421SectionDemand(
    normalForceKnPerM = -100,
    bendingMomentKnMPerM = 10,
    stripWidthM = 1,
    sectionDomains = Domains,
    forceEffectStatus = "lrfd-factored",
    convergenceTolerance = 2e-3
  )
  stopifnot(
    Assessment$convergenceStatus == "satisfied",
    is.finite(Assessment$radialUtilization),
    Assessment$sectionalAssessmentStatus == "not-evaluated-code-basis",
    Assessment$scopeID == "mechanical-sectional-P-M-reproduction",
    Assessment$axialLimitStatus == "not-applied"
  )
  invisible(TRUE)
}

runConcreteAci31819Tests()
cat("PASS: ACI E702.4-21 mechanical P-M reproduction.\n")
