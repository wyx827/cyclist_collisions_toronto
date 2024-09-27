#### Preamble ####
# Purpose: Tests if all the datas contain the information we want
# Author: Yuxuan Wei
# Date: 26 Sep 2024
# Contact: shaw.wei@mail.utoronto.ca
# License: MIT
# Pre-requisites: None
# Any other information needed? None

#### Workspace setup ####
library(tidyverse)

# Load the dataset
data <- read_csv("data/analysis_data/cleaned_collision_data.csv")

#### Test 1: Check that the 'COLLISION_YEAR' column contains valid years ####
all(data$COLLISION_YEAR >= 2000 & data$COLLISION_YEAR <= as.numeric(format(Sys.Date(), "%Y")))

#### Test 2: Check that the 'HOUR' column contains valid hours ####
all(data$HOUR >= 0 & data$HOUR <= 23)

#### Test 3: Check that 'WEATHER' contains expected values ####
expected_weather <- c("Clear", "Adverse", "Unknown")
all(data$WEATHER %in% expected_weather)

#### Test 4: Check that 'VISIBILITY' contains expected values ####
expected_visibility <- c("Clear", "Rain", "Snow", "Fog", "Other", "Unknown")
all(data$VISIBILITY %in% expected_visibility)

#### Test 5: Check that 'LIGHT' contains expected values ####
expected_light <- c("Daylight", "Dark", "Dawn", "Dusk", "Unknown", "Other")
all(data$LIGHT %in% expected_light)

#### Test 6: Check that 'INJURY' contains expected values ####
expected_injury <- c("Fatal", "Major", "Minor", "Minimal", "None")
all(data$INJURY %in% expected_injury)

#### Test 7: Check that 'INVTYPE' contains only Pedestrian and Cyclist ####
expected_invtype <- c("Pedestrian", "Cyclist")
all(data$INVTYPE %in% expected_invtype)

#### Test 8: Check that 'COLLISION_DATE' is a valid date ####
all(!is.na(data$COLLISION_DATE))

#### Test 9: Check that 'COLLISION_TIME' is a valid datetime ####
all(!is.na(data$COLLISION_TIME))

#### Test 10: Check that 'ACCLASS' is not empty ####
all(!is.na(data$ACCLASS) & data$ACCLASS != "")

#### Test 11: Check that there is no N/A in the table #### 

all(!is.na(cleaned_data))

# Print results of all tests
test_results <- c(
  all(data$COLLISION_YEAR >= 2000 & data$COLLISION_YEAR <= as.numeric(format(Sys.Date(), "%Y"))),
  all(data$HOUR >= 0 & data$HOUR <= 23),
  all(data$WEATHER %in% expected_weather),
  all(data$VISIBILITY %in% expected_visibility),
  all(data$LIGHT %in% expected_light),
  all(data$INJURY %in% expected_injury),
  all(data$INVTYPE %in% expected_invtype),
  all(!is.na(data$COLLISION_DATE)),
  all(!is.na(data$COLLISION_TIME)),
  all(!is.na(data$ACCLASS) & data$ACCLASS != ""),
  all(!is.na(cleaned_data))
)

print(test_results)