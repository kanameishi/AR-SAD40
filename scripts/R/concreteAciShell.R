# Versioned ACI assessment supported by the sources in this repository.
# ACI 318-25 governs the plain-concrete branch; the reinforced thin-shell
# branch remains partial until the complete ACI 318.2-25 text is available.

.aciShellVector <- function(value, lengthRequired, name) {
  if (length(value) == 1L) value <- rep(value, lengthRequired)
  if (length(value) != lengthRequired || anyNA(value)) {
    stop(name, " must have length one or match the resultants.", call. = FALSE)
  }
  value
}

.aciShellCheckRow <- function(
  checkID,
  clauseID,
  sourceLocator,
  standardID = "ACI-318.2-14",
  demandValue = NA_real_,
  capacityValue = NA_real_,
  unit = "-",
  utilization = NA_real_,
  applicabilityStatus = "applicable",
  calculationStatus = "calculated",
  checkStatus,
  blockReason = ""
) {
  data.frame(
    checkID = checkID,
    standardID = standardID,
    clauseID = clauseID,
    sourceLocator = sourceLocator,
    demandValue = demandValue,
    capacityValue = capacityValue,
    unit = unit,
    utilization = utilization,
    applicabilityStatus = applicabilityStatus,
    calculationStatus = calculationStatus,
    checkStatus = checkStatus,
    blockReason = blockReason,
    stringsAsFactors = FALSE
  )
}

calculateAci31825NormalWeightConcreteModulus <- function(
  compressiveStrengthMPa
) {
  ConcreteStrength <- .concretePositiveScalar(
    compressiveStrengthMPa,
    "compressiveStrengthMPa"
  )
  4700 * sqrt(ConcreteStrength) * 1000
}

mapAciShellActions <- function(
  normalForceKnPerM,
  bendingMomentKnMPerM,
  shearForceKnPerM,
  stripWidthM,
  thetaRad,
  thetaDeg,
  combinationID,
  stageID,
  forceEffectStatus,
  interfaceID
) {
  Count <- length(normalForceKnPerM)
  if (Count == 0L ||
      !is.numeric(normalForceKnPerM) ||
      !is.numeric(bendingMomentKnMPerM) ||
      !is.numeric(shearForceKnPerM) ||
      length(bendingMomentKnMPerM) != Count ||
      length(shearForceKnPerM) != Count ||
      any(!is.finite(normalForceKnPerM)) ||
      any(!is.finite(bendingMomentKnMPerM)) ||
      any(!is.finite(shearForceKnPerM))) {
    stop("N, M and Q must be finite numeric vectors of equal length.", call. = FALSE)
  }
  Width <- .concretePositiveScalar(stripWidthM, "stripWidthM")
  ThetaRad <- .aciShellVector(thetaRad, Count, "thetaRad")
  ThetaDeg <- .aciShellVector(thetaDeg, Count, "thetaDeg")
  if (!is.numeric(ThetaRad) || !is.numeric(ThetaDeg) ||
      any(!is.finite(ThetaRad)) || any(!is.finite(ThetaDeg))) {
    stop("thetaRad and thetaDeg must be finite numeric vectors.", call. = FALSE)
  }
  CombinationID <- .aciShellVector(combinationID, Count, "combinationID")
  StageID <- .aciShellVector(stageID, Count, "stageID")
  ForceEffectStatus <- .aciShellVector(
    forceEffectStatus,
    Count,
    "forceEffectStatus"
  )
  InterfaceID <- .aciShellVector(interfaceID, Count, "interfaceID")
  if (!all(vapply(
    list(CombinationID, StageID, ForceEffectStatus, InterfaceID),
    is.character,
    logical(1)
  )) || any(!nzchar(c(
    CombinationID,
    StageID,
    ForceEffectStatus,
    InterfaceID
  )))) {
    stop("Action identifiers must be non-empty character vectors.", call. = FALSE)
  }

  data.frame(
    thetaRad = ThetaRad,
    thetaDeg = ThetaDeg,
    combinationID = CombinationID,
    stageID = StageID,
    forceEffectStatus = ForceEffectStatus,
    interfaceID = InterfaceID,
    stripWidthM = Width,
    normalForceKnPerM = normalForceKnPerM,
    bendingMomentKnMPerM = bendingMomentKnMPerM,
    shearForceKnPerM = shearForceKnPerM,
    axialForceKn = -normalForceKnPerM * Width,
    bendingMomentKnM = bendingMomentKnMPerM * Width,
    shearDemandKn = abs(shearForceKnPerM) * Width,
    shearDirectionSign = sign(shearForceKnPerM),
    stringsAsFactors = FALSE
  )
}

