

library(respectables)                   # https://roche.github.io/respectables/
# library(synthetic.cdisc.data)           # https://roche.github.io/synthetic.cdisc.data/
library(tibble)


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
             list(list(x = c("A1", "A2", "A3"))), list(list(arms = c("ARM 1" = "A1", "ARM 2" = "A2", "ARM 3" = "A3"))),
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

seq_fun <- function(.df, n){
  spl <- split(seq_along(.df$USUBJID), .df$USUBJID)
  sp <-lapply(spl, function(x){seq_along(x)})
  unlist(sp)

}


join_fun <- rand_per_key("USUBJID", mincount = 0, maxcount = 5, prop_present = 1)

join_fun_removedomain <- function(n, .dbtab, .df){
  X <- join_fun(n, .dbtab, .df)
  subset(X,select = -DOMAIN)
}


AE_join_recipe <-  tribble(~foreign_tbl, ~foreign_key, ~func, ~func_args,
                           "DM", "USUBJID", "join_fun_removedomain", list())


ae_lookup <- tribble(
  ~AEBODSYS, ~AELLT,          ~AEDECOD,        ~AEHLT,        ~AEHLGT,      ~AETOXGR, ~AESOC, ~AESER, ~AREL,
  "cl A.1",  "llt A.1.1.1.1", "dcd A.1.1.1.1", "hlt A.1.1.1", "hlgt A.1.1", "1",        "cl A", "N",    "N",
  "cl A.1",  "llt A.1.1.1.2", "dcd A.1.1.1.2", "hlt A.1.1.1", "hlgt A.1.1", "2",        "cl A", "Y",    "N",
  "cl B.1",  "llt B.1.1.1.1", "dcd B.1.1.1.1", "hlt B.1.1.1", "hlgt B.1.1", "5",        "cl B", "N",    "Y",
  "cl B.2",  "llt B.2.1.2.1", "dcd B.2.1.2.1", "hlt B.2.1.2", "hlgt B.2.1", "3",        "cl B", "N",    "N",
  "cl B.2",  "llt B.2.2.3.1", "dcd B.2.2.3.1", "hlt B.2.2.3", "hlgt B.2.2", "1",        "cl B", "Y",    "N",
  "cl C.1",  "llt C.1.1.1.3", "dcd C.1.1.1.3", "hlt C.1.1.1", "hlgt C.1.1", "4",        "cl C", "N",    "Y",
  "cl C.2",  "llt C.2.1.2.1", "dcd C.2.1.2.1", "hlt C.2.1.2", "hlgt C.2.1", "2",        "cl C", "N",    "Y",
  "cl D.1",  "llt D.1.1.1.1", "dcd D.1.1.1.1", "hlt D.1.1.1", "hlgt D.1.1", "5",        "cl D", "Y",    "N",
  "cl D.1",  "llt D.1.1.4.2", "dcd D.1.1.4.2", "hlt D.1.1.4", "hlgt D.1.1", "3",        "cl D", "N",    "N",
  "cl D.2",  "llt D.2.1.5.3", "dcd D.2.1.5.3", "hlt D.2.1.5", "hlgt D.2.1", "1",        "cl D", "N",    "Y"
)

aes_func <- function(n, .df, lookup = ae_lookup) {
  lookup[sample(1:NROW(lookup), NROW(.df), replace =TRUE),]
}
aeterm_func <- function(n, .df) gsub("dcd", "trm", .df$AEDECOD, fixed=TRUE)

aesev_func <- function(n, .df) {
  ifelse(
    .df$AETOXGR == 1, "MILD",
    ifelse(
      .df$AETOXGR %in% c(2, 3), "MODERATE",
      "SEVERE"
    )
  )


}
time_func <- function(n, .df) {
  tstart <- .df$RFSTDTC
  tend <- .df$RFENDTC
  ret <- data.frame( AESTDTC = rand_posixct(start = tstart, end = tend))

  ret$AEENDTC = rand_posixct(start = ret$AESTDTC , end = tend)
  ret

}

