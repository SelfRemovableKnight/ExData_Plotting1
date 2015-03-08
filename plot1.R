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

# creating a png device
png(filename="plot1.png", height=480, width=480)

par(bg="transparent") # setting transparent background as in the example

# most parts of the graph can be constructed with the default hist function call
# the default x axis does not have the right labels, so I omit it here (axes = FALSE) and add it later
# the color of the given example looks most like orangered on my screen, if not perfectly 
# I add the title and the x axis label as in the example
# The x axis limit (0,7) makes sure the axis is long enough as in the example

hist(selecteddata$Global_active_power, axes = FALSE, col="orangered", main = "Global Active Power", xlim = c(0,7), ylim = c(0,1200), xlab = "Global Active Power (kilowatts)" )

# adding x axis with the right tickmarks and labels
axis(1, c(0,2,4,6), c(0,2,4,6))

# adding default Y axis
axis(2)

# closing png device
dev.off()
