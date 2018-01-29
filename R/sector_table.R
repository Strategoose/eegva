#' @export
sector_table <- function(gva_by_sector,
                         indexed = FALSE) {

  if (indexed) {
    df <- gva_by_sector %>%
      dplyr::group_by(sector) %>%
      dplyr::mutate(
        gva =
          gva /
          max(
            ifelse(
              year == min(attr(gva_by_sector, "years")),
              gva,
              0
            )
          ) * 100
      )

  } else {
    df <- gva_by_sector %>%
      dplyr::mutate(gva = gva / 1000)
  }

  total2016 <- df %>%
    dplyr::filter(sector == "UK" & year == 2016) %>%
    data.frame()

  df <- df %>%
    dplyr::group_by(sector) %>%
    tidyr::spread(key = year, value = gva) %>%
    dplyr::ungroup()

  if (!indexed) {
    df <- df %>%
      dplyr::mutate(`% change 2010 - 2016` = (`2016` / `2010` - 1) *100) %>%
      dplyr::mutate(`% change 2015 - 2016` = (`2016` / `2015` - 1) *100) %>%
      dplyr::mutate(`% of UK GVA 2016` = `2016` / total2016$gva * 100)

    df[nrow(df) + 1, ] <- (as.numeric(df[1, ]) / as.numeric(df[10, ])) * 100
    df[nrow(df), 1] <- "uk_pc"
    df[nrow(df), c(9, 10, 11)] <- NA
  } else {
    df <- df %>%
      dplyr::mutate(`% change 2015 - 2016` = (`2016` / `2015` - 1) *100)
  }

  df <- df %>%
    dplyr::rename(`Sector` = sector) %>%
    as.data.frame() # just ata.frame() will read in data and convert col names

  # append dcms % uk row

  # update sector column with pretty category names
  df$Sector <-
    sector_lookup$output_name[match(df$Sector, sector_lookup$working_name)]

  # re-order rows
  df <-
    df[
      order(
        sector_lookup$row_postition[
          match(df$Sector, sector_lookup$output_name)]
      ),
    ]

  if (indexed) {
    df[nrow(df) + 1, ] <- df[nrow(df), ]
    df[nrow(df) - 1, ] <- NA
  }
  return(df)
}
