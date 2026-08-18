# Project-case comparison with the classical formulations used by the memo.

.normaliseCoverClassicalComparison <- function(value) {
  Comparison <- .requireObject(value, "classicalComparison")
  .requireFields(
    Comparison,
    c("nunezRelaxationFactor", "nunezContactFactor"),
    path = "classicalComparison"
  )
  list(
    nunezRelaxationFactor = .readNumber(
      Comparison,
      "nunezRelaxationFactor",
      "classicalComparison",
      minimum = 0,
      maximum = 1
    ),
    nunezContactFactor = .readNumber(
      Comparison,
      "nunezContactFactor",
      "classicalComparison",
      minimum = 0,
      strictMinimum = TRUE
    )
  )
}

.classicalResultantUnit <- function(resultantID) {
  switch(resultantID, N = "kN/m", M = "kN-m/m", Q = "kN/m")
}

.classicalCurveRows <- function(
  liningID,
  resultants,
  schwartzEinstein,
  prescribed,
  theta,
  forceEffectStatus
) {
  Official <- data.frame(
    scenarioID = resultants$scenarioID,
    liningID = liningID,
    sectionID = resultants$sectionID,
    methodID = "official-hybrid",
    caseID = resultants$caseID,
    forceEffectStatus = resultants$forceEffectStatus,
    resultScopeID = "angular-distribution",
    thetaIndex = resultants$thetaIndex,
    thetaRad = resultants$thetaRad,
    thetaDeg = resultants$thetaDeg,
    resultantID = resultants$resultantID,
    value = resultants$value,
    unit = resultants$unit,
    sourceKey = "SchwartzEinstein1980+balanced-depth-gradient",
    sourceLocator = paste(
      "Schwartz--Einstein uniform interaction plus the balanced",
      "first/third-harmonic depth-gradient correction"
    ),
    stringsAsFactors = FALSE
  )

  HarmonicRows <- function(data, methodID, caseColumn, formulas) {
    Rows <- lapply(seq_len(nrow(data)), function(i) {
      Current <- data[i, , drop = FALSE]
      Values <- list(
        N = formulas$N(Current, theta$thetaRad),
        M = formulas$M(Current, theta$thetaRad),
        Q = formulas$Q(Current, theta$thetaRad)
      )
      do.call(rbind, lapply(names(Values), function(ResultantID) {
        data.frame(
          scenarioID = Current$scenarioID,
          liningID = liningID,
          sectionID = Current$sectionID,
          methodID = methodID,
          caseID = Current[[caseColumn]],
          forceEffectStatus = forceEffectStatus,
          resultScopeID = "angular-distribution",
          thetaIndex = theta$thetaIndex,
          thetaRad = theta$thetaRad,
          thetaDeg = theta$thetaDeg,
          resultantID = ResultantID,
          value = as.numeric(Values[[ResultantID]]),
          unit = .classicalResultantUnit(ResultantID),
          sourceKey = Current$sourceKey,
          sourceLocator = Current$sourceLocator,
          stringsAsFactors = FALSE
        )
      }))
    })
    do.call(rbind, Rows)
  }

  SchwartzEinstein <- HarmonicRows(
    schwartzEinstein,
    "schwartz-einstein-uniform",
    "comparisonCaseID",
    list(
      N = function(x, t) x$normalMeanKnPerM + x$normalCosineKnPerM * cos(2 * t),
      M = function(x, t) x$momentCosineKnMPerM * cos(2 * t),
      Q = function(x, t) x$shearSineKnPerM * sin(2 * t)
    )
  )
  Prescribed <- HarmonicRows(
    prescribed,
    "prescribed-k0-ring",
    "caseID",
    list(
      N = function(x, t) x$normalMeanKnPerM + x$normalCosineKnPerM * cos(2 * t),
      M = function(x, t) x$momentMeanKnMPerM + x$momentCosineKnMPerM * cos(2 * t),
      Q = function(x, t) x$shearSineKnPerM * sin(2 * t)
    )
  )
  OUT <- rbind(Official, SchwartzEinstein, Prescribed)
  rownames(OUT) <- NULL
  OUT
}

