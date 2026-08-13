# Interpolate circumferential properties from a loaded corrugation reference.

if (!exists(".assertFiniteScalar", mode = "function")) {
  stop("Source scripts/R/ringDirect.R before scripts/R/corrugatedSection.R.", call. = FALSE)
}

selectCorrugatedSection <- function(reference, profileID, referenceRowID) {
  if (!is.data.frame(reference)) {
    stop("reference must be one data frame.", call. = FALSE)
  }
  if (!is.character(profileID) || length(profileID) != 1L || !nzchar(profileID)) {
    stop("profileID must be one non-empty string.", call. = FALSE)
  }
  if (!is.character(referenceRowID) || length(referenceRowID) != 1L ||
      !nzchar(referenceRowID)) {
    stop("referenceRowID must be one non-empty string.", call. = FALSE)
  }

  Columns.required <- c(
    "profileID", "referenceRowID", "nominalPitchMm", "nominalDepthMm",
    "actualPitchMm", "actualDepthMm", "corrugationRadiusMm",
    "specifiedThicknessMm", "designBaseThicknessMm", "areaMm2PerMm",
    "tangentLengthMm", "tangentAngleDeg", "inertiaMm4PerMm",
    "sectionModulusMm3PerMm", "gyrationRadiusMm", "developedWidthFactor",
    "evidenceLevel", "sourceKey", "sourceLocator"
  )
  Missing <- setdiff(Columns.required, names(reference))
  if (length(Missing) > 0L) {
    stop(
      "The corrugation property table is missing: ",
      paste(Missing, collapse = ", "),
      ".",
      call. = FALSE
    )
  }

  Rows <- reference[
    reference$profileID == profileID &
      reference$referenceRowID == referenceRowID,
    Columns.required,
    drop = FALSE
  ]
  if (nrow(Rows) != 1L) {
    stop("The exact corrugation reference row is missing or duplicated.", call. = FALSE)
  }
  Columns.numeric <- c(
    "nominalPitchMm", "nominalDepthMm", "actualPitchMm", "actualDepthMm",
    "corrugationRadiusMm", "specifiedThicknessMm", "designBaseThicknessMm",
    "areaMm2PerMm", "tangentLengthMm", "tangentAngleDeg",
    "inertiaMm4PerMm", "sectionModulusMm3PerMm", "gyrationRadiusMm",
    "developedWidthFactor"
  )
  if (any(!vapply(Rows[Columns.numeric], is.numeric, logical(1))) ||
      any(!is.finite(as.matrix(Rows[Columns.numeric]))) ||
      any(as.matrix(Rows[Columns.numeric]) <= 0)) {
    stop("The exact corrugation properties must be finite and positive.", call. = FALSE)
  }
  if (Rows$tangentAngleDeg >= 90) {
    stop("The corrugation tangent angle must be less than 90 degrees.", call. = FALSE)
  }

  list(
    profileID = Rows$profileID,
    referenceRowID = Rows$referenceRowID,
    nominalPitchMm = Rows$nominalPitchMm,
    nominalDepthMm = Rows$nominalDepthMm,
    actualPitchMm = Rows$actualPitchMm,
    actualDepthMm = Rows$actualDepthMm,
    corrugationRadiusMm = Rows$corrugationRadiusMm,
    specifiedThicknessMm = Rows$specifiedThicknessMm,
    designBaseThicknessMm = Rows$designBaseThicknessMm,
    areaMm2PerMm = Rows$areaMm2PerMm,
    tangentLengthMm = Rows$tangentLengthMm,
    tangentAngleDeg = Rows$tangentAngleDeg,
    inertiaMm4PerMm = Rows$inertiaMm4PerMm,
    sectionModulusMm3PerMm = Rows$sectionModulusMm3PerMm,
    gyrationRadiusMm = Rows$gyrationRadiusMm,
    developedWidthFactor = Rows$developedWidthFactor,
    evidenceLevel = Rows$evidenceLevel,
    sourceKey = Rows$sourceKey,
    sourceLocator = Rows$sourceLocator,
    domainStatus = "exact-published-row"
  )
}

