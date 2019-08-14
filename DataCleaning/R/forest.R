#implement random forest
install.packages("randomForest")
library(randomForest)

#str(iowa_train_noZone)

#split into train and test sets (use a 70:30 ratio)
set.seed(1000) #set seed to make partition reusable


iowa_forest_table <- sample(nrow(iowa_numeric), 0.7*nrow(iowa_numeric), replace = FALSE)
#split the train and test data
iowa_forest_train <- iowa_numeric[iowa_forest_table,]
iowa_forest_test <- iowa_numeric[-iowa_forest_table,]

#create a random forest
random_forest <- randomForest(SalePrice ~ ., data = iowa_forest_train, ntree = 500, mtry = 6, importance = TRUE)
#forest_numeric
predicted <- predict(random_forest, iowa_forest_test)

plot(predicted, iowa_forest_test$SalePrice)



