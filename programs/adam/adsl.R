library(admiral)
library(dplyr)
library(lubridate)

# Read all required datasets
dm <- readRDS("data_demo/DM.rds") # Demography
ds <- readRDS("data_demo/DS.rds") # Disposition
#ex <- readRDS("data_demo/")  # Exposure

adsl <- dm %>%
  # Treatment start and end datetime

  # TRTSDTM -> TRTSDT and TRTEDTM -> TRTEDT
  #derive_var_trtsdtm(dataset_ex = ex) %>%
  #derive_var_trtedtm(dataset_ex = ex)

  mutate(
    TRTSDTM = as.POSIXct("2021-01-12 13:00:00"),
    TRTEDTM = as.POSIXct("2021-01-12 13:00:00")
  ) %>%

  mutate(
    TRTSDT = date(TRTSDTM),
    TRTEDT = date(TRTEDTM)
  ) %>%


  # Calculate treatment duration
  derive_var_trtdurd() %>%

  # BRTHDTC -> BRTHDT
  derive_vars_dt(
    new_vars_prefix = "BRTH" ,
    dtc = BRTHDTC,
    date_imputation = "06-15"
  ) %>%

  # AAGE and AAGEU
  derive_vars_aage(start_date = BRTHDT, end_date = TRTSDT, unit = "years") %>%

  # DTHDTC -> DTHDT
  derive_vars_dt(
    new_vars_prefix = "DTH",
    dtc = DTHDTC
  ) %>%

  # Randomization date
  derive_disposition_dt(
    dataset_ds = ds,
    new_var = RANDDT,
    dtc = DSSTDTC,
    filter = DSDECOD == 'RANDOMIZED',
    date_imputation = NULL
  ) %>%

  # Enrollment date
  derive_disposition_dt(
    dataset_ds = ds,
    new_var = ENRLDT,
    dtc = DSSTDTC,
    filter = DSDECOD == 'ENROLLED',
    date_imputation = NULL
  ) %>%


  # End of study date
  derive_disposition_dt(
    dataset_ds = ds,
    new_var = EOSDT,
    dtc = DSSTDTC,
    filter = DSCAT == "DISPOSITION EVENT",
    date_imputation = NULL
  ) %>%

  # End of study status
  derive_disposition_status(
    dataset_ds = ds,
    new_var = EOSSTT,
    status_var = DSDECOD,
    filter_ds = DSCAT == "DISPOSITION EVENT"
  ) %>%

  # Population flags
  mutate(
    ITTFL = if_else(!is.na(RANDDT), "Y", "N"),
    SAFFL = if_else(!is.na(TRTSDTM), "Y", "N"),
    FASFL = "Y"
  )
