#' @title Deprecated functions in package \pkg{Rd2md}.
#' @description The functions listed below are deprecated and will be defunct in
#'   the near future. When possible, alternative functions with similar
#'   functionality are also mentioned. Help pages for deprecated functions are
#'   available at `help("<function>-deprecated")`.
#' @name Rd2md-deprecated
#' @keywords internal
NULL

#' @keywords internal
#' @seealso [Rd2md-deprecated] and
#'   package \href{https://github.com/jbryer/Rd2markdown}{Rd2markdown} by jbryer
#' @name ReferenceManual-deprecated
#' @title Create Reference Manual Markdown
#' @description This is a wrapper to combine the Rd files of a package source or binary 
#'   into a reference manual in markdown format.
#' @param pkg Full path to package directory. Default value is the working directory. 
#' Alternatively, a package name can be passed. If this is the case, \code{\link[base]{find.package}} is applied.
#' @param outdir Output directory where the reference manual markdown shall be written to.
#' @param front.matter String with yaml-style heading of markdown file.
#' @param toc.matter String providing the table of contents. This is not auto-generated.
#'   The default value is a HTML comment, used by gitbook plugin
#'   \href{https://www.npmjs.com/package/gitbook-plugin-toc}{toc}.
#' @param date.format Date format that shall be written to the beginning of the reference manual. 
#'   If \code{NULL}, no date is written.
#'   Otherwise, provide a valid format (e.g. \code{\%Y-\%m-\%d}), see Details in \link[base]{strptime}.
#' @param verbose If \code{TRUE} all messages and process steps will be printed
#' @references Murdoch, D. (2010). \href{https://developer.R-project.org/parseRd.pdf}{Parsing Rd files}
#' @examples 
#' ## give source directory of your package
#' pkg_dir = "~/git/MyPackage"
#' 
#' ## specify, where reference manual shall be stored
#' out_dir = "/var/www/html/R_Web_app/md/"
#' 
#' ## create reference manual
#' ## ReferenceManual(pkg = pkg_dir, outdir = out_dir)
NULL

#' @rdname Rd2md-deprecated
#' @section `ReferenceManual`:
#'   For `ReferenceManual()`, use [Rd2md::render_refman()].
#'
#' @export
ReferenceManual <- function(
  pkg = getwd(), outdir = getwd(),
  front.matter = "",
  toc.matter = "<!-- toc -->",
  date.format = "%B %d, %Y",
  verbose = FALSE
) {

  .Deprecated("render_refman")

  # locate package
  pkg_path <- path.expand(pkg)
  pkg_name <- basename(pkg_path)

  # Output file for reference manual
  man_file <- file.path(outdir, paste0("Reference_Manual_", pkg_name, ".md"))

  render_refman(
    pkg,
    output_file = man_file,
    md_document(date_format = date.format)
  )
}

#' @keywords internal
#' @seealso [Rd2md-deprecated]
#' @name Rd2markdown-deprecated
#' @title Rd file to markdown
#' @description This function converts an Rd file into markdown format.
#' @param rdfile Filepath to an .Rd file or an \code{Rd} object to parse.
#' @param outfile Filepath to output file (markdown file).
#' @param append If outfile exists, append to existing content.
#' @return Parsed Rd as named list
#' @examples 
#' ## give a markdown source file
#' rdfile = "~/git/MyPackage/man/myfun.Rd"
#' ## specify, where markdown shall be stored
#' outfile = "/var/www/html/R_Web_app/md/myfun.md"
#' ## create markdown
#' ## Rd2markdown(rdfile = rdfile, outfile = outfile)
NULL

#' @rdname Rd2md-deprecated
#' @section `Rd2markdown`:
#' For `Rd2markdown()`, use [Rd2md::as_markdown()].
#'
#' @export
Rd2markdown <- function(rdfile, outfile, append=FALSE) {
  .Deprecated("as_markdown", package = "Rd2md")

  cat(
    as_markdown(read_rdfile(rdfile)),
    file = outfile,
    append = append
  )
}
