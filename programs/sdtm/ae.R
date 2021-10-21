### set up recipe for structure of AE


# Join random number of records per patient
join_fun <- rand_per_key("USUBJID", mincount = 0,
                         maxcount = 5, prop_present = 1)

join_fun_removedomain <- function(n, .dbtab, .df){
  X <- join_fun(n, .dbtab, .df)
  subset(X,select = -DOMAIN)
}


AE_join_recipe <-  tribble(~foreign_tbl, ~foreign_key, ~func, ~func_args,
                           "DM", "USUBJID", "join_fun_removedomain", list())

####### Functions needed for making ae

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
  ~variables,       ~dependencies,      ~func,              ~func_args,
  "DOMAIN",          NULL,              rep_n,              list(val = "AE"),
  "AESEQ",          "USUBJID",          seq_fun,            NULL,
  names(ae_lookup), NULL,               aes_func,           list(lookup = ae_lookup),
  "AETERM",         "AEDECOD",          aeterm_func,        NULL,
  "AESEV",          "AETOXGR",          aesev_func,         NULL,
  aet_vars,         aet_deps,           time_func,          NULL

)



AE <- gen_reljoin_table(AE_join_recipe, AE_recipe, db = list(DM = DM),
                        keep = c("STUDYID", "SITEID", "USUBJID"))
