buildCalculationConcreteAxialFlexurePlot <- function(
  domainsPath,
  sweepPath,
  governingDemandsPath,
  liningID = "reinforcedConcrete"
) {
  Paths <- c(domainsPath, sweepPath, governingDemandsPath)
  if (any(!file.exists(Paths))) {
    stop("The reinforcement P-M family products are not available.",
      call. = FALSE
    )
  }
  if (!is.character(liningID) || length(liningID) != 1L ||
      is.na(liningID) || !nzchar(liningID)) {
    stop("liningID must identify one concrete alternative.", call. = FALSE)
  }
  Domains <- data.table::fread(domainsPath)
  Sweep <- data.table::fread(sweepPath)
  Demands <- data.table::fread(governingDemandsPath)
  DomainRequired <- c(
    "liningID", "reinforcementCaseID", "domainPointIndex",
    "axialStrengthKnPerM", "bendingStrengthKnMPerM"
  )
  SweepRequired <- c(
    "liningID", "reinforcementCaseID", "reinforcementCaseOrder",
    "circumferentialAreaTotalMm2PerM", "reinforcementRatio",
    "maximumRadialUtilization", "localPMStatus", "isLowerReferenceCase",
    "isParametricCase", "calculationStatus", "demandReuseStatus"
  )
  DemandRequired <- c(
    "liningID", "demandOrder", "selectionBasisID", "interfaceID",
    "strengthCaseID", "axialDemandKnPerM", "bendingDemandKnMPerM",
    "verticalStressFactor", "horizontalStressFactor", "radialUtilization",
    "thetaDeg"
  )
  if (length(setdiff(DomainRequired, names(Domains))) > 0L ||
      length(setdiff(SweepRequired, names(Sweep))) > 0L ||
      length(setdiff(DemandRequired, names(Demands))) > 0L) {
    stop("The reinforcement P-M family has an invalid schema.", call. = FALSE)
  }
  TargetLiningID <- liningID
  Domains <- Domains[Domains[["liningID"]] == TargetLiningID]
  Sweep <- Sweep[Sweep[["liningID"]] == TargetLiningID]
  Demands <- Demands[Demands[["liningID"]] == TargetLiningID]
  data.table::setorder(Sweep, reinforcementCaseOrder)
  data.table::setorder(Domains, reinforcementCaseID, domainPointIndex)
  data.table::setorder(Demands, demandOrder)
  CaseIDs <- Sweep[["reinforcementCaseID"]]
  Invalid <- c(
    caseCount = nrow(Sweep) < 3L || nrow(Sweep) > 6L,
    duplicateCase = anyDuplicated(CaseIDs) > 0L,
    domainCases = !setequal(unique(Domains$reinforcementCaseID), CaseIDs),
    demandCount = nrow(Demands) != 4L,
    lowerReference = sum(Sweep$isLowerReferenceCase) != 1L,
    parametricFlag = any(!Sweep$isParametricCase),
    calculationStatus = any(Sweep$calculationStatus != "calculated"),
    demandReuse = any(Sweep$demandReuseStatus != "satisfied"),
    utilization = any(!is.finite(Sweep$maximumRadialUtilization))
  )
  if (any(Invalid)) {
    stop(
      "The reinforcement P-M family is incomplete: ",
      paste(names(Invalid)[Invalid], collapse = ", "),
      ".",
      call. = FALSE
    )
  }
  DomainGroups <- split(Domains, Domains$reinforcementCaseID)
  if (any(!vapply(DomainGroups, function(x) {
    identical(x$domainPointIndex, seq_len(nrow(x)))
  }, logical(1)))) {
    stop("A reinforcement P-M domain is not ordered.", call. = FALSE)
  }
  PublicLabel <- function(row) {
    Role <- if (row$isLowerReferenceCase) {
      "Referencia inferior · "
    } else {
      ""
    }
    paste0(
      Role,
      "rho=",
      formatC(100 * row$reinforcementRatio, format = "f", digits = 2L),
      "% · As=",
      formatC(
        row$circumferentialAreaTotalMm2PerM / 100,
        format = "f",
        digits = 1L
      ),
      " cm2/m"
    )
  }
  LineRows <- lapply(seq_len(nrow(Sweep)), function(i) {
    Row <- Sweep[i]
    Domain <- DomainGroups[[Row$reinforcementCaseID]]
    data.table::data.table(
      ID = PublicLabel(Row),
      X = Domain$bendingStrengthKnMPerM,
      Y = Domain$axialStrengthKnPerM,
      style = if (Row$isLowerReferenceCase) "dashed" else "solid",
      size = 1.5
    )
  })
  Lines <- data.table::rbindlist(LineRows)
  InterfaceLabels <- c(
    `full-slip` = "Deslizamiento libre",
    `no-slip` = "Sin deslizamiento"
  )
  StrengthLabel <- paste0(
    "Permanente vertical ×",
    format(
      Demands$verticalStressFactor,
      trim = TRUE,
      decimal.mark = ","
    ),
    " · Empuje lateral ×",
    format(
      Demands$horizontalStressFactor,
      trim = TRUE,
      decimal.mark = ","
    )
  )
  InterfaceCode <- unname(InterfaceLabels[Demands$interfaceID])
  if (anyNA(InterfaceCode) ||
      any(Demands$selectionBasisID != "lower-reference-domain")) {
    stop("The P-M family demand labels are incomplete.", call. = FALSE)
  }
  Points <- data.table::data.table(
    ID = paste(InterfaceCode, StrengthLabel, sep = " · "),
    X = Demands$bendingDemandKnMPerM,
    Y = Demands$axialDemandKnPerM,
    style = "circle"
  )
  Plot <- NGR::buildPlot(
    data.lines = Lines,
    data.points = Points,
    line.type = "line",
    plot.height = 600,
    xAxis.legend = "Momento flector, M [kN·m/m]",
    yAxis.legend = "Fuerza axial, P [kN/m]",
    group.legend = "Dominios por cuantía y demandas resistentes",
    color.palette = "Dark 3",
    line.size = 2,
    point.size = 6,
    legend.layout = "horizontal",
    legend.align = "center",
    legend.valign = "bottom",
    print.max.abs = FALSE,
    point.dataLabels = FALSE
  )
  Plot <- highcharter::hc_plotOptions(
    Plot,
    series = list(requireSorting = FALSE)
  )
  Plot <- highcharter::hc_xAxis(
    Plot,
    labels = list(format = "{value:.0f}")
  )
  Plot <- highcharter::hc_yAxis(
    Plot,
    labels = list(format = "{value:.0f}")
  )
  highcharter::hc_tooltip(Plot, valueDecimals = 0L)
}
