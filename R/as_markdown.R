# generic as_markdown --------------------------------------------------------

#' Parse into Markdown
#'
#' S3 Methods to parse different classes into Markdown.
#' @param x Object
#' @param ... Further arguments passed to methods
#' @export
as_markdown <- function(x, ...) {
  UseMethod("as_markdown")
}

#' @export
as_markdown.default <- function(x, ...) {
  warning(
    sprintf(
      "Unknown as_markdown method for class(es): %s",
      paste0(class(x), collapse = ", ")
    )
  )
  paste0(
    sapply(x, as_markdown, ...),
    collapse = ""
  )
}

#' @export
as_markdown.Rd <- function(x, ...) {
  paste0(
    sapply(x, as_markdown, ...),
    collapse = ""
  )
}

# Various internal classes ---------------------------------------------------

#' @export
as_markdown.DESCRIPTION <- function(x, section_level = 1, ...) {
  paste0(
    h_md("DESCRIPTION", section_level = section_level),
    pre_md(paste(x, collapse = "\n"))
  )
}

#' @export
as_markdown.refman_rdfile <- function(x, section_level = 1, ...) {
  funname <- flatten_text_md(find_section(x, "tag_name"), ...)
  fundesc <- flatten_text_md(find_section(x, "tag_title"), ...)
  title <- h_md(
    paste(
      code_md(funname),
      fundesc,
      sep = ": "
    ),
    section_level
  )

  x <- order_rdfile(
    x,
    keep_first = paste0("tag_", c("description", "usage", "arguments")),
    # name and title already concatenated above
    # alias(es) will be shown in usage section
    remove = paste0("tag_", c("name", "title", "alias")),
    keep_last = paste0("tag_", c("value", "see_also", "examples"))
  )

  subsection_level <- section_level + 1
  rest <- paste0(
    sapply(x, as_markdown, section_level = subsection_level, ...),
    collapse = ""
  )

  paste0(
    title,
    rest
  )
}

#' @export
as_markdown.rdfile <- function(x, section_level = 1, ...) {
  title <- as_markdown(
    find_section(x, "tag_title"), section_level = section_level, ...
  )

  x <- order_rdfile(
    x,
    keep_first = paste0("tag_", c("description", "usage", "arguments")),
    # title already concatenated above
    # name and alias(es) will be shown in usage section
    remove = paste0("tag_", c("name", "title", "alias")),
    keep_last = paste0("tag_", c("value", "see_also", "examples"))
  )

  subsection_level <- section_level + 1
  rest <- paste0(
    sapply(x, as_markdown, section_level = subsection_level, ...),
    collapse = ""
  )

  paste0(
    title,
    rest
  )
}

#' @export
as_markdown.rdfragment <- function(x, ...) {
  paste0(
    sapply(x, as_markdown, ...),
    collapse = ""
  )
}

#' @export
as_markdown.NULL <- function(x, ...) ""

# Sections ------------------------------------------------------------------

#' @export
as_markdown.tag_alias <- parse_section_md
#' @export
as_markdown.tag_arguments <- function(x, section_level = 2, ...) {
  title <- tag_to_title(x)
  paste0(
    h_md(title, section_level),
    flatten_para_md(describe_contents_md(x, ...), ...)
  )
}

