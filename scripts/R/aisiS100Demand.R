# Evaluate ANSI/SDI AISI S100-2024 H1, H2 and H3 demand-capacity checks.
#
# This file contains no capacity model. It consumes externally supplied
# nominal and available strengths with the same design method and
# projected-width basis as the demand. Section shear Q is not converted into a
# concentrated load or reaction.

.aisiRequireNamedList <- function(value, name) {
  if (!is.list(value) || is.null(names(value))) {
    stop(name, " must be one named list.", call. = FALSE)
  }
  value
}

.aisiRequireFields <- function(value, fields, name) {
  Missing <- setdiff(fields, names(value))
  if (length(Missing) > 0L) {
    stop(
      name, " is missing: ", paste(Missing, collapse = ", "), ".",
      call. = FALSE
    )
  }
  invisible(value)
}

.aisiTextScalar <- function(value, name) {
  if (!is.character(value) || length(value) != 1L || !nzchar(value)) {
    stop(name, " must be one non-empty string.", call. = FALSE)
  }
  value
}

.aisiFiniteScalar <- function(value, name, minimum = -Inf) {
  if (!is.numeric(value) || length(value) != 1L || !is.finite(value) ||
      value < minimum) {
    stop(name, " must be one finite number at least ", minimum, ".",
         call. = FALSE)
  }
  as.numeric(value)
}

.validateAisiDemand <- function(demand, angleToleranceDeg) {
  if (!is.data.frame(demand) || nrow(demand) == 0L) {
    stop("demand must be one non-empty data frame.", call. = FALSE)
  }
  Required <- c(
    "sectionID", "combinationID", "stageID", "thetaRad", "thetaDeg",
    "normalForceKnPerM", "bendingMomentKnMPerM", "shearForceKnPerM",
    "forceEffectStatus", "longitudinalBasis",
    "resultantConcurrencyStatus", "resultantConcurrencyEvidenceLocator",
    "localizedReactionStatus", "localizedReactionValue",
    "localizedReactionUnit", "localizedReactionWidthBasisID",
    "localizedReactionEvidenceLocator", "localizedMomentValue",
    "localizedMomentUnit", "localizedDemandEvidenceLocator"
  )
  .aisiRequireFields(demand, Required, "demand")

  TextFields <- c(
    "sectionID", "combinationID", "stageID", "forceEffectStatus",
    "longitudinalBasis", "resultantConcurrencyStatus",
    "resultantConcurrencyEvidenceLocator", "localizedReactionStatus"
  )
  TextValid <- vapply(
    demand[TextFields],
    function(value) is.character(value) && all(!is.na(value)) &&
      all(nzchar(value)),
    logical(1)
  )
  if (!all(TextValid)) {
    stop("Demand identifiers must be non-empty strings.", call. = FALSE)
  }

  NumericFields <- c(
    "thetaRad", "thetaDeg", "normalForceKnPerM",
    "bendingMomentKnMPerM", "shearForceKnPerM"
  )
  NumericValid <- vapply(demand[NumericFields], is.numeric, logical(1))
  if (!all(NumericValid) ||
      any(!is.finite(as.matrix(demand[NumericFields])))) {
    stop("Demand values and angles must be finite numbers.", call. = FALSE)
  }
  AngleDifference <- abs(demand$thetaDeg - demand$thetaRad * 180 / pi)
  if (any(AngleDifference > angleToleranceDeg)) {
    stop("demand.thetaRad and demand.thetaDeg are inconsistent.",
         call. = FALSE)
  }
  if (any(demand$longitudinalBasis != "per-projected-metre")) {
    stop("demand.longitudinalBasis must be per-projected-metre.",
         call. = FALSE)
  }
  if (length(unique(demand$sectionID)) != 1L) {
    stop("One call must contain exactly one sectionID.", call. = FALSE)
  }
  if ("scenarioID" %in% names(demand)) {
    if (!is.character(demand$scenarioID) || any(is.na(demand$scenarioID)) ||
        any(!nzchar(demand$scenarioID))) {
      stop("demand.scenarioID must contain non-empty strings.",
           call. = FALSE)
    }
    ScenarioKey <- demand$scenarioID
  } else {
    ScenarioKey <- rep("", nrow(demand))
  }
  ConcurrentKey <- paste(
    ScenarioKey,
    demand$sectionID,
    demand$combinationID,
    demand$stageID,
    format(demand$thetaRad, digits = 17, scientific = TRUE),
    sep = "\r"
  )
  if (anyDuplicated(ConcurrentKey)) {
    stop(
      paste(
        "Each scenarioID, sectionID, combinationID, stageID and thetaRad key must",
        "identify one concurrent demand row."
      ),
      call. = FALSE
    )
  }
  AllowedForceEffectStatus <- c(
    "asd-required", "lrfd-factored", "unfactored-reference-state"
  )
  if (any(!(demand$forceEffectStatus %in% AllowedForceEffectStatus))) {
    stop("demand.forceEffectStatus is not recognized.", call. = FALSE)
  }
  if (any(!(demand$resultantConcurrencyStatus %in%
      c("satisfied", "unknown", "not-satisfied")))) {
    stop("demand.resultantConcurrencyStatus is not recognized.",
         call. = FALSE)
  }
  if (any(!(demand$localizedReactionStatus %in%
      c("absent-demonstrated", "present", "unknown")))) {
    stop("demand.localizedReactionStatus is not recognized.", call. = FALSE)
  }
  if (!is.numeric(demand$localizedReactionValue) ||
      !is.numeric(demand$localizedMomentValue)) {
    stop("Localized demand values must be numeric.", call. = FALSE)
  }
  Present <- demand$localizedReactionStatus == "present"
  if (any(Present & (
    !is.finite(demand$localizedReactionValue) |
      demand$localizedReactionValue < 0 |
      !is.finite(demand$localizedMomentValue)
  ))) {
    stop("A present localized reaction requires finite demand values.",
         call. = FALSE)
  }
  LocalizedText <- c(
    "localizedReactionUnit", "localizedReactionWidthBasisID",
    "localizedReactionEvidenceLocator", "localizedMomentUnit",
    "localizedDemandEvidenceLocator"
  )
  LocalizedTextOK <- vapply(seq_len(nrow(demand)), function(i) {
    all(vapply(
      demand[i, LocalizedText, drop = FALSE],
      function(value) is.character(value) && length(value) == 1L &&
        !is.na(value) && nzchar(value),
      logical(1)
    ))
  }, logical(1))
  if (any(Present & !LocalizedTextOK)) {
    stop("A present localized reaction requires units, basis and evidence.",
         call. = FALSE)
  }
  demand
}

.validateAisiSettings <- function(settings) {
  Settings <- .aisiRequireNamedList(settings, "settings")
  Required <- c(
    "standardID", "jurisdictionID", "designMethodID",
    "loadCombinationBasisID", "demandBasisID", "editionAdoptionStatus",
    "evaluationPurposeID", "widthBasisID", "axialZeroToleranceKnPerM",
    "momentZeroToleranceKnMPerM", "shearZeroToleranceKnPerM",
    "angleToleranceDeg"
  )
  .aisiRequireFields(Settings, Required, "settings")
  for (Field in Required[seq_len(8L)]) {
    .aisiTextScalar(Settings[[Field]], paste0("settings.", Field))
  }
  NumericFields <- Required[9:12]
  for (Field in NumericFields) {
    .aisiFiniteScalar(
      Settings[[Field]],
      paste0("settings.", Field),
      minimum = 0
    )
  }

  if (Settings$standardID != "ANSI-SDI-AISI-S100-24") {
    stop("settings.standardID is not supported by this evaluator.",
         call. = FALSE)
  }
  if (!(Settings$jurisdictionID %in%
      c("US", "MX", "CA", "contractual-other"))) {
    stop("settings.jurisdictionID is not recognized.", call. = FALSE)
  }
  if (!(Settings$designMethodID %in% c("ASD", "LRFD", "LSD"))) {
    stop("settings.designMethodID is not recognized.", call. = FALSE)
  }
  if (!(Settings$demandBasisID %in% c(
    "asd-required", "lrfd-factored", "unfactored-reference-state"
  ))) {
    stop("settings.demandBasisID is not recognized.", call. = FALSE)
  }
  if (!(Settings$editionAdoptionStatus %in%
      c("satisfied", "unknown", "not-satisfied"))) {
    stop("settings.editionAdoptionStatus is not recognized.",
         call. = FALSE)
  }
  if (!(Settings$evaluationPurposeID %in%
      c("strength-check", "diagnostic-capacity-map"))) {
    stop("settings.evaluationPurposeID is not recognized.",
         call. = FALSE)
  }
  if (Settings$widthBasisID != "per-projected-metre") {
    stop("settings.widthBasisID must be per-projected-metre.",
         call. = FALSE)
  }
  Settings
}

