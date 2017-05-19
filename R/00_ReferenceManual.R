# Wrapper function to the process of creating the markdown reference manual
# 
# Author: jbusch
###############################################################################

#' @export
#' @name ReferenceManual
#' @title Create Reference Manual Markdown
#' @description This is a wrapper for a slightly amended version of package Rd2markdown by 
#' [jbryer]('https://github.com/jbryer/Rd2markdown').
#' It takes slightly amended versions of the available functions, so that the manuals are
#' taken from source instead of from the libraries. 
#' The result is the reference manual in markdown format.
#' @param pkg Full path to package directory. Default value is the working directory
#' @param outdir Output directory where the reference manual markdown shall be written to
#' @param verbose If \code{TRUE} all messages and process steps will be printed.
ReferenceManual <- function(pkg = getwd(), outdir = getwd(), verbose=FALSE) {
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
	
	
	# Description file
	cat("# DESCRIPTION", file=man_file, append=TRUE)
	cat("\n\n", file=man_file, append=TRUE)
	cat("```\n", file=man_file, append=TRUE)
	DESCRIPTION = readLines(file.path(pkg_path, "DESCRIPTION"))
	cat(paste0(DESCRIPTION, collapse="\n"), file=man_file, append=TRUE)
	cat("```\n", file=man_file, append=TRUE)
	cat("\n\n", file=man_file, append=TRUE)
	
	# Add all functions of package
	Rd2markdown(pkg=pkg_path, outfile=man_file, verbose=verbose)
	
}