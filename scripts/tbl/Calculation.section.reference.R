buildCalculationSectionReferenceTable <- function(pathReference, pathSection) {
  if (!file.exists(pathReference) || !file.exists(pathSection)) {
    stop("The section-property products are not available.", call. = FALSE)
  }
  Reference <- utils::read.csv(
    pathReference,
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  Section <- utils::read.csv(
    pathSection,
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  RequiredCommon <- c(
    "referenceRowID", "areaMm2PerMm", "inertiaMm4PerMm"
  )
  if (length(setdiff(RequiredCommon, names(Reference))) > 0L ||
      !("propertyModelID" %in% names(Section)) || nrow(Section) != 1L) {
    stop("The section-property products have an invalid schema.", call. = FALSE)
  }
  if (Section$propertyModelID %in% c(
    "published-exact-row", "uniform-thinning-fixed-midline"
  )) {
    RequiredReference <- c(
      "specifiedThicknessMm", "designBaseThicknessMm",
      "sectionModulusMm3PerMm"
    )
    RequiredSection <- c(
      "referenceRowID", "remainingBaseThicknessMm", "areaMm2PerMm",
      "inertiaMm4PerMm", "sectionModulusMm3PerMm"
    )
    if (length(setdiff(RequiredReference, names(Reference))) > 0L ||
        length(setdiff(RequiredSection, names(Section))) > 0L) {
      stop("The exact section-property products have an invalid schema.", call. = FALSE)
    }
    Row <- Reference[
      Reference$referenceRowID == Section$referenceRowID,
      ,
      drop = FALSE
    ]
    if (nrow(Row) != 1L) {
      stop("The exact reference row is not available.", call. = FALSE)
    }
    Output <- data.frame(
      ThicknessSpecified = Row$specifiedThicknessMm,
      ThicknessDesign = Row$designBaseThicknessMm,
      ThicknessRemaining = Section$remainingBaseThicknessMm,
      Area = Section$areaMm2PerMm,
      Inertia = Section$inertiaMm4PerMm,
      SectionModulus = Section$sectionModulusMm3PerMm,
      check.names = FALSE,
      stringsAsFactors = FALSE
    )
    return(knitr::kable(
      Output,
      digits = c(1, 2, 1, 0, 0, 0),
      col.names = c("$t_s$", "$t_d$", "$t_{rem}$", "$A_p$", "$I_p$", "$S_p$"),
      align = rep("r", 6),
      escape = FALSE
    ))
  }
  RequiredReference <- "baseThicknessMm"
  RequiredSection <- c("lowerReferenceRowID", "upperReferenceRowID")
  if (length(setdiff(RequiredReference, names(Reference))) > 0L ||
      length(setdiff(RequiredSection, names(Section))) > 0L) {
    stop("The interpolation products have an invalid schema.", call. = FALSE)
  }
  RowIDs <- c(Section$lowerReferenceRowID, Section$upperReferenceRowID)
  Rows <- Reference[match(RowIDs, Reference$referenceRowID), , drop = FALSE]
  if (nrow(Rows) != 2L || anyNA(Rows$referenceRowID)) {
    stop("The interpolation reference rows are not available.", call. = FALSE)
  }
  Output <- data.frame(
    Index = seq_len(nrow(Rows)),
    Thickness = Rows$baseThicknessMm,
    Area = Rows$areaMm2PerMm,
    Inertia = Rows$inertiaMm4PerMm,
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  knitr::kable(
    Output,
    digits = c(0, 5, 8, 7),
    col.names = c("$i$", "$t_i$", "$A_i$", "$I_i$"),
    align = rep("r", 4),
    escape = FALSE
  )
}
