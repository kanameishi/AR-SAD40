# Evaluate the reproduced AASHTO LRFD Section 12.7 conduit controls.
#
# The evaluator separates numerical checks from normative applicability. It
# never derives a current-edition compliance statement from a reference-basis
# calculation.

.aashtoRequireObject <- function(value, name) {
  if (!is.list(value) || is.null(names(value))) {
    stop(name, " must be one named list.", call. = FALSE)
  }
  value
}

.aashtoRequireFields <- function(value, fields, name) {
  Missing <- setdiff(fields, names(value))
  if (length(Missing) > 0L) {
    stop(
      name, " is missing: ", paste(Missing, collapse = ", "), ".",
      call. = FALSE
    )
  }
  invisible(value)
}

.aashtoText <- function(value, name) {
  if (!is.character(value) || length(value) != 1L || !nzchar(value)) {
    stop(name, " must be one non-empty string.", call. = FALSE)
  }
  value
}

.aashtoNumber <- function(value, name, minimum = 0, strict = TRUE) {
  if (!is.numeric(value) || length(value) != 1L || !is.finite(value)) {
    stop(name, " must be one finite number.", call. = FALSE)
  }
  Outside <- if (strict) value <= minimum else value < minimum
  if (Outside) {
    Relation <- if (strict) "greater than" else "at least"
    stop(name, " must be ", Relation, " ", minimum, ".", call. = FALSE)
  }
  as.numeric(value)
}

.calculateAashto127Buckling <- function(
  spanM,
  gyrationRadiusMm,
  elasticModulusMPa,
  tensileStrengthMPa,
  soilStiffnessFactor
) {
  SpanMm <- 1000 * spanM
  Slenderness <- soilStiffnessFactor * SpanMm / gyrationRadiusMm
  TransitionSpanM <- gyrationRadiusMm / soilStiffnessFactor *
    sqrt(24 * elasticModulusMPa / tensileStrengthMPa) / 1000
  if (spanM <= TransitionSpanM) {
    BranchID <- "inelastic"
    CriticalStressMPa <- tensileStrengthMPa -
      tensileStrengthMPa^2 / (48 * elasticModulusMPa) * Slenderness^2
  } else {
    BranchID <- "elastic"
    CriticalStressMPa <- 12 * elasticModulusMPa / Slenderness^2
  }
  if (!is.finite(CriticalStressMPa) || CriticalStressMPa <= 0) {
    stop("The buckling equation produced a non-positive stress.", call. = FALSE)
  }
  list(
    branchID = BranchID,
    slenderness = Slenderness,
    transitionSpanM = TransitionSpanM,
    criticalStressMPa = CriticalStressMPa
  )
}

.calculateAashto127Flexibility <- function(
  spanM,
  elasticModulusMPa,
  inertiaMm4PerMm
) {
  (1000 * spanM)^2 / (elasticModulusMPa * inertiaMm4PerMm)
}

.aashtoCheckRow <- function(
  checkID,
  observedValue,
  limitValue,
  unit,
  sourceKey,
  sourceLocator,
  specificationVerified,
  utilizationTolerance,
  applicable = TRUE
) {
  if (!is.logical(applicable) || length(applicable) != 1L ||
      is.na(applicable)) {
    stop("applicable must be TRUE or FALSE.", call. = FALSE)
  }
  if (!is.logical(specificationVerified) ||
      length(specificationVerified) != 1L || is.na(specificationVerified)) {
    stop("specificationVerified must be TRUE or FALSE.", call. = FALSE)
  }
  if (applicable) {
    .aashtoNumber(observedValue, "observedValue", strict = FALSE)
    .aashtoNumber(limitValue, "limitValue")
    Utilization <- observedValue / limitValue
    CheckStatus <- if (Utilization <= 1 + utilizationTolerance) {
      "satisfied"
    } else {
      "not-satisfied"
    }
    NormativeStatus <- if (specificationVerified) {
      CheckStatus
    } else {
      "not-evaluated-specification"
    }
  } else {
    observedValue <- NA_real_
    limitValue <- NA_real_
    Utilization <- NA_real_
    CheckStatus <- "not-evaluated"
    NormativeStatus <- "not-evaluated-inputs"
  }
  data.frame(
    checkID = checkID,
    observedValue = observedValue,
    limitValue = limitValue,
    unit = unit,
    utilization = Utilization,
    checkStatus = CheckStatus,
    normativeStatus = NormativeStatus,
    sourceKey = sourceKey,
    sourceLocator = sourceLocator,
    stringsAsFactors = FALSE
  )
}

