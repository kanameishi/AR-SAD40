# Materialize the cover-defined external-interaction calculation as report data.
#
# Schema 3.0.0 owns the cover, ground, interface and corrugated-steel inputs.
# The adapter translates configuration enum values at the boundary, calls the
# existing calculation functions, and writes no structural capacity model.

if (any(!vapply(
  c(
    "evaluateCoverScenario", "selectCorrugatedSection", "buildThetaMesh",
    ".requireFields", ".readText", ".readNumber", ".readNumberArray",
    ".normaliseK0Model", ".adaptCalculationK0State", ".inputRow",
    "calculateSymmetricReinforcementMesh"
  ),
  function(s) exists(s, mode = "function", inherits = TRUE),
  logical(1)
))) {
  stop(
    paste(
      "Source scripts/setup/calculationFunctions.R dependencies and",
      "scripts/R/calculationData.R before scripts/R/coverCalculationData.R."
    ),
    call. = FALSE
  )
}

.normaliseAashtoConfig <- function(value) {
  Aashto <- .requireObject(value, "aashto")
  TextFields <- c(
    "standardID", "editionID", "errataID", "branchID", "productTypeID",
    "sourceBasisID", "specificationStatus", "editionStatus", "errataStatus",
    "productApplicabilityStatus", "demandBasisID", "factorBasisID",
    "combinationID", "stageID", "forceEffectStatus", "demandSourceKey",
    "demandSourceLocator", "materialID", "materialSourceKey",
    "materialSourceLocator", "wallSourceKey", "wallSourceLocator",
    "seamFactorSourceKey", "seamFactorSourceLocator", "soilSourceKey",
    "soilSourceLocator", "flexibilitySourceKey",
    "flexibilitySourceLocator", "minimumCoverSourceKey",
    "minimumCoverSourceLocator"
  )
  PositiveFields <- c(
    "totalUnitWeightKnPerM3", "spanM", "tensileStrengthMPa",
    "deadLoadFactor", "demandModifier", "soilStiffnessFactor",
    "wallResistanceFactor", "seamResistanceFactor",
    "flexibilityLimitMmPerN"
  )
  NonnegativeFields <- c(
    "liveLoadFactor", "liveCrownPressureKPa", "liveLoadedWidthM"
  )
  .requireFields(
    Aashto,
    c(TextFields, PositiveFields, NonnegativeFields),
    optional = "seam",
    path = "aashto"
  )
  OUT <- list()
  for (s in TextFields) {
    OUT[[s]] <- .readText(Aashto, s, "aashto")
  }
  for (s in PositiveFields) {
    OUT[[s]] <- .readNumber(
      Aashto,
      s,
      "aashto",
      minimum = 0,
      strictMinimum = TRUE
    )
  }
  for (s in NonnegativeFields) {
    OUT[[s]] <- .readNumber(Aashto, s, "aashto", minimum = 0)
  }
  if (OUT[["forceEffectStatus", exact = TRUE]] != "lrfd-factored") {
    stop("aashto.forceEffectStatus must be lrfd-factored.", call. = FALSE)
  }
  if (OUT[["branchID", exact = TRUE]] != "12.7") {
    stop("aashto.branchID must be 12.7.", call. = FALSE)
  }
  if (!(OUT[["specificationStatus", exact = TRUE]] %in% c(
    "verified-current-edition", "reference-basis-not-current"
  ))) {
    stop("aashto.specificationStatus is not recognized.", call. = FALSE)
  }
  for (s in c(
    "editionStatus", "errataStatus", "productApplicabilityStatus"
  )) {
    if (!(OUT[[s, exact = TRUE]] %in% c("verified", "not-verified"))) {
      stop("aashto.", s, " is not recognized.", call. = FALSE)
    }
  }

  Seam <- Aashto[["seam", exact = TRUE]]
  if (!is.null(Seam)) {
    Seam <- .requireObject(Seam, "aashto.seam")
    .requireFields(
      Seam,
      c(
        "seamID", "nominalResistanceKnPerM", "fastenerDiameterMm",
        "fastenerDiameterLossRatio", "sourceKey", "sourceLocator"
      ),
      path = "aashto.seam"
    )
    DiameterLossRatio <- .readNumber(
      Seam,
      "fastenerDiameterLossRatio",
      "aashto.seam",
      minimum = 0,
      maximum = 1
    )
    if (DiameterLossRatio >= 1) {
      stop(
        "aashto.seam.fastenerDiameterLossRatio must be less than 1.",
        call. = FALSE
      )
    }
    Seam <- list(
      seamID = .readText(Seam, "seamID", "aashto.seam"),
      nominalResistanceKnPerM = .readNumber(
        Seam,
        "nominalResistanceKnPerM",
        "aashto.seam",
        minimum = 0,
        strictMinimum = TRUE
      ),
      fastenerDiameterMm = .readNumber(
        Seam,
        "fastenerDiameterMm",
        "aashto.seam",
        minimum = 0,
        strictMinimum = TRUE
      ),
      fastenerDiameterLossRatio = DiameterLossRatio,
      sourceKey = .readText(Seam, "sourceKey", "aashto.seam"),
      sourceLocator = .readText(
        Seam,
        "sourceLocator",
        "aashto.seam"
      )
    )
  }
  OUT$seam <- Seam
  OUT
}

.normaliseCoverInterfaces <- function(interfaceCases) {
  if (!is.list(interfaceCases) || length(interfaceCases) == 0L) {
    stop("interfaceCases must be a non-empty array.", call. = FALSE)
  }
  LIST <- lapply(seq_along(interfaceCases), function(i) {
    Path <- paste0("interfaceCases[", i, "]")
    Case <- interfaceCases[[i]]
    .requireFields(
      Case,
      c(
        "caseID", "interfaceID", "tangentialMultiplier",
        "comparisonInterfaceID"
      ),
      path = Path
    )
    InterfaceID <- .readText(Case, "interfaceID", Path)
    if (!(InterfaceID %in% c("full-traction", "normal-only"))) {
      stop(
        Path, ".interfaceID must be full-traction or normal-only.",
        call. = FALSE
      )
    }
    TangentialMultiplier <- .readNumber(
      Case,
      "tangentialMultiplier",
      Path,
      minimum = 0,
      maximum = 1
    )
    ExpectedMultiplier <- if (InterfaceID == "full-traction") 1 else 0
    if (TangentialMultiplier != ExpectedMultiplier) {
      stop(
        Path,
        ".tangentialMultiplier is inconsistent with interfaceID.",
        call. = FALSE
      )
    }
    ComparisonInterfaceID <- .readText(
      Case,
      "comparisonInterfaceID",
      Path
    )
    if (!(ComparisonInterfaceID %in% c("full-slip", "no-slip"))) {
      stop(
        Path,
        ".comparisonInterfaceID must be full-slip or no-slip.",
        call. = FALSE
      )
    }
    data.frame(
      caseID = .readText(Case, "caseID", Path),
      interfaceID = InterfaceID,
      tangentialMultiplier = TangentialMultiplier,
      comparisonInterfaceID = ComparisonInterfaceID,
      stringsAsFactors = FALSE
    )
  })
  OUT <- do.call(rbind, LIST)
  if (anyDuplicated(OUT$caseID)) {
    stop("interfaceCases.caseID values must be unique.", call. = FALSE)
  }
  if (anyDuplicated(OUT$interfaceID)) {
    stop("interfaceCases.interfaceID values must be unique.", call. = FALSE)
  }
  if (anyDuplicated(OUT$comparisonInterfaceID)) {
    stop(
      "interfaceCases.comparisonInterfaceID values must be unique.",
      call. = FALSE
    )
  }
  rownames(OUT) <- NULL
  OUT
}

.normaliseCoverAciStrengthCases <- function(value, path) {
  if (!is.list(value) || length(value) == 0L) {
    stop(path, " must be a non-empty array.", call. = FALSE)
  }
  Rows <- lapply(seq_along(value), function(i) {
    CasePath <- paste0(path, "[", i, "]")
    Case <- .requireObject(value[[i]], CasePath)
    .requireFields(
      Case,
      c(
        "caseID", "combinationID", "verticalStressFactor",
        "horizontalStressFactor", "forceEffectStatus",
        "loadCombinationBasisID", "sourceLocator"
      ),
      path = CasePath
    )
    ForceEffectStatus <- .readText(Case, "forceEffectStatus", CasePath)
    if (ForceEffectStatus != "lrfd-factored") {
      stop(CasePath, ".forceEffectStatus must be lrfd-factored.", call. = FALSE)
    }
    data.frame(
      caseID = .readText(Case, "caseID", CasePath),
      combinationID = .readText(Case, "combinationID", CasePath),
      verticalStressFactor = .readNumber(
        Case,
        "verticalStressFactor",
        CasePath,
        minimum = 0,
        strictMinimum = TRUE
      ),
      horizontalStressFactor = .readNumber(
        Case,
        "horizontalStressFactor",
        CasePath,
        minimum = 0,
        strictMinimum = TRUE
      ),
      forceEffectStatus = ForceEffectStatus,
      loadCombinationBasisID = .readText(
        Case,
        "loadCombinationBasisID",
        CasePath
      ),
      sourceLocator = .readText(Case, "sourceLocator", CasePath),
      stringsAsFactors = FALSE
    )
  })
  OUT <- do.call(rbind, Rows)
  rownames(OUT) <- NULL
  if (anyDuplicated(OUT$caseID) || anyDuplicated(OUT$combinationID)) {
    stop(path, " identifiers must be unique.", call. = FALSE)
  }
  OUT
}

