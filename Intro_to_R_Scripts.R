# R is CASE SENSITIVE

# R DATA OBJECTS AND STRUCTURES

# Create a vector of odd numbers
a<-c(1,3,5,7,9)
A
a

# Create a vector of even numbers
b<-c(0,2,4,6,8)
b

# Add two vectors 
c<- a+b
c

# Create a vector of strings
RGVCities<- c('Brownsville','Edinburg','Harlingen', 'McAllen', 'Mission', 'Weslaco')
RGVCities

# Create a vector of strings
RGVZipCodes<- c('78520','78539','78550', '78504', '78503', '78596')

# Data frames are two-dimensional R objects that can contain elements of different data types
# Combine two vectors into a data frame (same or different types)
RGV<-data.frame(RGVCities,RGVZipCodes)
RGV
RGV$RGVCities
RGV$RGVZipCodes

# Reference a particular row and column of an array or data frame
RGV[1,2]

# Set column names
colnames(RGV)=c('City', 'Zip Code')
RGV

# Attach a data frame to R's search path so we don't need to reference it by name each time
attach(RGV)
City

# Remove data object from memory
rm(RGV)
RGV

# LOADING EXTERNAL DATA

# Set working directory
setwd('E:/OneDrive - The University of Texas-Rio Grande Valley/Teaching/INFS 6353/R')
getwd()

# Import data sets
YouTubeVideoStats <- read.csv('Data Sets/YouTubeVideoStats.csv', header=T)
View(YouTubeVideoStats)
head(YouTubeVideoStats)

# Calculate descriptive stats
summary(YouTubeVideoStats)

# Get values
YouTubeVideoStats$viewCount


# R PROGRAMMING

x <- 20
y <- 40

if (x>y) {
  print("x is greater than y")
} else {
  print("y is greater than x")
}

# Now increase x and execute the above code again
x <- 50

# Loop
for (i in 1:10) 
{
  print (i^2)
}

# R PACKAGES

# List of all R packages at https://cran.r-project.org/web/packages/available_packages_by_name.html

# Install an R package. Each package only needs to installed once on a computer 
install.packages('ggplot2')

# Attach an R package, needs to attach a package during each R session
library('ggplot2')

# Detach an R package
detach(package:ggplot2)


# Set max # of rows of output in the Console panel
getOption("max.print")
options(max.print=2000)

library(ggplot2)

# List functions and data available in a package
ls('package:ggplot2')

# Get help on a function
?qplot