evaluateAashto127CorrugatedConduit <- function(
  demand,
  section,
  material,
  specification,
  seam = NULL
) {
  Demand <- .aashtoRequireObject(demand, "demand")
  Section <- .aashtoRequireObject(section, "section")
  Material <- .aashtoRequireObject(material, "material")
  Specification <- .aashtoRequireObject(specification, "specification")
  .aashtoRequireFields(
    Demand,
    c(
      "designThrustKnPerM", "combinationID", "stageID",
      "forceEffectStatus", "demandBasisID", "sourceKey", "sourceLocator"
    ),
    "demand"
  )
  .aashtoRequireFields(
    Section,
    c(
      "structuralProductID", "productTypeID", "shapeID", "spanM",
      "corrugationProfileID", "referenceRowID", "specifiedThicknessMm",
      "designBaseThicknessMm", "remainingBaseThicknessMm",
      "areaMm2PerMm", "inertiaMm4PerMm", "coverCrownM", "sourceKey",
      "sourceLocator"
    ),
    "section"
  )
  .aashtoRequireFields(
    Material,
    c(
      "materialID", "yieldStrengthMPa", "tensileStrengthMPa",
      "elasticModulusMPa", "sourceKey", "sourceLocator"
    ),
    "material"
  )
  .aashtoRequireFields(
    Specification,
    c(
      "standardID", "editionID", "errataID", "branchID",
      "productTypeID", "sourceBasisID", "specificationStatus",
      "editionStatus", "errataStatus", "productApplicabilityStatus",
      "wallResistanceFactor", "wallSourceKey", "wallSourceLocator",
      "seamResistanceFactor", "seamFactorSourceKey",
      "seamFactorSourceLocator", "utilizationTolerance",
      "soilStiffnessFactor", "soilSourceKey",
      "soilSourceLocator", "flexibilityLimitMmPerN",
      "flexibilitySourceKey", "flexibilitySourceLocator",
      "minimumCoverSourceKey", "minimumCoverSourceLocator"
    ),
    "specification"
  )

  for (Field in c(
    "combinationID", "stageID", "forceEffectStatus", "demandBasisID",
    "sourceKey", "sourceLocator"
  )) {
    .aashtoText(Demand[[Field, exact = TRUE]], paste0("demand.", Field))
  }
  if (Demand[["forceEffectStatus", exact = TRUE]] != "lrfd-factored") {
    stop("demand.forceEffectStatus must be lrfd-factored.", call. = FALSE)
  }
  DesignThrust <- .aashtoNumber(
    Demand[["designThrustKnPerM", exact = TRUE]],
    "demand.designThrustKnPerM",
    strict = FALSE
  )

  for (Field in c(
    "structuralProductID", "productTypeID", "shapeID",
    "corrugationProfileID", "referenceRowID", "sourceKey", "sourceLocator"
  )) {
    .aashtoText(Section[[Field, exact = TRUE]], paste0("section.", Field))
  }
  if (Section[["shapeID", exact = TRUE]] != "round") {
    stop("section.shapeID must be round for this evaluator.", call. = FALSE)
  }
  SpanM <- .aashtoNumber(Section[["spanM", exact = TRUE]], "section.spanM")
  for (Field in c(
    "specifiedThicknessMm", "designBaseThicknessMm",
    "remainingBaseThicknessMm", "areaMm2PerMm", "inertiaMm4PerMm"
  )) {
    .aashtoNumber(Section[[Field, exact = TRUE]], paste0("section.", Field))
  }
  Area <- Section[["areaMm2PerMm", exact = TRUE]]
  Inertia <- Section[["inertiaMm4PerMm", exact = TRUE]]
  GyrationRadius <- sqrt(Inertia / Area)

  for (Field in c("materialID", "sourceKey", "sourceLocator")) {
    .aashtoText(Material[[Field, exact = TRUE]], paste0("material.", Field))
  }
  for (Field in c(
    "yieldStrengthMPa", "tensileStrengthMPa", "elasticModulusMPa"
  )) {
    .aashtoNumber(Material[[Field, exact = TRUE]], paste0("material.", Field))
  }

  for (Field in c(
    "standardID", "editionID", "errataID", "branchID", "productTypeID",
    "sourceBasisID", "specificationStatus", "editionStatus", "errataStatus",
    "productApplicabilityStatus", "wallSourceKey", "wallSourceLocator",
    "seamFactorSourceKey", "seamFactorSourceLocator", "soilSourceKey",
    "soilSourceLocator", "flexibilitySourceKey", "flexibilitySourceLocator",
    "minimumCoverSourceKey", "minimumCoverSourceLocator"
  )) {
    .aashtoText(
      Specification[[Field, exact = TRUE]],
      paste0("specification.", Field)
    )
  }
  if (Specification[["branchID", exact = TRUE]] != "12.7") {
    stop("specification.branchID must be 12.7.", call. = FALSE)
  }
  if (!identical(
    Specification[["productTypeID", exact = TRUE]],
    Section[["productTypeID", exact = TRUE]]
  )) {
    stop("Specification and section product types differ.", call. = FALSE)
  }
  for (Field in c(
    "editionStatus", "errataStatus", "productApplicabilityStatus"
  )) {
    if (!(Specification[[Field, exact = TRUE]] %in% c(
      "verified", "not-verified"
    ))) {
      stop("specification.", Field, " is not recognized.", call. = FALSE)
    }
  }
  if (!(Specification[["specificationStatus", exact = TRUE]] %in% c(
    "verified-current-edition", "reference-basis-not-current"
  ))) {
    stop("specification.specificationStatus is not recognized.", call. = FALSE)
  }
  GateStatus <- c(
    Specification[["editionStatus", exact = TRUE]],
    Specification[["errataStatus", exact = TRUE]],
    Specification[["productApplicabilityStatus", exact = TRUE]]
  )
  SpecificationVerified <-
    Specification[["specificationStatus", exact = TRUE]] ==
      "verified-current-edition" && all(GateStatus == "verified")
  if (Specification[["specificationStatus", exact = TRUE]] ==
      "verified-current-edition" && !SpecificationVerified) {
    stop(
      "Current-edition status requires verified edition, errata and product.",
      call. = FALSE
    )
  }
  for (Field in c(
    "wallResistanceFactor", "seamResistanceFactor", "soilStiffnessFactor",
    "flexibilityLimitMmPerN"
  )) {
    .aashtoNumber(
      Specification[[Field, exact = TRUE]],
      paste0("specification.", Field)
    )
  }
  UtilizationTolerance <- .aashtoNumber(
    Specification[["utilizationTolerance", exact = TRUE]],
    "specification.utilizationTolerance",
    strict = FALSE
  )
  if (UtilizationTolerance >= 0.05) {
    stop(
      "specification.utilizationTolerance must stay below 0.05.",
      call. = FALSE
    )
  }

  Seam <- seam
  if (!is.null(Seam)) {
    Seam <- .aashtoRequireObject(Seam, "seam")
    .aashtoRequireFields(
      Seam,
      c(
        "seamID", "nominalResistanceKnPerM", "fastenerDiameterMm",
        "fastenerDiameterLossRatio", "sourceKey", "sourceLocator"
      ),
      "seam"
    )
    for (Field in c("seamID", "sourceKey", "sourceLocator")) {
      .aashtoText(Seam[[Field, exact = TRUE]], paste0("seam.", Field))
    }
    .aashtoNumber(
      Seam[["nominalResistanceKnPerM", exact = TRUE]],
      "seam.nominalResistanceKnPerM"
    )
    .aashtoNumber(
      Seam[["fastenerDiameterMm", exact = TRUE]],
      "seam.fastenerDiameterMm"
    )
    DiameterLossRatio <- .aashtoNumber(
      Seam[["fastenerDiameterLossRatio", exact = TRUE]],
      "seam.fastenerDiameterLossRatio",
      strict = FALSE
    )
    if (DiameterLossRatio >= 1) {
      stop("seam.fastenerDiameterLossRatio must be less than 1.", call. = FALSE)
    }
  }
  Buckling <- .calculateAashto127Buckling(
    spanM = SpanM,
    gyrationRadiusMm = GyrationRadius,
    elasticModulusMPa = Material[["elasticModulusMPa", exact = TRUE]],
    tensileStrengthMPa = Material[["tensileStrengthMPa", exact = TRUE]],
    soilStiffnessFactor = Specification[["soilStiffnessFactor", exact = TRUE]]
  )
  YieldResistance <- Specification[["wallResistanceFactor", exact = TRUE]] *
    Area * Material[["yieldStrengthMPa", exact = TRUE]]
  BucklingResistance <- Specification[[
    "wallResistanceFactor",
    exact = TRUE
  ]] * Area * Buckling$criticalStressMPa
  FlexibilityFactor <- .calculateAashto127Flexibility(
    spanM = SpanM,
    elasticModulusMPa = Material[["elasticModulusMPa", exact = TRUE]],
    inertiaMm4PerMm = Inertia
  )
  MinimumCoverM <- max(SpanM / 8, 0.3048)
  SeamAvailable <- !is.null(Seam)
  FastenerDiameterMm <- if (SeamAvailable) {
    Seam[["fastenerDiameterMm", exact = TRUE]]
  } else {
    NA_real_
  }
  FastenerDiameterLossRatio <- if (SeamAvailable) {
    Seam[["fastenerDiameterLossRatio", exact = TRUE]]
  } else {
    NA_real_
  }
  RemainingFastenerDiameterMm <- if (SeamAvailable) {
    FastenerDiameterMm * (1 - FastenerDiameterLossRatio)
  } else {
    NA_real_
  }
  FastenerAreaRatio <- if (SeamAvailable) {
    (RemainingFastenerDiameterMm / FastenerDiameterMm)^2
  } else {
    NA_real_
  }
  CorrodedSeamNominalResistance <- if (SeamAvailable) {
    Seam[["nominalResistanceKnPerM", exact = TRUE]] * FastenerAreaRatio
  } else {
    NA_real_
  }
  SeamResistance <- if (SeamAvailable) {
    Specification[["seamResistanceFactor", exact = TRUE]] *
      CorrodedSeamNominalResistance
  } else {
    NA_real_
  }
  SeamUtilizationAtZeroLoss <- if (SeamAvailable) {
    DesignThrust / (
      Specification[["seamResistanceFactor", exact = TRUE]] *
        Seam[["nominalResistanceKnPerM", exact = TRUE]]
    )
  } else {
    NA_real_
  }
  CriticalFastenerDiameterLossRatio <- if (SeamAvailable) {
    max(0, 1 - sqrt(SeamUtilizationAtZeroLoss))
  } else {
    NA_real_
  }

  Checks <- rbind(
    .aashtoCheckRow(
      checkID = "wall-yield",
      observedValue = DesignThrust,
      limitValue = YieldResistance,
      unit = "kN/m",
      sourceKey = Specification[["wallSourceKey", exact = TRUE]],
      sourceLocator = Specification[["wallSourceLocator", exact = TRUE]],
      specificationVerified = SpecificationVerified,
      utilizationTolerance = UtilizationTolerance
    ),
    .aashtoCheckRow(
      checkID = "wall-buckling",
      observedValue = DesignThrust,
      limitValue = BucklingResistance,
      unit = "kN/m",
      sourceKey = paste(
        Specification[["wallSourceKey", exact = TRUE]],
        Specification[["soilSourceKey", exact = TRUE]],
        sep = ";"
      ),
      sourceLocator = paste(
        Specification[["wallSourceLocator", exact = TRUE]],
        Specification[["soilSourceLocator", exact = TRUE]],
        sep = "; "
      ),
      specificationVerified = SpecificationVerified,
      utilizationTolerance = UtilizationTolerance
    ),
    .aashtoCheckRow(
      checkID = "seam",
      observedValue = DesignThrust,
      limitValue = SeamResistance,
      unit = "kN/m",
      sourceKey = if (SeamAvailable) {
        paste(
          Seam[["sourceKey", exact = TRUE]],
          Specification[["seamFactorSourceKey", exact = TRUE]],
          sep = ";"
        )
      } else {
        "not-provided"
      },
      sourceLocator = if (SeamAvailable) {
        paste(
          Seam[["sourceLocator", exact = TRUE]],
          Specification[["seamFactorSourceLocator", exact = TRUE]],
          sep = "; "
        )
      } else {
        "seam resistance not supplied"
      },
      specificationVerified = SpecificationVerified,
      utilizationTolerance = UtilizationTolerance,
      applicable = SeamAvailable
    ),
    .aashtoCheckRow(
      checkID = "flexibility",
      observedValue = FlexibilityFactor,
      limitValue = Specification[["flexibilityLimitMmPerN", exact = TRUE]],
      unit = "mm/N",
      sourceKey = Specification[["flexibilitySourceKey", exact = TRUE]],
      sourceLocator = Specification[[
        "flexibilitySourceLocator",
        exact = TRUE
      ]],
      specificationVerified = SpecificationVerified,
      utilizationTolerance = UtilizationTolerance
    ),
    .aashtoCheckRow(
      checkID = "minimum-cover",
      observedValue = MinimumCoverM,
      limitValue = Section[["coverCrownM", exact = TRUE]],
      unit = "m",
      sourceKey = Specification[["minimumCoverSourceKey", exact = TRUE]],
      sourceLocator = Specification[[
        "minimumCoverSourceLocator",
        exact = TRUE
      ]],
      specificationVerified = SpecificationVerified,
      utilizationTolerance = UtilizationTolerance,
      applicable = TRUE
    )
  )

  Complete <- all(Checks$checkStatus != "not-evaluated")
  CalculationStatus <- if (!Complete) {
    "incomplete"
  } else if (all(Checks$checkStatus == "satisfied")) {
    "satisfied"
  } else {
    "not-satisfied"
  }
  SystemStatus <- if (!Complete) {
    "not-evaluated-inputs"
  } else if (!SpecificationVerified) {
    "not-evaluated-specification"
  } else {
    CalculationStatus
  }
  WallRows <- Checks$checkID %in% c("wall-yield", "wall-buckling")
  WallStatus <- if (all(Checks$checkStatus[WallRows] == "satisfied")) {
    "satisfied"
  } else {
    "not-satisfied"
  }
  Finite <- is.finite(Checks$utilization)
  GoverningRow <- if (any(Finite)) {
    which.max(ifelse(Finite, Checks$utilization, -Inf))
  } else {
    NA_integer_
  }

  list(
    calculation = data.frame(
      standardID = Specification[["standardID", exact = TRUE]],
      editionID = Specification[["editionID", exact = TRUE]],
      errataID = Specification[["errataID", exact = TRUE]],
      branchID = Specification[["branchID", exact = TRUE]],
      sourceBasisID = Specification[["sourceBasisID", exact = TRUE]],
      structuralProductID = Section[["structuralProductID", exact = TRUE]],
      productTypeID = Section[["productTypeID", exact = TRUE]],
      combinationID = Demand[["combinationID", exact = TRUE]],
      stageID = Demand[["stageID", exact = TRUE]],
      forceEffectStatus = Demand[["forceEffectStatus", exact = TRUE]],
      demandBasisID = Demand[["demandBasisID", exact = TRUE]],
      designThrustKnPerM = DesignThrust,
      spanM = SpanM,
      areaMm2PerMm = Area,
      inertiaMm4PerMm = Inertia,
      gyrationRadiusMm = GyrationRadius,
      bucklingBranchID = Buckling$branchID,
      bucklingSlenderness = Buckling$slenderness,
      transitionSpanM = Buckling$transitionSpanM,
      criticalBucklingStressMPa = Buckling$criticalStressMPa,
      yieldResistanceKnPerM = YieldResistance,
      bucklingResistanceKnPerM = BucklingResistance,
      referenceSeamNominalResistanceKnPerM = if (SeamAvailable) {
        Seam[["nominalResistanceKnPerM", exact = TRUE]]
      } else {
        NA_real_
      },
      fastenerDiameterMm = FastenerDiameterMm,
      fastenerDiameterLossRatio = FastenerDiameterLossRatio,
      remainingFastenerDiameterMm = RemainingFastenerDiameterMm,
      fastenerAreaRatio = FastenerAreaRatio,
      corrodedSeamNominalResistanceKnPerM = CorrodedSeamNominalResistance,
      factoredSeamResistanceKnPerM = SeamResistance,
      seamUtilizationAtZeroLoss = SeamUtilizationAtZeroLoss,
      criticalFastenerDiameterLossRatio = CriticalFastenerDiameterLossRatio,
      flexibilityFactorMmPerN = FlexibilityFactor,
      minimumCoverM = MinimumCoverM,
      specificationStatus = Specification[[
        "specificationStatus",
        exact = TRUE
      ]],
      stringsAsFactors = FALSE
    ),
    checks = Checks,
    summary = data.frame(
      standardID = Specification[["standardID", exact = TRUE]],
      editionID = Specification[["editionID", exact = TRUE]],
      branchID = Specification[["branchID", exact = TRUE]],
      structuralProductID = Section[["structuralProductID", exact = TRUE]],
      calculationStatus = CalculationStatus,
      specificationStatus = Specification[[
        "specificationStatus",
        exact = TRUE
      ]],
      systemStatus = SystemStatus,
      normativeStatus = SystemStatus,
      wallStatus = WallStatus,
      seamStatus = Checks$checkStatus[Checks$checkID == "seam"],
      flexibilityStatus = Checks$checkStatus[
        Checks$checkID == "flexibility"
      ],
      minimumCoverStatus = Checks$checkStatus[
        Checks$checkID == "minimum-cover"
      ],
      governingCheckID = if (is.na(GoverningRow)) {
        NA_character_
      } else {
        Checks$checkID[GoverningRow]
      },
      governingUtilization = if (is.na(GoverningRow)) {
        NA_real_
      } else {
        Checks$utilization[GoverningRow]
      },
      stringsAsFactors = FALSE
    )
  )
}
