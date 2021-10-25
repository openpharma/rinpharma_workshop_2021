
library(rtables)
library(dplyr)

source("programs/tables_func.R")

# read ADaM data
adsl <- readRDS('data_demo/ADSL.rds')
adae <- readRDS('data_demo/ADAE.rds')
advs <- readRDS('data_demo/ADVS.rds')

# Filter ADaM data
adsl__ITT <- adsl %>%
  filter(ITTFL == "Y")
adsl__SE <- adsl %>%
  filter(SAFFL == "Y")
adae__SE <- adae %>%
  filter(SAFFL == 'Y')
advs__SE <- advs %>%
  filter(SAFFL == 'Y')



# Demographics Tables ----

tbl_dm__ITT <- t_dm(
  adsl = adsl__ITT[c('SEX')],
  title = 'Demographic and Baseline Characteristics',
  subtitle = 'Protocol: AB12345',
  main_footer ='Test footnotes'
)

# tbl_dm__ITT
# Viewer(tbl_dm__ITT)


# lpp numeric
# - Maximum lines per page including (re)printed header and context rows
paginate_table(tbl_dm__ITT)  ## figure out pagination
paginate_table(tbl_dm__ITT, lpp = 15, min_siblings = 2, nosplitin = NULL)


export_as_txt(tbl_dm__ITT, paginate = T, file = 'outputs/t_dm_IT.out')
export_as_pdf(tbl_dm__ITT, paginate = T, file = 'outputs/t_dm_IT.pdf')


# AE Tables ----
# t_ae(
#   adae = adae__SE,
#   adsl = adsl__SE,
#   title = '',
#   subtitle = '',
#   main_footer =''
# )

# VS Tables ----
# t_vs(
#   advs = advs__SE,
#   adsl = adsl__SE,
#   title = '',
#   subtitle = '',
#   main_footer =''
# )


