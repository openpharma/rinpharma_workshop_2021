
library(rtables)
library(dplyr)

source("tables_func.R")

# read ADaM data

adsl__ITT <- adsl %>%
  filter(ITTFL == "Y")

adsl__AGEG18 <- asl %>%
  filter(AGE > 18)


# Demographics Tables ----

tbl_dm__ITT <- t_dm(
  adsl = adsl__ITT,
  title = 'Demographic and Baseline Characteristics',
  subtitle = 'GA0001',
  main_footer ='Test footnotes'
)

# tbl_dm__ITT

# Viewer(tbl_dm__ITT)


# lpp numeric
# - Maximum lines per page including (re)printed header and context rows
# min_siblings  numeric
# - Minimum sibling rows which must appear on either side of pagination row for a mid-subtable split to be valid. Defaults to 2.
# nosplitin character
# - List of names of sub-tables where page-breaks are not allowed, regardless of other considerations. Defaults to none.

paginate_table(tbl_dm__ITT)  ## figure out pagination
paginate_table(tbl_dm__ITT, lpp = 15, min_siblings = 2, nosplitin = NULL)



export_as_txt(tbl_dm__ITT, paginate = T, file = 'outputs/t_dm_IT.out')
export_as_pdf(tbl_dm__ITT, paginate = T, file = 'outputs/t_dm_IT.pdf')







