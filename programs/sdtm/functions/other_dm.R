end_date <- function(.df, n = nrow(df), end_date){
  out <- ifelse(!is.na(.df$DTHDTC),
                as.POSIXct(.df$DTHDTC),
                respectables::rand_posixct(start = .df$RFSTDTC, end = end_date))
  as.POSIXct(out, origin = "1970-01-01")
}

date_func <- function(.df, n = nrow(df), end_date){
  tibble(
    RFENDTC = end_date(.df, n = nrow(df), end_date),
    RFXSTDTC = rand_posixct(start = .df$RFSTDTC,
                            end = pmin(RFENDTC, .df$RFSTDTC + lubridate::days(2))),
    RFXENDTC = rand_posixct(start = RFXSTDTC,
                            end = pmin(RFENDTC, RFXSTDTC + lubridate::days(30)))
  )
}



make_arm <- function(.df, n = nrow(df), arms){
  out <- .df$ARMCD
  forcats::fct_recode(out, !!!arms)
  out
}
