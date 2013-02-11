\name{Rd2markdown}
\alias{Rd2markdown}
\title{Convert Rd help files to markdown.}
\usage{
  Rd2markdown(pkg, topics, outdir, public.only = TRUE,
    data.topics = TRUE, file.ext = "markdown",
    link.ext = "html", section.sep = "\n\n", front.matter,
    verbose = TRUE, ...)
}
\arguments{
  \item{pkg}{the package to generate files for.}

  \item{topics}{the topics to convert to markdown. If
  missing all topics will be converted.}

  \item{public.only}{if \code{TRUE} and \code{topics} not
  specified, include only exported functions as determined
  by \code{ls('package:PackageName')}.}

  \item{data.topics}{if \code{TRUE}, include data help
  pages.}

  \item{verbose}{if \code{TRUE}, print messages as
  parsing.}

  \item{...}{other parameters passed to
  \code{\link{Rd2markdown.rd}}}

  \item{outdir}{directory to output the markdown file and
  any support files (e.g. figures). If missing, just the
  parsed results will be returned.}

  \item{file.ext}{file extension of the output file.}

  \item{link.ext}{file extension of linked files.}

  \item{section.sep}{character to print between sections.}

  \item{front.matter}{text to include at the top of the
  file.}
}
\description{
  Converts the help topics in the given package to
  markdown.
}
\references{
  Murdoch, D. (2010).
  \href{http://developer.r-project.org/parseRd.pdf}{Parsing
  Rd files}.
}
\seealso{
  Rd2markdown.rd

  Rd2HTML
}

