################################################################################
# PROJECT: Who Benefits from Food Tax Exemptions in Lower-Income Settings?
#          Evidence on Pass-Through and Incidence (PNG VAT exemptions)
#
# MASTER SCRIPT (R). Reproducibility package. Stage 2 of 3 (Stata -> R -> Stata).
#
# HOW TO RUN
#   1. Set ONE path below: `root` in Section 1. Nothing else changes.
#   2. Run this whole file. It installs packages and produces the maps.
#   3. Return to Code/main.do and press any key to resume the Stata analysis.
#
# Run main.do Section 4 (data preparation) BEFORE this script: it builds the
# Final/ datasets the maps read.
#
# Produces:
#   Figure 2  Outputs/Figures/figure_2.png   (2_maps/fig2_household_map.R)
#   Figure 1  Outputs/Figures/figure_1.png   (2_maps/fig1_store_proximity_map.R)
################################################################################

rm(list = ls()); gc()

################################################################################
# 1. SET DIRECTORIES  --  CHANGE ONLY THIS ONE LINE
################################################################################

root <- "/Users/rdoino/Library/CloudStorage/OneDrive-WBG/Desktop/VAT Exemption Through PNG"

# Derived paths (do not edit)
dir_data    <- file.path(root, "Data")
dir_figures <- file.path(root, "Outputs", "Figures")
dir_scripts <- file.path(root, "Code", "2_maps")

dir_data_raw       <- file.path(dir_data, "Raw")
dir_data_final     <- file.path(dir_data, "Final")
dir_data_raw_store <- file.path(dir_data_raw, "store_collection")
dir_data_final_store <- file.path(dir_data_final, "store_collection")

if (!dir.exists(dir_figures)) dir.create(dir_figures, recursive = TRUE)
setwd(dir_scripts)

cat("root:", root, "\n")

################################################################################
# 2. PACKAGES
################################################################################

required_packages <- c(
  "tidyverse", "sf", "ggplot2", "dplyr", "readr", "haven", "viridis",
  "scales", "RColorBrewer", "cowplot", "knitr", "readxl", "data.table", "osmdata"
)
for (pkg in required_packages) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
    library(pkg, character.only = TRUE)
  }
}

################################################################################
# 3. MAP + PROXIMITY SCRIPTS (paper exhibits only)
################################################################################

# Figure 2: national respondent map. Also writes
# Final/phone_survey/png_survey_by_district.dta (used by Table A2).
source("fig2_household_map.R", echo = FALSE)

# Figure 1: Port Moresby supermarket proximity map. Also writes
# proximity_tertile into Final/store_collection/POM_Prices_Long_Clean
# (used by the Stata store analysis).
source("fig1_store_proximity_map.R", echo = FALSE)


cat("\nR STAGE COMPLETE. Return to Code/main.do and press any key.\n")
################################################################################
# END
################################################################################
