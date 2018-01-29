extract_abs <- function(path,
                        sheet = "NEW ABS DATA (2)") {

  #ABS data explanation - in working file, for each full SIC, they look up
  #the GVA from ABS for the full sic and also the two digit part. then the
  #percentage the former of the latter is calculated and used to weight gva

  df <- openxlsx::read.xlsx(xlsxFile = path, sheet = sheet)
  # choose where to select excel data from
  df <-
    rbind(
      #df[, c(1, 4:11)], raw data
      df[91:161, 13:21],
      df[c(5:86, 89), 13:21]) %>%
    dplyr::rename(sic = Checks)

  #remove duplicate SIC 92
  df <- df[-82, ]

  #determine most recent year of data
  years <- suppressWarnings(as.numeric(colnames(df)))
  years <- min(years[!is.na(years)]):max(years[!is.na(years)])

  # replace full stops in data and convert to numeric
  df[, colnames(df) %in% years] <- lapply(
    df[, colnames(df) %in% years],
    function(x) as.numeric(ifelse(x == ".", NA, x)))

  # convert data to long format
  df <- df %>%
    tidyr::gather(
      key = "year",
      value = "abs",
      -sic) %>%
    dplyr::filter(!is.na(sic)) %>%
    dplyr::filter(!is.na(abs)) %>%
    dplyr::mutate(year = as.integer(year))

  # validate
  cols = rbind(
    data.frame(),
    list("sic", "character"),
    list("year", "integer"),
    list("abs", "numeric"),
    stringsAsFactors = FALSE
  )
  names(cols) <- c("name", "type")

  validate(
    df,
    cols = cols,
    class_name = "abs"
  )

}
