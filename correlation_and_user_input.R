# want to strip down values even more for an input
# check the correlation values for each remaining value ~ price

# this shows the class of each variable, so we can easily discern the ints
class_of_set <- data.frame(lapply(iowa_train_noZone, class))

# this shows the correlation (in a table) of the integer values in the dataset
# the ones with correlation over 0.5 were: 
# TotalBsmtSF, X1stFlrSF, GrLivArea, TotRmsAbvrd, GarageArea, TotalBathrooms
correlationMatrix_a <- cor(iowa_train_noZone[,c(6, 9:14, 16:17, 20, 19)])

