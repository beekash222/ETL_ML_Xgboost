library(shiny)
library(shinydashboard)
library(readxl)
library(RJDBC)
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
  
  headerPanel ("IODS AUTOMATION-SOURCE TARGET VALIDATION"),
    
  column(12,"Uploading Data Mapping sheet",
  fileInput('file1', 'Choose xlsx file',
            accept = c(".xlsx"))),
  
 column(12,
           sidebarLayout(
             sidebarPanel(
                        div(
                 id = "SOURCE SCENARIO COVERAGE",
                 #selectInput("OS_TYPE","HIVE/DB2",c("","HIVE","DB2","NETEZZA"),width = '350px'),
                 #textInput("DATABASE","DATABASE","",width = '350px'),
                 textInput("USER NAME","USERID","",width = '350px'),
                 passwordInput("PASSWORD","PASSWORD","",width = '350px'),
                 textInput("SRC","SOURCE TABLE","",width = '350px'),
                 textInput("TRG","TARGET TABLE","",width = '350px'),
                 textInput("IPI","INSERT PROC ID","",width = '350px'),
                 h2('E2E VALIDATION'),
               actionButton('rpart', label = 'TABLE DETAILS',icon("leaf",lib="glyphicon"), 
                            style="color: #fff; background-color: #339933; border-color: #2e6da4"),
               actionButton('rpart1', label = 'TABLE RULE',icon("leaf",lib="glyphicon"), 
                            style="color: #fff; background-color: #339933; border-color: #2e6da4"),
               actionButton('rpart2', label = 'COLUMN RULE',icon("leaf",lib="glyphicon"), 
                            style="color: #fff; background-color: #339933; border-color: #2e6da4"),
               actionButton('rpart3', label = 'DDL COMPARISON',icon("tree-conifer",lib="glyphicon"), 
                            style="color: #fff; background-color: #339933; border-color: #2e6da4"),
               actionButton('rpart4', label = 'COUNT VALIDATION',icon("tree-conifer",lib="glyphicon"), 
                            style="color: #fff; background-color: #339933; border-color: #2e6da4"),
               actionButton('rpart5', label = 'SOURCE TARGET COMPARISON',icon("tree-conifer",lib="glyphicon"), 
                            style="color: #fff; background-color: #339933; border-color: #2e6da4")
                    
               
             )),

mainPanel(
   h1("RESULTS"),
  tabsetPanel( tabPanel("TABLE DETAILS",tableOutput("contents")),
               tabPanel("TABLE RULE",tableOutput("contents1")), 
               tabPanel("COLUMN RULE",tableOutput("contents2")),
               downloadButton("download","Download"),
               tabPanel("DDL COMPARISON",tableOutput("contents3")),
               tabPanel("COUNT VALIDATION",tableOutput("contents4")),
               tabPanel("SOURCE TARGET COMPARISON",tableOutput("contents5")))
              
)))
)

