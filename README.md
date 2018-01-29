# run the below in R to produce results

[devtools] is required to install packages from github
```r
install.packages("devtools")
```

install [ee_gva package]
devtools::install_github("dcmsstats/ee_gva")

signal that this is statistics production, not development
production <- TRUE

run script which uses package to create stats publication
source(systemfile(control-script, ee_gva))
