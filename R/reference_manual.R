#' @export
#' @name ReferenceManual
#' @title Create Reference Manual Markdown
#' @description This is a wrapper to combine the Rd files
#' of a package source or binary into a reference manual in markdown format.
#' @param pkg Full path to package directory.
#' Default value is the working directory.
#' Alternatively, a package name can be passed. If this is the case,
#' \code{\link[base]{find.package}} is applied.
#' @param outdir Output directory where the reference manual
#' markdown shall be written to.
#' @param front_matter String with yaml-style heading of markdown file.
#' @param toc_matter String providing the table of contents.
#' This is not auto-generated.
#' The default value is a HTML comment, used by gitbook plugin
#' \href{https://www.npmjs.com/package/gitbook-plugin-toc}{toc}.
#' @param date_format Date format that shall be written to the
#' beginning of the reference manual.
#' If \code{NULL}, no date is written.
#' Otherwise, provide a valid format (e.g. \code{\%Y-\%m-\%d}),
#' see Details in \link[base]{strptime}.
#' @param verbose If \code{TRUE} all messages and process steps will be printed
#' @references Murdoch, D. (2010).
#' \href{https://developer.R-project.org/parseRd.pdf}{Parsing Rd files}
#' @seealso Package
#' \href{https://github.com/jbryer/Rd2markdown}{Rd2markdown} by jbryer
#' @examples
#' ## give source directory of your package
#' pkg_dir = "~/git/MyPackage"
#'
#' ## specify, where reference manual shall be stored
#' out_dir = "/var/www/html/R_Web_app/md/"
#'
#' ## create reference manual
#' ## ReferenceManual(pkg = pkg_dir, outdir = out_dir)
create_reference_manual <- function(
  pkg = getwd(),
  output_file = NULL,
  output_format = md_document()
) {
  pkg_info <- get_package_info(pkg)
  output_file <- get_output_file(output_file, output_format, pkg_info)

  # Get file list of rd files
  rd_files <- get_rd_files(
    pkg_info$name,
    pkg_info$manpath,
    pkg_info$type
  )

  refman <- generate_refman(output_format, pkg_info, rd_files)

  write_to_file(
    refman,
    file = output_file
  )

  invisible(output_file)
}

generate_refman <- function(output_format, pkg_info, rd_files) {
  UseMethod("generate_refman")
}

write_to_file <- function(x, file, append = FALSE, sep = "\n") {
  cat(x, file = file, append = append, sep = sep)
}

get_output_file <- function(output_file, output_format, pkg_info) {
  if (is.null(output_file)) {
    output_file <- file.path(
      getwd(),
      paste0(pkg_info$name, output_format$file_ext)
    )
  }
  output_file
}


get_package_info <- function(pkg) {
  pkg_path <- path.expand(pkg)
  pkg_name <- basename(pkg_path)
  type <- "src"
  mandir <- "man"

  if (!dir.exists(pkg_path)) {
    # find.package will throw an error if package is not found
    pkg_path <- find.package(pkg_name)
    type <- "bin"
    mandir <- "help"
  }

  manpath <- file.path(pkg_path, mandir)
  if (!dir.exists(manpath))
    stop("Path does not exist:", manpath)

  list(
    path = pkg_path,
    name = pkg_name,
    type = type,
    mandir = mandir,
    manpath = manpath
  )
}

get_rd_files <- function(pkg_name, manpath, type) {
  if (type == "src") {
    rd_files <- list.files(manpath, full.names = TRUE)
  } else {
    rd_files <- fetch_rd_db(file.path(manpath, pkg_name))
  }
  rd_files
}

read_description <- function(path = ".") {
  path <- file.path(path, "DESCRIPTION")
  if (!file.exists(path)) {
    stop("Can't find DESCRIPTION file.")
  }
  paste0(readLines(path), collapse = "\n")
}
