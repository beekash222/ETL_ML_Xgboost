server <- function(input, output,session) {
  
 
  
  output$contents <- renderTable({
    
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, head of that data file by default,
    # or all rows if selected, will be shown.
    
    req(input$file1)
    
    # when reading semicolon separated files,
    # having a comma separator causes `read.csv` to error
    tryCatch(
      {
        df <- read.csv(input$file1$datapath,
                       header = input$header,
                       sep = input$sep,
                       quote = input$quote)
      },
      error = function(e) {
        # return a safeError if a parsing error occurs
        stop(safeError(e))
      }
    )
    
    if(input$disp == "head") {
      return(head(df))
    }
    else {
      return(df)
    }
    
  })
  

  #######
  output$contents1 <- renderTable({
    
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, head of that data file by default,
    # or all rows if selected, will be shown.
    
    req(input$file2)
    
    # when reading semicolon separated files,
    # having a comma separator causes `read.csv` to error
    tryCatch(
      {
        df1 <- read.csv(input$file2$datapath,
                       header = input$header,
                       sep = input$sep,
                       quote = input$quote)
      },
      error = function(e) {
        # return a safeError if a parsing error occurs
        stop(safeError(e))
      }
    )
    
    if(input$disp == "head") {
      return(head(df1))
    }
    else {
      return(df1)
    }
    
  })
  ########
  observeEvent(input$rpart, {
  
    
    library(ggplot2)
    library(caret)          # For dummyVar and for data partitioning
    library(xgboost)        # For regression tree
    library(Matrix)         # For sparse matrix
    library(Metrics)
    
  
    train <- read.csv(input$file1$datapath,
                        header = input$header,
                        sep = input$sep,
                        quote = input$quote)
    
        
          
    test <- read.csv(input$file2$datapath,
                          header = input$header,
                          sep = input$sep,
                          quote = input$quote)
        
      
 
  ## 4
  train$Member_ID <- NULL
  train$BENEFIT_CD <- NULL
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
  #test <- read.csv(file.choose(),header = T)
  test$Member_ID <- NULL
  test$BENEFIT_CD <- NULL
  sparse_matrix_test <- sparse.model.matrix( ~., data = test)
  summary(sparse_matrix_test)
  colnames(sparse_matrix_test)
  sparse_matrix_test@Dimnames
  
  # 7 Make predictions
  pred <- predict(model, sparse_matrix_test)
  
  # 8. Check accuracy
  rmse(pred,test$COB_SAVINGS_AMT)
  
  #Check the match and unmatch
  test$Pred <- round(pred)
  #test$result <- ifelse(test$COB_SAVINGS_AMT==test$Pred, "match","Unmatch")
  output$result<-renderTable({
    test    })
  #show in graph match and unmatch
  #barplot(table(test_new$result),col = c("forestgreen", "deepskyblue"))
  
  #show the unmatch rows
  #test_new[test_new$result == "Unmatch",1:8]
  
  })
  
}
