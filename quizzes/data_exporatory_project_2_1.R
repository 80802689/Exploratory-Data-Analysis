
# Question 1
# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
# Using the base plotting system, make a plot showing the total PM2.5 emission from 
# all sources for each of the years 1999, 2002, 2005, and 2008.

setwd('~/R')
library(data.table)

# make sure the sources data folder exists
if (!file.exists('data/emissions analysis')) {
  dir.create('data/emissions analysis')
}

# get the specified data
fileURL<-'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip'
download.file(fileURL,destfile='./data/emissions analysis/emissions.zip')
unzip('data/emissions analysis/emissions.zip',exdir='data/emissions analysis',overwrite=TRUE)

# load 'em up
NEI<-data.table(readRDS('./data/emissions analysis/summarySCC_PM25.rds')[,c(4,6)])
NEI<-NEI[,lapply(.SD,sum),by=c('year')]
NEI<-NEI[,kEmissions:=as.integer(NEI$Emissions/1000)]

# open device
png(filename='data/emissions analysis/plot1.png',width=480,height=480,units='px')

# plot line (trend) data to answer above question
plot(NEI$year,NEI$kEmissions,ylab='YOY Emissions per 1,000 Tons', xlab='Emissions Testing Year',type='o',
     pch=4,col='black',lwd=3,main='U.S. YOY Emissions')
mdl <- lm(NEI$kEmissions ~ NEI$year)
abline(mdl, col='green',lwd=3,lty='dotted')
legend('bottomleft',legend=c('Emissions','Trend'),col=c('black','green'),lty=c('solid','dotted'))

# close device (use 'set' to bypass the inherent printing)
x<-dev.off()
