#' Environment containing all the word lists of all topics
#' @export
topics <- new.env(parent = emptyenv())

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
