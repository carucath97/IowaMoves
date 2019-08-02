library(caret)
library(class)
library(dplyr)
library(e1071)
library(FNN) 
library(gmodels) 
library(psych)
library(plyr)
library(tidyverse)
library(modelr)
library(broom)

# want to strip down values even more for an input
# check the correlation values for each remaining value ~ price

# this shows the class of each variable, so we can easily discern the ints
class_of_set <- data.frame(lapply(iowa_train_noZone, class))

# this shows the correlation (in a table) of the integer values in the dataset
# the ones with correlation over 0.5 were: 
# TotalBsmtSF, X1stFlrSF, GrLivArea, TotRmsAbvrd, GarageArea, TotalBathrooms
correlationMatrix_a <- cor(iowa_train_noZone[,c(6, 9:14, 16:17, 20, 19)])

# will now use the numeric table created to get correlations for the factors
# these should be ordered so that the higher numbered factors would indicate a higher house price
# only OverallQual has a correlation over 0.5

correlationMatrix_b <- cor(iowa_train_numeric[,c(1:5, 7:8, 15, 18, 19)])

# will keep the MSSubClass due to it being something that people would enter
# also keep OverallQual, TotalBsmtSF, X1stFlrSF, GrLivArea, TotRmsAbvrd, GarageArea, TotalBathrooms

iowa_stripped <- iowa_train_noZone

iowa_stripped <- iowa_stripped[, -c(2, 4:5, 7:8, 10:11, 13, 15:16, 18)]

# run the regression again
iowa_stripped_reg <- iowa_stripped

stripped_prediction <- as.data.frame(iowa_stripped_reg[8])

iowa_stripped_reg <- iowa_stripped_reg[-8]

# scale the integers, just use column numbers instead of names
iowa_stripped_reg[, c(3:8)] <- scale(iowa_stripped_reg[, c(3:8)])
head(iowa_stripped_reg)

MSSubClass <- as.data.frame(dummy.code(iowa_stripped_reg$MSSubClass))
OverallQual <- as.data.frame(dummy.code(iowa_stripped_reg$OverallQual))

iowa_stripped_reg <- iowa_stripped_reg[-c(1:2)]

iowa_stripped_reg <- cbind(iowa_stripped_reg, MSSubClass, OverallQual)

set.seed(1234)

smp_size <- floor(0.70 * nrow(iowa_stripped_reg))

train_ind <- sample(seq_len(nrow(iowa_stripped_reg)), size = smp_size)

# get testing and training data frames
iowa_stripped_reg_train <- iowa_stripped_reg[train_ind,]
iowa_stripped_reg_test <- iowa_stripped_reg[-train_ind,]

# split outcome variable
abs_outcome_train <- stripped_prediction[train_ind,]
abs_outcome_test <- stripped_prediction[-train_ind,]

# get k value
k_value <- floor(sqrt(nrow(iowa_stripped_reg_train)))

stripped_reg_results <- knn.reg(iowa_stripped_reg_train, iowa_stripped_reg_test, abs_outcome_train, k = k_value)

# plot as a graph to compare predicted values with actual values
#plot(abs_outcome_test, reg_results$pred, xlab="y", ylab=expression(hat(y)))

plot(abs_outcome_test, round(stripped_reg_results$pred), xlab="y", ylab=expression(hat(y)))

all.equal(abs_outcome_test, stripped_reg_results$pred)

# get the mean of the result difference = 0.1507384
mean_results <- mean(stripped_reg_results$pred/abs_outcome_test)

predictions_outage <- c()

# make sure that the mean will calculate to a percentage (so is between 0 and 1)
if(mean_results > 1) {
  predictions_outage <- c(predictions_outage, abs(mean_results) - 1)
} else {
  predictions_outage <- c(predictions_outage, 1- abs(mean_results))
}

print(mean(predictions_outage))
# the mean result is 0.07032535, why is it different????

# see if fitted method works for established row?
print(fitted(iowa_stripped_reg))

# now get the user input of these values to predict the price??
user_input <- function() {
  # take input from users
  sub_class <- readline(prompt = "Enter the SubClass: ")
  qual <- readline(prompt = "Enter the OverallQual - scale 1 to 10: ")
  basement_area <- readline(prompt = "Basement Area: ")
  area_of_first_floor <- readline(prompt = "Area of First Floor: ")
  above_grade_living <- readline(prompt = "Area of living room: ")
  total_good_rooms <- readline(prompt = "Total rooms (excluding basement): ")
  total_bathrooms <- readline(prompt = "Total bathrooms (including basement): ")
  garage_area <- readline(prompt = "Area of garage (0 if no garage): ")
  
  # convert integer values into ints
  basement_area <- as.integer(basement_area)
  area_of_first_floor <- as.integer(area_of_first_floor)
  above_grade_living <- as.integer(above_grade_living)
  total_good_rooms <- as.integer(total_good_rooms)
  total_bathrooms <- as.integer(total_bathrooms)
  garage_area <- as.integer(total_bathrooms)
  
  # make into a single rowed data frame
  single_row <- as.data.frame(sub_class, qual, basement_area, area_of_first_floor, above_grade_living,
                             total_good_rooms, garage_area, total_bathrooms)
  #scale the int values
  single_row[, c(3:8)] <- scale(single_row[, c(3:8)])
  
  # turn subclass and qual into dataframes
  ms_sub_class <- as.data.frame(dummy.code(single_row$sub_class))
  overall_qual <- as.data.frame(dummy.code(single_row$qual))
  
  single_row <- single_row[-c(1:2)]
  
  single_row <- cbind(single_row, ms_sub_class, overall_qual)
  
  single_row$SalePrice <- fitted(single_row)
  print(single_row$SalePrice)
}


