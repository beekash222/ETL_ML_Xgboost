rm(list=ls())
gc()

library("xlsx")
library("data.table")

setwd("C:\\Users\\user\\Desktop\\beekash")

col.read <- read.xlsx("zz.xlsx",1,header = T)

col.read <- col.read$TRANSFORMATION.RULE

write.table(col.read,"column_rule.txt",quote = FALSE,row.names = FALSE,col.names = FALSE,sep = "\t")

tab.read <- read.xlsx("zz.xlsx",2,header = T)

write.table(tab.read,"table_rule.txt",quote = FALSE,row.names = FALSE,col.names = FALSE,sep = "\t")

col_read <- readLines("C:\\Users\\user\\Desktop\\beekash\\column_rule.txt")

tab_read <- readLines("C:\\Users\\user\\Desktop\\beekash\\table_rule.txt")

file_read <- paste(col_read,tab_read,sep = "@@@")

for(i in 1: length(file_read))
{
  file_read[i] <- strsplit(as.character(file_read[i]), split="\\@@@")
}

file_read <- unlist(file_read)

file_read

library(stringr)
library(tm)
head(claim)

if_data <- grep(x = file_read,pattern = "^if",value = TRUE)
