### Functions for making demographic variables

usub_fun <- function(.df, n = nrow(df)){
  paste(.df$STUDYID, .df$SITEID, .df$SUBJID, sep = "-")
}

end_date <- function(.df, n = nrow(df), end_date){
  out <- ifelse(!is.na(.df$DTHDTC),
                as.POSIXct(.df$DTHDTC),
                respectables::rand_posixct(start = .df$RFSTDTC, end = end_date))
  as.POSIXct(out, origin = "1970-01-01")
}

death_date <- function(.df, n = nrow(df), death_prob, end_date){
  out <- ifelse(
    runif(n) < death_prob,
    respectables::rand_posixct(start = .df$RFSTDTC, end = end_date),
    NA
  )
  as.Date(as.POSIXct(out, origin = "1970-01-01"))

}

death_flag <- function(.df, n = nrow(df)){
  ifelse(is.na(.df$DTHDTC), "N", "Y")
}

arm_fn <- function(.df, n = nrow(df), arms){
  out <- .df$ARMCD
  fct_recode(out, !!!arms)
  out
}

age_fn <- function(n, min_age, max_age){
  sample(seq(min_age, max_age), n, replace = TRUE)
}

### Variables to call in tribble

s_race <- c(
  "ASIAN", "BLACK OR AFRICAN AMERICAN", "WHITE", "AMERICAN INDIAN OR ALASKA NATIVE",
  "MULTIPLE", "NATIVE HAWAIIAN OR OTHER PACIFIC ISLANDER", "OTHER", "UNKNOWN"
)
s_country <- c("CHN", "USA", "BRA", "PAK", "NGA", "RUS", "JPN", "GBR", "CAN", "CHE")
usub_dep  <- c("STUDYID", "SUBJID", "SITEID")
rfe_deps <- c("RFSTDTC", "DTHDTC")

dm_recipe <- tribble(
  ~variables,       ~dependencies,      ~func,               ~func_args,
  "STUDYID",        no_deps,            rep_n,              list(val = "a12345"),
  "DOMAIN",         no_deps,            rep_n,              list(val = "DM"),
  "USUBJID",        usub_dep,           usub_fun,           NULL,
  "SUBJID",         no_deps,            subjid_func,        NULL,
  "RFSTDTC",        no_deps,            rand_posixct,       list(start = "2019-01-01", end = "2019-06-01"),
  "RFENDTC",        rfe_deps,           end_date,           list(end_date = "2021-06-01"),
  "DTHDTC",         "RFSTDTC",          death_date,         list(end_date = "2021-06-01", death_prob = 0.2),
  "DTHFL",          "DTHDTC",           death_flag,         NULL,
  "SITEID",         no_deps,            sample_fct,         list(x = c("1", "2", "3")),
  "AGE",            no_deps,            age_fn,             list(min_age = 18, max_age = 80),
  "SEX",            no_deps,            sample_fct,         list(x = c("MALE", "FEMALE")),
  "RACE",           no_deps,            sample_fct,         list(x = s_race),
  "ARMCD",          no_deps,            sample_fct,         list(x = c("A1", "A2", "A3")),
  "ARM",            "ARMCD",            arm_fn,             list(arms = c("ARM 1" = "A1", "ARM 2" = "A2", "ARM 3" = "A3")),
  "COUNTRY",        no_deps,            sample_fct,         list(x = s_country)
)


DM_recipe <- tibble(
  variables =dm_variables ,
  dependencies = dm_dep,
  func = dm_funcs,
  func_args = dm_args
)


DM <- gen_table_data(N = 100, recipe = DM_recipe)
