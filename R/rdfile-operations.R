read_package_rdfiles <- function(pkg = ".", subclass = NULL) {
  pkg_rd_files <- tools::Rd_db(dir = pkg)
  lapply(pkg_rd_files, as_rdfile, subclass = subclass)
}

#' Read .Rd file
#'
#' And return object of class `rdfile`
#' @param path File path of `*.Rd`-file
#' @param pkg_path Package path, required to load macros, see
#' [tools::loadPkgRdMacros()].
#' @param subclass Potential subclass of returned `rdfile` object
#' @export
read_rdfile <- function(path, pkg_path = NULL, subclass = NULL) {
  parsed_rd <- parse_rd_file(path, pkg_path)
  as_rdfile(parsed_rd, subclass = subclass)
}

as_rdfile <- function(x, subclass = NULL, ...) {
  x_cls <- set_classes(x)
  # remove empty nodes
  x_cls[sapply(x_cls, is_empty)] <- NULL
  structure(
    x_cls,
    class = c(subclass, "rdfile")
  )
}

as_rdfragment <- function(x, subclass = NULL, ...) {
  x_cls <- set_classes(x)
  # remove empty nodes
  x_cls[sapply(x_cls, is_empty)] <- NULL
  structure(
    x_cls,
    class = c(subclass, "rdfragment")
  )
}

parse_rd_file <- function(path, pkg_path = NULL) {
  enc <- "UTF-8"
  if (getRversion() >= "3.4.0") {
    # loadPkgRdMacros returns NULL if input pkg_path is NULL
    macros <- tools::loadPkgRdMacros(pkg_path)
    parsed_rd <- tools::parse_Rd(path, macros = macros, encoding = enc)
  } else if (getRversion() >= "3.2.0") {
    macros <- tools::loadPkgRdMacros(pkg_path, TRUE)
    parsed_rd <- tools::parse_Rd(path, macros = macros, encoding = enc)
  } else {
    parsed_rd <- tools::parse_Rd(path, encoding = enc)
  }
  parsed_rd
}

# Convert RD attributes to S3 classes -------------------------------------

set_classes <- function(x) {
  if (is.list(x)) {
    # `[]<-` keeps the attributes of `rd`
    x[] <- lapply(x, set_classes)
  }
  set_class(x)
}

set_class <- function(x) {
  addtl_classes <- NULL
  # isTRUE will always return TRUE/FALSE, even if tag(x) returns with length 0
  if (isTRUE(tag(x) %in% section_tags)) {
    addtl_classes <- "rdsection"
  }
  structure(
    x,
    # attr(x, "class") instead of "class" to avoid base classes like "list".
    # "tag" is the superclass, required to define generics like "print.tag".
    class = c(attr(x, "class"), tag(x), addtl_classes, "tag"),
    # remove attributes that come with `tools::parse_Rd`, but are obsolete now
    Rd_tag = NULL,
    srcref = NULL,
    macros = NULL
  )
}

tag <- function(x) {
  tag <- attr(x, "Rd_tag")
  if (is.null(tag)) return()

  # Rd_tags start with "\\", e.g. "\\description",
  # hence we replace that with "tag_", e.g. "tag_description"
  gsub("\\", "tag_", tag, fixed = TRUE)
}


find_section <- function(x, name) {
  x[[which(sapply(x, inherits, name))]]
}

order_rdfile <- function(
  x,
  keep_first = NULL,
  keep_last = NULL,
  remove = NULL
) {
  section_names_in <- sapply(x, function(x) class(x)[1])
  # match() returns NA for unmatched elements -> hence suppressing NA
  x_sorted <- x[
    na.omit(c(
      match(keep_first, section_names_in, nomatch = NULL),
      which(!(section_names_in %in% c(keep_first, keep_last))),
      match(keep_last, section_names_in)
    ))
  ]
  section_names_sorted <- sapply(x_sorted, function(x) class(x)[1])
  x_sorted[which(!(section_names_sorted %in% remove))]
}