.validateAisiCapacities <- function(capacities) {
  if (!is.data.frame(capacities)) {
    stop("capacities must be one data frame.", call. = FALSE)
  }
  Required <- c(
    "sectionID", "capacityID", "capacityRoleID", "senseID",
    "nominalValue", "availableValue", "unit", "designMethodID",
    "widthBasisID",
    "capacityConsumerID", "capacityBasisID", "applicabilityStatus",
    "sourceLocator", "limitStateID", "sectionHoleStatus", "webHoleStatus",
    "netSectionBasisID", "capacityCoverageStatus",
    "capacityCoverageEvidenceLocator", "evidenceLocator"
  )
  .aisiRequireFields(capacities, Required, "capacities")
  if (nrow(capacities) == 0L) {
    return(capacities)
  }

  TextFields <- c(
    "sectionID", "capacityID", "capacityRoleID", "senseID", "unit",
    "designMethodID", "widthBasisID", "capacityConsumerID",
    "capacityBasisID", "applicabilityStatus", "sourceLocator",
    "limitStateID", "sectionHoleStatus", "webHoleStatus",
    "capacityCoverageStatus"
  )
  TextValid <- vapply(
    capacities[TextFields],
    function(value) is.character(value) && all(!is.na(value)) &&
      all(nzchar(value)),
    logical(1)
  )
  if (!all(TextValid)) {
    stop("Capacity identifiers and provenance must be non-empty strings.",
         call. = FALSE)
  }
  if (!is.numeric(capacities$availableValue) ||
      !is.numeric(capacities$nominalValue)) {
    stop("Capacity values must be numeric.", call. = FALSE)
  }
  if (anyDuplicated(capacities$capacityID)) {
    stop("capacities.capacityID values must be unique.", call. = FALSE)
  }
  if (any(!(capacities$capacityRoleID %in%
      c(
        "Ta", "Pa", "Ma", "Mat", "MaloH2", "Va",
        "MaloH3", "MnloH3", "RwcA", "RwcN"
      )))) {
    stop("capacities.capacityRoleID contains an unsupported role.",
         call. = FALSE)
  }
  if (any(!(capacities$senseID %in%
      c("positive", "negative", "both", "not-applicable")))) {
    stop("capacities.senseID contains an unsupported sense.",
         call. = FALSE)
  }
  if (any(!(capacities$designMethodID %in% c("ASD", "LRFD", "LSD")))) {
    stop("capacities.designMethodID contains an unsupported method.",
         call. = FALSE)
  }
  if (any(!(capacities$capacityConsumerID %in%
      c("general", "H1", "H2", "H3")))) {
    stop("capacities.capacityConsumerID contains an unsupported consumer.",
         call. = FALSE)
  }
  if (any(!(capacities$applicabilityStatus %in% c(
    "satisfied", "not-applicable", "unknown",
    "outside-prescriptive-scope", "invalid"
  )))) {
    stop("capacities.applicabilityStatus contains an unsupported state.",
         call. = FALSE)
  }
  if (any(!(capacities$capacityCoverageStatus %in% c(
    "satisfied", "not-applicable", "unknown",
    "outside-prescriptive-scope", "invalid"
  )))) {
    stop("capacities.capacityCoverageStatus contains an unsupported state.",
         call. = FALSE)
  }
  if (any(!(capacities$sectionHoleStatus %in%
      c("absent", "present", "unknown", "not-applicable")))) {
    stop("capacities.sectionHoleStatus contains an unsupported state.",
         call. = FALSE)
  }
  if (any(!(capacities$webHoleStatus %in%
      c("absent", "present", "unknown", "not-applicable")))) {
    stop("capacities.webHoleStatus contains an unsupported state.",
         call. = FALSE)
  }
  if (any(!(capacities$capacityBasisID %in%
      c("EWM", "DSM", "test", "rational-analysis", "certified")))) {
    stop("capacities.capacityBasisID contains an unsupported basis.",
         call. = FALSE)
  }
  Satisfied <- capacities$applicabilityStatus == "satisfied"
  AvailableRoles <- capacities$capacityRoleID %in% c(
    "Ta", "Pa", "Ma", "Mat", "MaloH2", "Va", "MaloH3", "RwcA"
  )
  NominalRoles <- capacities$capacityRoleID %in% c("MnloH3", "RwcN")
  if (any(Satisfied & AvailableRoles & (
    !is.finite(capacities$availableValue) |
      capacities$availableValue <= 0
  ))) {
    stop(
      paste(
        "Every satisfied capacity must have one finite, positive",
        "availableValue."
      ),
      call. = FALSE
    )
  }
  if (any(Satisfied & NominalRoles & (
    !is.finite(capacities$nominalValue) |
      capacities$nominalValue <= 0
  ))) {
    stop(
      paste(
        "Every satisfied nominal capacity must have one finite, positive",
        "nominalValue."
      ),
      call. = FALSE
    )
  }
  capacities
}

.validateAisiApplicability <- function(applicability) {
  .aisiRequireNamedList(applicability, "applicability")
}

.aisiReadApplicability <- function(
  applicability,
  field,
  allowed,
  required = TRUE
) {
  Value <- applicability[[field, exact = TRUE]]
  if (is.null(Value)) {
    if (required) {
      return(list(
        ok = FALSE,
        status = "blocked",
        applicabilityStatus = "unknown",
        reasonCode = paste0("missing-applicability-", field)
      ))
    }
    return(list(ok = TRUE, value = NA_character_))
  }
  if (!is.character(Value) || length(Value) != 1L || !nzchar(Value) ||
      !(Value %in% allowed)) {
    return(list(
      ok = FALSE,
      status = "invalid",
      applicabilityStatus = "invalid",
      reasonCode = paste0("invalid-applicability-", field)
    ))
  }
  list(ok = TRUE, value = Value)
}

.aisiStatusEvidenceGate <- function(
  applicability,
  statusField,
  evidenceField,
  allowed = c(
    "satisfied", "unknown", "not-satisfied", "outside-prescriptive-scope"
  )
) {
  Status <- .aisiReadApplicability(
    applicability,
    statusField,
    allowed
  )
  if (!Status$ok || Status$value != "satisfied") {
    return(list(
      ok = FALSE,
      status = if (!Status$ok) Status$status else "blocked",
      applicabilityStatus = if (!Status$ok) {
        Status$applicabilityStatus
      } else {
        .aisiGateApplicabilityStatus(Status$value)
      },
      reasonCode = if (!Status$ok) {
        Status$reasonCode
      } else {
        paste0(statusField, "-not-resolved")
      }
    ))
  }
  Evidence <- applicability[[evidenceField, exact = TRUE]]
  if (!.aisiTextAvailable(Evidence)) {
    return(list(
      ok = FALSE,
      status = "invalid",
      applicabilityStatus = "invalid",
      reasonCode = paste0("missing-applicability-", evidenceField)
    ))
  }
  list(ok = TRUE, evidenceLocator = Evidence)
}

.aisiNamedEvidenceGate <- function(
  applicability,
  statusField,
  evidenceField,
  requiredNames
) {
  Status <- applicability[[statusField, exact = TRUE]]
  Evidence <- applicability[[evidenceField, exact = TRUE]]
  if (!is.character(Status) || is.null(names(Status)) ||
      !identical(sort(names(Status)), sort(requiredNames))) {
    return(list(
      ok = FALSE,
      status = "invalid",
      applicabilityStatus = "invalid",
      reasonCode = paste0("invalid-applicability-", statusField)
    ))
  }
  if (!is.character(Evidence) || is.null(names(Evidence)) ||
      !identical(sort(names(Evidence)), sort(requiredNames))) {
    return(list(
      ok = FALSE,
      status = "invalid",
      applicabilityStatus = "invalid",
      reasonCode = paste0("invalid-applicability-", evidenceField)
    ))
  }
  Status <- Status[requiredNames]
  Evidence <- Evidence[requiredNames]
  if (any(!(Status %in% c(
    "satisfied", "unknown", "not-satisfied", "outside-prescriptive-scope"
  )))) {
    return(list(
      ok = FALSE,
      status = "invalid",
      applicabilityStatus = "invalid",
      reasonCode = paste0("invalid-applicability-", statusField)
    ))
  }
  if (any(Status == "not-satisfied") ||
      any(Status == "outside-prescriptive-scope")) {
    return(list(
      ok = FALSE,
      status = "blocked",
      applicabilityStatus = "outside-prescriptive-scope",
      reasonCode = paste0(statusField, "-outside-prescriptive-scope")
    ))
  }
  if (any(Status == "unknown")) {
    return(list(
      ok = FALSE,
      status = "blocked",
      applicabilityStatus = "unknown",
      reasonCode = paste0(statusField, "-unknown")
    ))
  }
  if (any(is.na(Evidence)) || any(!nzchar(Evidence))) {
    return(list(
      ok = FALSE,
      status = "invalid",
      applicabilityStatus = "invalid",
      reasonCode = paste0("missing-applicability-", evidenceField)
    ))
  }
  list(ok = TRUE, evidenceLocator = paste(Evidence, collapse = " | "))
}

.aisiEligibility <- function(settings, forceEffectStatus) {
  MethodID <- settings$designMethodID
  DemandBasisID <- settings$demandBasisID
  JurisdictionID <- settings$jurisdictionID

  if (MethodID == "LSD") {
    return(list(
      proceed = FALSE,
      evaluationStatus = "blocked",
      applicabilityStatus = "unknown",
      reasonCode = "unsupported-design-method-LSD",
      verdictEligibilityStatus = "not-satisfied",
      normativeEligible = FALSE
    ))
  }
  if (JurisdictionID == "CA") {
    return(list(
      proceed = FALSE,
      evaluationStatus = "invalid",
      applicabilityStatus = "invalid",
      reasonCode = "invalid-jurisdiction-design-method-pair",
      verdictEligibilityStatus = "not-satisfied",
      normativeEligible = FALSE
    ))
  }
  ExpectedBasisID <- if (MethodID == "ASD") {
    "asd-required"
  } else {
    "lrfd-factored"
  }
  if (DemandBasisID != ExpectedBasisID &&
      DemandBasisID != "unfactored-reference-state") {
    return(list(
      proceed = FALSE,
      evaluationStatus = "invalid",
      applicabilityStatus = "invalid",
      reasonCode = "incompatible-design-method-and-demand-basis",
      verdictEligibilityStatus = "not-satisfied",
      normativeEligible = FALSE
    ))
  }
  ExpectedForceEffectStatus <- switch(
    DemandBasisID,
    "asd-required" = "asd-required",
    "lrfd-factored" = "lrfd-factored",
    "unfactored-reference-state" = "unfactored-reference-state"
  )
  if (length(forceEffectStatus) != 1L ||
      forceEffectStatus != ExpectedForceEffectStatus) {
    return(list(
      proceed = FALSE,
      evaluationStatus = "invalid",
      applicabilityStatus = "invalid",
      reasonCode = "incompatible-force-effect-and-demand-basis",
      verdictEligibilityStatus = "not-satisfied",
      normativeEligible = FALSE
    ))
  }

  Diagnostic <- DemandBasisID == "unfactored-reference-state" ||
    settings$editionAdoptionStatus != "satisfied"
  if (Diagnostic && settings$evaluationPurposeID !=
      "diagnostic-capacity-map") {
    return(list(
      proceed = FALSE,
      evaluationStatus = "invalid",
      applicabilityStatus = "invalid",
      reasonCode = "incompatible-evaluation-purpose",
      verdictEligibilityStatus = "not-satisfied",
      normativeEligible = FALSE
    ))
  }
  if (!Diagnostic && settings$evaluationPurposeID != "strength-check") {
    return(list(
      proceed = FALSE,
      evaluationStatus = "invalid",
      applicabilityStatus = "invalid",
      reasonCode = "incompatible-evaluation-purpose",
      verdictEligibilityStatus = "not-satisfied",
      normativeEligible = FALSE
    ))
  }
  list(
    proceed = TRUE,
    evaluationStatus = if (Diagnostic) "diagnostic-only" else NA_character_,
    applicabilityStatus = "satisfied",
    reasonCode = if (Diagnostic) {
      "normative-verdict-not-eligible"
    } else {
      NA_character_
    },
    verdictEligibilityStatus = if (Diagnostic) {
      "not-satisfied"
    } else {
      "satisfied"
    },
    normativeEligible = !Diagnostic
  )
}

.aisiSenseID <- function(value, tolerance) {
  if (value > tolerance) {
    "positive"
  } else if (value < -tolerance) {
    "negative"
  } else {
    "not-applicable"
  }
}

.aisiGateApplicabilityStatus <- function(value) {
  if (value %in% c("outside-prescriptive-scope", "not-satisfied")) {
    "outside-prescriptive-scope"
  } else if (identical(value, "satisfied")) {
    "satisfied"
  } else {
    "unknown"
  }
}

