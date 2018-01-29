combine_gva_extracts <- function(abs, gva, sic91) {

  check_class(abs, "abs")
  check_class(gva, "gva")
  check_class(sic91, "sic91")

  # Annual business survey, duplicate 2014 data for 2015 and
  # then duplicate non SIC91 then add SIC 91 with sales data

  abs_2015 <- abs %>%
    dplyr::filter(!sic %in% unique(sic91$sic)) %>%

    #simply appending SIC sales data which supplements the ABS for SIC 91
    dplyr::bind_rows(sic91)

  abs_year <- max(attr(abs, "years"))
  abs_2015 <-
    dplyr::bind_rows(
      abs_2015,
      dplyr::filter(abs_2015, year == abs_year) %>%
      dplyr::mutate(year = abs_year + 1L))

  # keep cases from ABS which have integer SIC - which is just a higher level SIC
  abs_2digit <- abs_2015 %>%
    dplyr::filter(sic %in% eegva::sic_mappings$sic2) %>%
    dplyr::select(year, abs_2digit = abs, sic2 = sic)


  #add ABS to DCMS sectors
  gva_sectors <- dplyr::left_join(
                   eegva::sic_mappings,
                   abs_2015,
                   by = c('sic')) %>%
    dplyr::left_join(abs_2digit, by = c('year', 'sic2')) %>% #  add ABS GVA for integer SIC
    dplyr::mutate(perc_split = abs / abs_2digit) %>% #  split of GVA between SIC by SIC2
    dplyr::filter(!(is.na(year) & is.na(abs))) %>% #  rows must have either year or ABS GVA

    #add GVA
    dplyr::left_join(gva, by = c('sic2' = 'sic', 'year')) %>% #  add in GVA if SIC appears in SIC2
    dplyr::mutate(gva = perc_split * gva_2digit)

  # validation
  cols = rbind(
    data.frame(),
    list("sic", "character"),
    list("description", "character"),
    list("sector", "character"),
    list("sic2", "character"),
    list("sub_sector_categories", "character"),
    list("year", "integer"),
    list("abs", "numeric"),
    list("abs_2digit", "numeric"),
    list("perc_split", "numeric"),
    list("gva_2digit", "numeric"),
    list("gva", "numeric"),
    stringsAsFactors = FALSE
  )
  names(cols) <- c("name", "type")

  validate(
    gva_sectors,
    cols = cols,
    class_name = "combined_gva"
  )
}
