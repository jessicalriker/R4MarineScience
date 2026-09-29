# Script to wrangle sensor data

library(tidyverse)

#  Load sensor data, 
sensor_raw <- read_csv(here::here("data/workshop2/estuary_sonde_data.csv"))

# Check sensor data
head(sensor_raw)
str(sensor_raw)
glimpse(sensor_raw)
summary(sensor_raw)


### Clean up sensor data
sensor_data <- 
  sensor_raw |>
  mutate(
    # Parse the messy character string (Day/Month/Year Hour:Minute)
    datetime = dmy_hm(timestamp),
    # Convert the -999.0 hardware error to a true NA
    turbidity = na_if(turbidity, -999),
    # Convert negative salinity values to na
    salinity = ifelse(salinity < 0, NA, salinity),
  )

# Summarise 15-minute sonde data into daily means
sensor_daily <- 
  sensor_data |>
  mutate(date = as_date(floor_date(datetime, "day"))) |>
  group_by(site, date) |>
  summarise(
    mean_temp = mean(temperature, na.rm = TRUE),
    mean_salinity = mean(salinity, na.rm = TRUE),
    mean_turbidity = mean(turbidity, na.rm = TRUE),
    .groups = "drop")


# Load the primary data science framework and Excel import library
library(tidyverse)
library(readxl)
# Practice Import A: Loading a standard comma-separated plain text file
benthic_cover <- read_csv(here::here("data/workshop1/reef_cover_log.csv"))
# Practice Import B: Parsing a tab-separated telemetry instrument array string
acoustic_stream <- read_tsv(here::here("data/workshop1/acoustic_telemetry_stream.txt"))
# Practice Import C: Targeting a specific sheet in a multi-tab Excel spreadsheet
fisheries_annual <- read_excel(here::here("data/workshop1/fish_catch_data.xlsx"), sheet =
                                 "Commercial_2026")

# Read in mangrove_data
# mangrove_data <- read_csv(file = here::here("data/mangrove_survey_raw.csv"))

# Use args within read_csv to skip headers and declare missing flags
mangrove_data <- read_csv(
  here::here("data/workshop1/mangrove_survey_raw.csv"),
  skip = 5,   # Skip the first 5 lines of field notes
  na = c(".", "NA", "9999", "ND", "blank"))  # Convert known text alts to true NA

# Force a modern tibble to degrade into a legacy base R data frame structure
benthic_cover_df <- as.data.frame(benthic_cover)

# Print the old-style dataframe structure to view
print(benthic_cover_df)
# And compare with tibble alternative
print(benthic_cover)











