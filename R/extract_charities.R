#' @export
extract_charities <- function(path,
                              sheet = "Charities") {

  df <- openxlsx::read.xlsx(xlsxFile = path, sheet = sheet, rows = 2:9, cols = 1:5)
  names(df) <- c('year', 'gva', 'total', 'perc', 'overlap')
  df <- dplyr::mutate(df, year = as.integer(year))

  # validation
  cols = rbind(
    data.frame(),
    list("year", "integer"),
    list("gva", "numeric"),
    list("total", "numeric"),
    list("perc", "numeric"),
    list("overlap", "numeric"),
    stringsAsFactors = FALSE
  )
  names(cols) <- c("name", "type")

  validate(
    df,
    cols = cols,
    class_name = "charities"
  )

}
