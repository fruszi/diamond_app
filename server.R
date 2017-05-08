# https://github.com/fruszi/Developing_Data_Products/blob/master/Shiny_Part_2/Shiny_Part_2.Rmd
# at horsepower prediction

require(shiny)
library(plotly)
library(dplyr)


shinyServer(function(input, output) {
    d <- diamonds
    # model, prediction, and pred error for model1
    model1 <- lm(price ~ carat, data = d)
    d$pred1 <- predict(model1, newdata=d)
    err1 <- predict(model1, newdata=d, se=T)
    d$ucl1 <- err1$fit + 1.96 * err1$se.fit
    d$lcl1 <- err1$fit - 1.96 * err1$se.fit
    # model, prediction, and pred error for model1
    model2 <- lm(price ~ clarity * carat, data = d)
    d$pred2 <- predict(model2, newdata=d)
    err2 <- predict(model1, newdata=d, se=T)
    d$ucl2 <- err2$fit + 1.96 * err2$se.fit
    d$lcl2 <- err2$fit - 1.96 * err2$se.fit
    
    model1pred <- reactive({
        caratInput <- input$sliderCarat
        predict(model1, newdata = data.frame(carat = caratInput))
    })
    
    model2pred <- reactive({
        caratInput <- input$sliderCarat
        clarityInput <- input$sliderClarity
        predict(model2, newdata = data.frame(carat = caratInput, 
                                             clarity = clarityInput))
    })
    
    
    
    output$plot1 <- renderPlot({
        caratInput <- input$sliderCarat
        
        pl <- ggplot(d, aes(carat, price, color=clarity))
        pl <- pl + geom_point()
        pl <- pl + ggtitle('price by the (linear) function of carat')
        pl <- pl + labs(x='carat',y='price')
        #print(pl)
        if (input$showModel1) {
            pl <- pl + geom_line(aes(carat, pred1), size=1, color='black')
            #print(pl)
            #pl <- pl + geom_line(aes(y=lcl1), color='black', linetype='dashed')
            #pl <- pl + geom_line(aes(y=ucl1), color='black', linetype='dashed')
            
        }
        
        if (input$showModel2) {
            pl <- pl + geom_line(aes(carat, pred2, group=clarity), size=1)
            #print(pl)
        }
        pl <- pl + geom_point(aes(caratInput, model1pred()), col = "black", 
                              size=4)
        pl <- pl + geom_point(aes(caratInput, model2pred()), col = "black", 
                              size=4)
        print(pl)
    })
    
    output$pred1 <- renderText({
        model1pred()
    })
    
    output$pred2 <- renderText({
        model2pred()
    })
})
    