interpolateCorrugatedSection <- function(
  reference,
  profileID,
  baseThicknessMm
) {
  if (!is.data.frame(reference)) {
    stop("reference must be one data frame.", call. = FALSE)
  }
  if (!is.character(profileID) || length(profileID) != 1L || !nzchar(profileID)) {
    stop("profileID must be one non-empty string.", call. = FALSE)
  }
  .assertFiniteScalar(
    baseThicknessMm,
    "baseThicknessMm",
    minimum = 0,
    strict = TRUE
  )

  COLS.required <- c(
    "profileID", "referenceRowID", "specifiedThicknessIn", "baseThicknessMm",
    "areaMm2PerMm", "inertiaMm4PerMm", "evidenceLevel", "sourceKey",
    "sourceLocator"
  )
  Missing <- setdiff(COLS.required, names(reference))
  if (length(Missing) > 0L) {
    stop(
      "The corrugation property table is missing: ",
      paste(Missing, collapse = ", "),
      ".",
      call. = FALSE
    )
  }

  ProfileRows <- reference[
    reference$profileID == profileID,
    ,
    drop = FALSE
  ]
  if (nrow(ProfileRows) < 2L) {
    stop("At least two rows are required for the reference profile.", call. = FALSE)
  }
  COLS.numeric <- c(
    "specifiedThicknessIn", "baseThicknessMm", "areaMm2PerMm",
    "inertiaMm4PerMm"
  )
  if (any(!vapply(ProfileRows[COLS.numeric], is.numeric, logical(1))) ||
      any(!is.finite(as.matrix(ProfileRows[COLS.numeric]))) ||
      any(as.matrix(ProfileRows[COLS.numeric]) <= 0)) {
    stop("The selected reference properties must be finite and positive.", call. = FALSE)
  }

  ProfileRows <- ProfileRows[
    order(ProfileRows$baseThicknessMm),
    ,
    drop = FALSE
  ]
  if (anyDuplicated(ProfileRows$baseThicknessMm) ||
      anyDuplicated(ProfileRows$referenceRowID)) {
    stop("Reference thicknesses and row identifiers must be unique.", call. = FALSE)
  }
  if (baseThicknessMm < min(ProfileRows$baseThicknessMm) ||
      baseThicknessMm > max(ProfileRows$baseThicknessMm)) {
    stop("The analysis base thickness lies outside the published range.", call. = FALSE)
  }

  LowerIndex <- max(which(ProfileRows$baseThicknessMm <= baseThicknessMm))
  UpperIndex <- min(which(ProfileRows$baseThicknessMm >= baseThicknessMm))
  if (LowerIndex == UpperIndex) {
    if (LowerIndex == 1L) {
      UpperIndex <- 2L
    } else {
      LowerIndex <- LowerIndex - 1L
    }
  }
  LowerRow <- ProfileRows[LowerIndex, , drop = FALSE]
  UpperRow <- ProfileRows[UpperIndex, , drop = FALSE]
  Fraction <- (baseThicknessMm - LowerRow$baseThicknessMm) /
    (UpperRow$baseThicknessMm - LowerRow$baseThicknessMm)
  SourceKeys <- unique(c(LowerRow$sourceKey, UpperRow$sourceKey))
  SourceLocators <- unique(c(LowerRow$sourceLocator, UpperRow$sourceLocator))
  if (length(SourceKeys) != 1L || length(SourceLocators) != 1L) {
    stop("Interpolation rows must share one source and locator.", call. = FALSE)
  }

  list(
    profileID = profileID,
    analysisBaseThicknessMm = baseThicknessMm,
    lowerReferenceRowID = LowerRow$referenceRowID,
    upperReferenceRowID = UpperRow$referenceRowID,
    interpolationFraction = Fraction,
    areaMm2PerMm =
      (1 - Fraction) * LowerRow$areaMm2PerMm +
      Fraction * UpperRow$areaMm2PerMm,
    inertiaMm4PerMm =
      (1 - Fraction) * LowerRow$inertiaMm4PerMm +
      Fraction * UpperRow$inertiaMm4PerMm,
    sourceKey = SourceKeys,
    sourceLocator = SourceLocators,
    domainStatus = "within-interpolation-range"
  )
}
