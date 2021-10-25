
library(rtables)
library(dplyr)

source("programs_final/tables_func.R")

# read ADaM data

adsl <- readRDS("data_demo/ADSL.rds")
adae <- readRDS("data_demo/ADAE.rds")
admh <- readRDS("data_demo/ADMH.rds")
advs <- readRDS("data_demo/ADVS.rds")


# Subset Data
adsl__IT <- adsl %>%
  filter(ITTFL == "Y")

adsl__SE <- adsl %>%
  filter(SAFFL == "Y")

adsl__AGEG18 <- adsl %>%
  filter(AGE > 18)


# Demographics Tables ----

## tbl_dm__IT ----
tbl_dm__IT <- t_dm(
  adsl = adsl__IT,
  title = "Demographic and Baseline Characteristics - Intent-to-Treat Population",
  subtitle = "Study: Sample Study with Synthetic Data, Cutoff Date: 2021-10-28",
  main_footer = "The tables is build using synthetic data."
)
tbl_dm__IT

export_as_txt(tbl_dm__IT, file = "outputs/tbl_dm__IT.txt")

## t_dm__SE ----

tbl_tm_SE <- t_dm(
  adsl = adsl__SE,
  title = "Demographic and Baseline Characteristics - Safety-Evaluable Population",
  subtitle = "Study: Sample Study with Synthetic Data, Cutoff Date: 2021-10-28",
  main_footer = "The tables is build using synthetic data."
)

tbl_tm_SE
export_as_txt(tbl_tm_SE, file = "outputs/tbl_tm_SE.txt")


# Adverse Events Table ----

## tbl_ae__SE ----
adae__SE <- adae %>%
  filter(SAFFL == "Y")

tbl_ae__SE <- t_ae(
  adae = adae__SE,
  adsl = adsl__SE,
  title = "Adverse Events - Safety-Evaluable Population",
  subtitle = "Study: Sample Study with Synthetic Data, Cutoff Date: 2021-10-28",
  main_footer = c(
    "The tables is build using synthetic data.",
    "Percentages are based on N in the column headings."
  )
)

tbl_ae__SE

export_as_txt(tbl_ae__SE, "outputs/tbl_ae__SE.txt", paginate = TRUE, lpp = 18, min_siblings = 2)


## tbl_ae__SER_SE ----
adae__SER_SE <- adae %>%
  filter(AESER == 'Y', SAFFL == "Y")

adsl__SER_SE <- inner_join(
  adsl, adae__SER_SE %>% select(USUBJID, STUDYID), by = c("STUDYID", "USUBJID")
)

tbl_ae__SER_SE <- t_ae(
  adae = adae__SER_SE,
  adsl = adsl__SER_SE,
  title = "Serious Adverse Events - Safety-Evaluable Population",
  subtitle = "Study: Sample Study with Synthetic Data, Cutoff Date: 2021-10-28",
  main_footer = c(
    "The tables is build using synthetic data.",
    "Percentages are based on N in the column headings."
  )
)
tbl_ae__SER_SE
export_as_txt(tbl_ae__SER_SE, "outputs/tbl_ae__SER_SE.txt", paginate = TRUE, lpp = 30, min_siblings = 2)


# ... and so on


# Vital Signs ----

## tbl_vs__SE ----

advs__SE <- advs %>%
  filter(SAFFL == "Y")


tbl_vs__SE <- t_vs(
  advs = advs__SE,
  adsl = adsl__SE,
  title = "Vital Signs - Safety-Evaluable Population",
  subtitle = "Study: Sample Study with Synthetic Data, Cutoff Date: 2021-10-28",
  main_footer = "The tables is build using synthetic data."
)

tbl_vs__SE
export_as_pdf(tbl_vs__SE, "outputs/tbl_vs__SE.pdf", paginate = TRUE, lpp = 40, min_siblings = 2)
