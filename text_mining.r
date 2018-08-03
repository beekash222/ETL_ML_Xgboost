rm(list=ls())
gc()

library(tm) #load text mining library
setwd('C:\\Users\\user\\Desktop') #sets R's working directory to near where my files are
documents  <-Corpus(DirSource("rule1"), readerControl = list(language="lat")) #specifies the exact folder where my text file(s) is for analysis with tm.
summary(documents)  

documents <- gsub("\r?\n|\r", " ",documents)
documents = tolower(documents)

documents
documents <- Corpus(VectorSource(documents))

docs <- tm_map(documents,removePunctuation) 

exceptions   <- c("if","in","move","then","=")
my_stopwords <- setdiff(stopwords("en"), exceptions)
documents = tm_map(documents, removeWords, my_stopwords)

library(stringr)
gsub("\r?\n|\r", " ",documents)

trimws(documents,"right")
documents[[1]]$content



