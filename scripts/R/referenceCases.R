# Recalculates the source-specific cases reproduced in the calculation memo.

.requireReferenceFields <- function(data, required, label) {
  if (!is.data.frame(data) || nrow(data) == 0L) {
    stop(label, " must be one non-empty data frame.", call. = FALSE)
  }
  Missing <- setdiff(required, names(data))
  if (length(Missing) > 0L) {
    stop(
      label, " is missing: ", paste(Missing, collapse = ", "), ".",
      call. = FALSE
    )
  }
  invisible(data)
}

.calculateUSACED4Reference <- function(fixture) {
  Required <- c(
    "caseID", "unitWeightLbPerFt3", "coverCrownFt", "spanFt",
    "deadLoadFactor", "demandModifier", "liveCrownPressureLbPerFt2",
    "liveLoadedWidthFt", "liveDistributionFactor", "liveLoadFactor",
    "factorBasis", "publishedDeadCrownPressureLbPerFt2",
    "publishedFactoredThrustLbPerFt", "publishedModifiedDemandLbPerFt",
    "sourceKey", "equationSourceLocator", "exampleSourceLocator"
  )
  .requireReferenceFields(fixture, Required, "USACE D4 fixture")
  if (nrow(fixture) != 1L) {
    stop("USACE D4 fixture must contain one row.", call. = FALSE)
  }
  Row <- fixture[1L, , drop = FALSE]
  Result <- usaceCmpThrust(
    deadCrownPressure = usaceCrownPressure(
      Row$unitWeightLbPerFt3,
      Row$coverCrownFt
    ),
    span = Row$spanFt,
    deadLoadFactor = Row$deadLoadFactor,
    demandModifier = Row$demandModifier,
    factorBasis = Row$factorBasis,
    liveCrownPressure = Row$liveCrownPressureLbPerFt2,
    liveLoadedWidth = Row$liveLoadedWidthFt,
    liveDistributionFactor = Row$liveDistributionFactor,
    liveLoadFactor = Row$liveLoadFactor
  )
  Published <- c(
    Row$publishedDeadCrownPressureLbPerFt2,
    NA_real_,
    Row$publishedFactoredThrustLbPerFt,
    Row$publishedModifiedDemandLbPerFt
  )
  Calculated <- c(
    Result$deadCrownPressure,
    Result$deadServiceThrust,
    Result$factoredThrust,
    Result$designDemand
  )
  data.frame(
    caseID = Row$caseID,
    quantityID = c(
      "dead-crown-pressure", "dead-service-thrust", "factored-thrust",
      "modified-demand"
    ),
    publishedValue = Published,
    calculatedValue = Calculated,
    difference = Calculated - Published,
    unit = c("lb/ft2", "lb/ft", "lb/ft", "lb/ft"),
    evidenceClass = ifelse(
      is.na(Published),
      "study-derived-result",
      "published-result-reproduced"
    ),
    sourceKey = Row$sourceKey,
    sourceLocator = c(
      Row$exampleSourceLocator,
      Row$equationSourceLocator,
      Row$exampleSourceLocator,
      Row$exampleSourceLocator
    ),
    stringsAsFactors = FALSE
  )
}

