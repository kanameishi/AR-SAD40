# nolint start
if (!exists("SSM_MODEL", inherits = FALSE) || !identical(SSM_MODEL, "ARB")) {
  stop("SSM.ARB.R: SSM_MODEL must be 'ARB'.", call. = FALSE)
}
if (!exists("SSM_FILE", inherits = FALSE) || length(SSM_FILE) != 1L) {
  stop("SSM.ARB.R: set SSM_FILE to oq/data/SSMTable.Rds.", call. = FALSE)
}
if (!file.exists(SSM_FILE)) {
  stop("SSM.ARB.R: required inventory not found: ", SSM_FILE, ".", call. = FALSE)
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
  stop("SSM.ARB.R: SSMTable.Rds has an incompatible schema.", call. = FALSE)
}
if (!identical(vapply(DATA, class, character(1L)), Classes)) {
  stop("SSM.ARB.R: SSMTable.Rds has incompatible column types.", call. = FALSE)
}
RequiredMeta <- c(
  "producer", "oqt", "written", "units", "keyRule", "selection", "engine",
  "inputs"
)
if (!is.list(Meta) || any(!RequiredMeta %in% names(Meta))) {
  stop("SSM.ARB.R: SSMTable.Rds lacks required OQT provenance.", call. = FALSE)
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
  stop("SSM.ARB.R: SSMTable.Rds provenance is incomplete or incompatible.", call. = FALSE)
}
Units <- c(minMag = "Mw", maxMag = "Mw", usd = "km", lsd = "km")
if (is.null(Meta$units) || !identical(unname(Meta$units[names(Units)]), unname(Units))) {
  stop("SSM.ARB.R: SSMTable.Rds magnitude or depth units are incompatible.", call. = FALSE)
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
  stop("SSM.ARB.R: inventory must contain one model ID and at least one site.", call. = FALSE)
}
NormalizedProvider <- sub(
  "[:;].*$", "", sub("!.*$", "", trimws(DT$providerID))
)
if (any(DT$providerID != NormalizedProvider)) {
  stop("SSM.ARB.R: providerID is not normalized as declared.", call. = FALSE)
}
SiteCount <- data.table::uniqueN(DT$siteID)
ExpectedInputs <- c("ssmLT_ARB.xml", sprintf("%d sites", SiteCount))
if (!identical(as.character(Meta$inputs), ExpectedInputs)) {
  stop("SSM.ARB.R: inventory provenance does not identify the ARB source model.", call. = FALSE)
}
if (DT[, any(is.na(providerID) | !nzchar(trimws(providerID)))] ||
    DT[, anyDuplicated(.SD), .SDcols = c("ID", "siteID", "providerID")]) {
  stop("SSM.ARB.R: inventory source identity is invalid.", call. = FALSE)
}
AUX <- DT[, .N, by = providerID]
if (any(AUX$N != SiteCount)) {
  stop("SSM.ARB.R: every ARB source must be represented at every declared site.", call. = FALSE)
}

IntrinsicCols <- setdiff(
  names(DT), c("siteID", "hostKind", "Rjb", "Rrup", "distMethod")
)
DT <- unique(DT[, ..IntrinsicCols])
if (anyDuplicated(DT$providerID)) {
  stop("SSM.ARB.R: source properties differ between project sites.", call. = FALSE)
}

# The adopted tree combines two occurrence alternatives, two MIE source
# selections, and three maximum-magnitude perturbations. Sources whose
# properties change between branches carry one pipe-separated maximum
# magnitude per perturbation; every other intrinsic field must be resolved.
if (DT[, any(nModelBranches < 1L | !branchVaries %in% c(0L, 1L))]) {
  stop("SSM.ARB.R: inventory branch membership is invalid.", call. = FALSE)
}
UsedFields <- c(
  "trt", "sourceType", "mfdType", "minMag", "usd", "lsd", "hypoDepths"
)
if (DT[, any(vapply(
  .SD,
  function(x) any(grepl("|", x, fixed = TRUE), na.rm = TRUE),
  logical(1L)
)), .SDcols = UsedFields]) {
  stop("SSM.ARB.R: inventory contains unresolved source-model branches.", call. = FALSE)
}
if (DT[branchVaries == 0L, any(grepl("|", maxMag, fixed = TRUE))]) {
  stop("SSM.ARB.R: branch-invariant sources carry branch alternatives.", call. = FALSE)
}

