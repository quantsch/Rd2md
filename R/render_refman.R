#' Create Markdown Reference Manual
#'
#' This is a wrapper to combine the Rd files
#' of a package source or binary into a reference manual in markdown format.
#' @param pkg Full path to package directory.
#' Default value is the current working directory.
#' Alternatively, a package name can be passed as string.
#' If this is the case, [base::find.package()] is applied.
#' @param output_file Specify outputfile, including file extension
#' @param output_format Output format function. See [output_format()].
#' Default is [md_document()], but one could provide a custom output format.
#'
#' @references Murdoch, D. (2010).
#' [Parsing Rd files](https://developer.R-project.org/parseRd.pdf)
#' @seealso
#' * Package [Rd2markdown](https://github.com/jbryer/Rd2markdown),
#' on which the original version was based on.
#' * Package [pkgdown](https://github.com/r-lib/pkgdown),
#' on which the current (refactored) version is based on.
#' @examples
#' ## give source directory of your package
#' pkg_dir = "~/git/MyPackage"
#'
#' ## create reference manual
#' ## render_refman(pkg_dir)
#' @export
render_refman <- function(
  pkg = getwd(),
  output_file = NULL,
  output_format = md_document()
) {
  pkg_info <- get_package_info(pkg)
  output_file <- name_refman_file(output_file, output_format, pkg_info)

  rd_files <- read_package_rdfiles(pkg_info$path, subclass = "refman_rdfile")

  desc <- list(read_description(pkg_info$path))

  refman_sections <- append(desc, rd_files)

  refman <- paste0(
    sapply(refman_sections, parse_refman_content, output_format),
    collapse = ""
  )

  write_to_file(
    refman,
    file = output_file,
    sep = ""
  )
}

name_refman_file <- function(output_file, output_format, pkg_info) {
  if (is_empty(output_file)) {
    output_file <- file.path(
      getwd(),
      paste0(pkg_info$name, output_format$file_ext)
    )
  }
  output_file
}

parse_refman_content <- function(x, output_format) {
  do.call(output_format$parse_fun, append(list(x = x), output_format))
}

read_description <- function(path = ".") {
  file_path <- file.path(path, "DESCRIPTION")
  if (!file.exists(file_path)) {
    stop("Can't find DESCRIPTION file.")
  }
  structure(
    read_file(file_path),
    class = "DESCRIPTION"
  )
}
