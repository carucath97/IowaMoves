#install.packages("ggplot2")
#install.packages("FNN")
#install.packages("psych")
required_packages <- c("ggplot2", "FNN", "psych") #Every package your script needs
new_packages <- required_packages[!(required_packages %in% installed.packages()[,"Package"])] #Get all the ones not already installed
install.packages(new_packages) #Install all packages not already installed
library(class)
library(ggplot2)
library(FNN)
library(psych)

#test getting data from SQL

con <- dbConnect(MySQL(),
          user = "root", password = "password",
          dbname = "iowa_moves", host = "localhost")
on.exit(dbDisconnect(con))