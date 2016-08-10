## read top 5 rows including heading
tab5rows <- read.table("household_power_consumption.txt", header= TRUE, sep = ";", nrows = 50)

## read just the rows containing the period from 1/2/2007 to 2/2/2007
consume <- read.table("household_power_consumption.txt", header= FALSE, sep = ";", skip = 66637, nrows = 2881)

## copy headings over from patial files with top 5 rows
names(consume) <- names(tab5rows)
consume$Date <- paste(consume$Date, consume$Time)

## convert datetime to POSIXlt
consume$Date <- consume$Date%>%strptime("%d/%m/%Y %H:%M:%S")%>%as.POSIXlt()

## plot on screen device then followed by png device

par(mfrow = c(1,1))

plot(consume$Date,consume$Global_active_power, xlab = "", ylab = "Global Active Power (kilowatts)", type = "l")

png("plot2.png", 480, 480,)
plot(consume$Date,consume$Global_active_power, xlab = "", ylab = "Global Active Power (kilowatts)", type = "l")
dev.off()