#' @export
as_markdown.tag_author <- parse_section_md
#' @export
as_markdown.tag_concept <- parse_section_md
#' @export
as_markdown.tag_description <- parse_section_md
#' @export
as_markdown.tag_details <- parse_section_md
#' @export
as_markdown.tag_docType <- function(x, ...) ""
#' @export
as_markdown.tag_encoding <- function(x, ...) ""
#' @export
as_markdown.tag_examples <- function(x, section_level, ...) {
  p_md(
    paste0(
      h_md(tag_to_title(x), section_level),
      pre_md(flatten_text_md(x, ...), lang = "r")
    )
  )
}
#' @export
as_markdown.tag_format <- parse_section_md
#' @export
as_markdown.tag_keyword <- parse_section_md
#' @export
as_markdown.tag_name <- function(x, ...) {
  parse_section_md(NULL, x[[1]], ...)
}
#' @export
as_markdown.tag_note <- parse_section_md
#' @export
as_markdown.tag_Rdversion <- function(x, ...) ""
#' @export
as_markdown.tag_references <- parse_section_md
#' @export
as_markdown.tag_section <- function(x, ...) {
  parse_section_md(x[[2]], title = x[[1]], fmt_code_fun = function(x) x, ...)
}
#' @export
as_markdown.tag_seealso <- parse_section_md
#' @export
as_markdown.tag_source <- parse_section_md
#' @export
as_markdown.tag_title <- function(x, ...) {
  parse_section_md(NULL, title = x[[1]], ...)
}
#' @export
as_markdown.tag_value <- parse_section_md
#' @export
as_markdown.tag_usage <- function(x, section_level, ...) {
  p_md(
    paste0(
      h_md(tag_to_title(x), section_level),
      pre_md(flatten_text_md(x, ...), lang = "r")
    )
  )
}

# Not implemented -----------------------------------------------------------

#' @export
as_markdown.tag_RdOpts <- function(x, ...) {
  warn_not_implemented("\\RdOpts", NULL)
}
#' @export
as_markdown.tag_Sexpr <- function(x, ...) {
  warn_not_implemented("\\Sexpr", NULL)
}


# Text  ---------------------------------------------------------------------

#' @export
as_markdown.character <- function(x, ...) as.character(x)
#' @export
as_markdown.LIST <-  function(x, ...) flatten_text_md(x, ...)
#' @export
as_markdown.TEXT <-  as_markdown.character
#' @export
as_markdown.RCODE <- as_markdown.character
#' @export
as_markdown.VERB <-  as_markdown.character
#' @export
as_markdown.COMMENT <- function(x, ...) ""
#' @export
as_markdown.USERMACRO <-  function(x, ...) ""

#' @export
as_markdown.tag_subsection <- function(x, ..., subsection_level = 3L) {
  title <- flatten_text_md(x[[1]], ...)
  text <- flatten_para_md(x[[2]], subsection_level = subsection_level + 1L, ...)
  paste0(
    h_md(title, subsection_level),
    text,
    collapse = ""
  )
}

# Equations ------------------------------------------------------------------

#' @export
as_markdown.tag_eqn <- function(x, ...) {
  latex_rep <- x[[1]]
  paste0("$", flatten_text_md(latex_rep, ...), "$")
}

#' @export
as_markdown.tag_deqn <- function(x, ...) {
  latex_rep <- x[[1]]
  paste0("$$", flatten_text_md(latex_rep, ...), "$$")
}

# Links ----------------------------------------------------------------------

#' @export
as_markdown.tag_url <- function(x, ...) {
  if (length(x) != 1) {
    if (length(x) == 0) {
      msg <- "Check for empty \\url{{}} tags."
    } else {
      msg <- "This may be caused by a \\url tag that spans a line break."
    }
    stop_bad_tag("url", msg)
  }

  text <- flatten_text_md(x[[1]])
  a_md(text, href = text)
}

#' @export
as_markdown.tag_href <- function(x, ...) {
  a_md(flatten_text_md(x[[2]]), href = flatten_text_md(x[[1]]))
}

#' @export
as_markdown.tag_email <- function(x, ...) {
  a_md(flatten_text_md(x, ...), is_email = TRUE)
}


# If single, need to look up alias to find file name and package
#' @export
as_markdown.tag_link <- function(x, ...) {
  # \link[opt]{in_braces}
  opt <- attr(x, "Rd_option")
  in_braces <- flatten_text_md(x)

  if (is.null(opt)) {
    # \link{topic}
    href <- get_topic_href(in_braces)
  } else if (substr(opt, 1, 1) == "=") {
    # \link[=dest]{name}
    href <- get_topic_href(substr(opt, 2, nchar(opt)))
  } else {
    match <- regexec("^([^:]+)(?:|:(.*))$", opt)
    parts <- regmatches(opt, match)[[1]][-1]

    if (parts[[2]] == "") {
      # \link[pkg]{foo}
      href <- get_topic_href(in_braces, opt)
    } else {
      # \link[pkg:bar]{foo}
      href <- get_topic_href(parts[[2]], parts[[1]])
    }
  }

  a_md(in_braces, href = href)
}

