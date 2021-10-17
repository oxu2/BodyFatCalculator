library(shiny)
library(ggplot2)        

ui <- fluidPage(    

  # Generate a row with a sidebar
  sidebarLayout(      

    # Define the sidebar with one input
    sidebarPanel(
      selectInput("word", "Word", 
                  choices=c('Hits1','Hits2'),
                  selected='Hits1'
      )),

  # Create a spot for the lineplot
  mainPanel(
    plotOutput(outputId="lineplot")  
  )
))


# Define a server for the Shiny app
server <- function(input, output) {

  # Fill in the spot we created for a plot
  output$lineplot <- renderPlot({

    # Render a lineplot
    ggplot(datatest, aes_(x=as.name("Date"), y=as.name(input$word), group=1)) + geom_line()
  })
}
shinyApp(ui, server)