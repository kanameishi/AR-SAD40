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
  if (Section$propertyModelID == "published-exact-row") {
    RequiredReference <- c(
      "specifiedThicknessMm", "designBaseThicknessMm",
      "sectionModulusMm3PerMm"
    )
    if (length(setdiff(RequiredReference, names(Reference))) > 0L ||
        !("referenceRowID" %in% names(Section))) {
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
      Area = Row$areaMm2PerMm,
      Inertia = Row$inertiaMm4PerMm,
      SectionModulus = Row$sectionModulusMm3PerMm,
      check.names = FALSE,
      stringsAsFactors = FALSE
    )
    return(knitr::kable(
      Output,
      digits = c(0, 0, 3, 2, 2),
      col.names = c("$t_s$", "$t_d$", "$A_p$", "$I_p$", "$S_p$"),
      align = rep("r", 5),
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
