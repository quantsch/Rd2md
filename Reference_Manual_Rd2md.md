<!-- toc -->

February 19, 2024

# DESCRIPTION

```
Package: Rd2md
Title: Markdown Reference Manuals
Version: 0.0.5
Authors@R: person("Julian", "Busch", email = "jb@quants.ch", role = c("aut", "cre"))
Description: The native R functionalities only allow PDF exports of reference manuals. This shall be extended by converting the package documentation files into markdown files and combining them into a markdown version of the package reference manual.
Depends:
    R (>= 3.6)
Imports:
	knitr,
	tools
Suggests:
	testthat,
    rmarkdown,
    devtools
License: GPL
Encoding: UTF-8
LazyData: true
VignetteBuilder: knitr
RoxygenNote: 7.3.1
```


# `fetchRdDB`

<p>Capitalize the first letter of every new word. Very simplistic approach.</p>

## Usage

<p>fetchRdDB(filebase, key = NULL)</p>

## Arguments

<p>&lt;dl&gt;&lt;dt&gt;filebase&lt;/dt&gt;
&lt;dd&gt;&lt;p&gt;The file path to the database (&lt;code&gt;.rdb&lt;/code&gt; file), with no extension&lt;/p&gt;&lt;/dd&gt;&lt;dt&gt;key&lt;/dt&gt;
&lt;dd&gt;&lt;p&gt;Keys to fetch&lt;/p&gt;&lt;/dd&gt;&lt;/dl&gt;</p>

## Title

<p>Make first letter capital</p>

## Value

<p>&lt;p&gt;character vector with capitalized first letters&lt;/p&gt;</p>

# `Rd2markdown-package`

<p>Functions to parse and convert Rd files to markdown.</p>

## Title

<p>Convert Rd help files to markdown.</p>

## Author

<p>Jason Bryer <a href='mailto:jason@bryer.org'>jason@bryer.org</a></p>

## See also

<p><code>knitr</code></p>

# `Rd2md-package`

<p>Functions to parse and convert Rd files to markdown format reference manual.</p>

## Title

<p>Reference Manual in Markdown</p>

## See also

<p><code>knitr</code></p>

## Author

<p>Julian Busch &lt;jb@quants.ch&gt;</p>

# `rd2md`

<p>Translate an Rd string to its HTML output</p>

## Usage

<p>rd2md(x, fragment = TRUE, ...)</p>

## Arguments

<p>&lt;dl&gt;&lt;dt&gt;x&lt;/dt&gt;
&lt;dd&gt;&lt;p&gt;Rd string. Backslashes must be double-escaped ("\\").&lt;/p&gt;&lt;/dd&gt;&lt;dt&gt;fragment&lt;/dt&gt;
&lt;dd&gt;&lt;p&gt;logical indicating whether this represents a complete Rd file&lt;/p&gt;&lt;/dd&gt;&lt;dt&gt;...&lt;/dt&gt;
&lt;dd&gt;&lt;p&gt;additional arguments for as_markdown&lt;/p&gt;&lt;/dd&gt;&lt;/dl&gt;</p>

## Title

<p>Translate an Rd string to its HTML output</p>

# `RdTags`

<p>Extract Rd tags from Rd object</p>

## Usage

<p>RdTags(Rd)</p>

## Arguments

<p>&lt;dl&gt;&lt;dt&gt;Rd&lt;/dt&gt;
&lt;dd&gt;&lt;p&gt;Object of class &lt;code&gt;Rd&lt;/code&gt;&lt;/p&gt;&lt;/dd&gt;&lt;/dl&gt;</p>

## Title

<p>Extract Rd tags</p>

## Value

<p>&lt;p&gt;character vector with Rd tags&lt;/p&gt;</p>

# `ReferenceManual`

<p>This is a wrapper to combine the Rd files
of a package source or binary into a reference manual in markdown format.</p>

## Usage

<p>create_reference_manual(
  pkg = getwd(),
  outdir = getwd(),
  front_matter = "",
  toc_matter = "&lt;!-- toc --&gt;",
  date_format = "%B %d, %Y",
  verbose = FALSE
)</p>

