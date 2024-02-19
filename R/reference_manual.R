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
  outdir = getwd(),
  front_matter = "",
  toc_matter = "<!-- toc -->",
  date_format = "%B %d, %Y",
  verbose = FALSE
) {
  # VALIDATION
  stopifnot(dir.exists(pkg) && length(pkg) == 1)
  stopifnot(dir.exists(outdir) && length(outdir) == 1)
  verbose <- isTRUE(verbose)

  # locate package
  pkg_path <- path.expand(pkg)
  pkg_name <- basename(pkg_path)
  type <- "src"
  mandir <- "man"

  if (!dir.exists(pkg_path)) {
    pkg_path <- find.package(pkg_name)
    type <- "bin"
    mandir <- "help"
  }

  if (length(mandir) != 1) stop("Please provide only one manuals directory.")
  if (!dir.exists(file.path(pkg_path, mandir)))
    stop(
      "Package manuals path does not exist.",
      "Check working directory or given pkg and manuals path!"
    )

  write_to_file <- function(x, file = man_file, append = TRUE) {
    cat(x, file = file, append = append)
  }

  # PARAMS
  section_sep <- "\n\n"

  # Output file for reference manual
  man_file <- file.path(outdir, paste0("Reference_Manual_", pkg_name, ".md"))

  # INIT REFERENCE MANUAL .md
  write_to_file(front_matter, append = FALSE) # yaml
  if (trim(front_matter) != "") write_to_file(section_sep)

  # Table of contents
  write_to_file(toc_matter)
  if (trim(toc_matter) != "") write_to_file(section_sep)

  # Date
  if (!is.null(date_format)) {
    write_to_file(format(Sys.Date(), date_format))
    write_to_file(section_sep)
  }

  # DESCRIPTION file
  write_to_file("# DESCRIPTION")
  write_to_file(section_sep)
  write_to_file("```\n")
  write_to_file(read_description(pkg_path))
  write_to_file("\n```\n")
  write_to_file(section_sep)

  # Get file list of rd files
  if (type == "src") {
    rd_files <- list.files(file.path(pkg_path, mandir), full.names = TRUE)
    topics <- gsub(".rd", "", gsub(".Rd", "", basename(rd_files)))
  } else {
    rd_files <- fetch_rd_db(file.path(pkg_path, mandir, pkg_name))
    topics <- names(rd_files)
  }

  # Parse rd files and add to ReferenceManual
  for (rdfile in rd_files) {#i=1
    if(verbose) message(paste0("Writing topic: ", rdfile, "\n"))
    cat(
      as_markdown(read_rdfile(rdfile)),
      file = man_file,
      append = TRUE
    )
  }

  invisible(man_file)

}

read_description <- function(path = ".") {
  path <- file.path(path, "DESCRIPTION")
  if (!file.exists(path)) {
    stop("Can't find DESCRIPTION file.")
  }
  paste0(readLines(path), collapse="\n")
}
