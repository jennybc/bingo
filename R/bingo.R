#' Generate bingo cards
#'
#' @param n_cards number of cards
#' @param words text for the bingo squares
#' @param n number of rows/columns for one card
#'
#' @return a \code{bingo} object, which is really just a character matrix
#' @export
#'
#' @examples
#' bingo()
bingo <- function(n_cards = 1, words, n = 5) {
  stopifnot(n %% 2 == 1)

  if (missing(words)) {
    words <- topics[['open-data']]
  }

  words <- vet_squares(words)
  m <- length(words)
  n_sq <- (n ^ 2) - 1
  stopifnot(m >= n_sq)

  cards <- replicate(n_cards, words[sample.int(m, size = n_sq)])
  up_to <- trunc(n_sq/2)
  cards <- rbind(head(cards, up_to), rep("FREE", n_cards), tail(cards, up_to))
  row.names(cards) <- NULL
  structure(cards, class = c("bingo", "matrix"))
}

#' Plot bingo cards
#'
#' @param x a \code{\link{bingo}} object containing one or more bingo cards
#' @param dir directory where you want to write files
#' @param fontsize size of bingo square font
#' @param pdf_base base of the sequential filenames for the printable bingo card
#'   files
#' @param ... not used
#'
#' @export
#' @note Does not actually plot the cards to the graphics device
#' @return Vector containing the filenames of all the generated cards
#'   (invisibly)
#' @examples
#' bc <- bingo()
#' plot(bc)
plot.bingo <- function(x, dir = ".", fontsize = 14, pdf_base = "bingo-", ...) {
  bc <- x
  n <- infer_n(bc)
  n_cards <- ncol(bc)
  bc_wrapped <- apply(bc, 2, wrap_it)
  message("Writing to file ...")
  filenames <- c()
  for (i in seq_len(n_cards)) {
    fname <- file.path(dir, paste0(pdf_base, sprintf("%02d", i), ".pdf"))
    message("  ", fname)
    filenames <- c(filenames, fname)
    pdf(fname, width = 7, height = 7)
    plot_one(bc_wrapped[ , i], n = n, fontsize = fontsize)
    dev.off()
  }
  invisible(filenames)
}

plot_one <- function(x, n, fontsize = 14) {
  grid::grid.newpage()
  g <- make_grid(n)
  centers <- g[-1] - grid::unit(1/(n * 2),"npc")
  grid::grid.text(label = x, x = rep(centers, each = n), y = centers,
                  gp = grid::gpar(fontsize = fontsize))

}
