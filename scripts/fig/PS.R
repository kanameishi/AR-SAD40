# nolint start
Column <- paste(ID, DIR, sep = ".")
if (!ID %in% c("PSA", "PSV", "SD")) {
  stop("PS.R supports only PSA, PSV, and SD.", call. = FALSE)
}
if (!Column %in% names(PSWTable)) {
  stop(sprintf("Missing PS column: %s", Column), call. = FALSE)
}
Units <- if (ID == "PSA") paste0(SRS_UNITS, "/s2") else if (ID == "PSV") paste0(SRS_UNITS, "/s") else SRS_UNITS

SRS <- PSWTable[ID == "PSA" | Tn > 0, .(
  ID    = RecordID,
  X     = Tn,
  Y     = get(Column),
  style = "ShortDashDot",
  size  = THIN_LINE_SIZE,
  fill  = FALSE
)][is.finite(X) & is.finite(Y)]

MEAN <- SRS[, .(
  ID    = "mean",
  Y     = mean(Y, na.rm = TRUE),
  style = "Solid",
  size  = THICK_LINE_SIZE,
  fill  = FALSE
), by = X]

LIST <- list(SRS, MEAN)
if (ID == "PSA" && exists("TargetTable", inherits = TRUE)) {
  TARGET_REQUIRED <- c("Tn", "Sa.low", "Sa.mean", "Sa.high")
  TARGET_MISSING <- setdiff(TARGET_REQUIRED, names(TargetTable))
  if (length(TARGET_MISSING)) {
    stop(sprintf(
      "Target spectrum is missing required columns: %s.",
      paste(TARGET_MISSING, collapse = ", ")
    ), call. = FALSE)
  }
  TARGET_INPUT <- TargetTable[, ..TARGET_REQUIRED]
  if (anyDuplicated(TARGET_INPUT$Tn)) {
    stop("Target spectrum contains duplicate periods.", call. = FALSE)
  }
  if (any(TARGET_INPUT$Sa.low > TARGET_INPUT$Sa.mean) ||
      any(TARGET_INPUT$Sa.mean > TARGET_INPUT$Sa.high)) {
    stop("Target spectrum interval does not contain its mean.", call. = FALSE)
  }

  TARGET <- TARGET_INPUT[, .(
    ID    = "target",
    X     = Tn,
    Y     = Sa.mean,
    style = "Dash",
    size  = THICK_LINE_SIZE,
    fill  = FALSE
  )]
  TARGET_BAND <- rbindlist(list(
    TARGET_INPUT[, .(
      ID = ".min", X = Tn, Y = Sa.low,
      style = "Dash", size = THIN_LINE_SIZE, fill = TRUE
    )],
    TARGET_INPUT[, .(
      ID = ".max", X = Tn, Y = Sa.high,
      style = "Dash", size = THIN_LINE_SIZE, fill = TRUE
    )]
  ))
  LIST <- c(LIST, list(TARGET_BAND, TARGET))
}

SRS <- rbindlist(LIST, use.names = TRUE)[order(ID, X)]

PLOT <- buildPlot(
  line.type     = "spline",
  plot.height   = 750,
  legend.layout = "horizontal",
  legend.show   = TRUE,
  xAxis.log     = TRUE,
  yAxis.log     = TRUE,
  xAxis.log.zero = ID == "PSA",
  xAxis.log.zero.label = "PGA",
  xAxis.legend  = "Tn [s]",
  yAxis.legend  = sprintf("%s(%s) [%s]", ID, DIR, Units),
  group.legend  = "ID",
  plot.theme    = NGR::hc_theme_538_gridlines(),
  fill.legend   = if (exists("SRS_TARGET_FILL_LEGEND", inherits = TRUE)) {
    SRS_TARGET_FILL_LEGEND
  } else {
    "min–max"
  },
  fill.min.style = "Dash",
  fill.min.size = THIN_LINE_SIZE,
  fill.max.style = "Dash",
  fill.max.size = THIN_LINE_SIZE,
  data.lines    = SRS
)
rm(SRS, MEAN, LIST, Column, Units)
rm(list = intersect(c(
  "TARGET", "TARGET_BAND", "TARGET_INPUT", "TARGET_REQUIRED", "TARGET_MISSING"
), ls()))
# nolint end
