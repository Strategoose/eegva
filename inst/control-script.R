# This script uses the package functions to run through the necessary steps to produce the outputs for the statistical publication


# notes / to do ================================================================
# does system.file() work for excel templates when package uninstalled - test changing template - yes, system.file() seems to take account of whether devtools::load_all() or library has been used
# cant use GCP for testing in fresh environment as I dont think will be able to save and access excel output? could test everything else though.
# add tests to validate dummy data, so it is same as extracts
# build in more stuff to hadle the years
# and CI
# and tests


# useful code for development ==================================================

# devtools::install_github("dcmsstats/eegva")
# remove.packages("eegva") then restart studio, test with eegva::gva and library(eegva)
# run <- "development"
# publication_year <- 2016


# Making note of package dependencies ==========================================

# install tools for development
# install.packages("devtools")
# install.packages("roxygen2")
# install.packages("testthat")


# add dependencies for my package
# install.packages("openxlsx")
# install.packages("dplyr")
# install.packages("tidyr")
# install.packages("magrittr")


# devtools::use_package("openxlsx")
# devtools::use_package("dplyr")
# devtools::use_package("tidyr")
# devtools::use_package("magrittr")
# devtools::use_package("testthat", "Suggests")

# devtools::use_travis()
# devtools::use_appveyor()
# devtools::use_coverage()
# devtools::use_mit_license()

# there are a number of packages like rcpp which cannot be updated on my laptop - probably security restrictions so need to use need to use a private repo.
# update.packages()


# set up =======================================================================

# run can either be "development", "production", or "test"
if (!run %in% c("development", "production", "test")) {
  stop("check run has been set correctly")
}

# specify path to raw data excel file
if (publication_year == 2016) {
  if (.Platform$OS.type == 'unix') {
    path <- "/Volumes/Data/EAU/Statistics/Economic Estimates/2017 publications/November publication/GVA - current/Working_file_dcms_V11 2016 Data.xlsx"
  } else {
    path <- "G:/Economic Estimates/2017 publications/November publication/GVA - current/Working_file_dcms_V11 2016 Data.xlsx"
  }
}
if (publication_year == 2018) {
 # if (.Platform$OS.type == 'unix') {
  #  path <- "/Volumes/Data/EAU/Statistics/Economic Estimates/2017 publications/November publication/GVA - current/Working_file_dcms_V11 2016 Data.xlsx"
  #} else {
    path <- "G:/Economic Estimates/2019 publications/GVA/TestDevelopment/DP_Working_file_dcms_V11 2018 Data Test.xlsx"
 # }
}


if (run == "production" | run == "test") library(eegva)
if (run == "development") devtools::load_all()


# extract excel data ===========================================================

# update sic mappings - probably easiest to maintain as an excel file
# sic_mappings <- read.csv("inst/sic_mappings.csv")
# save(sic_mappings, file = "data/sic_mappings.rda")


# NOTE: THESE READ.XLSX OFTEN ERRORS SAYING THE FILE DOES NOT EXIST. NAVIGATING
# TO THE FILE IN WINDOWS EXPLORER USUALLY FIXES THIS.
if (run == "development" | run == "production") {
  abs = extract_abs(path)
  charities = extract_charities(path)
  gva = extract_gva(path)
  sic91 = extract_sic91(path)
  tourism = extract_tourism(path)
}
if (run == "test") {
  abs = eegva::abs
  charities = eegva::charities
  gva = eegva::gva
  sic91 = eegva::sic91
  tourism = eegva::tourism
}


# combine excel data ===========================================================

combined_gva <- combine_gva_extracts(
  abs = abs,
  gva = gva,
  sic91 = sic91
)


# aggregate data ===============================================================

# gva by sector:
# summarises by year and sector
# adds uk totals by year
# appends tourism and charities rows for each year
# left join tourism and charities overlap to remove overlap from all_dcms category
gva_by_sector <- sum_gva_by_sector(
  combined_gva = combined_gva,
  gva = gva,
  tourism = tourism,
  charities = charities
)

# gva by subsector:
# summarises by year and subsector
# adds sector and uk totals by year
temp_sectors <-
  c("creative", "culture", "digital", "gambling", "sport", "telecoms")
for (sector in temp_sectors) {
  assign(
    paste0("gva_by_subsector_", sector),
    sum_gva_by_subsector(
      combined_gva = combined_gva,
      gva = gva,
      subsector = sector
    )
  )
}


# create summary tables ========================================================

# sector title lookup
# sector_lookup <-
#   read.csv(
#     system.file(
#       "extdata", "sector_lookup.csv", package = "eegva"),
#     stringsAsFactors = FALSE)
# devtools::use_data(sector_lookup)

# subsector title lookups
for (sector in c("creative", "culture", "digital")) {
  assign(
    paste0("subsector_lookup_", sector),
    read.csv(
      system.file(
        "extdata", paste0("subsector_lookup_", sector, ".csv"), package = "eegva"),
      stringsAsFactors = FALSE)
  )
}


# sector tables
sector_table <- sector_table(gva_by_sector)
sector_table_indexed <- sector_table(gva_by_sector, indexed = TRUE)

# sub sector tables - work in progress
# sum_gva_by_subsector(
#   combined_gva = combined_gva,
#   gva = gva,
#   subsector = "digital"
# )


# excel output =================================================================

excel_filename <-
  system.file(
    "DCMS_Sectors_Economic_Estimates_Template.xlsx", package = "eegva")

wb <- openxlsx::loadWorkbook(file = excel_filename)

# update sheet "3.1 - GVA (£m)"
openxlsx::writeData(wb, 2, x = sector_table, startCol = 1, startRow = 6)

# update sheet "3.1a - GVA (2010=100)"
openxlsx::writeData(wb, 3, x = sector_table_indexed, startCol = 1, startRow = 6)

openxlsx::saveWorkbook(
  wb, file.path("~", "DCMS_Sectors_Economic_Estimates.xlsx"), overwrite = TRUE)


# create charts - work in progress =============================================

# # produce figure 3.1
# fig31 <- figure3.1(GVA_by_sector2) +
#   ggplot2::ggtitle(paste0('Figure 3.1: GVA contribution by DCMS sectors: ', GVA_by_sector2$years))
#
# # produce figure 3.2
# fig32 <- figure3.2(GVA_by_sector2) +
#   ggplot2::ggtitle(paste0('Figure 3.2: Indexed growth in GVA (2010 = 100)\n in DCMS sectors and UK: ', GVA_by_sector2$years))
#
# # produce figure 3.3
# fig33 <- figure3.3(GVA_by_sector2) +
#   ggplot2::ggtitle(paste0('Figure 3.3: Indexed growth in GVA (2010 = 100) in each DCMS sector: ', GVA_by_sector2$years))
