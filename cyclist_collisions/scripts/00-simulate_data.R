#### Preamble ####
# Purpose: Simulates data
# Author: Yuxuan Wei
# Date: 26 Sep 2024
# Contact: shaw.wei@mail.utoronto.ca
# License: MIT
# Pre-requisites: None
# Any other information needed? None


#### Workspace setup ####
library(tidyverse)


#### Simulate data ####
set.seed(12345)

# Define the number of accidents and dates for simulation
start_date <- as.Date("2013-01-01")
end_date <- as.Date("2023-12-31")
number_of_rows <- 1000

# Define possible values for categorical variables
visibility_options <- c("Clear", "Rain", "Snow", "Fog", "Other")
light_options <- c("Daylight", "Dawn", "Dusk", "Dark")
rdsfcond_options <- c("Dry", "Wet", "Snow", "Ice", "Slush")
injury_options <- c("None", "Minor", "Major", "Fatal")
invtype_options <- c("Pedestrian", "Cyclist", "Driver", "Passenger")
initdir_options <- c("N", "S", "E", "W", "NE", "NW", "SE", "SW")
neighbourhood_options <- paste("Neighbourhood", 1:20)
division_options <- paste("Division", 1:5)

# Simulate random collision data
simulated_data <- tibble(
  DATE = as.Date(runif(number_of_rows, min = as.numeric(start_date), max = as.numeric(end_date)), origin = "1970-01-01"),
  TIME = format(as.POSIXct(runif(number_of_rows, min = 0, max = 86400), origin = "1970-01-01"), "%H:%M"),
  ACCLASS = sample(c("Collision", "Near Miss"), number_of_rows, replace = TRUE),
  VISIBILITY = sample(visibility_options, number_of_rows, replace = TRUE),
  LIGHT = sample(light_options, number_of_rows, replace = TRUE),
  RDSFCOND = sample(rdsfcond_options, number_of_rows, replace = TRUE),
  INJURY = sample(injury_options, number_of_rows, replace = TRUE, prob = c(0.6, 0.3, 0.08, 0.02)),
  INVTYPE = sample(invtype_options, number_of_rows, replace = TRUE),
  INITDIR = sample(initdir_options, number_of_rows, replace = TRUE),
  NEIGHBOURHOOD_158 = sample(neighbourhood_options, number_of_rows, replace = TRUE),
  DIVISION = sample(division_options, number_of_rows, replace = TRUE)
)

# Save simulated data
write_csv(simulated_data, file = "data/raw_data/simulated_collision_data.csv")

#### Create plots ####

# 1. Collisions by Year
collisions_by_year <- simulated_data %>%
  mutate(Year = format(DATE, "%Y")) %>%
  count(Year)

plot1 <- ggplot(collisions_by_year, aes(x = Year, y = n)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  labs(title = "Number of Collisions by Year", x = "Year", y = "Number of Collisions") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

print(plot1)

# 2. Collisions by Involved Type
plot2 <- ggplot(simulated_data, aes(x = INVTYPE, fill = INVTYPE)) +
  geom_bar() +
  labs(title = "Collisions by Involved Type", x = "Involved Type", y = "Count") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

print(plot2)

# 3. Injury Severity Distribution
plot3 <- ggplot(simulated_data, aes(x = INJURY, fill = INJURY)) +
  geom_bar() +
  labs(title = "Injury Severity Distribution", x = "Injury Severity", y = "Count") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

print(plot3)

# 4. Collisions by Time of Day
simulated_data$Hour <- as.numeric(substr(simulated_data$TIME, 1, 2))

plot4 <- ggplot(simulated_data, aes(x = Hour)) +
  geom_histogram(binwidth = 1, fill = "coral", color = "black") +
  labs(title = "Collisions by Hour of Day", x = "Hour", y = "Count") +
  theme_minimal() +
  scale_x_continuous(breaks = seq(0, 23, by = 2))

print(plot4)

# 5. Collisions by Road Surface Condition and Visibility
plot5 <- ggplot(simulated_data, aes(x = RDSFCOND, fill = VISIBILITY)) +
  geom_bar(position = "dodge") +
  labs(title = "Collisions by Road Surface Condition and Visibility", 
       x = "Road Surface Condition", y = "Count") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

print(plot5)