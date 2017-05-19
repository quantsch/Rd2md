# Reference Manual To PDF

The Reference Manual of a package exported as PDF is an R command shipped with R.

```
R CMD Rd2pdf
```

However, pdf versions are quite static and nothing can really be done with it. 

The single .Rd files are quite flexible and can be converted to .md files. 

This fact is used to replicate a Reference Manual in markdown format.

# Reference Manual To Markdown

The main function is 

```{r, eval=FALSE}
ReferenceManual(pkg_, outdir_ = getwd())
```

For the `pkg_` variable, provide the full **file path** of the source code of the package.
