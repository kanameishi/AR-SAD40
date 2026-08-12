# Build the angular mesh and evaluate prescribed actions on the circular perimeter.

if (any(!vapply(
  c(
    ".assertFiniteScalar",
    ".assertTheta",
    "biaxialStressTangentialMultiplierLoad",
    "evaluateRingLoad"
  ),
  function(s) exists(s, mode = "function", inherits = TRUE),
  logical(1)
))) {
  stop(
    paste(
      "Source scripts/R/ringDirect.R and scripts/R/ringLoads.R before",
      "scripts/R/perimeterActions.R."
    ),
    call. = FALSE
  )
}

buildThetaMesh <- function(pointCount, criticalAnglesDeg) {
  .assertFiniteScalar(pointCount, "pointCount", minimum = 3)
  if (pointCount != as.integer(pointCount)) {
    stop("pointCount must be an integer.", call. = FALSE)
  }
  if (!is.numeric(criticalAnglesDeg) || length(criticalAnglesDeg) == 0L ||
      any(!is.finite(criticalAnglesDeg)) ||
      any(criticalAnglesDeg < 0 | criticalAnglesDeg >= 360) ||
      anyDuplicated(criticalAnglesDeg)) {
    stop(
      "criticalAnglesDeg must be unique finite values on [0, 360).",
      call. = FALSE
    )
  }

  Theta <- sort(unique(c(
    (0:(pointCount - 1L)) * 2 * pi / pointCount,
    criticalAnglesDeg * pi / 180
  )))
  .assertTheta(Theta)
  Theta
}

calculatePerimeterActions <- function(stressState, alpha, theta) {
  if (!is.list(stressState) || is.null(names(stressState))) {
    stop("stressState must be one named list.", call. = FALSE)
  }
  Fields.required <- c(
    "effectiveVerticalKPa",
    "effectiveHorizontalKPa",
    "waterPressureDifferenceKPa"
  )
  Fields.missing <- setdiff(Fields.required, names(stressState))
  if (length(Fields.missing) > 0L) {
    stop(
      "stressState is missing: ",
      paste(Fields.missing, collapse = ", "),
      ".",
      call. = FALSE
    )
  }
  .assertTheta(theta)

  Load <- biaxialStressTangentialMultiplierLoad(
    effectiveVertical = stressState[["effectiveVerticalKPa", exact = TRUE]],
    effectiveHorizontal = stressState[["effectiveHorizontalKPa", exact = TRUE]],
    waterPressureDifference =
      stressState[["waterPressureDifferenceKPa", exact = TRUE]],
    tangentialMultiplier = alpha
  )
  list(
    load = Load,
    values = evaluateRingLoad(Load, theta)
  )
}
