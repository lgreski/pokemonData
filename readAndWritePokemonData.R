# read and write updated Pokemon data
# 
library(readxl)
thePokemon <- read_xlsx("Pokemon.xlsx")
write.csv(thePokemon,file="Pokemon.csv",row.names=FALSE)

# starting with Pokemon.csv instead of xlsx
thePokemon <- read.csv("Pokemon.csv")
library(writexl)
write_xlsx(thePokemon,"Pokemon.xlsx")

# build single spreadsheet from genXX.csv files
thePokemon <- do.call(rbind,lapply(1:8,function(x){
  read.csv(sprintf("gen%02d.csv",x))
  }))

# write spreadsheet to csv
write.csv(thePokemon,file="Pokemon.csv",row.names=FALSE)


# extract & write individual csv files from single Pokemon file
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
if(file.exists("PokemonData.zip")) file.remove("PokemonData.zip")
zip("PokemonData.zip",fileList)

# write as individual spreadsheets and zip
# write single spreadsheet from genXX.csv files
library(writexl)
thePokemon <- do.call(rbind,lapply(1:8,function(x){
  df <-read.csv(sprintf("gen%02d.csv",x))
  write_xlsx(df,path=sprintf("gen%02d.xlsx",x))  
}))

# create zip file
fileList <- unlist(lapply(1:8,function(x){
  sprintf("gen%02d.xlsx",x)
}))
if(file.exists("PokemonXLSX.zip")) file.remove("PokemonXLSX.zip")
zip("PokemonXLSX.zip",fileList)