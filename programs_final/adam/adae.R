library(admiral)
library(dplyr)
library(lubridate)

ae <- readRDS("data/AE.rds")
adsl <- readRDS("data/ADSL.rds")

adae <- ae %>%
  left_join(adsl, by = c("STUDYID", "USUBJID")) %>%
  derive_vars_dtm(
    dtc = AESTDTC,
    new_vars_prefix = "AST",
    date_imputation = "first",
    time_imputation = "first",
    min_dates = list(TRTSDT)
  ) %>%
  derive_vars_dtm(
    dtc = AEENDTC,
    new_vars_prefix = "AEN",
    date_imputation = "last",
    time_imputation = "last",
    max_dates = list(DTHDT, EOSDT)
  ) %>%
  derive_vars_dtm_to_dt(vars(ASTDTM, AENDTM)) %>%
  derive_var_astdy() %>%
  derive_var_aendy() %>%
  derive_vars_duration(
    new_var = ADURN,
    new_var_unit = ADURU,
    start_date = ASTDT,
    end_date = AENDT
  ) %>%
  mutate(
    ASEV = AESEV,
    ATOXGR = as.numeric(AETOXGR),
    TRTEMFL = if_else(ASTDT >= TRTSDT & ASTDT <= TRTEDT + days(30), "Y", NA_character_),
    ANL01FL = if_else(TRTEMFL == "Y" & ASTDT <= TRTEDT, "Y", NA_character_),
    PREFL = if_else(ASTDT < TRTSDT, "Y", NA_character_),
    FUPFL = if_else(ASTDT > TRTSDT, "Y", NA_character_)
  ) %>%
  derive_extreme_flag(
    by_vars = vars(USUBJID),
    order = vars(ASTDTM, ATOXGR, AESEQ),
    new_var = AOCCIFL,
    filter = ANL01FL == "Y",
    mode = "last"
  ) %>%
  derive_extreme_flag(
    by_vars = vars(USUBJID, AEDECOD),
    order = vars(ASTDTM, ATOXGR, AESEQ),
    new_var = AOCCPIFL,
    filter = ANL01FL == "Y",
    mode = "last"
  ) %>%
  derive_extreme_flag(
    by_vars = vars(USUBJID, AEBODSYS),
    order = vars(ASTDTM, ATOXGR, AESEQ),
    new_var = AOCCSIFL,
    filter = ANL01FL == "Y",
    mode = "last"
  )

saveRDS(adae, file = "data/ADAE.rds")
