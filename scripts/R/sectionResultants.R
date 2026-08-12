# Calculate the three circumferential resultants and integration diagnostics.

if (!exists("solveRingDirect", mode = "function")) {
  stop(
    "Source scripts/R/ringDirect.R before scripts/R/sectionResultants.R.",
    call. = FALSE
  )
}

calculateSectionResultants <- function(
  load,
  radius,
  theta = (0:720) * 2 * pi / 721,
  sectionRatio = 0,
  integrationSteps = 4096L,
  balanceTolerance = 1e-8,
  allowUnbalanced = FALSE
) {
  solveRingDirect(
    load = load,
    radius = radius,
    theta = theta,
    sectionRatio = sectionRatio,
    integrationSteps = integrationSteps,
    balanceTolerance = balanceTolerance,
    allowUnbalanced = allowUnbalanced
  )
}
