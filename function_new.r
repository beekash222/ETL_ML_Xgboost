measures <- function(s1,s2,Measures_Component_Id_COF,Mesures_Id_COF,Measures_Component_Id_QI,Mesures_Id_QI)
{

#Measures_Component_Id_COF <- 1
#Mesures_Id_COF <- 2
#Measures_Component_Id_QI <- 1
#Mesures_Id_QI <- 2
#Model_Name <- "Measures"

library(xlsx)
library(data.table)
#setwd("C:\\Users\\user\\Desktop")

s1 <- read.xlsx("measures.xlsx",1,header = T)

names(s1)[Measures_Component_Id_COF] <- paste("Measures_Component_Id_COF")
names(s1)[Mesures_Id_COF] <- paste("Mesures_Id_COF")
Final_Component <- c("100010012","100010013","100010015","100010017","100010019")


s1 <- s1[s1[,Measures_Component_Id_COF] %in% Final_Component, ]

DT <- data.table(s1)

#DT <- data.frame(s1)

y1 <- DT[, .(COUNT_COF = length(unique(Mesures_Id_COF))), by = Measures_Component_Id_COF]

y1 <- as.data.frame(y1)

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
    names(y2)[1] <- paste("Measures_Component_Id_COF")
    names(y2)[2] <- paste("COUNT_COF")
  }
}

final <- rbind(y1,y2)

final[3] <- NA

for(k in 1:nrow(final))
{
  if(final[2][k,] == '0')
  {
    
    final[3][k,] <- "Y"
    
  }
  else
  {
  
    final[3][k,] <- "N"
  }
}  
names(final)[3] <- paste("TARGET")

final <- final[order(final[Measures_Component_Id_COF]),]

#######################

#s2 <- read.xlsx("Measure_QI.xlsx",1,header = T)

names(s2)[Measures_Component_Id_QI] <- paste("Measures_Component_Id_QI")
names(s2)[Mesures_Id_QI] <- paste("Mesures_Id_QI")


s2 <- s2[s2[,Measures_Component_Id_QI] %in% Final_Component, ]

DT1 <- data.table(s2)

#DT <- data.frame(s1)
y3 <- DT1[, .(COUNT_QI = length(unique(Mesures_Id_QI))), by = Measures_Component_Id_QI]

y3 <- as.data.frame(y3)

y4 <- data.frame()
j = 1
z = 0
k = 1

for(i in 1:length(Final_Component))
{
  for (j in 1: nrow(y3))
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
    names(y4)[1] <- paste("Measures_Component_Id_QI")
    names(y4)[2] <- paste("COUNT_QI")
  }
}

final1 <- rbind(y3,y4)

final1[3] <- NA

for(k in 1:nrow(final1))
{
  if(final1[2][k,] == '0')
  {
    final1[3][k,] <- "Y"
    
  }
  else
    
    final1[3][k,]  <- "N"
}

names(final1)[3] <- paste("TARGET")
final1 <- final1[order(final1[Measures_Component_Id_QI]),]
########clustering######

library(dummies)
final_copy <- final
final1_copy <- final1

final1_copy[2] <- NULL
final_copy[2] <- NULL

final_copy[1] <- NULL
final1_copy[1] <- NULL


final_copy <- dummy.data.frame(final_copy, names = c("TARGET"), sep= "_")

set.seed(1234)
no_of_clusters = 2
iterations = 200

start = Sys.time()
km = kmeans(
     final_copy,no_of_clusters,
     iter.max = iterations,
     nstart = 100
)

final1_copy <- dummy.data.frame(final1_copy, names = c("TARGET"), sep= "_")

set.seed(1234)
no_of_clusters = 2
iterations = 200

start = Sys.time()
km1 = kmeans(
  final1_copy,no_of_clusters,
  iter.max = iterations,
  nstart = 100
)

final[4] <- "NA"
names(final)[4] <- paste("cluster")
final1[4] <- "NA"
names(final1)[4] <- paste("cluster1")

final[4] <- km[1]
final1[4] <- km1[1]

New_final <- cbind(final,final1)

View(New_final)
New_final1 <- New_final[New_final[4] == New_final[8],]
New_final2 <- New_final[New_final[4] != New_final[8],]

New_final1[9] <- "NA"
names(New_final1)[9] <- paste("COF_CHECK_FOR_PRESENCE_OF_COMPONENT")
New_final2[9] <- "NA"
names(New_final2)[9] <- paste("COF_CHECK_FOR_PRESENCE_OF_COMPONENT")

New_final1[9] <- "NA"
New_final2[9] <- "Y"

New_final3 <- rbind(New_final1,New_final2)

###############
New_final3[c(3,4,7,8)] <- NULL

New_final3[6] <- "NA"
names(New_final3)[6] <- paste("Result")

for(l in 1:nrow(New_final3))
{
  if(New_final3[5][l,] == "NA")
  {
    New_final3[6][l,] <- "PASS"
  }
  else
    New_final3[6][l,] <- "FAIL"
  
}


result<- New_final3

result_file_name <- paste(Model_Name, "_Results.csv",sep = "")
write.csv(result,result_file_name)
result_read <- read.csv(result_file_name)
write.csv(result_read,result_file_name)

}



