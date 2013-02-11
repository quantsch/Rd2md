#' Strip white space.
#' 
#' Strip white space (spaces only) from the beginning and end of a character.
#' 
#' @param x character to strip white space from. 
#' @return a character with white space stripped.
stripWhite <- function(x) {
	sub('([ ]+$)', '', sub("(^[ ]+)", '', x, perl=TRUE), perl=TRUE)
}

