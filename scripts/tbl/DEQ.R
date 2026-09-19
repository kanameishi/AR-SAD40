REQUIRED <- c(
    "ID", "Standard", "Class", "Stage", "Vs30", "p", "Tn", "Bound", "SaF",
    "MCE", "SaF.design"
)
AUX <- setdiff(REQUIRED, names(DEQTable))
if (length(AUX)) {
    stop("DEQ table: DEQTable is missing column(s): ", paste(AUX, collapse = ", "))
}
DT <- DEQTable[
    ID %in% ID.target & Standard %in% Standard.target &
    Tn == Tn.target & Vs30 %in% Vs30.target
]
if (length(Stage.target)) DT <- DT[Stage %in% Stage.target]
DT <- DT[
    p == fifelse(
        Standard == "ANCOLD" & Stage == "Closure" & Class == "Extreme",
        "0.84",
        "mean"
    )
]
if ("siteID" %in% names(DT) && exists("siteID.target", inherits = FALSE)) {
    DT <- DT[siteID %in% siteID.target]
}
if (!nrow(DT)) stop("DEQ table: no rows match the requested design criterion.")
SITE_BY <- "siteID" %in% names(DT) && uniqueN(DT$siteID, na.rm = TRUE) > 1L
KEY <- c(
    if ("siteID" %in% names(DT)) "siteID",
    "ID", "Standard", "Class", "Stage", "Vs30", "p", "Tn"
)
AUX <- DT[
    ,
    .(
        N = .N,
        N.bound = uniqueN(Bound),
        Bounds.valid = setequal(Bound, c("lower", "upper")),
        Order.valid = SaF[Bound == "lower"] <= SaF[Bound == "upper"],
        MCE.valid = uniqueN(MCE) == 1L,
        Design.valid =
            uniqueN(SaF.design) == 1L &&
            all(is.finite(SaF.design)) &&
            isTRUE(all.equal(SaF.design[[1L]], mean(SaF)))
    ),
    by = KEY
][
    N != 2L | N.bound != 2L | !Bounds.valid | !Order.valid |
        !MCE.valid | !Design.valid
]
if (nrow(AUX)) {
    stop("DEQ table: invalid bounds or design value for at least one criterion.")
}
DT <- unique(DT[
    ,
    c(
        if (SITE_BY) "siteID", "ID", "Standard", "Class", "Stage",
        "TR.lower", "TR.upper", "Vs30", "p", "SaF.design"
    ),
    with = FALSE
])
DT[
    ,
    Criterion := fifelse(
        TR.lower == TR.upper,
        prettyNum(TR.lower, big.mark = ",", scientific = FALSE),
        sprintf(
            "\u00bd \u00d7 (%s + %s)",
            prettyNum(TR.lower, big.mark = ",", scientific = FALSE),
            prettyNum(TR.upper, big.mark = ",", scientific = FALSE)
        )
    )
]
DT[, c("TR.lower", "TR.upper") := NULL]
setnames(DT, "SaF.design", "PGA")

if (PSA_Units %in% c("cm", "cm/s2", "cm/s**2", "cm/s^2")) {
    DT[, PGA := round(PGA * 980.665, 0)]
}

if (PSA_Units %in% c("g")) {
    DT[, PGA := round(PGA, 3)]
}
CLASS_ORDER <- c(
    "Low", "Significant", "High", "High C",
    "High B", "High A", "Very High", "Extreme"
)
STAGE_ORDER <- c("Operation", "Closure", "Post-Closure")
AUX <- DT[
    order(
        Standard, chmatch(Class, CLASS_ORDER),
        chmatch(Stage, STAGE_ORDER), Vs30, p
    )
]
COLS <- c(
    if (SITE_BY) "siteID", "ID", "Standard", "Class", "Stage",
    "Criterion", "Vs30", "p", "PGA"
)
setcolorder(AUX, COLS)


TBL <- AUX[, !"ID"] |> buildTable(
    library = "flextable",
    align.body = "center",
    font.size.body = FONT.SIZE.BODY,
    font.size.header = FONT.SIZE.HEADER
) |> .mathHeader(c(
    Criterion = "T_R",
    Vs30 = "V_{S30}",
    p = "p",
    PGA = "\\mathrm{PGA}"
)) |> flextable::set_table_properties(layout = "autofit")
rm(
    DT, AUX, SITE_BY, CLASS_ORDER, STAGE_ORDER, REQUIRED, KEY,
    COLS
)
