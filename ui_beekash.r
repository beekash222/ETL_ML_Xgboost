library(shiny)
library(shinydashboard)

my_username <- "beekash.mohanty"
my_password <- "abc"

###########################/ui.R/##################################

header <- dashboardHeader(title = "KM Knowledge")
sidebar <- dashboardSidebar(uiOutput("sidebarpanel"))
body <- dashboardBody(uiOutput("body") )

ui <- dashboardPage(header, sidebar, body)
