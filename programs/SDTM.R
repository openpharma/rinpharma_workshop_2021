

library(respectables)                   # https://roche.github.io/respectables/
# library(synthetic.cdisc.data)           # https://roche.github.io/synthetic.cdisc.data/
library(tibble)


# DM  ----

DM_recipe <- tribble(
  ~variables,       ~dependencies,      ~func,               ~func_args,
   c("USUBJID", "SUBJID", "SITEID"),    no_deps,
)


DM <- gen_table_data(N = 100, recipe = DM_recipe)

# AE  ----



# MH  ----

