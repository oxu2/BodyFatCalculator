library(shiny)
library(ggplot2)
library(scales)

 fluidPage(
  titlePanel(h1("Body Fat Calculator for Men")),
  sidebarPanel(h2("Type in Your Information: "),
               numericInput("abodmen",h4("Abdomen"), value = 90),
               radioButtons("unit_abodmen","unit", choices = c("cm","inch")),

               
               numericInput("weight",h4("Weight"), value = 75),
               radioButtons("unit_weight","unit", choices = c("kg","lb")),
               
               numericInput("thigh",h4("Thigh"), value = 50),
               radioButtons("unit_thigh","unit", choices = c("cm","inch")),
               
               submitButton()

  ),
  
  mainPanel(
    h4(textOutput("space")),
    img(src = 'measurement.png', height = 365, width = 466),
    

    
    htmlOutput(outputId = "bodyfat"),
    br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),

    h4(textOutput("info")),
    textOutput("contact1"),textOutput("contact2")
  )
  
)

#  shinyApp(ui, server)
