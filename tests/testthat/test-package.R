context("bingo")

test_that("duplicate squares are removed", {
  x <- c("a", "a", "b")
  expect_identical(c("a", "b"), vet_squares(x))
})


test_that("each topic contains at least 24 unique values", {
  expect_topic_length <- function(topic) {
    nt <- length(get_topic(topic))
    expect(
      nt >= 24,
      sprintf("'%s' has length %i", topic, nt)
    )
    invisible(topic)
  }

  topics <- get_topics()
  for (t in topics) expect_topic_length(t)
})
