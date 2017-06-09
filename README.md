[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/Rd2md)](https://cran.r-project.org/package=Rd2md)


# Installation

To install the `Rd2md` package, you can either use the official CRAN repository or install directly from github.

From CRAN:

```r
install.packages("Rd2md")
```

From Github:
```
## if not already installed:
# install.packages("devtools") 
library(devtools)
install_github("quants-ch/Rd2md")
```

# Reference Manual To PDF

The Reference Manual of a package exported as PDF is an R command shipped with R.

```
R CMD Rd2pdf
```

However, pdf versions are quite static and nothing can really be done with it. 

The single .Rd files are well structured and can easily parsed to .md files. Thanks to [jbryer](https://github.com/jbryer/Rd2markdown) to publish the relevant code.

This fact is used to replicate a Reference Manual in markdown format.

# Reference Manual To Markdown

There main function to create the reference manual in markdown format is

```r
ReferenceManual(pkg, outdir = getwd(), verbose=FALSE)
```

For the `pkg` variable, provide the full **file path** of the source code of
the package or the path to the binary directory (e.g. library path like
`\\usr\\local\\lib\\R\\site-library\\Rd2md`).

If you read from a binary file, please specify `type="bin"`.