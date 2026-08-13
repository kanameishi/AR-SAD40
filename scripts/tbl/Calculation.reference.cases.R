buildCalculationReferenceTables <- function(pathUSACE, pathFHWA, pathNunez) {
  Paths <- c(pathUSACE, pathFHWA, pathNunez)
  if (any(!file.exists(Paths))) {
    stop("A reference-case data file is not available.", call. = FALSE)
  }

  USACE <- utils::read.csv(pathUSACE, check.names = FALSE)
  FHWA <- utils::read.csv(pathFHWA, check.names = FALSE)
  Nunez <- utils::read.csv(pathNunez, check.names = FALSE)

  Required.USACE <- c("quantity", "published", "calculated", "units", "status")
  Required.FHWA <- c(
    "forceKn", "frictionAngleDeg", "centroidalDiameterMm",
    "publishedEquationKpa", "calculatedKpa", "note"
  )
  Required.Nunez <- c("lining", "quantity", "published", "calculated")
  if (length(setdiff(Required.USACE, names(USACE))) > 0L ||
      length(setdiff(Required.FHWA, names(FHWA))) > 0L ||
      length(setdiff(Required.Nunez, names(Nunez))) > 0L) {
    stop("A reference-case data file has an invalid schema.", call. = FALSE)
  }

  Symbol.USACE <- c(
    deadCrownPressure = "$P_{FD}$",
    serviceThrust = "$T_G$",
    factoredThrust = "$T_L$",
    modifiedDemand = "$\\eta_{cmp}T_L$"
  )
  Class.USACE <- c(published = "P", `derived service value` = "D")
  Unit.USACE <- c(
    "lb/ft2" = "$\\mathrm{lb/ft^2}$",
    "lb/ft" = "$\\mathrm{lb/ft}$"
  )
  Table.USACE <- data.frame(
    Quantity = unname(Symbol.USACE[USACE$quantity]),
    Published = ifelse(
      is.na(USACE$published) | USACE$published == "UNKNOWN",
      "—",
      format(USACE$published, trim = TRUE)
    ),
    Calculated = format(USACE$calculated, trim = TRUE),
    Unit = unname(Unit.USACE[USACE$units]),
    Class = unname(Class.USACE[USACE$status]),
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  if (anyNA(Table.USACE)) {
    stop("The USACE public mapping is incomplete.", call. = FALSE)
  }

  Direct.FHWA <- FHWA[FHWA$note == "", , drop = FALSE]
  if (nrow(Direct.FHWA) != 8L) {
    stop("The direct FHWA reproduction set is incomplete.", call. = FALSE)
  }
  Table.FHWA <- data.frame(
    Force = Direct.FHWA$forceKn,
    Friction = Direct.FHWA$frictionAngleDeg,
    Diameter = Direct.FHWA$centroidalDiameterMm,
    Published = Direct.FHWA$publishedEquationKpa,
    Calculated = Direct.FHWA$calculatedKpa,
    check.names = FALSE,
    stringsAsFactors = FALSE
  )

  Quantity.Nunez <- c(
    a = "$a_N$", A = "$A_N$", Mc = "$M_{\\max}$",
    Nc = "$N_C$", Na = "$N_A$"
  )
  Lining.Nunez <- c(primary = "P", final = "F")
  Unit.Nunez <- c(
    a = "—", A = "—", Mc = "$\\mathrm{tf\\,m/m}$",
    Nc = "$\\mathrm{tf/m}$", Na = "$\\mathrm{tf/m}$"
  )
  Nunez <- Nunez[Nunez$quantity %in% names(Quantity.Nunez), , drop = FALSE]
  if (nrow(Nunez) != 9L) {
    stop("The published Nunez reproduction set is incomplete.", call. = FALSE)
  }
  Table.Nunez <- data.frame(
    Lining = unname(Lining.Nunez[Nunez$lining]),
    Quantity = unname(Quantity.Nunez[Nunez$quantity]),
    Published = Nunez$published,
    Calculated = Nunez$calculated,
    Unit = unname(Unit.Nunez[Nunez$quantity]),
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  if (anyNA(Table.Nunez)) {
    stop("The Nunez public mapping is incomplete.", call. = FALSE)
  }

  list(
    USACE = knitr::kable(
      Table.USACE,
      col.names = c("$x_i$", "$v_{p,i}$", "$v_{c,i}$", "$u_i$", "$c_i$"),
      align = c("c", "r", "r", "c", "c"),
      escape = FALSE
    ),
    FHWA = knitr::kable(
      Table.FHWA,
      digits = c(1, 0, 0, 1, 3),
      col.names = c("$P$", "$\\phi$", "$d_c$", "$n_{p,p}$", "$n_{p,c}$"),
      align = rep("r", 5),
      escape = FALSE
    ),
    Nunez = knitr::kable(
      Table.Nunez,
      digits = c(NA, NA, 4, 4, NA),
      col.names = c("$r_i$", "$x_i$", "$v_{p,i}$", "$v_{c,i}$", "$u_i$"),
      align = c("c", "c", "r", "r", "c"),
      escape = FALSE
    )
  )
}
