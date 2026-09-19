# nolint start
SiteID <- .currentTarget("siteID.target")
IDTarget <- .currentTarget("ID.target")
Vs30Target <- sort(unique(as.numeric(Vs30.target)))

DT <- .selectASCETable(
  ASCETable,
  "MCER table",
  idTarget = IDTarget,
  siteID = SiteID,
  vs30 = Vs30Target,
  p = "mean",
  spectrum = c("mcer", "design")
)

PGA <- data.table::dcast(
  DT[Tn == min(Tn)],
  Vs30 ~ Spectrum,
  value.var = "SaF"
)
data.table::setnames(PGA, c("mcer", "design"), c("PGA.MCER", "PGA.Design"))
PARAMETERS <- unique(DT[, .(Vs30, SMS, SM1, SDS, SD1)])
DATA <- merge(PGA, PARAMETERS, by = "Vs30", sort = TRUE)
data.table::setcolorder(
  DATA,
  c("Vs30", "PGA.MCER", "SMS", "SM1", "PGA.Design", "SDS", "SD1")
)
data.table::setorder(DATA, Vs30)

DATA[, `:=`(
  T0 = 0.2 * SD1 / SDS,
  TS = SD1 / SDS
)]
DATA[, PGA.Design := NULL]
data.table::setcolorder(
  DATA,
  c("Vs30", "PGA.MCER", "SMS", "SM1", "SDS", "SD1", "T0", "TS")
)
COLS <- setdiff(names(DATA), "Vs30")
DATA[, (COLS) := lapply(.SD, round, digits = 3L), .SDcols = COLS]

TBL <- DATA |> buildTable(
  library = "flextable",
  align.body = "center",
  font.size.body = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |> .mathHeader(c(
  Vs30 = "V_{S30}",
  PGA.MCER = "S_{aM}(0)",
  SMS = "S_{MS}",
  SM1 = "S_{M1}",
  SDS = "S_{DS}",
  SD1 = "S_{D1}",
  T0 = "T_0",
  TS = "T_S"
)) |> flextable::set_table_properties(layout = "autofit")

rm(SiteID, IDTarget, Vs30Target, DT, PGA, PARAMETERS, DATA, COLS)
# nolint end
