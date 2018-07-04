# read and write updated Pokemon data
# 
library(readxl)
thePokemon <- read_xlsx("Pokemon.xlsx")
write.csv(thePokemon,file="Pokemon.csv",row.names=FALSE)
# extract gen07 and write file
gen07 <- thePokemon[thePokemon$Generation == 7,]
write.csv(gen07,file="gen07.csv",row.names=FALSE)