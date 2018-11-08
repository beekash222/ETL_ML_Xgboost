rm(list=ls())


df1 <- read.csv('C:\\Users\\user\\Desktop\\Data Comparison\\mushrooms.csv',header = T)
df2 <- read.csv('C:\\Users\\user\\Desktop\\Data Comparison\\mushrooms - Copy.csv',header = T)

a <- nrow(df1)
b <- nrow(df2)

new_data_check <- isTRUE( all.equal(df1,df2) )

new_data <- all.equal(df1,df2)

new_data <- grep(x = new_data,pattern = "string mismatches",value = TRUE)

new_data_col <- new_data

new_data
library(stringr)
new_data_col <- gsub("Component","",str_trim(new_data_col))
new_data_col <- gsub(": \\w+","",str_trim(new_data_col))
new_data_col <- gsub("string mismatches","",str_trim(new_data_col))
new_data_col <- gsub("\\s+"," ",str_trim(new_data_col))
new_data_col <- noquote(new_data_col)
new_data_col
