#' @name parseTag
#' @title Tag from Rd Format to Markdown
#' @description This function will convert an Rd element to markdown format. 
#' @param x element from an \code{Rd} class.
#' @param pre a string to prepend to the parsed tag
#' @param post a string to append to the parsed tag
#' @param stripNewline logical indicating whether to strip new line characters
#' @param stripWhite logical indicating whether to strip white space
#' @param stripTab logical indicating whether to strip tab characters
#' @param link.ext file extention to use for links
parseTag <- function(x
							, pre=character()
							, post=character()
							, stripNewline=TRUE
							, stripWhite=TRUE
							, stripTab=TRUE
							, link.ext="html") {
	
	rdtag <- attr(x, "Rd_tag")
	if(is.null(rdtag) || rdtag %in% c("TEXT", "RCODE", "VERB")) {
		x <- paste0(pre, as.character(x), post)
		if(stripTab) { x <- gsub("\t", "", x)}
		if(stripNewline) { x <- gsub("\n", "", x) }
		if(stripWhite) { x <- stripWhite(x) }
	} else if(rdtag == "\\code") {
		pre <- c("`", pre)
		post <- c(post, "`")
		x <- parseTag(x[[1]], pre, post)
	} else if(rdtag == "\\eqn") {
		# message(paste0("Equation used, be sure to include MathJax."))
		pre <- c("$", pre)
		post <- c(post, "$")
		x <- paste0(parseTag(x[[1]], pre, post, stripWhite=TRUE, 
							 stripNewline=TRUE, stripTab=TRUE), collapse="")
	} else if(rdtag == "\\deqn") {
		message(paste0("Equation used, be sure to include MathJax."))
		pre <- c("\n$$", pre)
		post <- c(post, "$$\n")
		x <- paste0("\n$$", paste0(parseTag(x[[1]]), collapse=""), "$$\n")
	} else if(rdtag == "\\link") {
		if(attr(x[[1]], "Rd_tag") != "TEXT") { 
			warning("\\link is not the inner most tag. All other nested tags will be ignored.")
		}
		x <- paste("[", pre, parseTag(x[[1]], stripNewline=stripNewline), post, "](", 
				   parseTag(x[[1]], stripNewline=stripNewline), ".", link.ext,")", sep="")
	} else if(rdtag == "\\url") {
		x <- paste0("[", pre, as.character(x), post, "](", as.character(x), ")")
	} else if(rdtag == "\\href") {
		x <- paste0("[", as.character(x[[2]]), "](", as.character(x[[1]]), ")")
	} else if(rdtag == "\\item") {
		x <- "\n\n* "
	} else if(rdtag == "\\itemize") {
		x <- paste(sapply(x, parseTag), collapse=" ")
	} else if(rdtag == "\\enumerate") {
		warning("enumerate not currently supported. Items will be bulleted instead.")
		x <- paste(sapply(x, parseTag), collapse=" ")
	}
	
	return(x)
}
