server <- function(input, output,session) {
  
 
  observeEvent(input$rpart, {
  output$contents <- renderTable({
    
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, head of that data file by default,
    # or all rows if selected, will be shown.
    
    req(input$file1)
    
    # when reading semicolon separated files,
    # having a comma separator causes `read.csv` to error

        inFile <- input$file1
        
        
        df <- read_excel(inFile$datapath, 1)

  })
  })
  ###########Spec Column transformation#############
  observeEvent(input$rpart1, {
    output$contents1 <- renderTable({
      
      # input$file1 will be NULL initially. After the user selects
      # and uploads a file, head of that data file by default,
      # or all rows if selected, will be shown.
      
      req(input$file1)
      
      # when reading semicolon separated files,
      # having a comma separator causes `read.csv` to error
      
      inFile <- input$file1
      
      
      df <- read_excel(inFile$datapath, 2)
      
    })
  })
  
  observeEvent(input$rpart2, {
    output$contents2 <- renderTable({
      
      # input$file1 will be NULL initially. After the user selects
      # and uploads a file, head of that data file by default,
      # or all rows if selected, will be shown.
      
      req(input$file1)
      
      # when reading semicolon separated files,
      # having a comma separator causes `read.csv` to error
      
      inFile <- input$file1
      
      
      df <- read_excel(inFile$datapath, 3)
      
    })
  })
  
########
  observeEvent(input$rpart3, {
  
    
    library("xlsx")
    library("data.table")
    library(stringr)
    
   #C:\\Users\\user\\Desktop\\Transformation
    
    inFile <- input$file1
  
    tab.read <- read_excel(inFile$datapath, 2)
    
    write.table(tab.read,"C:\\Users\\user\\Desktop\\Transformation\\table_rule.txt",quote = FALSE,row.names = FALSE,col.names = FALSE,sep = "\t")
    
    tab_read <- readLines("C:\\Users\\user\\Desktop\\Transformation\\table_rule.txt")
    
    #################TABLE_RULE#################
    
    ######################join#####################
    if_join <- grep(x = tab_read,pattern = "join",value = TRUE)
    
    if_join <- gsub("\\s+"," ",str_trim(if_join))
    
    for(i in 1 : length(if_join))
    {
      if_join[i] <- gsub('^.*join\\s*|\\s*If.*$', '', if_join[i])
      if_join[i] <- gsub('^.*join\\s*|\\s*Move.*$', '', if_join[i])
      if_join[i] <- gsub('^.*join\\s*|\\s*then.*$', '', if_join[i])
    }
    
    if_join <- grep(x = if_join,pattern = "_", value = TRUE)
    
    for(i in 1: length(if_join))
    {
      if_join[i] <- strsplit(as.character(if_join[i]), split="\\on")
    }
    
    if_join <- unlist(if_join)
    
    for(i in 1: length(if_join))
    {
      if_join[i] <- strsplit(as.character(if_join[i]), split="and")
    }
    
    if_join <- unlist(if_join)
    if_join <- grep(x = if_join,pattern = "_", value = TRUE)
    if_join <- gsub("\\s+"," ",str_trim(if_join))
    if_join <- gsub("with","=",if_join)
    
    ######################IF-THEN#####################
    if_data <- grep(x = tab_read,pattern = "if",value = TRUE)
    
    if_data <- gsub("\\s+"," ",str_trim(if_data))
    
    for(i in 1 : length(if_data))
    {
      if_data[i] <- gsub('^.*if\\s*|\\s*then.*$', '', if_data[i])
    }
    
    if_data <- grep(x = if_data,pattern = "_", value = TRUE)
    
    #########################WHERE-AND##############
    
    if_where <- grep(x = tab_read,pattern = "where",value = TRUE)
    
    if_where <- gsub("\\s+"," ",str_trim(if_where))
    
    for(i in 1 : length(if_where))
    {
      if_where[i] <- gsub('^.*where\\s*|\\s*then.*$', '', if_where[i])
    }
    
    
    for(i in 1: length(if_where))
    {
      if_where[i] <- strsplit(as.character(if_where[i]), split=c("and|AND"))
    }
    
    if_where <- unlist(if_where)
    if_where <- grep(x = if_where,pattern = "_", value = TRUE)
    if_where <- gsub("\\s+"," ",str_trim(if_where))
    
    tab_final <- paste(if_join,if_data,if_where,sep = '@@@')
    
    for(i in 1: length(tab_final))
    {
      tab_final[i] <- strsplit(as.character(tab_final[i]), split="\\@@@")
    }
    
    tab_final <- unlist(tab_final)
    tab_final <- unique(tab_final)
    tab_final <- grep(x = tab_final,pattern = "_", value = TRUE)
    tab_final <- gsub("\\s+"," ",str_trim(tab_final))
    
    #####################################################
    ##########COLUMN RULE###########################
    
    inFile <- input$file1
    
    #tab.read <- read_excel(inFile$datapath, 1)
    col.read <- read_excel(inFile$datapath, 3)
    
    col.read <- col.read$TRANSFORMATION_RULE
    
    write.table(col.read,"C:\\Users\\user\\Desktop\\Transformation\\column_rule.txt",quote = FALSE,row.names = FALSE,col.names = FALSE,sep = "\t")
    
    col_read <- readLines("C:\\Users\\user\\Desktop\\Transformation\\column_rule.txt")
    
    head(col_read)
    ######################join#####################
    if_join_1 <- grep(x = col_read,pattern = "join",value = TRUE)
    
    if_join_1 <- gsub("\\s+"," ",str_trim(if_join_1))
    
    for(i in 1 : length(if_join_1))
    {
      if_join_1[i] <- gsub('^.*join\\s*|\\s*If.*$', '', if_join_1[i])
      if_join_1[i] <- gsub('^.*join\\s*|\\s*Move.*$', '', if_join_1[i])
      if_join_1[i] <- gsub('^.*join\\s*|\\s*then.*$', '', if_join_1[i])
    }
    
    if_join_1 <- grep(x = if_join_1,pattern = "_", value = TRUE)
    
    for(i in 1: length(if_join_1))
    {
      if_join_1[i] <- strsplit(as.character(if_join_1[i]), split="\\on")
    }
    
    if_join_1 <- unlist(if_join_1)
    
    for(i in 1: length(if_join_1))
    {
      if_join_1[i] <- strsplit(as.character(if_join_1[i]),  split=c("and|AND"))
    }
    
    if_join_1 <- unlist(if_join_1)
    if_join_1 <- grep(x = if_join_1,pattern = "_", value = TRUE)
    if_join_1 <- gsub("\\s+"," ",str_trim(if_join_1))
    if_join_1 <- gsub("with","=",if_join_1)
    ######################IF-THEN#####################
    if_data_1 <- grep(x = col_read,pattern = "\\bif\\b|\\bIF\\b|\\biF\\b|\\bIf\\b",value = TRUE)
    
    if_data_1
    if_data_1 <- gsub("\\s+"," ",str_trim(if_data_1))
    
    for(i in 1 : length(if_data_1))
    {
      if_data_1[i] <- gsub('^.*if\\s*|\\s*then.*$', '', if_data_1[i])
    }
    
    if_data_1 <- grep(x = if_data_1,pattern = "_", value = TRUE)
    
    if_data_1
    #########################WHERE-AND##############
    
    if_where_1 <- grep(x = col_read,pattern = "where",value = TRUE)
    
    if_where_1 <- gsub("\\s+"," ",str_trim(if_where_1))
    
    for(i in 1 : length(if_where_1))
    {
      if_where_1[i] <- gsub('^.*where\\s*|\\s*then.*$', '', if_where_1[i])
    }
    
    
    for(i in 1: length(if_where_1))
    {
      if_where_1[i] <- strsplit(as.character(if_where_1[i]),  split=c("and|AND"))
    }
    
    if_where_1 <- unlist(if_where_1)
    if_where_1 <- grep(x = if_where_1,pattern = "_", value = TRUE)
    if_where_1 <- gsub("\\s+"," ",str_trim(if_where_1))
    
    tab_final_1 <- paste(if_join_1,if_data_1,if_where_1,sep = '@@@')
    tab_final_1
    for(i in 1: length(tab_final_1))
    {
      tab_final_1[i] <- strsplit(as.character(tab_final_1[i]), split="\\@@@")
    }
    
    tab_final_1 <- unlist(tab_final_1)
    tab_final_1 <- unique(tab_final_1)
    tab_final_1 <- grep(x = tab_final_1,pattern = "_", value = TRUE)
    tab_final_1 <- gsub("\\s+"," ",str_trim(tab_final_1))
    
    ##########COMBINE TABLE & COLUMN RULE#############
    write.csv(tab_final, file = "C:\\Users\\user\\Desktop\\Transformation\\table_rule.csv",row.names=FALSE)
    write.csv(tab_final_1, file = "C:\\Users\\user\\Desktop\\Transformation\\column_rule.csv",row.names=FALSE)  
    
    df1 <- read.csv("C:\\Users\\user\\Desktop\\Transformation\\table_rule.csv",header = TRUE)
    df2 <- read.csv("C:\\Users\\user\\Desktop\\Transformation\\column_rule.csv",header = TRUE)
    
    df1[2] <- 'TABLE_RULE'
    df2[2] <- 'COLUMN_RULE'
    
    
    df3 <- rbind(df1,df2)
    
    names(df3) <- paste("SCENARIO'S")
    names(df3)[2] <- paste("RULE_TYPE")
    write.csv(df3, file = "My_Rules.csv",row.names=FALSE)  
    
  #test$result <- ifelse(test$COB_SAVINGS_AMT==test$Pred, "match","Unmatch")
  
    output$contents3 <-renderTable({
      
    print(df3[c(2,1)])
        })
  #show in graph match and unmatch
  #barplot(table(test_new$result),col = c("forestgreen", "deepskyblue"))
  
  #show the unmatch rows
  #test_new[test_new$result == "Unmatch",1:8]
  
  })
  
}

