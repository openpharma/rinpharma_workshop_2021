### set up recipe for structure of EX


trt_schedule <- tribble(
  ~ARMCD, ~EXSEQ, ~EXTRT, ~EXOCCUR,~EXDOSE,
  "A1",     1,     "Active Drug 1", "Y", 1200,
  "A1",     2,     "Active Drug 1", "Y", 1200,
  "A1",     3,     "Active Drug 1", "Y", 1200,
  "A2",     1,     "Active Drug 2", "Y", 300,
  "A2",     2,     "Active Drug 2", "Y", 300,
  "A2",     3,     "Active Drug 2", "Y", 300,
  "A3",     1,     "PLACEBO", "Y", 0,
  "A3",     2,     "PLACEBO", "Y", 0,
  "A3",     3,     "PLACEBO", "Y", 0,
)



join_ex <- function(n, .df, .db){

  X<- merge(.db[["DM"]], trt_schedule, by = "ARMCD", all= TRUE)
  subset(X, select = - DOMAIN)
}

ex_join_recipe <- tribble(
  ~foreign_tbl, ~foreign_key, ~dependencies, ~func, ~func_args,
  "DM", "ARMCD", no_deps, join_ex, NULL)

date_vars <- c("EXSTDTC", "EXENDTC")
date_deps <- c("RFSTDTC", "RFENDTC", "EXSEQ")

date_fun <- function(.df, n){
  tibble(
    EXSTDTC = as.POSIXct(ifelse(.df$RFXSTDTC + lubridate::days((.df$EXSEQ - 1) * 15) > .df$RFXENDTC,
                     .df$RFXENDTC,
                     .df$RFXSTDTC + lubridate::days((.df$EXSEQ - 1) * 15)),
                     origin = "1970-01-01"),
    EXENDTC = EXSTDTC + lubridate::minutes(100)
  )
}


ex_recipe <- tribble(
  ~variables,      ~dependencies,            ~func,               ~func_args,
  "DOMAIN",        NULL,                     rep_n,               list(val = "EX"),
  date_vars,       date_deps,                date_fun,            NULL
)





EX <- gen_reljoin_table(ex_join_recipe, ex_recipe, db = list(DM = DM),
                        keep = c("STUDYID", "SITEID", "USUBJID", "EXSEQ",
                                 "EXTRT", "EXOCCUR", "EXDOSE"))


EX <- dplyr::arrange(EX, USUBJID, EXSEQ)
EX <- EX[!duplicated(EX$EXSTDTC),]

