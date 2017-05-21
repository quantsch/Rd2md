#' @export
#' @name Rd2markdown
#' @title Rd file to markdown
#' @description This function converts an Rd file into markdown format.
#' @param rd an Rd data object.
#' @param outfile Filepath to output file (markdown file)
#' @return character vector of length one where the element name is the topic
#' name and the value is the filename.
Rd2markdown <- function(rd, outfile, append=TRUE) {
	# Global definitions for file parsing
	file.ext <- "md"
	link.ext <- "html"
	section <- "#"
	subsection <- "##"
	section.sep <- "\n\n"
	run.examples <- FALSE
	
	simpleCap <- function(x) {
		s <- strsplit(x, " ")[[1]]
		paste(toupper(substring(s, 1,1)), substring(s, 2), sep="", collapse=" ")
	}
	
	# Parse rd file
	results <- parseRd(rd)
	
	if(all(c("name","title") %in% names(results))) {
		filename <- paste0(results$name, ".", file.ext)
		results$filename <- filename
		results$directory <- dirname(outfile)
		# outfile <- paste0(outdir, "/", filename)
		
		# INIT file if required
		cat("", file=outfile, append=append)
		

		cat(paste0(section, " `", results$name, "`: ", results$title), file=outfile, append=TRUE)
		cat(section.sep, file=outfile, append=TRUE)
		
		for(i in sections.print[!sections.print %in% c("name","title")]) {
			if(i %in% names(results)) {
				if(i == "examples") {
					cat(paste(subsection, "Examples"), file=outfile, append=TRUE)
					cat(section.sep, file=outfile, append=TRUE)
					
				# EXAMPLES
				cat("```r", paste(results$examples, collapse="\n"), "```", file=outfile, append=TRUE)
				} else if(i %in% c("usage")) {
					cat(paste(subsection, simpleCap(i)), file=outfile, append=TRUE)
					cat(section.sep, file=outfile, append=TRUE)
					cat(paste0(results[[i]]), file=outfile, append=TRUE)
					cat(section.sep, file=outfile, append=TRUE)	
				} else if (i %in% c("arguments")) {
					cat(paste(subsection, simpleCap(i)), file=outfile, append=TRUE)
					cat(section.sep, file=outfile, append=TRUE)
					# Prepare table with arguments
					cat("Argument      |Description\n", file=outfile, append=TRUE)
					cat("------------- |----------------\n", file=outfile, append=TRUE)
					cat(paste0("```", names(results[[i]]), "```", "     |     ", results[[i]], collapse="\n"), file=outfile, append=TRUE)
					cat(section.sep, file=outfile, append=TRUE)
					
				} else {
					cat(paste(subsection, simpleCap(i)), file=outfile, append=TRUE)
					cat(section.sep, file=outfile, append=TRUE)
					cat(results[[i]], file=outfile, append=TRUE)
					cat(section.sep, file=outfile, append=TRUE)
				}
			}
		}
	} else {
		warning("name and title are required. Not creating markdown file")
	}
	
	invisible(results)
}
