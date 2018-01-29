sum_gva_by_sector <- function(combined_gva,
                              gva,
                              tourism,
                              charities) {

  check_class(combined_gva, "combined_gva")
  check_class(gva, "gva")
  check_class(tourism, "tourism")
  check_class(charities, "charities")



  gva_by_sector <- combined_gva %>%

    # initial summary by sector
    dplyr::group_by(year, sector) %>%
    dplyr::summarise(gva = sum(gva)) %>%

    #append total UK GVA by year
    dplyr::bind_rows(
      dplyr::filter(gva, sic == "year_total") %>%
        dplyr::mutate(sector = "UK") %>%
        dplyr::select(year, sector, gva = gva_2digit)
    ) %>%

    #append tourism data - add in by statement for transparency
    dplyr::bind_rows(
      dplyr::mutate(tourism, sector = "tourism") %>%
        dplyr::select(year, sector, gva)
    ) %>%

    #append charitites data
    dplyr::bind_rows(
      dplyr::mutate(charities, sector = "charities") %>%
        dplyr::select(year, sector, gva)
    )

  #add overlap info from tourism in order to calculate GVA for sector=all_dcms
  tourism_all_sectors <- dplyr::mutate(tourism, sector = "all_dcms") %>%
    dplyr::select(year, sector, overlap)

  #add overlap info from tourism in order to calculate GVA for sector=all_dcms
  charities_all_sectors <- dplyr::mutate(charities, sector = "all_dcms") %>%
    dplyr::select(year, sector, overlap)


  gva_by_sector <-
    dplyr::left_join(gva_by_sector, tourism_all_sectors, by = c("year", "sector")) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(gva = ifelse(!is.na(overlap), overlap + gva, gva)) %>%
    dplyr::select(-overlap)

  gva_by_sector <-
    dplyr::left_join(gva_by_sector, charities_all_sectors, by = c("year", "sector")) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(gva = ifelse(!is.na(overlap), overlap + gva, gva)) %>%
    dplyr::select(-overlap)

  #final clean up
  gva_by_sector <- gva_by_sector %>%
    dplyr::filter(year %in% 2010:max(attr(combined_gva, "years"))) %>%
    dplyr::select(sector, year, gva) %>%
    dplyr::arrange(year, sector) %>%
    data.frame()


  sectors_set <- c(
    "charities"   = "Civil Society (Non-market charities)",
    "creative"    = "Creative Industries",
    "culture"     = "Cultural Sector",
    "digital"     = "Digital Sector",
    "gambling"    = "Gambling",
    "sport"       = "Sport",
    "telecoms"    = "Telecoms",
    "tourism"     = "Tourism",
    "all_dcms"    = "All DCMS sectors",
    "perc_of_UK"  = "% of UK GVA",
    "UK"          = "UK"
  )

  # validation
  cols = rbind(
    data.frame(),
    list("sector", "character"),
    list("year", "integer"),
    list("gva", "numeric"),
    stringsAsFactors = FALSE
  )
  names(cols) <- c("name", "type")

  validate(
    gva_by_sector,
    cols = cols,
    class_name = "gva_by_sector"
  )

}
