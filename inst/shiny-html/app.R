# DO NOT LOOK AT ME, I'M HIDEOUS; the code here is not well-structured

library(shiny)
library(shinyjs)
library(bingo)

generateCardCSS <- function(length = 10, textSize = 16) {
  tags$style(paste0(
    "table.bingo-card { width: ", length, "cm; height: ", length, "cm; font-size: ", textSize, "px; }"
  ))
}

generateCard <- function(words = LETTERS, size = 5) {
  words <- sample(words, size * size - 1)
  middle <- size * size / 2 + 1
  middleWord <- words[middle]
  words[middle] <- "FREE"
  words[length(words) + 1] <- middleWord
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

getWordsText <- function(text) {
  trimws(strsplit(text, ",")[[1]])
}

getWordsFile <- function(file) {
  getWordsText(paste(readLines(file), collapse = ","))
}

ui <- fluidPage(
  useShinyjs(),
  tags$head(
    tags$link(href = "app.css", rel = "stylesheet")
  ),

  div(
    class = "noprint",
    id = "form",
    h1(id = "apptitle", "Bingo card generator"),
    div(id = "authors",
        "By", a("Jenny Bryan", href = "https://twitter.com/jennybryan"),
        "and", a("Dean Attali", href = "http://deanattali.com"),
        HTML("&bull;"),
        "Code", a("on GitHub", href = "https://github.com/jennybc/bingo")
    ),
    numericInput("numberToMake", "Number of cards to generate", 5, 1),
    selectInput("uploadType", "Phrase bank",
                c("Super Bowl 2016" = "superbowl",
                  "Open Data" = "opendata",
                  "Bad Data" = "baddata",
                  "Type phrases into a box" = "box",
                  "Upload text file" = "file")),
    div(
      id = "wordsinput",
      conditionalPanel(
        condition = "input.uploadType == 'box'",

        div(class = "form-group shiny-input-container",
            tags$textarea(id = "wordsBox", rows = 7, class = "form-control",
                          paste(LETTERS, collapse = ","))
        ),
        helpText("Phrases must be separated by commas")
      ),
      conditionalPanel(
        condition = "input.uploadType == 'file'",
        fileInput("wordsFile", NULL),
        helpText("Phrases must be separated by commas")
      )
    ),
    actionLink("advancedBtn", "More options"), br(),
    hidden(
      div(
        id = "advanced",
        selectInput("size", "Number of cells", selected = "5",
                    c("3x3" = "3", "5x5" = "5", "7x7" = "7", "9x9" = "9")),
        numericInput("length", "Card size (in centimeters)", 20, 5),
        numericInput("textSize", "Text size (in pixels)", 14, 8)
      )
    ),
    br(),
    actionButton("submit", "Generate cards!", class = "btn-primary btn-lg"),
    hidden(
      actionButton("print", "Print these cards", icon("print"),
                   onclick = "javascript:window.print()", class = "btn-lg")
    ),
    br(),
    hidden(
      div(
        id = "error",
        strong("Error: "),
        span(id = "errormsg")
      )
    )
  ),
  uiOutput("cards")
)

server <- function(input, output, session) {

  values <- reactiveValues(cardsHTML = NULL)

  observeEvent(input$advancedBtn, {
    toggle("advanced", anim = TRUE)
  })

  observeEvent(values$error, {
    html("errormsg", values$error)
    show("error", anim = TRUE)
  })

  observe({
    submitEnabled <-
      input$uploadType == "superbowl" || input$uploadType == "opendata" ||
      input$uploadType == "baddata" ||
      (input$uploadType == "box" && nzchar(input$wordsBox)) ||
      (input$uploadType == "file" && !is.null(input$wordsFile))
    toggleState("submit", condition = submitEnabled)
  })

  observeEvent(input$submit, {
    tryCatch({
      if (input$uploadType == "superbowl") {
        words <- superbowl_50_2016()
      } else if (input$uploadType == "opendata") {
        words <- open_data()
      } else if (input$uploadType == "baddata") {
        words <- bad_data()
      } else if (input$uploadType == "box") {
        words <- getWordsText(input$wordsBox)
      } else if (input$uploadType == "file") {
        words <- getWordsFile(input$wordsFile$datapath)
      }

      # make sure there are enough phrases to fill at least one card
      size <- as.integer(input$size)
      if (length(words) < (size * size - 1)) {
        stop(sprintf("You need at least %s phrases to fill a %sx%s bingo card (you provided %s)",
                     size * size - 1, size, size, length(words)))
      }

      hide("error")
      show("print")

      # Joe Cheng won't like, but I have to use reactiveValues here
      # SAVE THE KITTENS!
      values$cardsHTML <-
        tagList(
          generateCardCSS(input$length, input$textSize),
          lapply(seq(input$numberToMake), function(i) {
            generateCard(words, size)
          })
        )
    },
    error = function(err) {
      values$error <- err$message
    })
  })

  output$cards <- renderUI({
    values$cardsHTML
  })
}

shinyApp(ui = ui, server = server)
