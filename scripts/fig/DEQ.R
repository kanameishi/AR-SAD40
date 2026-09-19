# nolint start
REQUIRED <- c(
    "ID", "Standard", "Class", "Stage", "Vs30", "p", "Tn", "Bound", "SaF",
    "TR.lower", "TR.upper", "MCE", "SaF.design"
)
AUX <- setdiff(REQUIRED, names(DEQTable))
if (length(AUX)) {
    stop("DEQ.R: DEQTable is missing column(s): ", paste(AUX, collapse = ", "))
}
MCE_REQUIRED <- c("ID", "siteID", "Vs30", "p", "Tn", "SaF")
if (!exists("MCETable", inherits = FALSE) || is.null(MCETable)) {
    stop("DEQ.R: MCETable is required for the MCE reference curve.")
}
AUX <- setdiff(MCE_REQUIRED, names(MCETable))
if (length(AUX)) {
    stop("DEQ.R: MCETable is missing column(s): ", paste(AUX, collapse = ", "))
}
DEQ <- DEQTable[
    ID %in% ID.target & Vs30 %in% Vs30.target &
        Standard %in% Standard.target & Stage %in% Stage.target
]
DEQ <- DEQ[
    p == fifelse(
        Standard == "ANCOLD" & Stage == "Closure" & Class == "Extreme",
        "0.84",
        "mean"
    )
]
if ("siteID" %in% names(DEQ) && exists("siteID.target", inherits = FALSE)) {
    DEQ <- DEQ[siteID %in% siteID.target]
}
if (!nrow(DEQ)) stop("DEQ.R: no rows match the requested design criterion.")
DEQ[
    ,
    StageLabel := fcase(
        Standard == "ANCOLD" & Stage == "Operation", "OBE",
        Standard == "ANCOLD" & Stage == "Closure", "SEE",
        default = Stage
    )
]
SITE_BY <- "siteID" %in% names(DEQ) && uniqueN(DEQ$siteID, na.rm = TRUE) > 1L
# The stage identifiers repeat across standards (Operation, Closure), so a
# figure spanning several standards names the standard in each series.
STD_BY <- uniqueN(DEQ$Standard) > 1L

CLASS_ORDER <- c(
    "Low", "Significant", "High", "High C",
    "High B", "High A", "Very High", "Extreme"
)
KEY <- c(
    if ("siteID" %in% names(DEQ)) "siteID",
    "ID", "Standard", "Class", "Stage", "StageLabel", "Vs30", "p", "Tn"
)
AUX <- DEQ[
    ,
    .(
        N = .N,
        N.bound = uniqueN(Bound),
        Bounds.valid = setequal(Bound, c("lower", "upper")),
        Order.valid = SaF[Bound == "lower"] <= SaF[Bound == "upper"],
        Criterion.valid = uniqueN(TR.lower) == 1L &&
            uniqueN(TR.upper) == 1L && uniqueN(MCE) == 1L,
        Design.valid =
            uniqueN(SaF.design) == 1L &&
            all(is.finite(SaF.design)) &&
            isTRUE(all.equal(SaF.design[[1L]], mean(SaF)))
    ),
    by = KEY
][
    N != 2L | N.bound != 2L | !Bounds.valid | !Order.valid |
        !Criterion.valid | !Design.valid
]
if (nrow(AUX)) {
    stop("DEQ.R: invalid bounds or design value for at least one criterion/Tn.")
}

