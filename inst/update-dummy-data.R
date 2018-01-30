#need to update this to return dataframe
randomise_data <- function (df) {
  df_colnames <- names(df)[! names(df) %in% c("year", "sic")]
  df[, df_colnames] <-
    lapply(
      df_colnames,
      function(x) floor(runif(nrow(df),0,1000)) + 0.12345)
  return(df)
}

df_list <- c("abs", "charities", "gva", "sic91", "tourism")

for (df in df_list){
  dummy_path <- file.path("data", paste0(df,".rda"))
  assign(df, randomise_data(get(df)))
  save(list = df, file = dummy_path)
}
rm(list = ls())
df_list <- c("abs", "charities", "gva", "sic91", "tourism")
for (df in df_list){
  dummy_path <- file.path("data", paste0(df,".rda"))
  load(dummy_path)
}
