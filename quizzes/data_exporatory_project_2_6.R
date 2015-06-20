
# Question 6
# Compare emissions from motor vehicle sources in Baltimore City with 
# emissions from motor vehicle sources in Los Angeles County, California 
# (fips == 06037). Which city has seen greater changes over time in motor 
# vehicle emissions?

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

# load 'em up and limit to baltimore and motor vehicles, interpreted as 'on-road'
NEI<-data.table(readRDS('./data/emissions analysis/summarySCC_PM25.rds')[,c(1,4,5,6)])
NEI<-subset(NEI,(NEI$fips == '24510' | NEI$fips == '06037') & NEI$type == 'ON-ROAD')

# limit to final set
NEI<-NEI[,c(1,2,4),with=FALSE]
NEI<-NEI[,lapply(.SD,sum),by=c('fips','year')]
NEI<-NEI[,city:=ifelse(fips=='06037','Los Angeles','Baltimore')]

# open device
png(filename='data/emissions analysis/plot6.png',width=480,height=480,units='px')

# plot data to answer above question
qplot(year,log(Emissions),data=NEI,facets=city~.,geom=c('point','smooth'),method='lm')

# close device
x<-dev.off()

