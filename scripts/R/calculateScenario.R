# Compose one deterministic realization from primitive inputs and invariants.

calculateScenario <- function(realization, context) {
  if (!is.list(realization) || is.null(names(realization))) {
    stop("realization must be one named list.", call. = FALSE)
  }
  if (!is.list(context) || is.null(names(context))) {
    stop("context must be one named list.", call. = FALSE)
  }

  SectionPropertyModelID <- context[["sectionPropertyModelID", exact = TRUE]]
  if (is.null(SectionPropertyModelID)) {
    SectionPropertyModelID <- "linear-interpolation-base-thickness"
  }
  Fields.realization <- c(
    "effectiveVerticalKPa", "waterPressureDifferenceKPa", "alpha",
    if (SectionPropertyModelID == "linear-interpolation-base-thickness") {
      "baseThicknessMm"
    }
  )
  Fields.context <- c(
    "k0ModelID", "horizontalIncrementKPa", "horizontalIncrementStatus",
    "sectionReference", "profileID", "youngModulusKPa", "radiusM",
    "theta", "integrationSteps", "balanceTolerance"
  )
  Fields.missing <- setdiff(Fields.realization, names(realization))
  if (length(Fields.missing) > 0L) {
    stop(
      "realization is missing: ",
      paste(Fields.missing, collapse = ", "),
      ".",
      call. = FALSE
    )
  }
  Fields.missing <- setdiff(Fields.context, names(context))
  if (length(Fields.missing) > 0L) {
    stop(
      "context is missing: ",
      paste(Fields.missing, collapse = ", "),
      ".",
      call. = FALSE
    )
  }

  Fields.k0 <- c(
    "k0", "frictionAngleDeg", "poissonRatio", "ocr", "ocrMaximum"
  )
  LIST <- realization[intersect(Fields.k0, names(realization))]
  K0State <- do.call(
    estimateK0,
    c(
      list(modelID = context[["k0ModelID", exact = TRUE]]),
      LIST
    )
  )
  StressState <- calculateEffectiveStressState(
    effectiveVerticalKPa =
      realization[["effectiveVerticalKPa", exact = TRUE]],
    k0State = K0State,
    waterPressureDifferenceKPa =
      realization[["waterPressureDifferenceKPa", exact = TRUE]],
    horizontalIncrementKPa =
      context[["horizontalIncrementKPa", exact = TRUE]],
    horizontalIncrementStatus =
      context[["horizontalIncrementStatus", exact = TRUE]]
  )
  CorrugatedSection <- if (SectionPropertyModelID == "published-exact-row") {
    selectCorrugatedSection(
      reference = context[["sectionReference", exact = TRUE]],
      profileID = context[["profileID", exact = TRUE]],
      referenceRowID = context[["referenceRowID", exact = TRUE]]
    )
  } else if (SectionPropertyModelID ==
      "linear-interpolation-base-thickness") {
    interpolateCorrugatedSection(
      reference = context[["sectionReference", exact = TRUE]],
      profileID = context[["profileID", exact = TRUE]],
      baseThicknessMm = realization[["baseThicknessMm", exact = TRUE]]
    )
  } else {
    stop(
      "Unsupported sectionPropertyModelID: ",
      SectionPropertyModelID,
      ".",
      call. = FALSE
    )
  }
  SectionRigidity <- calculateRingSection(
    youngModulus = context[["youngModulusKPa", exact = TRUE]],
    # mm2/mm -> m2/m; mm4/mm -> m4/m.
    area = CorrugatedSection$areaMm2PerMm * 1e-3,
    inertia = CorrugatedSection$inertiaMm4PerMm * 1e-9,
    radius = context[["radiusM", exact = TRUE]]
  )
  PerimeterActions <- calculatePerimeterActions(
    stressState = StressState,
    alpha = realization[["alpha", exact = TRUE]],
    theta = context[["theta", exact = TRUE]]
  )
  SectionResultants <- calculateSectionResultants(
    load = PerimeterActions$load,
    radius = context[["radiusM", exact = TRUE]],
    theta = context[["theta", exact = TRUE]],
    sectionRatio = SectionRigidity$sectionRatio,
    integrationSteps = context[["integrationSteps", exact = TRUE]],
    balanceTolerance = context[["balanceTolerance", exact = TRUE]]
  )
  ResultantExtrema <- summarizeSectionResultants(SectionResultants)

  list(
    k0State = K0State,
    stressState = StressState,
    corrugatedSection = CorrugatedSection,
    sectionRigidity = SectionRigidity,
    perimeterActions = PerimeterActions,
    sectionResultants = SectionResultants,
    resultantExtrema = ResultantExtrema
  )
}
