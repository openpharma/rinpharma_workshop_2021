

library(respectables)                   # https://roche.github.io/respectables/
# library(synthetic.cdisc.data)           # https://roche.github.io/synthetic.cdisc.data/
library(tibble)


usub_fun <- function(.df, n = nrow(df)){
  paste(.df$STUDYID, .df$SITEID, .df$SUBJID, sep = "-")
}

end_date <- function(.df, n = nrow(df), end_date){
  ifelse(!is.na(.df$DTHDTC),
         .df$DTHDTC,
  respectables::rand_posixct(start = .df$RFSTDTC, end = end_date))
}

death_date <- function(.df, n = nrow(df), death_prob, end_date){
  if(runif(1)<death_prob){
    return(
      respectables::rand_posixct(start = .df$RFSTDTC, end = end_date)
    )
  }
  NA
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


dm_variables <- c("STUDYID", "DOMAIN", "USUBJID",
               "SUBJID", "RFSTDTC", "RFENDTC",
               "DTHDTC", "DTHFL", "SITEID",
               "AGE", "SEX", "RACE",
               "ARMCD", "ARM",
               "COUNTRY")
dm_dep <- c(replicate(2, no_deps), list(c("STUDYID", "SUBJID", "SITEID")),
            replicate(2, no_deps), list(c("RFSTDTC", "DTHDTC")),
            "RFSTDTC", "DTHDTC", list(no_deps),
            replicate(4, no_deps), "ARMCD",
            list(no_deps))

dm_funcs <-c(replicate(2, rep_n), usub_fun,
          respectables::subjid_func, respectables::rand_posixct, end_date,
          death_date, death_flag,
          sample_fct,
          age_fn,
          replicate(3, sample_fct),
          arm_fn,
          sample_fct

          )

s_race <- c(
  "ASIAN", "BLACK OR AFRICAN AMERICAN", "WHITE", "AMERICAN INDIAN OR ALASKA NATIVE",
  "MULTIPLE", "NATIVE HAWAIIAN OR OTHER PACIFIC ISLANDER", "OTHER", "UNKNOWN"
)
s_country <- c("CHN", "USA", "BRA", "PAK", "NGA", "RUS", "JPN", "GBR", "CAN", "CHE")
usub_dep  <- c("STUDYID", "SUBJID", "SITEID")
dm_args <- c(list(list(val = "a12345")), list(list(val = "DM")), list(NULL),
             list(NULL), list(list(start = "2019-01-01", end = "2019-06-01")), list(list(end_date = "2021-06-01")),
             list(list(end_date = "2021-06-01", death_prob = 0.2)), list(NULL), list(list(x = c("1", "2", "3"))),
             list(list(min_age = 18, max_age = 80)), list(list(x = c("MALE", "FEMALE"))), list(list(x = s_race)),
             list(list(x = c("A1", "A2", "A3"))), list(list(arms = c("A1" = "ARM 1", "A2" = "ARM 2", "A3" = "ARM 3"))),
             list(list(x = s_country)))

# test <- tribble(
#   ~variables,       ~dependencies,      ~func,               ~func_args,
#   "STUDYID",        no_deps,            rep_n,              list(val = "a12345"),
#   "DOMAIN",         no_deps,            rep_n,              list(val = "DM"),
#   "USUBJID",        usub_dep,           usub_fun,           NULL,
#   "SUBJID",         no_deps,
#   "RFSTDTC",
#   "RFENDTC",
#   "DTHDTC",
#   "DTHFL",
#   "SITEID",
#   "AGE",
#   "SEX",
#   "RACE",
#   "ARMCD",
#   "ARM",
#   "COUNTRY"
# )


# DM  ----

DM_recipe <- tibble(
  variables =dm_variables ,
  dependencies = dm_dep,
  func = dm_funcs,
  func_args = dm_args
)


DM <- gen_table_data(N = 100, recipe = DM_recipe)

# AE  ----



# MH  ----

