# Verifies the generic reinforced-concrete P-M geometry and demand evaluator.

Arguments <- commandArgs(trailingOnly = FALSE)
FileArgument <- grep("^--file=", Arguments, value = TRUE)
if (length(FileArgument) != 1L) {
  stop("Run with Rscript scripts/R/testConcreteDemand.R.", call. = FALSE)
}
ScriptPath <- normalizePath(sub("^--file=", "", FileArgument))
projectRoot <- normalizePath(file.path(dirname(ScriptPath), "..", ".."))
source(
  file.path(projectRoot, "scripts", "setup", "calculationFunctions.R"),
  local = TRUE
)

runConcreteDemandTests <- function() {
  Domain <- data.frame(
    axialStrengthN = c(1000, 0, -1000, 0),
    bendingStrengthNmm = c(0, 2000, 0, -2000),
    stripWidthMm = 1000,
    provisionID = "synthetic-domain",
    designBasisID = "geometric-control",
    sourceLocator = "internal mathematical control",
    stringsAsFactors = FALSE
  )
  Result <- evaluateConcreteDemand(
    normalForceKnPerM = c(-0.5, 0, 0),
    bendingMomentKnMPerM = c(0, 0.001, 0),
    stripWidthM = 1,
    designDomain = Domain,
    forceEffectStatus = "factored-strength-demand"
  )
  stopifnot(
    abs(Result$radialUtilization[1L] - 0.5) < 1e-12,
    abs(Result$radialUtilization[2L] - 0.5) < 1e-12,
    Result$radialUtilization[3L] == 0,
    Result$domainPositionID[1L] == "inside-supplied-domain"
  )

  Domain.outside <- Domain
  Domain.outside$axialStrengthN <- c(1000, 2000, 2000, 1000)
  Domain.outside$bendingStrengthNmm <- c(-1000, -1000, 1000, 1000)
  Outside.error <- tryCatch(
    evaluateConcreteDemand(
      normalForceKnPerM = -0.5,
      bendingMomentKnMPerM = 0,
      stripWidthM = 1,
      designDomain = Domain.outside,
      forceEffectStatus = "factored-strength-demand"
    ),
    error = function(e) conditionMessage(e)
  )
  stopifnot(grepl("origin", Outside.error, ignore.case = TRUE))

  Domain.crossed <- Domain[c(1, 3, 2, 4), ]
  Crossed.error <- tryCatch(
    evaluateConcreteDemand(
      normalForceKnPerM = 0,
      bendingMomentKnMPerM = 0.0005,
      stripWidthM = 1,
      designDomain = Domain.crossed,
      forceEffectStatus = "factored-strength-demand"
    ),
    error = function(e) conditionMessage(e)
  )
  stopifnot(grepl("self-intersecting", Crossed.error, fixed = TRUE))

  Width.error <- tryCatch(
    evaluateConcreteDemand(
      normalForceKnPerM = -0.5,
      bendingMomentKnMPerM = 0,
      stripWidthM = 0.5,
      designDomain = Domain,
      forceEffectStatus = "factored-strength-demand"
    ),
    error = function(e) conditionMessage(e)
  )
  stopifnot(grepl("strip widths", Width.error, fixed = TRUE))

  Reinforcement <- data.frame(
    layerID = c("interior", "exterior"),
    areaMm2 = c(300, 300),
    coordinateMm = c(-50, 50),
    yieldStrengthMPa = c(420, 420),
    modulusMPa = c(200000, 200000),
    stringsAsFactors = FALSE
  )
  Reduction <- function(netTensileStrain) {
    pmin(0.9, 0.65 + 0.25 * netTensileStrain / 0.005)
  }
  Depths.base <- exp(seq(log(0.001), log(150000), length.out = 201L))
  Depths.refined <- exp(seq(log(0.001), log(150000), length.out = 401L))
  buildDomain <- function(Depths) {
    buildConcreteSectionDomain(
      thicknessMm = 150,
      stripWidthMm = 1000,
      compressiveStrengthMPa = 30,
      reinforcement = Reinforcement,
      concreteMaximumStrain = 0.003,
      concreteStressFactor = 0.85,
      beta1 = 0.836,
      strengthReductionFactor = Reduction,
      strengthReductionRuleID = "synthetic-linear-reduction-rule",
      neutralAxisDepthsMm = Depths,
      provisionID = "synthetic-concrete-provisions",
      sourceLocator = "internal mathematical control"
    )
  }
  Concrete.base <- buildDomain(Depths.base)
  Concrete.refined <- buildDomain(Depths.refined)
  stopifnot(
    nrow(Concrete.refined) == 805L,
    Concrete.refined$stateID[1L] == "uniform-tension",
    Concrete.refined$stateID[403L] == "uniform-compression",
    all(Concrete.refined$stripWidthMm == 1000),
    all(Concrete.refined$netTensileStrain >= 0),
    max(Concrete.refined$axialStrengthN) > 0,
    min(Concrete.refined$axialStrengthN) < 0
  )
  Convergence <- evaluateConcreteDemandConvergence(
    normalForceKnPerM = c(-100, -50),
    bendingMomentKnMPerM = c(10, -20),
    stripWidthM = 1,
    baseDomain = Concrete.base,
    refinedDomain = Concrete.refined,
    forceEffectStatus = "factored-strength-demand",
    relativeTolerance = 2e-3
  )
  stopifnot(all(Convergence$convergenceStatus == "satisfied"))

  Domain.base <- Domain
  Domain.base$domainPrimitiveID <- "synthetic-shared-primitives"
  Domain.refined <- Domain.base
  Domain.refined$axialStrengthN <- 2 * Domain.refined$axialStrengthN
  Domain.refined$bendingStrengthNmm <-
    2 * Domain.refined$bendingStrengthNmm
  Convergence.small <- evaluateConcreteDemandConvergence(
    normalForceKnPerM = -0.0005,
    bendingMomentKnMPerM = 0,
    stripWidthM = 1,
    baseDomain = Domain.base,
    refinedDomain = Domain.refined,
    forceEffectStatus = "factored-strength-demand",
    relativeTolerance = 1e-3
  )
  Convergence.scaled <- evaluateConcreteDemandConvergence(
    normalForceKnPerM = -0.05,
    bendingMomentKnMPerM = 0,
    stripWidthM = 1,
    baseDomain = Domain.base,
    refinedDomain = Domain.refined,
    forceEffectStatus = "factored-strength-demand",
    relativeTolerance = 1e-3
  )
  stopifnot(
    Convergence.small$convergenceStatus == "not-satisfied",
    Convergence.scaled$convergenceStatus == "not-satisfied",
    abs(
      Convergence.small$convergenceRelativeDifference -
        Convergence.scaled$convergenceRelativeDifference
    ) < 1e-12
  )

  Domain.mismatch <- Concrete.refined
  Domain.mismatch$domainPrimitiveID <- "different-primitives"
  Mismatch.error <- tryCatch(
    evaluateConcreteDemandConvergence(
      normalForceKnPerM = -100,
      bendingMomentKnMPerM = 10,
      stripWidthM = 1,
      baseDomain = Concrete.base,
      refinedDomain = Domain.mismatch,
      forceEffectStatus = "factored-strength-demand"
    ),
    error = function(e) conditionMessage(e)
  )
  stopifnot(grepl("share every section", Mismatch.error, fixed = TRUE))

  buildConstantDomain <- function(Factor) {
    buildConcreteSectionDomain(
      thicknessMm = 150,
      stripWidthMm = 1000,
      compressiveStrengthMPa = 30,
      reinforcement = Reinforcement,
      concreteMaximumStrain = 0.003,
      concreteStressFactor = 0.85,
      beta1 = 0.836,
      strengthReductionFactor = Factor,
      neutralAxisDepthsMm = Depths.base,
      provisionID = "synthetic-concrete-provisions",
      sourceLocator = "internal mathematical control"
    )
  }
  Phi.mismatch.error <- tryCatch(
    evaluateConcreteDemandConvergence(
      normalForceKnPerM = 0,
      bendingMomentKnMPerM = 0,
      stripWidthM = 1,
      baseDomain = buildConstantDomain(0.65),
      refinedDomain = buildConstantDomain(0.90),
      forceEffectStatus = "factored-strength-demand"
    ),
    error = function(e) conditionMessage(e)
  )
  stopifnot(grepl("share every section", Phi.mismatch.error, fixed = TRUE))

  Missing.rule.error <- tryCatch(
    buildConcreteSectionDomain(
      thicknessMm = 150,
      stripWidthMm = 1000,
      compressiveStrengthMPa = 30,
      reinforcement = Reinforcement,
      concreteMaximumStrain = 0.003,
      concreteStressFactor = 0.85,
      beta1 = 0.836,
      strengthReductionFactor = Reduction,
      neutralAxisDepthsMm = Depths.base,
      provisionID = "synthetic-concrete-provisions",
      sourceLocator = "internal mathematical control"
    ),
    error = function(e) conditionMessage(e)
  )
  stopifnot(grepl("strengthReductionRuleID", Missing.rule.error, fixed = TRUE))

  Empty <- Reinforcement[0, ]
  Empty.error <- tryCatch(
    buildConcreteSectionDomain(
      thicknessMm = 150,
      stripWidthMm = 1000,
      compressiveStrengthMPa = 30,
      reinforcement = Empty,
      concreteMaximumStrain = 0.003,
      concreteStressFactor = 0.85,
      beta1 = 0.836,
      strengthReductionFactor = 0.65,
      neutralAxisDepthsMm = Depths.base,
      provisionID = "synthetic-concrete-provisions",
      sourceLocator = "internal mathematical control"
    ),
    error = function(e) conditionMessage(e)
  )
  stopifnot(grepl("requires at least one", Empty.error, fixed = TRUE))
  invisible(TRUE)
}

runConcreteDemandTests()
cat("PASS: concrete P-M domain geometry and demand evaluator.\n")
