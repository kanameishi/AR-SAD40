# Recover homogenized circumferential normal stress from section resultants.
#
# Units and signs:
#   normalForceKnPerM     : kN/m, positive in tension;
#   bendingMomentKnMPerM : kN m/m, positive in tension at the inner fibre;
#   section area         : mm2/mm of projected longitudinal width;
#   section inertia      : mm4/mm of projected longitudinal width;
#   fibre coordinate     : mm from the centroid, positive radially inward.
#
# The function implements only linear, homogenized-section stress recovery.
# It transports Q without using it and does not calculate resistance.

calculateSheetNormalStress <- function(resultants, netSection, recoveryBasis) {
  if (!is.data.frame(resultants) || nrow(resultants) == 0L) {
    stop("resultants must be one non-empty data frame.", call. = FALSE)
  }
  RequiredResultantFields <- c(
    "sectionID", "combinationID", "stageID", "theta", "thetaDeg",
    "normalForceKnPerM", "bendingMomentKnMPerM", "shearForceKnPerM",
    "forceEffectStatus", "longitudinalBasis"
  )
  MissingResultantFields <- setdiff(
    RequiredResultantFields,
    names(resultants)
  )
  if (length(MissingResultantFields) > 0L) {
    stop(
      "resultants is missing: ",
      paste(MissingResultantFields, collapse = ", "),
      ".",
      call. = FALSE
    )
  }
  NumericResultantFields <- c(
    "theta", "thetaDeg", "normalForceKnPerM", "bendingMomentKnMPerM",
    "shearForceKnPerM"
  )
  if (any(!vapply(
    resultants[NumericResultantFields],
    is.numeric,
    logical(1)
  )) || any(!is.finite(as.matrix(resultants[NumericResultantFields])))) {
    stop("The required resultant values must be finite and numeric.", call. = FALSE)
  }
  TextResultantFields <- c(
    "sectionID", "combinationID", "stageID", "forceEffectStatus",
    "longitudinalBasis"
  )
  if (any(!vapply(
    resultants[TextResultantFields],
    function(x) is.character(x) && all(nzchar(x)),
    logical(1)
  ))) {
    stop("The required resultant identifiers must be non-empty strings.", call. = FALSE)
  }
  if (any(resultants$longitudinalBasis != "per-projected-metre")) {
    stop(
      "resultants.longitudinalBasis must be per-projected-metre.",
      call. = FALSE
    )
  }

  if (!is.list(netSection) || is.null(names(netSection))) {
    stop("netSection must be one named list.", call. = FALSE)
  }
  RequiredSectionFields <- c(
    "sectionID", "areaMm2PerMm", "inertiaMm4PerMm",
    "outerFiberCoordinateMm", "innerFiberCoordinateMm",
    "coordinatePositiveDirection", "momentSignConvention"
  )
  MissingSectionFields <- setdiff(RequiredSectionFields, names(netSection))
  if (length(MissingSectionFields) > 0L) {
    stop(
      "netSection is missing: ",
      paste(MissingSectionFields, collapse = ", "),
      ".",
      call. = FALSE
    )
  }
  NumericSectionFields <- c(
    "areaMm2PerMm", "inertiaMm4PerMm",
    "outerFiberCoordinateMm", "innerFiberCoordinateMm"
  )
  SectionValues <- unlist(netSection[NumericSectionFields], use.names = FALSE)
  if (!is.numeric(SectionValues) || length(SectionValues) != 4L ||
      any(!is.finite(SectionValues))) {
    stop("The required net-section properties must be finite numbers.", call. = FALSE)
  }
  if (netSection$areaMm2PerMm <= 0 || netSection$inertiaMm4PerMm <= 0) {
    stop("Net-section area and inertia must be positive.", call. = FALSE)
  }
  if (netSection$outerFiberCoordinateMm >= 0 ||
      netSection$innerFiberCoordinateMm <= 0) {
    stop(
      paste(
        "With an inward-positive coordinate, the outer fibre must be",
        "negative and the inner fibre positive."
      ),
      call. = FALSE
    )
  }
  if (!identical(netSection$coordinatePositiveDirection, "inward")) {
    stop("netSection.coordinatePositiveDirection must be inward.", call. = FALSE)
  }
  if (!identical(
    netSection$momentSignConvention,
    "positive-tension-inner"
  )) {
    stop(
      "netSection.momentSignConvention must be positive-tension-inner.",
      call. = FALSE
    )
  }
  if (length(unique(resultants$sectionID)) != 1L ||
      !identical(unique(resultants$sectionID), netSection$sectionID)) {
    stop("resultants and netSection must identify the same sectionID.", call. = FALSE)
  }

  if (!is.list(recoveryBasis) || is.null(names(recoveryBasis))) {
    stop("recoveryBasis must be one named list.", call. = FALSE)
  }
  RequiredBasisFields <- c("modelID", "criterionID", "applicabilityStatus")
  MissingBasisFields <- setdiff(RequiredBasisFields, names(recoveryBasis))
  if (length(MissingBasisFields) > 0L) {
    stop(
      "recoveryBasis is missing: ",
      paste(MissingBasisFields, collapse = ", "),
      ".",
      call. = FALSE
    )
  }
  BasisValues <- recoveryBasis[RequiredBasisFields]
  if (any(!vapply(
    BasisValues,
    function(x) is.character(x) && length(x) == 1L && nzchar(x),
    logical(1)
  ))) {
    stop("The recovery-basis fields must be non-empty strings.", call. = FALSE)
  }
  ModelID <- recoveryBasis$modelID
  CriterionID <- recoveryBasis$criterionID
  ApplicabilityStatus <- recoveryBasis$applicabilityStatus
  if (ModelID != "linear-homogenized") {
    stop("Unsupported sheet-stress recovery modelID: ", ModelID, ".", call. = FALSE)
  }
  if (!(ApplicabilityStatus %in% c("satisfied", "not-satisfied", "unknown"))) {
    stop(
      "Unsupported recovery applicabilityStatus: ",
      ApplicabilityStatus,
      ".",
      call. = FALSE
    )
  }

  ResultantRow <- rep(seq_len(nrow(resultants)), each = 2L)
  Output <- resultants[ResultantRow, , drop = FALSE]
  rownames(Output) <- NULL
  Output$fiberID <- rep(c("outer", "inner"), times = nrow(resultants))
  Output$fiberCoordinateMm <- rep(
    c(
      netSection$outerFiberCoordinateMm,
      netSection$innerFiberCoordinateMm
    ),
    times = nrow(resultants)
  )
  Output$membraneStressMPa <- NA_real_
  Output$bendingStressMPa <- NA_real_
  Output$normalStressMPa <- NA_real_
  Output$shearStressStatus <- "not-evaluated"
  Output$recoveryModelID <- ModelID
  Output$criterionID <- CriterionID
  Output$applicabilityStatus <- ApplicabilityStatus
  if (ApplicabilityStatus == "satisfied") {
    Output$membraneStressMPa <-
      Output$normalForceKnPerM / netSection$areaMm2PerMm
    Output$bendingStressMPa <-
      1000 * Output$bendingMomentKnMPerM * Output$fiberCoordinateMm /
      netSection$inertiaMm4PerMm
    Output$normalStressMPa <-
      Output$membraneStressMPa + Output$bendingStressMPa
  }
  Output
}
