### Exploratory Data Analysis Week 1 

### Plot 1

list.of.packages <- c("data.table")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(data.table)

list.of.packages <- c("lubridate")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(lubridate)

# Read the data

# Create a temporary directory to store the file

tf <- tempfile()
td <- tempdir()

# Load the file

zipData <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

download.file(zipData, tf, mode="wb")

#Unzip the zip file

FileNames <- unzip(tf, exdir=td)

#read the file as a table

powerdata <- fread(FileNames[1], sep="auto", dec=".")

#remove the "?" lines

powerdata1 <- subset(powerdata, Sub_metering_1 !="?")
powerdata2 <- subset(powerdata1, Sub_metering_2 !="?")
powerdataclean <- subset(powerdata2, Sub_metering_3 !="?")

# format Date as date

powerdataclean$Date <- as.Date(powerdataclean$Date, "%d/%m/%Y")

#filter for only 2007 02 01 and 2007 02 02

powerdatadates <- subset(powerdataclean, powerdataclean$Date == "2007-02-01" | powerdataclean$Date == "2007-02-02")

#make a Date/Time column

powerdatadates$DateTime <- as.POSIXct(paste(powerdatadates$Date, powerdatadates$Time), format="%Y-%m-%d %H:%M:%S")


#turn columns to numeric

powerdatadates$Global_active_power <- as.numeric(powerdatadates$Global_active_power)
powerdatadates$Global_reactive_power <- as.numeric(powerdatadates$Global_reactive_power)
powerdatadates$Voltage <- as.numeric(powerdatadates$Voltage)
powerdatadates$Global_intensity <- as.numeric(powerdatadates$Global_intensity)
powerdatadates$Sub_metering_1 <- as.numeric(powerdatadates$Sub_metering_1)
powerdatadates$Sub_metering_2 <- as.numeric(powerdatadates$Sub_metering_2)
powerdatadates$Sub_metering_3 <- as.numeric(powerdatadates$Sub_metering_3)

#-------------------------------------------------------------------------

# Create Plot 4
png(filename = "plot4.png", width = 480, height = 480)

par(mfrow=c(2,2))

plot2 <- plot(powerdatadates$DateTime, powerdatadates$Global_active_power, xlab="", ylab = "Global Active Frequency (kilowatts)", type = "l", lty=1)
plot5 <- plot(powerdatadates$DateTime, powerdatadates$Voltage, xlab="datetime", ylab = "voltage", type="l", lty=1)
plot3 <- plot(powerdatadates$DateTime, powerdatadates$Sub_metering_1, xlab="", ylab = "Energy sub metering", type = "l", lty=1) +lines(powerdatadates$DateTime, powerdatadates$Sub_metering_2, col="red") +lines(powerdatadates$DateTime, powerdatadates$Sub_metering_3, col="blue")
plot6 <-plot(powerdatadates$DateTime, powerdatadates$Global_reactive_power, xlab="datetime", ylab="Global_reactive_power", type="l", lty=1)
dev.off()