.aci31825PlainCheckRows <- function(
  actions,
  checkID,
  clauseID,
  sourceLocator,
  demandValue,
  capacityValue,
  unit,
  utilization,
  calculationStatus,
  checkStatus,
  blockReason
) {
  Count <- nrow(actions)
  Fields <- list(
    demandValue = demandValue,
    capacityValue = capacityValue,
    utilization = utilization,
    calculationStatus = calculationStatus,
    checkStatus = checkStatus,
    blockReason = blockReason
  )
  Fields <- lapply(names(Fields), function(Name) {
    Value <- Fields[[Name]]
    if (length(Value) == 1L) Value <- rep(Value, Count)
    if (length(Value) != Count ||
        (Name %in% c("calculationStatus", "checkStatus", "blockReason") &&
          anyNA(Value))) {
      stop(
        Name,
        " must have length one or match the resultants.",
        call. = FALSE
      )
    }
    Value
  })
  names(Fields) <- c(
    "demandValue", "capacityValue", "utilization",
    "calculationStatus", "checkStatus", "blockReason"
  )
  data.frame(
    combinationID = actions$combinationID,
    stageID = actions$stageID,
    forceEffectStatus = actions$forceEffectStatus,
    interfaceID = actions$interfaceID,
    thetaRad = actions$thetaRad,
    thetaDeg = actions$thetaDeg,
    normalForceKnPerM = actions$normalForceKnPerM,
    bendingMomentKnMPerM = actions$bendingMomentKnMPerM,
    shearForceKnPerM = actions$shearForceKnPerM,
    axialForceKn = actions$axialForceKn,
    bendingMomentKnM = actions$bendingMomentKnM,
    shearDemandKn = actions$shearDemandKn,
    checkID = checkID,
    standardID = "ACI-318-25",
    clauseID = clauseID,
    sourceLocator = sourceLocator,
    demandValue = Fields$demandValue,
    capacityValue = Fields$capacityValue,
    unit = unit,
    utilization = Fields$utilization,
    applicabilityStatus = "applicable",
    calculationStatus = Fields$calculationStatus,
    checkStatus = Fields$checkStatus,
    blockReason = Fields$blockReason,
    stringsAsFactors = FALSE
  )
}

.aci31825GoverningChecks <- function(rowChecks) {
  CheckIDs <- unique(rowChecks$checkID)
  Rows <- lapply(CheckIDs, function(CheckID) {
    Candidates <- rowChecks[rowChecks$checkID == CheckID, , drop = FALSE]
    Calculated <- Candidates$calculationStatus == "calculated" &
      is.finite(Candidates$utilization)
    Index <- if (any(Calculated)) {
      which(Calculated)[which.max(Candidates$utilization[Calculated])]
    } else {
      1L
    }
    Candidates[Index, , drop = FALSE]
  })
  OUT <- do.call(rbind, Rows)
  rownames(OUT) <- NULL
  OUT
}