.normaliseCoverAciConfig <- function(value, path, concreteTypeID) {
  if (is.null(value)) return(NULL)
  Aci <- .requireObject(value, path)
  Required <- c(
    "standardSetID", "structuralClassificationID",
    "seismicDesignCategoryID", "jointingStatus", "openingStatus",
    "concreteDensityClassID", "lambda", "castAgainstSoil", "sourceKey",
    "sourceLocator", "strengthCases"
  )
  .requireFields(
    Aci,
    Required,
    optional = c(
      "compressionLengthMm", "plainConcretePermissionBasisID",
      "shellClassificationStatus", "longitudinalBoundaryConditionID"
    ),
    path = path
  )
  StandardSetID <- .readText(Aci, "standardSetID", path)
  if (concreteTypeID == "plain-concrete" &&
      StandardSetID != "aci-318-25-plain-concrete") {
    stop(
      path,
      ".standardSetID must be aci-318-25-plain-concrete.",
      call. = FALSE
    )
  }
  if (concreteTypeID == "reinforced-concrete" &&
      StandardSetID !=
        "aci-318.2-14-aci-318-25-reinforced-flexure") {
    stop(
      path,
      paste(
        ".standardSetID must be",
        "aci-318.2-14-aci-318-25-reinforced-flexure."
      ),
      call. = FALSE
    )
  }
  CastAgainstSoil <- Aci[["castAgainstSoil", exact = TRUE]]
  if (!is.logical(CastAgainstSoil) || length(CastAgainstSoil) != 1L ||
      is.na(CastAgainstSoil)) {
    stop(path, ".castAgainstSoil must be true or false.", call. = FALSE)
  }
  DensityClassID <- .readText(Aci, "concreteDensityClassID", path)
  Lambda <- .readNumber(
    Aci,
    "lambda",
    path,
    minimum = 0,
    maximum = 1,
    strictMinimum = TRUE
  )
  if (DensityClassID == "normal-weight" && Lambda != 1) {
    stop(path, ".lambda must equal 1 for normal-weight concrete.", call. = FALSE)
  }
  CompressionLength <- if (
    "compressionLengthMm" %in% names(Aci)
  ) {
    .readNumber(Aci, "compressionLengthMm", path, minimum = 0)
  } else {
    NA_real_
  }
  JointingStatus <- .readText(Aci, "jointingStatus", path)
  if (!(JointingStatus %in% c(
    "requirements-satisfied", "requirements-not-satisfied",
    "not-characterized"
  ))) {
    stop(path, ".jointingStatus is not supported.", call. = FALSE)
  }
  OpeningStatus <- .readText(Aci, "openingStatus", path)
  if (!(OpeningStatus %in% c(
    "none", "requirements-satisfied", "requirements-not-satisfied",
    "not-characterized"
  ))) {
    stop(path, ".openingStatus is not supported.", call. = FALSE)
  }
  PlainPermission <- if (concreteTypeID == "plain-concrete") {
    if (!("plainConcretePermissionBasisID" %in% names(Aci))) {
      stop(
        path,
        ".plainConcretePermissionBasisID is required for plain-concrete.",
        call. = FALSE
      )
    }
    .readText(Aci, "plainConcretePermissionBasisID", path)
  } else {
    "not-applicable"
  }
  ShellClassification <- if (concreteTypeID == "reinforced-concrete") {
    if (!("shellClassificationStatus" %in% names(Aci))) {
      stop(
        path,
        ".shellClassificationStatus is required for reinforced-concrete.",
        call. = FALSE
      )
    }
    Status <- .readText(Aci, "shellClassificationStatus", path)
    if (!(Status %in% c("applicable", "unknown"))) {
      stop(path, ".shellClassificationStatus is not supported.", call. = FALSE)
    }
    Status
  } else {
    "not-applicable"
  }
  LongitudinalBoundary <- if (concreteTypeID == "reinforced-concrete") {
    if (!("longitudinalBoundaryConditionID" %in% names(Aci))) {
      stop(
        path,
        paste(
          ".longitudinalBoundaryConditionID is required for",
          "reinforced-concrete."
        ),
        call. = FALSE
      )
    }
    BoundaryID <- .readText(Aci, "longitudinalBoundaryConditionID", path)
    if (!(BoundaryID %in% c(
      "not-characterized", "plane-stress-free-ends"
    ))) {
      stop(
        path,
        ".longitudinalBoundaryConditionID is not supported.",
        call. = FALSE
      )
    }
    BoundaryID
  } else {
    "not-characterized"
  }
  list(
    standardSetID = StandardSetID,
    structuralClassificationID = .readText(
      Aci,
      "structuralClassificationID",
      path
    ),
    plainConcretePermissionBasisID = PlainPermission,
    shellClassificationStatus = ShellClassification,
    longitudinalBoundaryConditionID = LongitudinalBoundary,
    seismicDesignCategoryID = .readText(
      Aci,
      "seismicDesignCategoryID",
      path
    ),
    jointingStatus = JointingStatus,
    openingStatus = OpeningStatus,
    concreteDensityClassID = DensityClassID,
    lambda = Lambda,
    castAgainstSoil = CastAgainstSoil,
    compressionLengthMm = CompressionLength,
    sourceKey = .readText(Aci, "sourceKey", path),
    sourceLocator = .readText(Aci, "sourceLocator", path),
    strengthCases = .normaliseCoverAciStrengthCases(
      Aci[["strengthCases", exact = TRUE]],
      paste0(path, ".strengthCases")
    )
  )
}

.normaliseCoverAdditionalLinings <- function(value) {
  if (is.null(value)) {
    return(list())
  }
  Linings <- .requireObject(value, "additionalLinings")
  LiningIDs <- names(Linings)
  if (length(LiningIDs) == 0L || any(!nzchar(LiningIDs)) ||
      anyDuplicated(LiningIDs)) {
    stop(
      "additionalLinings must have unique non-empty names.",
      call. = FALSE
    )
  }
  OUT <- lapply(seq_along(Linings), function(i) {
    Path <- paste0("additionalLinings.", LiningIDs[i])
    Lining <- .requireObject(Linings[[i]], Path)
    .requireFields(
      Lining,
      c(
        "liningTypeID", "sectionID", "concreteTypeID", "outerRadiusM",
        "thicknessM", "poisson", "compressiveStrengthMPa",
        "modulusModelID", "stiffnessBasisID", "stripWidthM",
        "reinforcement", "convergenceTolerance"
      ),
      optional = c(
        "aci", "reinforcementGradeID", "orthogonalReinforcement",
        "reinforcementLayout", "reinforcementStudy"
      ),
      path = Path
    )
    LiningTypeID <- .readText(Lining, "liningTypeID", Path)
    ConcreteTypeID <- .readText(Lining, "concreteTypeID", Path)
    ModulusModelID <- .readText(Lining, "modulusModelID", Path)
    StiffnessBasisID <- .readText(Lining, "stiffnessBasisID", Path)
    if (LiningTypeID != "shotcrete") {
      stop(Path, ".liningTypeID must be shotcrete.", call. = FALSE)
    }
    if (!(ConcreteTypeID %in% c(
      "plain-concrete", "reinforced-concrete"
    ))) {
      stop(
        Path,
        ".concreteTypeID must be plain-concrete or reinforced-concrete.",
        call. = FALSE
      )
    }
    if (ModulusModelID != "ACI-318-25-normal-weight") {
      stop(
        Path, ".modulusModelID must be ACI-318-25-normal-weight.",
        call. = FALSE
      )
    }
    if (StiffnessBasisID != "gross-uncracked-short-term") {
      stop(
        Path, ".stiffnessBasisID must be gross-uncracked-short-term.",
        call. = FALSE
      )
    }
    OuterRadius <- .readNumber(
      Lining,
      "outerRadiusM",
      Path,
      minimum = 0,
      strictMinimum = TRUE
    )
    Thickness <- .readNumber(
      Lining,
      "thicknessM",
      Path,
      minimum = 0,
      strictMinimum = TRUE
    )
    if (Thickness >= 2 * OuterRadius) {
      stop(Path, ".thicknessM is incompatible with outerRadiusM.", call. = FALSE)
    }
    Poisson <- .readNumber(
      Lining,
      "poisson",
      Path,
      minimum = -1,
      maximum = 0.5,
      strictMinimum = TRUE
    )
    if (Poisson >= 0.5) {
      stop(Path, ".poisson must be less than 0.5.", call. = FALSE)
    }
    ConcreteStrength <- .readNumber(
      Lining,
      "compressiveStrengthMPa",
      Path,
      minimum = 0,
      strictMinimum = TRUE
    )
    Reinforcement <- .normaliseShotcreteReinforcement(
      Lining[["reinforcement", exact = TRUE]]
    )
    OrthogonalReinforcement <- .normaliseShotcreteReinforcement(
      if ("orthogonalReinforcement" %in% names(Lining)) {
        Lining[["orthogonalReinforcement", exact = TRUE]]
      } else {
        list()
      }
    )
    if (ConcreteTypeID == "plain-concrete" &&
        (nrow(Reinforcement) != 0L ||
          nrow(OrthogonalReinforcement) != 0L)) {
      stop(
        Path,
        ".reinforcement tables must be empty for plain-concrete.",
        call. = FALSE
      )
    }
    ReinforcementGradeID <- if (ConcreteTypeID == "reinforced-concrete") {
      if (!("reinforcementGradeID" %in% names(Lining))) {
        stop(
          Path,
          ".reinforcementGradeID is required for reinforced-concrete.",
          call. = FALSE
        )
      }
      GradeID <- .readText(Lining, "reinforcementGradeID", Path)
      if (GradeID != "Grade-60") {
        stop(Path, ".reinforcementGradeID must be Grade-60.", call. = FALSE)
      }
      if (nrow(Reinforcement) == 0L ||
          nrow(OrthogonalReinforcement) == 0L) {
        stop(
          Path,
          paste(
            ".reinforcement and .orthogonalReinforcement must be",
            "non-empty for reinforced-concrete."
          ),
          call. = FALSE
        )
      }
      .validateConcreteReinforcement(Reinforcement, 1000 * Thickness)
      .validateConcreteReinforcement(
        OrthogonalReinforcement,
        1000 * Thickness
      )
      GradeID
    } else {
      "not-applicable"
    }
    ReinforcementLayout <- NULL
    if ("reinforcementLayout" %in% names(Lining)) {
      if (ConcreteTypeID != "reinforced-concrete") {
        stop(
          Path,
          ".reinforcementLayout is only valid for reinforced-concrete.",
          call. = FALSE
        )
      }
      LayoutPath <- paste0(Path, ".reinforcementLayout")
      Layout <- .requireObject(
        Lining[["reinforcementLayout", exact = TRUE]],
        LayoutPath
      )
      .requireFields(
        Layout,
        c("barDiameterMm", "barSpacingMm", "clearCoverRatio"),
        path = LayoutPath
      )
      BarDiameter <- .readNumber(
        Layout,
        "barDiameterMm",
        LayoutPath,
        minimum = 0,
        strictMinimum = TRUE
      )
      BarSpacing <- .readNumber(
        Layout,
        "barSpacingMm",
        LayoutPath,
        minimum = 0,
        strictMinimum = TRUE
      )
      if (BarSpacing <= BarDiameter) {
        stop(
          LayoutPath,
          ".barSpacingMm must exceed barDiameterMm.",
          call. = FALSE
        )
      }
      ClearCoverRatio <- .readNumber(
        Layout,
        "clearCoverRatio",
        LayoutPath,
        minimum = 0,
        maximum = 0.5,
        strictMinimum = TRUE
      )
      if (ClearCoverRatio >= 0.5) {
        stop(LayoutPath, ".clearCoverRatio must be less than 0.5.", call. = FALSE)
      }
      ReinforcementModulus <- unique(c(
        Reinforcement$modulusMPa,
        OrthogonalReinforcement$modulusMPa
      ))
      if (length(ReinforcementModulus) != 1L) {
        stop(
          LayoutPath,
          " requires one reinforcement modulus.",
          call. = FALSE
        )
      }
      Mesh <- calculateSymmetricReinforcementMesh(
        thicknessM = Thickness,
        barDiameterMm = BarDiameter,
        barSpacingMm = BarSpacing,
        clearCoverRatio = ClearCoverRatio,
        reinforcementGradeID = ReinforcementGradeID,
        reinforcementModulusMPa = ReinforcementModulus
      )
      checkLayout <- function(data, expected, directionID) {
        NumericFields <- c(
          "areaMm2", "coordinateMm", "yieldStrengthMPa", "modulusMPa"
        )
        if (nrow(data) != nrow(expected) ||
            !identical(data$layerID, expected$layerID) ||
            !isTRUE(all.equal(
              data[NumericFields],
              expected[NumericFields],
              tolerance = 1e-12,
              check.attributes = FALSE
            ))) {
          stop(
            LayoutPath,
            " is inconsistent with the ",
            directionID,
            " reinforcement records.",
            call. = FALSE
          )
        }
      }
      checkLayout(
        Reinforcement,
        .normaliseShotcreteReinforcement(
          Mesh[["circumferentialReinforcement", exact = TRUE]]
        ),
        "circumferential"
      )
      checkLayout(
        OrthogonalReinforcement,
        .normaliseShotcreteReinforcement(
          Mesh[["orthogonalReinforcement", exact = TRUE]]
        ),
        "orthogonal"
      )
      ReinforcementLayout <- list(
        barDiameterMm = BarDiameter,
        barSpacingMm = BarSpacing,
        clearCoverRatio = ClearCoverRatio,
        clearCoverMm = Mesh[["clearCoverMm", exact = TRUE]],
        layerCentroidCoverMm = Mesh[[
          "layerCentroidCoverMm",
          exact = TRUE
        ]],
        areaMm2PerFaceAndDirection = Mesh[[
          "areaMm2PerFaceAndDirection",
          exact = TRUE
        ]]
      )
    }
    ReinforcementStudy <- NULL
    if ("reinforcementStudy" %in% names(Lining)) {
      if (ConcreteTypeID != "reinforced-concrete") {
        stop(
          Path,
          ".reinforcementStudy is only valid for reinforced-concrete.",
          call. = FALSE
        )
      }
      ReinforcementStudy <- normaliseAci31825ReinforcementStudyPolicy(
        Lining[["reinforcementStudy", exact = TRUE]],
        paste0(Path, ".reinforcementStudy")
      )
    }
    Result <- list(
      liningTypeID = LiningTypeID,
      sectionID = .readText(Lining, "sectionID", Path),
      concreteTypeID = ConcreteTypeID,
      outerRadiusM = OuterRadius,
      centroidalRadiusM = OuterRadius - Thickness / 2,
      poisson = Poisson,
      thicknessM = Thickness,
      youngModulusKPa = calculateAci31825NormalWeightConcreteModulus(
        compressiveStrengthMPa = ConcreteStrength
      ),
      modulusModelID = ModulusModelID,
      stiffnessBasisID = StiffnessBasisID,
      compressiveStrengthMPa = ConcreteStrength,
      stripWidthM = .readNumber(
        Lining,
        "stripWidthM",
        Path,
        minimum = 0,
        strictMinimum = TRUE
      ),
      reinforcement = Reinforcement,
      orthogonalReinforcement = OrthogonalReinforcement,
      reinforcementGradeID = ReinforcementGradeID,
      orthogonalAreaMm2 = if (nrow(OrthogonalReinforcement) == 0L) {
        0
      } else {
        sum(OrthogonalReinforcement$areaMm2)
      },
      convergenceTolerance = .readNumber(
        Lining,
        "convergenceTolerance",
        Path,
        minimum = 0,
        strictMinimum = TRUE
      ),
      aci = .normaliseCoverAciConfig(
        Lining[["aci", exact = TRUE]],
        paste0(Path, ".aci"),
        ConcreteTypeID
      )
    )
    if (!is.null(ReinforcementLayout)) {
      Result[["reinforcementLayout"]] <- ReinforcementLayout
    }
    if (!is.null(ReinforcementStudy)) {
      Result[["reinforcementStudy"]] <- ReinforcementStudy
    }
    Result
  })
  names(OUT) <- LiningIDs
  OUT
}

