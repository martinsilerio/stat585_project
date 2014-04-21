library("shiny")
library("dplyr")
library("lubridate")

## Load national data
national <- read.csv(gzfile("../data/national.csv.gz")) %.% tbl_df() #Common
all.crimes <- as.character(unique(national$crime))
range0 <- range(ymd(national$date)) %.% as.character()

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  ## Title:
  titlePanel("Crimes in Mexico"),
  
  sidebarLayout(
    ## Sidebar panel
    sidebarPanel(
      
      h1("Census Vis"),
      p("Create demographic maps of ..."),
      selectInput("var",
                  label = "Choose a variable to display",
                  choices = c("Percent White",
                              "Percent Black",
                            "Percent Hispanic",
                            "Percent Asian")),
      ## Select crime
      selectInput("crime",
                  label = "Select crime",
                  choices = all.crimes),
      ## Select category
      uiOutput("category"),
      ## Select date
      dateRangeInput("dates", 
                     label = ("Date range"),
                     start = range0[1],
                     end = range0[2]),
      ## Rest
    sliderInput("ran",
                label = "Range of values",
                min = 1,
                max = 100,
                value = c(30, 50)),
    p("To intall shiny, run in your R terminal:"),
    code("install.packages(\"shiny\")")),
  
  ##Main
  mainPanel(h1("Now we'll do reactive text"),
            #img(src="profile.jpg", height = 400, width = 400),
            p("^_^"),
            p(textOutput("text1")),
            p(textOutput("text2")),
            ## Subsection
            h2("I need a section for this part"),
            p("We have also learned how to",
              span("highlight", style = "color:blue"),
              "text within a paragraph."),
            p("We will display now a map"),
            plotOutput("map"))
  )
))



# Output function  creates
# htmlOutput	raw HTML
# imageOutput	image
# plotOutput	plot
# tableOutput	table
# textOutput	text
# uiOutput	raw HTML
# verbatimTextOutput	text

# function  widget
# actionButton	Action Button
# checkboxGroupInput	A group of check boxes
# checkboxInput	A single check box
# dateInput	A calendar to aid date selection
# dateRangeInput	A pair of calendars for selecting a date range
# fileInput	A file upload control wizard
# helpText	Help text that can be added to an input form
# numericInput	A field to enter numbers
# radioButtons	A set of radio buttons
# selectInput	A box with choices to select from
# sliderInput	A slider bar
# submitButton	A submit button
# textInput	A field to enter text


# shiny function  HTML5 equivalent	creates
# p	<p>	A paragraph of text
# h1	<h1>	A first level header
# h2	<h2>	A second level header
# h3	<h3>	A third level header
# h4	<h4>	A fourth level header
# h5	<h5>	A fifth level header
# h6	<h6>	A sixth level header
# a	<a>	A hyper link
# br	<br>	A line break (e.g. a blank line)
# div	<div>	A division of text with a uniform style
# span	<span>	An in-line division of text with a uniform style
# pre	<pre>	Text 'as is' in a fixed width font
# code	<code>	A formatted block of code
# img	<img>	An image
# strong	<srtong>	Bold text
# em	<em>	Italicized text
# HTML	 	Directly passes a character string as HTML code