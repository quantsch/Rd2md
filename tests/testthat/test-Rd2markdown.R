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
load_pkg <- sapply(
  list.files("R", full.names = TRUE),
  source
)

path = "man/fetchRdDB.Rd"


create_reference_manual()
