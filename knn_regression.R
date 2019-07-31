# knn regression
#rm(list=ls()) # <-- will clear all the data (including libraries)
#Libraries----
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

# use the cleaned up table (but maintaining the factors)
iowa_reg <- iowa_train_noZone

# put sale price into its own data frame
sale_price_prediction <- as.data.frame(iowa_reg[19])

# remove the outcome variable from the data set
iowa_reg <- iowa_reg[-19]

# determine the types
str(iowa_reg)

# scale the integers
iowa_reg[, c("TotalBsmtSF", "X1stFlrSF", "X2ndFlrSF", "LowQualFinSF", "GrLivArea", "BedroomAbvGr", "TotRmsAbvGrd",
             "Fireplaces", "GarageArea", "TotalBathrooms")] <- scale(iowa_reg[, c("TotalBsmtSF", "X1stFlrSF", "X2ndFlrSF", 
                                                                                  "LowQualFinSF", "GrLivArea", "BedroomAbvGr", 
                                                                                  "TotRmsAbvGrd",
                                                                                  "Fireplaces", "GarageArea", 
                                                                                  "TotalBathrooms")])
head(iowa_reg)

# the factors are MSSubClass, Utilities, OverallQual, OverallCond, Foundation, CentralAir, Electrical, Functional, Sale Condition
# give the factors dummy variables
MSSubClass <- as.data.frame(dummy.code(iowa_reg$MSSubClass))
Utilities <- as.data.frame(dummy.code(iowa_reg$Utilities))
OverallQual <- as.data.frame(dummy.code(iowa_reg$OverallQual))
OverallCond <- as.data.frame(dummy.code(iowa_reg$OverallCond))
Foundation <- as.data.frame(dummy.code(iowa_reg$Foundation))
CentralAir <- as.data.frame(dummy.code(iowa_reg$CentralAir))
Electrical <- as.data.frame(dummy.code(iowa_reg$Electrical))
Functional <- as.data.frame(dummy.code(iowa_reg$Functional))
SaleCondition <- as.data.frame(dummy.code(iowa_reg$SaleCondition))

# remove the dummy variables from the original data set
iowa_reg <- iowa_reg[, -c(1:5, 7:8, 15, 18)]

# we now combine the dummy variables with data (which are now data frames)
iowa_reg <- cbind(iowa_reg, MSSubClass, Utilities, OverallQual, OverallCond, Foundation, CentralAir, Electrical, Functional, SaleCondition)

# REGRESSION!!!!

# set the seed to make the partition reusable
set.seed(1234)

# get sample size
smp_size <- floor(0.70 * nrow(iowa_reg))

train_ind <- sample(seq_len(nrow(iowa_reg)), size = smp_size)

# get testing and training data frames
iowa_reg_train <- iowa_reg[train_ind,]
iowa_reg_test <- iowa_reg[-train_ind,]

# split outcome variable
abs_outcome_train <- sale_price_prediction[train_ind,]
abs_outcome_test <- sale_price_prediction[-train_ind,]

# get k value
k_value <- floor(sqrt(nrow(iowa_reg_train)))

reg_results <- knn.reg(iowa_reg_train, iowa_reg_test, abs_outcome_train, k = k_value)

# plot as a graph to compare predicted values with actual values
#plot(abs_outcome_test, reg_results$pred, xlab="y", ylab=expression(hat(y)))

plot(abs_outcome_test, round(reg_results$pred), xlab="y", ylab=expression(hat(y)))

all.equal(abs_outcome_test, reg_results$pred)

# get the mean of the result difference
mean_results <- mean(reg_results$pred/abs_outcome_test)

predictions_outage <- c()

# make sure that the mean will calculate to a percentage (so is between 0 and 1)
if(mean_results > 1) {
  predictions_outage <- c(predictions_outage, abs(mean_results) - 1)
} else {
  predictions_outage <- c(predictions_outage, 1- abs(mean_results))
}

print(mean(predictions_outage))

