#install.packages("ggplot2")
#install.packages("FNN")
#install.packages("psych")
required_packages <- c("ggplot2", "FNN", "psych", "RMySQL") #Every package your script needs
new_packages <- required_packages[!(required_packages %in% installed.packages()[,"Package"])] #Get all the ones not already installed
install.packages(new_packages) #Install all packages not already installed
library(class)
library(ggplot2)
library(FNN)
library(psych)
library(RMySQL)

setwd("C:/Users/Admin/Documents/IowaMoves")

#establish connection to MySQL database

con <- dbConnect(MySQL(),
                 user = 'root',
                 password = 'password',
                 host = 'localhost',
                 dbname = 'iowa_moves')

#lapply(dbListConnections(dbDriver(drv = "MySQL")), dbDisconnect) # <- use this to disconnect

# write query to retrieve the wanted rows
RawIowa_train <- dbGetQuery(con, "SELECT MSSubClass, OverallQual, TotalBsmtSF, X1stFlrSF, GrLivArea, TotRmsAbvGrd,
           GarageArea, SalePrice, BsmtFullBath, BsmtHalfBath, FullBath, HalfBath from train;")

RawIowa_test <- read.csv("test.csv", sep = ",")

# combine the bathroom areas into one
RawIowa_train$TotalBathrooms <- (RawIowa_train$BsmtFullBath + RawIowa_train$BsmtHalfBath + RawIowa_train$FullBath + RawIowa_train$HalfBath)

# can get rid of other four bathroom columns now
iowa_train <- RawIowa_train[, -c(9:12)]

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


# make a numeric table for making prediction models
# after a lot of modelling, it was found that using factors don't
# work for inputting a new value (as the levels of the factors are different)
# there is a way to level the factors but simply converting to numerics was easier

iowa_numeric <- iowa_train #make a new table to have numeric values

# make the factors into numerics
iowa_numeric$MSSubClass <- as.numeric(iowa_numeric$MSSubClass)
iowa_numeric$OverallQual <- as.numeric(iowa_numeric$OverallQual)






