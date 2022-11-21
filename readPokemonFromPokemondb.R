#
# read all generations of Pokémon from pokemondb.net
#
# lgreski
# 21 November 2020
# 20 November 2022 -- add support for Generation 9 Pokémon

library(rvest)
pages <- 1:9
baseURL <- "https://pokemondb.net/pokedex/stats/gen"

pokemonList <- lapply(pages,function(x){
  html <- read_html(paste0(baseURL,x))
  tableNode <- html_node(html,xpath="//*[(@id = 'pokedex')]")
  data <- html_table(html,header=TRUE)[[1]]
  colnames(data)[1] <- "ID"
  # add generation ID and return
  data$Generation <- x
  data
})
names(pokemonList) <- paste0("gen",pages)

thePokemon <- do.call(rbind,pokemonList)

# now clean up the names and types
# h/t https://stackoverflow.com/questions/36778221/breaking-up-pascalcase-in-r/36778559#36778559

types <- strsplit(gsub('[a-z]\\K(?=[A-Z])', ' ',thePokemon$Type, perl=T)," ")
thePokemon$Type1 <- unlist(lapply(types,function(x) x[1]))
thePokemon$Type2 <- unlist(lapply(types,function(x) ifelse(is.na(x[2])," ",x[2])))
pokemonNames <- strsplit(gsub('[a-z]\\K(?=[A-Z])', '--', thePokemon$Name, perl=T),"--")
thePokemon$Name <- unlist(lapply(pokemonNames,function(x) x[1]))
thePokemon$Form <- unlist(lapply(pokemonNames,function(x) ifelse(is.na(x[2])," ",x[2])))

# reorder columns & remove special characters from male & female Nidoran
thePokemon <- thePokemon[,c(1,2,14,12,13,4,5,6,7,8,9,10,11)]
thePokemon[29,"Name"] <- "Nidoran"
thePokemon[29,"Form"] <- "Female"
thePokemon[32,"Name"] <- "Nidoran"
thePokemon[32,"Form"] <- "Male"

# write as CSV file
write.csv(thePokemon,file="Pokemon.csv",row.names=FALSE)

# write as XLSX file
library(writexl)
write_xlsx(thePokemon,"Pokemon.xlsx")

# extract & write individual csv files from single Pokemon file
generations <- 1:9
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
