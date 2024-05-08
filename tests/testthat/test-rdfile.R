test_that("Output file of function is correct", {
  input_file <- "testdoc/man/fundoc.Rd"
  comp_file <- "testdoc-md/fundoc.md"

  test_output_value <- as_markdown(
    read_rdfile(
      path = input_file,
      subclass = "refman_rdfile"
    )
  )
  test_expected_value <- read_file(comp_file, collapse = "\n")
  expect_equal(
    test_output_value,
    test_expected_value
  )
})

test_that("System user-defined macros are handled correctly", {
  input_file <- "testdoc/man/fundoc_with_ud_macro.Rd"
  comp_file <- "testdoc-md/fundoc_with_ud_macro.md"

  test_output_value <- as_markdown(
    read_rdfile(
      path = input_file,
      subclass = "refman_rdfile"
    )
  )
  test_expected_value <- read_file(comp_file, collapse = "\n")
  expect_equal(
    test_output_value,
    test_expected_value
  )
})


test_that("Output file of S4 class is correct", {
  input_file <- "testdoc/man/Account-class.Rd"
  comp_file <- "testdoc-md/Account-class.md"

  test_output_value <- as_markdown(
    read_rdfile(
      path = input_file,
      subclass = "refman_rdfile"
    )
  )
  test_expected_value <- read_file(comp_file, collapse = "\n")
  expect_equal(
    test_output_value,
    test_expected_value
  )
})

test_that("Output file of R6 class is correct", {
  input_file <- "testdoc/man/Person.Rd"
  comp_file <- "testdoc-md/Person.md"
  test_output_value <- as_markdown(
    read_rdfile(
      path = input_file,
      subclass = "refman_rdfile"
    )
  )
  test_expected_value <- read_file(comp_file, collapse = "\n")
  expect_equal(
    test_output_value,
    test_expected_value
  )
})
