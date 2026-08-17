# Verifies the pure ANSI/SDI AISI S100-2024 H1/H2/H3 evaluator.

Arguments <- commandArgs(trailingOnly = FALSE)
FileArgument <- grep("^--file=", Arguments, value = TRUE)
if (length(FileArgument) != 1L) {
  stop("Run with Rscript scripts/R/testAisiS100Demand.R.", call. = FALSE)
}

ScriptPath <- normalizePath(sub("^--file=", "", FileArgument))
ProjectRoot <- normalizePath(file.path(dirname(ScriptPath), "..", ".."))
projectRoot <- ProjectRoot
source(file.path(ProjectRoot, "scripts", "setup", "calculationFunctions.R"))

assertClose <- function(observed, expected, tolerance = 1e-12) {
  stopifnot(
    length(observed) == length(expected),
    all(is.finite(observed)),
    max(abs(observed - expected)) <= tolerance
  )
}

buildDemand <- function(
  normalForceKnPerM,
  bendingMomentKnMPerM,
  shearForceKnPerM,
  forceEffectStatus = "asd-required",
  thetaRad = 0,
  combinationID = "strength-control",
  resultantConcurrencyStatus = "satisfied",
  localizedReactionStatus = "absent-demonstrated",
  localizedReactionValue = NA_real_,
  localizedReactionUnit = NA_character_,
  localizedReactionWidthBasisID = NA_character_,
  localizedReactionEvidenceLocator = "synthetic-distributed-load-control",
  localizedMomentValue = NA_real_,
  localizedMomentUnit = NA_character_,
  localizedDemandEvidenceLocator = NA_character_
) {
  data.frame(
    scenarioID = "synthetic-equation-control",
    sectionID = "synthetic-section",
    combinationID = combinationID,
    stageID = "completed-fill",
    thetaRad = thetaRad,
    thetaDeg = thetaRad * 180 / pi,
    normalForceKnPerM = normalForceKnPerM,
    bendingMomentKnMPerM = bendingMomentKnMPerM,
    shearForceKnPerM = shearForceKnPerM,
    forceEffectStatus = forceEffectStatus,
    longitudinalBasis = "per-projected-metre",
    resultantConcurrencyStatus = resultantConcurrencyStatus,
    resultantConcurrencyEvidenceLocator = "synthetic-concurrent-row",
    localizedReactionStatus = localizedReactionStatus,
    localizedReactionValue = localizedReactionValue,
    localizedReactionUnit = localizedReactionUnit,
    localizedReactionWidthBasisID = localizedReactionWidthBasisID,
    localizedReactionEvidenceLocator = localizedReactionEvidenceLocator,
    localizedMomentValue = localizedMomentValue,
    localizedMomentUnit = localizedMomentUnit,
    localizedDemandEvidenceLocator = localizedDemandEvidenceLocator,
    stringsAsFactors = FALSE
  )
}

buildSettings <- function(
  designMethodID = "ASD",
  demandBasisID = "asd-required",
  editionAdoptionStatus = "satisfied",
  evaluationPurposeID = "strength-check",
  jurisdictionID = "US"
) {
  list(
    standardID = "ANSI-SDI-AISI-S100-24",
    jurisdictionID = jurisdictionID,
    designMethodID = designMethodID,
    loadCombinationBasisID = "synthetic-equation-control",
    demandBasisID = demandBasisID,
    editionAdoptionStatus = editionAdoptionStatus,
    evaluationPurposeID = evaluationPurposeID,
    widthBasisID = "per-projected-metre",
    axialZeroToleranceKnPerM = 1e-10,
    momentZeroToleranceKnMPerM = 1e-12,
    shearZeroToleranceKnPerM = 1e-10,
    angleToleranceDeg = 1e-10
  )
}

buildApplicability <- function(
  secondOrderStatus = "satisfied",
  concentricDemandStatus = "satisfied",
  shearStiffenerStatus = "absent",
  localizedReactionStatus = "absent-demonstrated",
  localizedReactionEvidenceLocator = "synthetic-distributed-load-control"
) {
  list(
    sectionClassID = "general-uniaxial",
    secondOrderStatus = secondOrderStatus,
    concentricDemandStatus = concentricDemandStatus,
    concentricDemandEvidenceLocator = "synthetic-concentric-demand",
    b4Status = "satisfied",
    b4EvidenceLocator = "synthetic-b4-control",
    crossSectionSymmetryStatus = "satisfied",
    shearInWebPlaneStatus = "satisfied",
    shearMappingStatus = "satisfied",
    shearRouteID = "accepted-alternative",
    shearRouteStatus = "satisfied",
    shearRouteEvidenceLocator = "synthetic-alternative-shear-route",
    shearStiffenerStatus = shearStiffenerStatus,
    g4GateStatus = c(
      strengthStiffness = "satisfied",
      spacingLe2h = "satisfied",
      flangeDistortionRestraint = "satisfied",
      spanEndAttachment = "satisfied"
    ),
    g4GateEvidenceLocator = c(
      strengthStiffness = "synthetic-g4-control",
      spacingLe2h = "synthetic-g4-control",
      flangeDistortionRestraint = "synthetic-g4-control",
      spanEndAttachment = "synthetic-g4-control"
    ),
    localizedReactionRouteID = "unknown",
    localizedReactionRouteStatus = "unknown",
    localizedReactionRouteEvidenceLocator = "synthetic-localized-route",
    h3InteractionCaseID = "unknown",
    h3CaseEvidenceLocator = "synthetic-h3-classification",
    localizedReactionStatus = localizedReactionStatus,
    localizedReactionEvidenceLocator = localizedReactionEvidenceLocator
  )
}

