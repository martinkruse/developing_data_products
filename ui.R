# ui.R

shinyUI(fluidPage(
  titlePanel("Exploration of the mtcars data set"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("The mtcars data set provides information on gas mileage for a variety
               of different cars. As part of the provided information, the data set contains information whether a car 
               has automatic or manual transmission. Therefore, it allows for an estimation
                whether automatic or manual transmission provides better gas efficieny 
                for  car. Here, a simple prediction model
               can be build that allows a user to explore which influence the
               weight (variable 'wt') and/or the quarter mile time (variable 'qsec') 
              have on miles per gallon (variable 'mpg') in relation 
                to the type of transmission (variable 'am'). The user can analyze
               several different prediction models and the result is shown as a table and 
               through analytical plots. The table, which prints the 
               output of the 'summary' function for the chosen model, can be accessed via
               the 'Summary' tab visible on the right side. The analytical plots can be accessed via
               the 'Plots' tab."),
      
      selectInput("var", 
                  label = "Choose a model",
                  choices = list("mpg ~ am", "mpg ~ am + wt",
                                 "mpg ~ am + qsec", "mpg ~ am + wt + qsec"),
                  selected = "mpg ~ am")
      ),
    
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Summary", verbatimTextOutput('print_fit')),
                  tabPanel("Plots",
                          fluidRow(
                                    splitLayout(style = "height:250px;", cellWidths = c("50%", "50%"), plotOutput('Plot1'), plotOutput('Plot2'))
                                  ),
                          fluidRow(
                                    splitLayout(style = "height:250px;", cellWidths = c("50%", "50%"), plotOutput('Plot3'), plotOutput('Plot4'))
                                  )
                          )
                  )
))
))