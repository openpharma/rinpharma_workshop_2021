library(admiral)
library(dplyr)
library(lubridate)

dm <- readRDS("data/DM.rds")
ds <- readRDS("data/DS.rds")
ex <- readRDS("data/EX.rds")

adsl <- dm %>%
  derive_var_trtsdtm(ex) %>%
  derive_var_trtedtm(ex) %>%
  derive_vars_dtm_to_dt(vars(TRTSDTM, TRTEDTM)) %>%
  derive_var_trtdurd() %>%
  derive_vars_dt(
    new_vars_prefix = "BRTH",
    dtc = BRTHDTC,
    date_imputation = "mid"
  ) %>%
  derive_vars_aage(start_date = BRTHDT, end_date = TRTSDT) %>%
  derive_vars_dt(
    new_vars_prefix = "DTH",
    dtc = DTHDTC,
    date_imputation = NULL,
    flag_imputation = FALSE
  ) %>%
  derive_disposition_dt(
    dataset_ds = ds,
    new_var = RANDDT,
    dtc = DSSTDTC,
    filter = DSDECOD == "RANDOMIZED",
    date_imputation = NULL
  ) %>%
  derive_disposition_dt(
    dataset_ds = ds,
    new_var = ENRLDT,
    dtc = DSSTDTC,
    filter = DSDECOD == "ENROLLED",
    date_imputation = NULL
  ) %>%
  mutate(
    ITTFL = if_else(!is.na(RANDDT), "Y", NA_character_),
    SAFFL = if_else(!is.na(TRTSDT), "Y", NA_character_),
    FASFL = "Y"
  )

saveRDS(adsl, file = "data/ADSL.rds")
