.escapeHtml <- function(x) {
  x <- if (is.null(x) || !length(x)) "" else as.character(x[[1L]])
  x <- gsub("&", "&amp;", x, fixed = TRUE)
  x <- gsub("<", "&lt;", x, fixed = TRUE)
  x <- gsub(">", "&gt;", x, fixed = TRUE)
  gsub('"', "&quot;", x, fixed = TRUE)
}

buildCoverReport <- function(params) {
  h <- .escapeHtml
  SiteLocation <- paste(
    c(params$site, params$location)[nzchar(c(params$site, params$location))],
    collapse = ". "
  )
  ProjectLines <- paste0(
    '<div class="srk-cover__project-line">', h(params$title), "</div>"
  )

  ConsultantAddress <- paste0(
    "<p>", vapply(params$consultant$address, h, character(1)), "</p>",
    collapse = "\n"
  )
  ConsultantBlock <- paste0(
    '<section class="srk-cover__block">',
    '<div class="srk-cover__block-title">Preparado por:</div>',
    '<div class="srk-cover__block-body">',
    '<p>', h(params$consultant$name), '</p>',
    ConsultantAddress,
    '<p><a href="', h(params$consultant$web), '">',
    h(params$consultant$web), '</a></p>',
    '</div></section>'
  )

  AuthorBlock <- ""
  if (!is.null(params$roles) && length(params$roles)) {
    AuthorLines <- vapply(params$roles, function(Role) {
      Name <- h(Role$name)
      Title <- h(Role$title)
      if (!nzchar(Title)) return(paste0("<p>", Name, "</p>"))
      paste0("<p>", Name, "<br>", Title, "</p>")
    }, character(1))
    AuthorBlock <- paste0(
      '<section class="srk-cover__block">',
      '<div class="srk-cover__block-title">Autores:</div>',
      '<div class="srk-cover__block-body">',
      paste(AuthorLines, collapse = "\n"),
      '</div></section>'
    )
  }

  ClientBlock <- ""
  if (nzchar(h(params$client$name))) {
    ClientBlock <- paste0(
      '<section class="srk-cover__block">',
      '<div class="srk-cover__block-title">Preparado para:</div>',
      '<div class="srk-cover__block-body"><p>', h(params$client$name),
      '</p></div></section>'
    )
  }

  paste0(
    '<section class="srk-cover"><div class="srk-cover__layout">',
    '<div class="srk-cover__content"><div class="srk-cover__title-group">',
    '<div class="srk-cover__kicker">', h(SiteLocation), '</div>',
    '<div class="srk-cover__project">', ProjectLines, '</div></div>',
    '<div class="srk-cover__blocks">', ClientBlock, ConsultantBlock, AuthorBlock, '</div>',
    '<div class="srk-cover__meta"><div class="srk-cover__meta-item">',
    '<div class="srk-cover__meta-label">Proyecto</div>',
    '<div class="srk-cover__meta-value">', h(params$project_id), '</div>',
    '</div><div class="srk-cover__meta-item">',
    '<div class="srk-cover__meta-label">Año</div>',
    '<div class="srk-cover__meta-value">', h(params$year), '</div>',
    '</div></div></div></div></section>'
  )
}
