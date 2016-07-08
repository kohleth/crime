
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)
library(reshape2)
library(plyr)
load("crime.rda")
load("suburbpostcode.RData")


shinyServer(function(input, output) {
  
  
  userdat=reactive({
    temp=data.frame(suburb=gsub("([[:alpha:]]+) [[:digit:]]+","\\1",input$postcode),
                    postcode=gsub(".*([[:digit:]]{4}$)","\\1",input$postcode)
    )
    temp=join(temp,crime)
    temp$suburb=factor(temp$suburb,levels=unique(temp$suburb))
    temp
    }
    )
  
  output$Plot <- renderPlot({

    ggplot(crime, aes(x=Year, y=OffenceCount, group=postcode)) +
      geom_line(color="gray")+theme_bw()+ theme(axis.text.x = element_text(angle = 45, hjust = 1))+
      coord_fixed(ratio = input$ratio)+
      geom_line(data=userdat(),aes(colour=suburb),lwd=1.2)+
      guides(guide_legend())
  }
  )
  
  output$tableui=renderUI({
    if(nrow(userdat())<1){
      return("")
    }
    tableOutput("table")
  })
  
  output$table=renderTable({
    dcast(userdat(),suburb+postcode~Year,value.var="OffenceCount")
  },digits=0,format.args = list(big.mark = ","),include.rownames=FALSE,
  caption="Data",caption.placement = getOption("xtable.caption.placement", "top")

  )
  
})
