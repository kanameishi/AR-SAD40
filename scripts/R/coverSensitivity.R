# Ground-modulus sensitivity products for the calculation memo.
#
# Each modulus reuses the complete product pipeline
# (resolveCoverCaseConfig + .buildCoverCalculationProducts), so every
# sensitivity row follows exactly the same code path as the adopted scenario;
# the builder only distils the lining-safety surfaces into compact tables.

buildCoverSensitivityData <- function(
  configPath,
  outputDirectory,
  projectRoot,
  moduliMPa
) {
  ConfigPath <- normalizePath(configPath, mustWork = TRUE)
  ProjectRoot <- normalizePath(projectRoot, mustWork = TRUE)
  if (!is.numeric(moduliMPa) || length(moduliMPa) < 2L ||
      any(!is.finite(moduliMPa)) || any(moduliMPa <= 0) ||
      is.unsorted(moduliMPa, strictly = TRUE)) {
    stop(
      "moduliMPa must be a strictly increasing set of positive moduli.",
      call. = FALSE
    )
  }
  Manifest <- readCalculationJson(ConfigPath)
  if (!identical(
    Manifest[["contractVersion", exact = TRUE]],
    "cover-case-2"
  )) {
    stop(
      "The sensitivity study requires a cover-case-2 manifest.",
      call. = FALSE
    )
  }
  Inputs <- Manifest[["inputs", exact = TRUE]]
  MethodID <- Manifest[["methodID", exact = TRUE]]
  Steel <- list()
  Aashto <- list()
  Plain <- list()
  Sweep <- list()
  Demands <- list()
  for (i in seq_along(moduliMPa)) {
    AUX <- unserialize(serialize(Inputs, NULL))
    AUX[["ground"]][["modulusKPa"]] <- 1000 * moduliMPa[i]
    Config <- resolveCoverCaseConfig(
      inputs = AUX,
      projectRoot = ProjectRoot,
      methodID = MethodID
    )[["config", exact = TRUE]]
    Products <- .buildCoverCalculationProducts(
      config = Config,
      projectRoot = ProjectRoot
    )
    Modulus <- data.frame(modulusMPa = moduliMPa[i])
    Extrema <- Products[["section.extrema.csv", exact = TRUE]]
    Extrema <- Extrema[
      Extrema$statisticID == "absolute-maximum",
      c("caseID", "resultantID", "value", "unit"),
      drop = FALSE
    ]
    Steel[[i]] <- cbind(Modulus, Extrema)
    Aashto[[i]] <- cbind(
      Modulus,
      Products[["aashto.checks.csv", exact = TRUE]][
        ,
        c("checkID", "utilization", "checkStatus"),
        drop = FALSE
      ]
    )
    Shotcrete <- Products[["shotcrete.checks.csv", exact = TRUE]]
    Shotcrete <- Shotcrete[
      Shotcrete$concreteTypeID == "plain-concrete" &
        Shotcrete$calculationStatus == "calculated" &
        Shotcrete$checkID %in% c("tension-face", "one-way-shear"),
      ,
      drop = FALSE
    ]
    if (nrow(Shotcrete) == 0L) {
      stop("The plain-concrete sensitivity checks are unavailable.", call. = FALSE)
    }
    Keys <- unique(Shotcrete[c("liningID", "checkID")])
    for (k in seq_len(nrow(Keys))) {
      Rows <- Shotcrete[
        Shotcrete$liningID == Keys$liningID[k] &
          Shotcrete$checkID == Keys$checkID[k],
        ,
        drop = FALSE
      ]
      Plain[[length(Plain) + 1L]] <- data.frame(
        modulusMPa = moduliMPa[i],
        liningID = Keys$liningID[k],
        checkID = Keys$checkID[k],
        utilization = max(Rows$utilization),
        checkStatus = if (all(Rows$checkStatus == "satisfied")) {
          "satisfied"
        } else {
          "not-satisfied"
        },
        stringsAsFactors = FALSE
      )
    }
    Sweep[[i]] <- cbind(
      Modulus,
      Products[[
        "shotcrete.axial.flexure.reinforcement.sweep.csv",
        exact = TRUE
      ]][
        ,
        c(
          "liningID", "reinforcementCaseID", "reinforcementCaseOrder",
          "barDiameterMm", "barSpacingMm", "reinforcementArrangementID",
          "maximumRadialUtilization", "localPMStatus",
          "maximumShearUtilization", "shearStatus"
        ),
        drop = FALSE
      ]
    )
    Demands[[i]] <- cbind(
      Modulus,
      Products[[
        "shotcrete.axial.flexure.reinforcement.governing.demands.csv",
        exact = TRUE
      ]][
        ,
        c(
          "liningID", "reinforcementCaseID", "interfaceID", "thetaDeg",
          "axialDemandKnPerM", "bendingDemandKnMPerM", "radialUtilization"
        ),
        drop = FALSE
      ]
    )
  }
  OUT <- list(
    "sensitivity.steel.extrema.csv" = do.call(rbind, Steel),
    "sensitivity.aashto.checks.csv" = do.call(rbind, Aashto),
    "sensitivity.plain.checks.csv" = do.call(rbind, Plain),
    "sensitivity.pm.sweep.csv" = do.call(rbind, Sweep),
    "sensitivity.pm.demands.csv" = do.call(rbind, Demands)
  )
  Directory <- normalizePath(outputDirectory, mustWork = TRUE)
  for (s in names(OUT)) {
    DATA <- OUT[[s]]
    rownames(DATA) <- NULL
    OUT[[s]] <- DATA
    utils::write.csv(
      DATA,
      file.path(Directory, s),
      row.names = FALSE,
      na = ""
    )
  }
  OUT
}
