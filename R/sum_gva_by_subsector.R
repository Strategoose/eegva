sum_gva_by_subsector <- function(combined_gva,
                              gva,
                              subsector) {

  check_class(combined_gva, "combined_gva")
  check_class(gva, "gva")

  gva_by_subsector <- combined_gva %>%

    # initial summary by sub_sector
    dplyr::filter(sector == subsector) %>%
    dplyr::group_by(year, sub_sector_categories) %>%
    dplyr::summarise(gva = sum(gva)) %>%
    dplyr::ungroup() %>%

    # append total sector GVA by year
    dplyr::bind_rows(
      combined_gva %>%
        dplyr::filter(sector == subsector) %>%
        dplyr::group_by(year) %>%
        dplyr::summarise(gva = sum(gva)) %>%
        dplyr::mutate(sub_sector_categories =
                 paste0(toupper(substr(subsector, 1, 1)),
                        substr(subsector, 2, nchar(subsector)))) %>%
        dplyr::select(year, sub_sector_categories, gva)
    ) %>%

    #append total UK GVA by year
    dplyr::bind_rows(
      dplyr::filter(gva, sic == "year_total") %>%
        dplyr::mutate(sub_sector_categories = "UK") %>%
        dplyr::select(year, sub_sector_categories, gva = gva_2digit)
    ) %>%

    #final clean up
    dplyr::filter(year %in% 2010:max(attr(combined_gva, "years"))) %>%
    #mutate(year = as.integer(year)) %>%
    dplyr::select(sub_sector_categories, year, gva) %>%
    dplyr::arrange(year, sub_sector_categories) %>%
    data.frame()



  # validation
  cols = rbind(
    data.frame(),
    list("sub_sector_categories", "character"),
    list("year", "integer"),
    list("gva", "numeric"),
    stringsAsFactors = FALSE
  )
  names(cols) <- c("name", "type")

  validate(
    gva_by_subsector,
    cols = cols,
    class_name = "gva_by_subsector"
  )

}
