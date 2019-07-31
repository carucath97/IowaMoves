#install.packages("ggplot2")
#install.packages("FNN")
install.packages("psych")
library(class)
library(ggplot2)
library(FNN)
library(psych)

setwd("C:/Users/Admin/Documents/IowaMoves")

RawIowa_test <- read.csv("test.csv", sep = ",")
RawIowa_train <- read.csv("train.csv", sep = ",")

#remove id
Iowa_train_NoId <- RawIowa_train[,-1]

#investigate columns with NA values
na_records <- is.na(iowa_train$LotFrontage)

#data[is.na(data$variable)] <- mean(data$variable)
#                           <- 0

# set lotfrontage to mean
Iowa_train_NoId$LotFrontage[is.na(Iowa_train_NoId$LotFrontage)] <- mean(Iowa_train_NoId$LotFrontage, na.rm = TRUE)

#get rid of alley as it has so many NA values (and can't know if either paved or gravel)
iowa_train_NoAlley <- Iowa_train_NoId[,-6]

#get rid of masonry veneer type and area, they appear irrelevant
iowa_train_NoMsn <- iowa_train_NoAlley[,-c(24,25)]
#iowa_train_NoMsn <- iowa_train_NoMsn[,-24]

#get rid of basement criteria except for area -- those indicate size/whether basement exists (0 would imply none)
iowa_train_lessBsmt <- iowa_train_NoMsn[,-c(27:30)]
iowa_train_lessBsmt <- iowa_train_lessBsmt[,-28]

count_na <- function(x) sum(is.na(x))

# as there's only one NA in Electrical, just set it to its most common value (by Subclass)
iowa_train_lessBsmt$Electrical[is.na(iowa_train_lessBsmt$Electrical)] <- "SBrkr"

# due to so many NA values, the fireplace quality is being removed
iowa_train_lessFire <- iowa_train_lessBsmt[,-49]

# get rid of all garage values except for area because the area would mostly indicate price
iowa_train_noGarage <- iowa_train_lessFire[,-c(49:52)]
iowa_train_noGarage <- iowa_train_noGarage[,-c(50:51)]

# due to so many NA values, get rid of PoolQC, Fence and MisFeatures
iowa_train_noMisc <- iowa_train_noGarage[, -c(57:59)]

# get rid of lot shape as not really something people consider for the price
iowa_train_lessLot <- iowa_train_noMisc[, -6]

# combine the bathroom areas into one
iowa_train_lessLot$TotalBathrooms <- (iowa_train_lessLot$BsmtFullBath + iowa_train_lessLot$BsmtHalfBath + iowa_train_lessLot$FullBath + iowa_train_lessLot$HalfBath)

# can get rid of other four bathroom columns now
iowa_train_noBath <- iowa_train_lessLot[, -c(38:41)]

# get rid of all columns between zoning(2) and utilities (7) as they aren't hugely used in pricing
iowa_train_noLot <- iowa_train_noBath[, -c(3:6)]

# get rid of columns between utilies and neighborhood
iowa_train_noLot <- iowa_train_noLot[, -c(4:5)]

# get rid of columns between house quality and material quality
iowa_train_noLot <- iowa_train_noLot[, -c(11:16)]

# just keep total basement area
iowa_train_noBsmt <- iowa_train_noLot[, -c(14:16)]

# kitchens above grade is redundant since kitchen quality is also column
iowa_train_noKitch <- iowa_train_noBsmt[, -24]

# get rid of criteria between garage area and sale condition as not very important
iowa_train_noPorch <- iowa_train_noKitch[, -c(29:39)]

# need to order factor some of the columns, then convert to ints/numerics, then normalise
iowa_train_noPorch$MSSubClass <- factor(iowa_train_noPorch$MSSubClass, ordered = TRUE, levels = c(30,
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
                                                   "2 FAMILY CONVERSION - ALL STYLES AND AGES"
                                        ))
