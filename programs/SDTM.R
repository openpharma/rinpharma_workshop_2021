

library(respectables)                   # https://roche.github.io/respectables/
library(tibble)


source("programs/sdtm/functions/seq_fun.R")

# These are incomplete! We need to update these!
source("programs/sdtm/dm.R")
source("programs/sdtm/ae.R")
source("programs/sdtm/vs.R")

## These are complete; do not touch!
source("programs/sdtm/ds.R")
source("programs/sdtm/ex.R")

# Modify dates here!



saveRDS(DM, "data/DM.rds")
saveRDS(AE, "data/AE.rds")
saveRDS(VS, "data/VS.rds")
saveRDS(DS, "data/DS.rds")
saveRDS(DS, "data/EX.rds")



