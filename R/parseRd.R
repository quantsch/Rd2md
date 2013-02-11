#' Parse an Rd object.
#' 
#' This function will parse an Rd object returning a list with each section. The
#' contents of each element of the list will be converted to markdown.
#' 
#' @param rd and Rd object.
#' @param link.ext file extension for links.
#' @return a list with the parts of the Rd object that will be used for creating
#'        an markdown file.
#' @export
parseRd <- function(rd, link.ext) {
	tags <- tools:::RdTags(rd)
	results <- list()
	
	if(!('\\name' %in% tags)) {
		return(results)
	}
	
	for(i in sections) {
		if(i %in% tags) {
			#Handle \argument section separately
			if(i == '\\arguments') {
				args <- rd[[which(tags == '\\arguments')]]
				args.tags <- tools:::RdTags(args)
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
			} else if(i %in% c('\\usage')) {
				results[['usage']] <- paste('    ', sapply(rd[[which(tags == '\\usage')]], 
						   FUN=function(x) {
						   parseTag(x, stripNewline=FALSE, link.ext=link.ext)
						   }), collapse='')
			} else if(i %in% tags) {
				key <- substr(i, 2, nchar(i))
				results[[key]] <- paste(sapply(rd[[which(tags==i)]], FUN=function(x) {
					parseTag(x, stripNewline=FALSE, link.ext=link.ext)
				} ), collapse=' ')
			}
		}
	}
	
	invisible(results)
}
