#' @export
#' @name ReferenceManual
#' @title Create Reference Manual Markdown
#' @description This is a wrapper to combine the Rd files of a package source or binary 
#' into a reference manual in markdown format.
#' @param pkg Full path to package directory. Default value is the working directory. 
#' Alternatively, a package name can be passed. If this is the case, \code{\link[base]{find.package}} is applied.
#' @param outdir Output directory where the reference manual markdown shall be written to.
#' @param front.matter String with yaml-style heading of markdown file.
#' @param toc.matter String providing the table of contents. This is not auto-generated.
#' The default value is a HTML comment, used by gitbook plugin
#' \href{https://www.npmjs.com/package/gitbook-plugin-toc}{toc}.
#' @param date.format Date format that shall be written to the beginning of the reference manual. 
#' If \code{NULL}, no date is written.
#' Otherwise, provide a valid format (e.g. \code{\%Y-\%m-\%d}), see Details in \link[base]{strptime}.
#' @param verbose If \code{TRUE} all messages and process steps will be printed
#' @references Murdoch, D. (2010). \href{https://developer.R-project.org/parseRd.pdf}{Parsing Rd files}
#' @seealso Package \href{https://github.com/jbryer/Rd2markdown}{Rd2markdown} by jbryer
#' @examples 
#' ## give source directory of your package
#' pkg_dir = "~/git/MyPackage"
#' 
#' ## specify, where reference manual shall be stored
#' out_dir = "/var/www/html/R_Web_app/md/"
#' 
#' ## create reference manual
#' ## ReferenceManual(pkg = pkg_dir, outdir = out_dir)
ReferenceManual <- function(pkg = getwd(), outdir = getwd()
					, front.matter = ""
					, toc.matter = "<!-- toc -->"
					, date.format = "%B %d, %Y"
					, verbose = FALSE) {
	# VALIDATION
	pkg <- as.character(pkg)
	if (length(pkg) != 1) stop("Please provide only one package at a time.")
	outdir <- as.character(outdir)
	if (length(outdir) != 1) stop("Please provide only one outdir at a time.")
	if (!dir.exists(outdir)) stop("Output directory path does not exist.")
	verbose <- as.logical(verbose)
	
	# locate package
	pkg_path <- path.expand(pkg)
	pkg_name <- basename(pkg_path)
	type <- "src"
	mandir <- "man"
	if (!dir.exists(pkg_path)) {
		pkg_path <- find.package(pkg_name)
		type <- "bin"
		mandir <- "help"
	} 	

	if (length(mandir ) != 1) stop("Please provide only one manuals directory.")
	if (!dir.exists(file.path(pkg_path, mandir))) stop("Package manuals path does not exist. Check working directory or given pkg and manuals path!")
	
	# PARAMS
	section.sep <- "\n\n"
	
	# Output file for reference manual
	man_file <- file.path(outdir, paste0("Reference_Manual_", pkg_name, ".md"))
	
	# INIT REFERENCE MANUAL .md
	cat(front.matter, file=man_file, append=FALSE) # yaml
	if (trim(front.matter)!="") cat(section.sep, file=man_file, append=TRUE)
	
	# Table of contents
	cat(toc.matter, file=man_file, append=TRUE)
	if (trim(toc.matter)!="") cat(section.sep, file=man_file, append=TRUE)
	
	# Date
	if (!is.null(date.format)) {
		cat(format(Sys.Date(), date.format), file=man_file, append=TRUE)
		cat(section.sep, file=man_file, append=TRUE)
	}
	
	
	
	# DESCRIPTION file
	cat("# DESCRIPTION", file=man_file, append=TRUE)
	cat(section.sep, file=man_file, append=TRUE)
	cat("```\n", file=man_file, append=TRUE)
	DESCRIPTION = readLines(file.path(pkg_path, "DESCRIPTION"))
	cat(paste0(DESCRIPTION, collapse="\n"), file=man_file, append=TRUE)
	cat("```\n", file=man_file, append=TRUE)
	cat(section.sep, file=man_file, append=TRUE)
	
	# RD files
	results <- list()

	# Get file list of rd files
	if (type == "src") {
		rd_files <- list.files(file.path(pkg_path, mandir), full.names = TRUE)
		topics <- gsub(".rd","",gsub(".Rd","",basename(rd_files)))
	} else {
		rd_files <- fetchRdDB(file.path(pkg_path, mandir, pkg_name))
		topics <- names(rd_files)
	}
	
	# Parse rd files and add to ReferenceManual
	for(i in 1:length(topics)) {#i=1
		if(verbose) message(paste0("Writing topic: ", topics[i], "\n"))
		results[[i]] <- Rd2markdown(rdfile=rd_files[i], outfile=man_file, append=TRUE)
	}
	
	invisible(man_file)
	
}