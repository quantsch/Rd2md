# parse as-is without applying a paragraph
flatten_text <- function(x, ...) {
  if (length(x) == 0) return("")
  parse_fun <- extract_from_dots("parse_fun", ...)

  trimws(paste(
    sapply(x, parse_fun, ...),
    collapse = ""
  ))
}

# make nice (multi) paragraph passages
flatten_para <- function(x, ...) {
  x <- x[!sapply(x, is_empty)]
  if (length(x) == 0) return("")

  parse_fun <- extract_from_dots("parse_fun", ...)
  fmt_p_fun <- extract_from_dots("fmt_p_fun", ...)

  # Look for "\n" TEXT blocks after a TEXT block, and not at end of file
  is_nl <- sapply(x, is_newline, trim = TRUE)
  is_text <- sapply(x, inherits, "TEXT")
  is_text_prev <- c(FALSE, is_text[-length(x)])
  has_next <- c(rep(TRUE, length(x) - 1), FALSE)
  is_para_break <- is_nl & is_text_prev & has_next

  # Or tags that are converted to individual paragraphs
  block_tags <- c(
    "tag_preformatted", "tag_itemize", "tag_enumerate", "tag_tabular",
    "tag_describe", "tag_subsection"
  )
  is_block <- sapply(x, inherits, block_tags)

  # Break before and after each status change
  before_break <- is_para_break | is_block
  after_break <- c(FALSE, before_break[-length(x)])
  groups <- cumsum(before_break | after_break)

  parsed_content <- lapply(x, parse_fun, ...)

  # clean text paragraphs from multiple whitespace and/or linebreaks
  empty <- sapply(x, function(x) length(x) == 0)
  needs_split <- !is_block & !empty
  parsed_content[needs_split] <- lapply(
    parsed_content[needs_split], split_at_linebreaks
  )

  blocks_ls <- lapply(
    split(parsed_content, groups),
    unlist
  )
  blocks <- sapply(
    blocks_ls,
    paste,
    collapse = ""
  )

  # There are three types of blocks:
  # 1. Combined text and inline tags
  # 2. Paragraph breaks (text containing only "\n")
  # 3. Block-level tags
  #
  # Need to wrap 1 in <p>
  needs_p <- sapply(split(!(is_nl | is_block), groups), any)

  blocks[needs_p] <- fmt_p_fun(trimws(blocks[needs_p]))

  paste0(blocks, collapse = "")
}


describe_contents <- function(x, ...) {
  # Drop pure whitespace nodes between items
  is_ws <- sapply(x, is_whitespace)

  # Group contiguous \items{}{}/whitespace into a <dl>
  is_item <- sapply(x, inherits, "tag_item") | is_ws
  changed <- is_item[-1] != is_item[-length(is_item)]
  group <- cumsum(c(TRUE, changed))

  parse_piece <- function(x, ...) {
    if (length(x) == 0) {
      NULL
    } else if (any(sapply(x, inherits, "tag_item"))) {
      parse_descriptions(x, ...)
    } else {
      flatten_text(x, ...)
    }
  }
  pieces <- split(x, group)
  paste(
    sapply(pieces, parse_piece, ...),
    collapse = "\n"
  )
}

# \item text blocks
parse_items <- function(x, enum = FALSE, ...) {
  separator <- sapply(x, inherits, "tag_item")
  group <- cumsum(separator)

  fmt_li_fun <- extract_from_dots("fmt_li_fun", ...)

  # Drop anything before first tag_item
  if (!all(group == 0) && any(group == 0)) {
    x <- x[group != 0]
    group <- group[group != 0]
  }

  parse_item <- function(x, enum, ...) {
    x <- trim_ws_nodes(x)
    items_str <- flatten_text(x, ...)
    fmt_li_fun(items_str, enum = enum)
  }
  paste(
    sapply(
      split(x, group),
      parse_item,
      enum = enum,
      ...
    ),
    collapse = ""
  )
}

# coming from an \item{}{} call
parse_descriptions <- function(rd, ...) {
  if (length(rd) == 0) return(character())
  fmt_li_fun <- extract_from_dots("fmt_li_fun", ...)
  fmt_code_fun <- extract_from_dots("fmt_code_fun", ...)

  parse_item <- function(x, ...) {
    if (inherits(x, "tag_item")) {
      fmt_li_fun(
        paste0(
          fmt_code_fun(flatten_text(x[[1]], ...)), ": ",
          flatten_text(x[[2]], ...)
        )
      )
    } else {
      flatten_para(x, ...)
    }
  }

  paste0(
    sapply(rd, parse_item, ...),
    collapse = ""
  )
}


# local helpers ------------------------------------------------------------

is_whitespace <- function(x) {
  inherits(x, "TEXT") && all(grepl("^\\s*$", x))
}

split_at_linebreaks <- function(text) {
  if (length(text) < 1) return(character())
  strsplit(text, "\\n\\s*\\n")[[1]]
}
