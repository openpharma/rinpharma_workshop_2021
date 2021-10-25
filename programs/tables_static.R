
library(rtables)
library(dplyr)

source("programs/tables_func.R")

# read ADaM data
adsl <- readRDS('data_demo/ADSL.rds')
adae <- readRDS('data_demo/ADAE.rds')
advs <- readRDS('data_demo/ADVS.rds')

# create each output in the LoPO Specification

# useful functions
#  - export_as_pdf
#  - export_as_txt
#  - ?paginate_table


# Demographic ----
## tbl_dm__SE ----
## tbl_ae__SE ----

# Adverse Events ----
## tbl_ae__SER_SE ----
## tbl_ae__REL_SE ----
## tbl_ae__CTC5_SE ----

# Vital Sighn ----
## tbl_vs__SE ----
## tbl_vs__IT ----
