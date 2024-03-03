#File : Module 2
#project : Introduction to Analytics
#Author : Kayal Chandrasekaran

rm(lists=ls())

dev.off()

# Importing and installing all the necessary packages
install.packages("FSAdata")
library(FSAdata)
install.packages("magrittr")
library(magrittr)
install.packages("dplyr")
library(dplyr)
install.packages("tidyr")
library(tidyr)
install.packages("plyr")
library(plyr)
install.packages("tidyverse")
library(tidyverse)
install.packages("plotrix")
library(plotrix)
install.packages("ggplot2")
library(ggplot2)
install.packages("scales")
library(scales)

# Importing the emissions.csv file and assigning it to originalemissions variable
getwd()
setwd("/Users/jasminejohn/Desktop/untitled folder")
list.files()
originalemissions = read.csv("emissions.csv",header=TRUE)
originalemissions

# Renaming a few column names as per convenience
colnames(originalemissions)[2] ="Country_Code"
colnames(originalemissions)[11] ="Per_Capita"

#Cleaning the data by removing all the null and empty values
newemissions <- na.omit(originalemissions)
newemissions

# Filtering the dataset to get last 10 years data from 2011 to 2021
newemissions <- filter(newemissions, Year >= 2011 & Year <= 2021, Country != "Global" & Country != "International")
newemissions

new2 <- filter(newemissions, Year >= 2011 & Year <= 2021, Country == "Global")
new2

# Displaying the summary of the dataset
summary(newemissions)


# Bar Graph to show TOTAL CO2 EMISSIONS BY COUNTRY FROM 2011-2021

emissions_by_country <- newemissions %>% group_by(Country) %>%
  summarise(Total_Emissions = sum(Total))

#Filtering the top 15 countries with the highest CO2 emissions
Num <- 15
countries <- emissions_by_country %>%
  arrange(desc(Total_Emissions)) %>%
  head(Num)

colors_1 <- colorRampPalette(c("#edc951","#eb6841","#cc2a36", "#4f372d", "#00a0b0"))

options(scipen = 999) #To set the right values for the Y-axis

bp <- barplot(countries$Total_Emissions, names.arg = countries$Country,
        col = colors_1(length(countries$Country)), cex.names = 0.8, width = 0.7, cex.axis = 0.8, cex.main = 1.2, cex.sub = 0.8,las = 2, ylab = "Total CO2 Emissions",
        main = paste("Top ", Num, " Countries with Highest CO2 Emissions"), ylim = c(0, max(countries$Total_Emissions) * 1.1))

legend("topright", legend = countries$Country, fill = colors_1(length(countries$Country)), x.intersp = 0.8, y.intersp = 0.7 ,title = "Top Countries",cex = 0.8)

text(x = bp, y = countries$Total_Emissions, labels = round(countries$Total_Emissions,0), pos = 3, cex = 0.8, col = "black")


#Pie chart
country_total <- aggregate(Total ~ Country, newemissions, sum)
country_total <- country_total[order(country_total$Total, decreasing = TRUE), ]
country_10 <- head(country_total, 10)

country_percent <- prop.table(country_10$Total) * 100

labels <- paste(country_10$Country, round(country_percent, 2), "%")

colors = c("#ffc404", "#cbaacb", "#ffccb6", "#ee9392", "#3b97b6", "#d24d55", "#ff968a", "#914363", "#aad4f4", "#d0d2df") 


# Creating the pie chart
pie(country_percent, labels = labels, main = "Top 10 countries contributing to CO2 emissions in percentages", col = colors, cex = 0.8, height = 100)

# Adding a legend to pie chart
legend("topleft", cex = 0.6, x.intersp = 1.6, y.intersp = 1.6,legend = country_10$Country, fill = colors)



#Stacked Bar graph for showing various resources used by countries which contributes to CO2 emissions.

df2 <- newemissions %>% select(-Country_Code, -Per_Capita, -Year, -Total)
ds <- df2 %>%
  gather(key = "Source", value = "Emissions", -Country)

top_countries <- ds %>%
  group_by(Country) %>%
  summarise(Total_Emissions = sum(Emissions)) %>%
  arrange(desc(Total_Emissions)) %>%
  top_n(10)

ds_10 <- ds %>%
  filter(Country %in% top_countries$Country)

ggplot(ds_10, aes(x = reorder(Country, -Emissions), y = Emissions)) +
  geom_bar(stat = "identity", aes(fill = Source)) +
  scale_fill_manual(values = c("#d11141", "#00b159", "#00aedb", "#f37735","#ffc425","#3d1e6d")) +
  labs(x = "Country", y = "CO2 Emissions", main = "Distribution of sources contributing to CO2 Emissions", fill = "Source", cex=0.6) +
  theme_bw() +
  theme(legend.position = "bottom", 
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

#Line graph


my_colors <- c("#00aedb","#d11141","#cbcacb","#E69F00", "#90ee90","#a7727d")

df_filtered <- new2 %>%
  select(Year, Coal, Oil, Gas, Cement, Flaring, Other)

# Unpivot the data
df_unpivot <- gather(df_filtered, key = "source", value = "value", -Year)

# Create line plot with circles at each year for all sources
ggplot(df_unpivot, aes(x = Year, y = value, color = source)) +
  geom_line() +
  geom_point(aes(fill = source), size = 2, shape = 21) +
  scale_x_continuous(breaks = seq(2011, 2021, by = 1)) +
  scale_color_manual(values = my_colors) +
  scale_fill_manual(values = my_colors) +
  labs(x = "Year", y = "CO2 Emissions (Mt)", 
       title = "Global CO2 Emissions by Fuel Type from 2011-2021") +
  theme_minimal() +
  theme(legend.position = "top", legend.title = element_blank())

# Cleaning up the variables 
rm(list=ls())
#clears the plots 
dev.off()

