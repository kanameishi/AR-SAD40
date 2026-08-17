# Prepare the section properties used by the ring analysis for each lining.

if (!exists("calculateRingSection", mode = "function", inherits = TRUE)) {
  stop(
    "Source scripts/R/ringDirect.R before scripts/R/liningSections.R.",
    call. = FALSE
  )
}

scaleCorrugatedSectionThickness <- function(
  referenceSection,
  remainingBaseThicknessMm
) {
  if (!is.list(referenceSection) || is.null(names(referenceSection))) {
    stop("referenceSection must be one named list.", call. = FALSE)
  }
  Fields.required <- c(
    "profileID", "referenceRowID", "designBaseThicknessMm",
    "areaMm2PerMm", "inertiaMm4PerMm", "sectionModulusMm3PerMm",
    "sourceKey", "sourceLocator"
  )
  Fields.missing <- setdiff(Fields.required, names(referenceSection))
  if (length(Fields.missing) > 0L) {
    stop(
      "referenceSection is missing: ",
      paste(Fields.missing, collapse = ", "),
      ".",
      call. = FALSE
    )
  }
  Fields.section <- c(
    "designBaseThicknessMm", "areaMm2PerMm", "inertiaMm4PerMm",
    "sectionModulusMm3PerMm"
  )
  if (any(!vapply(
    referenceSection[Fields.section],
    function(value) is.numeric(value) && length(value) == 1L &&
      is.finite(value) && value > 0,
    logical(1)
  ))) {
    stop(
      "The reference section properties must be positive finite scalars.",
      call. = FALSE
    )
  }
  .assertFiniteScalar(
    remainingBaseThicknessMm,
    "remainingBaseThicknessMm",
    minimum = 0,
    strict = TRUE
  )
  .assertFiniteScalar(
    referenceSection$designBaseThicknessMm,
    "referenceSection$designBaseThicknessMm",
    minimum = 0,
    strict = TRUE
  )
  if (remainingBaseThicknessMm > referenceSection$designBaseThicknessMm) {
    stop(
      paste(
        "remainingBaseThicknessMm must not exceed the selected published",
        "design base thickness."
      ),
      call. = FALSE
    )
  }

  Scale <- remainingBaseThicknessMm /
    referenceSection$designBaseThicknessMm
  OUT <- referenceSection
  OUT$referenceBaseThicknessMm <- referenceSection$designBaseThicknessMm
  OUT$analysisBaseThicknessMm <- remainingBaseThicknessMm
  OUT$thicknessScale <- Scale
  OUT$areaMm2PerMm <- Scale * referenceSection$areaMm2PerMm
  OUT$inertiaMm4PerMm <- Scale * referenceSection$inertiaMm4PerMm
  OUT$sectionModulusMm3PerMm <-
    Scale * referenceSection$sectionModulusMm3PerMm
  OUT$propertyModelID <- "uniform-thinning-fixed-midline"
  OUT$domainStatus <- "analytical-uniform-thinning-model"
  OUT
}

calculateCorrugatedRingSection <- function(
  referenceSection,
  remainingBaseThicknessMm,
  youngModulusKPa,
  radiusM
) {
  Section <- scaleCorrugatedSectionThickness(
    referenceSection = referenceSection,
    remainingBaseThicknessMm = remainingBaseThicknessMm
  )
  Rigidity <- calculateRingSection(
    youngModulus = youngModulusKPa,
    area = Section$areaMm2PerMm * 1e-3,
    inertia = Section$inertiaMm4PerMm * 1e-9,
    radius = radiusM
  )
  list(section = Section, rigidity = Rigidity)
}

calculateConcreteRingSection <- function(
  analysisThicknessM,
  analysisModulusKPa,
  centroidalRadiusM,
  stiffnessBasisID
) {
  .assertFiniteScalar(
    analysisThicknessM,
    "analysisThicknessM",
    minimum = 0,
    strict = TRUE
  )
  .assertFiniteScalar(
    analysisModulusKPa,
    "analysisModulusKPa",
    minimum = 0,
    strict = TRUE
  )
  .assertFiniteScalar(
    centroidalRadiusM,
    "centroidalRadiusM",
    minimum = 0,
    strict = TRUE
  )
  if (!is.character(stiffnessBasisID) || length(stiffnessBasisID) != 1L ||
      !nzchar(stiffnessBasisID)) {
    stop("stiffnessBasisID must be one non-empty string.", call. = FALSE)
  }

  Area <- analysisThicknessM
  Inertia <- analysisThicknessM^3 / 12
  Rigidity <- calculateRingSection(
    youngModulus = analysisModulusKPa,
    area = Area,
    inertia = Inertia,
    radius = centroidalRadiusM
  )
  list(
    analysisThicknessM = analysisThicknessM,
    analysisModulusKPa = analysisModulusKPa,
    centroidalRadiusM = centroidalRadiusM,
    stiffnessBasisID = stiffnessBasisID,
    areaM2PerM = Area,
    inertiaM4PerM = Inertia,
    propertyModelID = "homogeneous-rectangular-strip",
    rigidity = Rigidity
  )
}
