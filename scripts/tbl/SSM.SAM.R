# nolint start
if (!exists("SSM_MODEL", inherits = FALSE) || !identical(SSM_MODEL, "SAM")) {
  stop("SSM.SAM.R: SSM_MODEL must be 'SAM'.", call. = FALSE)
}
if (!exists("SSM_FILE", inherits = FALSE) || length(SSM_FILE) != 1L) {
  stop("SSM.SAM.R: set SSM_FILE to oq/data/SSMTable.Rds.", call. = FALSE)
}
if (!file.exists(SSM_FILE)) {
  stop(sprintf("SSM.SAM.R: required inventory not found: %s.", SSM_FILE), call. = FALSE)
}

DATA <- readRDS(SSM_FILE)
Meta <- attr(DATA, "oqt", exact = TRUE)
Schema <- c(
  "ID", "siteID", "providerID", "sourceName", "sourceType", "trt",
  "mfdType", "aValue", "bValue", "minMag", "maxMag",
  "mmaxLTType", "mmaxLTValues", "mmaxLTWeights",
  "abLTType", "abLTValues", "abLTWeights",
  "usd", "lsd", "hypoDepths", "meanHypoDepth", "midSeismoDepth",
  "dip", "rake", "traceLength", "seismoThickness", "downDipWidth",
  "magScaleRel", "ruptAspectRatio", "totalRate", "nMagBins",
  "lonMin", "lonMax", "latMin", "latMax", "hostKind", "Rjb", "Rrup",
  "distMethod", "nModelBranches", "branchVaries", "file"
)
Classes <- stats::setNames(rep("character", length(Schema)), Schema)
Classes[c("Rjb", "Rrup")] <- "numeric"
Classes[c("nModelBranches", "branchVaries")] <- "integer"

if (!inherits(DATA, "data.frame") || !identical(names(DATA), Schema)) {
  stop("SSM.SAM.R: SSMTable.Rds has an incompatible schema.", call. = FALSE)
}
if (!identical(vapply(DATA, class, character(1L)), Classes)) {
  stop("SSM.SAM.R: SSMTable.Rds has incompatible column types.", call. = FALSE)
}
RequiredMeta <- c(
  "producer", "oqt", "written", "units", "keyRule", "selection", "engine",
  "inputs"
)
if (!is.list(Meta) || any(!RequiredMeta %in% names(Meta))) {
  stop("SSM.SAM.R: SSMTable.Rds lacks required OQT provenance.", call. = FALSE)
}
if (!identical(Meta$producer, "ssm / runSSM.R") ||
    length(Meta$oqt) != 1L || !grepl("^[0-9a-f]{7,40}$", Meta$oqt) ||
    length(Meta$written) != 1L || !nzchar(Meta$written) ||
    length(Meta$engine) != 1L || !grepl("oq-3[.]26[.]2", Meta$engine) ||
    !identical(
      Meta$keyRule,
      paste0(
        "providerID normalized as in runAEPS.R so SSMTable joins AEPSTable ",
        "on (ID, siteID, providerID); SRMwTable keeps the raw sourceID and ",
        "needs consumer-side normalization"
      )
    ) ||
    !identical(
      Meta$selection,
      "complete: every source in the model, no distance cut and no ranking truncation"
    )) {
  stop("SSM.SAM.R: SSMTable.Rds provenance is incomplete or incompatible.", call. = FALSE)
}
Units <- c(minMag = "Mw", maxMag = "Mw", usd = "km", lsd = "km")
if (is.null(Meta$units) || !identical(unname(Meta$units[names(Units)]), unname(Units))) {
  stop("SSM.SAM.R: SSMTable.Rds magnitude or depth units are incompatible.", call. = FALSE)
}

