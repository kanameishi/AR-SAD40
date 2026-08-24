# Compose every $...$ fragment with the same flextable equation pattern used
# by the PSHA scaffold. Text before, between, and after equations remains text.
# NULL means that the cell has no mathematical fragment and stays unchanged.
.reportTableEquation <- function(text) {
  if (!is.character(text) || length(text) != 1L || is.na(text)) return(NULL)

  Matches <- gregexpr("\\$[^$]+\\$", text, perl = TRUE)[[1L]]
  if (length(Matches) == 1L && Matches[[1L]] == -1L) return(NULL)
  MatchLengths <- attr(Matches, "match.length")
  Content <- list()
  Cursor <- 1L

  for (i in seq_along(Matches)) {
    Start <- Matches[[i]]
    End <- Start + MatchLengths[[i]] - 1L
    if (Start > Cursor) {
      Content[[length(Content) + 1L]] <- flextable::as_chunk(
        substr(text, Cursor, Start - 1L)
      )
    }
    Content[[length(Content) + 1L]] <- flextable::as_equation(
      substr(text, Start + 1L, End - 1L)
    )
    Cursor <- End + 1L
  }
  if (Cursor <= nchar(text)) {
    Content[[length(Content) + 1L]] <- flextable::as_chunk(
      substr(text, Cursor, nchar(text))
    )
  }

  do.call(flextable::as_paragraph, Content)
}

buildReportTable <- function(
    data,
    headers = names(data),
    align = rep("left", ncol(data)),
    digits = NULL) {
  if (!is.data.frame(data)) {
    stop("The report table input must be a data frame.", call. = FALSE)
  }
  if (length(headers) != ncol(data) || length(align) != ncol(data)) {
    stop("Table headers and alignment must match the columns.", call. = FALSE)
  }
  if (!is.null(digits) && length(digits) != ncol(data)) {
    stop("Table digits must match the columns.", call. = FALSE)
  }
  if (!requireNamespace("NGR", quietly = TRUE) ||
      !requireNamespace("flextable", quietly = TRUE)) {
    stop("NGR and flextable are required to build report tables.", call. = FALSE)
  }

  Keys <- names(data)
  FontBody <- get0("FONT.SIZE.BODY", inherits = TRUE, ifnotfound = 11)
  FontHeader <- get0("FONT.SIZE.HEADER", inherits = TRUE, ifnotfound = 12)
  TBL <- NGR::buildTable(
    data,
    library = "flextable",
    align.body = "center",
    font.size.body = FontBody,
    font.size.header = FontHeader
  )
  TBL <- flextable::set_header_labels(
    TBL,
    values = stats::setNames(headers, Keys)
  )

  Alignment <- c(l = "left", c = "center", r = "right")
  if (any(!align %in% names(Alignment))) {
    stop("Table alignment must use l, c, or r.", call. = FALSE)
  }
  for (Code in names(Alignment)) {
    Columns <- Keys[align == Code]
    if (length(Columns)) {
      TBL <- flextable::align(
        TBL,
        j = Columns,
        align = Alignment[[Code]],
        part = "body"
      )
    }
  }

  if (!is.null(digits)) {
    for (i in seq_along(Keys)) {
      if (is.numeric(data[[i]]) && is.finite(digits[[i]])) {
        TBL <- flextable::colformat_double(
          TBL,
          j = Keys[[i]],
          digits = digits[[i]],
          big.mark = "",
          decimal.mark = ".",
          na_str = "—"
        )
      }
    }
  }

  if (requireNamespace("equatags", quietly = TRUE)) {
    for (i in seq_along(headers)) {
      Paragraph <- .reportTableEquation(headers[[i]])
      if (!is.null(Paragraph)) {
        TBL <- flextable::compose(
          TBL,
          part = "header",
          j = Keys[[i]],
          value = Paragraph
        )
      }
    }
    # One body column may contain both mathematical and plain-text cells.
    for (i in seq_along(Keys)) {
      Column <- data[[i]]
      if (!is.character(Column)) next
      for (k in seq_along(Column)) {
        Paragraph <- .reportTableEquation(Column[[k]])
        if (!is.null(Paragraph)) {
          TBL <- flextable::compose(
            TBL,
            part = "body",
            i = k,
            j = Keys[[i]],
            value = Paragraph
          )
        }
      }
    }
  }

  TBL <- flextable::padding(
    TBL,
    padding.top = 2,
    padding.bottom = 2,
    part = "all"
  )
  TBL <- flextable::line_spacing(TBL, space = 1, part = "all")
  flextable::set_table_properties(TBL, layout = "autofit")
}
