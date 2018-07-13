rm(list =ls())

library(xlsx)
library(data.table)
setwd("C:\\Users\\user\\Desktop")


s1 <- read.xlsx("measures.xlsx",1,header = T)


Final_Component <- c(100010012,100010013,100010015,100010017)

s1 <- s1[s1$Component_ID %in% Final_Component, ]

DT <- data.table(s1)

#DT <- data.frame(s1)

y1 <- DT[, .(count = length(unique(Mesures_Id))), by = Component_ID]


y1 <- as.data.frame(y1)

#len <- length(Final_Component)

y2 <- data.frame()
j = 1
x = 0
k = 1

for(i in 1:length(Final_Component))
{
  for (j in 1: nrow(y1))
  {
    
    y  = Final_Component[i]
     
       if (y == y1[j,1])
       {
       
        x[k] = Final_Component[i]
        k = k+1  
       }
    
    
      }

  
}


m <-  setdiff(Final_Component,x) 


if (length(m) > 0)
{
for( k in 1:length(m))
{
y2[k,1] = m[k]
y2[k,2] = "0"
names(y2)[1] <- paste("Measures_component_Id")
names(y2)[2] <- paste("COUNT_COF")
}
}

final <- rbind(y1,y2)


for(k in 1:nrow(final))
{
  if(final$count[k] == '0')
  {
    final$Target[k] <- "Y"

  }
else
  
    final$Target[k] <- "N"
}

final <- final[order(final$Measures_Component_Id),]
#######################

s2 <- read.xlsx("Measure_COF.xlsx",1,header = T)

str(s2)

s2 <- s2[s2$Component_ID %in% Final_Component, ]

DT1 <- data.table(s2)

#DT <- data.frame(s1)

y3 <- DT1[, .(count = length(unique(Mesures_Id))), by = Component_ID]


y3 <- as.data.frame(y3)
y4 <- data.frame()
j = 1
z = 0
k = 1

for(i in 1:length(Final_Component))
{
  for (j in 1: nrow(y1))
  {
    
    y  = Final_Component[i]
    
    if (y == y3[j,1])
    {
      
      z[k] = Final_Component[i]
      k = k+1  
    }
    
    
  }
  
  
}


n <-  setdiff(Final_Component,z) 


if (length(n) > 0)
{
  for( k in 1:length(n))
  {
    y4[k,1] = n[k]
    y4[k,2] = "0"
    names(y4)[1] <- paste("Component_ID")
    names(y4)[2] <- paste("count")
  }
}


final1 <- rbind(y3,y4)


for(k in 1:nrow(final1))
{
  if(final1$count[k] == '0')
  {
    final1$Target[k] <- "Y"
    
  }
  else
    
    final1$Target[k] <- "N"
}

View(final1)

final1 <- final1[order(final1$Measures_Component_Id),]
#########K Means Clustering#########


library(dummies)

final_copy <- final
final1_copy <- final1

final_copy <- cbind(final_copy,dummy(final_copy$Target,sep = "_"))

final1_copy <- cbind(final1_copy,dummy(final1_copy$Target,sep = "_"))


final1_copy$Target <- NULL
final_copy$Target <- NULL

no_of_clusters = 2
iteration = 100



km <- kmeans(final_copy,no_of_clusters,iter.max = iteration,nstart = 100)

no_of_clusters = 2
iteration = 100
km1 <- kmeans(final1_copy,no_of_clusters,iter.max = iteration,nstart = 100)


final$cluster <- km$cluster
final1$cluster1 <- km1$cluster

New_final <- cbind(final,final1)

View(New_final)


for (x in 1: nrow(New_final))
{
  if(New_final$cluster[x] == New_final$cluster1[x] )
  {
    New_final$COF <- "NA"
  }
  else if(New_final$cluster[x] != New_final$cluster1[x] )
  {
    New_final$COF <- "Y"
  }
}


