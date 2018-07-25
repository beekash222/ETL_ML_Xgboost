library(shiny)
library(shinydashboard)
ui <- fluidPage(
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
  
  headerPanel ("AETNA TABLE VALIDATION"),
  h4("UPLOADING TRAINING & TEST FILES"),
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
                           Tab = "\t"),
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
               h3('choose the model'),
               # the actioButton called rpart which is the name of the variable you need to use in the server component
               actionButton('rpart', label = 'Decision Tree',icon("leaf",lib="glyphicon"), 
                            style="color: #fff; background-color: #339933; border-color: #2e6da4")
               
               # the training sample split you allow the user to control on your model
               
             )
  

,
mainPanel(
  
  #tableOutput("contents"),
  #tableOutput("contents1")
  tabsetPanel( 
               tabPanel("TRAINING first 5 rows of the dataframe",tableOutput("contents")), 
               tabPanel("TEST 5 rows of the dataframe",tableOutput("contents1")),
               tabPanel("MODEL_RESULT",tableOutput("result")))
              
)))
)
