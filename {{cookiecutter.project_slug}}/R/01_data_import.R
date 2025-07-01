# 01_data_import.R
# Purpose: Import raw data from CSV files
# Author: {{ cookiecutter.author_name }}
# Date: {{ cookiecutter.year }}

# Load required packages
library(tidyverse)
library(readr)
library(janitor)

# Define data directory
data_dir <- here::here("data", "raw")

# Function to read CSV files with error handling
read_data <- function(file_name, ...) {
  file_path <- file.path(data_dir, file_name)
  
  if (!file.exists(file_path)) {
    stop(paste("File not found:", file_path))
  }
  
  tryCatch({
    data <- read_csv(file_path, ...) %>%
      clean_names()
    
    message(paste("Successfully loaded:", file_name))
    message(paste("Dimensions:", nrow(data), "rows x", ncol(data), "columns"))
    
    return(data)
  }, error = function(e) {
    stop(paste("Error reading", file_name, ":", e$message))
  })
}

# Function to read multiple CSV files
read_multiple_files <- function(pattern = "*.csv") {
  files <- list.files(data_dir, pattern = pattern, full.names = TRUE)
  
  if (length(files) == 0) {
    warning(paste("No files found matching pattern:", pattern))
    return(list())
  }
  
  data_list <- lapply(files, function(f) {
    read_data(basename(f))
  })
  
  names(data_list) <- tools::file_path_sans_ext(basename(files))
  
  return(data_list)
}

# Example usage (uncomment and modify as needed):
# main_data <- read_data("main_dataset.csv")
# demographic_data <- read_data("demographics.csv")
# 
# # Or read all CSV files at once
# all_data <- read_multiple_files()

# Save imported data for use in other scripts
# saveRDS(main_data, here::here("data", "processed", "main_data.rds"))