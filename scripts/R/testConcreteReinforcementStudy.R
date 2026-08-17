# Regression for the discrete symmetric circumferential-reinforcement family.

Arguments <- commandArgs(trailingOnly = FALSE)
FileArgument <- grep("^--file=", Arguments, value = TRUE)
if (length(FileArgument) != 1L) {
  stop(
    "Run with Rscript scripts/R/testConcreteReinforcementStudy.R.",
    call. = FALSE
  )
}
ScriptPath <- normalizePath(sub("^--file=", "", FileArgument))
projectRoot <- normalizePath(file.path(dirname(ScriptPath), "..", ".."))
source(
  file.path(projectRoot, "scripts", "setup", "calculationFunctions.R"),
  local = TRUE
)

Manifest <- readCalculationJson(file.path(projectRoot, "calculation.json"))
Inputs <- Manifest[["inputs", exact = TRUE]]
Context <- prepareCoverCaseContext(
  inputs = Inputs,
  projectRoot = projectRoot,
  methodID = Manifest[["methodID", exact = TRUE]]
)
Sample <- evaluateCoverSample(inputs = Inputs, context = Context)
stopifnot(is.null(Sample[["reinforcementStudy", exact = TRUE]]))
Study <- .evaluateCoverReinforcementStudy(
  config = Context[["baselineResolved", exact = TRUE]][[
    "config",
    exact = TRUE
  ]],
  additionalLinings = Sample[["additionalLinings", exact = TRUE]]
)

stopifnot(identical(
  names(Study),
  c("domains", "summary", "configuredGoverningDemands")
))
Domains <- Study[["domains", exact = TRUE]]
Summary <- Study[["summary", exact = TRUE]]
ConfiguredDemands <- Study[["configuredGoverningDemands", exact = TRUE]]
stopifnot(
  is.data.frame(Domains),
  is.data.frame(Summary),
  is.data.frame(ConfiguredDemands),
  nrow(Summary) == 5L,
  identical(Summary$reinforcementCaseOrder, 1:5),
  sum(Summary$isConfiguredCase) == 1L,
  sum(Summary$isMinimumHistoricalCase) == 1L,
  sum(Summary$isParametricReferenceCase) == 4L,
  all(Summary$calculationStatus == "calculated"),
  all(Summary$demandReuseStatus == "satisfied"),
  all(Summary$minimumComparisonStatus == "satisfied"),
  all(diff(Summary$maximumRadialUtilization) <= 0.02)
)
ExpectedRatios <- sort(c(
  0.0018,
  2 * 188.4955592153876 / 120000,
  0.01,
  0.02,
  0.03
))
stopifnot(isTRUE(all.equal(
  Summary$reinforcementRatio,
  ExpectedRatios,
  tolerance = 1e-12,
  check.attributes = FALSE
)))
Configured <- Summary[Summary$isConfiguredCase, , drop = FALSE]
Minimum <- Summary[Summary$isMinimumHistoricalCase, , drop = FALSE]
stopifnot(
  abs(Configured$circumferentialAreaTotalMm2PerM -
    376.9911184307752) < 1e-9,
  abs(Minimum$circumferentialAreaTotalMm2PerM - 216) < 1e-9,
  Summary$localPMStatus[Summary$reinforcementRatio == 0.02] ==
    "not-satisfied",
  Summary$localPMStatus[Summary$reinforcementRatio == 0.03] == "satisfied"
)

DomainCounts <- table(Domains$reinforcementCaseID)
stopifnot(
  length(DomainCounts) == nrow(Summary),
  all(DomainCounts == 807L),
  setequal(names(DomainCounts), Summary$reinforcementCaseID),
  all(vapply(split(Domains, Domains$reinforcementCaseID), function(x) {
    identical(x$domainPointIndex, seq_len(nrow(x))) &&
      length(unique(x$domainPrimitiveID)) == 1L
  }, logical(1)))
)

Canonical <- Sample[["additionalLinings", exact = TRUE]][[
  "reinforcedConcrete",
  exact = TRUE
]][["assessment", exact = TRUE]][["aci", exact = TRUE]][[
  "interactionDiagram",
  exact = TRUE
]]
CanonicalDomain <- Canonical[["domain", exact = TRUE]]
ConfiguredDomain <- Domains[
  Domains$reinforcementCaseID == Configured$reinforcementCaseID,
  ,
  drop = FALSE
]
rownames(ConfiguredDomain) <- NULL
rownames(CanonicalDomain) <- NULL
DomainFields <- c(
  "domainPointIndex", "axialStrengthKnPerM", "bendingStrengthKnMPerM",
  "domainPrimitiveID", "provisionID", "designBasisID",
  "strengthReductionRuleID", "sourceLocator"
)
stopifnot(identical(
  ConfiguredDomain[, DomainFields, drop = FALSE],
  CanonicalDomain[, DomainFields, drop = FALSE]
))

CanonicalDemands <- Canonical[["demands", exact = TRUE]]
stopifnot(
  nrow(ConfiguredDemands) == 4L,
  identical(ConfiguredDemands$demandOrder, 1:4),
  unique(ConfiguredDemands$reinforcementCaseID) ==
    Configured$reinforcementCaseID
)
for (i in seq_len(nrow(ConfiguredDemands))) {
  Observed <- ConfiguredDemands[i, , drop = FALSE]
  Expected <- CanonicalDemands[
    CanonicalDemands$caseID == Observed$caseID &
      CanonicalDemands$strengthCaseID == Observed$strengthCaseID &
      CanonicalDemands$thetaIndex == Observed$thetaIndex,
    ,
    drop = FALSE
  ]
  stopifnot(
    nrow(Expected) == 1L,
    Expected$radialUtilization == Observed$radialUtilization,
    Expected$axialDemandKnPerM == Observed$axialDemandKnPerM,
    Expected$bendingDemandKnMPerM == Observed$bendingDemandKnMPerM
  )
}

cat("PASS: five discrete reinforcement P-M domains and four demands.\n")
