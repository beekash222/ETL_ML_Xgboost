library(shiny)
library(shinydashboard)
ui <- 
  
  fluidPage(

  tags$head(
    tags$style(HTML("
                    @import url('//fonts.googleapis.com/css?family=Lobster|Cabin:400,700');
                    
                    h1 {
                    font-family: 'Lobster';
                    font-weight: 500;
                    line-height: 1.1;
                    color: #48ca3b;
                    }
                    
                    "))
    ),
  
  headerPanel ("AB-INITIO REWRITE-SOURCE TARGET VALIDATION"),
  h4("UPLOADING SOURCE & TARGET FILES"),
  fileInput("file1", "Choose CSV File",
            multiple = FALSE,
            accept = c("text/csv",
                       "text/comma-separated-values,text/plain",
                       ".csv")),
  
  
  fileInput("file2", "Choose CSV File",
            multiple = FALSE,
            accept = c("text/csv",
                       "text/comma-separated-values,text/plain",
                       ".csv")),
  
  
  # Input: Checkbox if file has header ----
  checkboxInput("header", "Header", TRUE),
  
  # Input: Select separator ----
  radioButtons("sep", "Separator",
               choices = c(Comma = ",",
                           Semicolon = ";",
                           Pipe = "|"),
               selected = ","),
  
  
  
  # Horizontal line ----
  tags$hr(),
  
  # Input: Select number of rows to display ----
  radioButtons("disp", "Display",
               choices = c(Head = "head",
                           All = "all"),
               selected = "head"),
  # Select variables to display ----
  uiOutput("checkbox"),
  
  
  
  column(12,
         "Model Selection Panel",
         
         sidebarLayout(
           sidebarPanel(
             h3('COMPARISON'),
             # the actioButton called rpart which is the name of the variable you need to use in the server component
             actionButton('rpart', label = 'RESULT',icon("leaf",lib="glyphicon"), 
                          style="color: #fff; background-color: #339933; border-color: #2e6da4")
             
             # the training sample split you allow the user to control on your model
             
           ),
           
            
           
           mainPanel(
             
             
             #tableOutput("contents"),
             #tableOutput("contents1")
             tabsetPanel( 
               tabPanel("SOURCE FIRST 5 rows OF THE DATAFRAME",tableOutput("contents")), 
               tabPanel("TARGET FIRST 5 ROWS OF THE DATAFRAME",tableOutput("contents1")),
               tabPanel("SOURCE COUNT",tableOutput("result")),
               tabPanel("TARGET COUNT",tableOutput("result1")),
               tabPanel("MISMATCH ROWS",tableOutput("result2")),
               tabPanel("MISMATCH COLUMNS",tableOutput("result3")),
               tabPanel("MISMATCH ROWS",tableOutput("result4")))
           )))
    )

