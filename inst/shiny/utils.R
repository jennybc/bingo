# Given a string with comma-separated phrases, extract the phrases
getWordsText <- function(text) {
  trimws(strsplit(text, ",")[[1]])
}

# Given a file with comma-separated or newline-separated phrases,
# extract the phrases
getWordsFile <- function(file) {
  getWordsText(paste(readLines(file), collapse = ","))
}


# Make sure there are enough phrases to fill at least one card
validateSize <- function(words, size) {
  if (length(words) < (size * size - 1)) {
    stop(sprintf("You need at least %s phrases to fill a %sx%s bingo card (you provided %s)",
                 size * size - 1, size, size, length(words)))
  }
}

# Create CSS that is needed to customize the appearance of the bingo cards
generateCardCSS <- function(length = 10, textSize = 16) {
  tags$style(paste0(
    "table.bingo-card {",
    "  width: ", length, "cm;",
    "  height: ", length, "cm;",
    "  font-size: ", textSize, "px;",
    "}"
  ))
}

# Generate HTML for a bingo card
generateCard <- function(words = LETTERS, size = 5) {
  # Randomly select phrases and insert "FREE" in the middle
  words <- sample(words, size * size - 1)
  middle <- size * size / 2 + 1
  middleWord <- words[middle]
  words[middle] <- "FREE"
  words[length(words) + 1] <- middleWord
  # Just for convenience, make the phrases a 2D matrix instead of 1D vector
  dim(words) <- c(size, size)

  tags$table(
    class = "bingo-card",
    tags$tbody(
      lapply(seq(size), function(row) {
        tags$tr(
          lapply(seq(size), function(col) {
            tags$td(words[row, col])
          })
        )
      })
    )
  )
}
