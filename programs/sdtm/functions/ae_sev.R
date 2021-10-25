aesev_func <- function(n, .df) {
  toxgr <- .df$AETOXGR

  aesev <- dplyr::case_when(
    toxgr == 1 ~ "MILD",
    toxgr %in% c(2, 3) ~ "MODERATE",
    TRUE ~ "SEVERE"
    )

  return(aesev)

}
