# put functions in here

required_packages <- c("ggplot2", "FNN", "psych", "RMySQL", "randomForest") #Every package your script needs
new_packages <- required_packages[!(required_packages %in% installed.packages()[,"Package"])] #Get all the ones not already installed
install.packages(new_packages) #Install all packages not already installed
library(class)
library(ggplot2)
library(FNN)
library(psych)
library(RMySQL)
library(randomForest)

#' Analyse input and create model
#'
#' The function will read the input that was taken in from the user.
#' It will first call other functions to retrieve the data from the iowa moves table
#' Then it call a function make a random forest model from this data
#'
#' It will then convert factored/ordered inputs into numerics to put into the prediction model
#' It then puts these inputs into a dataframe (with a single row).
#' This single row is then plotted against the random forest model in order to predict its sale price
#' @param input
#' the user input
#' @return predict_price
#' the predicted sale price of the input
#' @export
forest_logic <- function(input) {
  # connect to database
  con <- connect()

  # set table to data pulled from query
  RawIowa_train <- dbGetQuery(con, "SELECT MSSubClass, OverallQual, TotalBsmtSF, X1stFlrSF, GrLivArea, TotRmsAbvGrd,
           GarageArea, SalePrice, BsmtFullBath, BsmtHalfBath, FullBath, HalfBath from train;")

  # clean up table (order the factors)
  iowa_train <- cleaning(RawIowa_train)

  # also have a numeric table for predictions
  iowa_numeric <- make_numeric(iowa_train)

  #make random forest prediction model
  random_forest <- make_random_forest(iowa_numeric)

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

#' Connect R code to MySQL database
#'
#' Using an imported RMySQL function it connects to the iowa_moves database
#' This contains the data needed to make the model
#' @return con
#' the connection to the MySQL database
#' @export
connect <- function() {
  con <- dbConnect(MySQL(),
                   user = 'root',
                   password = 'password',
                   host = 'localhost',
                   port = 3306,
                   dbname = 'iowa_moves')

  return(con)
}

#' Clean imported data
#'
#' Taking in the raw table data as input, this function combines the bathroom columns into one
#' It then converts values in MSSubClass to text and then orders these in a factor
#' @param table
#' the table that was fetched from the MySQL database
#' @return iowa_train
#' the table after cleaning
#' @export
cleaning <- function(table) {
  # combine the bathroom areas into one
  table$TotalBathrooms <- (table$BsmtFullBath + table$BsmtHalfBath + table$FullBath + table$HalfBath)

  # can get rid of other four bathroom columns now
  iowa_train <- table[, -c(9:12)]

  # need to order factor the subclass
  iowa_train$MSSubClass <- factor(iowa_train$MSSubClass, ordered = TRUE, levels = c(30,
                                                                                    20,
                                                                                    120,
                                                                                    150,
                                                                                    40,
                                                                                    45,
                                                                                    50,
                                                                                    160,
                                                                                    70,
                                                                                    60,
                                                                                    180,
                                                                                    75,
                                                                                    80,
                                                                                    85,
                                                                                    90,
                                                                                    190),
                                  labels = c("1-STORY 1945 & OLDER",
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
                                             "2 FAMILY CONVERSION - ALL STYLES AND AGES"))


  return(iowa_train)
}

#' make a numeric table for making prediction models
#'
#' This function converts the two non-numeric columns (MSSubClass and OverallQual) into numerics
#' This is because numerics are single levelled which makes using random forest much easier
#' @param table
#' the table after it has been cleaned in the cleaning function
#' @return iowa_numeric
#' the same table but with all numeric values
#' @export
make_numeric <- function(table) {

  iowa_numeric <- table #make a new table to have numeric values

  # make the factors into numerics
  iowa_numeric$MSSubClass <- as.numeric(iowa_numeric$MSSubClass)
  iowa_numeric$OverallQual <- as.numeric(iowa_numeric$OverallQual)

  return(iowa_numeric)
}

make_random_forest <- function(table) {
  # make random forest

  set.seed(1000) #set seed to make partition reusable

  iowa_forest_table <- sample(nrow(table), 0.7*nrow(table), replace = FALSE)
  #split the train and test data
  iowa_forest_train <- table[iowa_forest_table,]
  iowa_forest_test <- table[-iowa_forest_table,]

  #create a random forest
  random_forest <- randomForest(SalePrice ~ ., data = iowa_forest_train, ntree = 500, mtry = 6, importance = TRUE, na.action=na.pass)

  return(random_forest)
}
