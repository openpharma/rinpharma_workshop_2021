visitn_fn <- function(.df, n){
  visit <- .df$VISIT
  sample(c(1, 5), n, replace = TRUE)
}
