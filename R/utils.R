#' @title Strip white space
#' @description Strip white space (spaces only) from the beginning and end of a character.
#' @param x character to strip white space from
#' @return a character with white space stripped
stripWhite <- function(x) {
	sub("([ ]+$)", "", sub("(^[ ]+)", "", x, perl=TRUE), perl=TRUE)
}

#' @title Extract Rd tags
#' @description Extract Rd tags from Rd object
#' @param Rd Object of class \code{Rd}
#' @return character vector with Rd tags
RdTags = function(Rd) {
  res <- sapply(Rd, attr, "Rd_tag")
  if (!length(res)) 
    res <- character()
  res
}

#' @title Make first letter capital
#' @description Capitalize the first letter of every new word. Very simplistic approach.
#' @param x Character string
#' @return character vector with capitalized first letters
simpleCap <- function(x) {
	s <- strsplit(x, " ")[[1]]
	paste(toupper(substring(s, 1,1)), substring(s, 2), sep="", collapse=" ")
}

#' @title Make first letter capital
#' @description Capitalize the first letter of every new word. Very simplistic approach.
#' @param filebase The file path to the database (\code{.rdb} file), with no extension
#' @param key Keys to fetch
#' @return character vector with capitalized first letters
fetchRdDB <- function (filebase, key = NULL) {
  fun <- function(db) {
    vals <- db$vals
    vars <- db$vars
    datafile <- db$datafile
    compressed <- db$compressed
    envhook <- db$envhook
    fetch <- function(key) lazyLoadDBfetch(vals[key][[1L]], 
        datafile, compressed, envhook)
    if (length(key)) {
      if (!key %in% vars) 
        stop(gettextf("No help on %s found in RdDB %s", 
            sQuote(key), sQuote(filebase)), domain = NA)
      fetch(key)
    }
    else {
      res <- lapply(vars, fetch)
      names(res) <- vars
      res
    }
  }
  res <- lazyLoadDBexec(filebase, fun)
  if (length(key)) 
    res
  else invisible(res)
}

#' @title Trim
#' @description Trim whitespaces and newlines before and after
#' @param x String to trim
#' @return character vector with stripped whitespaces
trim <- function(x) {
  gsub("^\\s+|\\s+$", "", x)
}

