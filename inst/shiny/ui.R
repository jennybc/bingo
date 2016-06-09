library(shiny)
library(bingo)

fluidPage(
  shinyjs::useShinyjs(),
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
    selectInput("cardType", NULL,
                c("Create PDF cards to download" = "pdf",
                  "Create HTML cards to print" = "html")
    ),
    numericInput("numberToMake", "Number of cards to generate", 5, 1),
    selectInput("uploadType", "Phrases to use",
                c(ls(topics),
                  "(Type phrases into a box)" = "box",
                  "(Upload text file)" = "file")),
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
    shinyjs::hidden(
      div(
        id = "advanced",
        selectInput("size", "Number of cells", selected = "5",
                    c("3x3" = "3", "5x5" = "5")),
        numericInput("textSize", "Text size (in pixels)", 14, 8),
        conditionalPanel(
          condition = "input.cardType == 'html'",
          numericInput("length", "Card size (in centimeters)", 20, 5)
        )
      )
    ),
    br(),
    conditionalPanel(
      condition = "input.cardType == 'pdf'",
      downloadButton('generatePdf', 'Download cards!', class = "btn-primary btn-lg")
    ),
    conditionalPanel(
      condition = "input.cardType == 'html'",
      actionButton("generateHtml", "Generate cards!", class = "btn-primary btn-lg"),
      shinyjs::hidden(
        actionButton("print", "Print these cards", icon("print"),
                     onclick = "javascript:window.print()", class = "btn-lg")
      )
    ),
    br(),
    conditionalPanel(
      condition = "input.cardType == 'html'",
      shinyjs::hidden(
        div(
          id = "error",
          strong("Error: "),
          span(id = "errormsg")
        )
      )
    )
  ),
  conditionalPanel(
    condition = "input.cardType == 'html'",
    uiOutput("cards")
  )
)
