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

#Plot 1
png("plot1.png", width = 480, height = 480, units = 'px')
ChartTitle <- "Global Active Power"
X.Title <- "Global Active Power (kilowatts)"
with(Dataset,hist(Global_active_power, col = "red", cex.axis = 1, main = ChartTitle, cex.main = 1.2, xlab = X.Title, cex.lab = 1))
dev.off()