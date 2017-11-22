#Check for data availability. If not, download file.
filename <- "exdata_data_household_power_consumption.zip"
if(!file.exists(filename)){
  Location1 <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(Location1, filename, mode = "wb", cacheOK = FALSE)
  rm(Location1)
}
if(!file.exists("UCI HAR Dataset")) {
  unzip(filename)
}
rm(filename)

#Import and Subset Data in R
Dataset <- read.table("./household_power_consumption.txt",sep = ";",header = T)
LogicalDate <- Dataset$Date == "1/2/2007" |  Dataset$Date == "2/2/2007"
Dataset <- subset(Dataset, LogicalDate)
row.names(Dataset) <- 1:nrow(Dataset)
rm(LogicalDate)

#Format Date and Time columns
Dataset$Date <- strptime(paste(Dataset$Date,Dataset$Time,sep = ""),"%d/%m/%Y %H:%M:%S")
Dataset <- subset(Dataset,select = -c(Time))

#Format Other Columns as Numeric
Dataset[ ,2:ncol(Dataset)] <- apply(Dataset[ ,2:ncol(Dataset)], 2, function(x) as.numeric(x))

png("plot4.png", width = 480, height = 480, units = 'px')
par(mfrow = c(2, 2))

#Plot 1
Y.Title <- "Global Active Power"
with(Dataset,plot(y = Global_active_power, x = Date, type = "l",
                  ylab = Y.Title, xlab = ""))

#Plot 2
with(Dataset,plot(y = Voltage, x = Date, type = "l", xlab = "datetime"))

#Plot 3
Y.Title <- "Energy sub metering"
with(Dataset,plot(y = Sub_metering_1, x = Date, col = "black",
                  type = "l", ylab = Y.Title, xlab = ""))
with(Dataset, lines(y = Sub_metering_2, x = Date, col = "red"))
with(Dataset, lines(y = Sub_metering_3, x = Date, col = "blue"))
legend("topright", lty=c(1,1), col = c("black","blue","red"), legend = names(Dataset)[6:8], bty = "n")

#Plot 4
with(Dataset,plot(y = Global_reactive_power, x = Date, type = "l", xlab = "datetime"))

dev.off()