.normaliseCoverAisiConfig <- function(value) {
  Aisi <- .requireObject(value, "lining.aisi")
  .requireFields(
    Aisi,
    c(
      "capacityTable", "capacityBaseThicknessMm",
      "capacityYieldStrengthMPa", "capacityProfileID",
      "capacityReferenceRowID", "applicability", "settings"
    ),
    path = "lining.aisi"
  )
  Applicability <- .requireObject(
    Aisi[["applicability", exact = TRUE]],
    "lining.aisi.applicability"
  )
  for (Field in c("g4GateStatus", "g4GateEvidenceLocator")) {
    Value <- Applicability[[Field, exact = TRUE]]
    if (is.list(Value) && !is.null(names(Value))) {
      Applicability[[Field]] <- unlist(Value, use.names = TRUE)
    }
  }
  list(
    capacityTable = .readText(Aisi, "capacityTable", "lining.aisi"),
    capacityBaseThicknessMm = .readNumber(
      Aisi,
      "capacityBaseThicknessMm",
      "lining.aisi",
      minimum = 0,
      strictMinimum = TRUE
    ),
    capacityYieldStrengthMPa = .readNumber(
      Aisi,
      "capacityYieldStrengthMPa",
      "lining.aisi",
      minimum = 0,
      strictMinimum = TRUE
    ),
    capacityProfileID = .readText(
      Aisi,
      "capacityProfileID",
      "lining.aisi"
    ),
    capacityReferenceRowID = .readText(
      Aisi,
      "capacityReferenceRowID",
      "lining.aisi"
    ),
    applicability = Applicability,
    settings = .requireObject(
      Aisi[["settings", exact = TRUE]],
      "lining.aisi.settings"
    )
  )
}

validateCoverCalculationConfig <- function(config) {
  .requireFields(
    config,
    c(
      "schemaVersion", "analysisModelID", "scenarioID", "cover", "ground",
      "action", "interfaceCases", "sectionReference", "lining", "numerics",
      "graphics"
    ),
    optional = c("aashto", "additionalLinings"),
    path = "calculation.json"
  )
  SchemaVersion <- .readText(config, "schemaVersion", "calculation.json")
  if (!(SchemaVersion %in% c("3.0.0", "3.1.0"))) {
    stop("Cover calculation schemaVersion is not supported.", call. = FALSE)
  }
  AashtoInput <- config[["aashto", exact = TRUE]]
  if (SchemaVersion == "3.1.0" && is.null(AashtoInput)) {
    stop("Schema 3.1.0 requires aashto.", call. = FALSE)
  }
  if (SchemaVersion == "3.0.0" && !is.null(AashtoInput)) {
    stop("Schema 3.0.0 does not support aashto.", call. = FALSE)
  }
  AnalysisModelID <- .readText(
    config,
    "analysisModelID",
    "calculation.json"
  )
  if (AnalysisModelID != "prescribed-biaxial-direct-integration") {
    stop(
      "Unsupported calculation analysisModelID: ", AnalysisModelID, ".",
      call. = FALSE
    )
  }

  Cover <- config[["cover", exact = TRUE]]
  .requireFields(
    Cover,
    c(
      "coverCrownM", "crownToAxisM", "effectiveUnitWeightKnPerM3",
      "effectiveSurchargeKPa", "referencePositionID"
    ),
    path = "cover"
  )
  ReferencePositionID <- .readText(Cover, "referencePositionID", "cover")
  if (!(ReferencePositionID %in% c("crown", "axis", "invert"))) {
    stop(
      "cover.referencePositionID must be crown, axis or invert.",
      call. = FALSE
    )
  }

  Ground <- config[["ground", exact = TRUE]]
  .requireFields(Ground, c("modulusKPa", "poisson", "k0"), path = "ground")
  GroundPoisson <- .readNumber(
    Ground,
    "poisson",
    "ground",
    minimum = -1,
    maximum = 0.5,
    strictMinimum = TRUE
  )
  if (GroundPoisson >= 0.5) {
    stop("ground.poisson must be less than 0.5.", call. = FALSE)
  }

  Action <- config[["action", exact = TRUE]]
  .requireFields(
    Action,
    c(
      "combinationID", "stageID", "forceEffectStatus",
      "loadCombinationBasisID", "waterPressureDifferenceKPa"
    ),
    path = "action"
  )
  ForceEffectStatus <- .readText(Action, "forceEffectStatus", "action")
  if (!(ForceEffectStatus %in% c(
    "asd-required", "lrfd-factored", "unfactored-reference-state"
  ))) {
    stop("Unsupported action.forceEffectStatus.", call. = FALSE)
  }

  SectionReference <- config[["sectionReference", exact = TRUE]]
  .requireFields(
    SectionReference,
    c("propertyTable", "profileID", "referenceRowID"),
    path = "sectionReference"
  )

  Lining <- config[["lining", exact = TRUE]]
  .requireFields(
    Lining,
    c(
      "liningTypeID", "sectionID", "centroidalRadiusM", "poisson",
      "remainingBaseThicknessMm", "youngModulusKPa", "yieldStrengthMPa"
    ),
    optional = if (SchemaVersion == "3.0.0") "aisi" else character(),
    path = "lining"
  )
  LiningTypeID <- .readText(Lining, "liningTypeID", "lining")
  if (LiningTypeID != "corrugated-steel") {
    stop(
      "Schema 3.0.0 supports lining.liningTypeID = corrugated-steel.",
      call. = FALSE
    )
  }
  LiningPoisson <- .readNumber(
    Lining,
    "poisson",
    "lining",
    minimum = -1,
    maximum = 0.5,
    strictMinimum = TRUE
  )
  if (LiningPoisson >= 0.5) {
    stop("lining.poisson must be less than 0.5.", call. = FALSE)
  }

  Numerics <- config[["numerics", exact = TRUE]]
  .requireFields(
    Numerics,
    c(
      "thetaPointCount", "criticalAnglesDeg", "integrationSteps",
      "balanceTolerance", "closedFormTolerance", "controlTolerance"
    ),
    path = "numerics"
  )
  CriticalAngles <- .readNumberArray(
    Numerics,
    "criticalAnglesDeg",
    "numerics",
    minimum = 0,
    maximum = 360
  )
  if (any(CriticalAngles >= 360) || anyDuplicated(CriticalAngles)) {
    stop(
      "numerics.criticalAnglesDeg must be unique on [0, 360).",
      call. = FALSE
    )
  }

  Graphics <- config[["graphics", exact = TRUE]]
  .requireFields(
    Graphics,
    c("graphicAmplification", "radialFraction", "ordinateCount"),
    path = "graphics"
  )

  list(
    schemaVersion = SchemaVersion,
    analysisModelID = AnalysisModelID,
    scenarioID = .readText(config, "scenarioID", "calculation.json"),
    cover = list(
      coverCrownM = .readNumber(Cover, "coverCrownM", "cover", minimum = 0),
      crownToAxisM = .readNumber(
        Cover,
        "crownToAxisM",
        "cover",
        minimum = 0,
        strictMinimum = TRUE
      ),
      effectiveUnitWeightKnPerM3 = .readNumber(
        Cover,
        "effectiveUnitWeightKnPerM3",
        "cover",
        minimum = 0,
        strictMinimum = TRUE
      ),
      effectiveSurchargeKPa = .readNumber(
        Cover,
        "effectiveSurchargeKPa",
        "cover",
        minimum = 0
      ),
      referencePositionID = ReferencePositionID
    ),
    ground = list(
      modulusKPa = .readNumber(
        Ground,
        "modulusKPa",
        "ground",
        minimum = 0,
        strictMinimum = TRUE
      ),
      poisson = GroundPoisson,
      k0 = .normaliseK0Model(Ground[["k0", exact = TRUE]])
    ),
    action = list(
      combinationID = .readText(Action, "combinationID", "action"),
      stageID = .readText(Action, "stageID", "action"),
      forceEffectStatus = ForceEffectStatus,
      loadCombinationBasisID = .readText(
        Action,
        "loadCombinationBasisID",
        "action"
      ),
      waterPressureDifferenceKPa = .readNumber(
        Action,
        "waterPressureDifferenceKPa",
        "action"
      )
    ),
    interfaceCases = .normaliseCoverInterfaces(
      config[["interfaceCases", exact = TRUE]]
    ),
    sectionReference = list(
      propertyTable = .readText(
        SectionReference,
        "propertyTable",
        "sectionReference"
      ),
      profileID = .readText(SectionReference, "profileID", "sectionReference"),
      referenceRowID = .readText(
        SectionReference,
        "referenceRowID",
        "sectionReference"
      )
    ),
    lining = c(
      list(
        liningTypeID = LiningTypeID,
        sectionID = .readText(Lining, "sectionID", "lining"),
        centroidalRadiusM = .readNumber(
          Lining,
          "centroidalRadiusM",
          "lining",
          minimum = 0,
          strictMinimum = TRUE
        ),
        poisson = LiningPoisson,
        remainingBaseThicknessMm = .readNumber(
          Lining,
          "remainingBaseThicknessMm",
          "lining",
          minimum = 0,
          strictMinimum = TRUE
        ),
        youngModulusKPa = .readNumber(
          Lining,
          "youngModulusKPa",
          "lining",
          minimum = 0,
          strictMinimum = TRUE
        ),
        yieldStrengthMPa = .readNumber(
          Lining,
          "yieldStrengthMPa",
          "lining",
          minimum = 0,
          strictMinimum = TRUE
        )
      ),
      if (is.null(Lining[["aisi", exact = TRUE]])) {
        list()
      } else {
        list(aisi = .normaliseCoverAisiConfig(
          Lining[["aisi", exact = TRUE]]
        ))
      }
    ),
    aashto = if (SchemaVersion == "3.1.0") {
      .normaliseAashtoConfig(AashtoInput)
    } else {
      NULL
    },
    additionalLinings = .normaliseCoverAdditionalLinings(
      config[["additionalLinings", exact = TRUE]]
    ),
    numerics = list(
      thetaPointCount = .readNumber(
        Numerics,
        "thetaPointCount",
        "numerics",
        minimum = 3,
        integer = TRUE
      ),
      criticalAnglesDeg = CriticalAngles,
      integrationSteps = .readNumber(
        Numerics,
        "integrationSteps",
        "numerics",
        minimum = 128,
        integer = TRUE
      ),
      balanceTolerance = .readNumber(
        Numerics,
        "balanceTolerance",
        "numerics",
        minimum = 0,
        strictMinimum = TRUE
      ),
      closedFormTolerance = .readNumber(
        Numerics,
        "closedFormTolerance",
        "numerics",
        minimum = 0,
        strictMinimum = TRUE
      ),
      controlTolerance = .readNumber(
        Numerics,
        "controlTolerance",
        "numerics",
        minimum = 0,
        strictMinimum = TRUE
      )
    ),
    graphics = list(
      graphicAmplification = .readNumber(
        Graphics,
        "graphicAmplification",
        "graphics",
        minimum = 0,
        strictMinimum = TRUE
      ),
      radialFraction = .readNumber(
        Graphics,
        "radialFraction",
        "graphics",
        minimum = 0,
        strictMinimum = TRUE
      ),
      ordinateCount = .readNumber(
        Graphics,
        "ordinateCount",
        "graphics",
        minimum = 1,
        integer = TRUE
      )
    )
  )
}

