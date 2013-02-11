\name{parseRd}
\alias{parseRd}
\title{Parse an Rd object.}
\usage{
  parseRd(rd, link.ext)
}
\arguments{
  \item{rd}{and Rd object.}

  \item{link.ext}{file extension for links.}
}
\value{
  a list with the parts of the Rd object that will be used
  for creating an markdown file.
}
\description{
  This function will parse an Rd object returning a list
  with each section. The contents of each element of the
  list will be converted to markdown.
}

