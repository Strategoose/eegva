context("combining gva")

# can I just source control-script here and then check the class of each object?
# will fail if I make weird changes to control-script... and save changes
# whilst it is good to have control-script clean, the version on github always will be, but I want flexibility when developing. and we won't want to produce output...
# maybe a 4th run type called unit_testing
run <- "test"
publication_year <- 2016

source(
  system.file("control-script.R", package = "eegva"),
  echo = TRUE,
  local = TRUE)

test_that("produces validated output", {
  expect_identical(class(abs), c("abs", "data.frame"))
  expect_identical(class(charities), c("charities", "data.frame"))
  expect_identical(class(gva), c("gva", "data.frame"))
  expect_identical(class(sic91), c("sic91", "data.frame"))
  expect_identical(class(tourism), c("tourism", "data.frame"))
  expect_identical(class(combined_gva), c("combined_gva", "data.frame"))
  expect_identical(class(gva_by_sector), c("gva_by_sector", "data.frame"))
})
