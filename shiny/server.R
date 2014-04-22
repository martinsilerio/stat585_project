library("shiny")
library("ggplot2")
library("dplyr")
library("lubridate")
library("xtable")

## Load national data
national <- read.csv(gzfile("../data/national.csv.gz")) %.% tbl_df() #Common
states <- read.csv(gzfile("../data/states.csv.gz")) %.% tbl_df() #Common

all.crimes <- as.character(unique(national$crime))
range0 <- range(ymd(national$date)) %.% as.character()


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  ## Output category
  output$category <- renderUI(
{
  categories <- (filter(national, crime == input$crime))$category %.%
    unique() %.% as.character()
  selectInput("category",
              label = "Select Category",
              choices = categories)
})
## text2
output$text2 <- renderText(
{
  paste0(
    "Your range goes from ",
    input$dates[1],
    " to ",
    input$dates[2])
})
## table1
output$table1 <- renderTable({
  data <- filter(national, 
                 crime == input$crime,
                 category == input$category,
                 ymd(date) >= ymd(input$dates[1]),
                 ymd(date) <= ymd(input$dates[2]))
  xtable(data[1:30, ])
})
## plot1
output$plot1 <- renderPlot({
  data <- filter(national, 
                 crime == input$crime,
                 category == input$category,
                 ymd(date) >= ymd(input$dates[1]),
                 ymd(date) <= ymd(input$dates[2]))
  p1 <- qplot(ymd(date), total.rate, data = data, geom = "line")
  print(p1)
})
})



# render function  creates
# renderImage	images (saved as a link to a source file)
# renderPlot	plots
# renderPrint	any printed output
# renderTable	data frame, matrix, other table like structures
# renderText	character strings
# renderUI	a Shiny tag object or HTML


