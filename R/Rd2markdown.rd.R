#' Converts an Rd help file to markdown.
#' 
#' This function will convert an Rd file to markdown.
#' 
#' @param rd an Rd data object.
#' @param outdir directory to output the markdown file and any support files 
#'        (e.g. figures). If missing, just the parsed results will be returned.
#' @param file.ext file extension of the output file.
#' @param link.ext file extension of linked files.
#' @param front.matter text to include at the top of the file.
#' @param section characters to surround section headings.
#' @param section.sep character to print between sections.
#' @param run.examples logical indicating whether to run the examples.
#' @param knitrOptions options to pass to \code{knitr} for running the examples.
#' @return a character vector of length one where the element name is the topic
#'        name and the value is the filename.
Rd2markdown.rd <- function(rd, 
						   outdir, 
						   file.ext='markdown',
						   link.ext='html',
						   front.matter,
						   section=c('####', '####'),
						   section.sep='\n\n',
						   run.examples=TRUE,
						   knitrOptions=c(message=FALSE, warning=FALSE, error=FALSE)
) {
	simpleCap <- function(x) {
		s <- strsplit(x, " ")[[1]]
		paste(toupper(substring(s, 1,1)), substring(s, 2), sep="", collapse=" ")
	}
	
	if(run.examples & !require(knitr)) {
		run.examples=FALSE
		warning('knitr is not avaialbe. Examples will not be executed!')
	}
	
	if(length(section) == 1) {
		section <- c(section, '')
	}
	
	results <- parseRd(rd, link.ext=link.ext)
	
	if(!missing(outdir)) {
		if(all(c('name','title') %in% names(results))) {
			filename <- paste0(results$name, '.', file.ext)
			results$filename <- filename
			results$directory <- outdir
			outfile <- paste0(outdir, '/', filename)
			
			#Print the results to file
			if(!missing(front.matter)) {
				cat(front.matter, file=outfile, append=FALSE)
				cat(section.sep, file=outfile, append=TRUE)
			}
			
			cat(paste0(section[1], ' `', results$name, '`: ', 
					   results$title, ' ', section[2]), file=outfile, append=TRUE)
			cat(section.sep, file=outfile, append=TRUE)
			
			for(i in sections.print[!sections.print %in% c('name','title')]) {
				if(i %in% names(results)) {
					if(i == 'examples') {
						#TODO: Exclude don't run (\\dontrun)
						cat(paste(section[1], 'Examples', section[2]), 
							file=outfile, append=TRUE)
						cat(section.sep, file=outfile, append=TRUE)
						
						if(run.examples) {
							opts_knit$set(progress=FALSE, 
										  verbose=FALSE, 
										  out.format='markdown')
							render_markdown(strict=TRUE)
							ex <- paste0("```{r ", results$name, "-example, fig.path='", outdir, "', ",
										 paste(names(knitrOptions), knitrOptions, 
										 	  sep='=', collapse=', '), '}'
							)
							for(i in seq_along(results$examples)) {
								ex <- c(ex, results$examples[i])
							}
							ex <- c(ex, '```')
							exfile <- tempfile()
							knit(output=exfile, text=ex)
							exout <- readLines(exfile)
							exout <- gsub(outdir, '', exout)
							cat(paste(exout, collapse='\n'), file=outfile, append=TRUE)
							unlink(exfile)
						} else {
							cat(paste('\n    ', results$examples, collapse=''), 
								file=outfile, append=TRUE)
						}
					} else if(i %in% c('usage')) {
						cat(paste(section[1], simpleCap(i), section[2]), 
							file=outfile, append=TRUE)
						cat(section.sep, file=outfile, append=TRUE)
						cat(paste0(results[[i]]), file=outfile, append=TRUE)
						cat(section.sep, file=outfile, append=TRUE)					
					} else {
						cat(paste(section[1], simpleCap(i), section[2]), 
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
	}
	
	invisible(results)
}
