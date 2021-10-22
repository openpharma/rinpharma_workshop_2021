make_age <- function(.df, n, min_age, max_age){
  AGE <- sample(seq(min_age, max_age), n, replace = TRUE)
  birthday <- .df$RFSTDTC - lubridate::years(AGE) - lubridate::days(round(runif(n, 0, 363), 0))
  tibble(BRTHDTC = as.Date(birthday), AGE = AGE)

}