CriterionCols <- c("TR.lower", "TR.upper", "MCE")
GroupCols <- c(setdiff(KEY, "Tn"), CriterionCols)
MeanData <- unique(
    DEQ[
        ,
        c(GroupCols, "Tn", "SaF.design"),
        with = FALSE
    ]
)
MeanData[, LegendID := paste(StageLabel, Class, sep = " · ")]
if (STD_BY) MeanData[, LegendID := paste(Standard, LegendID, sep = " · ")]
if (SITE_BY) MeanData[, LegendID := paste(siteID, LegendID, sep = " · ")]
LegendLevels <- MeanData[
    order(chmatch(Class, CLASS_ORDER), LegendID),
    unique(LegendID)
]
LegendColors <- setNames(
    grDevices::hcl.colors(length(LegendLevels), palette = "Dark 3"),
    LegendLevels
)
MeanLines <- MeanData[
    ,
    .(
        ID = LegendID,
        X = Tn,
        Y = SaF.design,
        Class,
        Stage = StageLabel,
        Category = Class,
        style = "Solid",
        size = MID_LINE_SIZE,
        color = unname(LegendColors[LegendID]),
        fill = FALSE
    )
][order(chmatch(Class, CLASS_ORDER), ID, X)]
MCEP <- c("mean", "0.84")
MCEClasses <- DEQ[MCE == TRUE & Class == "Extreme", unique(Class)]
MCEData <- NULL
MCELines <- MeanLines[0]
if (length(MCEClasses)) {
    MCEData <- MCETable[
        ID == "MCE" & p %in% MCEP & Vs30 %in% Vs30.target
    ]
    if ("siteID" %in% names(MCEData) &&
        exists("siteID.target", inherits = FALSE)) {
        MCEData <- MCEData[siteID %in% siteID.target]
    }
    if (!nrow(MCEData) || !all(MCEP %in% MCEData$p)) {
        stop("DEQ.R: MCE mean and p84 are required.")
    }
    DUP <- MCEData[, .N, by = .(siteID, Vs30, p, Tn)][N > 1L]
    if (nrow(DUP)) {
        stop("DEQ.R: MCE rows are not unique by siteID, Vs30, p, and Tn.")
    }
    MCELines <- MCEData[
        ,
        .(
            ID = fifelse(p == "mean", "MCE (mean)", "MCE (84%)"),
            X = Tn,
            Y = SaF,
            Class = NA_character_,
            Stage = unique(DEQ$StageLabel),
            Category = paste(MCEClasses, collapse = " / "),
            style = "Solid",
            size = fifelse(p == "mean", THICK_LINE_SIZE, THIN_LINE_SIZE),
            color = "#000000",
            fill = TRUE
        )
    ]
}
Lines <- rbindlist(list(MeanLines, MCELines), use.names = TRUE)
DUP <- Lines[, .N, by = .(ID, X)][N > 1L]
if (nrow(DUP)) {
    stop("DEQ.R: more than one ordinate found for at least one series/Tn.")
}
PLOT <- buildPlot(
    yAxis.label = TRUE,
    line.type = "spline",
    plot.height = 750,
    legend.layout = "horizontal",
    legend.show = TRUE,
    xAxis.log = Tn.log,
    yAxis.log = Sa.log,
    xAxis.log.zero.label = "PGA",
    line.size = MID_LINE_SIZE,
    xAxis.legend = "Tn [s]",
    yAxis.legend = "Sa [g]",
    group.legend = "ID",
    plot.theme = NGR::hc_theme_538_gridlines(),
    fill.legend = "MCE",
    fill.opacity = 0.18,
    data.lines = Lines
)
PLOT <- PLOT |>
    highcharter::hc_tooltip(
        headerFormat = "",
        pointFormat = paste0(
            "ID: <b>{point.series.name}</b><br>",
            "<b>{point.Stage}</b><br>",
            "<b>{point.Category}</b><br>",
            "Tn [s]: {point.Xlabel}<br>",
            "Sa [g]: {point.y}"
        )
    )

rm(
    DEQ, SITE_BY, REQUIRED, AUX, KEY, GroupCols, CLASS_ORDER, DUP,
    CriterionCols, MeanData, MeanLines, LegendLevels, LegendColors,
    MCE_REQUIRED, MCEP, MCEClasses, MCEData, MCELines, Lines
)
# nolint end
