
###############
#Data.Clean
###############

# Author: Benjamin Reddy
# Taken from pages 49-50 of O'Neil and Schutt

##Some packages you may need
# install.packages(c("brew", "countrycode",
#                    "devtools", "dplyr", "plyr",
#                    "ggplot2", "googleVis",
#                    "knitr", "MCMCpack",
#                    "repmis", "RCurl",
#                    "rmarkdown", "texreg",
#                    "tidyr", "WDI",
#                    "xtable", "Zelig"))


setwd("C:\\Users\\emily\\Documents\\Summer2017\\DoingDataScience\\LiveSession6")
# getwd()

# http://www1.nyc.gov/site/finance/taxes/property-rolling-sales-data.page


# read csv file
Manhattan <- read.csv("rollingsales_manhattan.csv",skip=4,header=TRUE)

## Check the data
head(Manhattan)
summary(Manhattan)
str(Manhattan) # Very handy function!
#Compactly display the internal structure of an R object.

library(plyr)
## clean/format the data with regular expressions
## More on these later. For now, know that the
## pattern "[^[:digit:]]" refers to members of the variable name that
## start with digits. We use the gsub command to replace them with a blank space.
# We create a new variable that is a "clean' version of sale.price.
# And sale.price.n is numeric, not a factor.
Manhattan$SALE.PRICE.N <- as.numeric(gsub("[^[:digit:]]","", Manhattan$SALE.PRICE))
count(is.na(Manhattan$SALE.PRICE.N))

names(Manhattan) <- tolower(names(Manhattan)) # make all variable names lower case

## Get rid of leading digits
Manhattan$gross.sqft <- as.numeric(gsub("[^[:digit:]]","", Manhattan$gross.square.feet))
Manhattan$land.sqft <- as.numeric(gsub("[^[:digit:]]","", Manhattan$land.square.feet))
Manhattan$year.built <- as.numeric(as.character(Manhattan$year.built))

## do a bit of exploration to make sure there's not anything
## weird going on with sale prices
attach(Manhattan)
hist(sale.price.n) 
detach(Manhattan)

## keep only the actual sales

Manhattan.sale <- Manhattan[Manhattan$sale.price.n!=0,]


## for now, let's look at 1-, 2-, and 3-family homes
Manhattan.homes <- Manhattan.sale[which(grepl("FAMILY",Manhattan.sale$building.class.category)),]
dim(Manhattan.homes)

summary(Manhattan.homes[which(Manhattan.homes$sale.price.n<100000),])
""

## remove outliers that seem like they weren't actual sales
Manhattan.homes$outliers <- (log10(Manhattan.homes$sale.price.n) <=5) + 0
Manhattan.homes <- Manhattan.homes[which(Manhattan.homes$outliers==0),]