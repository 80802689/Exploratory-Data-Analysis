
# Question 5
# How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?

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

# load 'em up and limit to baltimore and motor vehicles, interpreted as 'on-road'
NEI<-data.table(readRDS('./data/emissions analysis/summarySCC_PM25.rds')[,c(1,4,5,6)])
NEI<-NEI[NEI$fips == '24510',] # baltimore...
NEI<-NEI[NEI$type == 'ON-ROAD',] # motor vehichles

# limit to final set
NEI<-NEI[,c(2,4),with=FALSE]
NEI<-NEI[,lapply(.SD,sum),by=c('year')]

# open device
png(filename='data/emissions analysis/plot5.png',width=480,height=480,units='px')

# plot line (trend) data to answer above question
plot(NEI$year,NEI$Emissions,ylab='YOY Emissions (Tons)',xlab='Emissions Testing Year',
     type='o',pch=3,col='black',lwd=2,main='Baltimore YOY Motor Vehicle Emissions')
mdl <- lm(NEI$Emissions ~ NEI$year)
abline(mdl, col='green',lwd=5,lty='dotted')
legend('topright',legend=c('Emissions','Trend'),col=c('black','green'),lty=c('solid','dotted'))

# close device
x<-dev.off()