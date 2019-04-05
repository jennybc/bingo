context("bingo")

test_that("duplicate squares are removed", {
  x <- c("a", "a", "b")
  expect_identical(c("a", "b"), vet_squares(x))
})

topic_len_gte24 <- function(){
  topics <- get_topics()
  topic_len <- c()
  for (t in topics){
    topic_len[t] <- length(get_topic(t))
  }
  return(ifelse(all(topic_len > 24), TRUE, FALSE))
}

test_that("each topic contains 24+ unique values", {

  expect_true(topic_len_gte24(), "Submitted topic has <=24 entries")
})
