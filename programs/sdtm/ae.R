### set up recipe for structure of AE


# Join random number of records per patient
join_fun <- rand_per_key("USUBJID", "DM", mincount = 0,
                         maxcount = 5, prop_present = 1)

join_fun_removedomain <- function(n, .dbtab, .df){
  X <- join_fun(n, .dbtab, .df)
  subset(X,select = -DOMAIN)
}


AE_join_recipe <-  tribble(~foreign_tbl, ~foreign_key, ~func, ~func_args,
                           "DM", "USUBJID", "join_fun_removedomain", list())

####### Functions needed for making ae


source("programs/sdtm/functions/ae_lookup.R")
source("programs/sdtm/functions/ae_sev.R")
source("programs/sdtm/functions/ae_tox.R")
source("programs/sdtm/functions/ae_other.R")

# a comment


aet_vars <- c("AESTDTC", "AEENDTC")
aet_deps <- c("RFSTDTC", "RFENDTC")
aecn_vars <- c("AEACN", "AEACNOTH")
tox_deps <- c("DTHDTC", "AEENDTC")



AE_recipe<- tribble(
  ~variables,       ~dependencies,      ~func,              ~func_args,
  "DOMAIN",          NULL,              rep_n,              list(val = "AE"),
  "AESEQ",          "USUBJID",          seq_fun,            NULL,
  names(ae_lookup), NULL,               aes_func,           list(lookup = ae_lookup),
  "AETOXGR",        tox_deps,           tox_fun,            NULL,
  "AETERM",         "AEDECOD",          aeterm_func,        NULL,
  "AESEV",          "AETOXGR",          aesev_func,         NULL,
  aet_vars,         aet_deps,           time_func,          NULL,
  aecn_vars,        "AETOXGR",          aecn_func,          NULL

)



AE <- gen_reljoin_table(AE_join_recipe, AE_recipe, db = list(DM = DM),
                        keep = c("STUDYID", "SITEID", "USUBJID"))
