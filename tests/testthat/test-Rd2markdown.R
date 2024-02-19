test_that("Output file is correct", {
    input_file = "testdoc/fundoc.Rd"
    comp_file = "testdoc/fundoc.md"
    output_file = "testdoc/fundoc-out.md"

    Rd2markdown(input_file, outfile = output_file)

    test_output_value = as.character(tools::md5sum(output_file))
    test_expected_value = as.character(tools::md5sum(comp_file))
    expect_equal(
        !!test_output_value,
        !!test_expected_value
    )
})


# old stuff
install.packages("./", type="source",repos=NULL)
Rd2markdown(x, "testout.md")
Rd2md::ReferenceManual()

# new stuff

library(tidyverse)
source("R/figure.R")
source("R/as_rdfile.R")
source("R/as_rdsection.R")
source("R/as_markdown.R")
source("R/reference_manual.R")
source("R/utils.R")

path = "man/fetchRdDB.Rd"


rdfile <- read_rdfile(path)
#x=parsed_rd
cat(as_markdown(rdfile))

x <- parse_rd_file(path)

create_reference_manual(verbose=TRUE)

parsedrd <- rd_file(x)

# https://cran.r-project.org/web/packages/dplyr/dplyr.pdf
res <- as_markdown(parsedrd[[9]])
as_markdown(parsedrd[[1]])

cat(as_markdown(parsedrd))
as_markdown(parsedrd)


str(parsedrd[[9]])
traverse_list_classes(parsedrd)

# see how arguments are handled
as_markdown(parsedrd)
browser(as_markdown(parsedrd))

