rm(list=ls())
gc()

claim <- readLines("C:\\Users\\user\\Desktop\\ss1.txt")

library(stringr)
library(tm)
head(claim)

if_data <- grep(x = claim,pattern = "^if",value = TRUE)

#if_data <- tolower(if_data)
if_data <- gsub("in","=",if_data)
#if_data <- gsub("move","then",if_data)
#if_data <- gsub("else","then",if_data)

if_data

stopwords <- c("move")
if_data = removeWords(if_data,stopwords) 

if_data <- gsub("\\s+"," ",str_trim(if_data))


#if_data = gsub("[[:space:]]","",if_data)

for(i in 1:length(if_data))
{
  if_data[i] = paste(unique(strsplit(if_data, "move")[[i]]), collapse = ' ')
}

if_data


for(i in 1: length(if_data))
{
 if_data[i] <- strsplit(as.character(if_data[i]), split="\\.")
}


if_data <- unlist(if_data)

if_data_1 <- if_data

######################POSITIVE###########

for(i in 1: length(if_data))
{
  if_data_1[i] <- strsplit(as.character(if_data[i]), split="else ")
}

if_data_1 <- unlist(if_data_1)
if_data_1 <- gsub("\\s+"," ",str_trim(if_data_1))


if_data_New <- grep(x = if_data_1,pattern = "^if",value = TRUE)

if_data_New

########################NEGATIVE###############
if_data_2 <- if_data

if_data_2

#if_data_2 <- gsub("then \\c"," ",str_trim(if_data_2))
if_data_2 <- gsub("then \\w+"," ",str_trim(if_data_2))
if_data_2 <- gsub("\\s+"," ",str_trim(if_data_2))


if_data_2 <- gsub("=","!=",if_data_2)
if_data_2 <- gsub("<",">",if_data_2)
if_data_2 <- gsub("else","then",if_data_2)

if_data_2

if_data_last <- paste(if_data_New,if_data_2,sep = "@@@")


for(i in 1: length(if_data_last))
{
  if_data_last[i] <- strsplit(as.character(if_data_last[i]), split="\\@@@")
}

if_data_last <- unlist(if_data_last)
############WHERE CONDITION############

if_data_last <- gsub("then \\w+","",str_trim(if_data_last))
if_data_last <- gsub("if","",str_trim(if_data_last))

if_data_last <- gsub("\\s+"," ",str_trim(if_data_last))

if_data_last

write.csv(if_data_last, file = "MyData.csv",row.names=FALSE)