buildCapacities <- function(designMethodID = "ASD") {
  data.frame(
    sectionID = "synthetic-section",
    capacityID = c(
      "ta-control", "pa-control", "ma-positive-control",
      "ma-negative-control", "mat-positive-control",
      "mat-negative-control", "malo-positive-control",
      "malo-negative-control", "va-positive-control",
      "va-negative-control"
    ),
    capacityRoleID = c(
      "Ta", "Pa", "Ma", "Ma", "Mat", "Mat", "MaloH2", "MaloH2",
      "Va", "Va"
    ),
    senseID = c(
      "not-applicable", "not-applicable", "positive", "negative",
      "positive", "negative", "positive", "negative", "positive",
      "negative"
    ),
    nominalValue = NA_real_,
    availableValue = c(100, 100, 50, 40, 60, 55, 40, 35, 20, 18),
    unit = c(
      "kN/m", "kN/m", rep("kN m/m", 6L), "kN/m", "kN/m"
    ),
    designMethodID = designMethodID,
    widthBasisID = "per-projected-metre",
    capacityConsumerID = c(
      "general", "general", "general", "general", "H1", "H1", "H2",
      "H2", "general", "general"
    ),
    capacityBasisID = "test",
    applicabilityStatus = "satisfied",
    limitStateID = c(
      "D", "E", "F", "F", "F", "F", "F-H2", "F-H2", "G", "G"
    ),
    sectionHoleStatus = c(rep("absent", 8L), rep("not-applicable", 2L)),
    webHoleStatus = c(rep("not-applicable", 8L), rep("absent", 2L)),
    netSectionBasisID = NA_character_,
    capacityCoverageStatus = "satisfied",
    capacityCoverageEvidenceLocator = "synthetic-capacity-coverage",
    evidenceLocator = "synthetic-capacity-evidence",
    sourceLocator = "internal-mathematical-control",
    stringsAsFactors = FALSE
  )
}

appendH3Capacities <- function(capacities, designMethodID = "ASD") {
  H3 <- data.frame(
    sectionID = "synthetic-section",
    capacityID = c(
      "rwc-available-control", "rwc-nominal-control",
      "malo-h3-positive-control", "mnlo-h3-positive-control"
    ),
    capacityRoleID = c("RwcA", "RwcN", "MaloH3", "MnloH3"),
    senseID = c("not-applicable", "not-applicable", "positive", "positive"),
    nominalValue = c(NA, 100, NA, 50),
    availableValue = c(50, NA, 40, NA),
    unit = c("kN/m", "kN/m", "kN m/m", "kN m/m"),
    designMethodID = designMethodID,
    widthBasisID = "per-projected-metre",
    capacityConsumerID = "H3",
    capacityBasisID = "test",
    applicabilityStatus = "satisfied",
    limitStateID = c("G5", "G5", "F-H3", "F-H3"),
    sectionHoleStatus = c(
      "not-applicable", "not-applicable", "absent", "absent"
    ),
    webHoleStatus = c("absent", "absent", "not-applicable", "not-applicable"),
    netSectionBasisID = NA_character_,
    capacityCoverageStatus = "satisfied",
    capacityCoverageEvidenceLocator = "synthetic-h3-capacity-coverage",
    evidenceLocator = "synthetic-h3-capacity-evidence",
    sourceLocator = "internal-mathematical-control",
    stringsAsFactors = FALSE
  )
  rbind(capacities, H3)
}

buildH3Applicability <- function(caseID) {
  OUT <- buildApplicability()
  OUT$localizedReactionRouteID <- "G5-no-hole"
  OUT$localizedReactionRouteStatus <- "satisfied"
  OUT$localizedReactionRouteEvidenceLocator <- "synthetic-g5-route"
  OUT$h3InteractionCaseID <- caseID
  OUT$h3CaseEvidenceLocator <- "synthetic-h3-case"
  OUT
}

buildH3Demand <- function(forceEffectStatus = "asd-required") {
  buildDemand(
    0,
    15,
    0,
    forceEffectStatus = forceEffectStatus,
    localizedReactionStatus = "present",
    localizedReactionValue = 20,
    localizedReactionUnit = "kN/m",
    localizedReactionWidthBasisID = "per-projected-metre",
    localizedReactionEvidenceLocator = "synthetic-reaction-control",
    localizedMomentValue = 15,
    localizedMomentUnit = "kN m/m",
    localizedDemandEvidenceLocator = "synthetic-localized-demand"
  )
}

selectCheck <- function(result, clauseID) {
  Selected <- result$checks[result$checks$clauseID == clauseID, , drop = FALSE]
  stopifnot(nrow(Selected) == 1L)
  Selected
}

Settings <- buildSettings()
Applicability <- buildApplicability()
Capacities <- buildCapacities()

