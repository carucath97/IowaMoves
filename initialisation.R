#install.packages("ggplot2")
library(class)
library(ggplot2)

setwd("C:/Users/Admin/Documents/IowaMove")

RawIowa_test <- read.csv("test.csv", sep = ",")
RawIowa_train <- read.csv("train.csv", sep = ",")

RawIowa_test$MSSubClass <- factor(RawIowa_test$MSSubClass, levels = c(20,
                                                                      30,
                                                                      40,
                                                                      45,
                                                                      50,
                                                                      60,
                                                                      70,
                                                                      75,
                                                                      80,
                                                                      85,
                                                                      90,
                                                                      120,
                                                                      150,
                                                                      160,
                                                                      180,
                                                                      190),
                                  labels = c("1-STORY 1946 & NEWER ALL STYLES",
                                             "1-STORY 1945 & OLDER",
                                             "1-STORY W/FINISHED ATTIC ALL AGES",
                                             "1-1/2 STORY - UNFINISHED ALL AGES",
                                             "1-1/2 STORY FINISHED ALL AGES",
                                             "2-STORY 1946 & NEWER",
                                             "2-STORY 1945 & OLDER",
                                             "2-1/2 STORY ALL AGES",
                                             "SPLIT OR MULTI-LEVEL",
                                             "SPLIT FOYER",
                                             "DUPLEX - ALL STYLES AND AGES",
                                             "1-STORY PUD (Planned Unit Development) - 1946 & NEWER",
                                             "1-1/2 STORY PUD - ALL AGES",
                                             "2-STORY PUD - 1946 & NEWER",
                                             "PUD - MULTILEVEL - INCL SPLIT LEV/FOYER",
                                             "2 FAMILY CONVERSION - ALL STYLES AND AGES"))


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