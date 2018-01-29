clean_sic <- function(x) {

  correct_sic <- function(y) {

    if (nchar(remove_trailing_zeros(y)) %in% 3:5) {
      y <- remove_trailing_zeros(y)
      left <- substr(y, 1, 2)
      right <- substr(y, 3, nchar(y))
      y <- paste0(left, '.', right)

    } else return(remove_trailing_zeros(y))
  }

  x <- unlist(lapply(x, correct_sic))
  return(x)

}

na_cols <- function(df) {

  contains_NA <- apply(df, MARGIN = 2, FUN = anyNA)
  contains_NA <-  colnames(df)[contains_NA]
  return(contains_NA)

}

save_rds <- function(x, full_path) {

  saveRDS(x, full_path)

  if (file.exists(full_path)) {

    message('Saved to ', full_path)
    message('File is ', file.info(full_path)$size, ' bytes')

  } else warning(full_path, 'was not created.')

}

year_split <- function(x) {

  year_ <- function(x) strsplit(x, ' ')[[1]][1]
  output <- sapply(x, year_)
  output <- unname(output)
  output <- as.integer(output)
  return(output)

}

zero_ <- function(x) {

  # Check whether it can be converted to integer cleanly and whetehr it only has
  # one character

  if (((nchar(x) == 1) &!suppressWarnings(is.na(as.integer(x))))) x <- paste0(0, x)

  return(x)

}

zero_prepend <- function(x) {

  # Vectorize zero_

  output <- sapply(x, zero_)
  output <- unname(output)
  return(output)

}

elongate_SIC <- function(x) {

  x <- as.numeric(x) * 100
  x <- round(x)
  return(x)

}

# for checking that tibbles have unique classes
check_class <- function(df, class) {
  if (!identical(
        class(df),
        c(class, "data.frame"))) {
    stop(
      paste0(
        deparse(substitute(df)),
        " must have been created by extract_",
        class,
        "() and have class ",
        class))
  }
}

#check for missing columns
na_col_test <-  function (x) {
  w <- sapply(x, function(x)all(is.na(x)))
  if (any(w)) {
    stop(paste("All NA in columns", paste(which(w), collapse=", ")))
  }
}
