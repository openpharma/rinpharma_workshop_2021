date_gen <- function(.df, n){
  as.Date(.df$RFSTDTC) + lubridate::days((.df$VISITNUM-1) * 14)
}
