library(admiral)
library(dplyr)
library(lubridate)

vs <- readRDS("data_demo/VS.rds")
adsl <-

param_lookup <- tibble::tribble(
  ~VSTESTCD, ~PARAMCD, ~PARAM,
  "SYSBP",   "SYSBP",  "Systolic Blood Pressure (mmHg)",
  "DIABP",   "DIABP",  "Diastolic Blood Pressure (mmHg)",
  "PUL",     "PULSE",  "Pulse Rate (beats/min)",
  "WGHT",    "WEIGHT", "Weight (kg)",
  "HGHT",    "HEIGHT", "Height (cm)",
  "EMP",     "TEMP",   "Temperature (C)"
)

range_lookup <- tibble::tribble(
  ~PARAMCD, ~ANRLO, ~ANRHI, ~A1LO, ~A1HI,
  "SYSBP",  90,     130,    70,    140,
  "DIABP",  60,      80,    40,     90,
  "PUL",    60,     100,    40,    110,
  "TMP",    36.5,    37.5,  35,     38
)

advs <- vs %>%

  # Join ADSl variables
  *_join(adsl) %>%

  # ADTM
  derive_vars_dtm(
    new_vars_prefix = "A",
    dtc = VSDTC,
    time_imputation = ,
    flag_imputation =
  ) %>%

  # ADTM -> ADT
   %>%

  # ADT
  derive_ %>%

  # PARAMCD, PARAM etc.
   %>%

  # AVAL, AVALC
  mutate(
    AVAL =,
    AVALC =
  ) %>%

  # ONTRTFL
  derive_var_ontrtfl(

  ) %>%

  # ABLFL
  derive_extreme_flag(

  ) %>%

  # BASE
  derive_var_() %>%

  # BASEC
  derive_var_() %>%

  # CHG
  derive_var_() %>%

  # PCHG
  derive_var_() %>%

  # Reference range

  # ANRIND

  # BNRIND
  derive_baseline(

  )
