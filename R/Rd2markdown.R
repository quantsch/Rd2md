#' @name Rd2markdown
#' @title Convert Rd help files to markdown
#' @description Converts the help topics in the given package to markdown.
#' @references Murdoch, D. (2010). 
#'           \href{http://developer.r-project.org/parseRd.pdf}{Parsing Rd files}.
#' @param pkg the package to generate files for.
#' @param outfile Output file path
#' @param verbose if \code{TRUE}, print messages as parsing.
#' @seealso Rd2markdown.rd
Rd2markdown <- function(pkg, outfile, verbose=FALSE) {
	
	# Get file list of rd files
	rd_files <- list.files(file.path(pkg, "man"), full.names = TRUE)
	topics <- gsub(".rd","",gsub(".Rd","",basename(rd_files)))

	# Parse rd files and add to ReferenceManual
	results <- list()
	for(i in 1:length(topics)) {#i=1
		if(verbose) message(paste0("Writing topic: ", topics[i], "\n"))
		rd <- parse_Rd(rd_files[i])
		results[[i]] <- Rd2markdown.rd(rd=rd, outfile=outfile)
	}

	invisible(results)
}
