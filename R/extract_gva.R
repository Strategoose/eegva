#excel file explantion
#first matches against list of SICs which has some text headings removed
#but keeps the 30.1-4 and 30other types
#then it is matched against the two digit (except 30.1) SICs in Working
#File sheet. So is very simple we are doing no grouping.

#' @export
extract_gva <- function(path,
                        sheet = "CP Millions") {

  #extract GVA data separately to SIC codes to keep it as numeric type

  df <-
    openxlsx::read.xlsx(
      xlsxFile = path,
      sheet = sheet,
      colNames = FALSE,
      skipEmptyCols = FALSE,
      rows = 15:41)

  colnames <-
    openxlsx::read.xlsx(
      xlsxFile = path,
      sheet = sheet,
      colNames = TRUE,
      skipEmptyCols = FALSE,
      rows = 5)

  # some manipulation to transpose data and keep correct column names
  sic <- names(colnames)
  sic <- sic[-c(1:3,14)]

  colnames <- df[, 3]
  df <- df[, -c(1:3,14)]
  df <- t(df)
  df <- data.frame(df)
  names(df) <- colnames
  df <- cbind(sic, df, stringsAsFactors = FALSE)

  df[1, 1] <- "year_total"

  df <- df %>%
    dplyr::filter(sic %in% sic_mappings$sic2 | sic == "year_total")

  # check number of SIC codes in dataset (+1 for year_total)
  if (nrow(df) != length(unique((sic_mappings$sic2))) + 1) {
    stop(
      paste0(
        "GVA data has rows for ",
        nrow(df) - 1,
        " 2-digit SIC codes. there are ",
        length(unique((sic_mappings$sic2))),
        " in sic_mappings"))
  }

  # convert data to long format
  df <- df %>%
    tidyr::gather(key = "year", value = "gva_2digit", -sic) %>%
    dplyr::mutate(year = as.integer(year))

  # validation
  cols = rbind(
    data.frame(),
    list("sic", "character"),
    list("year", "integer"),
    list("gva_2digit", "numeric"),
    stringsAsFactors = FALSE
  )
  names(cols) <- c("name", "type")

  validate(
    df,
    cols = cols,
    class_name = "gva"
  )

}
