# 1
####### Call libraries #################
rm(list = ls()) ; gc()
library(ggplot2)
library(caret)          # For dummyVar and for data partitioning
library(xgboost)        # For regression tree
library(Matrix)         # For sparse matrix
library(Metrics)        # for rmse()


# 2
# Read files and process
setwd("")
# Read input file
tr<-read.csv(file.choose(), header=TRUE)
names(tr)
head(tr)
str(tr)

#2.1 Removing ID 
tr$Member_ID <- NULL
tr$BENEFIT_CD <- NULL

# 3. Create partition
trIndex <- createDataPartition(tr$COB_SAVINGS_AMT, p = 0.7, list = F)
train<-tr[trIndex,]
test<-tr[-trIndex,]


## 4
sparse_matrix <- sparse.model.matrix( ~., data = train)
summary(sparse_matrix)
colnames(sparse_matrix)
sparse_matrix@Dimnames
sparse_matrix[1,1]

# 5. Model now
model <- xgboost(data = sparse_matrix,
                 label = train$COB_SAVINGS_AMT,
                 max.depth = 4,
                 eta = 1,      # set 0, 0.5 and 1
                 nthread = 2,
                 nround = 100,  
                 objective = "reg:linear")

model

# 6. Convert test to sparse matrix
test <- read.csv(file.choose(),header = T)
test$Member_ID <- NULL
test$BENEFIT_CD <- NULL
sparse_matrix_test <- sparse.model.matrix( ~., data = test)
summary(sparse_matrix_test)
colnames(sparse_matrix_test)
sparse_matrix_test@Dimnames

# 7 Make predictions
pred <- predict(model, sparse_matrix_test)
pred

# 8. Check accuracy
rmse(pred,test$COB_SAVINGS_AMT)

#Check the match and unmatch
test$Pred <- round(pred)
test$result <- ifelse(test$COB_SAVINGS_AMT==test$Pred, "match","Unmatch")

#show in graph match and unmatch
barplot(table(test_new$result),col = c("forestgreen", "deepskyblue"))

#show the unmatch rows
test_new[test_new$result == "Unmatch",1:8]

View(test)
