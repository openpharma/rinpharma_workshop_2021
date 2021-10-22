
library(admiral)           # https://roche-gsk.github.io/admiral/
library(dplyr)

# source("SDTM.R") # creates list SDTM with elements DM, AE, MH
SDTM <- list(
  DM = rtables::ex_adsl %>% select(USUBJID, STUDYID, SITEID, ARM, ACTARM),
  AE = rtables::ex_adae %>% select(USUBJID, STUDYID, SITEID, ARM, ACTARM, AESEQ, AETERM, AEDECOD),
  MH = rtables::ex_admh %>% select(USUBJID, STUDYID, SITEID, ARM, ACTARM, MHSEQ, MHTERM, MHDECOD, MHBODSYS)
)

saveRDS(rtables::ex_adsl %>% select(USUBJID, STUDYID, SITEID, ARM, ACTARM), "data_demo/DM.rds")
saveRDS(rtables::ex_adae %>% select(USUBJID, STUDYID, SITEID, ARM, ACTARM, AESEQ, AETERM, AEDECOD), "data_demo/AE.rds")
saveRDS(rtables::ex_admh %>% select(USUBJID, STUDYID, SITEID, ARM, ACTARM, MHSEQ, MHTERM, MHDECOD, MHBODSYS), "data_demo/MH.rds")

saveRDS(rtables::ex_adsl, "data_demo/ADSL.rds")
saveRDS(rtables::ex_adae, "data_demo/ADAE.rds")
saveRDS(rtables::ex_admh, "data_demo/ADMH.rds")
ADaM <- list(
  ADSL = rtables::ex_adsl,
  ADAE = rtables::ex_adae,
  ADMH = rtables::ex_admh
)
