#
# read all generations of Pokémon from pokemondb.net
#
# lgreski
# 21 November 2020

library(rvest)
pages <- 1:8
baseURL <- "https://pokemondb.net/pokedex/stats/gen"

pokemonList <- lapply(pages,function(x){
  html <- read_html(paste0(baseURL,x))
  tableNode <- html_node(html,xpath="//*[(@id = 'pokedex')]")
  data <- html_table(html,header=TRUE)[[1]]
  colnames(data)[1] <- "ID"
  # add generation ID and return 
  data$generation <- x
  data
})
names(pokemonList) <- paste0("gen",pages)

thePokemon <- do.call(rbind,pokemonList)

# now clean up the names and types 
# h/t https://stackoverflow.com/questions/36778221/breaking-up-pascalcase-in-r/36778559#36778559

types <- strsplit(gsub('[a-z]\\K(?=[A-Z])', ' ',thePokemon$Type, perl=T)," ")
thePokemon$Type1 <- unlist(lapply(types,function(x) x[1]))
thePokemon$Type2 <- unlist(lapply(types,function(x) ifelse(is.na(x[2])," ",x[2])))
pokemonNames <- strsplit(gsub('[a-z]\\K(?=[A-Z])', '--', pokemonList[[8]][[2]], perl=T),"--")