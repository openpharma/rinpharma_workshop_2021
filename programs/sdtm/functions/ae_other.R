
aes_func <- function(n, .df, lookup = ae_lookup) {
  lookup[sample(1:NROW(lookup), NROW(.df), replace =TRUE),]
}

aeterm_func <- function(n, .df) gsub("dcd", "trm", .df$AEDECOD, fixed=TRUE)



time_func <- function(n, .df) {
  tstart <- .df$RFSTDTC
  tend <- .df$RFENDTC
  ret <- data.frame( AESTDTC = rand_posixct(start = tstart, end = tend))

  ret$AEENDTC = rand_posixct(start = ret$AESTDTC , end = tend)
  ret

}

aecn_func <- function(n, .df){
  tibble(
    AEACN = ifelse(
      .df$AETOXGR == 5, "DRUG WITHDRAWN",
      ifelse(
        .df$AETOXGR >= 3, sample(c("DRUG WITHDRAWN", "DRUG INTERRUPTED", "DOSE NOT CHANGED"), n, replace = TRUE),
        "DOSE NOT CHANGED"
      )
    ),
    ifelse(
      .df$AETOXGR == 5, "SUBJECT DISCONTINUED FROM STUDY",
      ifelse(
        AEACN == "DRUG WITHDRAWN", sample(c("PROCEDURE/SURGERY", "NONE", "SUBJECT DISCONTINUED FROM STUDY"),
                                          n, replace = TRUE),
        ifelse(
          AEACN == "DRUG INTERRUPTED",  sample(c("PROCEDURE/SURGERY", "NONE"),
                                               n, replace = TRUE),
          "NONE"
        )
      )
    )
  )
}
