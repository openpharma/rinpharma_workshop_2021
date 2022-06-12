visitn_fn <- function(.df, n){
  as.numeric(ifelse(grepl("\\d", .df$VISIT),
                    regmatches(.df$VISIT,regexpr("\\d",.df$VISIT)),
                    1))
}
