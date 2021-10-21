

library(respectables)                   # https://roche.github.io/respectables/
# library(synthetic.cdisc.data)           # https://roche.github.io/synthetic.cdisc.data/
library(tibble)


seq_fun <- function(.df, n){
  spl <- split(seq_along(.df$USUBJID), .df$USUBJID)
  sp <-lapply(spl, function(x){seq_along(x)})
  unlist(sp)

}

source("programs/sdtm/dm.R")
source("programs/sdtm/ae.R")
source("programs/sdtm/vs.R")
source("programs/sdtm/ds.R")


saveRDS(DM, "data/DM.rds")
saveRDS(AE, "data/AE.rds")
saveRDS(VS, "data/VS.rds")
saveRDS(DS, "data/DS.rds")