# H1.2: 20/100 + 15/50 = 0.50.
Result.h12 <- evaluateAisiS100Demand(
  buildDemand(-20, 15, 0),
  Capacities,
  Applicability,
  Settings
)
Check.h12 <- selectCheck(Result.h12, "Eq. H1.2-1")
assertClose(Check.h12$equationValue, 0.5)
stopifnot(
  Check.h12$evaluationStatus == "pass",
  Result.h12$summary$wallMemberVerdict == "pass"
)

# H1.1: two independent equations, including the favourable tensile term.
Result.h11 <- evaluateAisiS100Demand(
  buildDemand(20, 15, 0),
  Capacities,
  Applicability,
  Settings
)
Check.h11a <- selectCheck(Result.h11, "Eq. H1.1-1")
Check.h11b <- selectCheck(Result.h11, "Eq. H1.1-2")
assertClose(Check.h11a$equationValue, 0.45)
assertClose(Check.h11b$equationValue, 0.10)
stopifnot(nrow(Result.h11$capacityUsage) == 4L)

# H2-1 is the sum of the squared moment and shear ratios.
Result.h21 <- evaluateAisiS100Demand(
  buildDemand(0, 30, 8),
  Capacities,
  Applicability,
  Settings
)
Check.h21 <- selectCheck(Result.h21, "Eq. H2-1")
assertClose(Check.h21$equationValue, 0.7225)
stopifnot(Check.h21$evaluationStatus == "pass")
stopifnot(
  "malo-positive-control" %in% Result.h21$capacityUsage$capacityID,
  !any(
    Result.h21$capacityUsage$capacityID == "ma-positive-control" &
      Result.h21$capacityUsage$checkID == Check.h21$checkID
  )
)

# Signed bending selects different capacities before taking abs(M).
Demand.sign <- rbind(
  buildDemand(-20, 15, 0, thetaRad = 0),
  buildDemand(-20, -15, 0, thetaRad = pi)
)
Result.sign <- evaluateAisiS100Demand(
  Demand.sign,
  Capacities,
  Applicability,
  Settings
)
Usage.ma <- Result.sign$capacityUsage[
  Result.sign$capacityUsage$capacityRoleID == "Ma",
  ,
  drop = FALSE
]
stopifnot(
  "ma-positive-control" %in% Usage.ma$capacityID,
  "ma-negative-control" %in% Usage.ma$capacityID
)

# A row cannot override its declared demand basis through settings.
Result.forceEffectMismatch <- evaluateAisiS100Demand(
  buildDemand(
    normalForceKnPerM = -20,
    bendingMomentKnMPerM = 15,
    shearForceKnPerM = 0,
    forceEffectStatus = "unfactored-reference-state"
  ),
  Capacities,
  Applicability,
  Settings
)
stopifnot(
  all(Result.forceEffectMismatch$checks$evaluationStatus == "invalid"),
  Result.forceEffectMismatch$summary$normativeVerdict == "invalid"
)

# Different scenarios may share the same section, stage and angle.
Demand.scenarios <- rbind(
  buildDemand(-20, 15, 0),
  buildDemand(-20, 15, 0)
)
Demand.scenarios$scenarioID <- c("scenario-a", "scenario-b")
Result.scenarios <- evaluateAisiS100Demand(
  Demand.scenarios,
  Capacities,
  Applicability,
  Settings
)
stopifnot(nrow(Result.scenarios$checks) > 0L)

# H1.1-2 can govern even when H1.1-1 passes.
Capacities.h11Fail <- Capacities
Capacities.h11Fail$availableValue[
  Capacities.h11Fail$capacityID == "ma-positive-control"
] <- 10
Capacities.h11Fail$availableValue[
  Capacities.h11Fail$capacityID == "mat-positive-control"
] <- 100
Result.h11Fail <- evaluateAisiS100Demand(
  buildDemand(20, 15, 0),
  Capacities.h11Fail,
  Applicability,
  Settings
)
stopifnot(
  selectCheck(Result.h11Fail, "Eq. H1.1-1")$evaluationStatus == "pass",
  selectCheck(Result.h11Fail, "Eq. H1.1-2")$evaluationStatus == "fail",
  Result.h11Fail$summary$wallMemberVerdict == "fail"
)

# Pure axial branches consume only their applicable axial capacity.
Result.pureTension <- evaluateAisiS100Demand(
  buildDemand(20, 0, 0),
  Capacities,
  Applicability,
  Settings
)
stopifnot(
  selectCheck(Result.pureTension, "Chapter D")$evaluationStatus == "pass",
  identical(
    unique(Result.pureTension$capacityUsage$capacityRoleID),
    "Ta"
  )
)
Result.pureCompression <- evaluateAisiS100Demand(
  buildDemand(-20, 0, 0),
  Capacities,
  Applicability,
  Settings
)
stopifnot(
  selectCheck(Result.pureCompression, "Chapter E")$evaluationStatus ==
    "pass",
  identical(
    unique(Result.pureCompression$capacityUsage$capacityRoleID),
    "Pa"
  )
)

