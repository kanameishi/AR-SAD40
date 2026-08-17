runAisiFlexuralBoundTests <- function() {
  Arguments <- commandArgs(trailingOnly = FALSE)
  FileArgument <- grep("^--file=", Arguments, value = TRUE)
  if (length(FileArgument) != 1L) {
    stop("Run with Rscript scripts/R/testAisiFlexuralBound.R.", call. = FALSE)
  }
  ScriptPath <- normalizePath(sub("^--file=", "", FileArgument))
  Root <- normalizePath(file.path(dirname(ScriptPath), "..", ".."))
  source(file.path(Root, "scripts", "R", "aisiFlexuralBound.R"))

  assertNear <- function(actual, expected, tolerance, label) {
    Error <- max(abs(actual - expected))
    if (!is.finite(Error) || Error > tolerance) {
      stop(label, " failed; error = ", Error, ".", call. = FALSE)
    }
  }
  assertError <- function(expression, pattern, label) {
    Message <- tryCatch(
      {
        expression()
        NA_character_
      },
      error = function(e) conditionMessage(e)
    )
    if (is.na(Message) || !grepl(pattern, Message, fixed = TRUE)) {
      stop(label, " did not produce the expected error.", call. = FALSE)
    }
  }

  Screen <- screenAisiFlexuralDemand(
    bendingMomentKnMPerM = c(-14.4159166312977, -21.6210207979644),
    areaMm2PerMm = 3.281,
    inertiaMm4PerMm = 249.73,
    sectionModulusMm3PerMm = 17.81,
    yieldStrengthMPa = 250
  )
  assertNear(Screen$extremeFiberDistanceMm[1L], 249.73 / 17.81, 1e-12, "distance")
  assertNear(
    Screen$plasticModulusBoundMm3PerMm[1L],
    3.281 * 249.73 / 17.81,
    1e-12,
    "plastic modulus bound"
  )
  assertNear(Screen$reserveBoundKnMPerM[1L], 5.565625, 1e-12, "reserve bound")
  assertNear(
    Screen$plasticBoundKnMPerM[1L],
    11.5014616788321,
    1e-12,
    "plastic bound"
  )
  assertNear(
    Screen$nominalBoundKnMPerM[1L],
    Screen$plasticBoundKnMPerM[1L],
    0,
    "governing bound"
  )
  assertNear(
    Screen$demandBoundRatio,
    c(1.253398657827074, 1.879849831413762),
    1e-12,
    "demand ratios"
  )
  stopifnot(
    all(Screen$boundBasisID == "plastic-geometric"),
    all(Screen$screenStatus == "prescriptive-bound-exceeded")
  )

  Screen.scaled <- screenAisiFlexuralDemand(
    bendingMomentKnMPerM = Screen$bendingMomentKnMPerM,
    areaMm2PerMm = 3.281,
    inertiaMm4PerMm = 249.73,
    sectionModulusMm3PerMm = 17.81,
    yieldStrengthMPa = 500
  )
  assertNear(
    Screen.scaled$nominalBoundKnMPerM,
    2 * Screen$nominalBoundKnMPerM,
    1e-12,
    "yield-strength scaling"
  )

  assertError(
    function() screenAisiFlexuralDemand(
      bendingMomentKnMPerM = 1,
      areaMm2PerMm = 0,
      inertiaMm4PerMm = 1,
      sectionModulusMm3PerMm = 1,
      yieldStrengthMPa = 250
    ),
    "areaMm2PerMm must be one positive finite number",
    "zero area"
  )
  assertError(
    function() screenAisiFlexuralDemand(
      bendingMomentKnMPerM = 1,
      areaMm2PerMm = 1,
      inertiaMm4PerMm = c(1, 2),
      sectionModulusMm3PerMm = 1,
      yieldStrengthMPa = 250
    ),
    "inertiaMm4PerMm must be one positive finite number",
    "vector inertia"
  )

  Screen.sign <- screenAisiFlexuralDemand(
    bendingMomentKnMPerM = c(-2, 2),
    areaMm2PerMm = 1,
    inertiaMm4PerMm = 1,
    sectionModulusMm3PerMm = 1,
    yieldStrengthMPa = 250
  )
  stopifnot(
    identical(Screen.sign$absoluteMomentKnMPerM, c(2, 2)),
    identical(Screen.sign$demandBoundRatio, rep(Screen.sign$demandBoundRatio[1L], 2L))
  )

  Screen.edge <- screenAisiFlexuralDemand(
    bendingMomentKnMPerM = c(0.3125, 0.3, 0.3125001),
    areaMm2PerMm = 1,
    inertiaMm4PerMm = 0.01,
    sectionModulusMm3PerMm = 1,
    yieldStrengthMPa = 250
  )
  stopifnot(
    all(Screen.edge$boundBasisID == "inelastic-reserve"),
    identical(
      Screen.edge$screenStatus,
      c("inconclusive", "inconclusive", "prescriptive-bound-exceeded")
    )
  )

  assertError(
    function() screenAisiFlexuralDemand(
      bendingMomentKnMPerM = numeric(),
      areaMm2PerMm = 1,
      inertiaMm4PerMm = 1,
      sectionModulusMm3PerMm = 1,
      yieldStrengthMPa = 250
    ),
    "bendingMomentKnMPerM must contain finite numbers",
    "empty moment"
  )

  message("PASS: AISI prescriptive flexural upper bound")
  invisible(TRUE)
}

runAisiFlexuralBoundTests()
