# make the shiny stuff?
#install.packages("shiny")
library(shiny)
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

#' Analyse input and create model
#'
#' The function will read the input that was taken in from the user.
#' It will convert factored/ordered inputs into numerics to put into the prediction model
#' It then puts these inputs into a dataframe (with a single row).
#' This single row is then plotted against the random forest model in order to predict its sale price
#' @param input
#' the user input
#' @return predict_price
#' the predicted sale price of the input
#' @export
forest_logic <- function(input) {

  single_list <- list(
    "TotalBsmtSF" <- input$TotalBsmtSF,
    "X1stFlrSF" <- input$X1stFlrSF,
    "GrLivArea"  <- input$GrLivArea,
    "GarageArea" <- input$GarageArea,
    "TotRmsAbvGrd" <- input$TotRmsAbvGrd,
    "TotalBathrooms" <- input$TotalBathrooms,
    "MSSubClass" <- as.numeric(as.factor(input$MSSubClass)),
    "OverallQual" <- as.numeric(input$OverallQual)

)

 # single_row<-list(classValue, qualValue, basementValue, first_floorValue, livingValue,
 #                  roomValue, garageValue, bathroomValue)
  single_row <- as.data.frame(single_list)

  #name the columns
  colnames(single_row) <- c('MSSubClass','OverallQual','TotalBsmtSF','X1stFlrSF','GrLivArea','TotRmsAbvGrd',
                            'GarageArea','TotalBathrooms')


  #put single row in the random forest
  predict_price <- predict(random_forest, single_row)
  return(predict_price)
}

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
