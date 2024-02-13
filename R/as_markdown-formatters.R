# HTML-style named functions for text formatting


a_md <- function(text, href = NULL, is_email = FALSE) {
  if (is_empty(href)) href <- text
  if (is_email) href <- paste0("mailto:", href)
  href <- utils::URLencode(href)
  sprintf("[%s](%s)", text, href)
}

img_md <- function(src, alt) {
  sprintf("![%s](%s)", alt, src)
}

h_md <- function(text, section_level) {
  prefix <- strrep("#", section_level)
  sprintf("%s %s\n\n", prefix, trimws(text))
}

p_md <- function(text) {
  sprintf("%s\n\n", trimws(text))
}

b_md <- function(text) {
  sprintf("**%s**", text)
}

i_md <- function(text) {
  sprintf("*%s*", text)
}

bi_md <- function(text) {
  sprintf("***%s***", text)
}

q_md <- function(text) {
  sprintf("> %s", text)
}

code_md <- function(text) {
  sprintf("`%s`", text)
}

pre_md <- function(text, lang = NULL) {
  if (is_empty(lang)) lang <- ""
  sprintf("```%s\n%s\n```\n\n", lang, trimws(text))
}

li_md <- function(text, enum = FALSE) {
  if (enum) lc <- "1." else lc <- "*"
  sprintf("%s %s\n", lc, text)
}

table_md <- function(x) {
  # if data.frame has colnames(df) <- NULL then the md table will have empty
  # table heads:
  #
  # | |  |
  # |-|--|
  # |1|22|
  # |3|4 |
  #
  if (is.null(dim(x))) x <- matrix(x, nrow = 1)
  res <- vector("list", ncol(x))
  if (is.null(colnames(x))) colnames(x) <- rep("", ncol(x))
  for (i in seq_along(res)) {
    # format() outputs strings in same length, filled with whitespaces
    # "header", "1     ", "2      "
    # this is used for pretty md table text output
    nc <- max(nchar(format(c(colnames(x)[i], x[, i]))))
    tbl_col_head <- format(colnames(x)[i], width = nc)
    tbl_col_rows <- format(x[, i], width = nc)
    line <- strrep("-", nc)
    res[[i]] <- c(tbl_col_head, line, tbl_col_rows)
  }
  tbl_str <- paste0(
    do.call(paste, c("", res, "", sep = "|")),
    collapse = "\n"
  )
  sprintf("%s\n\n", tbl_str)
}
