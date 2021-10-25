# Set up environment ----
library(rtables)            # https://roche.github.io/rtables/

# Load data ----
# adsl <- readRDS("data_demo/ADSL.rds")
# adae <- readRDS("data_demo/ADAE.rds")
# advs <- readRDS("data_demo/ADVS.rds")

# Resources ----
# Vignette: https://roche.github.io/rtables/articles/clinical_trials.html
# Specifications for tables: https://docs.google.com/presentation/d/1bmAtJO7auQHGdnZj2Pw7mgJu-x0oZtpgRGe66uupF-U/edit#slide=id.gfa0fc69b34_0_333

# Demographics Table ----
source("tables_func/t_dm.R")

# Adverse Events Table ----
source("tables_func/t_ae.R")

# Vital Signs Table ----
source("tables_func/t_vs.R")

# Try it out:
# t_dm(adsl)
# t_ae(adae, adsl)
# t_vs(advs, adsl)
