library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(plotly)

  ui <- fluidPage(
  tags$head(
    setBackgroundColor(color = c("#F7FBFF", "#2171B5"),
                       gradient = "radial",
                       direction = c("top", "left")),
    tags$style(HTML("
                    @import url('//fonts.googleapis.com/css?family=Lobster|Cabin:400,700');
                    
                    h1 {
                    font-family: 'Lobster';
                    font-weight: 500;
                    line-height: 1.1;
                    color: #b53c74;
                    }
                    
                    "))
    ),
  #img(src = 'new10.png',width = 165, align = "center"),
  #img(src = 'twe.png',align = "right",width = 300),
  #img(src = 'new.png',align = "left",width = 350, align = "left"),
  #img(src = 'new6.png',align = "left",width = 350, align = "left"),
  #img(src = 'new8.png',align = "left",width = 200, align = "left"),
  #img(src = 'new9.png',align = "left",width = 165, align = "left"),

  headerPanel ("SOCIAL MEDIA MONITORING"),
  img(src = 'twe.png',width = 165, align = "center"),
  column(12,
         headerPanel('SEARCH ENGINE'),
         sidebarLayout(
           sidebarPanel(
             tags$style(".well {background-color:#3cb5af;}"),
             actionButton("twitter",
                          label = "twitter",
                          icon = icon("twitter"),style="color: #fff; background-color: #00acee; border-color: #2e6da4"),
             actionButton("facebook",
                          label = "facebook",
                          icon = icon("facebook"),style="color: #fff; background-color: #3b5998; border-color: #2e6da4"),
             actionButton("instagram",
                          label = "instagram",
                          icon = icon("instagram"),style="color: #fff; background-color:  #f46f30; border-color: #2e6da4"),
             checkboxGroupInput("social", "Social Media Sites",
                                c("Twitter", "Facebook","Instagram")),
             # the actioButton called rpart which is the name of the variable you need to use in the server component
             textInput("search", "Search Keyword"),
             sliderInput("integer", "Frequency",
                         min = 0, max = 1000,
                         value = 500),
             actionButton('rpart', label = 'SUBMIT',icon("leaf",lib="glyphicon"), 
                          style="color: #fff; background-color: #b53c74; border-color: #2e6da4"),
             actionButton('rpart', label = 'CANCEL',icon("leaf",lib="glyphicon"), 
                          style="color: #fff; background-color: #b53c74; border-color: #2e6da4"),
             
             # the training sample split you allow the user to control on your mode
         
             plotlyOutput("plot"),
            # plotlyOutput("plot1"),
            plotOutput("plot1"),
            plotOutput('Hist'),
             verbatimTextOutput("event"),
            verbatimTextOutput("event1")
             )
           
           
           ,
  
           mainPanel(
             
             #tableOutput("contents"),
             #tableOutput("contents1")
             
             tabsetPanel( 
               
              tabPanel("Posts/Tweets Mentioning Decisions",tableOutput("result")),
              downloadButton('downloadData', 'Download data')
                )
             
           )))
)

  
