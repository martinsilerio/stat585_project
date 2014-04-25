library("shiny")
library("ggplot2")
library("dplyr")
library("lubridate")
library("xtable")

## Load national data
national <- read.csv(gzfile("../data/national.csv.gz")) %.% 
  tbl_df() %.% 
  mutate(date = ymd(date))
states <- read.csv(gzfile("../data/states.csv.gz")) %.% 
  tbl_df() %.%
  mutate(date = ymd(date))
mex <- read.csv("../mexico/polygons.csv")[, -1]


all.crimes <- as.character(unique(national$crime))
range0 <- range(national$date) %.% as.character()


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  ## Output crime
  output$crime <- renderUI(
{
  temp <- input$law
  if(temp == "Common") temp <- "common"
  crimes <- (filter(national, law == temp))$crime %.%
    unique() %.% as.character()
  selectInput("crime",
              label = "Select crime",
              choices = crimes)
})
## Output category
output$category <- renderUI(
{
  categories <- (filter(national, crime == input$crime))$category %.%
    unique() %.% as.character()
  selectInput("category",
              label = "Select Category",
              choices = categories)
})
## table1
output$table1 <- renderTable({
  data <- filter(national, 
                 crime == input$crime,
                 category == input$category,
                 (date) >= ymd(input$dates[1]),
                 (date) <= ymd(input$dates[2]))
  xtable(data[1:30, -c(1, 6, 8, 9)])
})
## plot1
output$plot1 <- renderPlot({
  data <- filter(national, 
                 crime == input$crime,
                 category == input$category,
                 (date) >= ymd(input$dates[1]),
                 (date) <= ymd(input$dates[2]))
  range.dates <- range(data$date)
  p1 <- qplot(date, total.rate, data = data, 
              geom = "line", col = period,
              linetype = party) +
    ggtitle(paste0("Crime rates from", 
                   paste(range.dates, collapse = " to ")))
  print(p1)
})
## Data for states
dataInput <- reactive({
  filter(states, 
         crime == input$crime,
         category == input$category,
         (date) >= ymd(input$dates[1]),
         (date) <= ymd(input$dates[2]))
})

## map1
output$map1 <- renderPlot({
  
  data.states <- dataInput()
  range.date <- range(data.states$date)

    ## Associating value with response
    value1 <- (filter(data.states,
                      date == range.date[1]) %.%
                 arrange(state_code))$total.rate
    df1 <- mutate(mex, value = value1[region])
    
    value2 <- (filter(data.states,
                      date == range.date[2]) %.%
                 arrange(state_code))$total.rate
    df2 <- mutate(mex, value = value2[region])
  
  data2 <- rbind(cbind(df1, date = as.character(range.date[1])),
                 cbind(df2, date = as.character(range.date[2])))
 
  p2 <- ggplot(data = data2, aes(x, y)) +
    geom_polygon(col = "darkred", 
                 aes(order = order, group = group, fill = value)) +
    facet_wrap(~ date) +
    scale_fill_gradient(low='white', high='darkred') +
    ggtitle("Comparison for states")
  
  print(p2)  
})## End map 1

output$differences <- renderPlot({
  
  data.states <- dataInput()
  range.date <- range(data.states$date)
  
  ## Associating value with response
  value.before <- (filter(data.states,
                    date == range.date[1]) %.%
               arrange(state_code))$total.rate
  value.after <- (filter(data.states,
                    date == range.date[2]) %.%
               arrange(state_code))$total.rate
  
  ## Create new data frame with only 32 states and differences
  df <- mex %.% group_by(region, state.name) %.%
    summarise(n = n()) %.%
    select(region, state.name) %.%
    mutate(increment = value.after[region] - 
                 value.before[region],
           differences = 0,
           ymax = max(increment, 0),
           ymin = min(increment, 0)) %.%
    arrange(state.name)
    
  p3 <- ggplot(data = df, aes(state.name, differences)) +  
    geom_point() + 
    geom_pointrange(aes(ymin = ymin, ymax = ymax)) +
    coord_flip() +
    ggtitle(paste("Increment in rate from ", 
                  as.character(range.date), 
                  collapse = " to "))
  
  print(p3)  
})## End differences

})



# render function  creates
# renderImage	images (saved as a link to a source file)
# renderPlot	plots
# renderPrint	any printed output
# renderTable	data frame, matrix, other table like structures
# renderText	character strings
# renderUI	a Shiny tag object or HTML


