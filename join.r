rm(list=ls())
gc()

claim <- readLines("C:\\Users\\user\\Desktop\\ss1.txt")

library(stringr)
library(tm)
head(claim)

if_data <- grep(x = claim,pattern = "^join|Match",value = TRUE)

if_data

if_data <- gsub("\\s+"," ",str_trim(if_data))


#if_data = gsub("[[:space:]]","",if_data)




for(i in 1: length(if_data))
{
  if_data[i] <- strsplit(as.character(if_data[i]), split="\\on")
}


if_data <- unlist(if_data)

if_data_1 <- if_data

if_data_1

if_data_1 <- gsub("\\s+"," ",str_trim(if_data_1))

for(i in 1: length(if_data))
{
  if_data_1[i] <- strsplit(as.character(if_data_1[i]), split="and")
}


if_data_1 <- unlist(if_data_1)

if_data_2 <- if_data_1

if_data_2

if_data_2 <- grep(x = if_data_2,pattern = "=",value = TRUE)

if_data_2 <- gsub("\\s+"," ",str_trim(if_data_2))
if_data_2

if_data_2 <- gsub("Move \\w+"," ",str_trim(if_data_2))
if_data_2 <- gsub("\\s+"," ",str_trim(if_data_2))
