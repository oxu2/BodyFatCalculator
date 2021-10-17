library(shiny)
library(ggplot2)
library(scales)

 fluidPage(
  titlePanel(h2("Body Fat Calculator for Men")),
  sidebarPanel(h5("Type in Your Information: "),
               numericInput("abodmen",h4("Abdomen"), value = 90),
               radioButtons("unit_abodmen","unit", choices = c("cm","inch")),

               
               numericInput("weight",h4("Weight"), value = 75),
               radioButtons("unit_weight","unit", choices = c("kg","lb")),
               
               numericInput("thigh",h4("Thigh"), value = 50),
               radioButtons("unit_thigh","unit", choices = c("cm","inch")),
               
               submitButton(),
               htmlOutput(outputId = "bodyfat")

  ),
  
  mainPanel(
    br(),br(),br(),
    h4(textOutput("space")),
    img(src = 'measurement.png', height = 395, width = 516),
    br(),br(),br(),br(),
    h4(textOutput("Criterion")),
    img(src = 'line.png', height = 82, width = 616),
    br(),br(),br(),br(),br(),

    tags$a(href="https://github.com/oxu2/BodyFatCalculator", "GitHub link to this project"),
    br(),br(),
    h4(textOutput("contact0")),
    textOutput("contact1"),
    textOutput("contact2")
  )
  
)

#  shinyApp(ui, server)
