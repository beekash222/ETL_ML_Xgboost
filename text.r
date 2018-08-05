####################################################
rm(list=ls())
gc()
library(tm)
#load text mining library
setwd('C:\\Users\\user\\Desktop') #sets R's working directory to near where my files are
documents  <-Corpus(DirSource("rule1")) #specifies the exact folder where my text file(s) is for analysis with tm.
summary(documents)  

library(stringr)
documents <- str_replace(documents, " \\(.*\\)", "")
#documents <- gsub("('_')[[:punct:]]", "", documents)

#f <- content_transformer(function(x, pattern) gsub(pattern, "", x))
#documents <- tm_map(documents, f, "[!#$%&'*+,./)(:;<=>?@\\`{|}~]")

documents <- gsub("\r?\n|\r", " ",documents)


library(tm)
documents <- tolower(documents)
documents <- Corpus(VectorSource(documents))
documents <- tm_map(documents, removeNumbers)
f <- content_transformer(function(x, pattern) gsub(pattern, "", x))
documents <- tm_map(documents, f, "[][!#$%()'*.,:;<=>@^|~`{}]")
#documents <- tm_map(documents,removePunctuation)
documents <- tm_map(documents, stripWhitespace)

#exceptions   <- c("if","in","then","=","right","justify","fill")
#my_stopwords <- setdiff(stopwords("en"), exceptions)
#documents = tm_map(documents, removeWords, my_stopwords)
my_stopwords <- c("else","move","then","match","join","equal","=","convert","format","right","justify","fill","direct","first","byte","concatenate")
documents = tm_map(documents, removeWords, c(my_stopwords,stopwords("en")))
documents <- tm_map(documents, stripWhitespace)
#documents <- tm_map(documents, removePunctuation )


freq = as.data.frame(documents[[1]]$content)
freq$`documents[[1]]$content` <-  gsub("       ", " ", freq$`documents[[1]]$content`)
freq$`documents[[1]]$content` <-  gsub(" ", ",", freq$`documents[[1]]$content`)
names(freq)[1] <- paste("columns")

library(tidyr)

freq <- separate_rows(freq,"columns", sep=",")

new_freq <- as.data.frame(table(freq))


View(new_freq)

library(data.table)
DT <- data.table(freq)

y1 <- DT[, .(count = columns), by = columns]

View(y1)
View(DT)
###################################################

