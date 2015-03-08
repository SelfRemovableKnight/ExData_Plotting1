## Assuming the data zip file has been downloaded to the current directory
## It does not need to be unzipped yet

datafile <- unz("exdata_data_household_power_consumption.zip", "household_power_consumption.txt")

## The data file is sorted and the 2007 data is near the beginning, 
## within the first 10% of the file
## Therefore I can afford to read in the first 250000 lines only, reducing memory needs without much ado

inputdata <- read.delim(datafile, header = TRUE, sep =";", 
                     colClasses=c("character", "character", "numeric", "numeric", "numeric",
                                  "numeric","numeric","numeric","numeric"),
                     na.strings="?",nrows = 250000)

## converting date and time character strings to R Date and Datetime classes

parsed_datetime <- strptime(paste(inputdata[["Date"]], inputdata[["Time"]], sep= " "), format = "%d/%m/%Y %H:%M:%S")
parsed_date <- as.Date(inputdata[["Date"]], format = "%d/%m/%Y")

# making a new data set with the proper Date and Datetime replacing the character strings

formatteddata <- cbind(parsed_date, parsed_datetime, inputdata[,3:9])

# selecting only the two days that interest us

selecteddata <- formatteddata[parsed_date == as.Date("2007-02-01") | parsed_date == as.Date("2007-02-02"),]

# sanity check : we have 2880 observations, which is the number of minutes in 2 days

# make sure day labels derived from Date and Datetime are in English
Sys.setlocale("LC_TIME", "English") 

# creating a png device
png(filename="plot4.png", height=480, width=480)
par(bg="transparent") # setting transparent background as in the example

# need 2 columns and 2 rows, will fill them in the order top left, bottom left, top right, bottom right
par(mfcol=c(2,2))

# top left graph
with(selecteddata,plot(parsed_datetime,Global_active_power,type="l",xlab = "", ylab = "Global Active Power"))

# bottom left graph
# making a line plot, starting with the black lines (defaults are okay)
with(selecteddata,plot(parsed_datetime,Sub_metering_1,type="l",xlab = "", ylab = "Energy sub metering"))
# adding red and blue lines, in that order (so that red precedes black and blue precedes red, where graphs overlap)
lines(selecteddata$parsed_datetime,selecteddata$Sub_metering_2,col="red")
lines(selecteddata$parsed_datetime,selecteddata$Sub_metering_3,col="blue")
# adding legend without box in the top right
legend("topright", bty="n", lwd=1, col=c("black","red","blue"), legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3" ))

# top right graph : defaults except for axis labels
with(selecteddata,plot(parsed_datetime,Voltage,type="l",xlab = "datetime", ylab = "Voltage"))

# bottom right graph : defaults except for axis labels
with(selecteddata,plot(parsed_datetime,Global_reactive_power,type="l",xlab = "datetime", ylab = "Global_reactive_power"))

# closing the png device
dev.off()