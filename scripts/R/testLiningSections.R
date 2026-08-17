# Verifies steel-thickness and homogeneous-concrete section helpers.

Arguments <- commandArgs(trailingOnly = FALSE)
FileArgument <- grep("^--file=", Arguments, value = TRUE)
if (length(FileArgument) != 1L) {
  stop("Run with Rscript scripts/R/testLiningSections.R.", call. = FALSE)
}
ScriptPath <- normalizePath(sub("^--file=", "", FileArgument))
projectRoot <- normalizePath(file.path(dirname(ScriptPath), "..", ".."))
source(
  file.path(projectRoot, "scripts", "setup", "calculationFunctions.R"),
  local = TRUE
)

runLiningSectionTests <- function() {
  Reference <- data.frame(
    profileID = "cspi-76x25-csp-sheet",
    referenceRowID = "cspi-76x25-2.8",
    nominalPitchMm = 76,
    nominalDepthMm = 25,
    actualPitchMm = 76.2,
    actualDepthMm = 25.4,
    corrugationRadiusMm = 14.29,
    specifiedThicknessMm = 2.8,
    designBaseThicknessMm = 2.64,
    areaMm2PerMm = 3.281,
    tangentLengthMm = 18.75,
    tangentAngleDeg = 30,
    inertiaMm4PerMm = 249.73,
    sectionModulusMm3PerMm = 17.81,
    gyrationRadiusMm = sqrt(249.73 / 3.281),
    developedWidthFactor = 3.281 / 2.64,
    evidenceLevel = "DP",
    sourceKey = "CSPIHandbookChapter2",
    sourceLocator = "Table 2.4",
    stringsAsFactors = FALSE
  )
  Section.reference <- selectCorrugatedSection(
    reference = Reference,
    profileID = "cspi-76x25-csp-sheet",
    referenceRowID = "cspi-76x25-2.8"
  )
  Section.same <- scaleCorrugatedSectionThickness(
    referenceSection = Section.reference,
    remainingBaseThicknessMm = 2.64
  )
  stopifnot(
    identical(Section.same$areaMm2PerMm, Section.reference$areaMm2PerMm),
    identical(Section.same$inertiaMm4PerMm, Section.reference$inertiaMm4PerMm),
    identical(
      Section.same$sectionModulusMm3PerMm,
      Section.reference$sectionModulusMm3PerMm
    )
  )

  Section.half <- calculateCorrugatedRingSection(
    referenceSection = Section.reference,
    remainingBaseThicknessMm = 1.32,
    youngModulusKPa = 200e6,
    radiusM = 1.315
  )
  stopifnot(
    abs(Section.half$section$areaMm2PerMm - 3.281 / 2) < 1e-12,
    abs(Section.half$section$inertiaMm4PerMm - 249.73 / 2) < 1e-12,
    abs(Section.half$rigidity$sectionRatio -
      calculateRingSection(
        youngModulus = 200e6,
        area = 3.281e-3,
        inertia = 249.73e-9,
        radius = 1.315
      )$sectionRatio) < 1e-15
  )

  Thickness.invalid <- tryCatch(
    scaleCorrugatedSectionThickness(
      referenceSection = Section.reference,
      remainingBaseThicknessMm = 2.65
    ),
    error = function(e) conditionMessage(e)
  )
  stopifnot(grepl("must not exceed", Thickness.invalid, fixed = TRUE))

  Concrete <- calculateConcreteRingSection(
    analysisThicknessM = 0.15,
    analysisModulusKPa = 25e6,
    centroidalRadiusM = 1.315,
    stiffnessBasisID = "gross-uncracked-short-term"
  )
  stopifnot(
    abs(Concrete$areaM2PerM - 0.15) < 1e-15,
    abs(Concrete$inertiaM4PerM - 0.15^3 / 12) < 1e-15,
    abs(Concrete$rigidity$equivalentThickness - 0.15) < 1e-15,
    identical(Concrete$stiffnessBasisID, "gross-uncracked-short-term")
  )
  invisible(TRUE)
}

runLiningSectionTests()
cat("PASS: lining-section helpers.\n")