DT <- data.table::as.data.table(DATA)
IdentityCols <- c("ID", "siteID", "providerID")
if (!nrow(DT) ||
    DT[, any(vapply(
      .SD,
      function(x) any(is.na(x) | !nzchar(trimws(x))),
      logical(1L)
    )), .SDcols = IdentityCols] ||
    data.table::uniqueN(DT$ID) != 1L ||
    data.table::uniqueN(DT$siteID) < 1L) {
  stop("SSM.SAM.R: inventory must contain one model ID and at least one site.", call. = FALSE)
}
NormalizedProvider <- sub(
  "[:;].*$", "", sub("!.*$", "", trimws(DT$providerID))
)
if (any(DT$providerID != NormalizedProvider)) {
  stop("SSM.SAM.R: providerID is not normalized as declared.", call. = FALSE)
}
SiteCount <- data.table::uniqueN(DT$siteID)
ExpectedInputs <- c("ssmLT_SAM.xml", sprintf("%d sites", SiteCount))
if (!identical(as.character(Meta$inputs), ExpectedInputs)) {
  stop("SSM.SAM.R: inventory provenance does not identify the SAM source model.", call. = FALSE)
}
if (DT[, any(is.na(providerID) | !nzchar(trimws(providerID)))] ||
    DT[, anyDuplicated(.SD), .SDcols = c("ID", "siteID", "providerID")]) {
  stop("SSM.SAM.R: inventory source identity is invalid.", call. = FALSE)
}
AUX <- DT[, .N, by = providerID]
if (any(AUX$N != SiteCount)) {
  stop("SSM.SAM.R: every SAM source must be represented at every declared site.", call. = FALSE)
}
UsedFields <- c(
  "trt", "sourceType", "mfdType", "minMag", "maxMag", "usd", "lsd",
  "hypoDepths", "file"
)
if (DT[, any(nModelBranches != 1L | branchVaries != 0L)] ||
    DT[, any(vapply(
      .SD,
      function(x) any(grepl("|", x, fixed = TRUE), na.rm = TRUE),
      logical(1L)
    )), .SDcols = UsedFields]) {
  stop("SSM.SAM.R: inventory contains unresolved source-model branches.", call. = FALSE)
}

IntrinsicCols <- setdiff(
  names(DT), c("siteID", "hostKind", "Rjb", "Rrup", "distMethod")
)
DT <- unique(DT[, ..IntrinsicCols])
if (anyDuplicated(DT$providerID)) {
  stop("SSM.SAM.R: source properties differ between project sites.", call. = FALSE)
}

Map <- data.table::data.table(
  trt = c("ASC", "ASC", "SCC", "SCC", "SIF", "SIS"),
  sourceType = c(
    "SimpleFaultSource", "MultiPointSource", "SimpleFaultSource",
    "MultiPointSource", "ComplexFaultSource", "NonParametricSeismicSource"
  ),
  Component = paste0("C", seq_len(6L)),
  MFD = c("MFD1", "MFD2", "MFD1", "MFD2", "MFD5", "MFD4"),
  N = c(354L, 30L, 4L, 3L, 9L, 149L)
)
DT[Map, on = .(trt, sourceType), `:=`(
  Component = i.Component,
  MFD = i.MFD
)]
if (DT[, any(is.na(Component) | is.na(MFD))]) {
  stop("SSM.SAM.R: inventory contains an unclassified TRT/source combination.", call. = FALSE)
}

Observed <- DT[, .(N = .N), by = .(trt, sourceType, Component, MFD)]
data.table::setorder(Observed, Component)
Expected <- Map[, .(trt, sourceType, Component, MFD, N)]
if (!identical(Observed, Expected)) {
  stop("SSM.SAM.R: SAM component counts do not match the approved inventory.", call. = FALSE)
}
Recurrence <- DT[, .(
  Types = paste(sort(unique(data.table::fcoalesce(mfdType, "<NA>"))), collapse = "|")
), by = Component]
data.table::setorder(Recurrence, Component)
ExpectedTypes <- c(
  "EvenlyDiscretizedMFD", "MultiMFD", "EvenlyDiscretizedMFD", "MultiMFD",
  "EvenlyDiscretizedMFD|TruncatedGRMFD", "<NA>"
)
if (!identical(Recurrence$Types, ExpectedTypes)) {
  stop("SSM.SAM.R: SAM recurrence classes do not match the approved inventory.", call. = FALSE)
}
InterfaceMFD <- DT[Component == "C5", .N, by = mfdType]
data.table::setorder(InterfaceMFD, mfdType)
ExpectedInterfaceMFD <- data.table::data.table(
  mfdType = c("EvenlyDiscretizedMFD", "TruncatedGRMFD"),
  N = c(7L, 2L)
)
if (!identical(InterfaceMFD, ExpectedInterfaceMFD)) {
  stop("SSM.SAM.R: SAM interface recurrence mixture is incompatible.", call. = FALSE)
}

