if (!exists("buildReportTable", mode = "function", inherits = TRUE)) {
  source(file.path("scripts", "tbl", "table.R"), local = TRUE)
}

.readReferenceCaseProduct <- function(path, required) {
  if (!file.exists(path)) {
    stop("The reference-case product is not available: ", path, call. = FALSE)
  }
  Data <- utils::read.csv(
    path,
    check.names = FALSE,
    stringsAsFactors = FALSE,
    na.strings = ""
  )
  Missing <- setdiff(required, names(Data))
  if (nrow(Data) == 0L || length(Missing) > 0L) {
    stop("The reference-case product has an invalid schema.", call. = FALSE)
  }
  Data
}
buildMethodologyFHWACompactionTable <- function(path) {
  Data <- .readReferenceCaseProduct(path, c(
    "compactorForceKn", "publishedFrictionAngleDeg",
    "centroidalDiameterMm", "publishedPressureKPa"
  ))
  Output <- data.frame(
    Index = seq_len(nrow(Data)),
    Force = Data$compactorForceKn,
    FrictionAngle = Data$publishedFrictionAngleDeg,
    Diameter = Data$centroidalDiameterMm,
    Pressure = Data$publishedPressureKPa,
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  buildReportTable(
    data = Output,
    headers = c("$i$", "$P$", "$\\phi_\\ell$", "$d_c$", "$n_p$"),
    align = rep("r", 5),
    digits = c(0, 0, 0, 0, 1)
  )
}
