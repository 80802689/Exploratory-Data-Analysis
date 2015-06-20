
# Question 4
# Across the United States, how have emissions from coal combustion-related 
# sources changed from 1999-2008? Upload a PNG file containing your plot addressing this question.

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
NEI<-data.table(readRDS('./data/emissions analysis/summarySCC_PM25.rds')[,c(2,4,6)])
setkey(NEI,SCC)
SCC<-data.table(readRDS('./data/emissions analysis/Source_Classification_Code.rds')[,c(1,4)])
setkey(SCC,SCC)
NEI<-merge(NEI,SCC)

# limit to coal combustion source
NEI<-subset(NEI, grepl('^Fuel Comb+ (.*) Coal+',EI.Sector))
NEI<-NEI[,c(2,3),with=FALSE]
NEI<-NEI[,lapply(.SD,sum),by=c('year')]

# open device
png(filename='data/emissions analysis/plot4.png',width=480,height=480,units='px')

# plot line (trend) data to answer above question
plot(NEI$year,NEI$Emissions,ylab='YOY Emissions (Tons)',xlab='Emissions Testing Year',
     type='o',pch=5,col='blue',lwd=3,main='US YOY Coal Combustion Emissions')
mdl <- lm(NEI$Emissions ~ NEI$year)
abline(mdl, col='red',lwd=3,lty='dotted')
legend('bottomleft',legend=c('Emissions','Trend'),col=c('blue','red'),lty=c('solid','dotted'))

# close device
x<-dev.off()