#' Convert Rd help files to markdown.
#' 
#' Converts the help topics in the given package to markdown.
#' 
#' @references Murdoch, D. (2010). 
#'           \href{http://developer.r-project.org/parseRd.pdf}{Parsing Rd files}.
#' @param pkg the package to generate files for.
#' @param outfile Output file path
#' @param verbose if \code{TRUE}, print messages as parsing.
#' @param ... other parameters passed to \code{\link{Rd2markdown.rd}}
#' @seealso Rd2markdown.rd
#' @seealso Rd2HTML
#' @export
Rd2markdown <- function(pkg, outfile, verbose=TRUE) {
	#require(tools)
	
	public.only=TRUE
	data.topics=TRUE
	file.ext='md'
	link.ext='html'
	section.sep='\n\n'
	
	#topics.all <- names(tools:::fetchRdDB(file.path(find.package(pkg), "help", pkg)))
	rd_files = list.files(file.path(pkg, "man"), full.names = TRUE)
		topics <- gsub(".rd","",gsub(".Rd","",basename(rd_files)))
#		if(public.only) {
#			topics.data <- character()
#			if(data.topics) {
#				topics.data <- data(package=pkg)
#				topics.data <- topics.data$results[,'Item']
#			}
#			topics <- topics[topics %in% c(ls(paste0('package:', pkg)), topics.data)]
#		}
	# rddb <- tools::Rd_db(pkg, file.path(find.package(pkg), "help", pkg))
	results <- list()
	for(i in 1:length(topics)) {#i=1
		if(verbose) {
			message(paste0('Writing ', outfile, ' topic: ', topics[i], '\n'))
		}
		rd = tools::parse_Rd(rd_files[i])
		results[[i]] <- Rd2markdown.rd(rd=rd, outfile=outfile)
	}

#	if(!missing(outdir)) {
#		indexfile <- paste0(outdir, '/index.', file.ext)
#		if(!missing(front.matter)) {
#			#cat(front.matter, file=indexfile, append=TRUE)
#			cat(section.sep, file=indexfile, append=TRUE)
#		}
#		for(i in seq_along(results)) {
#			cat(paste0(' * [`', results[[i]]$name, '`](', 
#					   results[[i]]$name, '.', link.ext, ') ', 
#					   results[[i]]$title, '\n\n'), 
#				file=indexfile, append=TRUE)
#		}
#	}
#	
#	invisible(results)
}
