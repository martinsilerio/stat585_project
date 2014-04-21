library(shiny)
library(maps)

source("./helpers.R")
counties <- readRDS("./data/counties.rds")
#percent_map(counties$white, "darkred", "% white")
#head(counties)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  ## Output
  output$category <- renderUI(
    {
      categories <- (filter(national, crime == input$crime))$category %.%
        unique() %.% as.character()
      selectInput("category",
                  label = "Select Category",
                  choices = categories)
    })
  ## text1
  output$text1 <- renderText(
    {
      paste0(
      "You have selected this:\n",
      input$var
      )
    })
  
  ## text2
  output$text2 <- renderText(
    {
      paste0(
        "Your range goes from ",
        input$ran[1],
        " to ",
        input$ran[2])
    })
  
  ## map
  output$map <- renderPlot({
    data <- switch(input$var, 
                   "Percent White" = counties$white,
                   "Percent Black" = counties$black,
                   "Percent Hispanic" = counties$hispanic,
                   "Percent Asian" = counties$asian)
        
    percent_map(var = data, color = "darkred", 
                legend.title = input$var, 
                max = input$ran[2], 
                min = input$ran[1])
  })
})


# render function  creates
# renderImage	images (saved as a link to a source file)
# renderPlot	plots
# renderPrint	any printed output
# renderTable	data frame, matrix, other table like structures
# renderText	character strings
# renderUI	a Shiny tag object or HTML