.readCoverSectionReference <- function(config, projectRoot) {
  SectionConfig <- config[["sectionReference", exact = TRUE]]
  Path <- file.path(
    projectRoot,
    SectionConfig[["propertyTable", exact = TRUE]]
  )
  if (!file.exists(Path)) {
    stop("The corrugation property table is not available: ", Path, call. = FALSE)
  }
  Reference <- utils::read.csv(
    Path,
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  selectCorrugatedSection(
    reference = Reference,
    profileID = SectionConfig[["profileID", exact = TRUE]],
    referenceRowID = SectionConfig[["referenceRowID", exact = TRUE]]
  )
}

.readCoverAisiInput <- function(config, projectRoot) {
  Aisi <- config[["lining", exact = TRUE]][["aisi", exact = TRUE]]
  if (is.null(Aisi)) {
    return(NULL)
  }
  CapacityPath <- file.path(
    projectRoot,
    Aisi[["capacityTable", exact = TRUE]]
  )
  if (!file.exists(CapacityPath)) {
    stop("The AISI capacity table is not available: ", CapacityPath,
         call. = FALSE)
  }
  Capacities <- utils::read.csv(
    CapacityPath,
    check.names = FALSE,
    stringsAsFactors = FALSE,
    na.strings = ""
  )
  list(
    capacityBaseThicknessMm =
      Aisi[["capacityBaseThicknessMm", exact = TRUE]],
    capacityYieldStrengthMPa =
      Aisi[["capacityYieldStrengthMPa", exact = TRUE]],
    capacityProfileID = Aisi[["capacityProfileID", exact = TRUE]],
    capacityReferenceRowID =
      Aisi[["capacityReferenceRowID", exact = TRUE]],
    capacities = Capacities,
    applicability = Aisi[["applicability", exact = TRUE]],
    settings = Aisi[["settings", exact = TRUE]]
  )
}

.coverInterfaceAPI <- function(interfaceID) {
  switch(
    interfaceID,
    "full-traction" = "fullTraction",
    "normal-only" = "normalOnly",
    stop("Unsupported interfaceID: ", interfaceID, ".", call. = FALSE)
  )
}

.coverComparisonInterfaceAPI <- function(interfaceID) {
  switch(
    interfaceID,
    "full-slip" = "fullSlip",
    "no-slip" = "noSlip",
    stop(
      "Unsupported comparisonInterfaceID: ",
      interfaceID,
      ".",
      call. = FALSE
    )
  )
}

.buildCoverScenario <- function(config, case, aisiInput = NULL) {
  SectionReference <- config[["sectionReference", exact = TRUE]]
  Lining <- config[["lining", exact = TRUE]]
  Lining$aisi <- NULL
  Lining$referenceProfileID <- SectionReference[["profileID", exact = TRUE]]
  Lining$referenceRowID <- SectionReference[["referenceRowID", exact = TRUE]]
  if (!is.null(aisiInput)) {
    Lining$aisi <- aisiInput
  }
  list(
    scenarioID = paste(
      config[["scenarioID", exact = TRUE]],
      case[["caseID", exact = TRUE]],
      sep = "--"
    ),
    cover = config[["cover", exact = TRUE]],
    ground = config[["ground", exact = TRUE]],
    interfaceID = .coverInterfaceAPI(case[["interfaceID", exact = TRUE]]),
    comparisonInterfaceID = .coverComparisonInterfaceAPI(
      case[["comparisonInterfaceID", exact = TRUE]]
    ),
    tangentialMultiplier = case[["tangentialMultiplier", exact = TRUE]],
    action = config[["action", exact = TRUE]],
    numerics = config[["numerics", exact = TRUE]],
    lining = Lining
  )
}

.buildCoverInputs <- function(config) {
  ScenarioID <- config[["scenarioID", exact = TRUE]]
  Cover <- config[["cover", exact = TRUE]]
  Ground <- config[["ground", exact = TRUE]]
  Action <- config[["action", exact = TRUE]]
  Section <- config[["sectionReference", exact = TRUE]]
  Lining <- config[["lining", exact = TRUE]]
  Numerics <- config[["numerics", exact = TRUE]]
  Graphics <- config[["graphics", exact = TRUE]]
  Rows <- list(
    .inputRow(ScenarioID, NA, "model", "analysis-model", "model", textValue = config[["analysisModelID", exact = TRUE]], evidenceLevel = "HA", conditionCode = "selected-model"),
    .inputRow(ScenarioID, NA, "cover", "cover-at-crown", "H", Cover[["coverCrownM", exact = TRUE]], unit = "m", evidenceLevel = "HA", conditionCode = "scenario-input"),
    .inputRow(ScenarioID, NA, "cover", "crown-to-axis", "R_c", Cover[["crownToAxisM", exact = TRUE]], unit = "m", evidenceLevel = "HA", conditionCode = "scenario-input"),
    .inputRow(ScenarioID, NA, "cover", "effective-unit-weight", "gamma'", Cover[["effectiveUnitWeightKnPerM3", exact = TRUE]], unit = "kN/m3", evidenceLevel = "HA", conditionCode = "scenario-input"),
    .inputRow(ScenarioID, NA, "cover", "effective-surcharge", "q'", Cover[["effectiveSurchargeKPa", exact = TRUE]], unit = "kPa", evidenceLevel = "HA", conditionCode = "scenario-input"),
    .inputRow(ScenarioID, NA, "cover", "reference-position", "position", textValue = Cover[["referencePositionID", exact = TRUE]], evidenceLevel = "HA", conditionCode = "selected-reference"),
    .inputRow(ScenarioID, NA, "ground", "modulus", "E_g", Ground[["modulusKPa", exact = TRUE]], unit = "kPa", evidenceLevel = "HA", conditionCode = "scenario-input"),
    .inputRow(ScenarioID, NA, "ground", "poisson-ratio", "nu_g", Ground[["poisson", exact = TRUE]], evidenceLevel = "HA", conditionCode = "scenario-input"),
    .inputRow(ScenarioID, NA, "ground", "k0-model", "K0-model", textValue = Ground[["k0", exact = TRUE]][["modelID", exact = TRUE]], evidenceLevel = "HA", conditionCode = "selected-branch"),
    .inputRow(ScenarioID, NA, "action", "combination", "combination", textValue = Action[["combinationID", exact = TRUE]], evidenceLevel = "HA", conditionCode = "scenario-input"),
    .inputRow(ScenarioID, NA, "action", "stage", "stage", textValue = Action[["stageID", exact = TRUE]], evidenceLevel = "HA", conditionCode = "scenario-input"),
    .inputRow(ScenarioID, NA, "action", "force-effect-status", "basis", textValue = Action[["forceEffectStatus", exact = TRUE]], evidenceLevel = "HA", conditionCode = "scenario-input"),
    .inputRow(ScenarioID, NA, "action", "load-combination-basis", "load-basis", textValue = Action[["loadCombinationBasisID", exact = TRUE]], evidenceLevel = "HA", conditionCode = "scenario-input"),
    .inputRow(ScenarioID, NA, "action", "net-water-pressure", "Delta_u", Action[["waterPressureDifferenceKPa", exact = TRUE]], unit = "kPa", evidenceLevel = "HA", conditionCode = "scenario-input"),
    .inputRow(ScenarioID, NA, "section", "property-table", "table", textValue = Section[["propertyTable", exact = TRUE]], evidenceLevel = "DP", conditionCode = "published-reference"),
    .inputRow(ScenarioID, NA, "section", "reference-profile", "profile", textValue = Section[["profileID", exact = TRUE]], evidenceLevel = "DP", conditionCode = "published-reference"),
    .inputRow(ScenarioID, NA, "section", "reference-row", "row", textValue = Section[["referenceRowID", exact = TRUE]], evidenceLevel = "DP", conditionCode = "published-exact-row"),
    .inputRow(ScenarioID, NA, "lining", "section", "section", textValue = Lining[["sectionID", exact = TRUE]], evidenceLevel = "HA", conditionCode = "scenario-input"),
    .inputRow(ScenarioID, NA, "lining", "centroidal-radius", "R", Lining[["centroidalRadiusM", exact = TRUE]], unit = "m", evidenceLevel = "HA", conditionCode = "scenario-input"),
    .inputRow(ScenarioID, NA, "lining", "poisson-ratio", "nu_l", Lining[["poisson", exact = TRUE]], evidenceLevel = "HA", conditionCode = "scenario-input"),
    .inputRow(ScenarioID, NA, "lining", "remaining-base-thickness", "t", Lining[["remainingBaseThicknessMm", exact = TRUE]], unit = "mm", evidenceLevel = "HA", conditionCode = "scenario-input"),
    .inputRow(ScenarioID, NA, "lining", "young-modulus", "E_l", Lining[["youngModulusKPa", exact = TRUE]], unit = "kPa", evidenceLevel = "HA", conditionCode = "scenario-input"),
    .inputRow(ScenarioID, NA, "lining", "yield-strength", "F_y", Lining[["yieldStrengthMPa", exact = TRUE]], unit = "MPa", evidenceLevel = "HA", conditionCode = "scenario-input"),
    .inputRow(ScenarioID, NA, "numerics", "theta-point-count", "n", Numerics[["thetaPointCount", exact = TRUE]], evidenceLevel = "HA", conditionCode = "numerical-setting"),
    .inputRow(ScenarioID, NA, "numerics", "critical-angles", "theta_c", textValue = paste(Numerics[["criticalAnglesDeg", exact = TRUE]], collapse = "; "), unit = "deg", evidenceLevel = "HA", conditionCode = "numerical-setting"),
    .inputRow(ScenarioID, NA, "numerics", "integration-steps", "n_i", Numerics[["integrationSteps", exact = TRUE]], evidenceLevel = "HA", conditionCode = "numerical-setting"),
    .inputRow(ScenarioID, NA, "numerics", "balance-tolerance", "epsilon_b", Numerics[["balanceTolerance", exact = TRUE]], evidenceLevel = "HA", conditionCode = "numerical-setting"),
    .inputRow(ScenarioID, NA, "numerics", "closed-form-tolerance", "epsilon_c", Numerics[["closedFormTolerance", exact = TRUE]], evidenceLevel = "HA", conditionCode = "numerical-setting"),
    .inputRow(ScenarioID, NA, "numerics", "control-tolerance", "epsilon", Numerics[["controlTolerance", exact = TRUE]], evidenceLevel = "HA", conditionCode = "numerical-setting"),
    .inputRow(ScenarioID, NA, "graphics", "graphic-amplification", "A_g", Graphics[["graphicAmplification", exact = TRUE]], evidenceLevel = "HA", conditionCode = "display-setting"),
    .inputRow(ScenarioID, NA, "graphics", "radial-fraction", "f_r", Graphics[["radialFraction", exact = TRUE]], evidenceLevel = "HA", conditionCode = "display-setting"),
    .inputRow(ScenarioID, NA, "graphics", "ordinate-count", "n_o", Graphics[["ordinateCount", exact = TRUE]], evidenceLevel = "HA", conditionCode = "display-setting")
  )
  AdditionalLinings <- config[["additionalLinings", exact = TRUE]]
  if (length(AdditionalLinings) > 0L) {
    Rows <- c(Rows, unlist(lapply(seq_along(AdditionalLinings), function(i) {
      LiningID <- names(AdditionalLinings)[i]
      Shotcrete <- AdditionalLinings[[i]]
      LiningRows <- list(
        .inputRow(ScenarioID, LiningID, "shotcrete", "outer-radius", "R_o", Shotcrete[["outerRadiusM", exact = TRUE]], unit = "m", evidenceLevel = "HA", conditionCode = "scenario-input"),
        .inputRow(ScenarioID, LiningID, "shotcrete", "centroidal-radius", "R_sc", Shotcrete[["centroidalRadiusM", exact = TRUE]], unit = "m", evidenceLevel = "DE", conditionCode = "derived-geometry"),
        .inputRow(ScenarioID, LiningID, "shotcrete", "thickness", "t_sc", Shotcrete[["thicknessM", exact = TRUE]] * 1000, unit = "mm", evidenceLevel = "HA", conditionCode = "scenario-input"),
        .inputRow(ScenarioID, LiningID, "shotcrete", "compressive-strength", "fc", Shotcrete[["compressiveStrengthMPa", exact = TRUE]], unit = "MPa", evidenceLevel = "HA", conditionCode = "scenario-input"),
        .inputRow(ScenarioID, LiningID, "shotcrete", "young-modulus", "E_sc", Shotcrete[["youngModulusKPa", exact = TRUE]] / 1e6, unit = "GPa", evidenceLevel = "DE", conditionCode = "derived-material-property"),
        .inputRow(ScenarioID, LiningID, "shotcrete", "poisson-ratio", "nu_sc", Shotcrete[["poisson", exact = TRUE]], evidenceLevel = "HA", conditionCode = "scenario-input"),
        .inputRow(ScenarioID, LiningID, "shotcrete", "strip-width", "b", 1000 * Shotcrete[["stripWidthM", exact = TRUE]], unit = "mm", evidenceLevel = "HA", conditionCode = "scenario-input"),
        .inputRow(ScenarioID, LiningID, "shotcrete", "concrete-type", "type", textValue = Shotcrete[["concreteTypeID", exact = TRUE]], evidenceLevel = "HA", conditionCode = "selected-branch"),
        .inputRow(ScenarioID, LiningID, "shotcrete", "stiffness-basis", "basis", textValue = Shotcrete[["stiffnessBasisID", exact = TRUE]], evidenceLevel = "HA", conditionCode = "selected-branch")
      )
      ReinforcementLayout <- Shotcrete[["reinforcementLayout", exact = TRUE]]
      if (!is.null(ReinforcementLayout)) {
        LiningRows <- c(LiningRows, list(
          .inputRow(ScenarioID, LiningID, "shotcrete-reinforcement-layout", "reinforcement-grade", "grade", textValue = Shotcrete[["reinforcementGradeID", exact = TRUE]], evidenceLevel = "HA", conditionCode = "selected-material"),
          .inputRow(ScenarioID, LiningID, "shotcrete-reinforcement-layout", "bar-diameter", "phi", ReinforcementLayout[["barDiameterMm", exact = TRUE]], unit = "mm", evidenceLevel = "HA", conditionCode = "scenario-input"),
          .inputRow(ScenarioID, LiningID, "shotcrete-reinforcement-layout", "bar-spacing", "s", ReinforcementLayout[["barSpacingMm", exact = TRUE]], unit = "mm", evidenceLevel = "HA", conditionCode = "scenario-input"),
          .inputRow(ScenarioID, LiningID, "shotcrete-reinforcement-layout", "clear-cover-ratio", "c/t", ReinforcementLayout[["clearCoverRatio", exact = TRUE]], unit = "-", evidenceLevel = "HA", conditionCode = "scenario-input"),
          .inputRow(ScenarioID, LiningID, "shotcrete-reinforcement-layout", "clear-cover", "c", ReinforcementLayout[["clearCoverMm", exact = TRUE]], unit = "mm", evidenceLevel = "DE", conditionCode = "derived-geometry"),
          .inputRow(ScenarioID, LiningID, "shotcrete-reinforcement-layout", "layer-centroid-cover", "c_s", ReinforcementLayout[["layerCentroidCoverMm", exact = TRUE]], unit = "mm", evidenceLevel = "DE", conditionCode = "derived-geometry"),
          .inputRow(ScenarioID, LiningID, "shotcrete-reinforcement-layout", "area-per-face-direction", "A_s", ReinforcementLayout[["areaMm2PerFaceAndDirection", exact = TRUE]], unit = "mm2/m", evidenceLevel = "DE", conditionCode = "derived-reinforcement-layout")
        ))
      }
      ReinforcementSets <- list(
        circumferential = Shotcrete[["reinforcement", exact = TRUE]],
        orthogonal = Shotcrete[["orthogonalReinforcement", exact = TRUE]]
      )
      for (DirectionID in names(ReinforcementSets)) {
        Reinforcement <- ReinforcementSets[[DirectionID]]
        if (nrow(Reinforcement) == 0L) next
        for (j in seq_len(nrow(Reinforcement))) {
          LayerID <- Reinforcement[["layerID", exact = TRUE]][j]
          GroupID <- paste0("shotcrete-reinforcement-", DirectionID)
          ReinforcementCondition <- if (is.null(ReinforcementLayout)) {
            "scenario-input"
          } else {
            "derived-reinforcement-layout"
          }
          LiningRows <- c(LiningRows, list(
            .inputRow(ScenarioID, LiningID, GroupID, paste0("area-", LayerID), "A_s", Reinforcement[["areaMm2", exact = TRUE]][j], unit = "mm2/m", evidenceLevel = "DE", conditionCode = ReinforcementCondition),
            .inputRow(ScenarioID, LiningID, GroupID, paste0("coordinate-", LayerID), "z_s", Reinforcement[["coordinateMm", exact = TRUE]][j], unit = "mm", evidenceLevel = "DE", conditionCode = ReinforcementCondition),
            .inputRow(ScenarioID, LiningID, GroupID, paste0("yield-strength-", LayerID), "f_y", Reinforcement[["yieldStrengthMPa", exact = TRUE]][j], unit = "MPa", evidenceLevel = "DP", conditionCode = "selected-material"),
            .inputRow(ScenarioID, LiningID, GroupID, paste0("modulus-", LayerID), "E_s", Reinforcement[["modulusMPa", exact = TRUE]][j], unit = "MPa", evidenceLevel = "HA", conditionCode = "scenario-input")
          ))
        }
      }
      LiningRows
    }), recursive = FALSE))
  }
  Aisi <- Lining[["aisi", exact = TRUE]]
  if (!is.null(Aisi)) {
    Rows <- c(
      Rows,
      list(
        .inputRow(ScenarioID, NA, "aisi", "capacity-table", "capacity-table", textValue = Aisi[["capacityTable", exact = TRUE]], evidenceLevel = "DP", conditionCode = "external-capacity-set"),
        .inputRow(ScenarioID, NA, "aisi", "capacity-base-thickness", "t_c", Aisi[["capacityBaseThicknessMm", exact = TRUE]], unit = "mm", evidenceLevel = "DP", conditionCode = "external-capacity-set"),
        .inputRow(ScenarioID, NA, "aisi", "capacity-yield-strength", "F_yc", Aisi[["capacityYieldStrengthMPa", exact = TRUE]], unit = "MPa", evidenceLevel = "DP", conditionCode = "external-capacity-set"),
        .inputRow(ScenarioID, NA, "aisi", "standard", "standard", textValue = Aisi[["settings", exact = TRUE]][["standardID", exact = TRUE]], evidenceLevel = "DP", conditionCode = "external-capacity-set"),
        .inputRow(ScenarioID, NA, "aisi", "design-method", "method", textValue = Aisi[["settings", exact = TRUE]][["designMethodID", exact = TRUE]], evidenceLevel = "DP", conditionCode = "external-capacity-set")
      )
    )
  }
  Model <- Ground[["k0", exact = TRUE]]
  ModelFields <- c("k0", "frictionAngleDeg", "poissonRatio", "ocr", "ocrMaximum")
  ModelSymbols <- c(
    k0 = "K_0", frictionAngleDeg = "phi'", poissonRatio = "nu_K0",
    ocr = "OCR", ocrMaximum = "OCR_max"
  )
  ModelUnits <- c(
    k0 = "-", frictionAngleDeg = "deg", poissonRatio = "-",
    ocr = "-", ocrMaximum = "-"
  )
  for (s in intersect(ModelFields, names(Model))) {
    Rows[[length(Rows) + 1L]] <- .inputRow(
      ScenarioID,
      NA,
      "ground",
      s,
      ModelSymbols[[s]],
      Model[[s]],
      unit = ModelUnits[[s]],
      evidenceLevel = "HA",
      conditionCode = "k0-branch-input"
    )
  }
  Cases <- config[["interfaceCases", exact = TRUE]]
  for (i in seq_len(nrow(Cases))) {
    Rows[[length(Rows) + 1L]] <- .inputRow(
      ScenarioID,
      Cases[["caseID", exact = TRUE]][i],
      "action",
      "perimeter-projection",
      "projection",
      textValue = Cases[["interfaceID", exact = TRUE]][i],
      evidenceLevel = "HA",
      conditionCode = "selected-action-representation"
    )
    Rows[[length(Rows) + 1L]] <- .inputRow(
      ScenarioID,
      Cases[["caseID", exact = TRUE]][i],
      "action",
      "tangential-multiplier",
      "alpha",
      Cases[["tangentialMultiplier", exact = TRUE]][i],
      evidenceLevel = "HA",
      conditionCode = "scenario-input"
    )
    Rows[[length(Rows) + 1L]] <- .inputRow(
      ScenarioID,
      Cases[["caseID", exact = TRUE]][i],
      "comparison",
      "schwartz-einstein-interface",
      "interface",
      textValue = Cases[["comparisonInterfaceID", exact = TRUE]][i],
      evidenceLevel = "HA",
      conditionCode = "comparison-only"
    )
  }
  OUT <- do.call(rbind, Rows)
  rownames(OUT) <- NULL
  OUT
}

.buildCoverStressTable <- function(config, result) {
  ScenarioID <- config[["scenarioID", exact = TRUE]]
  Stress <- result[["freeFieldStress", exact = TRUE]]
  K0State <- .adaptCalculationK0State(result[["k0State", exact = TRUE]])
  data.frame(
    scenarioID = ScenarioID,
    stressStateID = paste0(ScenarioID, "-free-field"),
    stressModelID = Stress[["stressModelID", exact = TRUE]],
    referencePositionID = Stress[["referencePositionID", exact = TRUE]],
    depthM = Stress[["depthM", exact = TRUE]],
    coverCrownM = config[["cover", exact = TRUE]][["coverCrownM", exact = TRUE]],
    crownToAxisM = config[["cover", exact = TRUE]][["crownToAxisM", exact = TRUE]],
    effectiveUnitWeightKnPerM3 = config[["cover", exact = TRUE]][["effectiveUnitWeightKnPerM3", exact = TRUE]],
    effectiveSurchargeKPa = config[["cover", exact = TRUE]][["effectiveSurchargeKPa", exact = TRUE]],
    effectiveVerticalStressKPa = Stress[["effectiveVerticalStressKPa", exact = TRUE]],
    effectiveHorizontalStressKPa = Stress[["effectiveHorizontalStressKPa", exact = TRUE]],
    k0ModelID = K0State[["modelID", exact = TRUE]],
    frictionAngleDeg = K0State[["frictionAngleDeg", exact = TRUE]],
    poissonRatio = K0State[["poissonRatio", exact = TRUE]],
    ocr = K0State[["ocr", exact = TRUE]],
    ocrMaximum = K0State[["ocrMaximum", exact = TRUE]],
    k0Input = K0State[["k0Input", exact = TRUE]],
    k0Derived = K0State[["k0Derived", exact = TRUE]],
    k0Applied = K0State[["k0Applied", exact = TRUE]],
    domainStatus = K0State[["domainStatus", exact = TRUE]],
    evidenceLevel = "DE",
    k0EvidenceLevel = K0State[["k0EvidenceLevel", exact = TRUE]],
    sourceKey = K0State[["sourceKey", exact = TRUE]],
    sourceLocator = K0State[["sourceLocator", exact = TRUE]],
    stringsAsFactors = FALSE
  )
}

.buildCoverSectionTable <- function(config, reference, result) {
  Section <- result[["section", exact = TRUE]][["section", exact = TRUE]]
  Rigidity <- result[["section", exact = TRUE]][["rigidity", exact = TRUE]]
  ExactReference <- abs(Section[["thicknessScale", exact = TRUE]] - 1) <=
    10 * .Machine$double.eps
  data.frame(
    scenarioID = config[["scenarioID", exact = TRUE]],
    sectionID = config[["lining", exact = TRUE]][["sectionID", exact = TRUE]],
    profileID = Section[["profileID", exact = TRUE]],
    referenceRowID = Section[["referenceRowID", exact = TRUE]],
    propertyModelID = if (ExactReference) {
      "published-exact-row"
    } else {
      Section[["propertyModelID", exact = TRUE]]
    },
    nominalPitchMm = reference[["nominalPitchMm", exact = TRUE]],
    nominalDepthMm = reference[["nominalDepthMm", exact = TRUE]],
    actualPitchMm = reference[["actualPitchMm", exact = TRUE]],
    actualDepthMm = reference[["actualDepthMm", exact = TRUE]],
    corrugationRadiusMm = reference[["corrugationRadiusMm", exact = TRUE]],
    specifiedThicknessMm = reference[["specifiedThicknessMm", exact = TRUE]],
    designBaseThicknessMm = reference[["designBaseThicknessMm", exact = TRUE]],
    referenceBaseThicknessMm = Section[["referenceBaseThicknessMm", exact = TRUE]],
    remainingBaseThicknessMm = Section[["analysisBaseThicknessMm", exact = TRUE]],
    thicknessScale = Section[["thicknessScale", exact = TRUE]],
    areaMm2PerMm = Section[["areaMm2PerMm", exact = TRUE]],
    inertiaMm4PerMm = Section[["inertiaMm4PerMm", exact = TRUE]],
    sectionModulusMm3PerMm = Section[["sectionModulusMm3PerMm", exact = TRUE]],
    tangentLengthMm = reference[["tangentLengthMm", exact = TRUE]],
    tangentAngleDeg = reference[["tangentAngleDeg", exact = TRUE]],
    gyrationRadiusMm = reference[["gyrationRadiusMm", exact = TRUE]],
    developedWidthFactor = reference[["developedWidthFactor", exact = TRUE]],
    centroidalRadiusM = config[["lining", exact = TRUE]][["centroidalRadiusM", exact = TRUE]],
    circumferentialYoungModulusGPa = Rigidity[["youngModulus", exact = TRUE]] / 1e6,
    extensionalRigidityKnPerM = Rigidity[["extensionalRigidity", exact = TRUE]],
    flexuralRigidityKnM2PerM = Rigidity[["flexuralRigidity", exact = TRUE]],
    sectionRatio = Rigidity[["sectionRatio", exact = TRUE]],
    equivalentThicknessM = Rigidity[["equivalentThickness", exact = TRUE]],
    yieldStrengthMPa = config[["lining", exact = TRUE]][["yieldStrengthMPa", exact = TRUE]],
    evidenceLevel = "DE",
    propertyEvidenceLevel = reference[["evidenceLevel", exact = TRUE]],
    sourceKey = Section[["sourceKey", exact = TRUE]],
    sourceLocator = Section[["sourceLocator", exact = TRUE]],
    domainStatus = if (ExactReference) {
      "published-exact-row"
    } else {
      Section[["domainStatus", exact = TRUE]]
    },
    stringsAsFactors = FALSE
  )
}

.buildCoverInteractionTable <- function(config, results) {
  Cases <- config[["interfaceCases", exact = TRUE]]
  LIST <- lapply(seq_len(nrow(Cases)), function(i) {
    Result <- results[[i]]
    Interaction <- Result[["interaction", exact = TRUE]]
    Amplitudes <- Interaction[["amplitudesProject", exact = TRUE]]
    Values <- Interaction[["values", exact = TRUE]]
    data.frame(
      scenarioID = config[["scenarioID", exact = TRUE]],
      caseID = Cases[["caseID", exact = TRUE]][i],
      sectionID = Result[["scenario", exact = TRUE]][[
        "sectionID",
        exact = TRUE
      ]][1L],
      interactionModelID = Values[["interactionModelID", exact = TRUE]][1L],
      interfaceID = Cases[["interfaceID", exact = TRUE]][i],
      combinationID = Values[["combinationID", exact = TRUE]][1L],
      stageID = Values[["stageID", exact = TRUE]][1L],
      forceEffectStatus = Values[["forceEffectStatus", exact = TRUE]][1L],
      stressReferenceID = Values[["stressReferenceID", exact = TRUE]][1L],
      stressBasis = Values[["stressBasis", exact = TRUE]][1L],
      hydraulicActionTreatment = Values[["hydraulicActionTreatment", exact = TRUE]][1L],
      effectiveVerticalStressKPa = Values[["effectiveVerticalStressKPa", exact = TRUE]][1L],
      effectiveHorizontalStressKPa = Values[["effectiveHorizontalStressKPa", exact = TRUE]][1L],
      waterPressureDifferenceKPa = Values[["waterPressureDifferenceKPa", exact = TRUE]][1L],
      stressRatio = Values[["stressRatio", exact = TRUE]][1L],
      tangentialMultiplier = Interaction[[
        "tangentialMultiplier",
        exact = TRUE
      ]],
      sectionRatio = Interaction[["sectionRatio", exact = TRUE]],
      normalMeanKnPerM = Amplitudes[["normalMean", exact = TRUE]],
      normalCosineKnPerM = Amplitudes[["normalCosine", exact = TRUE]],
      momentMeanKnMPerM = Amplitudes[["momentMean", exact = TRUE]],
      momentCosineKnMPerM = Amplitudes[["momentCosine", exact = TRUE]],
      shearSineKnPerM = Amplitudes[["shearSine", exact = TRUE]],
      evidenceLevel = "DE",
      sourceKey = Interaction[["sourceKey", exact = TRUE]],
      sourceLocator = Interaction[["sourceLocation", exact = TRUE]],
      stringsAsFactors = FALSE
    )
  })
  OUT <- do.call(rbind, LIST)
  rownames(OUT) <- NULL
  OUT
}

.buildCoverSchwartzEinsteinComparisonTable <- function(config, results) {
  Cases <- config[["interfaceCases", exact = TRUE]]
  LIST <- lapply(seq_len(nrow(Cases)), function(i) {
    Result <- results[[i]]
    Interaction <- Result[["comparisonInteraction", exact = TRUE]]
    Stiffness <- Interaction[["stiffness", exact = TRUE]]
    Amplitudes <- Interaction[["amplitudesProject", exact = TRUE]]
    SourceAmplitudes <- Interaction[["source", exact = TRUE]][[
      "amplitudes",
      exact = TRUE
    ]]
    Values <- Interaction[["values", exact = TRUE]]
    data.frame(
      scenarioID = config[["scenarioID", exact = TRUE]],
      comparisonCaseID = paste0(
        "schwartz-einstein-",
        Cases[["comparisonInterfaceID", exact = TRUE]][i]
      ),
      sectionID = Result[["scenario", exact = TRUE]][[
        "sectionID",
        exact = TRUE
      ]][1L],
      interactionModelID = Values[["interactionModelID", exact = TRUE]][1L],
      interfaceID = Cases[["comparisonInterfaceID", exact = TRUE]][i],
      stressReferenceID = Values[["stressReferenceID", exact = TRUE]][1L],
      effectiveVerticalStressKPa = Values[["effectiveVerticalStressKPa", exact = TRUE]][1L],
      effectiveHorizontalStressKPa = Values[["effectiveHorizontalStressKPa", exact = TRUE]][1L],
      stressRatio = Values[["stressRatio", exact = TRUE]][1L],
      cStar = Stiffness[["cStar", exact = TRUE]],
      fStar = Stiffness[["fStar", exact = TRUE]],
      t0 = SourceAmplitudes[["thrust0", exact = TRUE]],
      t2 = SourceAmplitudes[["thrust2", exact = TRUE]],
      m2 = SourceAmplitudes[["moment2", exact = TRUE]],
      normalMeanKnPerM = Amplitudes[["normalMean", exact = TRUE]],
      normalCosineKnPerM = Amplitudes[["normalCosine", exact = TRUE]],
      momentCosineKnMPerM = Amplitudes[["momentCosine", exact = TRUE]],
      shearSineKnPerM = Amplitudes[["shearSine", exact = TRUE]],
      evidenceLevel = "DE",
      sourceKey = Interaction[["sourceKey", exact = TRUE]],
      sourceLocator = Interaction[["sourceLocation", exact = TRUE]],
      stringsAsFactors = FALSE
    )
  })
  OUT <- do.call(rbind, LIST)
  rownames(OUT) <- NULL
  OUT
}

.buildCoverResultants <- function(config, results) {
  Cases <- config[["interfaceCases", exact = TRUE]]
  Columns <- c(
    N = "normalForceKnPerM",
    M = "bendingMomentKnMPerM",
    Q = "shearForceKnPerM"
  )
  Units <- c(N = "kN/m", M = "kN m/m", Q = "kN/m")
  LIST <- lapply(seq_len(nrow(Cases)), function(i) {
    Values <- results[[i]][["interaction", exact = TRUE]][["values", exact = TRUE]]
    do.call(rbind, lapply(names(Columns), function(s) {
      data.frame(
        scenarioID = config[["scenarioID", exact = TRUE]],
        caseID = Cases[["caseID", exact = TRUE]][i],
        sectionID = config[["lining", exact = TRUE]][["sectionID", exact = TRUE]],
        stressStateID = paste0(config[["scenarioID", exact = TRUE]], "-free-field"),
        combinationID = Values[["combinationID", exact = TRUE]],
        stageID = Values[["stageID", exact = TRUE]],
        forceEffectStatus = Values[["forceEffectStatus", exact = TRUE]],
        interactionModelID = Values[["interactionModelID", exact = TRUE]],
        interfaceID = Cases[["interfaceID", exact = TRUE]][i],
        stressReferenceID = Values[["stressReferenceID", exact = TRUE]],
        resultantID = s,
        thetaIndex = seq_len(nrow(Values)) - 1L,
        thetaRad = Values[["thetaRad", exact = TRUE]],
        thetaDeg = Values[["thetaDeg", exact = TRUE]],
        value = Values[[Columns[[s]], exact = TRUE]],
        unit = Units[[s]],
        evidenceLevel = "DE",
        stringsAsFactors = FALSE
      )
    }))
  })
  OUT <- do.call(rbind, LIST)
  rownames(OUT) <- NULL
  OUT
}

.buildCoverExtrema <- function(config, results) {
  Cases <- config[["interfaceCases", exact = TRUE]]
  LIST <- lapply(seq_len(nrow(Cases)), function(i) {
    Extrema <- results[[i]][["extrema", exact = TRUE]]
    data.frame(
      scenarioID = config[["scenarioID", exact = TRUE]],
      caseID = Cases[["caseID", exact = TRUE]][i],
      sectionID = config[["lining", exact = TRUE]][["sectionID", exact = TRUE]],
      stressStateID = paste0(config[["scenarioID", exact = TRUE]], "-free-field"),
      combinationID = Extrema[["combinationID", exact = TRUE]],
      stageID = Extrema[["stageID", exact = TRUE]],
      forceEffectStatus = Extrema[["forceEffectStatus", exact = TRUE]],
      interactionModelID = Extrema[["interactionModelID", exact = TRUE]],
      interfaceID = Cases[["interfaceID", exact = TRUE]][i],
      stressReferenceID = Extrema[["stressReferenceID", exact = TRUE]],
      resultantID = Extrema[["resultantID", exact = TRUE]],
      statisticID = Extrema[["statisticID", exact = TRUE]],
      value = Extrema[["value", exact = TRUE]],
      signedValue = Extrema[["signedValue", exact = TRUE]],
      thetaRad = Extrema[["thetaRad", exact = TRUE]],
      thetaDeg = Extrema[["thetaDeg", exact = TRUE]],
      unit = Extrema[["unit", exact = TRUE]],
      evidenceLevel = "DE",
      stringsAsFactors = FALSE
    )
  })
  OUT <- do.call(rbind, LIST)
  rownames(OUT) <- NULL
  OUT
}

.emptyCoverAisiChecks <- function() {
  data.frame(
    scenarioID = character(), caseID = character(), demandRowID = integer(),
    sectionID = character(), combinationID = character(), stageID = character(),
    thetaRad = numeric(), thetaDeg = numeric(), normalForceKnPerM = numeric(),
    bendingMomentKnMPerM = numeric(), shearForceKnPerM = numeric(),
    checkID = character(), checkFamilyID = character(), clauseID = character(),
    equationValue = numeric(), equationLimit = numeric(),
    normalizedCheckValue = numeric(), limitStatus = character(),
    applicabilityStatus = character(), evaluationStatus = character(),
    complete = logical(), reasonCode = character(), evidenceLocator = character(),
    designMethodID = character(), demandBasisID = character(),
    forceEffectStatus = character(), widthBasisID = character(),
    capacityBasisID = character(), standardID = character(),
    verdictEligibilityStatus = character(), evaluationPurposeID = character(),
    sourceLocator = character(), stringsAsFactors = FALSE
  )
}

.emptyCoverAisiUsage <- function() {
  data.frame(
    scenarioID = character(), caseID = character(), demandRowID = integer(),
    checkID = character(), capacityRoleID = character(), capacityID = character(),
    senseID = character(), nominalValue = numeric(), availableValue = numeric(),
    unit = character(), designMethodID = character(), widthBasisID = character(),
    capacityConsumerID = character(), capacityBasisID = character(),
    limitStateID = character(), applicabilityStatus = character(),
    sectionHoleStatus = character(), webHoleStatus = character(),
    netSectionBasisID = character(), capacityCoverageStatus = character(),
    capacityCoverageEvidenceLocator = character(), evidenceLocator = character(),
    sourceLocator = character(), stringsAsFactors = FALSE
  )
}

.alignCoverAisiProduct <- function(
  data,
  template,
  scenarioID,
  caseID
) {
  if (!is.data.frame(data) || nrow(data) == 0L) {
    return(template)
  }
  Data <- data
  Data$scenarioID <- scenarioID
  Data$caseID <- caseID
  Missing <- setdiff(names(template), names(Data))
  if (length(Missing) > 0L) {
    stop(
      "The AISI result is missing: ", paste(Missing, collapse = ", "), ".",
      call. = FALSE
    )
  }
  Data[, names(template), drop = FALSE]
}

.buildCoverAisiChecks <- function(config, results) {
  Cases <- config[["interfaceCases", exact = TRUE]]
  Template <- .emptyCoverAisiChecks()
  LIST <- lapply(seq_len(nrow(Cases)), function(i) {
    Assessment <- results[[i]][["assessment", exact = TRUE]][[
      "aisi",
      exact = TRUE
    ]]
    .alignCoverAisiProduct(
      data = if (is.null(Assessment)) NULL else Assessment$checks,
      template = Template,
      scenarioID = config[["scenarioID", exact = TRUE]],
      caseID = Cases[["caseID", exact = TRUE]][i]
    )
  })
  OUT <- do.call(rbind, LIST)
  rownames(OUT) <- NULL
  OUT
}

.buildCoverAisiUsage <- function(config, results) {
  Cases <- config[["interfaceCases", exact = TRUE]]
  Template <- .emptyCoverAisiUsage()
  LIST <- lapply(seq_len(nrow(Cases)), function(i) {
    Assessment <- results[[i]][["assessment", exact = TRUE]][[
      "aisi",
      exact = TRUE
    ]]
    .alignCoverAisiProduct(
      data = if (is.null(Assessment)) NULL else Assessment$capacityUsage,
      template = Template,
      scenarioID = config[["scenarioID", exact = TRUE]],
      caseID = Cases[["caseID", exact = TRUE]][i]
    )
  })
  OUT <- do.call(rbind, LIST)
  rownames(OUT) <- NULL
  OUT
}

.buildCoverAisiSummary <- function(config, results) {
  Cases <- config[["interfaceCases", exact = TRUE]]
  LIST <- lapply(seq_len(nrow(Cases)), function(i) {
    Summary <- results[[i]][["summary", exact = TRUE]]
    Assessment <- results[[i]][["assessment", exact = TRUE]][[
      "aisi",
      exact = TRUE
    ]]
    AssessmentSummary <- if (is.null(Assessment)) {
      NULL
    } else {
      Assessment$summary[1L, , drop = FALSE]
    }
    data.frame(
      scenarioID = config[["scenarioID", exact = TRUE]],
      caseID = Cases[["caseID", exact = TRUE]][i],
      sectionID = Summary[["sectionID", exact = TRUE]],
      interfaceID = Cases[["interfaceID", exact = TRUE]][i],
      aisiWallMemberUtilization = Summary[["aisiWallMemberUtilization", exact = TRUE]],
      aisiWallMemberStatus = Summary[["aisiWallMemberStatus", exact = TRUE]],
      aisiSystemStatus = Summary[["aisiSystemStatus", exact = TRUE]],
      standardID = if (is.null(AssessmentSummary)) {
        NA_character_
      } else {
        AssessmentSummary$standardID
      },
      designMethodID = if (is.null(AssessmentSummary)) {
        NA_character_
      } else {
        AssessmentSummary$designMethodID
      },
      forceEffectStatus = config[["action", exact = TRUE]][["forceEffectStatus", exact = TRUE]],
      capacityStatus = if (is.null(AssessmentSummary)) {
        "not-provided"
      } else {
        "provided"
      },
      evidenceLevel = "DE",
      stringsAsFactors = FALSE
    )
  })
  OUT <- do.call(rbind, LIST)
  rownames(OUT) <- NULL
  OUT
}

.buildLiningDisplayScales <- function(
  resultants,
  centroidalRadiusM,
  graphics,
  scenarioID
) {
  Units <- c(N = "kN/m", M = "kN m/m", Q = "kN/m")
  Radius <- centroidalRadiusM
  Graphics <- graphics
  do.call(rbind, lapply(names(Units), function(s) {
    AUX <- resultants[resultants$resultantID == s, , drop = FALSE]
    Maximum <- max(abs(AUX$value))
    Scale <- if (Maximum == 0) {
      NA_real_
    } else {
      Graphics[["radialFraction", exact = TRUE]] * Radius / Maximum
    }
    data.frame(
      scenarioID = scenarioID,
      resultantID = s,
      referenceRadiusM = Radius,
      displayScale = Scale,
      maximumAbsoluteValue = Maximum,
      resultantUnit = Units[[s]],
      radialFraction = Graphics[["radialFraction", exact = TRUE]],
      graphicAmplification = Graphics[["graphicAmplification", exact = TRUE]],
      ordinateCount = Graphics[["ordinateCount", exact = TRUE]],
      evidenceLevel = "DE",
      stringsAsFactors = FALSE
    )
  }))
}

.buildCoverDisplayScales <- function(config, resultants) {
  .buildLiningDisplayScales(
    resultants = resultants,
    centroidalRadiusM = config[["lining", exact = TRUE]][[
      "centroidalRadiusM",
      exact = TRUE
    ]],
    graphics = config[["graphics", exact = TRUE]],
    scenarioID = config[["scenarioID", exact = TRUE]]
  )
}

.buildCoverControls <- function(config, results) {
  Cases <- config[["interfaceCases", exact = TRUE]]
  Numerics <- config[["numerics", exact = TRUE]]
  DifferenceNames <- c(
    N = "normalForce",
    M = "bendingMoment",
    Q = "shearForce"
  )
  BalanceNames <- c(Fx = "forceX", Fz = "forceZ", Mc = "momentCenter")
  Units <- c(N = "kN/m", M = "kN m/m", Q = "kN/m")
  LIST <- lapply(seq_len(nrow(Cases)), function(i) {
    Interaction <- results[[i]][["interaction", exact = TRUE]]
    Values <- Interaction[["values", exact = TRUE]]
    ClosedRows <- do.call(rbind, lapply(names(DifferenceNames), function(s) {
      Error <- Interaction[["closedFormDifference", exact = TRUE]][[
        DifferenceNames[[s]],
        exact = TRUE
      ]]
      data.frame(
        scenarioID = config[["scenarioID", exact = TRUE]],
        caseID = Cases[["caseID", exact = TRUE]][i],
        tangentialMultiplier = Cases[[
          "tangentialMultiplier",
          exact = TRUE
        ]][i],
        controlID = "closed-form-resultants",
        resultantID = s,
        metricID = "maximum-absolute-difference",
        observedValue = Error,
        comparison = "<=",
        limitValue = Numerics[["closedFormTolerance", exact = TRUE]],
        unit = Units[[s]],
        pass = Error <= Numerics[["closedFormTolerance", exact = TRUE]],
        thetaPointCount = nrow(Values),
        integrationSteps = Numerics[["integrationSteps", exact = TRUE]],
        evidenceLevel = "CI",
        stringsAsFactors = FALSE
      )
    }))
    Diagnostics <- Interaction[["response", exact = TRUE]][[
      "diagnostics",
      exact = TRUE
    ]]
    BalanceRows <- do.call(rbind, lapply(names(BalanceNames), function(s) {
      Residual <- abs(Diagnostics[["normalizedGlobalLoads", exact = TRUE]][[
        BalanceNames[[s]],
        exact = TRUE
      ]])
      data.frame(
        scenarioID = config[["scenarioID", exact = TRUE]],
        caseID = Cases[["caseID", exact = TRUE]][i],
        tangentialMultiplier = Cases[[
          "tangentialMultiplier",
          exact = TRUE
        ]][i],
        controlID = "global-equilibrium",
        resultantID = s,
        metricID = "absolute-normalized-residual",
        observedValue = Residual,
        comparison = "<=",
        limitValue = Numerics[["balanceTolerance", exact = TRUE]],
        unit = "-",
        pass = Residual <= Numerics[["balanceTolerance", exact = TRUE]],
        thetaPointCount = nrow(Values),
        integrationSteps = Numerics[["integrationSteps", exact = TRUE]],
        evidenceLevel = "CI",
        stringsAsFactors = FALSE
      )
    }))
    rbind(ClosedRows, BalanceRows)
  })
  OUT <- do.call(rbind, LIST)
  rownames(OUT) <- NULL
  if (!all(OUT$pass)) {
    stop("One or more cover-interaction numerical controls failed.", call. = FALSE)
  }
  OUT
}

.buildCoverShotcreteProducts <- function(config, evaluation) {
  Linings <- evaluation[["additionalLinings", exact = TRUE]]
  if (length(Linings) == 0L) {
    return(list())
  }
  LiningIDs <- names(Linings)
  ReinforcementStudy <- .evaluateCoverReinforcementStudy(
    config = config,
    additionalLinings = Linings
  )
  StudyProducts <- if (is.null(ReinforcementStudy)) {
    list()
  } else {
    list(
      "shotcrete.axial.flexure.reinforcement.domains.csv" =
        ReinforcementStudy[["domains", exact = TRUE]],
      "shotcrete.axial.flexure.reinforcement.sweep.csv" =
        ReinforcementStudy[["summary", exact = TRUE]],
      "shotcrete.axial.flexure.reinforcement.configured.demands.csv" =
        ReinforcementStudy[["configuredGoverningDemands", exact = TRUE]]
    )
  }
  bindProduct <- function(name) {
    Rows <- lapply(seq_along(Linings), function(i) {
      Data <- Linings[[i]][[name, exact = TRUE]]
      if (!is.data.frame(Data)) {
        stop("The shotcrete product is not tabular: ", name, ".", call. = FALSE)
      }
      cbind(
        data.frame(liningID = LiningIDs[i], stringsAsFactors = FALSE),
        Data
      )
    })
    OUT <- do.call(rbind, Rows)
    rownames(OUT) <- NULL
    OUT
  }
  Checks <- lapply(seq_along(Linings), function(i) {
    Result <- Linings[[i]]
    Aci <- Result[["assessment", exact = TRUE]][["aci", exact = TRUE]]
    SectionID <- Result[["section", exact = TRUE]][[
      "sectionID",
      exact = TRUE
    ]]
    ConcreteTypeID <- config[["additionalLinings", exact = TRUE]][[
      LiningIDs[i],
      exact = TRUE
    ]][["concreteTypeID", exact = TRUE]]
    if (is.null(Aci)) {
      SummaryData <- Result[["summary", exact = TRUE]]
      return(data.frame(
        scenarioID = config[["scenarioID", exact = TRUE]],
        liningID = LiningIDs[i],
        sectionID = SectionID,
        concreteTypeID = ConcreteTypeID,
        caseID = config[["interfaceCases", exact = TRUE]][[
          "caseID",
          exact = TRUE
        ]],
        interfaceID = config[["interfaceCases", exact = TRUE]][[
          "interfaceID",
          exact = TRUE
        ]],
        strengthCaseID = "",
        combinationID = SummaryData$scenarioID,
        stageID = config[["action", exact = TRUE]][["stageID", exact = TRUE]],
        forceEffectStatus = config[["action", exact = TRUE]][[
          "forceEffectStatus",
          exact = TRUE
        ]],
        thetaRad = NA_real_,
        thetaDeg = NA_real_,
        normalForceKnPerM = NA_real_,
        bendingMomentKnMPerM = NA_real_,
        shearForceKnPerM = NA_real_,
        axialForceKn = NA_real_,
        bendingMomentKnM = NA_real_,
        shearDemandKn = NA_real_,
        checkID = "aci-configuration",
        standardID = "",
        clauseID = "",
        sourceLocator = "",
        demandValue = NA_real_,
        capacityValue = NA_real_,
        unit = "-",
        utilization = NA_real_,
        applicabilityStatus = "not-evaluated",
        calculationStatus = "not-evaluated",
        checkStatus = "blocked",
        blockReason = "aci-configuration-not-provided",
        verticalStressFactor = NA_real_,
        horizontalStressFactor = NA_real_,
        loadCombinationBasisID = "",
        loadCombinationSourceLocator = "",
        stringsAsFactors = FALSE
      ))
    }
    Data <- Aci[["checks", exact = TRUE]]
    if (!is.data.frame(Data) || nrow(Data) == 0L) {
      stop("The ACI shotcrete checks are unavailable.", call. = FALSE)
    }
    Data$scenarioID <- config[["scenarioID", exact = TRUE]]
    Data$liningID <- LiningIDs[i]
    Data$sectionID <- SectionID
    Data$concreteTypeID <- ConcreteTypeID
    Leading <- c(
      "scenarioID", "liningID", "sectionID", "concreteTypeID",
      "caseID", "interfaceID", "strengthCaseID", "combinationID",
      "stageID", "forceEffectStatus", "thetaRad", "thetaDeg"
    )
    Data[, c(Leading, setdiff(names(Data), Leading)), drop = FALSE]
  })
  Checks <- do.call(rbind, Checks)
  rownames(Checks) <- NULL
  Summary <- lapply(seq_along(Linings), function(i) {
    Data <- Linings[[i]][["summary", exact = TRUE]]
    Data[["liningScenarioID"]] <- Data[["scenarioID", exact = TRUE]]
    Data[["scenarioID"]] <- config[["scenarioID", exact = TRUE]]
    Data[["liningID"]] <- LiningIDs[i]
    Data[["caseID"]] <- config[["interfaceCases", exact = TRUE]][[
      "caseID",
      exact = TRUE
    ]]
    Data[, c(
      "scenarioID", "liningID", "liningScenarioID", "caseID",
      setdiff(names(Data), c(
        "scenarioID", "liningID", "liningScenarioID", "caseID"
      ))
    ), drop = FALSE]
  })
  Summary <- do.call(rbind, Summary)
  rownames(Summary) <- NULL
  Scales <- lapply(seq_along(Linings), function(i) {
    Result <- Linings[[i]]
    Data <- .buildLiningDisplayScales(
      resultants = Result[["resultants", exact = TRUE]],
      centroidalRadiusM = Result[["section", exact = TRUE]][[
        "centroidalRadiusM",
        exact = TRUE
      ]],
      graphics = config[["graphics", exact = TRUE]],
      scenarioID = Result[["section", exact = TRUE]][[
        "scenarioID",
        exact = TRUE
      ]]
    )
    cbind(
      data.frame(liningID = LiningIDs[i], stringsAsFactors = FALSE),
      Data
    )
  })
  Scales <- do.call(rbind, Scales)
  rownames(Scales) <- NULL
  DomainRows <- list()
  DemandRows <- list()
  for (i in seq_along(Linings)) {
    Result <- Linings[[i]]
    Aci <- Result[["assessment", exact = TRUE]][["aci", exact = TRUE]]
    Diagram <- if (is.null(Aci)) {
      NULL
    } else {
      Aci[["interactionDiagram", exact = TRUE]]
    }
    if (is.null(Diagram)) next
    Domain <- Diagram[["domain", exact = TRUE]]
    Demands <- Diagram[["demands", exact = TRUE]]
    if (!is.data.frame(Domain) || !is.data.frame(Demands)) {
      stop("The ACI P-M interaction product is not tabular.", call. = FALSE)
    }
    SectionID <- Result[["section", exact = TRUE]][["sectionID", exact = TRUE]]
    ConcreteTypeID <- config[["additionalLinings", exact = TRUE]][[
      LiningIDs[i],
      exact = TRUE
    ]][["concreteTypeID", exact = TRUE]]
    DomainRows[[length(DomainRows) + 1L]] <- cbind(
      data.frame(
        scenarioID = config[["scenarioID", exact = TRUE]],
        liningID = LiningIDs[i],
        sectionID = SectionID,
        concreteTypeID = ConcreteTypeID,
        stringsAsFactors = FALSE
      ),
      Domain
    )
    DemandRows[[length(DemandRows) + 1L]] <- cbind(
      data.frame(
        scenarioID = config[["scenarioID", exact = TRUE]],
        liningID = LiningIDs[i],
        sectionID = SectionID,
        concreteTypeID = ConcreteTypeID,
        stringsAsFactors = FALSE
      ),
      Demands
    )
  }
  Domain <- if (length(DomainRows) == 0L) {
    data.frame()
  } else {
    do.call(rbind, DomainRows)
  }
  Demands <- if (length(DemandRows) == 0L) {
    data.frame()
  } else {
    do.call(rbind, DemandRows)
  }
  rownames(Domain) <- NULL
  rownames(Demands) <- NULL
  c(list(
    "shotcrete.section.properties.csv" = bindProduct("section"),
    "shotcrete.interaction.parameters.csv" = bindProduct("interaction"),
    "shotcrete.schwartz.einstein.comparison.csv" =
      bindProduct("schwartzEinsteinComparison"),
    "shotcrete.section.resultants.csv" = bindProduct("resultants"),
    "shotcrete.section.extrema.csv" = bindProduct("extrema"),
    "shotcrete.display.scales.csv" = Scales,
    "shotcrete.numerical.controls.csv" = bindProduct("controls"),
    "shotcrete.checks.csv" = Checks,
    "shotcrete.summary.csv" = Summary,
    "shotcrete.axial.flexure.domain.csv" = Domain,
    "shotcrete.axial.flexure.demands.csv" = Demands
  ), StudyProducts)
}

.buildCoverCalculationProducts <- function(config, projectRoot) {
  if (!is.list(config) || is.null(names(config))) {
    stop("config must be one validated calculation configuration.", call. = FALSE)
  }
  SchemaVersion <- config[["schemaVersion", exact = TRUE]]
  if (identical(SchemaVersion, "3.1.0")) {
    if (!exists(".evaluateValidatedCoverConfiguration", mode = "function")) {
      stop(
        paste(
          "Source scripts/R/coverConfiguration.R before building",
          "calculation schema 3.1.0."
        ),
        call. = FALSE
      )
    }
    Evaluation <- .evaluateValidatedCoverConfiguration(
      config = config,
      projectRoot = projectRoot
    )
    Resultants <- Evaluation[["resultants", exact = TRUE]]
    Aashto <- Evaluation[["aashto", exact = TRUE]]
    Products <- list(
      "calculation.inputs.csv" = .buildCoverInputs(config),
      "stress.state.csv" = Evaluation[["stress", exact = TRUE]],
      "section.properties.csv" = Evaluation[["section", exact = TRUE]],
      "interaction.parameters.csv" = Evaluation[[
        "interaction",
        exact = TRUE
      ]],
      "schwartz.einstein.comparison.csv" = Evaluation[[
        "schwartzEinsteinComparison",
        exact = TRUE
      ]],
      "section.resultants.csv" = Resultants,
      "section.extrema.csv" = Evaluation[["extrema", exact = TRUE]],
      "aashto.inputs.csv" = Aashto[["inputs", exact = TRUE]],
      "aashto.thrust.csv" = Aashto[["thrust", exact = TRUE]],
      "aashto.calculation.csv" = Aashto[["calculation", exact = TRUE]],
      "aashto.checks.csv" = Aashto[["checks", exact = TRUE]],
      "aashto.summary.csv" = Aashto[["summary", exact = TRUE]],
      "display.scales.csv" = .buildCoverDisplayScales(config, Resultants),
      "numerical.controls.csv" = Evaluation[["controls", exact = TRUE]]
    )
    return(c(
      Products,
      .buildCoverShotcreteProducts(config, Evaluation)
    ))
  }
  if (!identical(SchemaVersion, "3.0.0")) {
    stop(
      "config must use calculation schema 3.0.0 or 3.1.0.",
      call. = FALSE
    )
  }
  ProjectRoot <- normalizePath(projectRoot, mustWork = TRUE)
  Reference <- .readCoverSectionReference(config, ProjectRoot)
  AisiInput <- .readCoverAisiInput(config, ProjectRoot)
  Theta <- buildThetaMesh(
    pointCount = config[["numerics", exact = TRUE]][["thetaPointCount", exact = TRUE]],
    criticalAnglesDeg = config[["numerics", exact = TRUE]][["criticalAnglesDeg", exact = TRUE]]
  )
  Cases <- config[["interfaceCases", exact = TRUE]]
  Results <- lapply(seq_len(nrow(Cases)), function(i) {
    Case <- as.list(Cases[i, , drop = FALSE])
    evaluateCoverScenario(
      scenario = .buildCoverScenario(config, Case, AisiInput),
      theta = Theta,
      sectionReference = Reference
    )
  })
  SectionSignatures <- vapply(
    Results,
    function(x) x[["scenario", exact = TRUE]][["sectionSignature", exact = TRUE]],
    character(1)
  )
  if (length(unique(SectionSignatures)) != 1L) {
    stop("Interface cases produced inconsistent lining sections.", call. = FALSE)
  }
  StressStates <- lapply(Results, `[[`, "freeFieldStress")
  if (!all(vapply(
    StressStates[-1L],
    identical,
    logical(1),
    StressStates[[1L]]
  ))) {
    stop("Interface cases produced inconsistent free-field stresses.", call. = FALSE)
  }

  Resultants <- .buildCoverResultants(config, Results)
  list(
    "calculation.inputs.csv" = .buildCoverInputs(config),
    "stress.state.csv" = .buildCoverStressTable(config, Results[[1L]]),
    "section.properties.csv" = .buildCoverSectionTable(
      config,
      Reference,
      Results[[1L]]
    ),
    "interaction.parameters.csv" = .buildCoverInteractionTable(config, Results),
    "section.resultants.csv" = Resultants,
    "section.extrema.csv" = .buildCoverExtrema(config, Results),
    "aisi.checks.csv" = .buildCoverAisiChecks(config, Results),
    "aisi.capacity.usage.csv" = .buildCoverAisiUsage(config, Results),
    "aisi.summary.csv" = .buildCoverAisiSummary(config, Results),
    "display.scales.csv" = .buildCoverDisplayScales(config, Resultants),
    "numerical.controls.csv" = .buildCoverControls(config, Results)
  )
}
