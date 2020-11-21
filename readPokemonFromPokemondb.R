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