# H1.2 is blocked until second-order demand is resolved.
Result.secondOrder <- evaluateAisiS100Demand(
  buildDemand(-20, 15, 0),
  Capacities,
  buildApplicability(secondOrderStatus = "unknown"),
  Settings
)
stopifnot(
  selectCheck(Result.secondOrder, "Eq. H1.2-1")$evaluationStatus == "blocked",
  Result.secondOrder$summary$wallMemberVerdict == "blocked"
)

# The special singly-symmetric unstiffened-angle rule is not approximated.
Applicability.angle <- Applicability
Applicability.angle$sectionClassID <-
  "singly-symmetric-unstiffened-angle"
Result.angle <- evaluateAisiS100Demand(
  buildDemand(-20, 15, 0),
  Capacities,
  Applicability.angle,
  Settings
)
stopifnot(
  selectCheck(Result.angle, "Eq. H1.2-1")$evaluationStatus == "blocked",
  selectCheck(Result.angle, "Eq. H1.2-1")$reasonCode ==
    "unsupported-section-class"
)

# A documented second-order exception requires and preserves its evidence.
Applicability.secondOrderException <- buildApplicability(
  secondOrderStatus = "documented-exception"
)
Result.secondOrderNoEvidence <- evaluateAisiS100Demand(
  buildDemand(-20, 15, 0),
  Capacities,
  Applicability.secondOrderException,
  Settings
)
stopifnot(
  selectCheck(
    Result.secondOrderNoEvidence,
    "Eq. H1.2-1"
  )$evaluationStatus == "invalid"
)
Applicability.secondOrderException$secondOrderEvidenceLocator <-
  "synthetic-second-order-exception"
Result.secondOrderException <- evaluateAisiS100Demand(
  buildDemand(-20, 15, 0),
  Capacities,
  Applicability.secondOrderException,
  Settings
)
Check.secondOrderException <- selectCheck(
  Result.secondOrderException,
  "Eq. H1.2-1"
)
stopifnot(
  Check.secondOrderException$evaluationStatus == "pass",
  Check.secondOrderException$evidenceLocator ==
    "synthetic-second-order-exception"
)

# ASD demand cannot consume LRFD available strengths.
Result.methodMismatch <- evaluateAisiS100Demand(
  buildDemand(-20, 15, 0),
  buildCapacities("LRFD"),
  Applicability,
  Settings
)
stopifnot(
  selectCheck(Result.methodMismatch, "Eq. H1.2-1")$evaluationStatus == "invalid",
  Result.methodMismatch$summary$wallMemberVerdict == "invalid"
)

# An unfactored reference state is diagnostic, never a normative pass.
Settings.diagnostic <- buildSettings(
  demandBasisID = "unfactored-reference-state",
  editionAdoptionStatus = "unknown",
  evaluationPurposeID = "diagnostic-capacity-map",
  jurisdictionID = "contractual-other"
)
Result.diagnostic <- evaluateAisiS100Demand(
  buildDemand(
    -20,
    15,
    0,
    forceEffectStatus = "unfactored-reference-state"
  ),
  Capacities,
  Applicability,
  Settings.diagnostic
)
stopifnot(
  selectCheck(Result.diagnostic, "Eq. H1.2-1")$evaluationStatus ==
    "diagnostic-only",
  Result.diagnostic$summary$normativeVerdict == "blocked",
  !Result.diagnostic$summary$complete
)

# Concurrent N, M and Q run H1 and H2 independently.
Result.concurrent <- evaluateAisiS100Demand(
  buildDemand(-20, 15, 8),
  Capacities,
  Applicability,
  Settings
)
stopifnot(
  "Eq. H1.2-1" %in% Result.concurrent$checks$clauseID,
  "Eq. H2-1" %in% Result.concurrent$checks$clauseID,
  !any(Result.concurrent$checks$checkFamilyID == "NMQ"),
  abs(
    selectCheck(Result.concurrent, "Eq. H1.2-1")$equationValue - 0.50
  ) < 1e-12,
  abs(
    selectCheck(Result.concurrent, "Eq. H2-1")$equationValue - 0.300625
  ) < 1e-12,
  abs(
    Result.concurrent$summary$governingNormalizedCheckValue - 0.50
  ) < 1e-12
)

# H2-2 uses strict thresholds: equality does not activate the equation.
Result.threshold <- evaluateAisiS100Demand(
  buildDemand(0, 20, 14),
  Capacities,
  buildApplicability(shearStiffenerStatus = "g4-satisfied"),
  Settings
)
Check.threshold <- selectCheck(Result.threshold, "Eq. H2-2")
stopifnot(Check.threshold$evaluationStatus == "not-required-by-threshold")

# Q alone requires Va, not MaloH2, and does not create an H3 reaction.
Result.shearOnly <- evaluateAisiS100Demand(
  buildDemand(0, 0, 8),
  Capacities,
  Applicability,
  Settings
)
stopifnot(
  "Section H2 individual shear" %in% Result.shearOnly$checks$clauseID,
  !any(Result.shearOnly$capacityUsage$capacityRoleID == "MaloH2"),
  selectCheck(Result.shearOnly, "Section H3")$evaluationStatus ==
    "not-applicable"
)

