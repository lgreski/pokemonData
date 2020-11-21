# read and write updated Pokemon data
# 
library(readxl)
thePokemon <- read_xlsx("Pokemon.xlsx")
write.csv(thePokemon,file="Pokemon.csv",row.names=FALSE)

# build single spreadsheet from genXX.csv files
thePokemon <- do.call(rbind,lapply(1:8,function(x){
  read.csv(sprintf("gen%02d.csv",x))
  }))

# write spreadsheet to csv
write.csv(thePokemon,file="Pokemon.csv",row.names=FALSE)


# extract & write files
generations <- 1:8
lapply(generations,function(x){
  data <- thePokemon[thePokemon$Generation == x,]
  write.csv(data,
            sprintf("gen%02d.csv",x),
            row.names=FALSE)
})

# create zip file
fileList <- unlist(lapply(generations,function(x){
  sprintf("gen%02d.csv",x)
}))
zip("PokemonData.zip",fileList)