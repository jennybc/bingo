#' Launch the Shiny app that generates bingo cards
#' @export
#' @param format Which format to generate the cards (downloadable PDF or
#' printable HTML)
launch <- function(format = c("pdf", "html")) {
  if (!requireNamespace("shiny", quietly = TRUE)) {
    stop("Install 'shiny' via 'install.packages(\"shiny\")' to run this function.",
         call. = FALSE)
  }
  if (!requireNamespace("shinyjs", quietly = TRUE)) {
    stop("Install 'shinyjs' via 'install.packages(\"shinyjs\")' to run this function.",
         call. = FALSE)
  }
  format <- match.arg(format)
  folderName <- sprintf("shiny-%s", format)
  shiny::runApp(system.file(folderName, package = "bingo"),
                display.mode = "normal",
                launch.browser = TRUE)
}