.aisiTextAvailable <- function(value) {
  is.character(value) && length(value) == 1L && !is.na(value) && nzchar(value)
}

.aisiConcurrencyGate <- function(demandRow) {
  Status <- demandRow$resultantConcurrencyStatus
  Evidence <- demandRow$resultantConcurrencyEvidenceLocator
  if (Status == "satisfied" && .aisiTextAvailable(Evidence)) {
    return(list(ok = TRUE, evidenceLocator = Evidence))
  }
  if (Status == "not-satisfied") {
    return(list(
      ok = FALSE,
      status = "invalid",
      applicabilityStatus = "invalid",
      reasonCode = "resultant-concurrency-not-satisfied",
      evidenceLocator = if (.aisiTextAvailable(Evidence)) Evidence else NA_character_
    ))
  }
  list(
    ok = FALSE,
    status = "blocked",
    applicabilityStatus = "unknown",
    reasonCode = "resultant-concurrency-unknown",
    evidenceLocator = if (.aisiTextAvailable(Evidence)) Evidence else NA_character_
  )
}

.resolveAisiCapacity <- function(
  capacities,
  sectionID,
  roleID,
  senseID,
  consumerID,
  expectedUnit,
  settings,
  applicability,
  expectedWidthBasisID = settings$widthBasisID,
  valueField = "availableValue"
) {
  Candidates.role <- capacities[
    capacities$sectionID == sectionID &
      capacities$capacityRoleID == roleID,
    ,
    drop = FALSE
  ]
  if (nrow(Candidates.role) == 0L) {
    return(list(
      ok = FALSE,
      status = "blocked",
      applicabilityStatus = "unknown",
      reasonCode = paste0("missing-capacity-", roleID)
    ))
  }

  SenseAccepted <- if (senseID == "not-applicable") {
    c("not-applicable", "both")
  } else {
    c(senseID, "both")
  }
  Candidates.sense <- Candidates.role[
    Candidates.role$senseID %in% SenseAccepted,
    ,
    drop = FALSE
  ]
  if (nrow(Candidates.sense) == 0L) {
    return(list(
      ok = FALSE,
      status = "blocked",
      applicabilityStatus = "unknown",
      reasonCode = paste0("missing-capacity-sense-", roleID, "-", senseID)
    ))
  }
  if (senseID %in% c("positive", "negative") &&
      any(Candidates.sense$senseID == senseID)) {
    Candidates.sense <- Candidates.sense[
      Candidates.sense$senseID == senseID,
      ,
      drop = FALSE
    ]
  }

  Candidates.consumer <- Candidates.sense[
    Candidates.sense$capacityConsumerID == consumerID,
    ,
    drop = FALSE
  ]
  if (nrow(Candidates.consumer) == 0L) {
    return(list(
      ok = FALSE,
      status = "blocked",
      applicabilityStatus = "unknown",
      reasonCode = paste0("missing-capacity-consumer-", roleID, "-", consumerID)
    ))
  }
  Candidates.method <- Candidates.consumer[
    Candidates.consumer$designMethodID == settings$designMethodID,
    ,
    drop = FALSE
  ]
  if (nrow(Candidates.method) == 0L) {
    return(list(
      ok = FALSE,
      status = "invalid",
      applicabilityStatus = "invalid",
      reasonCode = paste0("capacity-design-method-mismatch-", roleID)
    ))
  }
  Candidates.width <- Candidates.method[
    Candidates.method$widthBasisID == expectedWidthBasisID,
    ,
    drop = FALSE
  ]
  if (nrow(Candidates.width) == 0L) {
    return(list(
      ok = FALSE,
      status = "invalid",
      applicabilityStatus = "invalid",
      reasonCode = paste0("capacity-width-basis-mismatch-", roleID)
    ))
  }
  if (nrow(Candidates.width) != 1L) {
    return(list(
      ok = FALSE,
      status = "invalid",
      applicabilityStatus = "invalid",
      reasonCode = paste0("ambiguous-capacity-", roleID)
    ))
  }

  Capacity <- Candidates.width[1L, , drop = FALSE]
  if (Capacity$unit != expectedUnit) {
    return(list(
      ok = FALSE,
      status = "invalid",
      applicabilityStatus = "invalid",
      reasonCode = paste0("capacity-unit-mismatch-", roleID)
    ))
  }
  if (Capacity$applicabilityStatus == "invalid") {
    return(list(
      ok = FALSE,
      status = "invalid",
      applicabilityStatus = "invalid",
      reasonCode = paste0("invalid-capacity-applicability-", roleID)
    ))
  }
  if (Capacity$applicabilityStatus == "not-applicable") {
    return(list(
      ok = FALSE,
      status = "invalid",
      applicabilityStatus = "invalid",
      reasonCode = "required-capacity-marked-not-applicable"
    ))
  }
  if (Capacity$applicabilityStatus != "satisfied") {
    return(list(
      ok = FALSE,
      status = "blocked",
      applicabilityStatus = Capacity$applicabilityStatus,
      reasonCode = paste0(
        "capacity-applicability-", roleID, "-",
        Capacity$applicabilityStatus
      )
    ))
  }
  if (Capacity$capacityCoverageStatus == "invalid") {
    return(list(
      ok = FALSE,
      status = "invalid",
      applicabilityStatus = "invalid",
      reasonCode = paste0("invalid-capacity-coverage-", roleID)
    ))
  }
  if (Capacity$capacityCoverageStatus == "not-applicable") {
    return(list(
      ok = FALSE,
      status = "invalid",
      applicabilityStatus = "invalid",
      reasonCode = paste0("required-capacity-coverage-not-applicable-", roleID)
    ))
  }
  if (Capacity$capacityCoverageStatus != "satisfied") {
    return(list(
      ok = FALSE,
      status = "blocked",
      applicabilityStatus = Capacity$capacityCoverageStatus,
      reasonCode = paste0(
        "capacity-coverage-", roleID, "-", Capacity$capacityCoverageStatus
      )
    ))
  }
  if (!.aisiTextAvailable(Capacity$capacityCoverageEvidenceLocator)) {
    return(list(
      ok = FALSE,
      status = "invalid",
      applicabilityStatus = "invalid",
      reasonCode = paste0("missing-capacity-coverage-evidence-", roleID)
    ))
  }
  if (Capacity$capacityBasisID %in% c("EWM", "DSM")) {
    B4 <- .aisiReadApplicability(
      applicability,
      "b4Status",
      c("satisfied", "unknown", "not-satisfied", "outside-prescriptive-scope")
    )
    B4Evidence <- applicability[["b4EvidenceLocator", exact = TRUE]]
    if (!B4$ok || B4$value != "satisfied") {
      return(list(
        ok = FALSE,
        status = if (!B4$ok) B4$status else "blocked",
        applicabilityStatus = if (!B4$ok) {
          B4$applicabilityStatus
        } else {
          .aisiGateApplicabilityStatus(B4$value)
        },
        reasonCode = if (!B4$ok) B4$reasonCode else "b4-not-resolved"
      ))
    }
    if (!.aisiTextAvailable(B4Evidence)) {
      return(list(
        ok = FALSE,
        status = "invalid",
        applicabilityStatus = "invalid",
        reasonCode = "missing-b4-evidence"
      ))
    }
  }
  AxialFlexure <- roleID %in% c(
    "Ta", "Pa", "Ma", "Mat", "MaloH2", "MaloH3", "MnloH3"
  )
  ShearBearing <- roleID %in% c("Va", "RwcA", "RwcN")
  if (AxialFlexure && Capacity$sectionHoleStatus == "unknown") {
    return(list(
      ok = FALSE,
      status = "blocked",
      applicabilityStatus = "unknown",
      reasonCode = paste0("section-hole-status-unknown-", roleID)
    ))
  }
  if (AxialFlexure && Capacity$sectionHoleStatus == "not-applicable") {
    return(list(
      ok = FALSE,
      status = "invalid",
      applicabilityStatus = "invalid",
      reasonCode = paste0("invalid-section-hole-status-", roleID)
    ))
  }
  if (AxialFlexure && Capacity$sectionHoleStatus == "present" &&
      (!.aisiTextAvailable(Capacity$netSectionBasisID) ||
        !.aisiTextAvailable(Capacity$evidenceLocator))) {
    return(list(
      ok = FALSE,
      status = "blocked",
      applicabilityStatus = "unknown",
      reasonCode = paste0("net-section-not-resolved-", roleID)
    ))
  }
  if (ShearBearing && Capacity$webHoleStatus == "unknown") {
    return(list(
      ok = FALSE,
      status = "blocked",
      applicabilityStatus = "unknown",
      reasonCode = paste0("web-hole-status-unknown-", roleID)
    ))
  }
  if (ShearBearing && Capacity$webHoleStatus == "not-applicable") {
    return(list(
      ok = FALSE,
      status = "invalid",
      applicabilityStatus = "invalid",
      reasonCode = paste0("invalid-web-hole-status-", roleID)
    ))
  }
  if (ShearBearing) {
    RouteField <- if (roleID == "Va") {
      "shearRouteID"
    } else {
      "localizedReactionRouteID"
    }
    RouteID <- applicability[[RouteField, exact = TRUE]]
    if (!.aisiTextAvailable(RouteID)) {
      return(list(
        ok = FALSE,
        status = "blocked",
        applicabilityStatus = "unknown",
        reasonCode = paste0("missing-applicability-", RouteField)
      ))
    }
    AbsentRoutes <- c("G2-no-hole", "G5-no-hole")
    PresentRoutes <- c("G3-qualified-hole", "G6-qualified-hole")
    if (RouteID %in% AbsentRoutes && Capacity$webHoleStatus != "absent") {
      return(list(
        ok = FALSE,
        status = "blocked",
        applicabilityStatus = "outside-prescriptive-scope",
        reasonCode = paste0("capacity-hole-route-mismatch-", roleID)
      ))
    }
    if (RouteID %in% PresentRoutes && Capacity$webHoleStatus != "present") {
      return(list(
        ok = FALSE,
        status = "blocked",
        applicabilityStatus = "outside-prescriptive-scope",
        reasonCode = paste0("capacity-hole-route-mismatch-", roleID)
      ))
    }
    if (RouteID == "accepted-alternative" &&
        Capacity$capacityBasisID %in% c("EWM", "DSM")) {
      return(list(
        ok = FALSE,
        status = "invalid",
        applicabilityStatus = "invalid",
        reasonCode = paste0("invalid-alternative-capacity-basis-", roleID)
      ))
    }
  }
  if (!(valueField %in% c("availableValue", "nominalValue")) ||
      !is.finite(Capacity[[valueField]]) || Capacity[[valueField]] <= 0) {
    return(list(
      ok = FALSE,
      status = "invalid",
      applicabilityStatus = "invalid",
      reasonCode = paste0("invalid-capacity-value-", roleID)
    ))
  }
  list(ok = TRUE, capacity = Capacity)
}