# order zones by cheapest to most expensive
iowa_train_noPorch$MSZoning <- factor(iowa_train_noPorch$MSZoning, ordered = TRUE, levels = c("A", "I", "RH", "RM", "RL", "RP", "FV", "C"))

# order utilities by cheapest to most expensive
iowa_train_noPorch$Utilities <- factor(iowa_train_noPorch$Utilities, ordered = TRUE, levels = c("ELO", "NoSeWa", "NoSewr", "AllPub"))

# get rid of neighborhood and condition columns, so much infor that's hard to really order
iowa_train_noNghbr <- iowa_train_noPorch[, -c(4:6)]

# order type of building
iowa_train_noNghbr$BldgType <- factor(iowa_train_noPrice$BldgType, ordered = TRUE, levels = c("TwnhsI", "TwnhsE", "Duplx", "2FmCon", "1Fam"))

# get rid of housestyle as it's redundant (says stories in SubClass)
iowa_train_noStyle <- iowa_train_noNghbr[, -5]

# order quality
iowa_train_noStyle$OverallQual <- factor(iowa_train_noPrice$OverallQual, ordered = TRUE, levels = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10))

# order condition
iowa_train_noStyle$OverallCond <- factor(iowa_train_noPrice$OverallCond, ordered = TRUE, levels = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10))

# get rid of building type as NA values have been found (also covered in SubClass)
iowa_train_noBuilding <- iowa_train_noStyle[, -4]

# get rid of other quality factors as overall is already listed
iowa_train_lessQual <- iowa_train_noBuilding[, -c(6:7)]

# order foundation
iowa_train_lessQual$Foundation <- factor(iowa_train_lessQual$Foundation, ordered = TRUE, levels = c("Wood", "Stone", "Slab", "PConc", "CBlock", "BrkTil"))

# get rid of heating as doesn't necessarily correlate with price (cheapest and most expensive tended towards GasA)
iowa_train_lessHeat <- iowa_train_lessQual[, -c(8:9)]

# order air con
iowa_train_lessHeat$CentralAir <- factor(iowa_train_lessHeat$CentralAir, ordered = TRUE, levels = c("N", "Y"))

# order electric
iowa_train_lessHeat$Electrical <- factor(iowa_train_lessHeat$Electrical, ordered = TRUE, levels = c("SBrkr", "FuseA", "FuseF", "FuseP", "Mix"))

# get rid of kitchen quality
iowa_train_lessHeat <- iowa_train_lessHeat[, -15]

# order functionality
iowa_train_lessHeat$Functional <- factor(iowa_train_lessHeat$Functional, ordered = TRUE, levels = c("Sal", "Sev", "Maj2", "Maj1", "Mod", "Min2", "Min1", "Typ"))

# order sale condition
iowa_train_lessHeat$SaleCondition <- factor(iowa_train_lessHeat$SaleCondition, ordered = TRUE, levels = c("Partial", "Family", "Alloca", "AdjLand", "Abnorml", "Normal"))

# get rid of zoning as it has NA values (and not sure what to change it to)
iowa_train_noZone <- iowa_train_lessHeat[, -2]

# make a new table to store the numerics
#iowa_train_numeric <- iowa_train_noZone

# make the factors into numerics
#iowa_train_numeric$MSSubClass <- as.numeric(iowa_train_numeric$MSSubClass)
#iowa_train_numeric$Utilities <- as.numeric(iowa_train_numeric$Utilities)
#iowa_train_numeric$OverallQual <- as.numeric(iowa_train_numeric$OverallQual)
#iowa_train_numeric$OverallCond <- as.numeric(iowa_train_numeric$OverallCond)
#iowa_train_numeric$Foundation <- as.numeric(iowa_train_numeric$Foundation)
#iowa_train_numeric$CentralAir <- as.numeric(iowa_train_numeric$CentralAir)
#iowa_train_numeric$Electrical <- as.numeric(iowa_train_numeric$Electrical)
#iowa_train_numeric$Functional <- as.numeric(iowa_train_numeric$Functional)
#iowa_train_numeric$SaleCondition <- as.numeric(iowa_train_numeric$SaleCondition)

