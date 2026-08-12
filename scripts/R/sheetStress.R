# Recover homogenized circumferential normal stress from section resultants.
#
# Units and signs:
#   normalForce    : kN/m, positive in tension;
#   bendingMoment : kN m/m;
#   section area  : mm2/mm of projected longitudinal width;
#   section inertia: mm4/mm of projected longitudinal width;
#   fibre coordinate: mm from the section centroid, positive radially outward;
#   positive bending moment compresses the positive-coordinate fibre.
#
# This function implements only the linear homogenized-section recovery. It
# does not infer net properties, evaluate curvature applicability, use Q, or
# calculate resistance, longitudinal stress, shear stress, or von Mises stress.

calculateSheetNormalStress <- function(resultants, netSection, recoveryBasis) {
  if (!is.data.frame(resultants) || nrow(resultants) == 0L) {
    stop("resultants must be one non-empty data frame.", call. = FALSE)
  }
  COLS.required <- c("theta", "thetaDeg", "normalForce", "bendingMoment")
  COLS.missing <- setdiff(COLS.required, names(resultants))
  if (length(COLS.missing) > 0L) {
    stop(
      "resultants is missing: ",
      paste(COLS.missing, collapse = ", "),
      ".",
      call. = FALSE
    )
  }
  if (any(!vapply(resultants[COLS.required], is.numeric, logical(1))) ||
      any(!is.finite(as.matrix(resultants[COLS.required])))) {
    stop("The required resultant columns must be finite and numeric.", call. = FALSE)
  }
  if (!is.list(netSection) || is.null(names(netSection))) {
    stop("netSection must be one named list.", call. = FALSE)
  }
  Fields.section <- c(
    "areaMm2PerMm", "inertiaMm4PerMm",
    "positiveFiberCoordinateMm", "negativeFiberCoordinateMm"
  )
  Fields.missing <- setdiff(Fields.section, names(netSection))
  if (length(Fields.missing) > 0L) {
    stop(
      "netSection is missing: ",
      paste(Fields.missing, collapse = ", "),
      ".",
      call. = FALSE
    )
  }
  Values.section <- unlist(netSection[Fields.section], use.names = FALSE)
  if (!is.numeric(Values.section) || length(Values.section) != 4L ||
      any(!is.finite(Values.section))) {
    stop("The required net-section properties must be finite numbers.", call. = FALSE)
  }
  if (netSection[["areaMm2PerMm", exact = TRUE]] <= 0 ||
      netSection[["inertiaMm4PerMm", exact = TRUE]] <= 0) {
    stop("Net-section area and inertia must be positive.", call. = FALSE)
  }
  if (netSection[["positiveFiberCoordinateMm", exact = TRUE]] <= 0 ||
      netSection[["negativeFiberCoordinateMm", exact = TRUE]] >= 0) {
    stop(
      "Net-section fibre coordinates must straddle the centroid.",
      call. = FALSE
    )
  }
  if (!is.list(recoveryBasis) || is.null(names(recoveryBasis))) {
    stop("recoveryBasis must be one named list.", call. = FALSE)
  }
  Fields.basis <- c("modelID", "criterionID", "applicabilityStatus")
  Fields.missing <- setdiff(Fields.basis, names(recoveryBasis))
  if (length(Fields.missing) > 0L) {
    stop(
      "recoveryBasis is missing: ",
      paste(Fields.missing, collapse = ", "),
      ".",
      call. = FALSE
    )
  }
  Values.text <- recoveryBasis[Fields.basis]
  if (any(!vapply(
    Values.text,
    function(x) is.character(x) && length(x) == 1L && nzchar(x),
    logical(1)
  ))) {
    stop("The recovery-basis fields must be non-empty strings.", call. = FALSE)
  }
  ModelID <- recoveryBasis[["modelID", exact = TRUE]]
  CriterionID <- recoveryBasis[["criterionID", exact = TRUE]]
  ApplicabilityStatus <- recoveryBasis[["applicabilityStatus", exact = TRUE]]
  if (ModelID != "linear-homogenized") {
    stop("Unsupported sheet-stress recovery modelID: ", ModelID, ".", call. = FALSE)
  }
  Statuses <- c("satisfied", "not-satisfied", "unknown")
  if (!(ApplicabilityStatus %in% Statuses)) {
    stop(
      "Unsupported recovery applicabilityStatus: ",
      ApplicabilityStatus,
      ".",
      call. = FALSE
    )
  }

  n <- nrow(resultants)
  IDX <- rep(seq_len(n), each = 2L)
  FiberCoordinates <- rep(
    c(
      netSection[["positiveFiberCoordinateMm", exact = TRUE]],
      netSection[["negativeFiberCoordinateMm", exact = TRUE]]
    ),
    times = n
  )
  OUT <- data.frame(
    theta = resultants[["theta", exact = TRUE]][IDX],
    thetaDeg = resultants[["thetaDeg", exact = TRUE]][IDX],
    fiberID = rep(c("outer", "inner"), times = n),
    fiberCoordinateMm = FiberCoordinates,
    normalForceKnPerM = resultants[["normalForce", exact = TRUE]][IDX],
    bendingMomentKnMPerM = resultants[["bendingMoment", exact = TRUE]][IDX],
    membraneStressMPa = NA_real_,
    bendingStressMPa = NA_real_,
    normalStressMPa = NA_real_,
    recoveryModelID = ModelID,
    criterionID = CriterionID,
    applicabilityStatus = ApplicabilityStatus,
    stringsAsFactors = FALSE
  )
  if (ApplicabilityStatus == "satisfied") {
    OUT$membraneStressMPa <-
      OUT$normalForceKnPerM /
      netSection[["areaMm2PerMm", exact = TRUE]]
    OUT$bendingStressMPa <-
      -1000 * OUT$bendingMomentKnMPerM * OUT$fiberCoordinateMm /
      netSection[["inertiaMm4PerMm", exact = TRUE]]
    OUT$normalStressMPa <- OUT$membraneStressMPa + OUT$bendingStressMPa
  }
  OUT
}
