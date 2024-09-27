#### Preamble ####
# Purpose: Cleans the raw collision data
# Author: Yuxuan Wei
# Date: 26 Sep 2024
# Contact: shaw.wei@mail.utoronto.ca
# License: MIT
# Pre-requisites: None
# Any other information needed? None

#### Workspace setup ####
library(tidyverse)
library(lubridate)

#### Clean data ####
raw_data <- read_csv("data/raw_data/raw_collision_data.csv")

# Select relevant columns and clean data
cleaned_data <- raw_data %>%
  select(
    DATE, TIME, ACCLASS, VISIBILITY, LIGHT, RDSFCOND, 
    INJURY, INVTYPE, INITDIR, NEIGHBOURHOOD_158, DIVISION
  ) %>%
  mutate(
    COLLISION_DATE = as.Date(DATE, format = "%Y/%m/%d"),
    COLLISION_YEAR = year(COLLISION_DATE),
    COLLISION_TIME = parse_date_time(paste(DATE, TIME), "ymd HM"),
    HOUR = hour(COLLISION_TIME),
    WEATHER = case_when(
      RDSFCOND == "Dry" ~ "Clear",
      RDSFCOND %in% c("Wet", "Slush", "Snow", "Ice") ~ "Adverse",
      TRUE ~ "Unknown"
    ),
    VISIBILITY = case_when(
      VISIBILITY %in% c("Clear", "Rain", "Snow", "Fog", "Other") ~ VISIBILITY,
      is.na(VISIBILITY) ~ "Unknown",
      TRUE ~ "Other"
    ),
    LIGHT = case_when(
      LIGHT %in% c("Daylight", "Dark", "Dawn", "Dusk") ~ LIGHT,
      is.na(LIGHT) ~ "Unknown",
      TRUE ~ "Other"
    ),
    INJURY = replace_na(INJURY, "None"),
    NEIGHBOURHOOD = NEIGHBOURHOOD_158
  ) %>%
  select(-DATE, -TIME, -RDSFCOND, -NEIGHBOURHOOD_158) %>%
  filter(!is.na(HOUR))  # Remove rows with invalid HOUR

# Filter for pedestrian and cyclist collisions
pedestrian_cyclist_data <- cleaned_data %>%
  filter(INVTYPE %in% c("Pedestrian", "Cyclist"))

#### Save cleaned data ####
write_csv(pedestrian_cyclist_data, "data/analysis_data/cleaned_collision_data.csv")

# Print summary to check the cleaning results
print(summary(pedestrian_cyclist_data))
print(table(pedestrian_cyclist_data$VISIBILITY))
print(table(pedestrian_cyclist_data$LIGHT))
print(table(pedestrian_cyclist_data$INJURY))
print(range(pedestrian_cyclist_data$HOUR, na.rm = TRUE))

# Print unique values in LIGHT column
print("Unique values in LIGHT column:")
print(unique(pedestrian_cyclist_data$LIGHT))