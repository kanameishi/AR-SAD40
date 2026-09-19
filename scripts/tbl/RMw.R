# nolint start
RMw <- RMwTable
if ("siteID" %in% names(RMw) && exists("siteID.target", inherits = FALSE)) {
  RMw <- RMw[siteID %in% siteID.target]
}
if ("siteID" %in% names(RMw) && uniqueN(RMw$siteID, na.rm = TRUE) > 1L) {
  stop("RMw table: set siteID.target to one siteID.")
}
if ("ID" %in% names(RMw)) {
  ID.target <- .resolveIDTarget(
    RMw,
    "RMw table",
    target = .currentTarget("ID.target"),
    siteID = .currentTarget("siteID.target"),
    base = TRUE
  )
  RMw <- RMw[ID %in% ID.target]
}

DT <- RMw[Tn %in% Tn.target & TR %in% TR.target]

# Modal block on the SAME display grid as the heatmaps (.rmwBlocks),
# so table and figure captions cross-check.
DT <- DT[
  ,
  {
    AUX <- .rmwBlocks(.SD[, .(Mw, R, p)])[which.max(p)]
    .(Mw = round(AUX$Mw, 2), R = round(AUX$R, 0))
  },
  by = .(Tn, TR)
][order(TR, Tn)]

AUX.Tn <- sort(unique(DT$Tn))
AUX.TR <- sort(unique(DT$TR))
AUX.label <- prettyNum(round(AUX.TR, 0), big.mark = ",")

# Build wide table: TR | Mw.1 | R.1 | Mw.2 | R.2 | ...
AUX.Mw <- data.table::dcast(DT, TR ~ Tn, value.var = "Mw")
AUX.R  <- data.table::dcast(DT, TR ~ Tn, value.var = "R")

WIDE <- data.table::data.table(TR = AUX.label)
for (i in seq_along(AUX.Tn)) {
  s <- as.character(AUX.Tn[i])
  WIDE[, (paste0("Mw.", i)) := AUX.Mw[[s]]]
  WIDE[, (paste0("R.", i))  := AUX.R[[s]]]
}

# Base style comes from the shared table builder; the spanning Tn
# header is layered on top.
TBL <- WIDE |> buildTable(
  library          = "flextable",
  align.body       = "center",
  font.size.body   = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
)

AUX <- c("TR")
for (i in seq_along(AUX.Tn)) {
  AUX <- c(AUX, paste0("Tn=", AUX.Tn[i], " s"), paste0("Tn=", AUX.Tn[i], " s"))
}
TBL <- flextable::add_header_row(TBL, values = AUX, top = TRUE)
TBL <- flextable::merge_h(TBL, part = "header")
TBL <- flextable::merge_v(TBL, j = 1, part = "header")
TBL <- flextable::align(TBL, align = "center", part = "header")
TBL <- flextable::fontsize(TBL, size = FONT.SIZE.HEADER, part = "header")

# Notation symbols enter after the merges: flextable derives the spans
# from the header text, and a composed equation carries none. Units are
# stated in the caption.
SYM <- c(TR = "T_R")
for (i in seq_along(AUX.Tn)) {
  SYM[[paste0("Mw.", i)]] <- "M_w"
  SYM[[paste0("R.", i)]]  <- "R"
}
TBL <- .mathHeader(TBL, SYM)

# The spanning row labels a value of Tn, so it keeps the value and gains
# the symbol; only the leading cell of each merged pair is visible.
AUX.tex <- paste0("T_n = ", AUX.Tn, "\\,\\mathrm{s}")
if (requireNamespace("equatags", quietly = TRUE)) {
  for (i in seq_along(AUX.Tn)) {
    TBL <- flextable::compose(
      TBL,
      part = "header", i = 1L, j = paste0("Mw.", i),
      value = flextable::as_paragraph(flextable::as_equation(AUX.tex[i]))
    )
  }
}
TBL <- flextable::set_table_properties(TBL, layout = "autofit")
# nolint end
rm(RMw, DT, AUX.Mw, AUX.R, WIDE, AUX.Tn, AUX.TR, AUX.label, AUX, SYM, AUX.tex)
