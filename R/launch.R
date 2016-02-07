#' Launch the Shiny app that generates bingo cards
#' @export
launch <- function() {
  if (!requireNamespace("shiny", quietly = TRUE)) {
    stop("Install 'shiny' via 'install.packages(\"shiny\")' to run this function.",
         call. = FALSE)
  }
  if (!requireNamespace("shinyjs", quietly = TRUE)) {
    stop("Install 'shinyjs' via 'install.packages(\"shinyjs\")' to run this function.",
         call. = FALSE)
  }
  shiny::runApp(system.file("shiny", package = "bingo"),
                display.mode = "normal",
                launch.browser = TRUE)
}
