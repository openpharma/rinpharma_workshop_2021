

library(respectables)                   # https://roche.github.io/respectables/
library(tibble)


source("programs/sdtm/functions/seq_fun.R")

# These are incomplete! We need to update these!
source("programs/sdtm/dm.R")
source("programs/sdtm/ae.R")
source("programs/sdtm/vs.R")

## These are complete; do not touch!
source("programs_final/sdtm/ds.R")
source("programs_final/sdtm/ex.R")

# Modify dates here!
source("programs/sdtm/functions/date_conversion.R")
VS <- date_conversion(VS)
AE <- date_conversion(AE)
DM <- date_conversion(DM)


saveRDS(DM, "data/DM.rds")
saveRDS(AE, "data/AE.rds")
saveRDS(VS, "data/VS.rds")
saveRDS(DS, "data/DS.rds")
saveRDS(EX, "data/EX.rds")




