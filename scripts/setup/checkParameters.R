Params <- yaml::read_yaml("params.yml")$params
if (!is.list(Params)) stop("params.yml: top-level params object missing", call. = FALSE)
Issues <- character()
for (Field in c("latitude", "longitude", "site", "location")) {
  if (!Field %in% names(Params)) Issues <- c(Issues, paste0("params.", Field, " missing"))
}
if (!is.list(Params$client) || !"name" %in% names(Params$client)) {
  Issues <- c(Issues, "params.client.name missing")
}
Selections <- NULL
if (is.list(Params$report)) Selections <- Params$report$selections
if (!is.null(Selections)) {
  Valid <- is.list(Selections) && length(Selections) && all(vapply(Selections, is.list, logical(1L)))
  if (Valid) {
    Valid <- all(vapply(Selections, function(x) {
      COLS <- names(x)
      !is.null(COLS) && !anyDuplicated(COLS) && "SRS" %in% COLS &&
        all(COLS %in% c("SRS", "label")) && length(x$SRS) == 1L && !is.list(x$SRS) &&
        (!"label" %in% COLS || (length(x$label) == 1L && !is.list(x$label)))
    }, logical(1L)))
  }
  if (!Valid) Issues <- c(Issues, "params.report.selections must contain scalar SRS and optional scalar label")
  if (Valid && anyDuplicated(vapply(Selections, function(x) trimws(as.character(x$SRS)), character(1L)))) {
    Issues <- c(Issues, "params.report.selections contains duplicate SRS values")
  }
}
if (dir.exists("mapper")) {
  Mapper <- Params$mapper
  if (!is.list(Mapper)) Issues <- c(Issues, "params.mapper section missing")
  if (is.list(Mapper)) {
    for (Field in c("radius_km", "mw_min", "mw_max")) {
      if (!Field %in% names(Mapper)) Issues <- c(Issues, paste0("params.mapper.", Field, " missing"))
    }
    if (all(c("mw_min", "mw_max") %in% names(Mapper))) {
      # Conversion failure is reported together with the remaining parameter issues.
      AUX <- suppressWarnings(as.numeric(c(Mapper$mw_min, Mapper$mw_max)))
      Valid <- length(AUX) == 2L && all(is.finite(AUX))
      if (!Valid) Issues <- c(Issues, "params.mapper.mw_min/mw_max must be numeric")
      if (Valid && AUX[[1L]] >= AUX[[2L]]) Issues <- c(Issues, "params.mapper.mw_min must be < mw_max")
    }
  }
}
if (length(Issues)) stop(paste(Issues, collapse = "\n"), call. = FALSE)
message("SHA parameter contract passed")