.classicalSectionRows <- function(config, evaluation) {
  Ground <- config$ground
  Comparison <- config$classicalComparison
  Steel <- evaluation$section[1L, , drop = FALSE]
  SteelInertiaM4PerM <- Steel$inertiaMm4PerMm * 1e-9
  SteelEquivalentThickness <- (12 * SteelInertiaM4PerM)^(1 / 3)
  Rows <- list(data.frame(
    scenarioID = Steel$scenarioID,
    liningID = "steel",
    sectionID = Steel$sectionID,
    centroidalDiameterM = 2 * Steel$centroidalRadiusM,
    structuralThicknessM = Steel$remainingBaseThicknessMm / 1000,
    nunezEquivalentThicknessM = SteelEquivalentThickness,
    nunezThicknessBasisID = "flexural-equivalent-homogeneous-thickness",
    youngModulusKPa = Steel$circumferentialYoungModulusGPa * 1e6,
    poisson = config$lining$poisson,
    extensionalRigidityKnPerM = Steel$extensionalRigidityKnPerM,
    flexuralRigidityKnM2PerM = Steel$flexuralRigidityKnM2PerM,
    stringsAsFactors = FALSE
  ))
  for (LiningID in names(evaluation$additionalLinings)) {
    Section <- evaluation$additionalLinings[[LiningID]]$section[1L, , drop = FALSE]
    Rows[[length(Rows) + 1L]] <- data.frame(
      scenarioID = Section$scenarioID,
      liningID = LiningID,
      sectionID = Section$sectionID,
      centroidalDiameterM = 2 * Section$centroidalRadiusM,
      structuralThicknessM = Section$thicknessM,
      nunezEquivalentThicknessM = Section$thicknessM,
      nunezThicknessBasisID = "homogeneous-wall-thickness",
      youngModulusKPa = Section$youngModulusKPa,
      poisson = Section$poisson,
      extensionalRigidityKnPerM = Section$extensionalRigidityKnPerM,
      flexuralRigidityKnM2PerM = Section$flexuralRigidityKnM2PerM,
      stringsAsFactors = FALSE
    )
  }
  OUT <- do.call(rbind, Rows)
  OUT$nunezInteractionRatio <- vapply(seq_len(nrow(OUT)), function(i) {
    nunezInteractionRatio(
      diameter = OUT$centroidalDiameterM[i],
      thickness = OUT$nunezEquivalentThicknessM[i],
      liningYoungModulus = OUT$youngModulusKPa[i],
      soilYoungModulus = Ground$modulusKPa,
      liningPoisson = OUT$poisson[i],
      soilPoisson = Ground$poisson,
      contactFactor = Comparison$nunezContactFactor
    )
  }, numeric(1))
  rownames(OUT) <- NULL
  OUT
}

.classicalPointRows <- function(config, evaluation, sections) {
  Stress <- evaluation$stress[1L, , drop = FALSE]
  DepthAxis <- config$cover$coverCrownM + config$cover$crownToAxisM
  Comparison <- config$classicalComparison
  Rows <- list()
  Add <- function(
    section,
    methodID,
    pointID,
    resultantID,
    thetaDeg,
    value,
    sourceKey,
    sourceLocator,
    valueStatusID = "signed"
  ) {
    data.frame(
      scenarioID = section$scenarioID,
      liningID = section$liningID,
      sectionID = section$sectionID,
      methodID = methodID,
      caseID = "nunez-project-sensitivity",
      forceEffectStatus = config$action$forceEffectStatus,
      resultScopeID = "published-point-resultants",
      pointID = pointID,
      resultantID = resultantID,
      thetaDeg = thetaDeg,
      value = value,
      unit = .classicalResultantUnit(resultantID),
      valueStatusID = valueStatusID,
      sourceKey = sourceKey,
      sourceLocator = sourceLocator,
      stringsAsFactors = FALSE
    )
  }
  for (i in seq_len(nrow(sections))) {
    Section <- sections[i, , drop = FALSE]
    Args <- list(
      diameter = Section$centroidalDiameterM,
      depthAxis = DepthAxis,
      unitWeight = config$cover$effectiveUnitWeightKnPerM3,
      surfaceLoad = config$cover$effectiveSurchargeKPa,
      k0 = Stress$k0Applied,
      relaxation = Comparison$nunezRelaxationFactor,
      interactionRatio = Section$nunezInteractionRatio
    )
    N2000 <- do.call(nunez2000CircularResultants, Args)
    N2014 <- do.call(nunez2014Resultants, Args)
    Rows <- c(Rows, list(
      Add(Section, "nunez-2000", "crown", "N", 0, -N2000$normalCrown,
          "Nunez2000", N2000$sourceLocation),
      Add(Section, "nunez-2000", "springline", "N", 90,
          -N2000$normalSpringline, "Nunez2000", N2000$sourceLocation),
      Add(Section, "nunez-2000", "crown", "M", 0, abs(N2000$momentCrown),
          "Nunez2000", N2000$sourceLocation, "absolute-maximum"),
      Add(Section, "nunez-2014", "crown", "N", 0, -N2014$normalCrown,
          "NunezSfrisoLaiun2014", N2014$sourceLocation),
      Add(Section, "nunez-2014", "springline", "N", 90,
          -N2014$normalSpringline, "NunezSfrisoLaiun2014", N2014$sourceLocation),
      Add(Section, "nunez-2014", "invert", "N", 180,
          -N2014$normalInvert, "NunezSfrisoLaiun2014", N2014$sourceLocation),
      Add(Section, "nunez-2014", "maximum", "M", NA_real_,
          abs(N2014$momentMaximum), "NunezSfrisoLaiun2014",
          N2014$sourceLocation, "absolute-maximum")
    ))
  }
  OUT <- do.call(rbind, Rows)
  rownames(OUT) <- NULL
  OUT
}

