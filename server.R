library(shiny)
source("functions.R")
server <- shinyServer(function(input, output) {
  output$Predicted <- renderText({
    # round the price since large prices tend to be whole numbers
    paste("Predicted Value of $", round(forest_logic(input), digits = 0))
  })
})