.resolveAisiCapacitySet <- function(
  capacities,
  sectionID,
  requests,
  settings,
  applicability,
  expectedWidthBasisID = settings$widthBasisID
) {
  Resolved <- lapply(seq_len(nrow(requests)), function(index) {
    .resolveAisiCapacity(
      capacities = capacities,
      sectionID = sectionID,
      roleID = requests$capacityRoleID[index],
      senseID = requests$senseID[index],
      consumerID = requests$capacityConsumerID[index],
      expectedUnit = requests$unit[index],
      settings = settings,
      applicability = applicability,
      expectedWidthBasisID = expectedWidthBasisID,
      valueField = if ("valueField" %in% names(requests)) {
        requests$valueField[index]
      } else {
        "availableValue"
      }
    )
  })
  Failed <- which(!vapply(Resolved, function(item) item$ok, logical(1)))
  if (length(Failed) > 0L) {
    Failure <- Resolved[[Failed[1L]]]
    return(Failure)
  }
  Rows <- do.call(rbind, lapply(Resolved, `[[`, "capacity"))
  if (length(unique(Rows$capacityBasisID)) != 1L) {
    return(list(
      ok = FALSE,
      status = "invalid",
      applicabilityStatus = "invalid",
      reasonCode = "mixed-capacity-basis-within-equation"
    ))
  }
  list(ok = TRUE, capacities = Rows)
}

.newAisiCheck <- function(
  demandRow,
  demandRowID,
  checkToken,
  checkFamilyID,
  clauseID,
  equationValue,
  equationLimit,
  applicabilityStatus,
  evaluationStatus,
  complete,
  reasonCode,
  settings,
  eligibility,
  capacityBasisID = NA_character_,
  evidenceLocator = NA_character_
) {
  FiniteEquation <- is.numeric(equationValue) &&
    length(equationValue) == 1L && is.finite(equationValue)
  NormalizedValue <- if (FiniteEquation && is.finite(equationLimit) &&
      equationLimit > 0) {
    equationValue / equationLimit
  } else {
    NA_real_
  }
  LimitStatus <- if (!FiniteEquation) {
    "not-evaluated"
  } else if (equationValue <= equationLimit) {
    "within-limit"
  } else {
    "exceeds-limit"
  }
  ScenarioID <- if ("scenarioID" %in% names(demandRow)) {
    demandRow$scenarioID
  } else {
    NA_character_
  }

  data.frame(
    demandRowID = as.integer(demandRowID),
    scenarioID = ScenarioID,
    sectionID = demandRow$sectionID,
    combinationID = demandRow$combinationID,
    stageID = demandRow$stageID,
    thetaRad = demandRow$thetaRad,
    thetaDeg = demandRow$thetaDeg,
    normalForceKnPerM = demandRow$normalForceKnPerM,
    bendingMomentKnMPerM = demandRow$bendingMomentKnMPerM,
    shearForceKnPerM = demandRow$shearForceKnPerM,
    checkID = paste0("row-", demandRowID, "-", checkToken),
    checkFamilyID = checkFamilyID,
    clauseID = clauseID,
    equationValue = if (FiniteEquation) equationValue else NA_real_,
    equationLimit = equationLimit,
    normalizedCheckValue = NormalizedValue,
    limitStatus = LimitStatus,
    applicabilityStatus = applicabilityStatus,
    evaluationStatus = evaluationStatus,
    complete = complete,
    reasonCode = reasonCode,
    evidenceLocator = evidenceLocator,
    designMethodID = settings$designMethodID,
    demandBasisID = settings$demandBasisID,
    forceEffectStatus = demandRow$forceEffectStatus,
    widthBasisID = settings$widthBasisID,
    capacityBasisID = capacityBasisID,
    standardID = settings$standardID,
    verdictEligibilityStatus = eligibility$verdictEligibilityStatus,
    evaluationPurposeID = settings$evaluationPurposeID,
    sourceLocator = paste0("ANSI/SDI AISI S100-2024 ", clauseID),
    stringsAsFactors = FALSE
  )
}

.computedAisiCheck <- function(
  demandRow,
  demandRowID,
  checkToken,
  checkFamilyID,
  clauseID,
  equationValue,
  equationLimit,
  settings,
  eligibility,
  capacityBasisID,
  evidenceLocator = NA_character_
) {
  WithinLimit <- equationValue <= equationLimit
  if (eligibility$normativeEligible) {
    EvaluationStatus <- if (WithinLimit) "pass" else "fail"
    Complete <- TRUE
    ReasonCode <- NA_character_
  } else {
    EvaluationStatus <- "diagnostic-only"
    Complete <- FALSE
    ReasonCode <- eligibility$reasonCode
  }
  .newAisiCheck(
    demandRow = demandRow,
    demandRowID = demandRowID,
    checkToken = checkToken,
    checkFamilyID = checkFamilyID,
    clauseID = clauseID,
    equationValue = equationValue,
    equationLimit = equationLimit,
    applicabilityStatus = "satisfied",
    evaluationStatus = EvaluationStatus,
    complete = Complete,
    reasonCode = ReasonCode,
    settings = settings,
    eligibility = eligibility,
    capacityBasisID = capacityBasisID,
    evidenceLocator = evidenceLocator
  )
}

.unresolvedAisiCheck <- function(
  demandRow,
  demandRowID,
  checkToken,
  checkFamilyID,
  clauseID,
  status,
  applicabilityStatus,
  reasonCode,
  settings,
  eligibility,
  equationLimit = 1,
  evidenceLocator = NA_character_
) {
  .newAisiCheck(
    demandRow = demandRow,
    demandRowID = demandRowID,
    checkToken = checkToken,
    checkFamilyID = checkFamilyID,
    clauseID = clauseID,
    equationValue = NA_real_,
    equationLimit = equationLimit,
    applicabilityStatus = applicabilityStatus,
    evaluationStatus = status,
    complete = status %in% c(
      "not-applicable", "not-required-by-threshold",
      "not-required-by-exception"
    ),
    reasonCode = reasonCode,
    settings = settings,
    eligibility = eligibility,
    evidenceLocator = evidenceLocator
  )
}

.aisiCapacityUsage <- function(capacitySet, demandRowID, checkID) {
  if (is.null(capacitySet) || nrow(capacitySet) == 0L) {
    return(data.frame())
  }
  data.frame(
    demandRowID = as.integer(demandRowID),
    checkID = checkID,
    capacityRoleID = capacitySet$capacityRoleID,
    capacityID = capacitySet$capacityID,
    senseID = capacitySet$senseID,
    nominalValue = capacitySet$nominalValue,
    availableValue = capacitySet$availableValue,
    unit = capacitySet$unit,
    designMethodID = capacitySet$designMethodID,
    widthBasisID = capacitySet$widthBasisID,
    capacityConsumerID = capacitySet$capacityConsumerID,
    capacityBasisID = capacitySet$capacityBasisID,
    limitStateID = capacitySet$limitStateID,
    applicabilityStatus = capacitySet$applicabilityStatus,
    sectionHoleStatus = capacitySet$sectionHoleStatus,
    webHoleStatus = capacitySet$webHoleStatus,
    netSectionBasisID = capacitySet$netSectionBasisID,
    capacityCoverageStatus = capacitySet$capacityCoverageStatus,
    capacityCoverageEvidenceLocator =
      capacitySet$capacityCoverageEvidenceLocator,
    evidenceLocator = capacitySet$evidenceLocator,
    sourceLocator = capacitySet$sourceLocator,
    stringsAsFactors = FALSE
  )
}

