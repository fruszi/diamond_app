
library(shiny)
shinyUI(fluidPage(
    titlePanel("Predict price from carat and clarity"),
    sidebarLayout(
        sidebarPanel(
            sliderInput("sliderCarat", "What is the carat of the diamond?",
                        0, 5, value=2.5, step=.01),
            selectInput("sliderClarity", "What is the clarity of the diamond?",
                        choices=c('I1','SI2','SI1','VS2','VVS2','VVS1','IF')),
            checkboxInput("showModel1", "Show/Hide Model 1", value = TRUE),
            checkboxInput("showModel2", "Show/Hide Model 2", value = TRUE)
        ),
        mainPanel(
            plotOutput("plot1"),
            h3("Predicted Price from Model 1:"),
            textOutput("pred1"),
            h3("Predicted Price from Model 2:"),
            textOutput("pred2")
        )
    )
))