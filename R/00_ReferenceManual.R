# Wrapper function to the process of creating the markdown reference manual
# 
# Author: jbusch
###############################################################################

#' @export
#' @name ReferenceManual
#' @title Create Reference Manual Markdown
#' @description This is a wrapper for a slightly
#' amended version of package Rd2markdown by jbryer (Github).
#' It takes the available functions and puts all into one document - the reference manual.
#' @param pkg_ Package name or path to directory
#' @param outdir_ output dir where the reference manual markdown shall be written to
#' @param verbose_ IF \code{TRUE} all messages and steps will be printed.
ReferenceManual = function(pkg_, outdir_ = getwd(), verbose_=FALSE) {
	# VALIDATION
	pkg = as.character(pkg_)
	if (length(pkg) != 1) stop("Please provide only one package at a time.")
	pkg_is_path = grepl("/|[\\]",pkg)
	if (pkg_is_path) if (!dir.exists(pkg)) stop("Package path does not exist.")
	outdir = as.character(outdir_)
	if (length(outdir) != 1) stop("Please provide only one outdir at a time.")
	if (!dir.exists(outdir)) stop("Output directory path does not exist.")
	verbose = as.logical(verbose_)
	
	pkg_name = ifelse(pkg_is_path, basename(pkg), pkg)
	pkg_path = ifelse(pkg_is_path, pkg, {
			pkgs_available = list.files(.libPaths()[1], full.names=TRUE)
			pkg_n = grep(pkg_name, basename(pkgs_available))[1]
			pkgs_available[pkg_n]
		})
	
	man_title = paste0("# Reference Manual ", pkg_name)
	
	# Output file for reference manual
	man_file = file.path(outdir, paste0("Reference_Manual_", pkg_name, ".md"))
	
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