.evaluateAisiH1 <- function(
  demandRow,
  demandRowID,
  capacities,
  applicability,
  settings,
  eligibility
) {
  N <- demandRow$normalForceKnPerM
  M <- demandRow$bendingMomentKnMPerM
  ActiveN <- abs(N) > settings$axialZeroToleranceKnPerM
  ActiveM <- abs(M) > settings$momentZeroToleranceKnMPerM
  MomentSenseID <- .aisiSenseID(
    M,
    settings$momentZeroToleranceKnMPerM
  )
  Checks <- list()
  Usage <- list()

  addCheck <- function(check, capacitySet = NULL) {
    Index <- length(Checks) + 1L
    Checks[[Index]] <<- check
    Usage[[Index]] <<- .aisiCapacityUsage(
      capacitySet,
      demandRowID,
      check$checkID
    )
    invisible(NULL)
  }

  addResolvedCheck <- function(
    requests,
    token,
    familyID,
    clauseID,
    equationFunction,
    equationLimit = 1,
    evidenceLocator = NA_character_
  ) {
    Resolved <- .resolveAisiCapacitySet(
      capacities = capacities,
      sectionID = demandRow$sectionID,
      requests = requests,
      settings = settings,
      applicability = applicability
    )
    if (!Resolved$ok) {
      addCheck(.unresolvedAisiCheck(
        demandRow, demandRowID, token, familyID, clauseID,
        Resolved$status, Resolved$applicabilityStatus,
        Resolved$reasonCode, settings, eligibility, equationLimit
      ))
      return(invisible(NULL))
    }
    CapacitySet <- Resolved$capacities
    Values <- setNames(
      CapacitySet$availableValue,
      CapacitySet$capacityRoleID
    )
    EquationValue <- equationFunction(Values)
    Check <- .computedAisiCheck(
      demandRow, demandRowID, token, familyID, clauseID,
      EquationValue, equationLimit, settings, eligibility,
      unique(CapacitySet$capacityBasisID), evidenceLocator
    )
    addCheck(Check, CapacitySet)
    invisible(NULL)
  }

  if (!ActiveN && !ActiveM) {
    return(list(checks = data.frame(), capacityUsage = data.frame()))
  }

  if (N > settings$axialZeroToleranceKnPerM && ActiveM) {
    Requests.h11a <- data.frame(
      capacityRoleID = c("Ta", "Mat"),
      senseID = c("not-applicable", MomentSenseID),
      capacityConsumerID = c("general", "H1"),
      unit = c("kN/m", "kN m/m"),
      stringsAsFactors = FALSE
    )
    addResolvedCheck(
      Requests.h11a,
      "H1.1-1",
      "H1",
      "Eq. H1.1-1",
      function(values) N / values[["Ta"]] + abs(M) / values[["Mat"]]
    )
    Requests.h11b <- data.frame(
      capacityRoleID = c("Ta", "Ma"),
      senseID = c("not-applicable", MomentSenseID),
      capacityConsumerID = c("general", "general"),
      unit = c("kN/m", "kN m/m"),
      stringsAsFactors = FALSE
    )
    addResolvedCheck(
      Requests.h11b,
      "H1.1-2",
      "H1",
      "Eq. H1.1-2",
      function(values) abs(M) / values[["Ma"]] - N / values[["Ta"]]
    )
  } else if (N > settings$axialZeroToleranceKnPerM) {
    Concentric <- .aisiReadApplicability(
      applicability,
      "concentricDemandStatus",
      c("satisfied", "unknown", "not-satisfied")
    )
    if (!Concentric$ok || Concentric$value != "satisfied") {
      Status <- if (!Concentric$ok) Concentric$status else "blocked"
      ApplicabilityStatus <- if (!Concentric$ok) {
        Concentric$applicabilityStatus
      } else {
        .aisiGateApplicabilityStatus(Concentric$value)
      }
      ReasonCode <- if (!Concentric$ok) {
        Concentric$reasonCode
      } else {
        "concentric-demand-not-demonstrated"
      }
      addCheck(.unresolvedAisiCheck(
        demandRow, demandRowID, "D-axial", "D", "Chapter D",
        Status, ApplicabilityStatus, ReasonCode, settings, eligibility
      ))
    } else {
      Evidence <- applicability[["concentricDemandEvidenceLocator", exact = TRUE]]
      if (!.aisiTextAvailable(Evidence)) {
        addCheck(.unresolvedAisiCheck(
          demandRow, demandRowID, "D-axial", "D", "Chapter D",
          "invalid", "invalid", "missing-concentric-demand-evidence",
          settings, eligibility
        ))
        return(list(
          checks = do.call(rbind, Checks),
          capacityUsage = data.frame()
        ))
      }
      Requests <- data.frame(
        capacityRoleID = "Ta",
        senseID = "not-applicable",
        capacityConsumerID = "general",
        unit = "kN/m",
        stringsAsFactors = FALSE
      )
      addResolvedCheck(
        Requests,
        "D-axial",
        "D",
        "Chapter D",
        function(values) N / values[["Ta"]],
        evidenceLocator = Evidence
      )
    }
  } else if (N < -settings$axialZeroToleranceKnPerM && ActiveM) {
    SectionClass <- .aisiReadApplicability(
      applicability,
      "sectionClassID",
      c(
        "general-uniaxial",
        "singly-symmetric-unstiffened-angle"
      )
    )
    if (!SectionClass$ok ||
        SectionClass$value == "singly-symmetric-unstiffened-angle") {
      Status <- if (!SectionClass$ok) SectionClass$status else "blocked"
      ApplicabilityStatus <- if (!SectionClass$ok) {
        SectionClass$applicabilityStatus
      } else {
        "unknown"
      }
      ReasonCode <- if (!SectionClass$ok) {
        SectionClass$reasonCode
      } else {
        "unsupported-section-class"
      }
      addCheck(.unresolvedAisiCheck(
        demandRow, demandRowID, "H1.2-1", "H1", "Eq. H1.2-1",
        Status, ApplicabilityStatus, ReasonCode, settings, eligibility
      ))
    } else {
      SecondOrder <- .aisiReadApplicability(
        applicability,
        "secondOrderStatus",
        c("satisfied", "documented-exception", "unknown", "not-satisfied")
      )
      if (!SecondOrder$ok ||
          !(SecondOrder$value %in% c("satisfied", "documented-exception"))) {
        Status <- if (!SecondOrder$ok) SecondOrder$status else "blocked"
        ApplicabilityStatus <- if (!SecondOrder$ok) {
          SecondOrder$applicabilityStatus
        } else {
          .aisiGateApplicabilityStatus(SecondOrder$value)
        }
        ReasonCode <- if (!SecondOrder$ok) {
          SecondOrder$reasonCode
        } else {
          "second-order-demand-not-resolved"
        }
        addCheck(.unresolvedAisiCheck(
          demandRow, demandRowID, "H1.2-1", "H1", "Eq. H1.2-1",
          Status, ApplicabilityStatus, ReasonCode, settings, eligibility
        ))
      } else {
        Evidence <- if (SecondOrder$value == "documented-exception") {
          applicability[["secondOrderEvidenceLocator", exact = TRUE]]
        } else {
          NA_character_
        }
        if (SecondOrder$value == "documented-exception" &&
            (!is.character(Evidence) || length(Evidence) != 1L ||
              !nzchar(Evidence))) {
          addCheck(.unresolvedAisiCheck(
            demandRow, demandRowID, "H1.2-1", "H1", "Eq. H1.2-1",
            "invalid", "invalid", "missing-second-order-exception-evidence",
            settings, eligibility
          ))
          return(list(
            checks = do.call(rbind, Checks),
            capacityUsage = data.frame()
          ))
        }
        Requests <- data.frame(
          capacityRoleID = c("Pa", "Ma"),
          senseID = c("not-applicable", MomentSenseID),
          capacityConsumerID = c("general", "general"),
          unit = c("kN/m", "kN m/m"),
          stringsAsFactors = FALSE
        )
        addResolvedCheck(
          Requests,
          "H1.2-1",
          "H1",
          "Eq. H1.2-1",
          function(values) -N / values[["Pa"]] + abs(M) / values[["Ma"]],
          evidenceLocator = Evidence
        )
      }
    }
  } else if (N < -settings$axialZeroToleranceKnPerM) {
    Concentric <- .aisiReadApplicability(
      applicability,
      "concentricDemandStatus",
      c("satisfied", "unknown", "not-satisfied")
    )
    if (!Concentric$ok || Concentric$value != "satisfied") {
      Status <- if (!Concentric$ok) Concentric$status else "blocked"
      ApplicabilityStatus <- if (!Concentric$ok) {
        Concentric$applicabilityStatus
      } else {
        .aisiGateApplicabilityStatus(Concentric$value)
      }
      ReasonCode <- if (!Concentric$ok) {
        Concentric$reasonCode
      } else {
        "concentric-demand-not-demonstrated"
      }
      addCheck(.unresolvedAisiCheck(
        demandRow, demandRowID, "E-axial", "E", "Chapter E",
        Status, ApplicabilityStatus, ReasonCode, settings, eligibility
      ))
    } else {
      Evidence <- applicability[["concentricDemandEvidenceLocator", exact = TRUE]]
      if (!.aisiTextAvailable(Evidence)) {
        addCheck(.unresolvedAisiCheck(
          demandRow, demandRowID, "E-axial", "E", "Chapter E",
          "invalid", "invalid", "missing-concentric-demand-evidence",
          settings, eligibility
        ))
        return(list(
          checks = do.call(rbind, Checks),
          capacityUsage = data.frame()
        ))
      }
      Requests <- data.frame(
        capacityRoleID = "Pa",
        senseID = "not-applicable",
        capacityConsumerID = "general",
        unit = "kN/m",
        stringsAsFactors = FALSE
      )
      addResolvedCheck(
        Requests,
        "E-axial",
        "E",
        "Chapter E",
        function(values) -N / values[["Pa"]],
        evidenceLocator = Evidence
      )
    }
  } else if (ActiveM) {
    Requests <- data.frame(
      capacityRoleID = "Ma",
      senseID = MomentSenseID,
      capacityConsumerID = "general",
      unit = "kN m/m",
      stringsAsFactors = FALSE
    )
    addResolvedCheck(
      Requests,
      "F-flexure",
      "F",
      "Chapter F",
      function(values) abs(M) / values[["Ma"]]
    )
  }

  Checks <- if (length(Checks) == 0L) {
    data.frame()
  } else {
    do.call(rbind, Checks)
  }
  Usage <- Filter(function(value) nrow(value) > 0L, Usage)
  Usage <- if (length(Usage) == 0L) {
    data.frame()
  } else {
    do.call(rbind, Usage)
  }
  list(checks = Checks, capacityUsage = Usage)
}

.aisiShearGate <- function(applicability) {
  Mapping <- .aisiReadApplicability(
    applicability,
    "shearMappingStatus",
    c("satisfied", "unknown", "not-satisfied", "outside-prescriptive-scope")
  )
  if (!Mapping$ok || Mapping$value != "satisfied") {
    return(list(
      ok = FALSE,
      status = if (!Mapping$ok) Mapping$status else "blocked",
      applicabilityStatus = if (!Mapping$ok) {
        Mapping$applicabilityStatus
      } else {
        .aisiGateApplicabilityStatus(Mapping$value)
      },
      reasonCode = if (!Mapping$ok) {
        Mapping$reasonCode
      } else {
        "shear-mapping-not-resolved"
      }
    ))
  }
  Route <- .aisiReadApplicability(
    applicability,
    "shearRouteID",
    c("G2-no-hole", "G3-qualified-hole", "accepted-alternative", "unknown")
  )
  RouteStatus <- .aisiReadApplicability(
    applicability,
    "shearRouteStatus",
    c("satisfied", "unknown", "not-satisfied", "outside-prescriptive-scope")
  )
  if (!Route$ok || !RouteStatus$ok || Route$value == "unknown" ||
      RouteStatus$value != "satisfied") {
    FirstFailure <- if (!Route$ok) Route else RouteStatus
    return(list(
      ok = FALSE,
      status = if (!FirstFailure$ok) FirstFailure$status else "blocked",
      applicabilityStatus = if (!FirstFailure$ok) {
        FirstFailure$applicabilityStatus
      } else {
        .aisiGateApplicabilityStatus(FirstFailure$value)
      },
      reasonCode = if (!FirstFailure$ok) {
        FirstFailure$reasonCode
      } else {
        "shear-capacity-route-not-resolved"
      }
    ))
  }
  RouteEvidence <- applicability[["shearRouteEvidenceLocator", exact = TRUE]]
  if (!.aisiTextAvailable(RouteEvidence)) {
    return(list(
      ok = FALSE,
      status = "invalid",
      applicabilityStatus = "invalid",
      reasonCode = "missing-shear-route-evidence"
    ))
  }
  if (Route$value %in% c("G2-no-hole", "G3-qualified-hole")) {
    for (Field in c("crossSectionSymmetryStatus", "shearInWebPlaneStatus")) {
      Gate <- .aisiReadApplicability(
        applicability,
        Field,
        c(
          "satisfied", "unknown", "not-satisfied",
          "outside-prescriptive-scope"
        )
      )
      if (!Gate$ok || Gate$value != "satisfied") {
        return(list(
          ok = FALSE,
          status = if (!Gate$ok) Gate$status else "blocked",
          applicabilityStatus = if (!Gate$ok) {
            Gate$applicabilityStatus
          } else {
            .aisiGateApplicabilityStatus(Gate$value)
          },
          reasonCode = if (!Gate$ok) {
            Gate$reasonCode
          } else {
            paste0(Field, "-not-resolved")
          }
        ))
      }
    }
  }
  if (Route$value == "G3-qualified-hole") {
    G3 <- .aisiNamedEvidenceGate(
      applicability = applicability,
      statusField = "g3LimitStatus",
      evidenceField = "g3LimitEvidenceLocator",
      requiredNames = c(
        "holeDepthRatio", "stiffenedAspectRatio", "holeLengthToSpacing",
        "holeAspectRatio", "midDepthLocation", "clearHoleSpacing",
        "midStiffenerSpacing", "cornerRadius"
      )
    )
    if (!G3$ok) {
      return(G3)
    }
  }
  list(
    ok = TRUE,
    routeID = Route$value,
    evidenceLocator = RouteEvidence
  )
}

