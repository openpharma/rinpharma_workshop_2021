### Make a structure for VS

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
  Map(function(x, y){TESTCDS$VISIT <- x; TESTCDS$VSBLFL <- y; TESTCDS},
      visits, vlbfl)
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

### Functions for making VS

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

VS_recipe <- tribble(
  ~variables,      ~dependencies,            ~func,               ~func_args,
  "DOMAIN",        NULL,                     rep_n,               list(val = "VS"),
  "VSSEQ",         "USUBJID",                seq_fun,             NULL,
  "VSORRES",       "VSTESTCD",               VSval,               NULL,
  "VISITNUM",      "VISIT",                  visitn_fn,           NULL,
  "VSDTC",         c("RFSTDTC","VISITNUM"),  date_gen,            NULL

)





VS <- gen_reljoin_table(vs_join_recipe, VS_recipe, db = list(DM = DM),
                        keep = c("STUDYID", "SITEID", "USUBJID", "VISIT",
                                 "VSTESTCD", "VSTEST", "VSORRESU", "VSBLFL"))
