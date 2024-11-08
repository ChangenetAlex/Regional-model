# Regional Model: Species Occurrence Extraction and Data Cleaning for ECOLOPES

## Overview

This project provides a simplified regional model for filtering and processing species occurrences from the Global Biodiversity Information Facility (GBIF) for use in the ECOLOPES model. The model retrieves occurrences for specified taxa within a 50 km buffer around a given geographic coordinate, cleans and standardizes the data, and assigns species to predefined functional groups (PFGs for plants and AFGs for animals). The output is a refined dataset of functional groups suitable for ecological modeling.

## Contents

* `RegionalModel.R`: Main R script for data extraction, cleaning, and processing.  
* `README.md`: Overview and instructions for using the script.  
* Required Data Files:
  * `Plants_TPL_database_part1.xlsx`, `Plants_TPL_database_part2.xlsx`, `Plants_TPL_database_part3.xlsx`: The Plant List (TPL) databases for standardized taxonomy matching.
  * `PFGs_species_traits.csv`: Trait data file defining plant functional groups (PFGs).
  * `AFGs_species_traits.csv`: Trait data file defining animal functional groups (AFGs).  
  
## Requirements

The script requires the following R packages. You can install them by running:
```
install.packages(c("rgbif", "dplyr", "CoordinateCleaner", "sf", "taxonlookup", "U.Taxonstand", "stringr", "openxlsx"))
```
## Instructions

### 1. Set Up GBIF Account Credentials

To access GBIF data, you need an account. Set your credentials at the top of `RegionalModel.R`:

```
user <- "YOUR_GBIF_USERNAME"
pwd <- "YOUR_GBIF_PASSWORD"
email <- "YOUR_GBIF_EMAIL"
```
### 2. Configure Study Area and Buffer
Define the centroid coordinates for your study area and the buffer radius (default is 50 km):

```
site_centroid_coords <- c(latitude, longitude)  # Replace with your centroid's latitude and longitude
buffer_radius <- 50000  # Adjust buffer radius as needed
```
### 3. Load Required Trait Databases

Ensure the following files are in the same directory as the script, or update the file paths within the script if stored elsewhere:

* `Plants_TPL_database_part1.xlsx`, `Plants_TPL_database_part2.xlsx`, `Plants_TPL_database_part3.xlsx`: Used for plant taxonomy standardization.  
* `PFGs_species_traits.csv`: Trait data file for plant functional groups.  
* `AFGs_species_traits.csv`: Trait data file for animal functional groups.  

### 4. Run the Script

Execute `RegionalModel.R` in R or RStudio. The script performs the following main steps:

* Extract Species Occurrences: Uses GBIF API to download species occurrences within the specified buffer for plants and animals.  
* Clean Data: Filters out records with missing data, low precision, fossils, duplicate coordinates, and marine records.  
* Standardize Plant Taxonomy: Matches plant species to standardized names using The Plant List (TPL).  
* Assign Functional Groups:  
  * For plants, assigns species to predefined plant functional groups (PFGs).
  * For animals, assigns species to animal functional groups (AFGs).

### 5. Outputs
The final lists, `pfgs_list` and `afgs_list`, contain the functional groups around the specified location, ready for input into the ECOLOPES model. You may save these lists as CSV files or directly use them in further analyses.



