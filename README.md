# run the below in R to produce results

[devtools](https://www.rstudio.com/products/rpackages/devtools/) is required to install packages from github
```r
install.packages("devtools")
```

install eegva package
```r
devtools::install_github("dcmsstats/eegva")
```

signal that this is statistics production, not development
production <- TRUE

run script which uses package to create stats publication
source(systemfile(control-script, eegva))
