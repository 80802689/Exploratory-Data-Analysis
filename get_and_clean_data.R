
# set working directory (change this to fit your needs)
setwd('~/Source Code/GitHub/Exploratory-Data-Analysis')

#
library(data.table)
library(lubridate)

#
if (!file.exists('source data')) {
  dir.create('source data')
}

# check to see if the existing tidy data set exists; if not, make it...
if (!file.exists('source data/power_consumption.txt')) {
  
  #
  file.url<-'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
  download.file(file.url,destfile='source data/power_consumption.zip')
  unzip('source data/power_consumption.zip',exdir='source data',overwrite=TRUE)

  #
  variable.class<-c(rep('character',2),rep('numeric',7))
  power.consumption<-read.table('source data/household_power_consumption.txt',header=TRUE,
                                sep=';',na.strings='?',colClasses=variable.class)
  power.consumption<-power.consumption[power.consumption$Date=='1/2/2007' | power.consumption$Date=='2/2/2007',]

  # clean up the variable names and convert date field
  cols<-c('Date','Time','GlobalActivePower','GlobalReactivePower','Voltage','GlobalIntensity',
          'SubMetering1','SubMetering2','SubMetering3')
  colnames(power.consumption)<-cols
  power.consumption$Date<-dmy(power.consumption$Date)

  #
  write.table(power.consumption,file='source data/power_consumption.txt',sep='|',row.names=FALSE)
}

if (file.exists('source data/household_power_consumption.txt')) {
  x<-file.remove('source data/household_power_consumption.txt')
}