# Pure reinforcement-mesh derivation shared by configuration and calculation.

resolveReinforcementGrade <- function(reinforcementGradeID) {
  if (!is.character(reinforcementGradeID) ||
      length(reinforcementGradeID) != 1L ||
      is.na(reinforcementGradeID) || !nzchar(reinforcementGradeID)) {
    stop("reinforcementGradeID must be one non-empty identifier.", call. = FALSE)
  }
  GradeCatalog <- list(
    `Grade-60` = list(
      reinforcementGradeID = "Grade-60",
      yieldStrengthMPa = 414,
      sourceBasisID = "ACI-318.2-14-grade-60-metric-conversion"
    )
  )
  Grade <- GradeCatalog[[reinforcementGradeID]]
  if (is.null(Grade)) {
    stop(
      "Unsupported reinforcementGradeID: ",
      reinforcementGradeID,
      ".",
      call. = FALSE
    )
  }
  Grade
}

calculateSymmetricReinforcementMesh <- function(
  thicknessM,
  barDiameterMm,
  barSpacingMm,
  clearCoverRatio,
  reinforcementGradeID,
  reinforcementModulusMPa
) {
  NumberList <- list(
    thicknessM = thicknessM,
    barDiameterMm = barDiameterMm,
    barSpacingMm = barSpacingMm,
    clearCoverRatio = clearCoverRatio,
    reinforcementModulusMPa = reinforcementModulusMPa
  )
  ValidNumbers <- vapply(
    NumberList,
    function(x) {
      is.numeric(x) && length(x) == 1L && is.finite(x) && x > 0
    },
    logical(1)
  )
  if (!all(ValidNumbers)) {
    stop("Reinforcement-mesh dimensions must be positive numbers.", call. = FALSE)
  }
  Grade <- resolveReinforcementGrade(
    reinforcementGradeID = reinforcementGradeID
  )
  if (barSpacingMm <= barDiameterMm) {
    stop("barSpacingMm must exceed barDiameterMm.", call. = FALSE)
  }
  if (clearCoverRatio >= 0.5) {
    stop("clearCoverRatio must be less than 0.5.", call. = FALSE)
  }
  ThicknessMm <- 1000 * thicknessM
  ClearCoverMm <- ThicknessMm * clearCoverRatio
  LayerCentroidCoverMm <- ClearCoverMm + barDiameterMm / 2
  CoordinateMagnitudeMm <- ThicknessMm / 2 - LayerCentroidCoverMm
  if (CoordinateMagnitudeMm <= 0) {
    stop(
      paste(
        "clearCoverRatio and barDiameterMm place the reinforcement",
        "outside the concrete section."
      ),
      call. = FALSE
    )
  }
  BarAreaMm2 <- pi * barDiameterMm^2 / 4
  AreaMm2PerFaceAndDirection <- BarAreaMm2 * 1000 / barSpacingMm
  Coordinates <- c(-CoordinateMagnitudeMm, CoordinateMagnitudeMm)
  buildLayers <- function(directionID) {
    Faces <- c("interior", "exterior")
    lapply(seq_along(Faces), function(i) {
      list(
        layerID = paste(directionID, Faces[i], sep = "-"),
        areaMm2 = AreaMm2PerFaceAndDirection,
        coordinateMm = Coordinates[i],
        yieldStrengthMPa = Grade[["yieldStrengthMPa", exact = TRUE]],
        modulusMPa = reinforcementModulusMPa
      )
    })
  }
  list(
    reinforcementGradeID = Grade[["reinforcementGradeID", exact = TRUE]],
    reinforcementGradeBasisID = Grade[["sourceBasisID", exact = TRUE]],
    barAreaMm2 = BarAreaMm2,
    areaMm2PerFaceAndDirection = AreaMm2PerFaceAndDirection,
    clearCoverMm = ClearCoverMm,
    layerCentroidCoverMm = LayerCentroidCoverMm,
    interiorLayerCoordinateMm = Coordinates[1L],
    exteriorLayerCoordinateMm = Coordinates[2L],
    yieldStrengthMPa = Grade[["yieldStrengthMPa", exact = TRUE]],
    circumferentialReinforcement = buildLayers("circumferential"),
    orthogonalReinforcement = buildLayers("orthogonal")
  )
}
