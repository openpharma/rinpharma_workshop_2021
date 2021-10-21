### set up recipe for structure of AE


# Join random number of records per patient
join_fun <- rep_per_key("USUBJID", 4, prop_present = 1)

join_fun_removedomain <- function(n, .dbtab, .df){
  X <- join_fun(n, .dbtab, .df)
  subset(X,select = -DOMAIN)
}


DS_join_recipe <-  tribble(~foreign_tbl, ~foreign_key, ~func, ~func_args,
                           "DM", "USUBJID", "join_fun_removedomain", list())

####### Functions needed for making ae

dsvars <- c("DSDECOD", "DSCAT", "DSSCAT","DSTERM", "DSSDTC")
ds_deps <- c("USUBJID", "DTHDTC", "RFSTDTC", "RFENDTC", "RFXSTDTC")
ds_fun <- function(.df, n){
  split_df <- split(.df, factor(.df$USUBJID))

  dplyr::bind_rows(
    lapply(
      split_df,
      function(x){
        tibble(
          DSDECOD = c(
            'ENROLLED',  'INFORMED CONSENT OBTAINED', 'RANDOMIZED',
            ifelse(!is.na(x$DTHDTC), "DEATH", sample(c(
              "COMPLETED", "NOT COMPLETED"
            ), 1))[1]),
          DSCAT = c(
            rep( 'PROTOCOL MILESTONE', 3 ),
            "DISPOSITION EVENT"
          ),
          DSSCAT = c(
            rep( 'PROTOCOL MILESTONE', 3 ),
            "STUDY COMPLETION/EARLY DISCONTINUATION"
          ),
          DSTERM = c(
            rep("", 3),
            ifelse(DSDECOD[4] == "NOT COMPLETED",
                   "PHYSICIAN DECISION TO DISCONTINUE TREATMENT",
                   DSDECOD[4])[1]
          ),
          DSSDTC = c(
            x$RFSTDTC[1] - lubridate::days(2),
            x$RFSTDTC[1] - lubridate::days(1),
            x$RFSTDTC[1],
            x$RFENDTC[1]
          )

        )


      }

    )
  )

}

DS_recipe<- tribble(
  ~variables,       ~dependencies,      ~func,              ~func_args,
  "DOMAIN",          NULL,              rep_n,              list(val = "DS"),
  "DSSEQ",          "USUBJID",          seq_fun,            NULL,
  dsvars,          ds_deps,             ds_fun,            NULL,

)



DS <- gen_reljoin_table(DS_join_recipe, DS_recipe, db = list(DM = DM),
                        keep = c("STUDYID", "SITEID", "USUBJID"))
