
make_usub <- function(.df, n = nrow(df)){
  paste(.df$STUDYID, .df$SITEID, .df$SUBJID, sep = "-")
}
