#' Launch the Shiny app that generates bingo cards
#' @export
#' @param format Which format to generate the cards (downloadable PDF or
#' printable HTML)
launch <- function(format = c("pdf", "html")) {
  format <- match.arg(format)
  folderName <- sprintf("shiny-%s", format)
  shiny::runApp(system.file(folderName, package = "bingo"),
                display.mode = "normal",
                launch.browser = TRUE)
}
