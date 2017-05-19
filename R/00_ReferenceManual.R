# Wrapper function to the process of creating the markdown reference manual
# 
# Author: jbusch
###############################################################################

#' @export
#' @name ReferenceManual
#' @title Create Reference Manual Markdown
#' @description This is a wrapper for a slightly amended version of package Rd2markdown by 
#' \href{https://github.com/jbryer/Rd2markdown}{jbryer}.
#' It takes slightly amended versions of the available functions, so that the manuals are
#' taken from source instead of from the libraries. 
#' The result is the reference manual in markdown format.
#' @param pkg Full path to package directory. Default value is the working directory
#' @param outdir Output directory where the reference manual markdown shall be written to
#' @param verbose If \code{TRUE} all messages and process steps will be printed.
#' @references Murdoch, D. (2010). \href{http://developer.r-project.org/parseRd.pdf}{Parsing Rd files}
ReferenceManual <- function(pkg = getwd(), outdir = getwd(), verbose = FALSE) {
	# VALIDATION
	pkg <- as.character(pkg)
	if (length(pkg) != 1) stop("Please provide only one package at a time.")
	outdir <- as.character(outdir)
	if (length(outdir) != 1) stop("Please provide only one outdir at a time.")
	if (!dir.exists(outdir)) stop("Output directory path does not exist.")
	verbose <- as.logical(verbose)
	
	pkg_path <- path.expand(pkg)
	pkg_name <- basename(pkg_path)
	if (!dir.exists(pkg_path)) stop("Package path does not exist.")
	
	# Output file for reference manual
	man_file <- file.path(outdir, paste0("Reference_Manual_", pkg_name, ".md"))
	
	# INIT REFERENCE MANUAL .md
	cat("<!-- toc -->", file=man_file, append=FALSE)
	cat("\n\n", file=man_file, append=TRUE)
	# Date
	cat(format(Sys.Date(), "%B %d, %Y"), file=man_file, append=TRUE)
	cat("\n\n", file=man_file, append=TRUE)
	
	
	# DESCRIPTION file
	cat("# DESCRIPTION", file=man_file, append=TRUE)
	cat("\n\n", file=man_file, append=TRUE)
	cat("```\n", file=man_file, append=TRUE)
	DESCRIPTION = readLines(file.path(pkg_path, "DESCRIPTION"))
	cat(paste0(DESCRIPTION, collapse="\n"), file=man_file, append=TRUE)
	cat("```\n", file=man_file, append=TRUE)
	cat("\n\n", file=man_file, append=TRUE)
	
	# RD files
	# Get file list of rd files
	rd_files <- list.files(file.path(pkg_path, "man"), full.names = TRUE)
	topics <- gsub(".rd","",gsub(".Rd","",basename(rd_files)))
	
	# Parse rd files and add to ReferenceManual
	results <- list()
	for(i in 1:length(topics)) {#i=1
		if(verbose) message(paste0("Writing topic: ", topics[i], "\n"))
		rd <- parse_Rd(rd_files[i])
		results[[i]] <- Rd2markdown(rd=rd, outfile=man_file)
	}
	
}