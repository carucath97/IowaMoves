# IowaMoves
This R code uses random forest in order to take in the data from the iowa_moves MySQL database and predict the sale price of the houses listed.

# Instructions for running
The code can simply be run, nothing needs to be uncommented/commented out.

initialisation.R needs to be run first since, as you can tell by its name, it initialises the tables required for the model. 

# Information on scripts
intialisation.R takes in the data from the table and cleans it (taking the over 80 columns and stripping it down to 9), so that the data is more usable. It also turns the ordered factors into numeric values, as that makes correlating the data and modelling predictions much easier. 

random_forest.R takes the table with 8 columns (rather 'random' ones as it was only when writing this script that it occured to me that I should have checked the correlations for a column ~ sale price) and makes a random forst model. It then makes a prediction of prices of the test data and then plots a graph of the predictions vs the actual values in the test data.
It then has a function which creates a single row of given (currently hard coded) variables in order to make a prediction of a single sale price.

# Summary
This project is still very much a work in progress, the shiny hasn't been started yet and even the predictions are very iffy. I attribute the slow progress to not really understanding the project fully (or at least enough to reasonably make progress) until Wednesday (31/07/2019) not that that's an excuse, merely an explanation.

