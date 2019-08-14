# IowaMoves
This R code uses random forest in order to take in the data from the iowa_moves MySQL database and predict the sale price of the houses listed.

# Instructions for installation
TODO

# Instructions for running
The code can simply be run, nothing needs to be uncommented/commented out.

mysql_initialisation.R needs to be sourced and then run first since, as you can tell by its name, it initialises the tables required for the model. 
forest.R needs to be run next to generate the random forest model (the lines install.packages("randomForest") and library(randomForst) need to be run manually (not just with the others) prior to the rest so that the prediction model works.
shiny_app.R can simply be run to generate the application.

# Information on scripts
intialisation.R takes in the data from a MySQL server (from the iowa_moves) schema, selects the 13 columns it needs (based on previous data cleaning), and does some extra cleaning so that the data is more usable (it combines the bathroom columns and it order factors the sub classes). It also turns the ordered factors into numeric values, as that makes correlating the data and modelling predictions much easier. 

forest.R takes the table with 8 columns (rather 'random' ones as it was only when writing this script that it occured to me that I should have checked the correlations for a column ~ sale price) and makes a random forst model. It then makes a prediction of prices of the test data and then plots a graph of the predictions vs the actual values in the test data.

shiny_app.R makes a shiny application (which is the user interface for this product). It takes in user inputs, turns them into a dataframe and then uses the random forest model made in forest.R to make a prediction of the sale price of the potential house based on the input.

# Summary
This project is currently only a minimum viable product (hopefully, the predictions aren't very strong).

