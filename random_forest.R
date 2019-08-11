#implement random forest
install.packages("randomForest")
library(randomForest)

str(iowa_train_noZone)

#split into train and test sets (use a 70:30 ratio)
set.seed(1000) #set seed to make partition reusable

iowa_forest <- sample(nrow(iowa_train_noZone), 0.7*nrow(iowa_train_noZone), replace = FALSE)
iowa_forest_train <- iowa_train_noZone[iowa_forest,]
iowa_forest_test <- iowa_train_noZone[-iowa_forest,]

iowa_forest_stripped <- sample(nrow(iowa_stripped), 0.7*nrow(iowa_train_noZone), replace = FALSE)
iowa_fstrain <- iowa_stripped[iowa_forest_stripped,]
iowa_fstest <- iowa_stripped[-iowa_forest_stripped,]

summary(iowa_forest_train) 

#create the model
forest1 <- randomForest(SalePrice ~ ., data = iowa_forest_train, importance = TRUE)


#add in ntree and mtry values
forest2 <- randomForest(SalePrice ~ ., data = iowa_forest_train, ntree = 500, mtry = 6, importance = TRUE)
forest2
predicted <- predict(forest2, iowa_forest_test)

forest3 <- randomForest(SalePrice ~ ., data = iowa_fstrain, ntree = 500, mtry = 6, importane = TRUE)
forest3
predicted_s <- predict(forest3, iowa_fstest)
plot(predicted_s, iowa_fstest$SalePrice)
all.equal(predicted_s, iowa_fstest$SalePrice)

plot(predicted, iowa_forest_test$SalePrice)
all.equal(predicted, iowa_forest_test$SalePrice)

#make random forest with all rows
forest_all <- randomForest(SalePrice ~ ., data = iowa_stripped, ntree = 500, mtry = 6, importance = TRUE)
#make sample row
sub_class <- "1-STORY 1946 & NEWER ALL STYLES"
qual <- 7
basement_area <- 1300
area_of_first_floor <- 1400
above_grade_living <- 1500
total_good_rooms <- 5
total_bathrooms <- 3
garage_area = 0

single_list<-list(MSSubClass = sub_class, OverallQual = qual, TotalBsmtSF = basement_area, 
                  X1stFlrSF = area_of_first_floor, GrLivArea = above_grade_living,
                 TotRmsAbvGrd = total_good_rooms, GarageArea = garage_area, TotalBathrooms = total_bathrooms)
single_row <- as.data.frame(single_list)
#have to level data
single_row$MSSubClass <- factor(single_row$MSSubClass, levels = level(iowa_stripped$MSSubClass))
single_row$OverallQual <- factor(single_row$OverallQual, levels = level(iowa_stripped$OverallQual))
single_row$TotalBsmtSF <- factor(single_row$TotalBsmtSF, levels = level(iowa_stripped$TotalBsmtSF))
single_row$X1stFlrSF <- factor(single_row$X1stFlrSF, levels = level(iowa_stripped$X1stFlrSF))
single_row$GrLivArea <- factor(single_row$GrLivArea, levels = level(iowa_stripped$GrLivArea))
single_row$TotRmsAbvGrd <- factor(single_row$TotRmsAbvGrd, levels = level(iowa_stripped$TotRmsAbvGrd))
single_row$GarageArea <- factor(single_row$GarageArea, levels = level(iowa_stripped$GarageArea))
single_row$TotalBathrooms <- factor(single_row$TotalBathrooms, levels = level(iowa_stripped$TotalBathrooms))

predict_price <- predict(forest_all, single_row)
plot(predict_price, single_row$Sale_Price)

#now need to make a function getting in the user input
user_input <- function() 
{
  # take input from users
  sub_class <- readline(prompt = "Enter the SubClass: ")
  qual <- readline(prompt = "Enter the OverallQual - scale 1 to 10: ")
  basement_area <- readline(prompt = "Basement Area: ")
  area_of_first_floor <- readline(prompt = "Area of First Floor: ")
  above_grade_living <- readline(prompt = "Area of living room: ")
  total_good_rooms <- readline(prompt = "Total rooms (excluding basement): ")
  total_bathrooms <- readline(prompt = "Total bathrooms (including basement): ")
  garage_area <- readline(prompt = "Area of garage (0 if no garage): ")
  print(1)
  # make into a single rowed data frame
  ##test
  
  
  
  single_row<-list(sub_class, qual, basement_area, area_of_first_floor, above_grade_living,
    total_good_rooms, garage_area, total_bathrooms)
  print(1)
  single_row <- as.data.frame(sub_class, qual, basement_area, area_of_first_floor, above_grade_living,
                              total_good_rooms, garage_area, total_bathrooms)
  print(1)
  print(single_row)
  #put in the random forest
  predict_price <- predict(forest3, single_row)
  print(1)
  plot(predict_price, single_row$Sale_Price)
  all.equal(predict_price, single_row$Sale_Price)
  #print(single_row$Sale_Price)
  
  #single_row$SalePrice <- fitted(single_row)
  #print(single_row$SalePrice)
}




