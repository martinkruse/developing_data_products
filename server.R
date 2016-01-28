#server.R

library(datasets)
attach(mtcars)
library(ggplot2)

shinyServer(function(input, output) {
  output$print_fit <- renderPrint({
    fit <- lm(input$var, data = mtcars)
    return(print(summary(fit)))
  })
  
  logText <- reactive({
    values[["log"]] <- capture.output(data <- queryMagic())
  })
  
  output$Plot1 <- renderPlot({
    fit <- lm(input$var, data = mtcars)
    mtcars$e <- resid(lm(input$var, data = mtcars))
    mtcars$fitted <- predict(fit)
    g <- ggplot(mtcars, aes(x = fitted, y = e))
    g <- g + geom_hline(yintercept = 0, size = 1)
    g <- g + geom_point(shape=21, size=2, fill = "red")
    g <- g + geom_smooth(se=F, method="loess", colour = "red")
    g <- g + xlab("Fitted values (mpg)")
    g <- g + ylab("Residual values")
    g <- g + ggtitle("Residual Plot")
    g <- g + theme(plot.title = element_text(size=10))
    g <- g + theme(text = element_text(size=8))
    g
  },height = 200, width = 300)
  
  output$Plot2 <- renderPlot({
    ggQQ = function(lm) {
      # extract standardized residuals from the fit
      d <- data.frame(std.resid = rstandard(lm))
      # calculate 1Q/4Q line
      y <- quantile(d$std.resid[!is.na(d$std.resid)], c(0.25, 0.75))
      x <- qnorm(c(0.25, 0.75))
      slope <- diff(y)/diff(x)
      int <- y[1L] - slope * x[1L]
      
      p <- ggplot(data=d, aes(sample=std.resid)) +
        stat_qq(shape=21, size=2, fill = "red") +
        labs(title="Normal Q-Q Plot",       
             x="Theoretical Quantiles",      
             y="Standardized residuals") +   
        geom_abline(slope = slope, intercept = int, linetype="dashed") +
        theme(plot.title = element_text(size=10)) +
        theme(text = element_text(size=8))
      return(p)
    }
    ggQQ(lm(input$var, data = mtcars))
  },height = 200, width = 300)
  
  output$Plot3 <- renderPlot({
    fit <- lm(input$var, data = mtcars)
    mtcars$sresqrt <- sqrt(sqrt(rstandard(lm(input$var, data = mtcars))^2))
    mtcars$fitted <- predict(fit)
    g1 <- ggplot(mtcars, aes(x = fitted, y= sresqrt))
    g1 <- g1 + ylab(expression(sqrt("Standardized residuals")))
    g1 <- g1 + xlab("Fitted values (mpg)")
    g1 <- g1 + geom_point(shape=21, size=2, fill = "red")
    g1 <- g1 + geom_smooth(se=F, method="loess", colour = "red")
    g1 <- g1 + ggtitle("Scale-Location Plot")
    g1 <- g1 + theme(plot.title = element_text(size=10))
    g1 <- g1 + theme(text = element_text(size=8))
    g1
  },height = 200, width = 300)
  
  output$Plot4 <- renderPlot({
    mtcars$sre <- rstandard(lm(input$var, data = mtcars))
    mtcars$hat <- round(hatvalues(lm(input$var, data = mtcars)),3)
    g2 <- ggplot(mtcars, aes(x = hat, y= sre))
    g2 <- g2 + ylab("Standardized residuals")
    g2 <- g2 + xlab("Leverage")
    g2 <- g2 + geom_point(shape=21, size=2, fill = "red")
    g2 <- g2 + geom_smooth(se=F, method="loess", colour = "red")
    g2 <- g2 + ggtitle("Residuals vs Leverage Plot")
    g2 <- g2 + theme(plot.title = element_text(size=10))
    g2 <- g2 + theme(text = element_text(size=8))
    g2
  },height = 200, width = 300)
})