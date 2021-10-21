
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
  title = ,
  subtitle = ,
  main_footer =
)

# tbl_dm__ITT

# Viewer(tbl_dm__ITT)
paginate_table(tbl_dm__ITT)  ## figure out pagination

export_as_txt(tbl_dm__ITT)
export_as_pdf(tbl_dm__ITT)