evaluateAci31825PlainConcreteStrip <- function(
  actions,
  specifiedThicknessMm,
  stripWidthMm,
  compressiveStrengthMPa,
  lambda,
  castAgainstSoil,
  compressionLengthMm,
  structuralClassificationID,
  plainConcretePermissionBasisID,
  seismicDesignCategoryID,
  jointingStatus,
  openingStatus
) {
  RequiredActionFields <- c(
    "thetaRad", "thetaDeg", "combinationID", "stageID",
    "forceEffectStatus", "interfaceID", "normalForceKnPerM",
    "bendingMomentKnMPerM", "shearForceKnPerM", "axialForceKn",
    "bendingMomentKnM", "shearDemandKn"
  )
  if (!is.data.frame(actions) || nrow(actions) == 0L ||
      !all(RequiredActionFields %in% names(actions))) {
    stop("actions must be returned by mapAciShellActions().", call. = FALSE)
  }
  ThicknessSpecified <- .concretePositiveScalar(
    specifiedThicknessMm,
    "specifiedThicknessMm"
  )
  Width <- .concretePositiveScalar(stripWidthMm, "stripWidthMm")
  ConcreteStrength <- .concretePositiveScalar(
    compressiveStrengthMPa,
    "compressiveStrengthMPa"
  )
  Lambda <- .concretePositiveScalar(lambda, "lambda")
  if (Lambda > 1) {
    stop("lambda must not exceed one.", call. = FALSE)
  }
  if (!is.logical(castAgainstSoil) || length(castAgainstSoil) != 1L ||
      is.na(castAgainstSoil)) {
    stop("castAgainstSoil must be TRUE or FALSE.", call. = FALSE)
  }
  if (castAgainstSoil) {
    stop(
      paste(
        "castAgainstSoil = TRUE is outside this evaluator's scope:",
        "the lining is not cast against ground and the ACI 318-25",
        "50 mm thickness reduction is not implemented."
      ),
      call. = FALSE
    )
  }
  if (!is.numeric(compressionLengthMm) || length(compressionLengthMm) != 1L ||
      (!is.na(compressionLengthMm) &&
        (!is.finite(compressionLengthMm) || compressionLengthMm < 0))) {
    stop(
      "compressionLengthMm must be one nonnegative number or NA.",
      call. = FALSE
    )
  }
  TextInputs <- c(
    structuralClassificationID = structuralClassificationID,
    plainConcretePermissionBasisID = plainConcretePermissionBasisID,
    seismicDesignCategoryID = seismicDesignCategoryID,
    jointingStatus = jointingStatus,
    openingStatus = openingStatus
  )
  if (any(!nzchar(TextInputs))) {
    stop("ACI specification identifiers must be non-empty.", call. = FALSE)
  }
  if (!(structuralClassificationID %in% c(
    "underground-member-arch-strip", "thin-shell", "not-characterized"
  ))) {
    stop("structuralClassificationID is not supported.", call. = FALSE)
  }
  if (!(plainConcretePermissionBasisID %in% c(
    "continuously-supported", "arch-compression", "not-characterized"
  ))) {
    stop("plainConcretePermissionBasisID is not supported.", call. = FALSE)
  }
  if (!(seismicDesignCategoryID %in% c(
    "A", "B", "C", "D", "E", "F", "not-characterized"
  ))) {
    stop("seismicDesignCategoryID is not supported.", call. = FALSE)
  }
  if (!(jointingStatus %in% c(
    "requirements-satisfied", "requirements-not-satisfied",
    "not-characterized"
  ))) {
    stop("jointingStatus is not supported.", call. = FALSE)
  }
  if (!(openingStatus %in% c(
    "none", "requirements-satisfied", "requirements-not-satisfied",
    "not-characterized"
  ))) {
    stop("openingStatus is not supported.", call. = FALSE)
  }

  Thickness <- ThicknessSpecified
  Area <- Width * Thickness
  SectionModulus <- Width * Thickness^2 / 6
  Phi <- 0.60
  NominalMomentTension <- 0.42 * Lambda * sqrt(ConcreteStrength) *
    SectionModulus
  NominalMomentCompression <- 0.85 * ConcreteStrength * SectionModulus
  NominalShear <- 0.11 * Lambda * sqrt(ConcreteStrength) * Width * Thickness
  DesignTensionStress <- Phi * 0.42 * Lambda * sqrt(ConcreteStrength)
  DesignShearKn <- Phi * NominalShear / 1000
  DesignMomentCompressionKnM <- Phi * NominalMomentCompression / 1e6
  CompressionLengthKnown <- !is.na(compressionLengthMm)
  NominalAxial <- if (CompressionLengthKnown) {
    max(
      0,
      0.60 * ConcreteStrength * Area *
        (1 - (compressionLengthMm / (32 * Thickness))^2)
    )
  } else {
    NA_real_
  }
  DesignAxialKn <- Phi * NominalAxial / 1000

  Count <- nrow(actions)
  Factored <- actions$forceEffectStatus == "lrfd-factored"
  AxialCompression <- actions$axialForceKn >= 0
  TensionDemand <- pmax(
    0,
    abs(actions$bendingMomentKnM) * 1e6 / SectionModulus -
      actions$axialForceKn * 1000 / Area
  )
  TensionCalculated <- Factored & AxialCompression
  TensionUtilization <- rep(NA_real_, Count)
  TensionUtilization[TensionCalculated] <-
    TensionDemand[TensionCalculated] / DesignTensionStress
  TensionStatus <- ifelse(
    !TensionCalculated,
    "blocked",
    ifelse(TensionUtilization <= 1, "satisfied", "not-satisfied")
  )
  TensionReason <- ifelse(
    !Factored,
    "factored-actions-not-provided",
    ifelse(!AxialCompression, "axial-tension-not-covered", "")
  )
  TensionRows <- .aci31825PlainCheckRows(
    actions = actions,
    checkID = "tension-face",
    clauseID = "14.5.4.1(a)",
    sourceLocator = paste(
      "ACI CODE-318-25 SI, Table 14.5.4.1(a),",
      "printed p. 226/PDF p. 227"
    ),
    demandValue = TensionDemand,
    capacityValue = DesignTensionStress,
    unit = "MPa",
    utilization = TensionUtilization,
    calculationStatus = ifelse(
      TensionCalculated,
      "calculated",
      "not-evaluated"
    ),
    checkStatus = TensionStatus,
    blockReason = TensionReason
  )

  CompressionCalculated <- Factored & AxialCompression &
    CompressionLengthKnown & DesignAxialKn > 0
  CompressionUtilization <- rep(NA_real_, Count)
  CompressionUtilization[CompressionCalculated] <-
    abs(actions$bendingMomentKnM[CompressionCalculated]) /
      DesignMomentCompressionKnM +
    actions$axialForceKn[CompressionCalculated] / DesignAxialKn
  CompressionStatus <- ifelse(
    !CompressionCalculated,
    "blocked",
    ifelse(CompressionUtilization <= 1, "satisfied", "not-satisfied")
  )
  CompressionReason <- ifelse(
    !Factored,
    "factored-actions-not-provided",
    ifelse(
      !AxialCompression,
      "axial-tension-not-covered",
      ifelse(
        !CompressionLengthKnown,
        "compression-length-not-characterized",
        ifelse(DesignAxialKn <= 0, "nonpositive-axial-capacity", "")
      )
    )
  )
  CompressionRows <- .aci31825PlainCheckRows(
    actions = actions,
    checkID = "compression-face",
    clauseID = "14.5.3.1;14.5.4.1(b)",
    sourceLocator = paste(
      "ACI CODE-318-25 SI, Eq. 14.5.3.1 and Table 14.5.4.1(b),",
      "printed p. 226/PDF p. 227"
    ),
    demandValue = CompressionUtilization,
    capacityValue = 1,
    unit = "-",
    utilization = CompressionUtilization,
    calculationStatus = ifelse(
      CompressionCalculated,
      "calculated",
      "not-evaluated"
    ),
    checkStatus = CompressionStatus,
    blockReason = CompressionReason
  )

  ShearCalculated <- Factored
  ShearUtilization <- rep(NA_real_, Count)
  ShearUtilization[ShearCalculated] <-
    actions$shearDemandKn[ShearCalculated] / DesignShearKn
  ShearStatus <- ifelse(
    !ShearCalculated,
    "blocked",
    ifelse(ShearUtilization <= 1, "satisfied", "not-satisfied")
  )
  ShearRows <- .aci31825PlainCheckRows(
    actions = actions,
    checkID = "one-way-shear",
    clauseID = "14.5.5.1(a)",
    sourceLocator = paste(
      "ACI CODE-318-25 SI, Table 14.5.5.1(a),",
      "printed p. 227/PDF p. 228"
    ),
    demandValue = actions$shearDemandKn,
    capacityValue = DesignShearKn,
    unit = "kN",
    utilization = ShearUtilization,
    calculationStatus = ifelse(ShearCalculated, "calculated", "not-evaluated"),
    checkStatus = ShearStatus,
    blockReason = ifelse(Factored, "", "factored-actions-not-provided")
  )

  RowChecks <- rbind(TensionRows, CompressionRows, ShearRows)
  rownames(RowChecks) <- NULL
  GoverningChecks <- .aci31825GoverningChecks(RowChecks)
  Calculated <- GoverningChecks$calculationStatus == "calculated" &
    is.finite(GoverningChecks$utilization)
  Failed <- GoverningChecks$checkStatus == "not-satisfied"
  LocalStrengthStatus <- if (any(Failed)) {
    "not-satisfied"
  } else if (any(GoverningChecks$checkStatus == "blocked")) {
    "not-evaluated"
  } else {
    "satisfied"
  }
  GoverningIndex <- if (any(Calculated)) {
    which(Calculated)[which.max(GoverningChecks$utilization[Calculated])]
  } else {
    NA_integer_
  }
  ClassificationStatus <- switch(
    structuralClassificationID,
    `underground-member-arch-strip` = "satisfied",
    `thin-shell` = "blocked",
    `not-characterized` = "blocked"
  )
  PermissionStatus <- switch(
    plainConcretePermissionBasisID,
    `continuously-supported` = "satisfied",
    `arch-compression` = if (
      all(actions$normalForceKnPerM <= 0)
    ) "satisfied" else "not-satisfied",
    `not-characterized` = "blocked"
  )
  ClassificationReason <- switch(
    structuralClassificationID,
    `underground-member-arch-strip` = "",
    `thin-shell` = "thin-shell-requires-aci-318.2",
    `not-characterized` = "structural-classification-not-characterized"
  )
  PermissionReason <- switch(
    plainConcretePermissionBasisID,
    `continuously-supported` = "",
    `arch-compression` = if (
      PermissionStatus == "satisfied"
    ) "" else "arch-compression-not-maintained",
    `not-characterized` = "plain-concrete-permission-not-characterized"
  )
  SeismicStatus <- if (seismicDesignCategoryID == "not-characterized") {
    "blocked"
  } else if (seismicDesignCategoryID %in% c("D", "E", "F")) {
    "not-satisfied"
  } else {
    "satisfied"
  }
  JointingCheckStatus <- switch(
    jointingStatus,
    `requirements-satisfied` = "satisfied",
    `requirements-not-satisfied` = "not-satisfied",
    `not-characterized` = "blocked"
  )
  OpeningCheckStatus <- switch(
    openingStatus,
    none = "not-applicable",
    `requirements-satisfied` = "satisfied",
    `requirements-not-satisfied` = "not-satisfied",
    `not-characterized` = "blocked"
  )
  MinimumStrengthStatus <- if (
    ConcreteStrength >= 17
  ) "satisfied" else "not-satisfied"
  GateChecks <- data.frame(
    checkID = c(
      "minimum-concrete-strength", "structural-classification",
      "plain-concrete-permission", "seismic-scope", "jointing",
      "openings", "global-stability", "durability", "serviceability"
    ),
    standardID = "ACI-318-25",
    clauseID = c(
      "19.2.1.1", "1.4.4", "14.1.2", "14.1.3", "14.3.4",
      "14.6.1", "1.4.4", "19.3", "24.1.1;24.2.1"
    ),
    sourceLocator = c(
      "ACI CODE-318-25 SI, Table 19.2.1.1, printed p. 393/PDF p. 394",
      "ACI CODE-318-25 SI, 1.4.4, printed p. 10/PDF p. 11",
      "ACI CODE-318-25 SI, 14.1.2, printed p. 221/PDF p. 222",
      "ACI CODE-318-25 SI, 14.1.3, printed p. 221/PDF p. 222",
      "ACI CODE-318-25 SI, 14.3.4, printed p. 223/PDF p. 224",
      "ACI CODE-318-25 SI, 14.6.1, printed p. 227/PDF p. 228",
      "ACI CODE-318-25 SI, 1.4.4, printed p. 10/PDF p. 11",
      "ACI CODE-318-25 SI, 19.3",
      "ACI CODE-318-25 SI, 24.1.1 and 24.2.1, printed p. 497/PDF p. 498"
    ),
    demandValue = c(17, rep(NA_real_, 8L)),
    capacityValue = c(ConcreteStrength, rep(NA_real_, 8L)),
    unit = c("MPa", rep("-", 8L)),
    utilization = c(17 / ConcreteStrength, rep(NA_real_, 8L)),
    applicabilityStatus = c(
      "applicable", "applicable", "applicable", "applicable", "applicable",
      if (openingStatus == "none") "not-applicable" else "applicable",
      "applicable", "applicable", "applicable"
    ),
    calculationStatus = c(
      "calculated",
      if (ClassificationStatus == "blocked") "not-evaluated" else "calculated",
      if (PermissionStatus == "blocked") "not-evaluated" else "calculated",
      if (SeismicStatus == "blocked") "not-evaluated" else "calculated",
      if (JointingCheckStatus == "blocked") "not-evaluated" else "calculated",
      if (OpeningCheckStatus == "blocked") "not-evaluated" else "calculated",
      "not-evaluated", "not-evaluated", "not-evaluated"
    ),
    checkStatus = c(
      MinimumStrengthStatus, ClassificationStatus, PermissionStatus,
      SeismicStatus, JointingCheckStatus, OpeningCheckStatus,
      "blocked", "blocked", "blocked"
    ),
    blockReason = c(
      "",
      ClassificationReason,
      PermissionReason,
      if (SeismicStatus == "blocked") "seismic-design-category-not-characterized" else "",
      if (JointingCheckStatus == "blocked") "jointing-not-characterized" else "",
      if (OpeningCheckStatus == "blocked") "opening-condition-not-characterized" else "",
      "global-shell-stability-not-evaluated",
      "exposure-classes-not-provided",
      "service-inputs-not-provided"
    ),
    stringsAsFactors = FALSE
  )
  GateFailed <- GateChecks$checkStatus == "not-satisfied"
  ApplicabilityBlocked <- GateChecks$checkID %in% c(
    "structural-classification", "plain-concrete-permission"
  ) & GateChecks$checkStatus == "blocked"
  NormativeStatus <- if (any(ApplicabilityBlocked)) {
    "not-evaluated"
  } else if (LocalStrengthStatus == "not-satisfied" ||
      any(GateFailed)) {
    "not-satisfied"
  } else if (LocalStrengthStatus == "not-evaluated" ||
      any(GateChecks$checkStatus == "blocked")) {
    "not-evaluated"
  } else {
    "satisfied"
  }

  list(
    actions = actions,
    rowChecks = RowChecks,
    checks = GoverningChecks,
    gateChecks = GateChecks,
    section = data.frame(
      specifiedThicknessMm = ThicknessSpecified,
      designThicknessMm = Thickness,
      stripWidthMm = Width,
      grossAreaMm2 = Area,
      sectionModulusMm3 = SectionModulus,
      castAgainstSoil = castAgainstSoil,
      compressionLengthMm = compressionLengthMm,
      stringsAsFactors = FALSE
    ),
    capacities = data.frame(
      compressiveStrengthMPa = ConcreteStrength,
      lambda = Lambda,
      strengthReductionFactor = Phi,
      nominalMomentTensionKnM = NominalMomentTension / 1e6,
      nominalMomentCompressionKnM = NominalMomentCompression / 1e6,
      designMomentKnM = Phi * min(
        NominalMomentTension,
        NominalMomentCompression
      ) / 1e6,
      designAxialKn = DesignAxialKn,
      designShearKn = DesignShearKn,
      stringsAsFactors = FALSE
    ),
    controls = data.frame(
      standardID = "ACI-318-25",
      controlID = "local-strength-numerical-control",
      convergenceRelativeDifference = NA_real_,
      convergenceTolerance = NA_real_,
      convergenceStatus = "not-applicable",
      strengthReductionRuleID = "ACI-318-25-21.2.1-plain-phi-0.60",
      strengthReductionStatus = "applied",
      axialLimitStatus = "not-applicable",
      sourceLocator = "ACI CODE-318-25 SI, Table 21.2.1",
      stringsAsFactors = FALSE
    ),
    summary = data.frame(
      standardSetID = "aci-318-25-plain-concrete",
      concreteTypeID = "plain-concrete",
      localStrengthStatus = LocalStrengthStatus,
      normativeStatus = NormativeStatus,
      governingCheckID = if (is.na(GoverningIndex)) {
        ""
      } else {
        GoverningChecks$checkID[GoverningIndex]
      },
      governingUtilization = if (is.na(GoverningIndex)) {
        NA_real_
      } else {
        GoverningChecks$utilization[GoverningIndex]
      },
      structuralClassificationID = structuralClassificationID,
      plainConcretePermissionBasisID = plainConcretePermissionBasisID,
      seismicDesignCategoryID = seismicDesignCategoryID,
      jointingStatus = jointingStatus,
      openingStatus = openingStatus,
      stringsAsFactors = FALSE
    )
  )
}

