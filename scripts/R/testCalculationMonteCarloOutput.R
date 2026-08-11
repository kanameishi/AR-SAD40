source("scripts/R/ringDirect.R")
source("scripts/R/ringLoads.R")
source("scripts/R/ringMonteCarlo.R")
source("scripts/R/calculationMonteCarloOutput.R")

theta <- (0:71) * 2 * pi / 72
draws <- data.frame(
  effectiveVertical = c(90, 100, 110),
  frictionAngleDeg = c(28, 32, 36),
  tangentialMultiplier = c(0, 0.5, 1),
  stringsAsFactors = FALSE
)
result <- runRingMonteCarlo(
  draws = draws,
  responseFunction = function(draw, theta) {
    Load <- k0TangentialMultiplierLoad(
      effectiveVertical = draw$effectiveVertical,
      k0 = k0NormallyConsolidated(draw$frictionAngleDeg),
      porePressure = 0,
      tangentialMultiplier = draw$tangentialMultiplier
    )
    solveRingDirect(
      load = Load,
      radius = 1.315,
      theta = theta,
      sectionRatio = 4.46e-5
    )
  },
  theta = theta,
  probabilities = c(0.05, 0.50, 0.95),
  modelLabel = "mathematical-control"
)
products <- prepareCalculationMonteCarloProducts(
  result,
  caseId = "mathematical-control",
  stageId = "single-stage"
)

stopifnot(
  all(products$pointwiseQuantiles$statisticScope == "pointwise"),
  all(products$extremaQuantiles$statisticScope == "spatialExtremum"),
  !any(c("theta", "thetaDeg") %in% names(products$extremaQuantiles)),
  all(products$extremaQuantiles$sampleCount == nrow(draws)),
  all(products$extremaQuantiles$quantileType == 7L),
  all(products$extremaQuantiles$valueBasis[
    products$extremaQuantiles$statistic == "absoluteMaximum"
  ] == "absolute"),
  identical(result$draws, draws)
)

temporaryDirectory <- tempfile("calculation-monte-carlo-")
paths <- writeCalculationMonteCarloProducts(products, temporaryDirectory)
stopifnot(all(file.exists(paths)))
unlink(temporaryDirectory, recursive = TRUE)

cat("PASS: calculation Monte Carlo output adapter.\n")
