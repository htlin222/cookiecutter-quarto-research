# 02_data_cleaning.R
# Purpose: Clean and prepare data for analysis
# Author: {{ cookiecutter.author_name }}
# Date: {{ cookiecutter.year }}

# Load required packages
library(tidyverse)
library(lubridate)
library(naniar)

# Function to check for missing values
check_missing <- function(data, threshold = 0.05) {
  missing_summary <- data %>%
    miss_var_summary() %>%
    filter(pct_miss > threshold * 100)
  
  if (nrow(missing_summary) > 0) {
    message("Variables with > ", threshold * 100, "% missing:")
    print(missing_summary)
  } else {
    message("No variables exceed missing threshold of ", threshold * 100, "%")
  }
  
  return(missing_summary)
}

# Function to clean numeric variables
clean_numeric <- function(x, min_val = NULL, max_val = NULL) {
  x <- as.numeric(x)
  
  # Remove implausible values
  if (!is.null(min_val)) {
    x[x < min_val] <- NA
  }
  if (!is.null(max_val)) {
    x[x > max_val] <- NA
  }
  
  return(x)
}

# Function to clean date variables
clean_dates <- function(x, format = "%Y-%m-%d", min_date = "1900-01-01", max_date = Sys.Date()) {
  x <- as.Date(x, format = format)
  
  # Remove implausible dates
  x[x < as.Date(min_date) | x > as.Date(max_date)] <- NA
  
  return(x)
}

# Function to create categorical variables from numeric
categorize_numeric <- function(x, breaks, labels, include.lowest = TRUE, right = FALSE) {
  cut(x, breaks = breaks, labels = labels, 
      include.lowest = include.lowest, right = right)
}

# Main data cleaning function
clean_data <- function(data) {
  cleaned_data <- data %>%
    # Remove duplicate rows
    distinct() %>%
    
    # Example cleaning operations (modify as needed):
    # mutate(
    #   # Clean age variable
    #   age = clean_numeric(age, min_val = 0, max_val = 120),
    #   
    #   # Create age categories
    #   age_group = categorize_numeric(
    #     age,
    #     breaks = c(0, 18, 45, 65, Inf),
    #     labels = c("< 18", "18-44", "45-64", "65+")
    #   ),
    #   
    #   # Clean dates
    #   enrollment_date = clean_dates(enrollment_date),
    #   
    #   # Standardize categorical variables
    #   gender = str_to_title(gender),
    #   gender = case_when(
    #     gender %in% c("M", "Male") ~ "Male",
    #     gender %in% c("F", "Female") ~ "Female",
    #     TRUE ~ NA_character_
    #   )
    # ) %>%
    
    # Remove rows with missing key variables
    # filter(!is.na(id))
    
    identity()  # Placeholder - remove when adding actual cleaning steps
  
  # Check data quality
  message("\nData cleaning summary:")
  message("Original rows: ", nrow(data))
  message("Cleaned rows: ", nrow(cleaned_data))
  message("Rows removed: ", nrow(data) - nrow(cleaned_data))
  
  # Check for remaining missing values
  check_missing(cleaned_data)
  
  return(cleaned_data)
}

# Example usage:
# cleaned_main_data <- clean_data(main_data)
# saveRDS(cleaned_main_data, here::here("data", "processed", "cleaned_main_data.rds"))