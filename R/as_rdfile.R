package_rd <- function(path = ".") {
  man_path <- fs::path(path, "man")

  if (!fs::dir_exists(man_path)) {
    return(list())
  }

  rd <- fs::dir_ls(man_path, regexp = "\\.[Rr]d$", type = "file")
  names(rd) <- fs::path_file(rd)
  lapply(rd, read_rdfile, pkg_path = path)
}


as_rdfile <- function(x, ...) {
  x_cls <- set_classes(x)
  rdfile <- lapply(x_cls, as_rdsection)
  # removing NULL values, which appear due to parsing Rd files
  # as they contain "\n" linebreaks as separate items, that are no longer
  # required in this structured rdfile format
  rdfile[sapply(rdfile, is.null)] <- NULL
  names(rdfile) <- lapply(rdfile, function(x) x$id)
  structure(
    rdfile,
    class = "rdfile"
  )
}

parse_rd_file <- function(path, pkg_path = NULL) {
  enc <- "UTF-8"
  if (getRversion() >= "3.4.0") {
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


read_rdfile <- function(path, pkg_path = NULL) {
  parsed_rd <- parse_rd_file(path, pkg_path)
  as_rdfile(parsed_rd)
}



# Convert RD attributes to S3 classes -------------------------------------

set_classes <- function(rd) {
  if (is.list(rd)) {
    # `[]<-` keeps the attributes of `rd`
    rd[] <- lapply(rd, set_classes)
  }
  set_class(rd)
}

set_class <- function(x) {
  structure(
    x,
    # attr(x, "class") instead of "class" to avoid base classes like "list".
    # "tag" is the superclass, required to define generics like "print.tag".
    class = c(attr(x, "class"), tag(x), "tag"),
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
