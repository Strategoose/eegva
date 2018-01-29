#' Extract SIC sales data from excel file

extract_sic91 <- function(path,
                          sheet = "SIC 91 Sales Data") {

  df <-
    openxlsx::read.xlsx(
      xlsxFile = path,
      sheet = sheet,
      colNames = FALSE) %>%
    dplyr::select(sic = X1, year = X3, abs = X4) %>%
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
    class_name = "sic91"
  )

}
