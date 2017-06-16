#' @export
#' @name Rd2markdown
#' @title Rd file to markdown
#' @description This function converts an Rd file into markdown format.
#' @param rdfile Filepath to an .Rd file or an \code{Rd} object to parse.
#' @param outfile Filepath to output file (markdown file).
#' @param append If outfile exists, append to existing content.
#' @return Parsed Rd as named list
#' @examples 
#' ## give a markdown source file
#' rdfile = "~/git/MyPackage/man/myfun.Rd"
#' ## specify, where markdown shall be stored
#' outfile = "/var/www/html/R_Web_app/md/myfun.md"
#' ## create markdown
#' ## Rd2markdown(rdfile = rdfile, outfile = outfile)
Rd2markdown <- function(rdfile, outfile, append=FALSE) {
	# VALIDATION
	append = as.logical(append)
	if (length(append) != 1) stop("Please provide append as single logical value.")
	if (is.character(rdfile)) if ((length(rdfile) != 1)) stop("Please provide rdfile as single character value (file path with extension).")
	outfile = as.character(outfile)
	if (length(outfile) != 1) stop("Please provide outfile as single character value (file path with extension).")
	if (append) {
		if (!file.exists(outfile)) stop("If append=TRUE, the outfile must exists already.")
	}
	type = ifelse(inherits(rdfile, "Rd"), "bin", "src")
	
	# Global definitions for file parsing
	file.ext <- "md"
	section <- "#"
	subsection <- "##"
	section.sep <- "\n\n"
	run.examples <- FALSE
	
	
	# Parse rd file
	if (type == "src") {
		rd <- parse_Rd(rdfile)
	} else {
		if (inherits(rdfile, "list"))  {
			rdfile = rdfile[[1]]
		}
		rd <- rdfile
		class(rd) <- "Rd"
	}
	# takes as input an "Rd" object
	results <- parseRd(rd)
	
	if (all(c("name","title") %in% names(results))) {
		filename <- paste0(results$name, ".", file.ext)
		results$filename <- filename
		results$directory <- dirname(outfile)
		
		# INIT file if required
		cat("", file=outfile, append=append)
		
		# HEADING
		cat(paste0(section, " `", results$name, "`"), file=outfile, append=TRUE)
		cat(section.sep, file=outfile, append=TRUE)
		# title as normal text
		cat(results$title, file=outfile, append=TRUE)
		cat(section.sep, file=outfile, append=TRUE)
		
		for (i in sections.print[!sections.print %in% c("name","title")]) {
			if (i %in% names(results)) {
				if (i == "examples") {
					cat(paste(subsection, "Examples"), file=outfile, append=TRUE)
					cat(section.sep, file=outfile, append=TRUE)
					
				# EXAMPLES
				cat("```r", paste(results$examples, collapse="\n"), "```", "\n\n", file=outfile, append=TRUE)
				} else if (i %in% c("usage")) {
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
					cat(paste0("`", names(results[[i]]), "`", "     |     ", results[[i]], collapse="\n"), file=outfile, append=TRUE)
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
