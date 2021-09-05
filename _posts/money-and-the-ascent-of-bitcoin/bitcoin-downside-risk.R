################################################################################
####   This is the code that I used to generate the plot in which I show    ####
####   Bitcoin's Price and Downside Risk together in the following post:    ####
####   https://zerointerest.ch/money-and-the-ascent-of-bitcoin/             ####
####                                                                        ####
####   Data Source:                                                         ####
####          https://www.investing.com/crypto/bitcoin/historical-data      ####
################################################################################


# Read and format the data

btc_to_usd <- read.csv("btcdata.csv", stringsAsFactors=FALSE)

colnames(btc_to_usd)[1] <- "Date"
colnames(btc_to_usd)[7] <- "Change_percent"

btc_to_usd$Change_percent <- as.numeric(sub("%", "", btc_to_usd$Change_percent))
btc_to_usd$Change <- btc_to_usd$Change_percent/100

btc_to_usd$Date <- as.Date(btc_to_usd$Date, format =  "%b %d, %Y")

btc_to_usd <- btc_to_usd[(order(btc_to_usd$Date)),]
btc_to_usd$DownsideDeviation <- NA

btc_to_usd$Price <- as.numeric(sub(',', '', btc_to_usd$Price, fixed = TRUE))


#Compute the Downside deviation

library("PerformanceAnalytics")


# N = 1 years
N = 1
days = 365 * N


for (i in days:nrow(btc_to_usd)) {
  btc_to_usd$DownsideDeviation[i] <- DownsideDeviation(btc_to_usd$Change[(i - days + 1):i])
}

btc_to_usd$AnnualizedDownsideDeviation <- btc_to_usd$DownsideDeviation * sqrt(365)



# Load plotting libraries

library(ggplot2)
library(ggthemes)
library(scales)

# Plotting the downside Deviation

ggplot(btc_to_usd, aes(x=Date, y=DownsideDeviation)) +
  geom_path() + 
#  geom_smooth(method = "gam") +
  xlab("") +
  theme_fivethirtyeight() +
#  theme(panel.background = element_rect(fill = 'white'), plot.background = element_rect(fill = "white")) +
  scale_x_date(date_breaks = "1 year", date_labels =  "%Y") +
  labs(title = "Bitcoin Downside Risk", subtitle = "Historical Annualized Downside Deviation (N = 1 year)",
       caption = "Data source: Investing.com")
  

# Plotting the Downside Deviation + Bitcoin Price (dual axis: left corresponds to price, right to deviation)

library(hrbrthemes)
ggplot(btc_to_usd, aes(x=Date)) +
  geom_line( aes(y=DownsideDeviation*770000), color = "#17becf", size = 1.1) + 
  geom_line( aes(y=Price), size = 0.9, color = "#7f7f7f") +
  scale_y_continuous(
    name = "Price (USD)",
    sec.axis = sec_axis(~./770000, name = "Annualized Downside Deviation (N = 1 year)")) +
  scale_x_date(date_breaks = "1 year", date_labels =  "%Y") +
  theme_fivethirtyeight() +
  labs(title = "Bitcoin Downside Risk",
       caption = "Data source: Investing.com")

 