# H3 distinguishes an unknown reaction from a present but unresolved reaction.
Result.h3Unknown <- evaluateAisiS100Demand(
  buildDemand(
    -20,
    0,
    0,
    localizedReactionStatus = "unknown",
    localizedReactionEvidenceLocator = NA_character_
  ),
  Capacities,
  Applicability,
  Settings
)
stopifnot(
  selectCheck(Result.h3Unknown, "Section H3")$evaluationStatus == "blocked",
  selectCheck(Result.h3Unknown, "Section H3")$applicabilityStatus == "unknown",
  !selectCheck(Result.h3Unknown, "Section H3")$complete,
  Result.h3Unknown$summary$wallMemberVerdict == "blocked"
)
Result.h3Present <- evaluateAisiS100Demand(
  buildDemand(
    -20,
    0,
    0,
    localizedReactionStatus = "present",
    localizedReactionValue = 20,
    localizedReactionUnit = "kN/m",
    localizedReactionWidthBasisID = "per-projected-metre",
    localizedReactionEvidenceLocator = "synthetic-reaction-control",
    localizedMomentValue = 0,
    localizedMomentUnit = "kN m/m",
    localizedDemandEvidenceLocator = "synthetic-localized-demand"
  ),
  Capacities,
  Applicability,
  Settings
)
stopifnot(selectCheck(Result.h3Present, "Section H3")$evaluationStatus ==
  "blocked")

# Missing and duplicate capacities do not become favourable values.
Capacities.missing <- Capacities[
  Capacities$capacityRoleID != "Pa",
  ,
  drop = FALSE
]
Result.missing <- evaluateAisiS100Demand(
  buildDemand(-20, 15, 0),
  Capacities.missing,
  Applicability,
  Settings
)
stopifnot(selectCheck(Result.missing, "Eq. H1.2-1")$evaluationStatus ==
  "blocked")
Capacity.duplicate <- Capacities[Capacities$capacityID == "pa-control", ]
Capacity.duplicate$capacityID <- "pa-control-duplicate"
Result.duplicate <- evaluateAisiS100Demand(
  buildDemand(-20, 15, 0),
  rbind(Capacities, Capacity.duplicate),
  Applicability,
  Settings
)
stopifnot(selectCheck(Result.duplicate, "Eq. H1.2-1")$evaluationStatus ==
  "invalid")

# Unknown capacity applicability blocks; an incompatible width basis is invalid.
Capacities.unknown <- Capacities
Capacities.unknown$applicabilityStatus[
  Capacities.unknown$capacityID == "pa-control"
] <- "unknown"
Result.capacityUnknown <- evaluateAisiS100Demand(
  buildDemand(-20, 15, 0),
  Capacities.unknown,
  Applicability,
  Settings
)
stopifnot(
  selectCheck(Result.capacityUnknown, "Eq. H1.2-1")$evaluationStatus ==
    "blocked",
  !Result.capacityUnknown$summary$complete
)
Capacities.widthMismatch <- Capacities
Capacities.widthMismatch$widthBasisID[
  Capacities.widthMismatch$capacityID == "pa-control"
] <- "per-developed-metre"
Result.widthMismatch <- evaluateAisiS100Demand(
  buildDemand(-20, 15, 0),
  Capacities.widthMismatch,
  Applicability,
  Settings
)
stopifnot(
  selectCheck(Result.widthMismatch, "Eq. H1.2-1")$evaluationStatus ==
    "invalid"
)

# Not-applicable H3 requires affirmative evidence.
Result.h3NoEvidence <- evaluateAisiS100Demand(
  buildDemand(
    -20,
    0,
    0,
    localizedReactionEvidenceLocator = ""
  ),
  Capacities,
  Applicability,
  Settings
)
stopifnot(selectCheck(Result.h3NoEvidence, "Section H3")$evaluationStatus ==
  "invalid")

# A known failure remains visible when another required check is blocked.
Capacities.fail <- Capacities
Capacities.fail$availableValue[
  Capacities.fail$capacityID == "pa-control"
] <- 10
Result.failBlocked <- evaluateAisiS100Demand(
  buildDemand(
    -20,
    15,
    0,
    localizedReactionStatus = "unknown",
    localizedReactionEvidenceLocator = NA_character_
  ),
  Capacities.fail,
  Applicability,
  Settings
)
stopifnot(
  Result.failBlocked$summary$wallMemberVerdict == "fail",
  Result.failBlocked$summary$normativeVerdict == "fail",
  !Result.failBlocked$summary$complete
)

# A concurrent demand row is an explicit gate, not an inference from extrema.
Result.concurrencyInvalid <- evaluateAisiS100Demand(
  buildDemand(
    -20,
    15,
    0,
    resultantConcurrencyStatus = "not-satisfied"
  ),
  Capacities,
  Applicability,
  Settings
)
stopifnot(
  Result.concurrencyInvalid$summary$wallMemberVerdict == "invalid",
  nrow(Result.concurrencyInvalid$capacityUsage) == 0L
)