## Arguments

<p>&lt;dl&gt;&lt;dt&gt;pkg&lt;/dt&gt;
&lt;dd&gt;&lt;p&gt;Full path to package directory.
Default value is the working directory.
Alternatively, a package name can be passed. If this is the case,
&lt;code&gt;&lt;a href='https://rdrr.io/r/base/find.package.html'&gt;find.package&lt;/a&gt;&lt;/code&gt; is applied.&lt;/p&gt;&lt;/dd&gt;&lt;dt&gt;outdir&lt;/dt&gt;
&lt;dd&gt;&lt;p&gt;Output directory where the reference manual
markdown shall be written to.&lt;/p&gt;&lt;/dd&gt;&lt;dt&gt;front_matter&lt;/dt&gt;
&lt;dd&gt;&lt;p&gt;String with yaml-style heading of markdown file.&lt;/p&gt;&lt;/dd&gt;&lt;dt&gt;toc_matter&lt;/dt&gt;
&lt;dd&gt;&lt;p&gt;String providing the table of contents.
This is not auto-generated.
The default value is a HTML comment, used by gitbook plugin
&lt;a href='https://www.npmjs.com/package/gitbook-plugin-toc'&gt;toc&lt;/a&gt;.&lt;/p&gt;&lt;/dd&gt;&lt;dt&gt;date_format&lt;/dt&gt;
&lt;dd&gt;&lt;p&gt;Date format that shall be written to the
beginning of the reference manual.
If &lt;code&gt;NULL&lt;/code&gt;, no date is written.
Otherwise, provide a valid format (e.g. &lt;code&gt;%Y-%m-%d&lt;/code&gt;),
see Details in &lt;a href='https://rdrr.io/r/base/strptime.html'&gt;strptime&lt;/a&gt;.&lt;/p&gt;&lt;/dd&gt;&lt;dt&gt;verbose&lt;/dt&gt;
&lt;dd&gt;&lt;p&gt;If &lt;code&gt;TRUE&lt;/code&gt; all messages and process steps will be printed&lt;/p&gt;&lt;/dd&gt;&lt;/dl&gt;</p>

## Title

<p>Create Reference Manual Markdown</p>

## References

<p>Murdoch, D. (2010).
<a href='https://developer.R-project.org/parseRd.pdf'>Parsing Rd files</a></p>

## See also

<p>Package
<a href='https://github.com/jbryer/Rd2markdown'>Rd2markdown</a> by jbryer</p>

# `simpleCap`

<p>Capitalize the first letter of every new word. Very simplistic approach.</p>

## Usage

<p>simpleCap(x)</p>

## Arguments

<p>&lt;dl&gt;&lt;dt&gt;x&lt;/dt&gt;
&lt;dd&gt;&lt;p&gt;Character string&lt;/p&gt;&lt;/dd&gt;&lt;/dl&gt;</p>

## Title

<p>Make first letter capital</p>

## Value

<p>&lt;p&gt;character vector with capitalized first letters&lt;/p&gt;</p>

# `stripWhite`

<p>Strip white space (spaces only) from the beginning and end of a character.</p>

## Usage

<p>stripWhite(x)</p>

## Arguments

<p>&lt;dl&gt;&lt;dt&gt;x&lt;/dt&gt;
&lt;dd&gt;&lt;p&gt;character to strip white space from&lt;/p&gt;&lt;/dd&gt;&lt;/dl&gt;</p>

## Title

<p>Strip white space</p>

## Value

<p>&lt;p&gt;a character with white space stripped&lt;/p&gt;</p>

# `trim`

<p>Trim whitespaces and newlines before and after</p>

## Usage

<p>trim(x)</p>

## Arguments

<p>&lt;dl&gt;&lt;dt&gt;x&lt;/dt&gt;
&lt;dd&gt;&lt;p&gt;String to trim&lt;/p&gt;&lt;/dd&gt;&lt;/dl&gt;</p>

## Title

<p>Trim</p>

## Value

<p>&lt;p&gt;character vector with stripped whitespaces&lt;/p&gt;</p>

