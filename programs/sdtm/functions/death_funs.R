death_date <- function(.df, n = nrow(df), death_prob, end_date){
  start_date <- .df$RFSTDTC

  # Create death date per requirement (after RFSTDTC)
  dthdtc <- rand_posixct(
    start_date + lubridate::days(1),
    start_date + lubridate::years(5)
  )

  # Randomly set ~50 % to NA to simulate non-deaths
  dthdtc[sample(1:length(dthdtc), size = floor(length(dthdtc)/2))] <- NA

  return(dthdtc)

}

death_flag <- function(.df, n = nrow(df)){
  dthdt <- .df$DTHDTC
  return(dplyr::if_else(is.na(dthdt), "N", "Y"))
}
