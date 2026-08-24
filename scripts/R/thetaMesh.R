if (!exists(".assertTheta", mode = "function", inherits = TRUE)) {
  stop(
    "Source scripts/R/ringDirect.R before scripts/R/thetaMesh.R.",
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
