# Environment containing all the word lists of all topics
topics <- new.env(parent = emptyenv())

#' Get all bingo card topics
#'
#' @return A character vector containing the names of all the bingo card topics
#' @export
#'
#' @examples
#' get_topics()
get_topics <- function() {
  ls(topics)
}

#' Get the words of a bingo card topic
#'
#' @return A character vector containing all the possible words of a bingo card
#' topic
#' @export
#'
#' @examples
#' get_topic("open-data")
get_topic <- function(topic) {
  if (!topic %in% get_topics()) {
    stop("Topic '", topic, "' does not exist", call. = FALSE)
  }
  topics[[topic]]
}

# When the package loads, load all the topics words
.onLoad <- function(libname, pkgname) {
  rm(list = ls(topics), envir = topics)
  topics_dir <- system.file("topics", package = "bingo")
  all_topics <- list.files(topics_dir, full.names = FALSE, pattern = "\\.R$")
  all_topics <- sub("\\.R$", "", all_topics)

  lapply(all_topics, function(x) {
    tryCatch({
      topic_file <- file.path(topics_dir, paste0(x, ".R"))
      words <- source(topic_file)$value
      assign(x, words, topics)
    }, error = function(err) {
      warning("Topic '", x, "' is mal-formed", call. = FALSE)
    })
  })
}
