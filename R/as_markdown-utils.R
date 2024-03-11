trim_ws_nodes <- function(x, side = c("both", "left", "right")) {
  is_ws <- sapply(x, function(x) inherits(x, "TEXT") && grepl("^\\s*$", x[[1]]))

  if (!any(is_ws))
    return(x)
  if (all(is_ws))
    return(x[0])

  which_not <- which(!is_ws)

  side <- match.arg(side)
  if (side %in% c("left", "both")) {
    start <- which_not[1]
  } else {
    start <- 1
  }

  if (side %in% c("right", "both")) {
    end <- which_not[length(which_not)]
  } else {
    end <- length(x)
  }

  x[start:end]
}

stop_bad_tag <- function(tag, msg = NULL) {
  bad_tag <- paste0("\\", tag, "{}")
  msg_abort <- sprintf("Failed to parse tag %s.", bad_tag)
  stop(msg_abort, msg)
}

is_newline <- function(x, trim = FALSE) {
  if (!inherits(x, "TEXT") && !inherits(x, "RCODE") && !inherits(x, "VERB"))
    return(FALSE)

  text <- x[[1]]
  if (trim) text <- gsub("^[ \t]+|[ \t]+$", "", text)
  identical(text, "\n")
}

tag_to_title <- function(x) {
  tag <- gsub("^tag_", "", class(x)[1])
  tools::toTitleCase(tag)
}

section_tags <- paste0(
  "tag_",
  c(
    "alias",
    "arguments",
    "author",
    "concept",
    "description",
    "details",
    "format",
    "keyword",
    "name",
    "note",
    "references",
    "section",
    "seealso",
    "source",
    "title",
    "value",
    "examples",
    "usage"
  )
)

set_default_args_md <- function(fun) {
  function(
    x,
    parse_fun = as_markdown,
    fmt_p_fun = p_md,
    fmt_li_fun = li_md,
    fmt_code_fun = code_md,
    ...
  ) {
    fun(
      x,
      parse_fun = parse_fun,
      fmt_p_fun = fmt_p_fun,
      fmt_li_fun = fmt_li_fun,
      fmt_code_fun = fmt_code_fun,
      ...
    )
  }
}

flatten_text_md <- set_default_args_md(flatten_text)
flatten_para_md <- set_default_args_md(flatten_para)
describe_contents_md <- set_default_args_md(describe_contents)
parse_items_md <- set_default_args_md(parse_items)
parse_descriptions_md <- set_default_args_md(parse_descriptions)

remove_obsolete_newlines <- function(text) {
  gsub("\\n\\n+", "\n\n", text)
}

parse_section_md <- function(
  x,
  title = NULL,
  section_level = 1,
  ...
) {
  if (is.null(title)) {
    title <- tag_to_title(x)
  }
  remove_obsolete_newlines(paste0(
    h_md(title, section_level),
    flatten_para_md(x, ...)
  ))
}
