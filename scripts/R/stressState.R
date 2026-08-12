# Form the effective stress state consumed by the perimeter-load model.

if (!exists(".assertFiniteScalar", mode = "function")) {
  stop("Source scripts/R/ringDirect.R before scripts/R/stressState.R.", call. = FALSE)
}

calculateEffectiveStressState <- function(
  effectiveVerticalKPa,
  k0State,
  waterPressureDifferenceKPa,
  horizontalIncrementKPa = NA_real_,
  horizontalIncrementStatus = "unknown-not-modeled"
) {
  .assertFiniteScalar(
    effectiveVerticalKPa,
    "effectiveVerticalKPa",
    minimum = 0
  )
  .assertFiniteScalar(
    waterPressureDifferenceKPa,
    "waterPressureDifferenceKPa"
  )
  if (!is.list(k0State) || is.null(k0State$k0Applied)) {
    stop("k0State must contain k0Applied.", call. = FALSE)
  }
  .assertFiniteScalar(k0State$k0Applied, "k0State$k0Applied", minimum = 0)
  if (!is.character(horizontalIncrementStatus) ||
      length(horizontalIncrementStatus) != 1L ||
      horizontalIncrementStatus != "unknown-not-modeled") {
    stop(
      "Unsupported horizontalIncrementStatus: ",
      paste(horizontalIncrementStatus, collapse = ", "),
      ".",
      call. = FALSE
    )
  }
  if (!is.numeric(horizontalIncrementKPa) ||
      length(horizontalIncrementKPa) != 1L ||
      !is.na(horizontalIncrementKPa)) {
    stop(
      paste(
        "horizontalIncrementKPa must remain NA while",
        "horizontalIncrementStatus is unknown-not-modeled."
      ),
      call. = FALSE
    )
  }

  EffectiveHorizontal <- k0State$k0Applied * effectiveVerticalKPa
  list(
    effectiveVerticalKPa = effectiveVerticalKPa,
    baseEffectiveHorizontalKPa = EffectiveHorizontal,
    horizontalIncrementKPa = horizontalIncrementKPa,
    horizontalIncrementStatus = horizontalIncrementStatus,
    effectiveHorizontalKPa = EffectiveHorizontal,
    waterPressureDifferenceKPa = waterPressureDifferenceKPa
  )
}
