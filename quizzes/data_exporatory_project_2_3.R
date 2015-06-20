
# Question 3
# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) 
# variable, which of these four sources have seen decreases in emissions from 1999-2008 
# for Baltimore City? Which have seen increases in emissions from 1999-2008? Use the 
# ggplot2 plotting system to make a plot answer this question.

setwd('~/R')
library(data.table)
library(ggplot2)

# make sure the sources data folder exists
if (!file.exists('data/emissions analysis')) {
  dir.create('data/emissions analysis')
}

# get the specified data
fileURL<-'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip'
download.file(fileURL,destfile='./data/emissions analysis/emissions.zip')
unzip('data/emissions analysis/emissions.zip',exdir='data/emissions analysis',overwrite=TRUE)

# load 'em up and limit to baltimore
NEI<-data.table(readRDS('./data/emissions analysis/summarySCC_PM25.rds')[,c(1,4,5,6)])
NEI<-NEI[NEI$fips == '24510',] # baltimore...
NEI<-NEI[,c(2,3,4),with=FALSE]
NEI<-NEI[,lapply(.SD,sum),by=c('year','type')]

# open device
png(filename='data/emissions analysis/plot3.png',width=480,height=960,units='px')

# plot line (trend) data to answer above question
qplot(year,log(Emissions),data=NEI,facets=type~.,geom=c('point','smooth'),method='lm')

# close device
x<-dev.off()