InterfaceFiles <- file.path(
  "ssm_SAM", "interface",
  c(paste0("int_", seq_len(7L), ".xml"), "int_pan_uh.xml", "int_lan_uh.xml")
)
if (!setequal(DT[Component == "C5", file], InterfaceFiles) ||
    DT[Component == "C5", any(!is.na(usd) | !is.na(lsd))]) {
  stop("SSM.SAM.R: SAM interface geometry set is incompatible.", call. = FALSE)
}
SampleN <- suppressWarnings(as.integer(sub(
  "^sample n=", "", DT[Component == "C6", hypoDepths]
)))
if (any(!is.finite(SampleN) | SampleN < 1L | SampleN > 200L)) {
  stop("SSM.SAM.R: SAM intraslab depth sampling is incompatible.", call. = FALSE)
}

DT[, `:=`(
  MinMag = suppressWarnings(as.numeric(minMag)),
  MaxMag = suppressWarnings(as.numeric(maxMag)),
  MinDepth = suppressWarnings(as.numeric(usd)),
  MaxDepth = suppressWarnings(as.numeric(lsd))
)]
if (DT[, any(!is.finite(MinMag) | !is.finite(MaxMag))] ||
    DT[Component != "C5", any(!is.finite(MinDepth) | !is.finite(MaxDepth))]) {
  stop("SSM.SAM.R: SAM magnitude or depth fields are not numeric.", call. = FALSE)
}
if (DT[, any(MinMag > MaxMag)] ||
    DT[Component != "C5", any(
      MinDepth < 0 | MaxDepth < 0 | MinDepth > MaxDepth
    )]) {
  stop("SSM.SAM.R: SAM magnitude or depth intervals are invalid.", call. = FALSE)
}

AUX <- DT[, .(
  MwMin = min(MinMag),
  MwMax = max(MaxMag),
  zMin = if (all(is.na(MinDepth))) NA_real_ else min(MinDepth, na.rm = TRUE),
  zMax = if (all(is.na(MaxDepth))) NA_real_ else max(MaxDepth, na.rm = TRUE)
), by = Component]

# The RDS has no interface z coordinates. These audited extrema belong to the
# exact nine-file interface set validated above and come from its 3-D nodes.
DepthInterface <- c(7.0, 60.0352)
AUX[Component == "C5", `:=`(zMin = DepthInterface[[1L]], zMax = DepthInterface[[2L]])]
Map[AUX, on = "Component", `:=`(
  MwMin = i.MwMin,
  MwMax = i.MwMax,
  zMin = i.zMin,
  zMax = i.zMax
)]
AUX <- Map
AUX[, Mw := sprintf("%.2f–%.2f", MwMin, MwMax)]
AUX[, z := paste0(
  sub("[.]0$", "", sprintf("%.1f", zMin)),
  "–",
  sub("[.]0$", "", sprintf("%.1f", zMax))
)]
AUX[Component %in% c("C5", "C6"), z := sprintf("%.1f–%.1f", zMin, zMax)]
AUX[Component == "C5", z := paste0(z, "*")]
AUX <- AUX[, .(TRT = trt, Component, N, MFD, Mw, z)]
AUX <- data.table::rbindlist(list(
  AUX,
  data.table::data.table(
    TRT = "Total", Component = "", N = sum(AUX$N), MFD = "", Mw = "", z = ""
  )
), use.names = TRUE)

TBL <- AUX |> buildTable(
  library          = "flextable",
  align.body       = "center",
  font.size.body   = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |> flextable::set_header_labels(Component = "Comp.") |>
  .mathHeader(c(N = "N", Mw = "M_w", z = "z")) |>
  flextable::set_table_properties(layout = "autofit")
TBL <- flextable::align(TBL, j = "N", align = "right", part = "body")

rm(
  AUX, Classes, DATA, DepthInterface, DT, Expected, ExpectedInputs,
  ExpectedInterfaceMFD, ExpectedTypes, InterfaceFiles, InterfaceMFD,
  IdentityCols, IntrinsicCols, Map, Meta, NormalizedProvider, Observed,
  Recurrence, RequiredMeta, SampleN, Schema, SiteCount, Units, UsedFields
)
# nolint end
