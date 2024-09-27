#### Preamble ####
# Purpose: Downloads and saves the data from Open Data Toronto
# Author: Yuxuan Wei
# Date: 26 Sep 2024
# Contact: shaw.wei@mail.utoronto.ca
# License: MIT
# Pre-requisites: None
# Any other information needed? None

#### Workspace setup ####
library(opendatatoronto)
library(tidyverse)

#### Download data ####
# Get package
package <- show_package("0b6d3a00-7de1-440b-b47c-7252fd13929f")

# Get all resources for this package
resources <- list_package_resources("0b6d3a00-7de1-440b-b47c-7252fd13929f")

# Identify datastore resources in CSV format
datastore_resources <- filter(resources, tolower(format) %in% c('csv'))

# Load the first datastore resource as a sample
data <- filter(datastore_resources, row_number() == 1) %>% 
  get_resource()

#### Save data ####
write_csv(data, "data/raw_data/raw_collision_data.csv")

         
