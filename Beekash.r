rm(list=ls())
gc()

claim <- readLines("C:\\Users\\user\\Desktop\\ss1.txt")

library(stringr)
library(tm)
head(claim)

#my_stopwords <- c("else","move","then","match","join","equal","=","convert","format","right","justify","fill","direct","first","byte","concatenate")
#documents = tm_map(documents, removeWords, c(my_stopwords,stopwords("en")))

claim <- grep(x = claim,pattern = "if|join|whether",value = TRUE)

claim

for(i in 1:length(claim))
{
  #claim[i] <- gsub("if \\w+","",str_trim(claim[i]))
  #claim[i] <- gsub("_","",claim[i])
  claim[i] <- gsub('^.*if\\s*|\\s*then.*$', '', claim[i]) 
  claim[i] <- gsub('^.*join\\s*|\\s*.then*$', '', claim[i]) 
  claim[i] <- gsub('^.*whether \\w+\\s*|\\s*then.*$', '', claim[i])
}

claim <- gsub("with","=",claim)

