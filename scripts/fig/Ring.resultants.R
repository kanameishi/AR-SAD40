buildRingResultantFigure <- function(path) {
  if (!is.character(path) || length(path) != 1L || !nzchar(path) ||
      !file.exists(path)) {
    stop("path must identify the generated ring-resultants figure.", call. = FALSE)
  }
  knitr::include_graphics(normalizePath(path, mustWork = TRUE))
}
