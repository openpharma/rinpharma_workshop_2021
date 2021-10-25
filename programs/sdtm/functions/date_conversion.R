#converts any column that contains DTC to <character>
#an alternative would be to pick any column of type <date> and convert
date_conversion <- function(df){
  dfnew <- df %>% dplyr::mutate_at(dplyr::vars(dplyr::contains("DTC")), as.character)
  return(dfnew)
}
