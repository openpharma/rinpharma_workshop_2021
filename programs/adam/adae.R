library(admiral)
library(dplyr)
library(lubridate)

# Rad source datasets
ae <- readRDS("data/AE.rds")
adsl <-

adae <- ae %>%

  # Join ADSL variables
  *_join(adsl) %>%

  # AE start datetime
  derive_vars_dtm(
    dtc = AESTDTC,
    new_vars_prefix = "AST",
    date_imputation = ,
    time_imputation = ,
    min_dates =
  ) %>%

  # AE end datetime
  derive_vars_dtm(

  ) %>%

  # ASTDTM -> ASTDT and AENDTM -> AENDT
   %>%

  # AE start date
  derive_() %>%

  # AE end date
  derive_() %>%

  # ADURN and ADURU
  derive_vars_duration(

  ) %>%

  # ASEV, ATOXGR and various flags
  mutate(
    ASEV = ,
    ATOXGR = ,
    TRTEMFL = if_else(, "Y", NA_character_),
    ANL01FL = ,
    PREFL = ,
    FUPFL =
  ) %>%

  # AOCCIFL
  derive_extreme_flag(
    by_vars = ,
    order = ,
    new_var = AOCCIFL,
    filter = ANL01FL == "Y",
    mode =
  ) %>%

  # AOCCPIFL
  derive_extreme_flag(

  ) %>%

  # AOCCSIFL
  derive_extreme_flag(

  )

saveRDS(adae, file = "data/ADAE.rds")
