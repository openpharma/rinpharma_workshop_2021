date_gen <- function(.df, n){
  start_date <- .df$RFSTDTC
  vis_num <- .df$VISITNUM
  rand_posixct(start = start_date, end = start_date + lubridate::years(2))

}
