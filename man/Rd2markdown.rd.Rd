\name{Rd2markdown.rd}
\alias{Rd2markdown.rd}
\title{Converts an Rd help file to markdown.}
\usage{
  Rd2markdown.rd(rd, outdir, file.ext = "markdown",
    link.ext = "html", front.matter,
    section = c("####", "####"), section.sep = "\n\n",
    run.examples = TRUE,
    knitrOptions = c(message = FALSE, warning = FALSE, error = FALSE))
}
\arguments{
  \item{rd}{an Rd data object.}

  \item{outdir}{directory to output the markdown file and
  any support files (e.g. figures). If missing, just the
  parsed results will be returned.}

  \item{file.ext}{file extension of the output file.}

  \item{link.ext}{file extension of linked files.}

  \item{front.matter}{text to include at the top of the
  file.}

  \item{section}{characters to surround section headings.}

  \item{section.sep}{character to print between sections.}

  \item{run.examples}{logical indicating whether to run the
  examples.}

  \item{knitrOptions}{options to pass to \code{knitr} for
  running the examples.}
}
\value{
  a character vector of length one where the element name
  is the topic name and the value is the filename.
}
\description{
  This function will convert an Rd file to markdown.
}

