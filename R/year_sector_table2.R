year_sector_table2 <- function(gva_by_subsector) {

    total2016 <- gva_by_subsector %>%
      dplyr::filter(sub_sector_categories == "UK" & year == 2016) %>%
      data.frame()

    df <- gva_by_subsector %>%
      dplyr::group_by(sub_sector_categories) %>%
      tidyr::spread(key = year, value = gva) %>%
      dplyr::mutate(change1516 = (`2016` / `2015` - 1) *100) %>%
      dplyr::mutate(change1015 = (`2016` / `2010` - 1) *100) %>%
      dplyr::mutate(ukperc = 100 * `2016` / total2016$gva) %>%

      dplyr::rename(
        `Sub-sector` = sub_sector_categories,
        `% change 2015 - 2016` = change1516,
        `% change 2010 - 2016` = change1015,
        `% of UK GVA 2016` = ukperc
      )
}
