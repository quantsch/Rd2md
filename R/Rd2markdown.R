#' Convert Rd help files to markdown.
#' 
#' Converts the help topics in the given package to markdown.
#' 
#' @references Murdoch, D. (2010). 
#'           \href{http://developer.r-project.org/parseRd.pdf}{Parsing Rd files}.
#' @inheritParams Rd2markdown.rd
#' @param pkg the package to generate files for.
#' @param topics the topics to convert to markdown. If missing all topics will be converted.
#' @param public.only if \code{TRUE} and \code{topics} not specified, include 
#'        only exported functions as determined by \code{ls('package:PackageName')}.
#' @param data.topics if \code{TRUE}, include data help pages.
#' @param verbose if \code{TRUE}, print messages as parsing.
#' @param ... other parameters passed to \code{\link{Rd2markdown.rd}}
#' @seealso Rd2markdown.rd
#' @seealso Rd2HTML
#' @export
Rd2markdown <- function(pkg, 
						topics,
						outdir, 
						public.only=TRUE,
						data.topics=TRUE,
						file.ext='markdown',
						link.ext='html',
						section.sep='\n\n',
						front.matter,
						verbose=TRUE, ...) {
	require(tools)
	
	topics.all <- names(tools:::fetchRdDB(file.path(find.package(pkg), "help", pkg)))
	if(missing(topics)) {
		topics <- topics.all
		if(public.only) {
			topics.data <- character()
			if(data.topics) {
				topics.data <- data(package=pkg)
				topics.data <- topics.data$results[,'Item']
			}
			topics <- topics[topics %in% c(ls(paste0('package:', pkg)), topics.data)]
		}
	}
	rddb <- tools:::Rd_db(pkg, file.path(find.package(pkg), "help", pkg))
	results <- list()
	for(i in topics) {
		if(verbose) {
			message(paste0('Writing ', outdir, '/', i, '.', file.ext, '\n'))
		}
		results[[i]] <- Rd2markdown.rd(rddb[[which(topics.all == i)]], 
									   outdir=outdir,
									   file.ext=file.ext,
									   link.ext=link.ext,
									   front.matter=front.matter, 
									   section.sep=section.sep, ...)
	}

	if(!missing(outdir)) {
		indexfile <- paste0(outdir, '/index.', file.ext)
		if(!missing(front.matter)) {
			cat(front.matter, file=indexfile, append=FALSE)
			cat(section.sep, file=indexfile, append=TRUE)
		}
		for(i in seq_along(results)) {
			cat(paste0(' * [`', results[[i]]$name, '`](', 
					   results[[i]]$name, '.', link.ext, ') ', 
					   results[[i]]$title, '\n\n'), 
				file=indexfile, append=TRUE)
		}
	}
	
	invisible(results)
}