# Aggregate capacities require complete mode coverage and resolved holes.
Capacities.coverageUnknown <- Capacities
Capacities.coverageUnknown$capacityCoverageStatus[
  Capacities.coverageUnknown$capacityID == "pa-control"
] <- "unknown"
Result.coverageUnknown <- evaluateAisiS100Demand(
  buildDemand(-20, 15, 0),
  Capacities.coverageUnknown,
  Applicability,
  Settings
)
stopifnot(
  selectCheck(Result.coverageUnknown, "Eq. H1.2-1")$evaluationStatus ==
    "blocked"
)
Capacities.sectionHole <- Capacities
Capacities.sectionHole$sectionHoleStatus[
  Capacities.sectionHole$capacityID == "pa-control"
] <- "present"
Result.sectionHole <- evaluateAisiS100Demand(
  buildDemand(-20, 15, 0),
  Capacities.sectionHole,
  Applicability,
  Settings
)
stopifnot(
  selectCheck(Result.sectionHole, "Eq. H1.2-1")$evaluationStatus == "blocked"
)
Capacities.notApplicable <- Capacities
Capacities.notApplicable$applicabilityStatus[
  Capacities.notApplicable$capacityID == "pa-control"
] <- "not-applicable"
Capacities.notApplicable$evidenceLocator[
  Capacities.notApplicable$capacityID == "pa-control"
] <- ""
Result.capacityNotApplicable <- evaluateAisiS100Demand(
  buildDemand(-20, 15, 0),
  Capacities.notApplicable,
  Applicability,
  Settings
)
stopifnot(
  selectCheck(Result.capacityNotApplicable, "Eq. H1.2-1")$evaluationStatus ==
    "invalid"
)

# Ordinary EWM/DSM capacities require a demonstrated B4 gate.
Capacities.b4 <- Capacities
Capacities.b4$capacityBasisID[
  Capacities.b4$capacityRoleID %in% c("Pa", "Ma")
] <- "EWM"
Applicability.b4Unknown <- Applicability
Applicability.b4Unknown$b4Status <- "unknown"
Result.b4Unknown <- evaluateAisiS100Demand(
  buildDemand(-20, 15, 0),
  Capacities.b4,
  Applicability.b4Unknown,
  Settings
)
stopifnot(
  selectCheck(Result.b4Unknown, "Eq. H1.2-1")$evaluationStatus == "blocked"
)
Applicability.b4Outside <- Applicability
Applicability.b4Outside$b4Status <- "not-satisfied"
Result.b4Outside <- evaluateAisiS100Demand(
  buildDemand(-20, 15, 0),
  Capacities.b4,
  Applicability.b4Outside,
  Settings
)
stopifnot(
  selectCheck(Result.b4Outside, "Eq. H1.2-1")$applicabilityStatus ==
    "outside-prescriptive-scope"
)

# Shear routes preserve hole status and their branch-specific evidence.
Capacities.webUnknown <- Capacities
Capacities.webUnknown$webHoleStatus[
  Capacities.webUnknown$capacityRoleID == "Va"
] <- "unknown"
Result.webUnknown <- evaluateAisiS100Demand(
  buildDemand(0, 0, 8),
  Capacities.webUnknown,
  Applicability,
  Settings
)
stopifnot(
  selectCheck(
    Result.webUnknown,
    "Section H2 individual shear"
  )$evaluationStatus == "blocked"
)
Applicability.g2 <- buildApplicability()
Applicability.g2$shearRouteID <- "G2-no-hole"
Applicability.g2$shearRouteEvidenceLocator <- "synthetic-g2-route"
Capacities.g2Mismatch <- Capacities
Capacities.g2Mismatch$webHoleStatus[
  Capacities.g2Mismatch$capacityRoleID == "Va"
] <- "present"
Result.g2Mismatch <- evaluateAisiS100Demand(
  buildDemand(0, 0, 8),
  Capacities.g2Mismatch,
  Applicability.g2,
  Settings
)
stopifnot(
  selectCheck(
    Result.g2Mismatch,
    "Section H2 individual shear"
  )$applicabilityStatus == "outside-prescriptive-scope"
)
Applicability.g3 <- buildApplicability()
Applicability.g3$shearRouteID <- "G3-qualified-hole"
Applicability.g3$shearRouteEvidenceLocator <- "synthetic-g3-route"
Applicability.g3$g3LimitStatus <- setNames(
  rep("satisfied", 8L),
  c(
    "holeDepthRatio", "stiffenedAspectRatio", "holeLengthToSpacing",
    "holeAspectRatio", "midDepthLocation", "clearHoleSpacing",
    "midStiffenerSpacing", "cornerRadius"
  )
)
Applicability.g3$g3LimitEvidenceLocator <- setNames(
  rep("synthetic-g3-control", 8L),
  names(Applicability.g3$g3LimitStatus)
)
Capacities.g3 <- Capacities
Capacities.g3$webHoleStatus[Capacities.g3$capacityRoleID == "Va"] <- "present"
Result.g3 <- evaluateAisiS100Demand(
  buildDemand(0, 0, 8),
  Capacities.g3,
  Applicability.g3,
  Settings
)
stopifnot(
  selectCheck(Result.g3, "Section H2 individual shear")$evaluationStatus ==
    "pass"
)
Applicability.g3Unknown <- Applicability.g3
Applicability.g3Unknown$g3LimitStatus[["cornerRadius"]] <- "unknown"
Result.g3Unknown <- evaluateAisiS100Demand(
  buildDemand(0, 0, 8),
  Capacities.g3,
  Applicability.g3Unknown,
  Settings
)
stopifnot(
  selectCheck(
    Result.g3Unknown,
    "Section H2 individual shear"
  )$evaluationStatus == "blocked"
)
Applicability.g4Unknown <- buildApplicability(
  shearStiffenerStatus = "g4-satisfied"
)
Applicability.g4Unknown$g4GateStatus[["spanEndAttachment"]] <- "unknown"
Result.g4Unknown <- evaluateAisiS100Demand(
  buildDemand(0, 20, 14),
  Capacities,
  Applicability.g4Unknown,
  Settings
)
stopifnot(
  selectCheck(Result.g4Unknown, "Section H2")$evaluationStatus == "blocked"
)