#' @export
as_markdown.tag_linkS4class <- function(x, ...) {
  if (length(x) != 1) stop_bad_tag("linkS4class")

  text <- flatten_text_md(x[[1]])
  href <- get_topic_href(paste0(text, "-class"))
  a_md(text, href = href)
}

# Miscellaneous --------------------------------------------------------------

#' @export
as_markdown.tag_method <- function(x, ...) method_usage_md(x, "S3")
#' @export
as_markdown.tag_S3method <- function(x, ...) method_usage_md(x, "S3")
#' @export
as_markdown.tag_S4method <- function(x, ...) method_usage_md(x, "S4")

method_usage_md <- function(x, type) {
  fun <- as_markdown(x[[1]])
  class <- as_markdown(x[[2]])
  sprintf("# %s method for %s\n%s", type, class, fun)
}

# Conditionals ---------------------------------------------------------------

#' @export
as_markdown.tag_if <- function(x, ...) {
  if (x[[1]] == "markdown") {
    as_markdown(x[[2]], ...)
  } else {
    ""
  }
}

#' @export
as_markdown.tag_ifelse <- function(x, ...) {
  if (x[[1]] == "markdown") {
    as_markdown(x[[2]], ...)
  } else {
    as_markdown(x[[3]], ...)
  }
}

# Used inside a \usage{} Rd tag to prevent the code from being treated as
# regular R syntax, either because it is not valid R, or because its usage
# intentionally deviates from regular R usage. An example of the former is the
# command line documentation, e.g. `R CMD SHLIB`
# (https://github.com/wch/r-source/blob/trunk/src/library/utils/man/SHLIB.Rd):
#
#    \special{R CMD SHLIB [options] [-o dllname] files}
#
# An example of the latter is the documentation shortcut `?`
# (https://github.com/wch/r-source/blob/trunk/src/library/utils/man/Question.Rd):
#
#    \special{?topic}
#
#' @export
as_markdown.tag_special <- function(x, ...) {
  flatten_text_md(x, ...)
}

#' @export
`as_markdown.#ifdef` <- function(x, ...) {
  os <- trimws(flatten_text_md(x[[1]]))
  if (os == "unix") {
    flatten_text_md(x[[2]])
  } else {
    ""
  }
}

#' @export
`as_markdown.#ifndef` <- function(x, ...) {
  os <- trimws(flatten_text_md(x[[1]]))
  if (os == "windows") {
    flatten_text_md(x[[2]])
  } else {
    ""
  }
}

# Tables ---------------------------------------------------------------------

#' @export
as_markdown.tag_tabular <- function(x, ...) {
  align_abbr <- strsplit(as.character(x[[1]]), "")[[1]]
  align <- align_abbr[align_abbr != "|"]

  contents <- x[[2]]
  class <- sapply(contents, function(x) class(x)[[1]])

  row_sep <- class == "tag_cr"
  contents[row_sep] <- list("")
  col_sep <- class == "tag_tab"
  sep <- col_sep | row_sep

  # Identify groups in reverse order (preserve empty cells)
  # Negative maintains correct ordering once reversed
  cell_grp <- rev(cumsum(-rev(sep)))
  cells <- unname(split(contents, cell_grp))
  # Remove trailing content (that does not match the dimensions of the table)
  cells <- cells[seq_len(length(cells) - length(cells) %% length(align))]
  cell_contents <- trimws(sapply(cells, flatten_text_md, ...))
  tbl <- matrix(cell_contents, ncol = length(align), byrow = TRUE)

  table_md(tbl)
}


# Figures -----------------------------------------------------------------

#' @export
as_markdown.tag_figure <- function(x, ...) {
  path <- as.character(x[[1]])
  alt <- ""

  if (length(x) == 2) {
    opt <- paste(trimws(as.character(x[[2]])), collapse = " ")
    if (substr(opt, 1, 9) != "options: ") {
      alt <- opt
    }
  }

  img_md(path, alt)
}

