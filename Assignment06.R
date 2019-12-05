###################################################################
#   Luke Domanico - Assignment 06: READ THE INSTRUCTIONS BELOW!   #
###################################################################

## Use the following line of commands to set the working directory to ".../Assignment-06"
library(rstudioapi)
current_path <- getActiveDocumentContext()$path 
setwd(dirname(current_path ))
print( getwd() )

## Reading in our csv file using fread() from package data.table 
# Installing data.table (if required) and loading it into memory
if (!require("data.table")) install.packages("data.table")
library("data.table")

#Checking and setting number of cpu threads to maximize reading performance
getDTthreads()
getDTthreads(verbose=TRUE)
setDTthreads(0)
getDTthreads()

# Reading the csv file "yellow_tripdata_2018-07.csv" with fread()
rm(list=ls(all=TRUE))
cat("\014")

header <- read.table("yellow_tripdata_2018-07.csv", header = TRUE,
                     sep=",", nrow = 1)
yellow_tripdata_2018_07 <- fread("yellow_tripdata_2018-07.csv",
                                 skip=1, sep=",",header=FALSE,
                                 data.table=FALSE)
setnames(yellow_tripdata_2018_07, colnames(header))
rm(header)
############################################

# Reading the csv file "taxi+_zone_lookup.csv" with fread()

header2 <- read.table("taxi+_zone_lookup.csv", header = TRUE,
                     sep=",", nrow = 1)
taxi_zone_lookup <- fread("taxi+_zone_lookup.csv",
                                 skip=1, sep=",",header=FALSE,
                                 data.table=FALSE)
setnames(taxi_zone_lookup, colnames(header2))
rm(header2)
############################################


# Install and load tidyverse
if (!require("tidyverse")) install.packages("tidyverse")
library(tidyverse)

# merge pickups
yt_mergedpickups <- merge(yellow_tripdata_2018_07, taxi_zone_lookup, by.x="PULocationID", by.y="LocationID")
yt_mergedpickups <- yt_mergedpickups %>% rename(PUZone = Zone)

# merge dropoffs
yt_mergeddropoffs <- merge(yellow_tripdata_2018_07, taxi_zone_lookup, by.x="DOLocationID", by.y="LocationID")
yt_mergeddropoffs <- yt_mergeddropoffs %>% rename(DOZone = Zone)

# mean of total_amounts
timessquarepickups <- filter(yt_mergedpickups, PUZone == "Times Sq/Theatre District")
newarkdropoffs <- filter(yt_mergeddropoffs, DOZone == "Newark Airport")

pickupmean <- mean(timessquarepickups[["total_amount"]])
dropoffmean <- mean(newarkdropoffs[["total_amount"]])

#printing means
print(paste0("Times Square Pickups Total Amount: ", pickupmean, " Newark Dropoffs Total Amount: ", dropoffmean))
