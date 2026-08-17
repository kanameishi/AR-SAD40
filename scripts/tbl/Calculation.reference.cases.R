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

buildCalculationUSACEReferenceTable <- function(path) {
  Data <- .readReferenceCaseProduct(path, c(
    "quantityID", "publishedValue", "calculatedValue", "unit",
    "evidenceClass"
  ))
  Quantity <- c(
    `dead-crown-pressure` = "$P_{FD}$",
    `dead-service-thrust` = "$T_G$",
    `factored-thrust` = "$T_L$",
    `modified-demand` = "$\\eta_{cmp}T_L$"
  )
  Class <- c(
    `published-result-reproduced` = "P",
    `study-derived-result` = "D"
  )
  Unit <- c(
    "lb/ft2" = "$\\mathrm{lb/ft^2}$",
    "lb/ft" = "$\\mathrm{lb/ft}$"
  )
  Output <- data.frame(
    Quantity = unname(Quantity[Data$quantityID]),
    Published = ifelse(
      is.na(Data$publishedValue),
      "—",
      format(Data$publishedValue, trim = TRUE, scientific = FALSE)
    ),
    Calculated = format(Data$calculatedValue, trim = TRUE, scientific = FALSE),
    Unit = unname(Unit[Data$unit]),
    Class = unname(Class[Data$evidenceClass]),
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  if (anyNA(Output)) stop("The USACE public mapping is incomplete.", call. = FALSE)
  knitr::kable(
    Output,
    col.names = c("$x_i$", "$v_{p,i}$", "$v_{c,i}$", "$u_i$", "$c_i$"),
    align = c("c", "r", "r", "c", "c"),
    escape = FALSE
  )
}

buildCalculationFHWAReferenceTable <- function(path) {
  Data <- .readReferenceCaseProduct(path, c(
    "publishedFrictionAngleDeg", "alternativeFrictionAngleDeg",
    "compactorForceKn", "centroidalDiameterMm", "publishedPressureKPa",
    "calculatedPublishedInputKPa", "calculatedAlternativeKPa",
    "comparisonStatus"
  ))
  Output <- data.frame(
    Index = seq_len(nrow(Data)),
    Force = Data$compactorForceKn,
    FrictionPublished = Data$publishedFrictionAngleDeg,
    Diameter = Data$centroidalDiameterMm,
    Published = Data$publishedPressureKPa,
    Calculated = Data$calculatedPublishedInputKPa,
    FrictionAlternative = ifelse(
      is.na(Data$alternativeFrictionAngleDeg),
      "—",
      format(Data$alternativeFrictionAngleDeg, trim = TRUE)
    ),
    CalculatedAlternative = ifelse(
      is.na(Data$calculatedAlternativeKPa),
      "—",
      formatC(Data$calculatedAlternativeKPa, format = "f", digits = 3)
    ),
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  knitr::kable(
    Output,
    digits = c(0, 1, 0, 0, 1, 3, NA, NA),
    col.names = c(
      "$i$", "$P$", "$\\phi_p$", "$d_c$", "$n_{p,p}$",
      "$n_{p,c}$", "$\\phi_a$", "$n_{p,a}$"
    ),
    align = rep("r", 8),
    escape = FALSE
  )
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
  knitr::kable(
    Output,
    digits = c(0, 1, 0, 0, 1),
    col.names = c("$i$", "$P$", "$\\phi_\\ell$", "$d_c$", "$n_p$"),
    align = rep("r", 5),
    escape = FALSE
  )
}

buildCalculationNunezReferenceTable <- function(path) {
  Data <- .readReferenceCaseProduct(path, c(
    "liningID", "quantityID", "publishedValue", "calculatedValue", "unit"
  ))
  Data <- Data[!is.na(Data$publishedValue), , drop = FALSE]
  Quantity <- c(
    `interaction-ratio` = "$a_N$",
    `interaction-fraction` = "$A_N$",
    `maximum-moment` = "$M_{\\max}$",
    `normal-crown` = "$N_C$",
    `normal-side` = "$N_A$"
  )
  Lining <- c(primary = "P", final = "F")
  Unit <- c(
    "-" = "—", "tf m/m" = "$\\mathrm{tf\\,m/m}$",
    "tf/m" = "$\\mathrm{tf/m}$"
  )
  Output <- data.frame(
    Lining = unname(Lining[Data$liningID]),
    Quantity = unname(Quantity[Data$quantityID]),
    Published = Data$publishedValue,
    Calculated = Data$calculatedValue,
    Unit = unname(Unit[Data$unit]),
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  if (nrow(Output) != 9L || anyNA(Output)) {
    stop("The Nunez public mapping is incomplete.", call. = FALSE)
  }
  knitr::kable(
    Output,
    digits = c(NA, NA, 4, 4, NA),
    col.names = c("$r_i$", "$x_i$", "$v_{p,i}$", "$v_{c,i}$", "$u_i$"),
    align = c("c", "c", "r", "r", "c"),
    escape = FALSE
  )
}

buildCalculationSchwartzEinsteinReferenceTable <- function(path) {
  Data <- .readReferenceCaseProduct(path, c(
    "sequenceID", "interfaceID", "publishedThrustRatio",
    "calculatedThrustRatio", "publishedMomentRatio", "calculatedMomentRatio"
  ))
  Sequence <- c(excavation = "E", external = "X")
  Interface <- c(fullSlip = "F", noSlip = "N")
  Output <- data.frame(
    Sequence = unname(Sequence[Data$sequenceID]),
    Interface = unname(Interface[Data$interfaceID]),
    ThrustPublished = Data$publishedThrustRatio,
    ThrustCalculated = Data$calculatedThrustRatio,
    MomentPublished = Data$publishedMomentRatio,
    MomentCalculated = Data$calculatedMomentRatio,
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  if (nrow(Output) != 4L || anyNA(Output)) {
    stop("The Schwartz-Einstein public mapping is incomplete.", call. = FALSE)
  }
  knitr::kable(
    Output,
    digits = c(NA, NA, 4, 6, 5, 7),
    col.names = c(
      "$s_i$", "$j_i$", "$\\bar T_p$", "$\\bar T_c$",
      "$\\bar M_p$", "$\\bar M_c$"
    ),
    align = c("c", "c", "r", "r", "r", "r"),
    escape = FALSE
  )
}
