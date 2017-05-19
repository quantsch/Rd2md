#' Converts an Rd help file to markdown.
#' 
#' This function will convert an Rd file to markdown.
#' 
#' @param rd an Rd data object.
#' @param outfile Filepath to output file (markdown file)
#' @param knitrOptions options to pass to \code{knitr} for running the examples.
#' @return a character vector of length one where the element name is the topic
#'        name and the value is the filename.
Rd2markdown.rd <- function(rd, outfile, knitrOptions=c(message=FALSE, warning=FALSE, error=FALSE)) {
	file.ext='md'
	link.ext='html'
	front.matter = ""
	section="#"
	subsection="##"
	section.sep='\n\n'
	run.examples=FALSE
	simpleCap <- function(x) {
		s <- strsplit(x, " ")[[1]]
		paste(toupper(substring(s, 1,1)), substring(s, 2), sep="", collapse=" ")
	}
	
	
	if(length(section) == 1) {
		section <- c(section, '')
	}
	
	# rd = rddb[1]
	# results <- tools::parse_Rd(rd)
	results = parseRd(rd)
	

	if(all(c('name','title') %in% names(results))) {
		filename <- paste0(results$name, '.', file.ext)
		results$filename <- filename
		results$directory <- dirname(outfile)
		# outfile <- paste0(outdir, '/', filename)
		
		#Print the results to file
		if(!missing(front.matter)) {
			cat(front.matter, file=outfile, append=TRUE)
			cat(section.sep, file=outfile, append=TRUE)
		}
		
		cat(paste0(section[1], ' `', results$name, '`: ', 
				   results$title, ' ', section[2]), file=outfile, append=TRUE)
		cat(section.sep, file=outfile, append=TRUE)
		
		for(i in sections.print[!sections.print %in% c('name','title')]) {
			if(i %in% names(results)) {
				if(i == 'examples') {
					#TODO: Exclude don't run (\\dontrun)
					cat(paste(subsection[1], 'Examples', section[2]), 
						file=outfile, append=TRUE)
					cat(section.sep, file=outfile, append=TRUE)
					
				# EXAMPLES
				cat("```r", paste(results$examples, collapse='\n'), "```", file=outfile, append=TRUE)
				} else if(i %in% c('usage')) {
					cat(paste(subsection[1], simpleCap(i), section[2]), 
						file=outfile, append=TRUE)
					cat(section.sep, file=outfile, append=TRUE)
					cat(paste0(results[[i]]), file=outfile, append=TRUE)
					cat(section.sep, file=outfile, append=TRUE)	
				} else if (i %in% c("arguments")) {
					cat(paste(subsection[1], simpleCap(i)), file=outfile, append=TRUE)
					cat("\n\n\n", file=outfile, append=TRUE)
					cat("Argument      |Description\n", file=outfile, append=TRUE)
					cat("------------- |----------------\n", file=outfile, append=TRUE)
					cat(paste0("```", names(results[[i]]), "```", "     |     ", results[[i]], collapse="\n"), file=outfile, append=TRUE)
					cat(section.sep, file=outfile, append=TRUE)
					
				} else {
					cat(paste(subsection[1], simpleCap(i), section[2]), 
						file=outfile, append=TRUE)
					cat(section.sep, file=outfile, append=TRUE)
					cat(results[[i]], file=outfile, append=TRUE)
					cat(section.sep, file=outfile, append=TRUE)
				}
			}
		}
	} else {
		warning('name and title are required. Not creating markdown file')
	}
	
	invisible(results)
}
