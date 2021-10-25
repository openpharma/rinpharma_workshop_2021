library(dplyr)

dtm_to_dtc <- function(dtm) {
  gsub(" ", "T", as.character(dtm))
}

DM <- rtables::ex_adsl %>%
  transmute(STUDYID, USUBJID, SITEID, ARM, ACTARM, BRTHDTC = as.character(RANDDT - AGE * 365), DTHDTC = as.character(DTHDT))
AE <- rtables::ex_adae %>%
  transmute(
    USUBJID, STUDYID, SITEID, ARM, ACTARM, AESEQ, AESTDTC = dtm_to_dtc(ASTDTM),
    AEENDTC = dtm_to_dtc(AENDTM), AETERM, AEDECOD, AEBODSYS, AESEV, AESER, AETOXGR
  )
VS <- rtables::ex_advs %>%
  transmute(
    USUBJID, STUDYID, SITEID, DOMAIN = "VS", ARM, ACTARM, VSSEQ, VSTEST, VSTESTCD,
    VSDTC = dtm_to_dtc(ADTM), VSSTRESC, VSORRES = VSSTRESC, VSSTRESN = as.numeric(VSSTRESC)
  )
DS <- rtables::ex_adsl %>%
  transmute(
    STUDYID, USUBJID, RANDDT, ENRLDT = RANDDT - sample(0:5, nrow(.), replace = TRUE),
    EOSDT
  ) %>%
  tidyr::pivot_longer(RANDDT:EOSDT, names_to = "DSDECOD", values_to = "DSSTDTC") %>%
  mutate(
    DSSTDTC = as.character(DSSTDTC),
    DSDECOD = case_when(
      DSDECOD == "RANDDT" ~ "RANDOMIZED",
      DSDECOD == "ENRLDT" ~ "ENROLLED",
      DSDECOD == "EOSDT" ~ sample(c("DEATH", "WITHDRAWAL BY SUBJECT", "PHYSICIAN DECISION"), nrow(.), replace = TRUE)
    ),
    DSCAT = if_else(DSDECOD %in% c("RANDOMIZED", "ENROLLED"), "PROTOCOL MILESTONE", "DISPOSITION EVENT")
  )

saveRDS(DM, "data_demo/DM.rds")
saveRDS(AE, "data_demo/AE.rds")
saveRDS(VS, "data_demo/VS.rds")
saveRDS(DS, "data_demo/DS.rds")

rtables::ex_adsl %>%
  mutate(
    TRTSDT = lubridate::date(TRTSDTM),
    TRTEDT = lubridate::date(TRTEDTM)
  ) %>%
  saveRDS("data_demo/ADSL.rds")
saveRDS(rtables::ex_adae, "data_demo/ADAE.rds")
saveRDS(rtables::ex_advs, "data_demo/ADVS.rds")
