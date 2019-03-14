context("bingo")

test_that("duplicate squares are removed", {
  x <- c("a", "a", "b")
  expect_identical(c("a", "b"), vet_squares(x))
})


test_that("each topic contains 24+ unique values", {
  x <- letters[1:23]
  expect_error(bingo(words = x), "m >= n_sq is not TRUE")
})
