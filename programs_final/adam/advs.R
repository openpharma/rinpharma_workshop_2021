library(admiral)
library(dplyr)
library(lubridate)

vs <- readRDS("data/VS.rds")
adsl <- readRDS("data/ADSL.rds")

param_lookup <- tibble::tribble(
  ~VSTESTCD, ~PARAMCD, ~PARAM,
  "SYSBP",   "SYSBP",  "Systolic Blood Pressure (mmHg)",
  "DIABP",   "DIABP",  "Diastolic Blood Pressure (mmHg)",
  "PUL",     "PULSE",  "Pulse Rate (beats/min)",
  "WGHT",    "WEIGHT", "Weight (kg)",
  "HGHT",    "HEIGHT", "Height (cm)",
  "TEMP",    "TEMP",   "Temperature (C)"
)

range_lookup <- tibble::tribble(
  ~PARAMCD, ~ANRLO, ~ANRHI, ~A1LO, ~A1HI,
  "SYSBP",  90,     130,    70,    140,
  "DIABP",  60,      80,    40,     90,
  "PUL",    60,     100,    40,    110,
  "TEMP",   36.5,    37.5,  35,     38
)

advs <- vs %>%
  left_join(adsl, by = c("STUDYID", "USUBJID")) %>%
  derive_vars_dtm(
    new_vars_prefix = "A",
    dtc = VSDTC,
    time_imputation = "12:00:00",
    flag_imputation = "both"
  ) %>%
  mutate(ADT = date(ADTM)) %>%
  derive_var_ady() %>%
  left_join(param_lookup, by = "VSTESTCD") %>%
  mutate(
    AVAL = VSSTRESN,
    AVALC = VSSTRESC
  ) %>%
  derive_var_ontrtfl(
    start_date = ADT,
    ref_start_date = TRTSDT,
    ref_end_date = TRTEDT
  ) %>%
  derive_extreme_flag(
    by_vars = vars(STUDYID, USUBJID, PARAMCD),
    order = vars(ADT, VSSEQ),
    new_var = ABLFL,
    mode = "last",
    filter = (!is.na(AVAL) & ADT <= TRTSDT)
  ) %>%
  derive_var_base(
    by_vars = vars(STUDYID, USUBJID, PARAMCD)
  ) %>%
  derive_var_basec(
    by_vars = vars(STUDYID, USUBJID, PARAMCD)
  ) %>%
  derive_var_chg() %>%
  derive_var_pchg() %>%
  left_join(range_lookup, by = "PARAMCD") %>%
  derive_var_anrind() %>%
  derive_baseline(
    by_vars = vars(STUDYID, USUBJID, PARAMCD),
    source_var = ANRIND,
    new_var = BNRIND
  )
