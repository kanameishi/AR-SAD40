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
    "barDiameterMm", "barSpacingMm", "reinforcementArrangementID",
    "circumferentialAreaTotalMm2PerM", "reinforcementRatio",
    "maximumRadialUtilization", "localPMStatus",
    "isParametricCase", "calculationStatus", "demandReuseStatus"
  )
  DemandRequired <- c(
    "liningID", "reinforcementCaseID", "reinforcementCaseOrder",
    "circumferentialAreaTotalMm2PerM", "reinforcementRatio",
    "demandOrder", "selectionBasisID", "interfaceID", "strengthCaseID",
    "axialDemandKnPerM", "bendingDemandKnMPerM",
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
    caseCount = nrow(Sweep) != 4L,
    duplicateCase = anyDuplicated(CaseIDs) > 0L,
    domainCases = !setequal(unique(Domains$reinforcementCaseID), CaseIDs),
    demandCount = nrow(Demands) != 2L * nrow(Sweep),
    symmetricCount = sum(Sweep$isParametricCase) != 3L,
    compositeCount = sum(!Sweep$isParametricCase) != 1L,
    arrangement =
      any(Sweep$reinforcementArrangementID[Sweep$isParametricCase] !=
        "symmetric-two-face") ||
      any(Sweep$reinforcementArrangementID[!Sweep$isParametricCase] !=
        "existing-sheet-plus-interior-mesh"),
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
  DemandGroups <- split(Demands, Demands$reinforcementCaseID)
  if (!setequal(names(DemandGroups), CaseIDs) ||
      any(!vapply(DemandGroups, function(x) {
        nrow(x) == 2L &&
          setequal(x$interfaceID, c("full-slip", "no-slip")) &&
          length(unique(x$reinforcementCaseOrder)) == 1L &&
          length(unique(x$reinforcementRatio)) == 1L
      }, logical(1)))) {
    stop("Each reinforcement domain must have one demand per interface.",
      call. = FALSE
    )
  }
  DomainGroups <- split(Domains, Domains$reinforcementCaseID)
  if (any(!vapply(DomainGroups, function(x) {
    identical(x$domainPointIndex, seq_len(nrow(x)))
  }, logical(1)))) {
    stop("A reinforcement P-M domain is not ordered.", call. = FALSE)
  }
  DomainGroups <- lapply(DomainGroups, function(Domain) {
    Quarter <- Domain[
      Domain$axialStrengthKnPerM >= 0 &
        Domain$bendingStrengthKnMPerM >= 0
    ]
    if (nrow(Quarter) < 2L ||
        any(diff(Quarter$domainPointIndex) != 1L)) {
      stop("The positive P-M quadrant is not contiguous.", call. = FALSE)
    }
    Quarter
  })
  PublicLabel <- function(row) {
    if (!row$isParametricCase) {
      return(paste0(
        "A",
        trimws(formatC(row$barDiameterMm, format = "fg", digits = 6L)),
        " · chapa + Ø",
        trimws(formatC(row$barDiameterMm, format = "fg", digits = 6L)),
        "/",
        trimws(formatC(row$barSpacingMm, format = "fg", digits = 6L)),
        " interior"
      ))
    }
    paste0(
      "S",
      trimws(formatC(row$barDiameterMm, format = "fg", digits = 6L)),
      " · Ø",
      trimws(formatC(row$barDiameterMm, format = "fg", digits = 6L)),
      "/",
      trimws(formatC(row$barSpacingMm, format = "fg", digits = 6L)),
      " · rho=",
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
      style = if (!Row$isParametricCase) {
        "shortdashdot"
      } else {
        "solid"
      },
      size = 1.5
    )
  })
  Lines <- data.table::rbindlist(LineRows)
  InterfaceLabels <- c(
    `full-slip` = "Slip (S)",
    `no-slip` = "No Slip (NS)"
  )
  StrengthLabel <- paste0(
    "EV ×",
    format(
      Demands$verticalStressFactor,
      trim = TRUE,
      decimal.mark = ","
    ),
    " · EH ×",
    format(
      Demands$horizontalStressFactor,
      trim = TRUE,
      decimal.mark = ","
    )
  )
  InterfaceCode <- unname(InterfaceLabels[Demands$interfaceID])
  if (anyNA(InterfaceCode) ||
      any(Demands$selectionBasisID !=
        "reinforcement-domain-interface-envelope")) {
    stop("The P-M family demand labels are incomplete.", call. = FALSE)
  }
  CaseLabel <- vapply(
    Demands$reinforcementCaseID,
    function(caseID) {
      Row <- Sweep[Sweep$reinforcementCaseID == caseID]
      if (nrow(Row) != 1L) {
        stop("The demand does not map to one reinforcement domain.",
          call. = FALSE
        )
      }
      PublicLabel(Row)
    },
    character(1)
  )
  Points <- data.table::data.table(
    ID = CaseLabel,
    X = Demands$bendingDemandKnMPerM,
    Y = Demands$axialDemandKnPerM,
    style = "circle",
    interfaceLabel = InterfaceCode,
    strengthLabel = StrengthLabel,
    thetaLabel = formatC(Demands$thetaDeg, format = "f", digits = 0L),
    utilizationLabel = formatC(
      Demands$radialUtilization,
      format = "f",
      digits = 2L
    ),
    marker = Map(function(interfaceID, caseOrder, isParametricCase) {
      list(
        symbol = if (interfaceID == "full-slip") "circle" else "diamond",
        radius = if (isParametricCase) 4 + 2 * caseOrder else 7,
        fillColor = "rgba(255,255,255,0)",
        lineWidth = 3
      )
    },
    Demands$interfaceID,
    Demands$reinforcementCaseOrder,
    Demands$reinforcementCaseOrder <= sum(Sweep$isParametricCase))
  )
  Plot <- NGR::buildPlot(
    data.lines = Lines,
    data.points = Points,
    line.type = "line",
    plot.theme = NGR::hc_theme_538_gridlines(),
    plot.height = 750,
    xAxis.legend = "Momento flector, M [kN·m/m]",
    yAxis.legend = "Fuerza axial, P [kN/m]",
    group.legend = "Dominios por armadura y demandas resistentes",
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
  Series <- Plot[["x"]][["hc_opts"]][["series"]]
  PointSeries <- seq.int(nrow(Sweep) + 1L, length(Series))
  for (i in PointSeries) {
    Series[[i]][["showInLegend"]] <- FALSE
    for (j in seq_along(Series[[i]][["data"]])) {
      Series[[i]][["data"]][[j]][["marker"]][["lineColor"]] <-
        Series[[i]][["color"]]
    }
    Series[[i]][["tooltip"]] <- list(
      pointFormat = paste0(
        "<b>{point.series.name}</b><br>",
        "{point.interfaceLabel}<br>",
        "{point.strengthLabel}<br>",
        "θ = {point.thetaLabel}°<br>",
        "M = {point.x:.0f} kN·m/m<br>",
        "P = {point.y:.0f} kN/m<br>",
        "Utilización P–M = {point.utilizationLabel}"
      )
    )
  }
  Plot[["x"]][["hc_opts"]][["series"]] <- Series
  highcharter::hc_tooltip(Plot, valueDecimals = 0L)
}
