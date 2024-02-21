#' @title Trim
#' @description Trim whitespaces and newlines before and after
#' @param x String to trim
#' @return character vector with stripped whitespaces
trim <- function(x) {
  gsub("^\\s+|\\s+$", "", x)
}

tr_ <- function(...) {
  enc2utf8(gettext(..., domain = "R-pkgdown"))
}

split_at_linebreaks <- function(text) {
  if (length(text) < 1)
    return(character())
  strsplit(text, "\\n\\s*\\n")[[1]]
}

# HTML-style named functions for text formatting

a <- function(text, href) {
  if (is.na(href)) return(text)
  href <- utils::URLencode(href)
  sprintf("[%s](%s)", text, href)
}

h <- function(text, section_level) {
  prefix <- rep("#", section_level)
  sprintf("%s %s\n\n", prefix, text)
}

p <- function(text) {
  sprintf("%s\n\n", text)
}

b <- function(text) {
  sprintf("**%s**", text)
}

i <- function(text) {
  sprintf("*%s*", text)
}

bi <- function(text) {
  sprintf("***%s***", text)
}

q <- function(text) {
  sprintf("> %s", text)
}

code <- function(x) {
  sprintf("`%s`", x)
}

pre <- function(x, lang = NULL) {
  if (!is.null(lang)) lang <- sprintf("{%s}", lang)
  sprintf("```%s\n%s\n```\n\n", lang, x)
}


#' @title Make first letter capital
#' @description Capitalize the first letter of every new word.
#' Very simplistic approach.
#' @param filebase The file path to the database (\code{.rdb} file),
#' with no extension.
#' @param key Keys to fetch
#' @return character vector with capitalized first letters
fetch_rd_db <- function(filebase, key = NULL) {
  fun <- function(db) {
    vals <- db$vals
    vars <- db$vars
    datafile <- db$datafile
    compressed <- db$compressed
    envhook <- db$envhook
    fetch <- function(key) lazyLoadDBfetch(
      vals[key][[1L]], 
      datafile, compressed, envhook
    )
    if (length(key)) {
      if (!key %in% vars) 
        stop(
          gettextf(
            "No help on %s found in RdDB %s", 
            sQuote(key), sQuote(filebase)
          ),
          domain = NA
        )
      fetch(key)
    } else {
      res <- lapply(vars, fetch)
      names(res) <- vars
      res
    }
  }
  res <- lazyLoadDBexec(filebase, fun)
  if (length(key))
    res
  else invisible(res)
}

# for testing package

#' Translate an Rd string to its HTML output
#'
#' @param x Rd string. Backslashes must be double-escaped ("\\\\").
#' @param fragment logical indicating whether this represents a complete Rd file
#' @param ... additional arguments for as_markdown
#'
#' @examples
#' rd2md("a\n%b\nc")
#'
#' rd2md("a & b")
#'
#' rd2md("\\strong{\\emph{x}}")
#'
#' @export
rd2md <- function(x, fragment = TRUE, ...) {
  md <- as_markdown(rd_text(x, fragment = fragment), ...)
  trim(strsplit(trim(md), "\n")[[1]])
}

rd_text <- function(x, fragment = TRUE) {
  con <- textConnection(x)
  on.exit(close(con), add = TRUE)
  set_classes(tools::parse_Rd(con, fragment = fragment, encoding = "UTF-8"))
}
