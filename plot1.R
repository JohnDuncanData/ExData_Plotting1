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

#add Day name

powerdatadates$Day <- wday(as.Date(powerdatadates$Date), label=TRUE)

#turn columns to numeric

powerdatadates$Global_active_power <- as.numeric(powerdatadates$Global_active_power)
powerdatadates$Global_reactive_power <- as.numeric(powerdatadates$Global_reactive_power)
powerdatadates$Voltage <- as.numeric(powerdatadates$Voltage)
powerdatadates$Global_intensity <- as.numeric(powerdatadates$Global_intensity)
powerdatadates$Sub_metering_1 <- as.numeric(powerdatadates$Sub_metering_1)
powerdatadates$Sub_metering_2 <- as.numeric(powerdatadates$Sub_metering_2)
powerdatadates$Sub_metering_3 <- as.numeric(powerdatadates$Sub_metering_3)

#-------------------------------------------------------------------------

# Create Plot 1

plot1 <- hist(powerdatadates$Global_active_power, col = "red", xlab="Global Active Power (kilowatts)", main="Global Active Power") 

png(filename = "plot1.png", width = 480, height = 480)
plot(plot1,col = "red", xlab="Global Active Power (kilowatts)", main="Global Active Power")
dev.off()
