#implement random forest
install.packages("randomForest")
library(randomForest)

#str(iowa_train_noZone)

#split into train and test sets (use a 70:30 ratio)
set.seed(1000) #set seed to make partition reusable


iowa_forest_table <- sample(nrow(iowa_stripped_numeric), 0.7*nrow(iowa_stripped_numeric), replace = FALSE)
#split the train and test data
iowa_forest_train <- iowa_stripped[iowa_forest_table,]
iowa_forest_test <- iowa_stripped[-iowa_forest_table,]

#create a random forest
random_forest <- randomForest(SalePrice ~ ., data = iowa_forest_train, ntree = 500, mtry = 6, importance = TRUE)
#forest_numeric
predicted <- predict(random_forest, iowa_forest_test)

plot(predicted, iowa_forest_test$SalePrice)


#' This function takes in a single value (that's numeric) for the final criteria.
#' Once it takes in the value (currently generic values, will be user input)
#' it will turn it into a single rowed dataframe with column names
#' that match the column names of the iowa_stripped table (except for sale price)
#' then use the random forest method model created above to predict
#' the sale price of that row
#' @export
single_input <- function() 
{
  #make the values numeric (just for prediction stuff)
  sub_class <- 2
  qual <- 3
  basement_area <- 2
  area_of_first_floor <- 4
  above_grade_living <- 5
  total_good_rooms <- 7
  total_bathrooms <- 9
  garage_area <- 8
  
  # make into a single rowed data frame
  single_row<-list(sub_class, qual, basement_area, area_of_first_floor, above_grade_living,
                   total_good_rooms, garage_area, total_bathrooms)
  single_row <- as.data.frame(single_row)
  
  #name the columns
  colnames(single_row) <- c('MSSubClass','OverallQual','TotalBsmtSF','X1stFlrSF','GrLivArea','TotRmsAbvGrd',
                           'GarageArea','TotalBathrooms')
 
  
  #put single row in the random forest
  predict_price <- predict(random_forest, single_row)
  print(predict_price)
  
}