# H2 rejects capacity bases mixed across its individual and interaction checks.
Capacities.h2Mixed <- Capacities
Capacities.h2Mixed$capacityBasisID[
  Capacities.h2Mixed$capacityRoleID == "Ma"
] <- "DSM"
Result.h2Mixed <- evaluateAisiS100Demand(
  buildDemand(0, 30, 8),
  Capacities.h2Mixed,
  Applicability,
  Settings
)
stopifnot(
  selectCheck(Result.h2Mixed, "Section H2")$evaluationStatus == "invalid",
  Result.h2Mixed$summary$wallMemberVerdict == "invalid"
)

# A blocked shear branch does not erase concurrent satisfactory H1 checks.
Capacities.partial <- Capacities
Capacities.partial$capacityCoverageStatus[
  Capacities.partial$capacityRoleID == "Va"
] <- "unknown"
Result.partial <- evaluateAisiS100Demand(
  buildDemand(-20, 15, 8),
  Capacities.partial,
  Applicability,
  Settings
)
stopifnot(
  selectCheck(Result.partial, "Eq. H1.2-1")$evaluationStatus == "pass",
  Result.partial$summary$wallMemberVerdict == "blocked",
  !Result.partial$summary$complete
)

# H3 consumes its own available and nominal capacities.
Capacities.h3 <- appendH3Capacities(Capacities)
Result.h31 <- evaluateAisiS100Demand(
  buildH3Demand(),
  Capacities.h3,
  buildH3Applicability("single-unreinforced-flat-web"),
  Settings
)
assertClose(selectCheck(Result.h31, "Eq. H3-1")$equationValue, 0.482)
Result.h32 <- evaluateAisiS100Demand(
  buildH3Demand(),
  Capacities.h3,
  buildH3Applicability(
    "multiple-unreinforced-webs-high-rotation-restraint"
  ),
  Settings
)
assertClose(selectCheck(Result.h32, "Eq. H3-2")$equationValue, 0.476)
Applicability.h33 <- buildH3Applicability("two-nested-z")
Applicability.h33$h3NestedZGateStatus <- setNames(
  rep("satisfied", 8L),
  c(
    "depthToThickness", "bearingLengthToThickness", "yieldStrength",
    "radiusToThickness", "webEndBolts", "flangeSupportBolts",
    "webContact", "thicknessRatio"
  )
)
Applicability.h33$h3NestedZGateEvidenceLocator <- setNames(
  rep("synthetic-h3-3-control", 8L),
  names(Applicability.h33$h3NestedZGateStatus)
)
Applicability.h33$nestedZThickerToThinnerThicknessRatio <- 1.3
Result.h33 <- evaluateAisiS100Demand(
  buildH3Demand(),
  Capacities.h3,
  Applicability.h33,
  Settings
)
assertClose(selectCheck(Result.h33, "Eq. H3-3")$equationValue, 0.472)
Applicability.h33Outside <- Applicability.h33
Applicability.h33Outside$nestedZThickerToThinnerThicknessRatio <- 1.3001
Result.h33Outside <- evaluateAisiS100Demand(
  buildH3Demand(),
  Capacities.h3,
  Applicability.h33Outside,
  Settings
)
stopifnot(
  selectCheck(Result.h33Outside, "Eq. H3-3")$applicabilityStatus ==
    "outside-prescriptive-scope"
)
Applicability.h3Exception <- buildH3Applicability(
  "interior-support-exception"
)
Applicability.h3Exception$h3ExceptionStatus <- "satisfied"
Applicability.h3Exception$continuousSpanInteriorSupportStatus <- "satisfied"
Applicability.h3Exception$memberFamilyID <- "deck-or-beam"
Applicability.h3Exception$singleWebCount <- 2
Applicability.h3Exception$compressionEdgesLateralSupportStatus <- "satisfied"
Applicability.h3Exception$adjacentWebSpacingMm <- 254
Result.h3Exception <- evaluateAisiS100Demand(
  buildH3Demand(),
  Capacities.h3,
  Applicability.h3Exception,
  Settings
)
stopifnot(
  selectCheck(Result.h3Exception, "Section H3")$evaluationStatus ==
    "not-required-by-exception",
  all(c(
    "Section H3 individual web crippling",
    "Section H3 individual bending"
  ) %in% Result.h3Exception$checks$clauseID)
)
Capacities.h3Missing <- Capacities.h3[
  Capacities.h3$capacityRoleID != "MnloH3",
  ,
  drop = FALSE
]
Capacities.h3Missing$availableValue[
  Capacities.h3Missing$capacityRoleID == "RwcA"
] <- 10
Result.h3Missing <- evaluateAisiS100Demand(
  buildH3Demand(),
  Capacities.h3Missing,
  buildH3Applicability("single-unreinforced-flat-web"),
  Settings
)
stopifnot(
  selectCheck(
    Result.h3Missing,
    "Section H3 individual web crippling"
  )$evaluationStatus == "fail",
  selectCheck(Result.h3Missing, "Section H3")$evaluationStatus == "blocked",
  Result.h3Missing$summary$wallMemberVerdict == "fail",
  !Result.h3Missing$summary$complete
)
Result.h3Outside <- evaluateAisiS100Demand(
  buildH3Demand(),
  Capacities.h3,
  buildH3Applicability("unsupported"),
  Settings
)
stopifnot(
  selectCheck(Result.h3Outside, "Section H3")$applicabilityStatus ==
    "outside-prescriptive-scope"
)
stopifnot(
  "malo-h3-positive-control" %in% Result.h31$capacityUsage$capacityID,
  "mnlo-h3-positive-control" %in% Result.h31$capacityUsage$capacityID,
  !any(
    Result.h31$capacityUsage$capacityID == "malo-positive-control" &
      Result.h31$capacityUsage$checkID == selectCheck(
        Result.h31,
        "Eq. H3-1"
      )$checkID
  )
)