.classicalSummaryRows <- function(config, evaluation, curves, points, sections) {
  Extreme <- function(data, resultantID) {
    Values <- data[data$resultantID == resultantID, , drop = FALSE]
    if (nrow(Values) == 0L || all(is.na(Values$value))) return(c(NA_real_, NA_real_))
    Index <- which.max(abs(Values$value))
    c(abs(Values$value[Index]), Values$thetaDeg[Index])
  }
  CurveGroups <- split(
    curves,
    interaction(curves$liningID, curves$methodID, curves$caseID, drop = TRUE)
  )
  Rows <- lapply(CurveGroups, function(Data) {
    N <- Extreme(Data, "N"); M <- Extreme(Data, "M"); Q <- Extreme(Data, "Q")
    data.frame(
      scenarioID = Data$scenarioID[1L], liningID = Data$liningID[1L],
      sectionID = Data$sectionID[1L], methodID = Data$methodID[1L],
      caseID = Data$caseID[1L], forceEffectStatus = Data$forceEffectStatus[1L],
      resultScopeID = "angular-distribution", applicabilityStatus = "applicable",
      normalAbsoluteMaxKnPerM = N[1L], normalThetaDeg = N[2L],
      momentAbsoluteMaxKnMPerM = M[1L], momentThetaDeg = M[2L],
      shearAbsoluteMaxKnPerM = Q[1L], shearThetaDeg = Q[2L],
      normalRatioToOfficialEnvelope = NA_real_,
      momentRatioToOfficialEnvelope = NA_real_,
      shearRatioToOfficialEnvelope = NA_real_,
      sourceKey = Data$sourceKey[1L], sourceLocator = Data$sourceLocator[1L],
      stringsAsFactors = FALSE
    )
  })
  PointGroups <- split(points, interaction(points$liningID, points$methodID, drop = TRUE))
  Rows <- c(Rows, lapply(PointGroups, function(Data) {
    N <- Extreme(Data, "N"); M <- Extreme(Data, "M")
    data.frame(
      scenarioID = Data$scenarioID[1L], liningID = Data$liningID[1L],
      sectionID = Data$sectionID[1L], methodID = Data$methodID[1L],
      caseID = Data$caseID[1L], forceEffectStatus = Data$forceEffectStatus[1L],
      resultScopeID = "published-point-resultants",
      applicabilityStatus = "open-cut-sensitivity",
      normalAbsoluteMaxKnPerM = N[1L], normalThetaDeg = N[2L],
      momentAbsoluteMaxKnMPerM = M[1L], momentThetaDeg = M[2L],
      shearAbsoluteMaxKnPerM = NA_real_, shearThetaDeg = NA_real_,
      normalRatioToOfficialEnvelope = NA_real_,
      momentRatioToOfficialEnvelope = NA_real_,
      shearRatioToOfficialEnvelope = NA_real_,
      sourceKey = Data$sourceKey[1L], sourceLocator = Data$sourceLocator[1L],
      stringsAsFactors = FALSE
    )
  }))

  Thrust <- evaluation$aashto$thrust
  Value <- function(quantityID) Thrust$value[match(quantityID, Thrust$quantityID)]
  Service <- Value("dead-service-thrust") + Value("live-service-thrust")
  Modified <- Value("modified-demand")
  for (i in seq_len(nrow(sections))) {
    Section <- sections[i, , drop = FALSE]
    IsSteel <- Section$liningID == "steel"
    for (CaseID in c("aashto-service-thrust", "aashto-modified-factored-demand")) {
      IsService <- CaseID == "aashto-service-thrust"
      Rows[[length(Rows) + 1L]] <- data.frame(
        scenarioID = Section$scenarioID, liningID = Section$liningID,
        sectionID = Section$sectionID, methodID = "aashto-usace",
        caseID = CaseID,
        forceEffectStatus = if (IsService) "unfactored-service" else "modified-factored-demand",
        resultScopeID = "scalar-thrust",
        applicabilityStatus = if (IsSteel) "steel-only" else "outside-material-system",
        normalAbsoluteMaxKnPerM = if (IsSteel) if (IsService) Service else Modified else NA_real_,
        normalThetaDeg = NA_real_, momentAbsoluteMaxKnMPerM = NA_real_,
        momentThetaDeg = NA_real_, shearAbsoluteMaxKnPerM = NA_real_,
        shearThetaDeg = NA_real_, normalRatioToOfficialEnvelope = NA_real_,
        momentRatioToOfficialEnvelope = NA_real_,
        shearRatioToOfficialEnvelope = NA_real_,
        sourceKey = "AASHTOLRFD+USACE2020",
        sourceLocator = "AASHTO LRFD Section 12.7; USACE EM 1110-2-2902 Eq. 4-20",
        stringsAsFactors = FALSE
      )
    }
  }
  OUT <- do.call(rbind, Rows)
  Official <- curves[curves$methodID == "official-hybrid", , drop = FALSE]
  Denominators <- aggregate(
    abs(value) ~ liningID + resultantID,
    data = Official,
    FUN = max
  )
  names(Denominators)[3L] <- "denominator"
  for (i in seq_len(nrow(OUT))) {
    for (ResultantID in c("N", "M", "Q")) {
      ValueColumn <- switch(
        ResultantID,
        N = "normalAbsoluteMaxKnPerM",
        M = "momentAbsoluteMaxKnMPerM",
        Q = "shearAbsoluteMaxKnPerM"
      )
      RatioColumn <- switch(
        ResultantID,
        N = "normalRatioToOfficialEnvelope",
        M = "momentRatioToOfficialEnvelope",
        Q = "shearRatioToOfficialEnvelope"
      )
      Denominator <- Denominators$denominator[
        Denominators$liningID == OUT$liningID[i] &
          Denominators$resultantID == ResultantID
      ]
      if (length(Denominator) == 1L && is.finite(OUT[[ValueColumn]][i]) &&
          OUT$forceEffectStatus[i] == config$action$forceEffectStatus) {
        OUT[[RatioColumn]][i] <- OUT[[ValueColumn]][i] / Denominator
      }
    }
  }
  rownames(OUT) <- NULL
  OUT
}

