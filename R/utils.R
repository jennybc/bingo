vet_squares <- function(words) {
  if (!inherits(words, "character")) words <- as.character(words)
  words <- unique(words)
  words
}

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
