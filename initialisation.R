#install.packages("ggplot2")
library(class)
library(ggplot2)

setwd("C:/Users/Admin/Documents/IowaMoves")

RawIowa_test <- read.csv("test.csv", sep = ",")
RawIowa_train <- read.csv("train.csv", sep = ",")

#RawIowa_test$MSSubClass <- factor(RawIowa_test$MSSubClass, levels = c(20,
#                                                                      30,
#                                                                      40,
#                                                                      45,
#                                                                      50,
#                                                                      60,
#                                                                      70,
#                                                                      75,
#                                                                      80,
#                                                                      85,
#                                                                      90,
#                                                                      120,
#                                                                      150,
#                                                                      160,
#                                                                      180,
#                                                                      190),
#                                  labels = c("1-STORY 1946 & NEWER ALL STYLES",
#                                             "1-STORY 1945 & OLDER",
#                                             "1-STORY W/FINISHED ATTIC ALL AGES",
#                                             "1-1/2 STORY - UNFINISHED ALL AGES",
#                                             "1-1/2 STORY FINISHED ALL AGES",
#                                             "2-STORY 1946 & NEWER",
#                                             "2-STORY 1945 & OLDER",
#                                             "2-1/2 STORY ALL AGES",
#                                             "SPLIT OR MULTI-LEVEL",
#                                             "SPLIT FOYER",
#                                             "DUPLEX - ALL STYLES AND AGES",
#                                             "1-STORY PUD (Planned Unit Development) - 1946 & NEWER",
#                                             "1-1/2 STORY PUD - ALL AGES",
#                                             "2-STORY PUD - 1946 & NEWER",
#                                             "PUD - MULTILEVEL - INCL SPLIT LEV/FOYER",
#                                             "2 FAMILY CONVERSION - ALL STYLES AND AGES"))

#remove id
Iowa_train_NoId <- RawIowa_train[,-1]



#names(RawIowa_test$MSZoning) = c("Agriculture",
#                                 "Commercial",
#                                 "Floating Village Residential",
#                                 "Industrial",
#                                 "Residential High Density",
#                                 "Residential Low Density",
#                                 "Residential Low Density Park ",
#                                 "Residential Medium Density")

#names(RawIowa_test$LotShape) = c("Regular",
#                                 "Slightly irregular",
#                                 "Moderately Irregular",
#                                 "Irregular")
# need to remove various column headers to clean up the data

#boxplot(iowa_train$MSSubClass ~ iowa_train$MSSubClass)

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


#for now, just see the rest as a data frame
dataset <- as.data.frame(lapply(iowa_train_lessBsmt, as.integer))

# need a feature scaling function
#scaling <- function(x) { ((x - min(x)) / (max(x) - min(x))) }

#iowa_normalised <- as.data.frame(lapply(Iowa_train_NoId, scaling))

correlationMatrix <- cor(dataset[,1:8])
correlationMatrix2 <- cor(dataset[,8:16])
correlationMatrix3 <- cor(dataset[,16:25])
correlationMatrix4 <- cor(dataset[,25:40])
correlationMatrix5 <- cor(dataset[,41:55])
correlationMatrix6 <- cor(dataset[,56:70])
correlationMatrix7 <- cor(dataset[,65:72])
