md_document <- function(
  section_level = 1,
  front_matter = NULL,
  toc_matter = "<!-- toc -->",
  date_format = "%F",
  file_ext = ".md"
) {
  structure(
    list(
      section_level = section_level,
      front_matter = front_matter,
      toc_matter = toc_matter,
      date_format = date_format,
      file_ext = file_ext
    ),
    class = "output_format_md"
  )
}

generate_refman.output_format_md <- function(
  output_format,
  pkg_info,
  rd_files
) {
  rd_content <- lapply(
    rd_files,
    function(x) {
      do.call(
        as_markdown,
        append(
          list(x = read_rdfile(x)),
          output_format
        )
      )
    }
  )
  # TODO: make pkg_description class and call as_markdown.pkg_description on it
  pkg_description <- refman_description_md(
    pkg_path = pkg_info$path,
    section_level = output_format$section_level
  )
  doc_date <- format(Sys.Date(), output_format$date_format)
  paste0(
    c(
      output_format$front_matter,
      output_format$toc_matter,
      doc_date,
      pkg_description,
      unlist(rd_content)
    ),
    collapse = ""
  )
}

refman_description_md <- function(pkg_path, section_level) {
  desc_text <- read_description(pkg_path)
  paste0(
    h("DESCRIPTION", section_level = section_level),
    pre(desc_text)
  )
}
