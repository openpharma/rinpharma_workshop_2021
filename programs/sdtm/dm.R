library(respectables)                   # https://roche.github.io/respectables/
library(tibble)

### Functions for making demographic variables

source("programs/sdtm/functions/make_usub.R")
source("programs/sdtm/functions/death_funs.R")
source("programs/sdtm/functions/make_age.R")

source("programs/sdtm/functions/other_dm.R")



### Variables to call in tribble

s_race <- c(
  "ASIAN", "BLACK OR AFRICAN AMERICAN", "WHITE", "AMERICAN INDIAN OR ALASKA NATIVE",
  "MULTIPLE", "NATIVE HAWAIIAN OR OTHER PACIFIC ISLANDER", "OTHER", "UNKNOWN"
)

s_country <- c("CHN", "RUS", "USA", "PAK", "BRA", "CAN", "GBR", "JPN")
usub_dep  <- c("STUDYID", "SUBJID", "SITEID")
rfe_deps <- c("RFSTDTC", "DTHDTC")
date_vars <- c("RFENDTC", "RFXSTDTC", "RFXENDTC")
age_vars <- c("BRTHDTC", "AGE")



### Recipe

DM_recipe <- tribble(
  ~variables,       ~dependencies,      ~func,               ~func_args,
  "STUDYID",        no_deps,            rep_n,              list(val = "a12345"),
  "DOMAIN",         no_deps,            rep_n,              list(val = "incorrect"),
  "USUBJID",        usub_dep,           make_usub,          NULL,
  "SUBJID",         no_deps,            subjid_func,        NULL,
  "RFSTDTC",        no_deps,            rand_posixct,       list(start = "2019-01-01", end = "2019-06-01"),
  date_vars,        rfe_deps,           date_func,          list(end = "2021-06-01"),
  "DTHDTC",         "RFSTDTC",          death_date,         list(end_date = "2021-06-01", death_prob = 0.2),
  "DTHFL",          "DTHDTC",           death_flag,         NULL,
  "SITEID",         no_deps,            sample_fct,         list(x = c("1", "2", "3")),
  age_vars,         "RFSTDTC",          make_age,           list(min_age = 18, max_age = 80),
  "SEX",            no_deps,            sample_fct,         list(x = c("MALE", "FEMALE")),
  "RACE",           no_deps,            sample_fct,         list(x = s_race),
  "ARMCD",          no_deps,            sample_fct,         list(x = c("A1", "A2", "A3")),
  "ARM",            "ARMCD",            make_arm,           list(arms = c("ARM 1" = "A1", "ARM 2" = "A2", "ARM 3" = "A3")),
  "COUNTRY",        no_deps,            sample_fct,         list(x = s_country)
)



DM <- gen_table_data(N = 60, recipe = DM_recipe)