.evaluateAisiH2 <- function(
  demandRow,
  demandRowID,
  capacities,
  applicability,
  settings,
  eligibility
) {
  M <- demandRow$bendingMomentKnMPerM
  Q <- demandRow$shearForceKnPerM
  ActiveM <- abs(M) > settings$momentZeroToleranceKnMPerM
  ActiveQ <- abs(Q) > settings$shearZeroToleranceKnPerM
  if (!ActiveQ) {
    return(list(checks = data.frame(), capacityUsage = data.frame()))
  }

  MomentSenseID <- .aisiSenseID(
    M,
    settings$momentZeroToleranceKnMPerM
  )
  ShearSenseID <- .aisiSenseID(Q, settings$shearZeroToleranceKnPerM)
  Checks <- list()
  Usage <- list()

  addCheck <- function(check, capacitySet = NULL) {
    Index <- length(Checks) + 1L
    Checks[[Index]] <<- check
    Usage[[Index]] <<- .aisiCapacityUsage(
      capacitySet,
      demandRowID,
      check$checkID
    )
    invisible(NULL)
  }
  addResolvedCheck <- function(
    requests,
    token,
    clauseID,
    equationFunction,
    equationLimit = 1
  ) {
    Resolved <- .resolveAisiCapacitySet(
      capacities = capacities,
      sectionID = demandRow$sectionID,
      requests = requests,
      settings = settings,
      applicability = applicability
    )
    if (!Resolved$ok) {
      addCheck(.unresolvedAisiCheck(
        demandRow, demandRowID, token, "H2", clauseID,
        Resolved$status, Resolved$applicabilityStatus,
        Resolved$reasonCode, settings, eligibility, equationLimit
      ))
      return(NULL)
    }
    CapacitySet <- Resolved$capacities
    Values <- setNames(
      CapacitySet$availableValue,
      CapacitySet$capacityRoleID
    )
    EquationValue <- equationFunction(Values)
    Check <- .computedAisiCheck(
      demandRow, demandRowID, token, "H2", clauseID,
      EquationValue, equationLimit, settings, eligibility,
      unique(CapacitySet$capacityBasisID)
    )
    addCheck(Check, CapacitySet)
    list(values = Values, capacities = CapacitySet)
  }

  ShearGate <- .aisiShearGate(applicability)
  if (ActiveM) {
    Requests.moment <- data.frame(
      capacityRoleID = "Ma",
      senseID = MomentSenseID,
      capacityConsumerID = "general",
      unit = "kN m/m",
      stringsAsFactors = FALSE
    )
    addResolvedCheck(
      Requests.moment,
      "H2-M",
      "Section H2 individual bending",
      function(values) abs(M) / values[["Ma"]]
    )
  }
  if (!ShearGate$ok) {
    addCheck(.unresolvedAisiCheck(
      demandRow, demandRowID, "H2-V", "H2",
      "Section H2 individual shear",
      ShearGate$status, ShearGate$applicabilityStatus,
      ShearGate$reasonCode, settings, eligibility
    ))
    if (ActiveM) {
      addCheck(.unresolvedAisiCheck(
        demandRow, demandRowID, "H2-interaction", "H2", "Section H2",
        ShearGate$status, ShearGate$applicabilityStatus,
        ShearGate$reasonCode, settings, eligibility
      ))
    }
  } else {
    Requests.shear <- data.frame(
      capacityRoleID = "Va",
      senseID = ShearSenseID,
      capacityConsumerID = "general",
      unit = "kN/m",
      stringsAsFactors = FALSE
    )
    addResolvedCheck(
      Requests.shear,
      "H2-V",
      "Section H2 individual shear",
      function(values) abs(Q) / values[["Va"]]
    )

    if (ActiveM) {
      Stiffener <- .aisiReadApplicability(
        applicability,
        "shearStiffenerStatus",
        c("absent", "g4-satisfied", "unknown")
      )
      G4 <- list(ok = TRUE)
      if (Stiffener$ok && Stiffener$value == "g4-satisfied") {
        G4 <- .aisiNamedEvidenceGate(
          applicability = applicability,
          statusField = "g4GateStatus",
          evidenceField = "g4GateEvidenceLocator",
          requiredNames = c(
            "strengthStiffness", "spacingLe2h",
            "flangeDistortionRestraint", "spanEndAttachment"
          )
        )
      }
      if (!Stiffener$ok || Stiffener$value == "unknown" || !G4$ok) {
        Gate <- if (!Stiffener$ok || Stiffener$value == "unknown") {
          list(
            status = if (!Stiffener$ok) Stiffener$status else "blocked",
            applicabilityStatus = if (!Stiffener$ok) {
              Stiffener$applicabilityStatus
            } else {
              "unknown"
            },
            reasonCode = if (!Stiffener$ok) {
              Stiffener$reasonCode
            } else {
              "shear-stiffener-status-not-resolved"
            }
          )
        } else {
          G4
        }
        addCheck(.unresolvedAisiCheck(
          demandRow, demandRowID, "H2-interaction", "H2", "Section H2",
          Gate$status,
          Gate$applicabilityStatus,
          Gate$reasonCode,
          settings,
          eligibility
        ))
      } else {
        Requests.interaction <- data.frame(
          capacityRoleID = c("MaloH2", "Va"),
          senseID = c(MomentSenseID, ShearSenseID),
          capacityConsumerID = c("H2", "general"),
          unit = c("kN m/m", "kN/m"),
          stringsAsFactors = FALSE
        )
        Resolved <- .resolveAisiCapacitySet(
          capacities = capacities,
          sectionID = demandRow$sectionID,
          requests = Requests.interaction,
          settings = settings,
          applicability = applicability
        )
        if (!Resolved$ok) {
          addCheck(.unresolvedAisiCheck(
            demandRow, demandRowID, "H2-interaction", "H2", "Section H2",
            Resolved$status, Resolved$applicabilityStatus,
            Resolved$reasonCode, settings, eligibility
          ))
        } else {
          CapacitySet <- Resolved$capacities
          Values <- setNames(
            CapacitySet$availableValue,
            CapacitySet$capacityRoleID
          )
          Ratio.moment <- abs(M) / Values[["MaloH2"]]
          Ratio.shear <- abs(Q) / Values[["Va"]]
          if (Stiffener$value == "absent") {
            EquationValue <- Ratio.moment^2 + Ratio.shear^2
            Check <- .computedAisiCheck(
              demandRow, demandRowID, "H2-1", "H2", "Eq. H2-1",
              EquationValue, 1, settings, eligibility,
              unique(CapacitySet$capacityBasisID)
            )
          } else if (Ratio.moment > 0.5 && Ratio.shear > 0.7) {
            EquationValue <- 0.6 * Ratio.moment + Ratio.shear
            Check <- .computedAisiCheck(
              demandRow, demandRowID, "H2-2", "H2", "Eq. H2-2",
              EquationValue, 1.3, settings, eligibility,
              unique(CapacitySet$capacityBasisID)
            )
          } else {
            Check <- .newAisiCheck(
              demandRow, demandRowID, "H2-2", "H2", "Eq. H2-2",
              0.6 * Ratio.moment + Ratio.shear,
              1.3,
              "satisfied",
              "not-required-by-threshold",
              TRUE,
              "strict-H2-2-threshold-not-exceeded",
              settings,
              eligibility,
              unique(CapacitySet$capacityBasisID)
            )
          }
          addCheck(Check, CapacitySet)
        }
      }
    }
  }

  UsedCapacityRows <- Filter(function(value) nrow(value) > 0L, Usage)
  if (length(UsedCapacityRows) > 0L &&
      length(unique(do.call(rbind, UsedCapacityRows)$capacityBasisID)) != 1L) {
    addCheck(
      .unresolvedAisiCheck(
        demandRow, demandRowID, "H2-capacity-basis", "H2", "Section H2",
        "invalid", "invalid", "mixed-capacity-basis-within-H2",
        settings, eligibility
      )
    )
  }
  Checks <- do.call(rbind, Checks)
  Usage <- Filter(function(value) nrow(value) > 0L, Usage)
  Usage <- if (length(Usage) == 0L) {
    data.frame()
  } else {
    do.call(rbind, Usage)
  }
  list(checks = Checks, capacityUsage = Usage)
}

