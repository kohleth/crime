
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
load("suburbpostcode.RData")

shinyUI(fluidPage(
  
  # Application title
  titlePanel("2011-2016 Offences count by Postcode"),
  
  # Sidebar with a slider input for number of bins
  verticalLayout(
    plotOutput("Plot"),
    wellPanel(
      selectizeInput(
        "postcode","Select your Suburb/Postcode",
        choices = c(`Enter Suburb/Postcode` ='',suburbpostcode),
        selected = "MELBOURNE 3000",
        multiple= TRUE,
        options = list(maxOptions=4, maxItems = 5,placeholder="select a postcode."),
        width="50%"
      ),
    sliderInput("ratio","Aspect Ratio:",0.00001,0.001,0.0001,step=0.00001,width="50%")

    ),
    wellPanel(
      uiOutput("tableui")
    )
  )
))
