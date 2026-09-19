# nolint start
# Executive criteria summary: design PGA by consequence classification and
# site condition, for one standard and one stage.
# Expects: ID.target, Standard.target (one), Stage.target (one), Vs30.target,
# PSA_Units
REQUIRED <- c(
  "ID", "Standard", "Class", "Stage", "Vs30", "p", "Tn",
  "TR.lower", "TR.upper", "SaF.design"
)
AUX <- setdiff(REQUIRED, names(DEQTable))
if (length(AUX)) {
  stop("DEQ.PGA.R: DEQTable is missing column(s): ", paste(AUX, collapse = ", "))
}
if (length(Standard.target) != 1L || length(Stage.target) != 1L) {
  stop("DEQ.PGA.R: set Standard.target and Stage.target to one value each.", call. = FALSE)
}

DT <- DEQTable[
  ID %in% ID.target & Standard %in% Standard.target &
    Stage %in% Stage.target & Vs30 %in% Vs30.target
]
DT <- DT[Tn == min(Tn)]
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
if (!nrow(DT)) stop("DEQ.PGA.R: no rows match the requested criterion.", call. = FALSE)
SITE_BY <- "siteID" %in% names(DT) && uniqueN(DT$siteID, na.rm = TRUE) > 1L

DT <- unique(DT[
  ,
  c(
    if (SITE_BY) "siteID", "Class", "TR.lower", "TR.upper", "Vs30",
    "SaF.design"
  ),
  with = FALSE
])
KEY <- c(if (SITE_BY) "siteID", "Class", "Vs30")
if (anyDuplicated(DT, by = KEY)) {
  stop("DEQ.PGA.R: duplicated design PGA per class and Vs30.", call. = FALSE)
}
setnames(DT, "SaF.design", "PGA")
if (PSA_Units %in% c("cm", "cm/s2", "cm/s**2", "cm/s^2")) DT[, PGA := round(PGA * 980.665, 0)]
if (PSA_Units %in% c("g"))                                DT[, PGA := round(PGA, 3)]

DT[
  ,
  Criterion := fifelse(
    TR.lower == TR.upper,
    prettyNum(TR.lower, big.mark = ",", scientific = FALSE),
    sprintf(
      "½ × (%s + %s)",
      prettyNum(TR.lower, big.mark = ",", scientific = FALSE),
      prettyNum(TR.upper, big.mark = ",", scientific = FALSE)
    )
  )
]
DT[, c("TR.lower", "TR.upper") := NULL]

AUX <- dcast(
  DT,
  stats::as.formula(paste(
    paste(c(if (SITE_BY) "siteID", "Class", "Criterion"), collapse = " + "),
    "~ Vs30"
  )),
  value.var = "PGA"
)
CLASS_ORDER <- c(
  "Low", "Significant", "High", "High C",
  "High B", "High A", "Very High", "Extreme"
)
AUX <- AUX[order(chmatch(Class, CLASS_ORDER))]
if (SITE_BY) AUX <- AUX[order(match(siteID, siteID.target))]
VS_COLS <- setdiff(names(AUX), c("siteID", "Class", "Criterion"))
setcolorder(AUX, c(
  if (SITE_BY) "siteID", "Class", "Criterion", VS_COLS[order(as.numeric(VS_COLS))]
))
if (length(VS_COLS) == 1L) setnames(AUX, VS_COLS, "PGA")

TBL <- AUX |> buildTable(
  library          = "flextable",
  align.body       = "center",
  font.size.body   = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |> .mathHeader(c(
  Criterion = "T_R"
)) |> flextable::set_table_properties(layout = "autofit")

rm(DT, AUX, KEY, REQUIRED, CLASS_ORDER, VS_COLS, SITE_BY)
# nolint end
