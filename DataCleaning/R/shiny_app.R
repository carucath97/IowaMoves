# make the shiny stuff?
#install.packages("shiny")
library(shiny)
source("functions.R")
options(scipen = 9999)
ui <- shinyUI(fluidPage(
  titlePanel("Iowa Moves Price Prediction"),

  sidebarLayout(
    sidebarPanel(
      numericInput(inputId = "TotalBsmtSF", label = "Area of Basement", value = 0, min = 0, step = 1),
      numericInput(inputId = "X1stFlrSF", label = "Area of First Floor", value = 0, min = 0, step = 1),
      numericInput(inputId = "GrLivArea", label = "Area of Living Room", value = 0, min = 0, step = 1),
      numericInput(inputId = "GarageArea", label = "Garage Area (0 if no garage)", value = 0, min = 0, step = 1),
      numericInput(inputId = "TotRmsAbvGrd", label = "Total rooms (above grade)", value = 0, min = 0, step = 1),
      sliderInput(inputId = "TotalBathrooms", label = "Number of Bathrooms", min = 0, value = 0, step = 1, max = 10),
      selectInput(inputId = "MSSubClass", label = "House Type", choices = c("1-STORY 1945 & OLDER",
                                                                            "1-STORY 1946 & NEWER ALL STYLES",
                                                                            "1-STORY PUD (Planned Unit Development) - 1946 & NEWER",
                                                                            "1-1/2 STORY PUD - ALL AGES",
                                                                            "1-STORY W/FINISHED ATTIC ALL AGES",
                                                                            "1-1/2 STORY - UNFINISHED ALL AGES",
                                                                            "1-1/2 STORY FINISHED ALL AGES",
                                                                            "2-STORY PUD - 1946 & NEWER",
                                                                            "2-STORY 1945 & OLDER",
                                                                            "2-STORY 1946 & NEWER",
                                                                            "PUD - MULTILEVEL - INCL SPLIT LEV/FOYER",
                                                                            "2-1/2 STORY ALL AGES",
                                                                            "SPLIT OR MULTI-LEVEL",
                                                                            "SPLIT FOYER",
                                                                            "DUPLEX - ALL STYLES AND AGES",
                                                                            "2 FAMILY CONVERSION - ALL STYLES AND AGES")),
      selectInput(inputId = "OverallQual", label = "Quality", choices = c(1:10))
    ),

    mainPanel(
      textOutput(outputId = "Predicted"),
      plotOutput(outputId = "PlotID")
    )
  )
)
)

server <- shinyServer(function(input, output) {
  output$Predicted <- renderText({
    # round the price since large prices tend to be whole numbers
    paste("Predicted Value of $", round(forest_logic(input), digits = 0))
  })


  output$PlotID <- renderPlot({
    plot(c(1:20), c(1:20))
  })
})

shinyApp(ui = ui, server = server)
