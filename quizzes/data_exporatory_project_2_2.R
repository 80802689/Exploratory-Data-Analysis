
# Question 2
# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
# (fips == '24510') from 1999 to 2008? Use the base plotting system to make 
# a plot answering this question.

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
NEI<-data.table(readRDS('./data/emissions analysis/summarySCC_PM25.rds')[,c(1,4,6)])
NEI<-NEI[NEI$fips == '24510',] # baltimore...
NEI<-NEI[,lapply(.SD,sum),by=c('year','fips')]

# open device
png(filename='data/emissions analysis/plot2.png',width=480,height=480,units='px')

# plot line (trend) data to answer above question
plot(NEI$year,NEI$Emissions,ylab='YOY Emissions (Tons)',xlab='Emissions Testing Year',
     type='o',pch=5,col='blue',lwd=3,main='Baltimore YOY Emissions')
mdl <- lm(NEI$Emissions ~ NEI$year)
abline(mdl, col='red',lwd=3,lty='dotted')
legend('bottomleft',legend=c('Emissions','Trend'),col=c('blue','red'),lty=c('solid','dotted'))

# close device
x<-dev.off()