.evaluateAisiH3 <- function(
  demandRow,
  demandRowID,
  capacities,
  applicability,
  settings,
  eligibility
) {
  ReactionStatus <- demandRow$localizedReactionStatus
  ReactionEvidence <- demandRow$localizedReactionEvidenceLocator
  if (ReactionStatus == "absent-demonstrated") {
    if (!.aisiTextAvailable(ReactionEvidence)) {
      return(list(
        checks = .unresolvedAisiCheck(
          demandRow, demandRowID, "H3-interface", "H3", "Section H3",
          "invalid", "invalid", "missing-localized-reaction-evidence",
          settings, eligibility
        ),
        capacityUsage = data.frame()
      ))
    }
    return(list(
      checks = .unresolvedAisiCheck(
        demandRow, demandRowID, "H3-interface", "H3", "Section H3",
        "not-applicable", "not-applicable",
        "localized-reaction-absence-demonstrated", settings, eligibility,
        evidenceLocator = ReactionEvidence
      ),
      capacityUsage = data.frame()
    ))
  }
  if (ReactionStatus == "unknown") {
    return(list(
      checks = .unresolvedAisiCheck(
        demandRow, demandRowID, "H3-interface", "H3", "Section H3",
        "blocked", "unknown", "localized-reaction-status-unknown",
        settings, eligibility
      ),
      capacityUsage = data.frame()
    ))
  }

  Route <- .aisiReadApplicability(
    applicability,
    "localizedReactionRouteID",
    c(
      "G5-no-hole", "G6-qualified-hole", "accepted-alternative", "unknown"
    )
  )
  RouteGate <- .aisiStatusEvidenceGate(
    applicability = applicability,
    statusField = "localizedReactionRouteStatus",
    evidenceField = "localizedReactionRouteEvidenceLocator"
  )
  if (!Route$ok || Route$value == "unknown" || !RouteGate$ok) {
    Gate <- if (!Route$ok || Route$value == "unknown") {
      list(
        status = if (!Route$ok) Route$status else "blocked",
        applicabilityStatus = if (!Route$ok) {
          Route$applicabilityStatus
        } else {
          "unknown"
        },
        reasonCode = if (!Route$ok) {
          Route$reasonCode
        } else {
          "localized-reaction-route-unknown"
        }
      )
    } else {
      RouteGate
    }
    return(list(
      checks = .unresolvedAisiCheck(
        demandRow, demandRowID, "H3-interface", "H3", "Section H3",
        Gate$status, Gate$applicabilityStatus, Gate$reasonCode,
        settings, eligibility
      ),
      capacityUsage = data.frame()
    ))
  }

  MomentValue <- demandRow$localizedMomentValue
  MomentSenseID <- .aisiSenseID(
    MomentValue,
    settings$momentZeroToleranceKnMPerM
  )
  if (demandRow$localizedReactionWidthBasisID == settings$widthBasisID &&
      abs(MomentValue - demandRow$bendingMomentKnMPerM) >
        settings$momentZeroToleranceKnMPerM) {
    return(list(
      checks = .unresolvedAisiCheck(
        demandRow, demandRowID, "H3-interface", "H3", "Section H3",
        "invalid", "invalid", "localized-moment-not-concurrent",
        settings, eligibility,
        evidenceLocator = demandRow$localizedDemandEvidenceLocator
      ),
      capacityUsage = data.frame()
    ))
  }

  Rwc <- demandRow$localizedReactionValue
  Mr <- abs(MomentValue)
  Checks <- list()
  Usage <- list()
  addCheck <- function(check, capacitySet) {
    Index <- length(Checks) + 1L
    Checks[[Index]] <<- check
    Usage[[Index]] <<- .aisiCapacityUsage(
      capacitySet,
      demandRowID,
      check$checkID
    )
    invisible(NULL)
  }
  resolveCapacity <- function(roleID, senseID, unit, valueField) {
    .resolveAisiCapacitySet(
      capacities = capacities,
      sectionID = demandRow$sectionID,
      requests = data.frame(
        capacityRoleID = roleID,
        senseID = senseID,
        capacityConsumerID = "H3",
        unit = unit,
        valueField = valueField,
        stringsAsFactors = FALSE
      ),
      settings = settings,
      applicability = applicability,
      expectedWidthBasisID = demandRow$localizedReactionWidthBasisID
    )
  }
  Resolved.rwcA <- resolveCapacity(
    "RwcA",
    "not-applicable",
    demandRow$localizedReactionUnit,
    "availableValue"
  )
  if (Resolved.rwcA$ok) {
    RwcA <- Resolved.rwcA$capacities
    addCheck(
      .computedAisiCheck(
        demandRow, demandRowID, "H3-Rwc", "H3",
        "Section H3 individual web crippling",
        Rwc / RwcA$availableValue, 1, settings, eligibility,
        RwcA$capacityBasisID,
        evidenceLocator = demandRow$localizedDemandEvidenceLocator
      ),
      RwcA
    )
  } else {
    addCheck(
      .unresolvedAisiCheck(
        demandRow, demandRowID, "H3-Rwc", "H3",
        "Section H3 individual web crippling",
        Resolved.rwcA$status, Resolved.rwcA$applicabilityStatus,
        Resolved.rwcA$reasonCode, settings, eligibility
      ),
      NULL
    )
  }
  Resolved.malo <- resolveCapacity(
    "MaloH3",
    MomentSenseID,
    demandRow$localizedMomentUnit,
    "availableValue"
  )
  if (Resolved.malo$ok) {
    Malo <- Resolved.malo$capacities
    addCheck(
      .computedAisiCheck(
        demandRow, demandRowID, "H3-M", "H3",
        "Section H3 individual bending",
        Mr / Malo$availableValue, 1, settings, eligibility,
        Malo$capacityBasisID,
        evidenceLocator = demandRow$localizedDemandEvidenceLocator
      ),
      Malo
    )
  } else {
    addCheck(
      .unresolvedAisiCheck(
        demandRow, demandRowID, "H3-M", "H3",
        "Section H3 individual bending",
        Resolved.malo$status, Resolved.malo$applicabilityStatus,
        Resolved.malo$reasonCode, settings, eligibility
      ),
      NULL
    )
  }

  Resolved.nominal <- .resolveAisiCapacitySet(
    capacities = capacities,
    sectionID = demandRow$sectionID,
    requests = data.frame(
      capacityRoleID = c("RwcN", "MnloH3"),
      senseID = c("not-applicable", MomentSenseID),
      capacityConsumerID = c("H3", "H3"),
      unit = c(
        demandRow$localizedReactionUnit,
        demandRow$localizedMomentUnit
      ),
      valueField = c("nominalValue", "nominalValue"),
      stringsAsFactors = FALSE
    ),
    settings = settings,
    applicability = applicability,
    expectedWidthBasisID = demandRow$localizedReactionWidthBasisID
  )
  if (!Resolved.nominal$ok) {
    addCheck(
      .unresolvedAisiCheck(
        demandRow, demandRowID, "H3-interaction", "H3", "Section H3",
        Resolved.nominal$status, Resolved.nominal$applicabilityStatus,
        Resolved.nominal$reasonCode, settings, eligibility
      ),
      NULL
    )
    Checks <- do.call(rbind, Checks)
    Usage <- Filter(function(value) nrow(value) > 0L, Usage)
    Usage <- if (length(Usage) == 0L) data.frame() else do.call(rbind, Usage)
    return(list(checks = Checks, capacityUsage = Usage))
  }
  RwcN <- Resolved.nominal$capacities[
    Resolved.nominal$capacities$capacityRoleID == "RwcN",
    ,
    drop = FALSE
  ]
  Mnlo <- Resolved.nominal$capacities[
    Resolved.nominal$capacities$capacityRoleID == "MnloH3",
    ,
    drop = FALSE
  ]
  AvailableRows <- Filter(
    function(value) is.list(value) && isTRUE(value$ok),
    list(Resolved.rwcA, Resolved.malo)
  )
  AllRows <- c(
    lapply(AvailableRows, `[[`, "capacities"),
    list(Resolved.nominal$capacities)
  )
  if (length(unique(do.call(rbind, AllRows)$capacityBasisID)) != 1L) {
    addCheck(
      .unresolvedAisiCheck(
        demandRow, demandRowID, "H3-capacity-basis", "H3", "Section H3",
        "invalid", "invalid", "mixed-capacity-basis-within-H3",
        settings, eligibility
      ),
      NULL
    )
    Checks <- do.call(rbind, Checks)
    Usage <- Filter(function(value) nrow(value) > 0L, Usage)
    Usage <- if (length(Usage) == 0L) data.frame() else do.call(rbind, Usage)
    return(list(checks = Checks, capacityUsage = Usage))
  }

  CaseID <- applicability[["h3InteractionCaseID", exact = TRUE]]
  CaseEvidence <- applicability[["h3CaseEvidenceLocator", exact = TRUE]]
  AllowedCases <- c(
    "single-unreinforced-flat-web",
    "multiple-unreinforced-webs-high-rotation-restraint",
    "two-nested-z",
    "interior-support-exception",
    "unsupported",
    "unknown"
  )
  if (!.aisiTextAvailable(CaseID) || !(CaseID %in% AllowedCases)) {
    addCheck(
      .unresolvedAisiCheck(
        demandRow, demandRowID, "H3-interaction", "H3", "Section H3",
        "invalid", "invalid", "invalid-h3-interaction-case",
        settings, eligibility
      ),
      NULL
    )
  } else if (CaseID == "unknown") {
    addCheck(
      .unresolvedAisiCheck(
        demandRow, demandRowID, "H3-interaction", "H3", "Section H3",
        "blocked", "unknown", "h3-interaction-case-unknown",
        settings, eligibility,
        evidenceLocator = if (.aisiTextAvailable(CaseEvidence)) {
          CaseEvidence
        } else {
          NA_character_
        }
      ),
      NULL
    )
  } else if (CaseID == "unsupported") {
    if (!.aisiTextAvailable(CaseEvidence)) {
      addCheck(
        .unresolvedAisiCheck(
          demandRow, demandRowID, "H3-interaction", "H3", "Section H3",
          "invalid", "invalid", "missing-h3-case-evidence",
          settings, eligibility
        ),
        NULL
      )
    } else {
      addCheck(
        .unresolvedAisiCheck(
          demandRow, demandRowID, "H3-interaction", "H3", "Section H3",
          "blocked", "outside-prescriptive-scope",
          "h3-interaction-case-outside-prescriptive-scope",
          settings, eligibility,
          evidenceLocator = CaseEvidence
        ),
        NULL
      )
    }
  } else if (!.aisiTextAvailable(CaseEvidence)) {
    addCheck(
      .unresolvedAisiCheck(
        demandRow, demandRowID, "H3-interaction", "H3", "Section H3",
        "invalid", "invalid", "missing-h3-case-evidence",
        settings, eligibility
      ),
      NULL
    )
  } else if (CaseID == "interior-support-exception") {
    ExceptionStatus <- applicability[["h3ExceptionStatus", exact = TRUE]]
    ContinuousStatus <- applicability[[
      "continuousSpanInteriorSupportStatus", exact = TRUE
    ]]
    MemberFamilyID <- applicability[["memberFamilyID", exact = TRUE]]
    WebCount <- applicability[["singleWebCount", exact = TRUE]]
    SupportStatus <- applicability[[
      "compressionEdgesLateralSupportStatus", exact = TRUE
    ]]
    Spacing <- applicability[["adjacentWebSpacingMm", exact = TRUE]]
    ExceptionOK <- identical(ExceptionStatus, "satisfied") &&
      identical(ContinuousStatus, "satisfied") &&
      identical(MemberFamilyID, "deck-or-beam") &&
      is.numeric(WebCount) && length(WebCount) == 1L && is.finite(WebCount) &&
      WebCount >= 2 && identical(SupportStatus, "satisfied") &&
      is.numeric(Spacing) && length(Spacing) == 1L && is.finite(Spacing) &&
      Spacing <= 254
    if (ExceptionOK) {
      addCheck(
        .unresolvedAisiCheck(
          demandRow, demandRowID, "H3-interaction", "H3", "Section H3",
          "not-required-by-exception", "satisfied",
          "interior-support-exception-demonstrated",
          settings, eligibility,
          evidenceLocator = CaseEvidence
        ),
        NULL
      )
    } else {
      addCheck(
        .unresolvedAisiCheck(
          demandRow, demandRowID, "H3-interaction", "H3", "Section H3",
          "blocked", "unknown", "h3-exception-not-demonstrated",
          settings, eligibility,
          evidenceLocator = CaseEvidence
        ),
        NULL
      )
    }
  } else {
    if (CaseID == "two-nested-z") {
      Nested <- .aisiNamedEvidenceGate(
        applicability = applicability,
        statusField = "h3NestedZGateStatus",
        evidenceField = "h3NestedZGateEvidenceLocator",
        requiredNames = c(
          "depthToThickness", "bearingLengthToThickness", "yieldStrength",
          "radiusToThickness", "webEndBolts", "flangeSupportBolts",
          "webContact", "thicknessRatio"
        )
      )
      Ratio <- applicability[[
        "nestedZThickerToThinnerThicknessRatio", exact = TRUE
      ]]
      if (!Nested$ok || !is.numeric(Ratio) || length(Ratio) != 1L ||
          !is.finite(Ratio) || Ratio > 1.3) {
        ApplicabilityStatus <- if (!Nested$ok) {
          Nested$applicabilityStatus
        } else {
          "outside-prescriptive-scope"
        }
        ReasonCode <- if (!Nested$ok) {
          Nested$reasonCode
        } else {
          "h3-3-thickness-ratio-outside-scope"
        }
        addCheck(
          .unresolvedAisiCheck(
            demandRow, demandRowID, "H3-interaction", "H3", "Eq. H3-3",
            "blocked", ApplicabilityStatus, ReasonCode,
            settings, eligibility,
            evidenceLocator = CaseEvidence
          ),
          NULL
        )
        return(list(
          checks = do.call(rbind, Checks),
          capacityUsage = do.call(rbind, Filter(
            function(value) nrow(value) > 0L,
            Usage
          ))
        ))
      }
    }
    Coefficient <- switch(
      CaseID,
      "single-unreinforced-flat-web" = 0.91,
      "multiple-unreinforced-webs-high-rotation-restraint" = 0.88,
      "two-nested-z" = 0.86
    )
    ClauseID <- switch(
      CaseID,
      "single-unreinforced-flat-web" = "Eq. H3-1",
      "multiple-unreinforced-webs-high-rotation-restraint" = "Eq. H3-2",
      "two-nested-z" = "Eq. H3-3"
    )
    Limit <- switch(
      CaseID,
      "single-unreinforced-flat-web" = if (settings$designMethodID == "ASD") {
        1.33 / 1.70
      } else {
        1.33 * 0.90
      },
      "multiple-unreinforced-webs-high-rotation-restraint" =
        if (settings$designMethodID == "ASD") 1.46 / 1.70 else 1.46 * 0.90,
      "two-nested-z" = if (settings$designMethodID == "ASD") {
        1.65 / 1.70
      } else {
        1.65 * 0.90
      }
    )
    EquationValue <- Coefficient * Rwc / RwcN$nominalValue +
      Mr / Mnlo$nominalValue
    addCheck(
      .computedAisiCheck(
        demandRow, demandRowID, "H3-interaction", "H3", ClauseID,
        EquationValue, Limit, settings, eligibility,
        unique(rbind(RwcN, Mnlo)$capacityBasisID),
        evidenceLocator = CaseEvidence
      ),
      rbind(RwcN, Mnlo)
    )
  }

  Checks <- do.call(rbind, Checks)
  Usage <- Filter(function(value) nrow(value) > 0L, Usage)
  Usage <- if (length(Usage) == 0L) data.frame() else do.call(rbind, Usage)
  list(checks = Checks, capacityUsage = Usage)
}

