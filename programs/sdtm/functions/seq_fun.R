seq_fun <- function(.df, n){
  spl <- split(seq_along(.df$USUBJID), .df$USUBJID)
  sp <-lapply(spl, function(x){seq_along(x)})
  unlist(sp)

}
