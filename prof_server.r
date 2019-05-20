server <- function(input, output,session) {
  
  
  output$server <- renderText({ c("Time:", as.character(Sys.time()), as.character(Sys.timezone())) })
  session$userData$time <- reactive({format(lubridate::mdy_hms(as.character(input$clientTime)), "%d/%m/%Y; %H:%M:%S")})
  output$local <- renderText({session$userData$time() })
  
  
 
  
  #######
  observeEvent(input$SHOW, {
    
    drv <- JDBC("oracle.jdbc.driver.OracleDriver","C:/Users/user/Downloads/ojdbc6.jar")
    
    jdbcConnection <- dbConnect(drv, "jdbc:oracle:thin:@//localhost:1521/xe",input$NID,input$PASSWORD)
    
    SRC_TAB <- input$SRC
    
    SRC_QUERY <- paste("select * from MEMBER_NEW")
    
    
    df <- dbGetQuery(jdbcConnection, SRC_QUERY)
    
    
    
    df1 <- data.frame()
    
    df_count1 <- data.frame(matrix(ncol =2,nrow =2))
    
    x <-  c("Description","COUNT")
    
    count_row <- nrow(df)
    count_col <- ncol(df)
    
    colnames(df_count1) <- x
    
    df_count1$Description[1] <- "Total No Of Records :"
    
    df_count1$Description[2] <- "Total No Of Columns :"
    
    df_count1$COUNT[1] <- count_row
    
    df_count1$COUNT[2] <- count_col

    df_count3 <- data.frame()
    
    df_count3 <- list()
    for(i in 1:ncol(df))
    {
      df_count3$Column_Name[i] <- colnames(df[i])
      df_count3$COUNT[i] <- nrow(df[i])
      
    }
    #df_count3 <- unlist(df_count3)
    
    df_count4 <- list()
    
    for(i in 1:ncol(df))
    {
      df_count4$Column_Name[i] <- colnames(df[i])
      df_count4$COUNT[i] <- nrow(unique(df[i]))
      
    }
    #df_count4 <- unlist(df_count4)                 
 
    output$contents <-renderTable({
      
      if(input$dist == "Table_Summary")
      {
        df_count1
      }
      else if (input$dist == "Count")
      {
        df_count3
      }
      else if (input$dist == "Distinct-Count")
      {
        df_count4
      }
      
    })
    
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, head of that data file by default,
    # or all rows if selected, will be shown.
    })
  }
  

