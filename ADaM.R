
library(admiral)           # https://roche-gsk.github.io/admiral/
library(dplyr)

# source("SDTM.R") # creates list SDTM with elements DM, AE, MH
SDTM <- list(
  DM = rtables::ex_adsl %>% select(USUBJID, STUDYID, SITEID, ARM, ACTARM),
  AE = rtables::ex_adae %>% select(USUBJID, STUDYID, SITEID, ARM, ACTARM, AESEQ, AETERM, AEDECOD),
  MH = rtables::ex_admh %>% select(USUBJID, STUDYID, SITEID, ARM, ACTARM, MHSEQ, MHTERM, MHDECOD, MHBODSYS)
)





ADaM <- list(
  ADSL = rtables::ex_adsl,
  ADAE = rtables::ex_adae,
  ADMH = rtables::ex_admh
)