evaluateAciShotcrete <- function(
  normalForceKnPerM,
  bendingMomentKnMPerM,
  shearForceKnPerM,
  stripWidthM,
  thetaRad,
  thetaDeg,
  combinationID,
  stageID,
  forceEffectStatus,
  interfaceID,
  thicknessMm,
  compressiveStrengthMPa,
  concreteTypeID,
  circumferentialAreaMm2,
  longitudinalAreaMm2,
  reinforcementGradeID,
  standardSetID,
  shellClassificationStatus,
  longitudinalBoundaryConditionID,
  castAgainstSoil,
  lambda = 1,
  compressionLengthMm = NA_real_,
  structuralClassificationID = "not-characterized",
  plainConcretePermissionBasisID = "not-characterized",
  seismicDesignCategoryID = "not-characterized",
  jointingStatus = "not-characterized",
  openingStatus = "not-characterized",
  circumferentialReinforcement = NULL,
  orthogonalReinforcement = NULL,
  convergenceTolerance = 1e-3,
  sectionDomains = NULL
) {
  .concreteTextScalar(standardSetID, "standardSetID")
  .concreteTextScalar(concreteTypeID, "concreteTypeID")
  ExpectedStandardSetID <- switch(
    concreteTypeID,
    "plain-concrete" = "aci-318-25-plain-concrete",
    "reinforced-concrete" =
      "aci-318.2-14-aci-318-25-reinforced-flexure",
    stop(
      "concreteTypeID must be plain-concrete or reinforced-concrete.",
      call. = FALSE
    )
  )
  if (standardSetID != ExpectedStandardSetID) {
    stop(
      "standardSetID must be ", ExpectedStandardSetID, ".",
      call. = FALSE
    )
  }
  Actions <- mapAciShellActions(
    normalForceKnPerM = normalForceKnPerM,
    bendingMomentKnMPerM = bendingMomentKnMPerM,
    shearForceKnPerM = shearForceKnPerM,
    stripWidthM = stripWidthM,
    thetaRad = thetaRad,
    thetaDeg = thetaDeg,
    combinationID = combinationID,
    stageID = stageID,
    forceEffectStatus = forceEffectStatus,
    interfaceID = interfaceID
  )
  if (standardSetID == "aci-318-25-plain-concrete") {
    return(evaluateAci31825PlainConcreteStrip(
      actions = Actions,
      specifiedThicknessMm = thicknessMm,
      stripWidthMm = 1000 * stripWidthM,
      compressiveStrengthMPa = compressiveStrengthMPa,
      lambda = lambda,
      castAgainstSoil = castAgainstSoil,
      compressionLengthMm = compressionLengthMm,
      structuralClassificationID = structuralClassificationID,
      plainConcretePermissionBasisID = plainConcretePermissionBasisID,
      seismicDesignCategoryID = seismicDesignCategoryID,
      jointingStatus = jointingStatus,
      openingStatus = openingStatus
    ))
  }
  if (
    standardSetID ==
      "aci-318.2-14-aci-318-25-reinforced-flexure"
  ) {
    if (!is.data.frame(circumferentialReinforcement) ||
        !is.data.frame(orthogonalReinforcement)) {
      stop(
        paste(
          "The reinforced ACI branch requires circumferential and",
          "orthogonal reinforcement tables."
        ),
        call. = FALSE
      )
    }
    return(evaluateAci31825ReinforcedShellStrip(
      actions = Actions,
      thicknessMm = thicknessMm,
      stripWidthMm = 1000 * stripWidthM,
      compressiveStrengthMPa = compressiveStrengthMPa,
      circumferentialReinforcement = circumferentialReinforcement,
      orthogonalReinforcement = orthogonalReinforcement,
      convergenceTolerance = convergenceTolerance,
      shellClassificationStatus = shellClassificationStatus,
      longitudinalBoundaryConditionID = longitudinalBoundaryConditionID,
      seismicDesignCategoryID = seismicDesignCategoryID,
      jointingStatus = jointingStatus,
      openingStatus = openingStatus,
      sectionDomains = sectionDomains
    ))
  }
  stop("The validated standardSetID was not dispatched.", call. = FALSE)
}
