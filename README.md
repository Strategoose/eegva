
## Producing output 

[devtools](https://www.rstudio.com/products/rpackages/devtools/) is required to install packages from github
```r
install.packages("devtools")
```

install eegva package
```r
devtools::install_github("dcmsstats/eegva")
```

signal whether the run is "development", "production", or "test".
```r
run <- "production"
```

specify the publication year
```r
publication_year <- 2016
```

Run script which uses package to create stats publication. [control-script.R] goes through the necessary steps to produce the output.
source(systemfile(control-script, eegva))

## Trouble shooting

if run the above fails and generates the below error, try navigating to the file in windows explorer then rerun the code
```
Error in read.xlsx.default(xlsxFile = path, sheet = sheet, colNames = FALSE) : 
  File does not exist.
```

for other errors, perform these steps then try again
run `update.packages()`

## How the package works

### Using the package
There are two options for using the package. 

#### Cloning
Cloning the package source code from the github repository will give you access to all the code for the package and therefore the ability to update the package (to save your updates to github, you need the appropriate permissions). [These] instructions provide some guidance on this process. You can also make changes directly in github, but this is only suitable for making very small changes.

#### Installing
The second, which [Producing output] uses, is to install the package in a similar way that you would usually install packages (e.g. using install.packages("dplyr")). This means you can use the functions in the package which are necessary to produce the outputs, but are not able to access all of the code, or update it.

### How the package functions

#### Producing Output
The below roughly outlines the steps the package takes to [produce output]. This is what control-script.R does, see [control-script] or open on your laptop using `system.file()` for more detail. Each step uses functions which are founder in /R in the source code.
1. Uses openxlsx to read in raw data from excel file. The functions that do this are prefixed with `extract_`. Dummy data is included in the package which can be used in place of this extracted data, when the raw data is not available.
1. `combine_gva_extracts()` combines the extracted data.
1. `sum_gva_by_sector()` and `sum_gva_by_subsector()` aggreates the data by sector and subsector respectively.
1. `sector_table()` produces 2 way summary tables ready for the publication.
1. To produce excel file outputs, excel files in /inst which contain a template are read in using openxlsx, then the summary tables are inserted, again using openxlsx, and then saved to the users home idrectory ~/ which is usually your Documents folder on Windows.
1. Produce charts, and PDF using Rmd - work in progress

#### Further work
1. Complete summary table functionality for subsectors.
1. Produce PDF using Rmd to avoid copy and pasting values, and provide an audit trail.
1. Produce charts using R to save time creating them manually, and in order to use Rmd above.

### Source Code

#### R/
This is where most of the code which does the analysis lives. All the code is
functions, only some of which are avaiable when you install the package.

#### man/
This is where the package documentation that can usually be found running `?function_name` lives. In this case it is empty because it makes the package easier to understand, if documentation is kept minimal and in one place - i.e. here.

#### inst/
This is where all other files live, for example:  
1. Excel files which are used as templates that are then populated with output data tables.
1. Csv files which are lookup tables used by the package.
1. The control script (control-script.R)

#### test/
The code here simply tests the package is working as expected, using the dummy data. None of this code does any of the analysis the package was designed for.

#### data/
This is where data.frames and other R data are stored for use by the package. They are accessed using for example eegva::tourism (this is the tourism dummy data).
This is where the dummy data lives, which can be used by to test the package, even if you do not have access to the raw data (which is sensitive and not distributed with this package) The test folder uses this dummy data.

#### README.md
Contains the text for this document in [Markdown](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet) format. This is the sole documentation for the package, other than occasional comments in the source code. The source code is transparent enough that it is best to read the source code to better understand how functions in the package work.

#### NAMESPACE
Is a config file that should not be updated manually - instead use roxygen comments in the code. http://r-pkgs.had.co.nz/namespace.html

#### DESCRIPTION
If a config file. Most fields are self explanatory. http://r-pkgs.had.co.nz/description.html

## Glossary
Source code: this is just all the code which is used to make the package (i.e. the code on github)

## Related material

Very good introductory guide to developing packages: http://r-pkgs.had.co.nz/

Previous iteration of package: https://github.com/DCMSstats/eesectors

There is a RAP channel at: https://govdatascience.slack.com/

GDS guide to RAP: https://ukgovdatascience.github.io/rap_companion/
