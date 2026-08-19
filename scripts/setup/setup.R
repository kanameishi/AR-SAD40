if (!exists("root", inherits = FALSE)) {
  root <- if (exists("projectRoot", inherits = FALSE)) {
    projectRoot
  } else {
    normalizePath(".", mustWork = TRUE)
  }
}
root <- normalizePath(root, mustWork = TRUE)
projectRoot <- root

Packages <- c(
  "yaml", "knitr", "NGR", "flextable", "highcharter", "htmlwidgets",
  "ggplot2"
)
OK <- vapply(
  Packages,
  function(Package) requireNamespace(Package, quietly = TRUE),
  logical(1)
)
if (any(!OK)) {
  stop(
    "Missing required R packages: ",
    paste(Packages[!OK], collapse = ", "),
    ".",
    call. = FALSE
  )
}

source(file.path(root, "scripts", "setup", "calculationFunctions.R"), local = TRUE)
source(file.path(root, "scripts", "setup", "coverCalculationResults.R"), local = TRUE)

ParamsPath <- file.path(root, "params.yml")
if (!file.exists(ParamsPath)) {
  stop("Missing params.yml.", call. = FALSE)
}
params <- yaml::read_yaml(ParamsPath)$params

if (!exists("THIN_LINE_SIZE", inherits = FALSE)) THIN_LINE_SIZE <- 0.75
if (!exists("MID_LINE_SIZE", inherits = FALSE)) MID_LINE_SIZE <- 1.5
if (!exists("THICK_LINE_SIZE", inherits = FALSE)) THICK_LINE_SIZE <- 3.5
if (!exists("HC.THEME", inherits = FALSE)) {
  HC.THEME <- NGR::hc_theme_538_gridlines()
}
if (!exists("GG_THEME", inherits = FALSE)) {
  GG_THEME <- ggplot2::theme_light()
}

if (knitr::is_html_output()) {
  if (!exists("FONT.SIZE.BODY", inherits = FALSE)) FONT.SIZE.BODY <- 11
  if (!exists("FONT.SIZE.HEADER", inherits = FALSE)) FONT.SIZE.HEADER <- 12
} else {
  if (!exists("FONT.SIZE.BODY", inherits = FALSE)) FONT.SIZE.BODY <- 10
  if (!exists("FONT.SIZE.HEADER", inherits = FALSE)) FONT.SIZE.HEADER <- 10
}
