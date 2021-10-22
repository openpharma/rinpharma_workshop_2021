library(admiral)
library(dplyr)
library(lubridate)

# Read all required datasets
dm <- readRDS("data/DM.rds")
ds <-
ex <-

adsl <- dm %>%
  # Treatment start and end datetime
  derive_ %>%
  derive_ %>%

  # TRTSDTM -> TRTSDT and TRTEDTM -> TRTEDT
   %>%

  # Calculate treatment duration
  derive_ %>%

  # BRTHDTC -> BRTHDT
  derive_vars_dt(
    new_vars_prefix = ,
    dtc = BRTHDTC,
    date_imputation =
  ) %>%

  # AAGE and AAGEU
  derive_vars_aage() %>%

  # DTHDTC -> DTHDT
  derive_ %>%

  # Randomization date
  derive_disposition_dt(
    dataset_ds = ds,
    new_var = RANDDT,
    dtc = ,
    filter = ,
    date_imputation = NULL
  ) %>%

  # Enrollment date
  derive_disposition_dt(

  ) %>%

  # End of study date
  derive_disposition_dt(

  ) %>%

  # End of study status
  derive_ %>%

  # Population flags
  mutate(
    ITTFL = if_else(),
    SAFFL = ,
    FASFL =
  )

saveRDS(adsl, file = "data/ADSL.rds")
