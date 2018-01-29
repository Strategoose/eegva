# install devtools for development
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

# THERE IS SENSITIVE DATA IN INST
#
# scrap the subsector for now
# just get it up on github with instructions for penny to check
#
# tell penny I wasted a bunch of time rounding the numbers because I forgot
# that it was actually only excel rounding the numbers.
#
#
# set up for development or production =========================================

production <- FALSE

# this updates the package used in both the package and the control script
# there are a number of packages like rcpp which cannot be updated - probably
# need to use a private repo.
update.packages()

if (production) {
  #install_github()
  library(ee_gva)
} else {

  # need %>% loaded during devlopment
  library(magrittr)

  # load my R scripts
  devtools::load_all()
}

# extract excel data ===========================================================

# update sic mappings - probably easiest to maintain as an excel file
# sic_mappings <- read.csv("inst/sic_mappings.csv")
# save(sic_mappings, file = "data/sic_mappings.rda")

# if below gives errors saying file doesn't exist try closing and starting again
# it seems like it could be the network causing problems occasionally.
path <- "G:/Economic Estimates/2017 publications/November publication/GVA - current/Working_file_dcms_V11 2016 Data.xlsx"
sic91 = extract_sic91(path)
abs = extract_abs(path)
gva = extract_gva(path)
tourism = extract_tourism(path)
charities = extract_charities(path)


# update dummy data ============================================================

#need to update this to return dataframe
randomise_data <- function (df) {
  df_colnames <- names(df)[! names(df) %in% c("year", "sic")]
  df[, df_colnames] <-
    lapply(
      df_colnames,
      function(x) floor(runif(nrow(df),0,1000)) + 0.12345)
  return(df)
}

df_list <- c("abs", "charities", "gva", "sic91", "tourism")

for (df in df_list){
  dummy_path <- file.path("data", paste0(df,".rda"))
  assign(df, randomise_data(get(df)))
  save(list = df, file = dummy_path)
}
rm(list = ls())
df_list <- c("abs", "charities", "gva", "sic91", "tourism")
for (df in df_list){
  dummy_path <- file.path("data", paste0(df,".rda"))
  load(dummy_path)
}


# combine excel data ===========================================================

combined_gva <- combine_gva_extracts(
  abs = abs,
  gva = gva,
  sic91 = sic91
)

# overlap <- overlap_table(combined_GVA)
# write.csv(overlap, "G:/Economic Estimates/Rmarkdown/overlap.csv")


# group and summarise data =====================================================

# gva by subsector:
# summarises by year and subsector
# adds sector and uk totals by year
for (sector in c("creative", "culture", "digital", "gambling", "sport", "telecoms")) {
  assign(
    paste0("gva_by_", sector, "_subsector"),
    sum_gva_by_subsector(
      combined_gva = combined_gva,
      gva = gva,
      subsector = sector
    )
  )
}

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

# create summary tables --------------------------------------------------------

# Sector title mapping
# sector_lookup = rbind(
#   data.frame(),
#   list("charities", "Civil Society (Non-market charities)", 1),
#   list("creative", "Creative Industries", 2),
#   list("culture", "Cultural Sector", 3),
#   list("digital", "Digital Sector", 4),
#   list("gambling", "Gambling", 5),
#   list("sport", "Sport", 6),
#   list("telecoms", "Telecoms", 7),
#   list("tourism", "Tourism", 8),
#   list("all_dcms", "All DCMS sectors", 9),
#   list("uk_pc", "% of UK GVA", 10),
#   list("UK", "UK", 11),
#
#   stringsAsFactors = FALSE
# )
# names(sector_lookup) <- c("working_name", "output_name", "row_postition")
# write.csv(sector_lookup, "data/sector_lookup.csv")
sector_lookup <- read.csv("data/sector_lookup.csv", stringsAsFactors = FALSE)

subsector_lookup_digital <- read.csv("data/digital_subsector_lookup.csv", stringsAsFactors = FALSE)
subsector_lookup_creative <- read.csv("data/creative_subsector_lookup.csv", stringsAsFactors = FALSE)
subsector_lookup_culture <- read.csv("data/culture_subsector_lookup.csv", stringsAsFactors = FALSE)

# Digital subsector title mapping
digital_subsector_lookup = rbind(
  data.frame(),
  list("charities", "Civil Society (Non-market charities)", 1),
  list("creative", "Creative Industries", 2),
  list("culture", "Cultural Sector", 3),
  list("digital", "Digital Sector", 4),
  list("gambling", "Gambling", 5),
  list("sport", "Sport", 6),
  list("telecoms", "Telecoms", 7),
  list("tourism", "Tourism", 8),
  list("all_dcms", "All DCMS sectors", 9),
  list("uk_pc", "% of UK GVA", 10),
  list("UK", "UK", 11),

  stringsAsFactors = FALSE
)
names(sector_lookup) <- c("working_name", "output_name", "row_postition")

# sector tables
sector_table <- sector_table(gva_by_sector)
sector_table_indexed <- sector_table(gva_by_sector, indexed = TRUE)

# sub sector tables - work in progress
# sum_gva_by_subsector(
#   combined_gva = combined_gva,
#   gva = gva,
#   subsector = "digital"
# )




# excel output -----------------------------------------------------------------

excel_filename <- "DCMS_Sectors_Economic_Estimates_Template.xlsx"

wb <- openxlsx::loadWorkbook(file = paste0("inst/", excel_filename))

# 3.1 - GVA (£m)
openxlsx::writeData(wb, 2, x = sector_table, startCol = 1, startRow = 6)

# 3.1a - GVA (2010=100)
openxlsx::writeData(wb, 3, x = sector_table_indexed, startCol = 1, startRow = 6)

openxlsx::saveWorkbook(wb, file.path("~", "DCMS_Sectors_Economic_Estimates.xlsx"), overwrite = TRUE)


# create charts - work in progress

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
