library(shiny)
library(scales)
library(ggplot2)

function(input,output) {
  
  output$bodyfat = renderUI({
    if (input$unit_abodmen == "cm") abodmen = input$abodmen else abodmen = input$abodmen*2.54
    
    if (input$unit_weight == "lb") weight = input$weight else weight = input$weight*2.20462262
    
    if (input$unit_thigh == "cm")  thigh = input$thigh else thigh = input$thigh/2.54 
    
    p =  -49.10679 + 0.90497 * abodmen - 0.15878 * weight + 0.21646 * thigh
    
    bodyfat.judge = function(gender,bodyfat){
      if (gender == "male"){
        if (bodyfat <= 5) return(NA) #Extremely below normal range
        if (5 < bodyfat & bodyfat <= 14) return("Essential fat")
        if (14 < bodyfat & bodyfat <= 21) return("Athletes")
        if (21 < bodyfat & bodyfat <= 25) return("Fitness")
        if (25 < bodyfat & bodyfat <= 32) return("Average")
        if (bodyfat > 31 & bodyfat <= 60) return("Obese")
        if (bodyfat > 60) return(NULL)
      }

    }
  

    if (is.null(bodyfat.judge("male", p))) {
      HTML( paste("Your body fat is",round(p,2),"%.", h3("Extremely above the normal range! Please check your input.")) )
    } else {
      if (is.na(bodyfat.judge("male", p))){
        HTML( paste("Your body fat is",round(p,2),"%.",h3("Extremely below the normal range! Please check your input.")) )
      } 
      else HTML(paste( h4("You body fat percentage is: "), h2(round(p,2), "%"), h4("The type of your body fat is:"), h4(bodyfat.judge("male", p)), sep = '<br/>'))
    } 
  })
  
  output$space = renderText({"Note: How to measure your body?"})
  output$Criterion = renderText({ "Criterion"})
  output$contact0 = renderText({ "Contact"})
  output$contact1 = renderText({ "Ouyang Xu"})
  output$contact2 = renderText({ "E-mail: oxu2@wisc.edu"})
  

}

