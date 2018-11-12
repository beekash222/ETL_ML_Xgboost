library(shiny)
library(shinydashboard)
library(readxl)
ui <- fluidPage(
    titlePanel("ETL EXTREME AUTOMATION"),
    column(12,"UPLOAD SPEC/MAPPING DOCUMENT",
  fileInput('file1', 'Choose xlsx file',
            accept = c(".xlsx"))),

  
  
    column(12,
           "E2E VALIDATION",
           
           sidebarLayout(
             sidebarPanel(
               h3('E2E VALIDATION'),
               # the actioButton called rpart which is the name of the variable you need to use in the server component
               actionButton('rpart', label = 'TABLE_DETAILS',icon("leaf",lib="glyphicon"), 
                            style="color: #fff; background-color: #339933; border-color: #2e6da4"),
               actionButton('rpart1', label = 'TABLE_RULE',icon("leaf",lib="glyphicon"), 
                            style="color: #fff; background-color: #339933; border-color: #2e6da4"),
               actionButton('rpart2', label = 'COLUMN_RULE',icon("leaf",lib="glyphicon"), 
                            style="color: #fff; background-color: #339933; border-color: #2e6da4"),
               actionButton('rpart3', label = 'RULES',icon("random",lib="glyphicon"), 
                            style="color: #fff; background-color: #339933; border-color: #2e6da4"),
               
               actionButton('rpart4', label = 'SOURCE SCENARIO COVERAGE',icon("tree-conifer",lib="glyphicon"), 
                            style="color: #fff; background-color: #339933; border-color: #2e6da4"),
               actionButton('rpart5', label = 'SAMPLE RECORDS',icon("tree-conifer",lib="glyphicon"), 
                            style="color: #fff; background-color: #339933; border-color: #2e6da4"),
               actionButton('rpart5', label = 'COUNT VALIDATION',icon("tree-conifer",lib="glyphicon"), 
                            style="color: #fff; background-color: #339933; border-color: #2e6da4"),
               actionButton('rpart5', label = 'SOURCE TARGET COMPARISON',icon("tree-conifer",lib="glyphicon"), 
                            style="color: #fff; background-color: #339933; border-color: #2e6da4")
               
               # the training sample split you allow the user to control on your model
               
             )
  

,
mainPanel(
  
  #tableOutput("contents"),
  #tableOutput("contents1")
  tabsetPanel( 
               tabPanel("TABLE DETAILS",tableOutput("contents")),
               tabPanel("TABLE RULE",tableOutput("contents1")), 
               tabPanel("COLUMN RULE",tableOutput("contents2")),
               tabPanel("RULES",tableOutput("contents3")),
               tabPanel("SOURCE SCENARIO COVERAGE",tableOutput("contents4")),
               tabPanel("SAMPLE RECORDS",tableOutput("contents5")),
               tabPanel("COUNT VALIDATION",tableOutput("contents6")),
               tabPanel("COLUMN COMPARISON",tableOutput("contents7")))
              
)))
)

