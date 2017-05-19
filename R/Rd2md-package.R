#' Functions to parse and convert Rd files to markdown.
#' 
#' 
#' 
#' @name Rd2md-package
#' @docType package
#' @title Convert Rd help files to markdown.
#' @author Julian Busch, copied from Jason Bryer \email{jason@@bryer.org}
#' @keywords Rd help markdown
#' @seealso \code{knitr}
#' @import tools
#' @import knitr
NA

sections <- c('\\arguments', '\\author', '\\concept', '\\description',
			  '\\details', '\\docType', '\\encoding', '\\format', '\\keyword', '\\name',
			  '\\note', '\\references', '\\section', '\\seealso', '\\source', '\\title',
			  '\\value', '\\examples', '\\usage', '\\alias', '\\Rdversion', '\\synopsis',
			  '\\Sexpr', '\\RdOpts' )

sections.print <- c('name', 'title', 'description', 'format', 'usage', 'arguments', 
					'details', 'value', 'seealso', 'note', 'author', 
					'references', 'examples')

markups.latex <- c('\\acronym', '\\bold', '\\cite', '\\command', '\\dfn',
				   '\\dQuote', '\\email', '\\emph', '\\file', '\\item', '\\linkS4class',
				   '\\pkg', '\\sQuote', '\\strong', '\\var', '\\describe', '\\enumerate',
				   '\\itemize', '\\enc', '\\if', '\\ifelse', '\\method', '\\S3method',
				   '\\S4method', '\\tabular', '\\subsection', '\\link', '\\href' )

markups.r <- c('\\cr', '\\dots', '\\ldots', '\\R', '\\tab', '\\code', '\\dontshow',
			   '\\donttest', '\\testonly', '\\dontrun', '\\env', '\\kbd', '\\option',
			   '\\out', '\\preformatted', '\\samp', '\\special', '\\url', '\\verb',
			   '\\deqn', '\\eqn', '\\newcommand', '\\renewcommand')
