# IowaMoves
This R code uses random forest in order to take in the data from the iowa_moves MySQL database and predict the sale price 
of the houses listed.

# Instructions for installation
Download the code from the repository. Install MySQL if you don't have it and run dump.sql. Then install the packages (install.packages("packageName")) devtools, FNN, pysch, RMySQL and randomForest in R (preferably RStudio). It should then run.

# Instructions on running
The code can simply be run, nothing needs to be uncommented/commented out. The app can be run from shiny_app.R when in RStudio.

# Information on scripts
ui.R contains the shiny code for what will be shown on the screen. It is not much different from the framework 
except for what the inputs are

server.R sources the functions.R file so that it can call the logic that runs to generate the prediction on screen.

shiny_app.R countains the code from both of these files and an additional line about running the shiny app (this is so the application can be run locally).

functions.R contains the functions needed for the applciation to run. So it connects to a MySQL database to collect the training data,
it cleans the tables a bit to be more useful, it creates a random forest using the training data and then it generates
a prediction based on a singular input.

# Summary
This project is still a WIP at the moment due to difficulties I have been having with the cloud.