# List -----------------------------------------------------------------------

#' @export
as_markdown.tag_itemize <- function(x, ...) {
  flatten_para_md(parse_items_md(x, ...))
}
#' @export
as_markdown.tag_enumerate <- function(x, ...) {
  flatten_para_md(parse_items_md(x, enum = TRUE, ...))
}

#' @export
# we manipulate the argument `fmt_code_fun` of the `...` as we cannot directly
# call `parse_descriptions_md(x, fmt_code_fun= f unction(x) x, ...)`, then there
# could be twice the argument `fmt_code_fun`, once explicitly passed and once
# through `...`
as_markdown.tag_describe <- function(x, ...) {
  args <- list(...)
  args$fmt_code_fun <- function(x) x
  flatten_para_md(
    do.call(describe_contents_md, append(list(x = x), args))
  )
}

# only used by parse_items() to split up sequence of tags
#' @export
as_markdown.tag_item <- function(x, ...) ""

# Marking text --------------------------------------------------------------
# https://cran.rstudio.com/doc/manuals/r-devel/R-exts.html#Marking-text

wrap_flattened_text <- function(fun) {
  function(x, ...) {
    fun(flatten_text_md(x, ...))
  }
}

#' @export
as_markdown.tag_emph <- wrap_flattened_text(i_md)
#' @export
as_markdown.tag_strong <- wrap_flattened_text(bi_md)
#' @export
as_markdown.tag_bold <- wrap_flattened_text(b_md)

#' @export
as_markdown.tag_dQuote <- wrap_flattened_text(sQuote)
#' @export
as_markdown.tag_sQuote <- wrap_flattened_text(sQuote)

#' @export
as_markdown.tag_code <- wrap_flattened_text(code_md)

#' @export
as_markdown.tag_preformatted <- wrap_flattened_text(pre_md)

#' @export
as_markdown.tag_kbd <- wrap_flattened_text(code_md)
#' @export
as_markdown.tag_samp <- function(x, ...) sQuote(code_md(flatten_text_md(x, ...)))

#' @export
as_markdown.tag_verb <- wrap_flattened_text(code_md)

#' @export
as_markdown.tag_pkg <- wrap_flattened_text(code_md)
#' @export
as_markdown.tag_file <- wrap_flattened_text(code_md)

#' @export
as_markdown.tag_var <- wrap_flattened_text(i_md)
#' @export
as_markdown.tag_env <- wrap_flattened_text(code_md)
#' @export
as_markdown.tag_option <- wrap_flattened_text(code_md)
#' @export
as_markdown.tag_command <- wrap_flattened_text(code_md)

#' @export
as_markdown.tag_dfn <- as_markdown.character
#' @export
as_markdown.tag_cite <- as_markdown.character
#' @export
as_markdown.tag_acronym <- as_markdown.character
#' @export
as_markdown.tag_abbr <- as_markdown.character

#' @export
as_markdown.tag_out <- function(x, ...) flatten_text_md(x, ..., escape = FALSE)

# Insertions --------------------------------------------------------------

#' @export
as_markdown.tag_R <- function(x, ...) code_md("R")
#' @export
as_markdown.tag_dots <- function(x, ...) code_md("...")
#' @export
as_markdown.tag_ldots <- function(x, ...) code_md("...")
#' @export
as_markdown.tag_cr <- function(x, ...) "\n"

# First element of enc is the encoded version (second is the ascii version)
#' @export
as_markdown.tag_enc <- function(x, ...) {
  if (length(x) == 2) {
    as_markdown(x[[1]], ...)
  } else {
    stop_bad_tag("enc")
  }
}

# Elements that don't return anything ----------------------------------------

#' @export
as_markdown.tag_tab <- function(x, ...) ""
#' @export
as_markdown.tag_newcommand <- function(x, ...) ""
#' @export
as_markdown.tag_renewcommand <- function(x, ...) ""