# LRFD uses factored demand, LRFD strengths and the LRFD H3 limit.
Settings.lrfd <- buildSettings(
  designMethodID = "LRFD",
  demandBasisID = "lrfd-factored"
)
Capacities.lrfd <- buildCapacities("LRFD")
Result.lrfd <- evaluateAisiS100Demand(
  buildDemand(-20, 15, 8, forceEffectStatus = "lrfd-factored"),
  Capacities.lrfd,
  Applicability,
  Settings.lrfd
)
stopifnot(
  selectCheck(Result.lrfd, "Eq. H1.2-1")$evaluationStatus == "pass",
  selectCheck(Result.lrfd, "Eq. H2-1")$evaluationStatus == "pass"
)
Capacities.h3Lrfd <- appendH3Capacities(
  Capacities.lrfd,
  designMethodID = "LRFD"
)
Result.h31Lrfd <- evaluateAisiS100Demand(
  buildH3Demand("lrfd-factored"),
  Capacities.h3Lrfd,
  buildH3Applicability("single-unreinforced-flat-web"),
  Settings.lrfd
)
Check.h31Lrfd <- selectCheck(Result.h31Lrfd, "Eq. H3-1")
assertClose(Check.h31Lrfd$equationLimit, 1.33 * 0.90)
stopifnot(Check.h31Lrfd$evaluationStatus == "pass")

# LSD is rejected before capacities are divided.
Settings.lsd <- buildSettings(
  designMethodID = "LSD",
  demandBasisID = "unfactored-reference-state",
  editionAdoptionStatus = "unknown",
  evaluationPurposeID = "diagnostic-capacity-map",
  jurisdictionID = "CA"
)
Result.lsd <- evaluateAisiS100Demand(
  buildDemand(-20, 15, 8),
  Capacities,
  Applicability,
  Settings.lsd
)
stopifnot(
  all(Result.lsd$checks$reasonCode == "unsupported-design-method-LSD"),
  nrow(Result.lsd$capacityUsage) == 0L,
  Result.lsd$summary$normativeVerdict == "blocked"
)

# Every emitted state belongs to the accepted output domains.
Results <- list(
  Result.h12, Result.h11, Result.h21, Result.sign, Result.h11Fail,
  Result.pureTension, Result.pureCompression, Result.secondOrder,
  Result.angle, Result.secondOrderNoEvidence, Result.secondOrderException,
  Result.forceEffectMismatch, Result.scenarios, Result.methodMismatch,
  Result.diagnostic, Result.concurrent,
  Result.threshold, Result.shearOnly, Result.h3Unknown, Result.h3Present,
  Result.missing, Result.duplicate, Result.capacityUnknown,
  Result.widthMismatch, Result.h3NoEvidence, Result.failBlocked,
  Result.concurrencyInvalid, Result.coverageUnknown, Result.sectionHole,
  Result.capacityNotApplicable, Result.b4Unknown, Result.b4Outside,
  Result.webUnknown, Result.g2Mismatch, Result.g3, Result.g3Unknown,
  Result.g4Unknown, Result.h2Mixed, Result.partial, Result.h31,
  Result.h32, Result.h33, Result.h33Outside, Result.h3Exception,
  Result.h3Missing, Result.h3Outside, Result.lrfd, Result.h31Lrfd,
  Result.lsd
)
ApplicabilityStates <- c(
  "satisfied", "not-applicable", "unknown",
  "outside-prescriptive-scope", "invalid"
)
EvaluationStates <- c(
  "pass", "fail", "blocked", "not-applicable",
  "not-required-by-threshold", "not-required-by-exception",
  "diagnostic-only", "invalid"
)
stopifnot(
  all(vapply(
    Results,
    function(result) all(result$checks$applicabilityStatus %in%
      ApplicabilityStates),
    logical(1)
  )),
  all(vapply(
    Results,
    function(result) all(result$checks$evaluationStatus %in%
      EvaluationStates),
    logical(1)
  ))
)

cat("PASS: AISI S100 H1/H2/H3 evaluator controls.\n")