.buildCoverClassicalComparisonProducts <- function(config, evaluation) {
  CurveAngleStepDeg <- 5
  Sections <- .classicalSectionRows(config, evaluation)
  ForceEffectStatus <- config$action$forceEffectStatus
  CurveSets <- list(.classicalCurveRows(
    "steel", evaluation$resultants, evaluation$schwartzEinsteinComparison,
    evaluation$interaction, evaluation$theta, ForceEffectStatus
  ))
  for (LiningID in names(evaluation$additionalLinings)) {
    Current <- evaluation$additionalLinings[[LiningID]]
    CurveSets[[length(CurveSets) + 1L]] <- .classicalCurveRows(
      LiningID, Current$resultants, Current$schwartzEinsteinComparison,
      Current$interaction, evaluation$theta, ForceEffectStatus
    )
  }
  Curves <- do.call(rbind, CurveSets)
  rownames(Curves) <- NULL
  Points <- .classicalPointRows(config, evaluation, Sections)
  Stress <- evaluation$stress[1L, , drop = FALSE]
  Inputs <- data.frame(
    scenarioID = config$scenarioID,
    coverCrownM = config$cover$coverCrownM,
    depthAxisM = config$cover$coverCrownM + config$cover$crownToAxisM,
    effectiveUnitWeightKnPerM3 = config$cover$effectiveUnitWeightKnPerM3,
    effectiveSurchargeKPa = config$cover$effectiveSurchargeKPa,
    effectiveVerticalStressKPa = Stress$effectiveVerticalStressKPa,
    effectiveHorizontalStressKPa = Stress$effectiveHorizontalStressKPa,
    k0Applied = Stress$k0Applied,
    groundModulusKPa = config$ground$modulusKPa,
    groundPoisson = config$ground$poisson,
    waterPressureDifferenceKPa = config$action$waterPressureDifferenceKPa,
    nunezRelaxationFactor = config$classicalComparison$nunezRelaxationFactor,
    nunezContactFactor = config$classicalComparison$nunezContactFactor,
    curveAngleStepDeg = CurveAngleStepDeg,
    forceEffectStatus = config$action$forceEffectStatus,
    stringsAsFactors = FALSE
  )
  Summary <- .classicalSummaryRows(
    config, evaluation, Curves, Points, Sections
  )
  CurveQuotient <- Curves$thetaDeg / CurveAngleStepDeg
  PublishedCurves <- Curves[
    abs(CurveQuotient - round(CurveQuotient)) < 1e-10,
    ,
    drop = FALSE
  ]
  rownames(PublishedCurves) <- NULL
  list(
    "classical.comparison.inputs.csv" = Inputs,
    "classical.comparison.sections.csv" = Sections,
    "classical.comparison.curves.csv" = PublishedCurves,
    "classical.comparison.points.csv" = Points,
    "classical.comparison.summary.csv" = Summary
  )
}
