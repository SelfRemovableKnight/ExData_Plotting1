## Assuming the data zip file has been downloaded to the current directory
## It does not need to be unzipped yet

datafile <- unz("exdata_data_household_power_consumption.zip", "household_power_consumption.txt")

## The data file is sorted and the 2007 data is near the beginning, 
## within the first 10% of the file
## Therefore I can afford to read in the first 250000 lines only, reducing memory needs

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

# creating png device
png(filename="plot2.png", height=480, width=480)
par(bg="transparent") # transparent background, as in the example

# making a line plot, adjusting labels to match the example
with(selecteddata,plot(parsed_datetime,Global_active_power,type="l",xlab = "", ylab = "Global Active Power (kilowatts)"))

# closing png device
dev.off()
