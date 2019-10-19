# read and write updated Pokemon data
#
library(readxl)
thePokemon <- read_xlsx("Pokemon.xlsx")
write.csv(thePokemon, file = "Pokemon.csv", row.names = FALSE)

i <- 1

while (i < 8) {
    write.csv(
    thePokemon[thePokemon$Generation == i,],
    file = paste(paste("gen0", i, sep = ""), ".csv", sep = ""), row.names = FALSE)
    i = i + 1
}
