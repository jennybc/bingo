library(shiny)
library(shinyjs)
library(bingo)

source("utils.R")

function(input, output, session) {

  values <- reactiveValues(cardsHTML = NULL)

  # show/hide the advanced options
  observeEvent(input$advancedBtn, {
    toggle("advanced", anim = TRUE)
  })

  # show an error message when an error occurs
  observeEvent(values$error, {
    html("errormsg", values$error)
    show("error", anim = TRUE)
  })

  # disable the Generate button when no words are entered
  observe({
    submitEnabled <- TRUE
    if ( (input$uploadType == "box" && !nzchar(input$wordsBox)) ||
         (input$uploadType == "file" && is.null(input$wordsFile))
    ) {
      submitEnabled <- FALSE
    }
    toggleState("generatePdf", condition = submitEnabled)
    toggleState("generateHtml", condition = submitEnabled)
  })

  # Generate PDF cards
  output$generatePdf <- downloadHandler(
    filename = function() {
      "bingo-cards.zip"
    },
    content = function(file) {
      tryCatch({
        # make sure there are enough phrases to fill at least one card
        size <- as.integer(input$size)
        validateSize(words(), size)

        # generate the cards
        cards <- bingo(n_cards = input$numberToMake, words = words(), n = size)
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

  words <- reactive({
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
  })

  # Generate HTML cards
  observeEvent(input$generateHtml, {
    tryCatch({
      size <- as.integer(input$size)
      validateSize(words(), size)

      hide("error")
      show("print")

      # Joe Cheng won't like, but I have to use reactiveValues here
      values$cardsHTML <-
        tagList(
          generateCardCSS(input$length, input$textSize),
          lapply(seq(input$numberToMake), function(i) {
            generateCard(words(), size)
          })
        )
    },
    error = function(err) {
      values$error <- err$message
    })
  })

  # render the cards HTML when it changes
  output$cards <- renderUI({
    values$cardsHTML
  })
}
