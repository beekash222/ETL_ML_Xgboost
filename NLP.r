rm(list=ls())

Search_Engine <- function(query)
{
  #query <- "please provide krish_sha"
  library(tm)
  library(stringr)
  query <- tolower(query)
  query <- VCorpus(VectorSource(query))
  my_stopwords <- c("scenarios","related","need","please","provide","can","scenario","help","design","pattern","looking","test","validation","want")
  query = tm_map(query, removeWords, c(my_stopwords,stopwords("en")))
  query <- tm_map(query, stripWhitespace)
  #query <- tm_map(query, removePunctuation )
  query[["1"]][["content"]]
  query[["1"]][["content"]] <- gsub("\\s+"," ",str_trim(query[["1"]][["content"]]))
  
  setwd("C:\\Users\\user\\Desktop\\Clust")
  t1_final <- read.csv("sai2.csv",header =  T)
  t1_final[[1]] <- tolower(t1_final[[1]])
  #t1_final <- matrix()
  for (i in 1:nrow(t1_final))
  {
    for (i in 1:nrow(t1_final))
    {
      if(query[["1"]][["content"]] == t1_final[i,1])
      {
        #x <- t1_final[i,2]
        print(t1_final[i,2],max.levels = 0)
        
        i = i+1
        #break
        opt <- options(show.error.messages = FALSE)
        on.exit(options(opt))
        stop()
        #show.error.messages =  "TRUE"
      }
      
    
    if (query[["1"]][["content"]] != t1_final[i,1])
    {
      j = 0
      for(k in 1: nchar(query[["1"]][["content"]]))
      {
        for(m in 1: nchar(t1_final[i,1]))
        {
          if(substring(query[["1"]][["content"]],k,k) == substring(t1_final[i,1],m,m)) 
          {
            j  = j+1
            m = 0
            break
          }
          m = m+1
          }
        
        k=k+1
        }
        len = nchar(query[["1"]][["content"]])
        per = (j/len) * 100
        
        if(per > 75)
        {
          cat("Showing results for:")
          print(query[["1"]][["content"]])
          cat("search instead of : query")
          print(t1_final[i,1])
          print(t1_final[i,2],max.levels = 0)
          #i = i+1
        }

    }
  else
    print("0")
  }
    break
}
}



Search_Engine("please provide beehhh")


