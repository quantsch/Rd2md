[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/Rd2md)](https://cran.r-project.org/package=Rd2md)
[![codecov](https://codecov.io/gh/quantsch/Rd2md/graph/badge.svg?token=0ZHTXDYG3T)](https://app.codecov.io/gh/quantsch/Rd2md)

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/L3L2ZG7SC)


# Installation

To install the `Rd2md` package, you can either use the official CRAN repository
or install directly from github.

From CRAN:

```r
install.packages("Rd2md")
```

From Github:

```r
devtools::install_github("quantsch/Rd2md")
```

The package does not have any third-party package dependencies as I wanted
to keep things simple. However, it heavily borrows ideas and code from
[pkgdown](https://github.com/r-lib/pkgdown), so big thanks to the great
work there!

# Introduction

See the introduction vignette:

```r
vignette("introduction")
```


# Roadmap

* significantly expand and improve unit tests
* fail early: introduce input validations for exposed functions
* add header content in output_format to pass `date_format`, etc.
* toc "<\!-- toc -->\n\n" and a front_matter implementation for markdown


# Extension

You can "easily" extend the parsing functionality by implementing your own
parser. Without further details, an (almost) minimal example for text reference
manual:

```r
# required: a generic parsing function
as_txt <- function(x, ...) UseMethod("as_txt")
# required: introduces recursion
process_txt_contents <- function(x, ...) {
  # traverse through list and concatenate to string
  if (is.list(x)) x[] <- lapply(x, as_txt, ...)
  paste(as.character(x), collapse = "")
}
# required: a fallback as not all tags might have an `as_txt` method
as_txt.default <- function(x, ...) {
  process_txt_contents(x, ...)
}
# not required but improves output significantly:
# we add a section title and a separator for readability
as_txt.rdsection <- function(x, ...) {
  paste0(
    Rd2md:::tag_to_title(x),
    "\n----------------\n\n",
    process_txt_contents(x, ...), "\n\n"
  )
}
# not required but improves output significantly:
# we add a paragraph after the description file
as_txt.DESCRIPTION <- function(x, ...) paste0(x, "\n\n")
# not required but looks better: we drop the comments
as_txt.COMMENT <- function(x, ...) ""

# required: the output_format definition
txt_document <- function() output_format("txt", ".txt", as_txt)

# now we can render our new text refman:
render_refman(output_format = txt_document())
```
