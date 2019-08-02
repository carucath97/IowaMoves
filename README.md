# IowaMoves
This R code uses knn regression in order to take in the data from train.csv and predict the sale price of the houses listed.

The code can simply be run, nothing needs to be uncommented/commented out.

initialisation.R needs to be run first since, as you can tell by its name, it initialises the tables required for the model. knn_regression.R and correlation_and_user_input.R are independent of each other so the order they are run doesn't matter.

knn_regression.R takes the table with 20 columns left and uses regression in order to build a prediction model (i'm not really sure how to capture the model to use fitted() functions unfortunately). 

correlation_and_user_input.R takes the table with 8 columns (rather 'random' ones as it was only when writing this script that it occured to me that I should have checked the correlations for a column ~ sale price) and does the same as knn_regression.R. It then has a function which attempts to take in input from the user and make a prediction of the sale price, this doesn't work (returns a NULL) and this is due to me not being sure on how to deal with factors as input and with (As mentioned above) the uncertainty on knowing how to capture models.

This project is still very much a work in progress, the shiny and MySQL parts haven't been started yet and even the predictions are very iffy. I attribute the slow progress to not really understanding the project fully (or at least enough to reasonably make progress) until Wednesday (31/07/2019) not that that's an excuse, merely an explanation.

