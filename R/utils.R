extract_from_dots <- function(name, ...) {
  args <- list(...)
  if (!name %in% names(args)) {
    stop("Please provide ", name, " in `...`.")
  }
  args[[name]]
}

write_to_file <- function(x, file, append = FALSE, sep = "\n") {
  cat(x, file = file, append = append, sep = sep)
  invisible(file)
}

# if collapse = NULL a vector with file lines is returned
read_file <- function(file, collapse = NULL) {
  paste(
    readChar(file, file.info(file)$size),
    collapse = collapse
  )
}

warn_not_implemented <- function(name, return_val = NULL) {
  warning(
    sprintf("%s not yet implemented. Returning: %s", name, return_val)
  )
  return_val
}

is_empty <- function(x) {
  # lists or vectors do not classify as empty, even if c("", "")
  if (length(x) > 1) return(FALSE)
  # the following classify as empty:
  # NULL, "", NA
  is.null(x) || is.na(x) || trimws(x) == ""
}

# local_links: try to obtain links to local filesystem documentation instead
#   of online sources
get_topic_href <- function(topic, package = NULL, local_links = FALSE) {
  if (is.null(package)) return(topic)
  aliases <- readRDS(
    system.file("help", "aliases.rds", package = package)
  )
  # reexports are from other packages
  aliases <- aliases[names(aliases) != "reexports"]
  rdname <- aliases[[topic]]
  if (is_package_local(package) && isTRUE(local_links)) {
    path <- find.package(package, quiet = TRUE)
    file.path(path, "doc", paste0(rdname, ".html"))
  } else {
    paste0(get_package_url(package), "/", rdname, ".html")
  }
}

get_package_url <- function(package) {
  base_pkgs <- c(
    "base", "compiler", "datasets", "graphics", "grDevices", "grid", "methods",
    "parallel", "splines", "stats", "stats4", "tcltk", "tools", "utils"
  )
  if (package %in% base_pkgs) {
    paste0("https://rdrr.io/r/", package)
  } else {
    paste0("https://rdrr.io/pkg/", package, "/man")
  }
}

is_package_local <- function(package) {
  # has to be local if no package is provided
  if (is.null(package)) return(TRUE)
  length(find.package(package, quiet = TRUE)) > 0
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

# for testing package -------------------------------------------------------

#' Translate an Rd string to markdown
#'
#' Note that this will always end in one newline \\n.
#'
#' @param x Rd string. Backslashes must be double-escaped ("\\\\").
#' @param fragment logical indicating whether this represents a complete Rd file
#' @param ... additional arguments for as_markdown
#'
#' @examples
#' rd_str_to_md("a\n%b\nc")
#'
#' rd_str_to_md("a & b")
#'
#' rd_str_to_md("\\strong{\\emph{x}}")
#'
#' rd_str_to_md("\\enumerate{\\item test 1\n\n\\item test 2}")
#' rd_str_to_md("wrapped \\itemize{\\item test 1\n\\item test 2} in text")
#'
#' @export
rd_str_to_md <- function(
  x,
  fragment = TRUE,
  ...
) {
  as_markdown(
    rd_text(x, fragment = fragment),
    ...
  )
}

rd_text <- function(x, fragment = TRUE) {
  con <- textConnection(x)
  on.exit(close(con), add = TRUE)
  as_rdfragment(
    tools::parse_Rd(con, fragment = fragment, encoding = "UTF-8")
  )
}
