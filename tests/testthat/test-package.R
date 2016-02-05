context("bingo")

test_that("duplicate squares are removed", {
  x <- c("a", "a", "b")
  expect_identical(c("a", "b"), vet_squares(x))
})
