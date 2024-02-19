as_rdsection <- function(x, ...) {
  UseMethod("as_rdsection")
}
# previous as_data

#' @export
as_rdsection.default <- function(x, ...) {
  NULL
}


# Sections ----------------------------------------------------------------

parse_section <- function(x, title, id = tolower(title), ...) {
  text <- flatten_para(x, ...)

  structure(
    list(
      id = id,
      title = title,
      content = text
    ),
    class = "rdsection"
  )
}

#' @export
as_rdsection.tag_name <- function(x, ...) {
  parse_section(
    NULL,
    as_markdown(x[[1]], escape = FALSE),
    id = tr_("name"),
    ...
  )
}

#' @export
as_rdsection.tag_alias <- function(x, ...) {
  parse_section(x, tr_("Alias"), ...)
}

#' @export
as_rdsection.tag_title <- function(x, ...) {
  parse_section(x, tr_("Title"), ...)
}
# add tag_concept, tag_keyword

#' @export
as_rdsection.tag_usage <- function(x, ...) {
  parse_section(x, tr_("Usage"), ...)
}

#' @export
as_rdsection.tag_details <- function(x, ...) {
  parse_section(x, tr_("Details"), ...)
}
#' @export
as_rdsection.tag_description <- function(x, ...) {
  parse_section(x, tr_("Description"), ...)
}
#' @export
as_rdsection.tag_references <- function(x, ...) {
  parse_section(x, tr_("References"), ...)
}
#' @export
as_rdsection.tag_source <- function(x, ...) {
  parse_section(x, tr_("Source"), ...)
}
#' @export
as_rdsection.tag_format <- function(x, ...) {
  parse_section(x, tr_("Format"), ...)
}
#' @export
as_rdsection.tag_note <- function(x, ...) {
  parse_section(x, tr_("Note"), ...)
}
#' @export
as_rdsection.tag_author <- function(x, ...) {
  parse_section(x, tr_("Author"), ...)
}
#' @export
as_rdsection.tag_seealso <- function(x, ...) {
  parse_section(x, tr_("See also"), ...)
}
#' @export
as_rdsection.tag_section <- function(x, ...) {
  parse_section(x[[2]], as_markdown(x[[1]], ...), ...)
}

# \arguments{} & \details{} -----------------------------------------------
# Both are like the contents of \description{} but can contain arbitrary
# text outside of \item{}

#' @export
as_rdsection.tag_arguments <- function(x, ...) {
  parse_section(
    describe_contents(x, ...),
    tr_("Arguments"),
    ...
  )
}

#' @export
as_rdsection.tag_value <- function(x, ...) {
  parse_section(
    describe_contents(x, ...),
    tr_("Value"),
    ...
  )
}

describe_contents <- function(x, ...) {
  # Drop pure whitespace nodes between items
  is_ws <- purrr::map_lgl(x, is_whitespace)

  # Group contiguous \items{}/whitespace into a <dl>
  is_item <- purrr::map_lgl(x, inherits, "tag_item") | is_ws
  changed <- is_item[-1] != is_item[-length(is_item)]
  group <- cumsum(c(TRUE, changed))

  parse_piece <- function(x) {
    if (length(x) == 0) {
      NULL
    } else if (any(purrr::map_lgl(x, inherits, "tag_item"))) {
      paste0("<dl>\n", parse_descriptions(x, ...), "</dl>")
    } else {
      flatten_para(x, ...)
    }
  }
  pieces <- split(x, group)
  out <- purrr::map(pieces, parse_piece)

  paste(unlist(out), collapse = "\n")
}

is_whitespace <- function(x) {
  inherits(x, "TEXT") && all(grepl("^\\s*$", x))
}