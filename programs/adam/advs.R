library(admiral)
library(dplyr)
library(lubridate)

vs <- readRDS("data_demo/VS.rds")
adsl <- readRDS("data_demo/ADSL.rds")

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
  left_join(adsl) %>%

  # ADTM
  derive_vars_dtm(
    new_vars_prefix = "A",
    dtc = VSDTC
    #time_imputation =,
    #flag_imputation =
  ) %>%

  # ADTM -> ADT
mutate(ADT = ADTM) %>%

#  # ADT
#  derive_vars_dt (
#    new_vars_prefix = "AST",
#    dtc = ADT
#)

derive_var_ady(reference_date = TRTSDT, date = ADT) %>%

  # PARAMCD, PARAM etc.

  left_join(param_lookup, by = "VSTESTCD") %>%


  # AVAL, AVALC
  mutate(
    AVAL = VSSTRESN,
    AVALC = VSSTRESC,
  ) %>%

  # ONTRTFL
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
  # # ABLFL
  # derive_extreme_flag(
  #
  # ) %>%
  #
  # # BASE
  # derive_var_base() %>%
  #
  # # BASEC
  # derive_var_basec() %>%
  #
  # # CHG
  # derive_var_chg() %>%
  #
  # # PCHG
  # derive_var_pchg() %>%
  #
  # # Reference range
  #
  # # ANRIND
  #
  # # BNRIND
  # derive_baseline(
  #
  # )
