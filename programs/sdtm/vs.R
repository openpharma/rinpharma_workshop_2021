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

visits <- c("BASELINE", paste0("VISIT", seq(1, 4)))
vlbfl <- c("Y", rep("", 4))

Vital_vars <- dplyr::bind_rows(
  Map(function(x, y){TESTCDS$VISIT <- x; TESTCDS$VSBLFL <- y; TESTCDS},
      visits, vlbfl)
)

vital_join <- dplyr::bind_rows(
  lapply(DM$USUBJID, function(x){Vital_vars$USUBJID = x; Vital_vars})
)

join_visit <- function(n, .df, .db){
  X<- merge(.db[["DM"]], vital_join, by = "USUBJID", all = TRUE)
  subset(X, select = - DOMAIN)
}

# VS

vs_join_recipe <- tribble(
  ~foreign_tbl, ~foreign_key, ~dependencies, ~func, ~func_args,
  "DM", "USUBJID", no_deps, join_visit, NULL)

### Functions for making VS

source("programs/sdtm/functions/vsval.R")
source("programs/sdtm/functions/visit_fun.R")
source("programs/sdtm/functions/vs_date_gen.R")





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