#for now, just see the rest as a data frame
dataset <- as.data.frame(lapply(iowa_train_lessLot, as.integer))

# need a feature scaling function
scaling <- function(x) { ((x - min(x)) / (max(x) - min(x))) }

iowa_normalised[, -19] <- as.data.frame(lapply(iowa_train_numeric[, -19], scaling))

# split the date into training and testing -- doing a 60:40 split
iowa_training <- iowa_normalised[1:876,-19]

iowa_testing <- iowa_normalised[877:1460,-19]

iowa_training_true <- iowa_normalised[1:876,19]

k_value <- floor(sqrt(nrow(iowa_training)))

# use knn.reg (reg=regression)
iowa_predictions <- knn.reg(iowa_training, iowa_testing, iowa_training_true, k=k_value)

iowa_reference <- iowa_train_noZone[877:1460, 1]

# table results
prediction_table <- table(iowa_predictions, iowa_reference)
  
correlationMatrix <- cor(dataset[,1:8])
correlationMatrix2 <- cor(dataset[,8:16])
correlationMatrix3 <- cor(dataset[,16:25])
correlationMatrix4 <- cor(dataset[,25:40])
correlationMatrix5 <- cor(dataset[,41:50])
correlationMatrix6 <- cor(dataset[,51:61])
#correlationMatrix7 <- cor(dataset[,65:72])

# make a new dataset
iowa_data <- as.data.frame(lapply(iowa_train_noZone, as.integer))

# compare the correlation of certain factors with the sales price??
cor(iowa_data$MSSubClass, iowa_data$SalePrice) # -0.08428414 or 0.04290332??
cor(iowa_data$OverallQual, iowa_data$SalePrice) # 0.7909816
cor(iowa_data$Utilities, iowa_data$SalePrice) # 0.0143143
cor(iowa_data$OverallCond, iowa_data$SalePrice) # -0.07785589
cor(iowa_data$Foundation, iowa_data$SalePrice) # -0.382479
cor(iowa_data$TotalBsmtSF, iowa_data$SalePrice) # 0.6135806

# copy dataset for regression
data_reg <- iowa_data

# put the outcome variable into its own object
sale_price_prediction <- as.data.frame(data_reg[, 19])

# remove the price column from main dataset
data_reg <- data_reg[, -19]

# scale the variables as they are integers?
data_reg[, c("MSSubClass", "Utilities", "OverallQual", "OverallCond", "Foundation", "TotalBsmtSF",
             "CentralAir", "Electrical", "X1stFlrSF", "X2ndFlrSF", "LowQualFinSF", "GrLivArea",
             "BedroomAbvGr", "TotRmsAbvGrd", "Functional", "Fireplaces", "GarageArea", "SaleCondition", "TotalBathrooms")] <- scale(
               data_reg[, c("MSSubClass", "Utilities", "OverallQual", "OverallCond", "Foundation", "TotalBsmtSF",
                            "CentralAir", "Electrical", "X1stFlrSF", "X2ndFlrSF", "LowQualFinSF", "GrLivArea",
                            "BedroomAbvGr", "TotRmsAbvGrd", "Functional", "Fireplaces", "GarageArea", "SaleCondition", "TotalBathrooms")]
             )

# split the scaled data into training and test, do a 70:30 split
set.seed(1234)

# get sample size
smp_size <- floor(0.70 * nrow(data_reg))

train_ind <- sample(seq_len(nrow(data_reg)), size = smp_size)

# get testing and training data frames
data_reg_train <- data_reg[train_ind,]
data_reg_test <- data_reg[-train_ind,]

# split outcome variable
abs_outcome_train <- sale_price_prediction[train_ind,]
abs_outcome_train <- sale_price_prediction[-train_ind,]

# get k value
k_value <- floor(sqrt(nrow(data_reg_train)))

reg_results <- knn.reg(data_reg_train, data_reg_test, abs_outcome_train, k = k_value)
