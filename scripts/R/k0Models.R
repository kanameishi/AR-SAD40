# Select and evaluate one supported at-rest earth-pressure relationship.

if (any(!vapply(
  c(
    "k0NormallyConsolidated",
    "k0ElasticConfined",
    "k0MayneKulhawyUnloading",
    "k0MayneKulhawyReload",
    "checkK0PassiveDomain"
  ),
  function(s) exists(s, mode = "function", inherits = TRUE),
  logical(1)
))) {
  stop("Source scripts/R/ringLoads.R before scripts/R/k0Models.R.", call. = FALSE)
}

estimateK0 <- function(
  modelID,
  k0 = NULL,
  frictionAngleDeg = NULL,
  poissonRatio = NULL,
  ocr = NULL,
  ocrMaximum = NULL
) {
  if (!is.character(modelID) || length(modelID) != 1L || !nzchar(modelID)) {
    stop("modelID must be one non-empty string.", call. = FALSE)
  }

  LIST <- list(
    k0 = k0,
    frictionAngleDeg = frictionAngleDeg,
    poissonRatio = poissonRatio,
    ocr = ocr,
    ocrMaximum = ocrMaximum
  )
  BranchFields <- switch(
    modelID,
    "adopted-constant" = "k0",
    "elastic-confined" = "poissonRatio",
    "jaky-nc" = "frictionAngleDeg",
    "mayne-kulhawy-unloading" = c("frictionAngleDeg", "ocr"),
    "mayne-kulhawy-reload" = c("frictionAngleDeg", "ocr", "ocrMaximum"),
    stop("Unsupported K0 modelID: ", modelID, ".", call. = FALSE)
  )
  Missing <- BranchFields[vapply(LIST[BranchFields], is.null, logical(1))]
  Unexpected <- setdiff(
    names(LIST)[!vapply(LIST, is.null, logical(1))],
    BranchFields
  )
  if (length(Missing) > 0L) {
    stop(
      "The selected K0 branch is missing: ",
      paste(Missing, collapse = ", "),
      ".",
      call. = FALSE
    )
  }
  if (length(Unexpected) > 0L) {
    stop(
      "The selected K0 branch received unsupported parameters: ",
      paste(Unexpected, collapse = ", "),
      ".",
      call. = FALSE
    )
  }

  OUT <- list(
    modelID = modelID,
    frictionAngleDeg = NA_real_,
    poissonRatio = NA_real_,
    ocr = NA_real_,
    ocrMaximum = NA_real_,
    k0Input = NA_real_,
    k0Derived = NA_real_,
    k0Applied = NA_real_,
    domainStatus = "not-applicable",
    passiveCoefficient = NA_real_,
    ocrLimit = NA_real_
  )

  if (modelID == "adopted-constant") {
    .assertFiniteScalar(k0, "k0", minimum = 0)
    OUT$k0Input <- k0
    OUT$k0Applied <- k0
  } else if (modelID == "elastic-confined") {
    OUT$poissonRatio <- poissonRatio
    OUT$k0Derived <- k0ElasticConfined(
      poissonRatio = poissonRatio
    )
    OUT$k0Applied <- OUT$k0Derived
  } else if (modelID == "jaky-nc") {
    OUT$frictionAngleDeg <- frictionAngleDeg
    OUT$k0Derived <- k0NormallyConsolidated(
      frictionAngleDeg = frictionAngleDeg
    )
    OUT$k0Applied <- OUT$k0Derived
  } else if (modelID == "mayne-kulhawy-unloading") {
    Domain <- checkK0PassiveDomain(
      frictionAngleDeg = frictionAngleDeg,
      ocrMaximum = ocr
    )
    if (!Domain$valid) {
      stop("The selected K0 unloading state reaches the passive limit.", call. = FALSE)
    }
    OUT$frictionAngleDeg <- frictionAngleDeg
    OUT$ocr <- ocr
    OUT$k0Derived <- k0MayneKulhawyUnloading(
      frictionAngleDeg = frictionAngleDeg,
      ocr = ocr
    )
    OUT$k0Applied <- OUT$k0Derived
    OUT$domainStatus <- "within-domain"
    OUT$passiveCoefficient <- Domain$passiveCoefficient
    OUT$ocrLimit <- Domain$ocrLimit
  } else if (modelID == "mayne-kulhawy-reload") {
    Domain <- checkK0PassiveDomain(
      frictionAngleDeg = frictionAngleDeg,
      ocrMaximum = ocrMaximum
    )
    if (!Domain$valid) {
      stop("The selected K0 reload state reaches the passive limit.", call. = FALSE)
    }
    OUT$frictionAngleDeg <- frictionAngleDeg
    OUT$ocr <- ocr
    OUT$ocrMaximum <- ocrMaximum
    OUT$k0Derived <- k0MayneKulhawyReload(
      frictionAngleDeg = frictionAngleDeg,
      ocr = ocr,
      ocrMaximum = ocrMaximum
    )
    OUT$k0Applied <- OUT$k0Derived
    OUT$domainStatus <- "within-domain"
    OUT$passiveCoefficient <- Domain$passiveCoefficient
    OUT$ocrLimit <- Domain$ocrLimit
  }

  if (!is.finite(OUT$k0Applied) || OUT$k0Applied < 0) {
    stop("The selected K0 branch did not produce a finite non-negative value.", call. = FALSE)
  }
  OUT
}
