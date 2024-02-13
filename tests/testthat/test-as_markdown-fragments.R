test_that("Simple markdown parsing works", {
  expect_equal(rd_str_to_md("a\n%b\nc"), "a\nc\n")
})

test_that("Insertions work", {
  expect_equal(rd_str_to_md("\\ldots"), "`...`")
  expect_equal(rd_str_to_md("\\dots"), "`...`")
  expect_equal(rd_str_to_md("\\R"), "`R`")
  expect_equal(rd_str_to_md("\\cr"), "\n")
})

test_that("Insertions within text work", {
  expect_equal(rd_str_to_md("text1 \\ldots text2"), "text1 `...` text2\n")
})

test_that("Tables are translated as expected", {
  test_val <- rd_str_to_md("\\tabular{rlll}{
    [,1] \\tab Ozone   \\tab numeric \\tab Ozone (ppb)\\cr
    [,2] \\tab Solar.R \\tab numeric \\tab Solar R (lang)\\cr
    [,3] \\tab Wind    \\tab numeric \\tab Wind (mph)\\cr
    [,4] \\tab Temp    \\tab numeric \\tab Temperature (degrees F)\\cr
    [,5] \\tab Month   \\tab numeric \\tab Month (1--12)\\cr
    [,6] \\tab Day     \\tab numeric \\tab Day of month (1--31)
  }")

  expected_val <- "|    |       |       |                       |
|----|-------|-------|-----------------------|
|[,1]|Ozone  |numeric|Ozone (ppb)            |
|[,2]|Solar.R|numeric|Solar R (lang)         |
|[,3]|Wind   |numeric|Wind (mph)             |
|[,4]|Temp   |numeric|Temperature (degrees F)|
|[,5]|Month  |numeric|Month (1--12)          |
|[,6]|Day    |numeric|Day of month (1--31)   |

"

  expect_equal(test_val, expected_val)
})
