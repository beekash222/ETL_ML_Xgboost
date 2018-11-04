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
    
    train <- read.csv(input$file1$datapath,
                      header = input$header,
                      sep = input$sep,
                      quote = input$quote)
    
    
    
    test <- read.csv(input$file2$datapath,
                     header = input$header,
                     sep = input$sep,
                     quote = input$quote)
    
   
    
    a <- nrow(train)
    b <- nrow(test)
    
    library(dplyr)
    
    new_data <- setdiff(train,test)
    new_data1 <- setdiff(test,train)
    
    file_type <- 'NA'  
    
    c <- nrow(new_data)
    
    if(c >= 1) 
    {
    new_data <- cbind(file_type,new_data)
    new_data1 <- cbind(file_type,new_data1)
    new_data$file_type <- "SOURCE"
    new_data1$file_type <- "TARGET"
    for(i in 1 : ncol(new_data))
    {
      if(as.character(new_data[i]) %in% as.character(new_data1[i]))
      {
        new_data[i] <- "X"
        new_data1[i] <-  "X"
      }
      
    }
    
    new_data3 <- rbind(new_data,new_data1)
    
    new_data3 <- new_data3[vapply(new_data3, function(x) length(unique(x)) > 1, logical(1L))]
    
    d <- names(new_data3)
    
    d <- paste(d,collapse = ",")
    output$result<-renderTable({
      #cat("SOURCE COUNT:", a,"\n") 
      #cat("TARGET COUNT:", b,"\n") 
      #cat("MISMATCH ROWS:", c,"\n") 
      #cat("MISMATCH COLUMNS:", d,"\n") 
      print(a)
       })
    output$result1<-renderTable({
      #cat("SOURCE COUNT:", a,"\n") 
      #cat("TARGET COUNT:", b,"\n") 
      #cat("MISMATCH ROWS:", c,"\n") 
      #cat("MISMATCH COLUMNS:", d,"\n") 
      print(b)
    })
    output$result2<-renderTable({
      #cat("SOURCE COUNT:", a,"\n") 
      #cat("TARGET COUNT:", b,"\n") 
      #cat("MISMATCH ROWS:", c,"\n") 
      #cat("MISMATCH COLUMNS:", d,"\n") 
      print(c)
    })
    output$result3<-renderTable({
      #cat("SOURCE COUNT:", a,"\n") 
      #cat("TARGET COUNT:", b,"\n") 
      #cat("MISMATCH ROWS:", c,"\n") 
      #cat("MISMATCH COLUMNS:", d,"\n") 
      print(d)
    }) 
    output$result4<-renderTable({
      #cat("SOURCE COUNT:", a,"\n") 
      #cat("TARGET COUNT:", b,"\n") 
      #cat("MISMATCH ROWS:", c,"\n") 
      #cat("MISMATCH COLUMNS:", d,"\n") 
      print(new_data3)
    })
    }
    else
    {
      output$result<-renderTable({
        #cat("SOURCE COUNT:", a,"\n") 
        #cat("TARGET COUNT:", b,"\n") 
        #cat("MISMATCH ROWS:", c,"\n") 
        #cat("MISMATCH COLUMNS:", d,"\n") 
        print(a)
      })
      output$result1<-renderTable({
        #cat("SOURCE COUNT:", a,"\n") 
        #cat("TARGET COUNT:", b,"\n") 
        #cat("MISMATCH ROWS:", c,"\n") 
        #cat("MISMATCH COLUMNS:", d,"\n") 
        print(b)
      })
      output$result2<-renderTable({
        #cat("SOURCE COUNT:", a,"\n") 
        #cat("TARGET COUNT:", b,"\n") 
        #cat("MISMATCH ROWS:", c,"\n") 
        #cat("MISMATCH COLUMNS:", d,"\n") 
        print("0")
      })
      output$result3<-renderTable({
        #cat("SOURCE COUNT:", a,"\n") 
        #cat("TARGET COUNT:", b,"\n") 
        #cat("MISMATCH ROWS:", c,"\n") 
        #cat("MISMATCH COLUMNS:", d,"\n") 
        print("NO Mismatch Found!")
      }) 
      output$result4<-renderTable({
        #cat("SOURCE COUNT:", a,"\n") 
        #cat("TARGET COUNT:", b,"\n") 
        #cat("MISMATCH ROWS:", c,"\n") 
        #cat("MISMATCH COLUMNS:", d,"\n") 
        print("NO Mismatch Found!")
      })
    }
  })
  
}