.calculateFHWACompactionReference <- function(fixture) {
  Required <- c(
    "caseID", "compactorID", "soilID", "compactorForceKn",
    "publishedFrictionAngleDeg", "alternativeFrictionAngleDeg",
    "nominalDiameterMm", "centroidalDiameterMm", "publishedPressureKPa",
    "sourceKey", "sourceLocator"
  )
  .requireReferenceFields(fixture, Required, "FHWA compaction fixture")
  CalculatedPublished <- vapply(seq_len(nrow(fixture)), function(i) {
    fhwaCompactionPressure(
      compactorForceKn = fixture$compactorForceKn[i],
      looseFrictionAngleDeg = fixture$publishedFrictionAngleDeg[i],
      centroidalDiameterMm = fixture$centroidalDiameterMm[i]
    )
  }, numeric(1))
  CalculatedAlternative <- vapply(seq_len(nrow(fixture)), function(i) {
    if (is.na(fixture$alternativeFrictionAngleDeg[i])) return(NA_real_)
    fhwaCompactionPressure(
      compactorForceKn = fixture$compactorForceKn[i],
      looseFrictionAngleDeg = fixture$alternativeFrictionAngleDeg[i],
      centroidalDiameterMm = fixture$centroidalDiameterMm[i]
    )
  }, numeric(1))
  RoundedPublished <- round(CalculatedPublished, 1)
  RoundedAlternative <- round(CalculatedAlternative, 1)
  Status <- ifelse(
    RoundedPublished == fixture$publishedPressureKPa,
    "rounded-match",
    ifelse(
      !is.na(RoundedAlternative) &
        RoundedAlternative == fixture$publishedPressureKPa,
      "published-input-mismatch-alternative-match",
      "mismatch"
    )
  )
  data.frame(
    fixture[Required],
    calculatedPublishedInputKPa = CalculatedPublished,
    roundedPublishedInputKPa = RoundedPublished,
    calculatedAlternativeKPa = CalculatedAlternative,
    roundedAlternativeKPa = RoundedAlternative,
    differencePublishedInputKPa =
      CalculatedPublished - fixture$publishedPressureKPa,
    comparisonStatus = Status,
    evidenceClass = ifelse(
      Status == "rounded-match",
      "published-result-reproduced",
      "source-discrepancy"
    ),
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
}

.calculateNunez2000Reference <- function(fixture) {
  Required <- c(
    "caseID", "liningID", "diameterM", "depthAxisM",
    "unitWeightTfPerM3", "surfaceLoadTfPerM2", "k0", "relaxation",
    "interactionRatio", "publishedInteractionRatio",
    "publishedInteractionFraction", "publishedMomentMaximumTfMPerM",
    "publishedNormalCrownTfPerM", "publishedNormalSideTfPerM",
    "sourceKey", "sourceLocator"
  )
  .requireReferenceFields(fixture, Required, "Nunez 2000 fixture")
  LIST <- lapply(seq_len(nrow(fixture)), function(i) {
    Row <- fixture[i, , drop = FALSE]
    Result <- nunez2000CircularResultants(
      diameter = Row$diameterM,
      depthAxis = Row$depthAxisM,
      unitWeight = Row$unitWeightTfPerM3,
      surfaceLoad = Row$surfaceLoadTfPerM2,
      k0 = Row$k0,
      relaxation = Row$relaxation,
      interactionRatio = Row$interactionRatio
    )
    Published <- c(
      Row$publishedInteractionRatio,
      Row$publishedInteractionFraction,
      Row$publishedMomentMaximumTfMPerM,
      Row$publishedNormalCrownTfPerM,
      Row$publishedNormalSideTfPerM
    )
    Calculated <- c(
      Result$interactionRatio,
      Result$interactionFraction,
      Result$momentCrown,
      Result$normalCrown,
      Result$normalSpringline
    )
    QuantityID <- c(
      "interaction-ratio", "interaction-fraction", "maximum-moment",
      "normal-crown", "normal-side"
    )
    Difference <- Calculated - Published
    data.frame(
      caseID = Row$caseID,
      liningID = Row$liningID,
      quantityID = QuantityID,
      publishedValue = Published,
      calculatedValue = Calculated,
      difference = Difference,
      relativeDifferencePercent = ifelse(
        is.na(Published) | Published == 0,
        NA_real_,
        100 * Difference / Published
      ),
      unit = c("-", "-", "tf m/m", "tf/m", "tf/m"),
      evidenceClass = ifelse(
        QuantityID == "interaction-ratio",
        "published-datum",
        ifelse(
          is.na(Published),
          "study-derived-result",
          "published-result-reproduced"
        )
      ),
      sourceKey = Row$sourceKey,
      sourceLocator = Row$sourceLocator,
      stringsAsFactors = FALSE
    )
  })
  OUT <- do.call(rbind, LIST)
  rownames(OUT) <- NULL
  OUT
}

.calculateSchwartzEinsteinHP97Reference <- function(fixture) {
  Required <- c(
    "caseID", "sequenceID", "interfaceID", "thetaDeg", "verticalStress",
    "stressRatio", "radius", "cStar", "fStar", "groundPoisson",
    "publishedThrustRatio", "publishedMomentRatio", "sourceKey",
    "sourceLocator"
  )
  .requireReferenceFields(fixture, Required, "Schwartz-Einstein fixture")
  LIST <- lapply(seq_len(nrow(fixture)), function(i) {
    Row <- fixture[i, , drop = FALSE]
    Result <- schwartzEinsteinResultants(
      theta = Row$thetaDeg * pi / 180,
      verticalStress = Row$verticalStress,
      stressRatio = Row$stressRatio,
      radius = Row$radius,
      cStar = Row$cStar,
      fStar = Row$fStar,
      groundPoisson = Row$groundPoisson,
      sequence = Row$sequenceID,
      interface = Row$interfaceID
    )
    data.frame(
      caseID = Row$caseID,
      sequenceID = Row$sequenceID,
      interfaceID = Row$interfaceID,
      thetaDeg = Row$thetaDeg,
      publishedThrustRatio = Row$publishedThrustRatio,
      calculatedThrustRatio = Result$response$thrustRatio,
      differenceThrustRatio =
        Result$response$thrustRatio - Row$publishedThrustRatio,
      publishedMomentRatio = Row$publishedMomentRatio,
      calculatedMomentRatio = Result$response$momentRatio,
      differenceMomentRatio =
        Result$response$momentRatio - Row$publishedMomentRatio,
      evidenceClass = "published-result-reproduced",
      sourceKey = Row$sourceKey,
      sourceLocator = Row$sourceLocator,
      stringsAsFactors = FALSE
    )
  })
  OUT <- do.call(rbind, LIST)
  rownames(OUT) <- NULL
  OUT
}

.writeReferenceCaseProducts <- function(products, outputDirectory) {
  Parent <- dirname(outputDirectory)
  if (!dir.exists(Parent)) dir.create(Parent, recursive = TRUE)
  Stage <- tempfile("reference-cases-", tmpdir = Parent)
  if (!dir.create(Stage)) {
    stop("Could not create the reference-case staging directory.", call. = FALSE)
  }
  on.exit(unlink(Stage, recursive = TRUE, force = TRUE), add = TRUE)
  for (s in names(products)) {
    utils::write.csv(
      products[[s]],
      file.path(Stage, s),
      row.names = FALSE,
      na = ""
    )
  }
  Backup <- tempfile("reference-cases-backup-", tmpdir = Parent)
  HadOutput <- dir.exists(outputDirectory)
  if (HadOutput && !file.rename(outputDirectory, Backup)) {
    stop("Could not preserve the previous reference-case products.", call. = FALSE)
  }
  if (!file.rename(Stage, outputDirectory)) {
    Restored <- !HadOutput || file.rename(Backup, outputDirectory)
    if (!Restored) {
      stop("Could not restore the previous reference-case products.", call. = FALSE)
    }
    stop("Could not publish the reference-case products.", call. = FALSE)
  }
  if (HadOutput && dir.exists(Backup)) unlink(Backup, recursive = TRUE)
  invisible(file.path(outputDirectory, names(products)))
}

buildReferenceCaseData <- function(referenceDirectory, outputDirectory) {
  if (!dir.exists(referenceDirectory)) {
    stop("The reference-case directory is not available.", call. = FALSE)
  }
  readFixture <- function(fileName) {
    Path <- file.path(referenceDirectory, fileName)
    if (!file.exists(Path)) {
      stop("The reference fixture is not available: ", Path, call. = FALSE)
    }
    utils::read.csv(
      Path,
      check.names = FALSE,
      stringsAsFactors = FALSE,
      na.strings = ""
    )
  }
  Products <- list(
    "usace.d4.csv" = .calculateUSACED4Reference(
      readFixture("usace.d4.csv")
    ),
    "fhwa.compaction.eq.5.1.csv" = .calculateFHWACompactionReference(
      readFixture("fhwa.compaction.eq.5.1.csv")
    ),
    "nunez.2000.circular.csv" = .calculateNunez2000Reference(
      readFixture("nunez.2000.circular.csv")
    ),
    "schwartz.einstein.hp97.csv" = .calculateSchwartzEinsteinHP97Reference(
      readFixture("schwartz.einstein.hp97.csv")
    )
  )
  .writeReferenceCaseProducts(Products, outputDirectory)
  list(
    products = Products,
    outputDirectory = normalizePath(outputDirectory, mustWork = TRUE)
  )
}
