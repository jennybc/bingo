# DO NOT LOOK AT ME, I'M HIDEOUS; the code here is not well-structured

library(shiny)
library(shinyjs)
library(bingo)

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
                    c("3x3" = "3", "5x5" = "5")),
        numericInput("textSize", "Text size (in pixels)", 14, 8)
      )
    ),
    br(),
    downloadButton('generate', 'Generate cards!', class = "btn-primary btn-lg")
  )
)

server <- function(input, output, session) {
  observeEvent(input$advancedBtn, {
    toggle("advanced", anim = TRUE)
  })

  observe({
    submitEnabled <-
      input$uploadType == "superbowl" || input$uploadType == "opendata" ||
      (input$uploadType == "box" && nzchar(input$wordsBox)) ||
      (input$uploadType == "file" && !is.null(input$wordsFile))
    toggleState("download", condition = submitEnabled)
  })

  output$generate <- downloadHandler(
    filename = function() {
      "bingo-cards.zip"
    },
    content = function(file) {
      tryCatch({
        if (input$uploadType == "superbowl") {
          words <- superbowl_50_2016()
        } else if (input$uploadType == "opendata") {
          words <- open_data()
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

        # generate the cards
        cards <- bingo(n_cards = input$numberToMake, bs = words, n = size)
        filenames <- plot(cards, dir = tempdir(), fontsize = input$textSize)
        wd <- setwd(dirname(filenames[1]))
        zip(file, basename(filenames))
        setwd(wd)
      },
      error = function(err) {
        stop(err$message)
      })
    }
  )
}

shinyApp(ui = ui, server = server)
