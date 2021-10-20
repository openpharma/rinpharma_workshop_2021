
library(rtables)            # https://roche.github.io/rtables/

# Demographics Table ----

t_dm <- function(adsl) {
  lyt <- basic_table()

  build_table(lyt, adsl)
}

# Adverse Events Table ----

t_ae <- function(popdf, adae) {
  lyt <- basic_table()

  build_table(lyt, adae, alt_counts_df = popdf)
}


# Disposition ----

t_dsp <- function(adsl) {
  lyt <- basic_table()

  build_table(lyt, adsl)
}



# Medical History Table ----

t_mh <- function() {

}

