buildLinerRehabilitationInteractionPlot <- function(
  domainsPath,
  sweepPath,
  configuredDemandsPath,
  liningID = "reinforcedConcrete"
) {
  Paths <- c(domainsPath, sweepPath, configuredDemandsPath)
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
  Demands <- data.table::fread(configuredDemandsPath)
  DomainRequired <- c(
    "liningID", "reinforcementCaseID", "domainPointIndex",
    "axialStrengthKnPerM", "bendingStrengthKnMPerM"
  )
  SweepRequired <- c(
    "liningID", "reinforcementCaseID", "reinforcementCaseOrder",
    "circumferentialAreaTotalMm2PerM", "reinforcementRatio",
    "maximumRadialUtilization", "localPMStatus", "isConfiguredCase",
    "isMinimumHistoricalCase", "calculationStatus", "demandReuseStatus"
  )
  DemandRequired <- c(
    "liningID", "reinforcementCaseID", "demandOrder", "interfaceID",
    "strengthCaseID", "axialDemandKnPerM", "bendingDemandKnMPerM",
    "verticalStressFactor", "horizontalStressFactor", "radialUtilization",
    "thetaDeg"
  )
  if (length(setdiff(DomainRequired, names(Domains))) > 0L ||
      length(setdiff(SweepRequired, names(Sweep))) > 0L ||
      length(setdiff(DemandRequired, names(Demands))) > 0L) {
    stop("The reinforcement P-M family has an invalid schema.", call. = FALSE)
  }
  Domains <- Domains[Domains[["liningID"]] == liningID]
  Sweep <- Sweep[Sweep[["liningID"]] == liningID]
  Demands <- Demands[Demands[["liningID"]] == liningID]
  data.table::setorder(Sweep, reinforcementCaseOrder)
  data.table::setorder(Domains, reinforcementCaseID, domainPointIndex)
  data.table::setorder(Demands, demandOrder)
  CaseIDs <- Sweep[["reinforcementCaseID"]]
  if (nrow(Sweep) < 3L || nrow(Sweep) > 6L || anyDuplicated(CaseIDs) ||
      !setequal(unique(Domains$reinforcementCaseID), CaseIDs) ||
      nrow(Demands) != 4L || sum(Sweep$isConfiguredCase) != 1L ||
      sum(Sweep$isMinimumHistoricalCase) != 1L ||
      any(Sweep$calculationStatus != "calculated") ||
      any(Sweep$demandReuseStatus != "satisfied") ||
      any(!is.finite(Sweep$maximumRadialUtilization))) {
    stop("The reinforcement P-M family is incomplete.", call. = FALSE)
  }
  DomainGroups <- split(Domains, Domains$reinforcementCaseID)
  if (any(!vapply(DomainGroups, function(x) {
    identical(x$domainPointIndex, seq_len(nrow(x)))
  }, logical(1)))) {
    stop("A reinforcement P-M domain is not ordered.", call. = FALSE)
  }
  PublicLabel <- function(row) {
    Role <- if (row$isConfiguredCase) {
      "Configurada"
    } else if (row$isMinimumHistoricalCase) {
      "Mínimo histórico"
    } else {
      "Referencia"
    }
    paste0(
      Role,
      " · rho=",
      formatC(100 * row$reinforcementRatio, format = "f", digits = 3L),
      "% · As=",
      formatC(
        row$circumferentialAreaTotalMm2PerM / 100,
        format = "f",
        digits = 2L
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
      style = if (Row$isMinimumHistoricalCase) "Dash" else "Solid",
      size = if (Row$isConfiguredCase) THICK_LINE_SIZE else MID_LINE_SIZE
    )
  })
  Lines <- data.table::rbindlist(LineRows)
  InterfaceLabels <- c(
    `full-traction` = "A1",
    `normal-only` = "A0"
  )
  StrengthLabel <- paste0(
    format(Demands$verticalStressFactor, trim = TRUE),
    "V + ",
    format(Demands$horizontalStressFactor, trim = TRUE),
    "H"
  )
  InterfaceCode <- unname(InterfaceLabels[Demands$interfaceID])
  if (anyNA(InterfaceCode) ||
      length(unique(Demands$reinforcementCaseID)) != 1L ||
      unique(Demands$reinforcementCaseID) !=
        Sweep$reinforcementCaseID[Sweep$isConfiguredCase]) {
    stop("The configured P-M demand labels are incomplete.", call. = FALSE)
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
    group.legend = "Dominios por cuantía y demandas configuradas",
    plot.theme = HC.THEME,
    line.size = MID_LINE_SIZE,
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

PLOT <- buildLinerRehabilitationInteractionPlot(
  domainsPath = Calculation$paths$shotcreteReinforcementDomains,
  sweepPath = Calculation$paths$shotcreteReinforcementSweep,
  configuredDemandsPath =
    Calculation$paths$shotcreteReinforcementConfiguredDemands,
  liningID = "reinforcedConcrete"
)
