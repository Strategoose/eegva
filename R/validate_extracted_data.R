validate <- function(df,
                     cols,
                     class_name) {


  # check for missing rows and columns

  # check for missing values

  # check for duplicates

  # check columns names
  if (!identical(colnames(df), cols$name)) {
    stop("column names have not been created correctly")
  }

  # check column types
  df_types <- sapply(df, class)
  names(df_types) <- NULL
  if (!identical(df_types, cols$type)) {
    stop("column classes have not been created correctly")
  }

  # check expected number of years matches
  if ("year" %in% colnames(df)) {
    years <- sort(unique(df$year))
  } else {
    years <- NA
  }

  #if (exists(expected_years) !identical())

  # finally check class
  if (!identical(class(df), "data.frame")) stop("class(df) is not data.frame")

  structure(
    df,
    class = c(class_name, "data.frame"),
    years = years
  )
}
