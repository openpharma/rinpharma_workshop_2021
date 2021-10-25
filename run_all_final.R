
# Create SDTM, ADaM and Tables
# Make sure the root folder is the rinpharma_workshop_2021

rm(list = ls()) # remove all objects from environment

## Remove Deliveries ----

# all.files = FALSE in order to not include hidden files
files_to_cleanup <- c(
  list.files("data_demo/", recursive = TRUE, all.files = FALSE, full.names = TRUE),
  list.files("outputs/", recursive = TRUE, all.files = FALSE, full.names = TRUE)
)
files_to_cleanup

unlink(files_to_cleanup)


## Create synthetic SDTM data ----
source("programs_final/SDTM.R")


## Create ADaM data ----

source("programs_final/ADaM.R")


## Create Static Tables ----

source("programs_final/tables_static.R")


## Check if required files are in the data and outputs folder ----

list.files("outputs/")
