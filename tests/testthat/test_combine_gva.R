context("combining gva")

combined_gva <- combine_gva_extracts(
  abs = ee_gva::abs,
  gva = ee_gva::gva,
  sic91 = ee_gva::sic91
)

test_that("produces validated output", {
  expect_equal(1, 1)
  expect_identical(class(combined_gva), c("combined_gva", "data.frame"))
})

# test_that("str_length of factor is length of level", {
#   expect_equal(str_length(factor("a")), 1)
#   expect_equal(str_length(factor("ab")), 2)
#   expect_equal(str_length(factor("abc")), 3)
# })
#
# test_that("str_length of missing is missing", {
#   expect_equal(str_length(NA), NA_integer_)
#   expect_equal(str_length(c(NA, 1)), c(NA, 1))
#   expect_equal(str_length("NA"), 2)
# })
