# this should be a supplement to unit testing
# the first time you create a function, you will obviously want to store it at least once
# to see the output, it is at this point you would save the returned metadata.

raw_input <- 1:10

func1 <- function(input) {
  data.frame(
    a = input
  )
}

rm(keep, keep2, keep3)
keep2 <- lapply(ls(), FUN = function(x) get(x) )
keep3 <- lapply(ls(), FUN = function(x) x )

?get(raw_input, envir = )

keep <- lapply(ls(), FUN = function(x) str(raw_input) )

identical(str(get("raw_input")), str(raw_input))
