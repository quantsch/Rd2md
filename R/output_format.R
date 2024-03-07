#' Output Format Definition
#'
#' Specifies output format parameters.
#'
#' @param output_class_suffix Suffix to class name. E.g. `md` for
#' `output_format_md`.
#' @param file_ext File extension, if default output_file name.
#' @param parse_fun Parsing function, should be a generic S3 method.
#' @param ... Named arguments inserted into list structure output and eventually
#' passed as arguments to `parse_fun`.
#' @export
output_format <-  function(
  output_class_suffix,
  file_ext,
  parse_fun,
  ...
) {
  base_output_class <- "output_format"
  output_classes <- c(
    paste(base_output_class, tolower(output_class_suffix), sep = "_"),
    base_output_class
  )
  structure(
    list(
      parse_fun = parse_fun,
      file_ext = file_ext,
      ...
    ),
    class = output_classes
  )
}

#' Output Format Markdown
#'
#' Specifies markdown output format parameters.
#'
#' @param file_ext File extension, if default output_file name
#' @param section_level Initial section level, subsection level `n` will
#' consequently be `section_level + n`
#' @param date_format See `format` argument of [base::strptime()]
#' @param toc Currently not implemented. If table of contents should be included
#' in reference manual.
#' @export
md_document <- function(
  file_ext = ".md",
  section_level = 1,
  date_format = "%F",
  toc = FALSE
) {
  output_format(
    output_class_suffix = "md",
    parse_fun = as_markdown,
    file_ext = file_ext,
    section_level = section_level,
    toc = toc,
    date_format = date_format
  )
}