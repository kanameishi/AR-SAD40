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

  StiffnessModels <- c(
    `gross-uncracked-short-term` = 1,
    `aci-318-25-cracked-wall-0p35-ig` = 0.35
  )
  InertiaReductionFactor <- unname(StiffnessModels[stiffnessBasisID])
  if (length(InertiaReductionFactor) != 1L ||
      is.na(InertiaReductionFactor)) {
    stop("stiffnessBasisID is not recognized.", call. = FALSE)
  }

  Area <- analysisThicknessM
  GrossInertia <- analysisThicknessM^3 / 12
  Inertia <- InertiaReductionFactor * GrossInertia
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
    inertiaReductionFactor = InertiaReductionFactor,
    areaM2PerM = Area,
    grossInertiaM4PerM = GrossInertia,
    inertiaM4PerM = Inertia,
    propertyModelID = if (InertiaReductionFactor == 1) {
      "homogeneous-rectangular-strip-gross"
    } else {
      "homogeneous-rectangular-strip-cracked-wall"
    },
    rigidity = Rigidity
  )
}

# Effective elastic section for the explicit full-composite sensitivity:
# cracked concrete, the existing corrugated sheet at the exterior face and
# one or more circumferential reinforcing layers. Coordinates are measured
# from the concrete mid-depth and are positive toward the exterior.
calculateCompositeConcreteSteelRingSection <- function(
  concreteSection,
  sheetSection,
  sheetYoungModulusKPa,
  sheetCoordinateM,
  reinforcement,
  concreteCentroidalRadiusM
) {
  if (!is.list(concreteSection) || !is.list(concreteSection$rigidity) ||
      !is.list(sheetSection) || !is.list(sheetSection$rigidity)) {
    stop(
      "concreteSection and sheetSection must be calculated sections.",
      call. = FALSE
    )
  }
  .assertFiniteScalar(
    sheetYoungModulusKPa,
    "sheetYoungModulusKPa",
    minimum = 0,
    strict = TRUE
  )
  .assertFiniteScalar(
    sheetCoordinateM,
    "sheetCoordinateM"
  )
  .assertFiniteScalar(
    concreteCentroidalRadiusM,
    "concreteCentroidalRadiusM",
    minimum = 0,
    strict = TRUE
  )
  Required <- c("areaMm2", "coordinateMm", "modulusMPa")
  if (!is.data.frame(reinforcement) || nrow(reinforcement) == 0L ||
      any(!Required %in% names(reinforcement)) ||
      any(!is.finite(as.matrix(reinforcement[Required]))) ||
      any(reinforcement$areaMm2 <= 0) ||
      any(reinforcement$modulusMPa <= 0)) {
    stop("reinforcement is invalid for the composite section.", call. = FALSE)
  }

  ConcreteE <- concreteSection$rigidity$youngModulus
  ConcreteA <- concreteSection$rigidity$area
  ConcreteI <- concreteSection$rigidity$inertia
  SheetA <- sheetSection$rigidity$area
  SheetI <- sheetSection$rigidity$inertia
  BarA <- reinforcement$areaMm2 * 1e-6
  BarY <- reinforcement$coordinateMm * 1e-3
  BarE <- reinforcement$modulusMPa * 1000

  EAComponents <- c(
    concrete = ConcreteE * ConcreteA,
    sheet = sheetYoungModulusKPa * SheetA,
    stats::setNames(BarE * BarA, reinforcement$layerID)
  )
  YComponents <- c(
    concrete = 0,
    sheet = sheetCoordinateM,
    stats::setNames(BarY, reinforcement$layerID)
  )
  EA <- sum(EAComponents)
  ElasticCentroid <- sum(EAComponents * YComponents) / EA
  EIComponents <- c(
    concrete = ConcreteE *
      (ConcreteI + ConcreteA * ElasticCentroid^2),
    sheet = sheetYoungModulusKPa *
      (SheetI + SheetA * (sheetCoordinateM - ElasticCentroid)^2),
    stats::setNames(
      BarE * BarA * (BarY - ElasticCentroid)^2,
      reinforcement$layerID
    )
  )
  EI <- sum(EIComponents)
  Radius <- concreteCentroidalRadiusM + ElasticCentroid
  EquivalentArea <- EA / ConcreteE
  EquivalentInertia <- EI / ConcreteE
  Rigidity <- calculateRingSection(
    youngModulus = ConcreteE,
    area = EquivalentArea,
    inertia = EquivalentInertia,
    radius = Radius
  )
  list(
    analysisThicknessM = concreteSection$analysisThicknessM,
    analysisModulusKPa = ConcreteE,
    centroidalRadiusM = Radius,
    concreteCentroidalRadiusM = concreteCentroidalRadiusM,
    elasticCentroidCoordinateM = ElasticCentroid,
    momentReferenceCoordinateMm = 1000 * ElasticCentroid,
    stiffnessBasisID = paste(
      concreteSection$stiffnessBasisID,
      "full-composite-sheet-and-interior-reinforcement",
      sep = "+"
    ),
    areaM2PerM = EquivalentArea,
    inertiaM4PerM = EquivalentInertia,
    propertyModelID = "full-composite-transformed-elastic-section",
    componentExtensionalRigidityKnPerM = EAComponents,
    componentFlexuralRigidityKnM2PerM = EIComponents,
    rigidity = Rigidity
  )
}
