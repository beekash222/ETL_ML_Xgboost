rm(list=ls())
gc()

library("xlsx")
library("data.table")
library(stringr)
library(dplyr)

setwd("C:\\Users\\user\\Desktop\\xml parsing")

inp <- read.xlsx("input.xlsx",1,header = T)

tab.read <- read.csv("C:\\Users\\user\\Desktop\\xml parsing\\food.txt",header = FALSE)

write.table(tab.read,"table_rule.txt",quote = FALSE,row.names = FALSE,col.names = FALSE,sep = "\t")

tab_read <- readLines("C:\\Users\\user\\Desktop\\xml parsing\\table_rule.txt")

trim <- gsub("^\\s+|\\s+$", "", tab_read)

trim <- paste(trim,collapse = " ")

####################
for(i in 1: length(trim))
{
  trim[i] <- strsplit(as.character(trim), split="</food>")
}

trim <- unlist(trim)

#trim <- gsub(".", "EEEE", trim)

##########
x <- list()
z <- list()
u <- list()
y = list()
m <- list()

for(j in 1 : nrow(inp))
{
for(i in 1 : length(trim))
   {
     z[j] <-  paste(inp$Columns[j],"(.*?)",inp$Columns1[j],"|.")  
     z[j] <-  gsub("\\s+", "", z[j])
     x[i] <-  gsub(z[j], "\\1 ", trim[i])
   }
  x <- unlist(x)
  
  y <- gsub("(,).\\s+\\s+", "@", x)
  
  u[[j]] = y
  
  big = do.call(cbind,u)

} 

big = big[-length(x),]

write.table(y,"table_rule1.txt",quote = FALSE,row.names = FALSE,col.names = FALSE,sep =' ')


write.table(big,"table_rule1.txt",quote = FALSE,row.names = FALSE,col.names = FALSE,sep ='@')

tab.read1 <- read.csv("C:\\Users\\user\\Desktop\\xml parsing\\table_rule1.txt",header = FALSE,sep ='@')


df <- tab.read1[, colSums(is.na(tab.read1)) != nrow(tab.read1)]

  #y <- gsub("^\\s+|\\s+$", "", x[i])


View(df)


