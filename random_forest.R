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




