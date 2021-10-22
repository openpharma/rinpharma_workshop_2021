

library(respectables)                   # https://roche.github.io/respectables/
# library(synthetic.cdisc.data)           # https://roche.github.io/synthetic.cdisc.data/
library(tibble)


seq_fun <- function(.df, n){
  spl <- split(seq_along(.df$USUBJID), .df$USUBJID)
  sp <-lapply(spl, function(x){seq_along(x)})
  unlist(sp)

}

source("programs_final/sdtm/dm.R")
source("programs_final/sdtm/ae.R")
source("programs_final/sdtm/vs.R")
source("programs_final/sdtm/ds.R")
source("programs_final/sdtm/ex.R")


datemutator <- function(dataset){
  ds_names <- names(dataset)
  dtc_names <- ds_names[grepl("DTC", ds_names)]
  for (date_name in dtc_names){
    dataset[[date_name]] <- as.character(dataset[[date_name]])
  }
  dataset
}

DM <- datemutator(DM)
AE <- datemutator(AE)
VS <- datemutator(VS)
DS <- datemutator(DS)
EX <- datemutator(EX)


saveRDS(DM, "data/DM.rds")
saveRDS(AE, "data/AE.rds")
saveRDS(VS, "data/VS.rds")
saveRDS(DS, "data/DS.rds")
saveRDS(DS, "data/EX.rds")



