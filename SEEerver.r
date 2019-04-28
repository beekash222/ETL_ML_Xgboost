server <- function(input, output,session) {
  
  
  observeEvent(input$rpart, {
    output$contents <- renderTable({
      
      req(input$file1)
      
      inFile <- input$file1
      
      
      df <- read_excel(inFile$datapath, 1)
      
    })
  })
  ###########Spec Column transformation#############
  observeEvent(input$rpart1, {
    output$contents1 <- renderTable({
      
      req(input$file1)
      
      inFile <- input$file1
      
      
      df <- read_excel(inFile$datapath, 3)
      
    })
  })
  
  observeEvent(input$rpart2, {
    output$contents2 <- renderTable({
      
      req(input$file1)
      
      inFile <- input$file1
      
      
      df <- read_excel(inFile$datapath, 2)
      
    })
  })
  
  ########
  observeEvent(input$rpart5, {
    library(readxl)
    library(RJDBC)
    
    req(input$file1)
    
    inFile <- input$file1
    
    
    df1 <- read_excel(inFile$datapath, 2)
    #df1 <- read_xlsx("C://Users/user//Desktop//ML_21//zz.xlsx",2)
    
    df1 <- df1[df1$`TRANSFORMATION RULE` == 'Direct Move',]
    
    
    ###########SOURCE QUERY FRAME###############
    str <- list()
    
    str <- paste(df1$`SOURCE COLUMN`,collapse = ",") 
    
    
    
    drv <- JDBC("oracle.jdbc.driver.OracleDriver","C:/Users/user/Downloads/ojdbc6.jar")
    
    jdbcConnection <- dbConnect(drv, "jdbc:oracle:thin:@//localhost:1521/xe",input$`USER NAME`,input$PASSWORD)
    
    SRC_TAB <- input$SRC
    
    SRC_QUERY <- paste("select",str,"from",SRC_TAB)
    
    
    SRC <- dbGetQuery(jdbcConnection, SRC_QUERY)
    
    
    #########TARGET QUERY FRAME############
    
    str1 <- list()
    
    str1 <- paste(df1$`TARGET COLUMN`,collapse = ",") 
    
    
    library(RJDBC)
    drv <- JDBC("oracle.jdbc.driver.OracleDriver","C:/Users/user/Downloads/ojdbc6.jar")
    
    jdbcConnection <- dbConnect(drv, "jdbc:oracle:thin:@//localhost:1521/xe",input$`USER NAME`,input$PASSWORD)
    
    Trg_TAB <- input$TRG
    
    TRG_QUERY <- paste("select",str1,"from",Trg_TAB)
    
    TRG <- dbGetQuery(jdbcConnection, TRG_QUERY)
    
    
    SRC[is.na(SRC)]<-'SPACE'
    TRG[is.na(TRG)]<-'SPACE'
    
    
    for(i in 1:nrow(SRC))
    {
      for(j in 1:ncol(SRC))
      {
        if(SRC[i,j] != TRG[i,j])
        {
          SRC[i,j] <- paste("SOURCE ->",SRC[i,j],":",TRG[i,j],"<- TARGET")
          
        }
      }
    }
    
    
    
    
    output$contents5 <-renderTable({
      
      SRC
      
    })
    
    
  }
  )
  
  #################################
  
  observeEvent(input$rpart4, {
    
    #######source count###########
    drv <- JDBC("oracle.jdbc.driver.OracleDriver","C:/Users/user/Downloads/ojdbc6.jar")
    
    jdbcConnection <- dbConnect(drv, "jdbc:oracle:thin:@//localhost:1521/xe",input$`USER NAME`,input$PASSWORD)
    
    SRC_TAB <- input$SRC
    
    SRC_CNT <- paste("select count(*) from",SRC_TAB)
    
    SRC_COUNT <- dbGetQuery(jdbcConnection,SRC_CNT )
    
    #SRC_COUNT_NEW <- paste("SOURCE COUNT IS ->",SRC_COUNT)
    #######target count###########
    
    
    drv <- JDBC("oracle.jdbc.driver.OracleDriver","C:/Users/user/Downloads/ojdbc6.jar")
    
    jdbcConnection <- dbConnect(drv, "jdbc:oracle:thin:@//localhost:1521/xe",input$`USER NAME`,input$PASSWORD)
    
    TRG_TAB <- input$TRG
    
    TRG_CNT <- paste("select count(*) from",TRG_TAB)
    
    TRG_COUNT <- dbGetQuery(jdbcConnection,TRG_CNT )
    
    #TRG_COUNT_NEW <- paste("TARGET COUNT IS ->",TRG_COUNT)
    ############mismatch#
    req(input$file1)
    
    inFile <- input$file1
    
    
    df1 <- read_excel(inFile$datapath, 2)
    #df1 <- read_xlsx("C://Users/user//Desktop//ML_21//zz.xlsx",2)
    
    df1 <- df1[df1$`TRANSFORMATION RULE` == 'Direct Move',]
    
    
    ###########SOURCE QUERY FRAME###############
    str <- list()
    
    str <- paste(df1$`SOURCE COLUMN`,collapse = ",") 
    
    
    
    drv <- JDBC("oracle.jdbc.driver.OracleDriver","C:/Users/user/Downloads/ojdbc6.jar")
    
    jdbcConnection <- dbConnect(drv, "jdbc:oracle:thin:@//localhost:1521/xe",input$`USER NAME`,input$PASSWORD)
    
    SRC_TAB <- input$SRC
    
    SRC_QUERY <- paste("select",str,"from",SRC_TAB)
    
    
    SRC <- dbGetQuery(jdbcConnection, SRC_QUERY)
    
    
    #########TARGET QUERY FRAME############
    
    str1 <- list()
    
    str1 <- paste(df1$`TARGET COLUMN`,collapse = ",") 
    
    
    library(RJDBC)
    drv <- JDBC("oracle.jdbc.driver.OracleDriver","C:/Users/user/Downloads/ojdbc6.jar")
    
    jdbcConnection <- dbConnect(drv, "jdbc:oracle:thin:@//localhost:1521/xe",input$`USER NAME`,input$PASSWORD)
    
    Trg_TAB <- input$TRG
    
    TRG_QUERY <- paste("select",str1,"from",Trg_TAB)
    
    TRG <- dbGetQuery(jdbcConnection, TRG_QUERY)
    
    colnames(SRC) <- colnames(TRG) 
    
    #minus <- setdiff(SRC,TRG)
    
    new_data <- setdiff(SRC,TRG)
    new_data1 <- setdiff(TRG,SRC)
    
      
    new_data3 <- rbind(new_data,new_data1)
      
    new_data3 <- new_data3[vapply(new_data3, function(x) length(unique(x)) > 1, logical(1L))]
      
    d <- names(new_data3)
      
    d <- paste(d,collapse = ",")
    
    df_count <- data.frame(matrix(ncol =2,nrow =4))
    
    x <-  c("QUERY","COUNT")
    
    colnames(df_count) <- x
    
    df_count$QUERY[1] <- SRC_CNT
    
    df_count$QUERY[2] <- TRG_CNT
    
    df_count$QUERY[3] <- "Number of Mismatch Record"
    
    df_count$QUERY[4] <- "Mismatch Columns"
    
    df_count$COUNT[1] <- SRC_COUNT
    
    df_count$COUNT[2] <- TRG_COUNT
    
    df_count$COUNT[3] <- nrow(new_data)
    
    df_count$COUNT[4] <- d
    
    output$contents4 <-renderTable({
      
      df_count
      
    })
    
    
    
  })
  #####download############
  
  
}
