year_sector_data_index <- function(x, log_level = futile.logger::WARN,
                             log_appender = "console",
                             log_issues = FALSE) {


  # Extract third column name

  value <- colnames(x)[(!colnames(x) %in% c('sector','year'))]

  # Check snsible range for year

 ectors_set <- c(
    "creative"    = "Creative Industries",
    "culture"    = "Cultural Sector",
    "digital"     = "Digital Sector",
    "gambling"    = "Gambling",
    "sport"       = "Sport",
    "telecoms"    = "Telecoms",
    "tourism"     = "Tourism",
    "all_dcms"    = "All DCMS sectors",
    "perc_of_UK"  = "% of UK GVA",
    "UK"          = "UK"
  )


  # add index for value column
  x <- x %>%
    # replaces values in sector with lookup in year_sector_data
    mutate(sector = factor(unname(sectors_set[as.character(sector)]))) %>%

    # calculate the index (index_year=100) variable
    group_by(sector) %>%
    mutate(indexGVA = GVA/max(ifelse(year == min(x$year), GVA, 0)) * 100)

  # Define the class here ----

  structure(
    list(
      df = x,
      colnames = colnames(x),
      type = colnames(x)[!colnames(x) %in% c('year','sector')],
      sector_levels = levels(x$sector),
      sectors_set = sectors_set,
      years = unique(x$year)
    ),
    class = "year_sector_data_index")
}
