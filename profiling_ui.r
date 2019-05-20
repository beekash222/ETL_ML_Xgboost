library(shiny)
library(shinydashboard)
library(shinyWidgets)
ui <- fluidPage(

                
  setBackgroundColor(
    color = c("#F7FBFF","#2171B5"),
    gradient = "linear",
    direction = "bottom"
  ),
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

  headerPanel ("AETNA DATA PROFILING"),
  
  
  
  # Input: Checkbox if file has header ----
  column(8,
  sidebarLayout(
    " ",
    sidebarPanel(
      #h3('LOGIN'),
      selectInput("USER NAME","Choose Database:",c(" ","DB2","NETEZZA")),
         textInput("NID","NID","",width = '200px'),
         passwordInput("PASSWORD","PASSWORD","",width = '200px'),
  mainPanel()))),
  column(4,
         verbatimTextOutput("server"),
         tags$script('
                     $(document).ready(function(){
                     var d = new Date();
                     var target = $("#clientTime");
                     target.val(d.toLocaleString());
                     target.trigger("change");
                     });
                     ')),
  column(1,
         checkboxInput("USER_NAME","IODS",FALSE)),
  column(1,
         checkboxInput("USER_NAME","RRODS",FALSE)),
  column(1,
         checkboxInput("USER_NAME","DMT",FALSE)),
  column(1,
         checkboxInput("USER_NAME","FDR",FALSE)),
  column(3,
         
    selectInput("USER NAME","Select Table:",c(" ","Member","Plan","Claim"))),

  
  # Input: Select separator ----
  column(5,
  radioButtons("dist", "SUMMARY:",
               choices=  c("Table_Summary",
                 "Count",
                 "Distinct-Count",
                 "Zero/Blank/Null/NA's Count"),selected = ' ')),
  column(5,
         radioButtons("dist1", " ",
                      choices= c("Max String Length" = "lnorm",
                        "Average String Length" = "norm",
                        "Min String Length" = "unif"),selected = ' ')),

  # Horizontal line ----
  tags$hr(),
  
  # Input: Select number of rows to display ----
 
  # Select variables to display ----
  uiOutput("checkbox"),
  
  
  
  column(8,
         "Result",
         
         sidebarLayout(
           sidebarPanel(
             #h3('SHOW'),
             # the actioButton called rpart which is the name of the variable you need to use in the server component
             actionButton('SHOW', label = 'SHOW',icon("leaf",lib="glyphicon"), 
                          style="color: #fff; background-color: #339933; border-color: #2e6da4"),
             # the actioButton called rpart which is the name of the variable you need to use in the server component
             actionButton('RESET', label = 'RESET',icon("leaf",lib="glyphicon"), 
                          style="color: #fff; background-color: #339933; border-color: #2e6da4")
             
             # the training sample split you allow the user to control on your model
             
           )
           
           
           ,
           mainPanel(
             
             #tableOutput("contents"),
             #tableOutput("contents1")
             tabsetPanel( 
               tabPanel("SHOW",tableOutput("contents")))

           )))
    )