.summarizeAisiChecks <- function(checks, settings, eligibility) {
  Invalid <- any(checks$evaluationStatus == "invalid")
  Failed <- any(checks$evaluationStatus == "fail")
  Blocked <- any(checks$evaluationStatus %in%
    c("blocked", "diagnostic-only"))
  Applicable <- any(checks$evaluationStatus %in%
    c("pass", "fail", "diagnostic-only"))

  WallMemberVerdict <- if (Invalid) {
    "invalid"
  } else if (Failed) {
    "fail"
  } else if (Blocked) {
    "blocked"
  } else if (Applicable) {
    "pass"
  } else {
    "not-applicable"
  }
  Complete <- !Invalid && !Blocked
  NormativeVerdict <- if (Invalid) {
    "invalid"
  } else if (!eligibility$normativeEligible) {
    "blocked"
  } else if (Failed) {
    "fail"
  } else if (Blocked) {
    "blocked"
  } else {
    WallMemberVerdict
  }

  GoverningCandidates <- which(
    is.finite(checks$normalizedCheckValue) &
      !(checks$evaluationStatus %in% c(
        "not-applicable", "not-required-by-threshold",
        "not-required-by-exception"
      ))
  )
  GoverningIndex <- if (length(GoverningCandidates) == 0L) {
    NA_integer_
  } else {
    GoverningCandidates[which.max(
      checks$normalizedCheckValue[GoverningCandidates]
    )]
  }
  ReasonCodes <- unique(checks$reasonCode[
    checks$evaluationStatus %in% c("blocked", "invalid") &
      !is.na(checks$reasonCode)
  ])

  data.frame(
    standardID = settings$standardID,
    designMethodID = settings$designMethodID,
    evaluationPurposeID = settings$evaluationPurposeID,
    verdictEligibilityStatus = eligibility$verdictEligibilityStatus,
    wallMemberVerdict = WallMemberVerdict,
    normativeVerdict = NormativeVerdict,
    connectionVerdict = "not-evaluated",
    serviceabilityVerdict = "not-evaluated",
    systemVerdict = "blocked",
    complete = Complete,
    governingCheckID = if (is.na(GoverningIndex)) {
      NA_character_
    } else {
      checks$checkID[GoverningIndex]
    },
    governingCombinationID = if (is.na(GoverningIndex)) {
      NA_character_
    } else {
      checks$combinationID[GoverningIndex]
    },
    governingStageID = if (is.na(GoverningIndex)) {
      NA_character_
    } else {
      checks$stageID[GoverningIndex]
    },
    governingThetaRad = if (is.na(GoverningIndex)) {
      NA_real_
    } else {
      checks$thetaRad[GoverningIndex]
    },
    governingThetaDeg = if (is.na(GoverningIndex)) {
      NA_real_
    } else {
      checks$thetaDeg[GoverningIndex]
    },
    governingNormalizedCheckValue = if (is.na(GoverningIndex)) {
      NA_real_
    } else {
      checks$normalizedCheckValue[GoverningIndex]
    },
    blockedCheckCount = sum(checks$evaluationStatus == "blocked"),
    diagnosticCheckCount = sum(checks$evaluationStatus == "diagnostic-only"),
    blockingReasonCode = if (length(ReasonCodes) == 0L) {
      NA_character_
    } else {
      paste(sort(ReasonCodes), collapse = "|")
    },
    stringsAsFactors = FALSE
  )
}

#' Evaluate AISI S100 demand-capacity interaction checks.
#'
#' @param demand Concurrent section-resultant rows. N is positive in tension;
#'   positive M tensions the inner fibre. Units are encoded in field names.
#' @param capacities Long table of externally determined nominal and available
#'   strengths.
#' @param applicability Named list of branch-specific applicability evidence.
#' @param settings Named list declaring the standard, design method, load basis,
#'   purpose, width basis and numerical zero tolerances.
#'
#' @return A list with `checks`, `capacityUsage` and `summary` data frames.
evaluateAisiS100Demand <- function(
  demand,
  capacities,
  applicability,
  settings
) {
  Settings <- .validateAisiSettings(settings)
  Demand <- .validateAisiDemand(demand, Settings$angleToleranceDeg)
  Capacities <- .validateAisiCapacities(capacities)
  Applicability <- .validateAisiApplicability(applicability)
  if (any(Demand$longitudinalBasis != Settings$widthBasisID)) {
    stop("Demand and settings width bases are incompatible.", call. = FALSE)
  }
  if (nrow(Capacities) > 0L &&
      any(Capacities$sectionID != unique(Demand$sectionID))) {
    stop("Every supplied capacity must match demand.sectionID.",
         call. = FALSE)
  }

  Eligibility <- .aisiEligibility(
    Settings,
    unique(Demand$forceEffectStatus)
  )
  Checks <- list()
  Usage <- list()
  for (DemandRowID in seq_len(nrow(Demand))) {
    DemandRow <- Demand[DemandRowID, , drop = FALSE]
    Concurrency <- .aisiConcurrencyGate(DemandRow)
    if (!Concurrency$ok) {
      Checks[[length(Checks) + 1L]] <- .unresolvedAisiCheck(
        DemandRow,
        DemandRowID,
        "resultant-concurrency",
        "B",
        "Concurrent demand row",
        Concurrency$status,
        Concurrency$applicabilityStatus,
        Concurrency$reasonCode,
        Settings,
        Eligibility,
        evidenceLocator = Concurrency$evidenceLocator
      )
    } else if (!Eligibility$proceed) {
      Checks[[length(Checks) + 1L]] <- .unresolvedAisiCheck(
        DemandRow,
        DemandRowID,
        "B3-eligibility",
        "B",
        "Section B3",
        Eligibility$evaluationStatus,
        Eligibility$applicabilityStatus,
        Eligibility$reasonCode,
        Settings,
        Eligibility
      )
    } else {
      H1 <- .evaluateAisiH1(
        DemandRow,
        DemandRowID,
        Capacities,
        Applicability,
        Settings,
        Eligibility
      )
      H2 <- .evaluateAisiH2(
        DemandRow,
        DemandRowID,
        Capacities,
        Applicability,
        Settings,
        Eligibility
      )
      H3 <- .evaluateAisiH3(
        DemandRow,
        DemandRowID,
        Capacities,
        Applicability,
        Settings,
        Eligibility
      )
      for (Result in list(H1, H2, H3)) {
        if (nrow(Result$checks) > 0L) {
          Checks[[length(Checks) + 1L]] <- Result$checks
        }
        if (nrow(Result$capacityUsage) > 0L) {
          Usage[[length(Usage) + 1L]] <- Result$capacityUsage
        }
      }
    }
  }

  Checks <- do.call(rbind, Checks)
  rownames(Checks) <- NULL
  Usage <- if (length(Usage) == 0L) {
    data.frame(
      demandRowID = integer(),
      checkID = character(),
      capacityRoleID = character(),
      capacityID = character(),
      senseID = character(),
      nominalValue = numeric(),
      availableValue = numeric(),
      unit = character(),
      designMethodID = character(),
      widthBasisID = character(),
      capacityConsumerID = character(),
      capacityBasisID = character(),
      limitStateID = character(),
      applicabilityStatus = character(),
      sectionHoleStatus = character(),
      webHoleStatus = character(),
      netSectionBasisID = character(),
      capacityCoverageStatus = character(),
      capacityCoverageEvidenceLocator = character(),
      evidenceLocator = character(),
      sourceLocator = character(),
      stringsAsFactors = FALSE
    )
  } else {
    Result <- do.call(rbind, Usage)
    rownames(Result) <- NULL
    Result
  }
  Summary <- .summarizeAisiChecks(Checks, Settings, Eligibility)
  list(checks = Checks, capacityUsage = Usage, summary = Summary)
}
