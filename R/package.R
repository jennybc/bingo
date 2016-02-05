vet_squares <- function(bs) {
  if (!inherits(bs, "character")) bs <- as.character(bs)
  bs <- unique(bs)
  bs
}

#' Generate bingo cards
#'
#' @param n_cards number of cards
#' @param bs text for the bingo squares
#' @param n number of rows/columns for one card
#'
#' @return a \code{bingo} object, which is really just a character matrix
#' @export
#'
#' @examples
#' bingo()
bingo <- function(n_cards = 1, bs = NULL, n = 5) {
  stopifnot(n %% 2 == 1)
  if (is.null(bs)) bs <- superbowl_50_2016()
  bs <- vet_squares(bs)
  m <- length(bs)
  n_sq <- (n ^ 2) - 1
  stopifnot(m >= n_sq)

  cards <- replicate(n_cards, bs[sample.int(m, size = n_sq)])
  up_to <- trunc(n_sq/2)
  cards <- rbind(head(cards, up_to), rep("FREE", n_cards), tail(cards, up_to))
  row.names(cards) <- NULL
  structure(cards, class = c("bingo", "matrix"))
}

#' @export
plot.bingo <- function(bc, fontsize = 14, pdf_base = "bingo-") {
  n <- infer_n(bc)
  n_cards <- ncol(bc)
  bc_wrapped <- apply(bc, 2, wrap_it)
  message("Writing to file ...")
  for (i in seq_len(n_cards)) {
    plot_one(bc_wrapped[ , i], n = n, fontsize = fontsize)
    fname <- paste0(pdf_base, sprintf("%02d", i), ".pdf")
    message("  ", fname)
    dev.print(pdf, fname, width = 7, height = 7)
  }
}

plot_one <- function(x, n, fontsize = 14) {
  grid::grid.newpage()
  g <- make_grid(n)
  centers <- g[-1] - grid::unit(1/(n * 2),"npc")
  grid::grid.text(label = x, x = rep(centers, each = n), y = centers,
                  gp = grid::gpar(fontsize = fontsize))

}

## utils

wrap_one <- function(x, w = 13) {
  stopifnot(length(x) == 1L)
  paste(strwrap(x, width = w), collapse = "\n")
}
wrap_it <- Vectorize(wrap_one, "x", USE.NAMES = FALSE)

make_grid <- function(n) {
  gridlines <- grid::unit( (0:n) / n, "npc")
  grid::grid.grill(h = gridlines,  v = gridlines) # gp = gpar(col="grey"))
  gridlines
}

## write something to compute n from a vector or matrix of bingo card data
infer_n <- function(bc) {
  m <- if (length(dim(bc) == 2)) nrow(bc) else length(bc)
  n_ok <- 3:6
  n_sq <- n_ok ^ 2
  n <- n_ok[match(m, n_sq)]
  if (is.na(n))
    stop("Sorry, we are only prepared to plot square bingo cards ",
         "with ", min(n_ok), " to ", max(n_ok), " rows/cols.", call. = FALSE)
  n
}
