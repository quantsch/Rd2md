#' @export
#' @name parseRd
#' @title Parse an Rd object
#' @description This function will parse an Rd object returning a list with each section. The
#' contents of each element of the list will be converted to markdown.
#' @param rd An \code{Rd} object
#' @param link.ext file extension for links
#' @return a named list with the parts of the Rd object that will be used for creating
#' a markdown file
#' @examples 
#' ## rd source (from parse_Rd function of tools package)
#' rdfile = "~/git/MyPackage/man/myfun.Rd"
#' ## rd = tools::parse_Rd(rdfile)
#' ## parseRd(rd, "html")
parseRd <- function(rd, link.ext) {
	
	# VALIDATION
	if (!("Rd" %in% class(rd))) stop("Please provide Rd object to parse.")
	
	
	tags <- RdTags(rd)
	results <- list()
	
	if(!('\\name' %in% tags)) {
		return(results)
	}
	
	for(i in sections) {
		if(i %in% tags) {
			#Handle \argument section separately
			if(i == '\\arguments') {
				args <- rd[[which(tags == '\\arguments')]]
				args.tags <- RdTags(args)
				args <- args[which(args.tags == '\\item')]
				params <- character()
				for(i in seq_along(args)) {
					param.name <- as.character(args[[i]][[1]])
					param.desc <- paste(sapply(args[[i]][[2]], 
							FUN=function(x) { parseTag(x, link.ext=link.ext) }), collapse=' ')
					params <- c(params, param.desc)
					names(params)[length(params)] <- param.name
				}
				results$arguments <- params
			} else if (i %in% c('\\usage')) {
				results[['usage']] <- paste0("```r\n", 
						paste(sapply(rd[[which(tags == '\\usage')]], 
							   FUN=function(x) {
									if (x[1]=="\n") x[1]="" # exception handling
							   	parseTag(x, stripNewline=FALSE, stripWhite=FALSE, stripTab=FALSE, link.ext=link.ext)
							   }), collapse=''), 
					 "```\n")
			} else if(i %in% tags) {
				key <- substr(i, 2, nchar(i))
				results[[key]] <- paste(sapply(rd[[which(tags==i)[1]]], FUN=function(x) {
					parseTag(x, stripNewline=FALSE, link.ext=link.ext)
				} ), collapse=' ')
			}
		}
	}
	
	invisible(results)
}