aet_vars <- c("AESTDTC", "AEENDTC")
aet_deps <- c("RFSTDTC", "RFENDTC")

AE_recipe<- tribble(
  ~variables,       ~dependencies,      ~func,               ~func_args,
  "DOMAIN",          NULL,              rep_n,               list(val = "AE"),
  "AESEQ",          "USUBJID",          seq_fun,             NULL,
  names(ae_lookup), NULL,               aes_func,           list(lookup = ae_lookup),
  "AETERM",         "AEDECOD",          aeterm_func,        NULL,
  "AESEV",          "AETOXGR",          aesev_func,         NULL,
  aet_vars,         aet_deps,           time_func,          NULL

)



AE <- gen_reljoin_table(AE_join_recipe, AE_recipe, db = list(DM = DM),
                        keep = c("STUDYID", "SITEID", "USUBJID"))


TESTCDS <- tribble(
  ~VSTESTCD, ~VSTEST, ~ VSORRESU,
  "DIABP", "Diastolic Blood Pressure",	"mmHg",
  "HEIGHT", "Height","cm",
  "PULSE", 	"Pulse Rate","BEATS/MIN",
  "SYSBP", "Systolic Blood Pressure","mmHg",
  "TEMP", "Temperature", "C",
  "WEIGHT", 	"Weight", 	"kg"
  )

visits <- c("BASELINE", paste0("VISIT", seq(1, 8)))
vlbfl <- c("Y", rep("", 8))

Vital_vars <- dplyr::bind_rows(
  Map(function(x, y){TESTCDS$VISIT <- x; TESTCDS$VSBLFL <- y; TESTCDS}, visits, vlbfl)
)

vital_join <- dplyr::bind_rows(
  lapply(DM$USUBJID, function(x){Vital_vars$USUBJID = x; Vital_vars})
)




join_visit <- function(n, .df, .dbtab){
  X<- merge(.dbtab, vital_join, by = "USUBJID", all = TRUE)
  subset(X, select = - DOMAIN)
}

# VS

vs_join_recipe <- tribble(
  ~foreign_tbl, ~foreign_key, ~dependencies, ~func, ~func_args,
  "DM", "USUBJID", no_deps, join_visit, NULL)

VSval <- function(.df, n){
  inner_calc <- function(tstcd){
    if(tstcd == "DIABP"){
      return(round(runif(1, 50, 80), 0))
    }
    if(tstcd == "HEIGHT"){
      return(round(runif(1, 140, 210), 0))
    }
    if(tstcd == "PULSE"){
      return(round(runif(1, 50, 80), 0))
    }
    if(tstcd == "SYSBP"){
      return(round(runif(1, 100, 160), 0))
    }
    if(tstcd == "TEMP"){
      return(round(runif(1, 35, 40), 2))
    }
    if(tstcd == "WEIGHT"){
      return(round(runif(1, 50, 120), 2))
    }
  }
  sapply(.df$VSTESTCD, inner_calc)
}

visitn_fn <- function(.df, n){
  as.numeric(ifelse(grepl("\\d", .df$VISIT),
    regmatches(.df$VISIT,regexpr("\\d",.df$VISIT)),
    1))
}

date_gen <- function(.df, n){
  as.Date(.df$RFSTDTC) + lubridate::days((.df$VISITNUM-1) * 14)
}

VS_recipe<- tribble(
  ~variables,       ~dependencies,      ~func,               ~func_args,
  "DOMAIN",          NULL,              rep_n,               list(val = "VS"),
  "VSSEQ",           "USUBJID",              seq_fun,             NULL,
  "VSORRES",       "VSTESTCD",         VSval,                    NULL,
  "VISITNUM",      "VISIT",            visitn_fn,                NULL,
  "VSDTC",         c("RFSTDTC","VISITNUM"), date_gen,                 NULL

)





VS <- gen_reljoin_table(vs_join_recipe, VS_recipe, db = list(DM = DM),
                        keep = c("STUDYID", "SITEID", "USUBJID", "VISIT",
                                 "VSTESTCD", "VSTEST", "VSORRESU", "VSBLFL"))