TrtOrder <- c("ASC", "SCC", "SIF", "SIS")
TypeOrder <- c(
  "AreaSource", "PointSource", "MultiPointSource", "SimpleFaultSource",
  "ComplexFaultSource", "NonParametricSeismicSource"
)
if (DT[, any(!trt %in% TrtOrder | !sourceType %in% TypeOrder)]) {
  stop("SSM.ARB.R: inventory contains an unclassified TRT/source combination.", call. = FALSE)
}
AUX <- DT[, .(Types = data.table::uniqueN(mfdType)), by = .(trt, sourceType)]
if (any(AUX$Types != 1L)) {
  stop("SSM.ARB.R: recurrence class varies within a TRT/source combination.", call. = FALSE)
}

# Components and MFD codes are derived from the inventory itself, in
# tectonic order: sources are never counted against a hardcoded census.
Map <- unique(DT[, .(trt, sourceType, mfdType)])
Map[, `:=`(
  TrtRank = match(trt, TrtOrder),
  TypeRank = match(sourceType, TypeOrder)
)]
data.table::setorder(Map, TrtRank, TypeRank)
Map[, Component := paste0("C", seq_len(.N))]
MfdLevels <- unique(Map$mfdType)
Map[, MFD := paste0("MFD", match(mfdType, MfdLevels))]
DT[Map, on = .(trt, sourceType), `:=`(
  Component = i.Component,
  MFD = i.MFD
)]

DT[, `:=`(
  MinMag = suppressWarnings(as.numeric(minMag)),
  MaxMagLo = vapply(
    strsplit(maxMag, "|", fixed = TRUE),
    function(x) min(suppressWarnings(as.numeric(x))),
    numeric(1L)
  ),
  MaxMag = vapply(
    strsplit(maxMag, "|", fixed = TRUE),
    function(x) max(suppressWarnings(as.numeric(x))),
    numeric(1L)
  ),
  MinDepth = suppressWarnings(as.numeric(usd)),
  MaxDepth = suppressWarnings(as.numeric(lsd))
)]
if (DT[, any(!is.finite(MinMag) | !is.finite(MaxMagLo) | !is.finite(MaxMag))] ||
    DT[, any(MinMag > MaxMagLo | MaxMagLo > MaxMag)]) {
  stop("SSM.ARB.R: ARB magnitude fields are not numeric or are inconsistent.", call. = FALSE)
}
if (DT[sourceType != "ComplexFaultSource",
        any(!is.finite(MinDepth) | !is.finite(MaxDepth))] ||
    DT[sourceType != "ComplexFaultSource",
       any(MinDepth < 0 | MaxDepth < 0 | MinDepth > MaxDepth)]) {
  stop("SSM.ARB.R: ARB depth fields are not numeric or are inconsistent.", call. = FALSE)
}

AUX <- DT[, .(
  N = .N,
  MwMin = min(MinMag),
  MwMax = max(MaxMag),
  zMin = if (all(is.na(MinDepth))) NA_real_ else min(MinDepth, na.rm = TRUE),
  zMax = if (all(is.na(MaxDepth))) NA_real_ else max(MaxDepth, na.rm = TRUE)
), by = Component]
Map[AUX, on = "Component", `:=`(
  N = i.N,
  MwMin = i.MwMin,
  MwMax = i.MwMax,
  zMin = i.zMin,
  zMax = i.zMax
)]
AUX <- Map
AUX[, Mw := sprintf("%.2f–%.2f", MwMin, MwMax)]
AUX[, z := "—"]
AUX[!is.na(zMin), z := paste0(
  sub("[.]0$", "", sprintf("%.1f", zMin)),
  "–",
  sub("[.]0$", "", sprintf("%.1f", zMax))
)]
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
  AUX, Classes, DATA, DT, ExpectedInputs, IdentityCols, IntrinsicCols,
  Map, Meta, MfdLevels, NormalizedProvider, RequiredMeta, Schema,
  SiteCount, TrtOrder, TypeOrder, Units, UsedFields
)
# nolint end
