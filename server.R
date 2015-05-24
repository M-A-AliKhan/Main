# Load necessary libraries.
library(datasets)
library(ggplot2)
library(shiny)

# All server code must be within shinyServer()
shinyServer(
    # Function takes input as a list from ui.R, and returns output as a list
    # of objects computed based on input list.
    function(input, output) {
        
        # Returns the text entered in the data.frame text box, updates
        # every time that text changes.
        getDataName <- reactive({
            input$dataName
        })
        
        # Returns data.frame if the text returned by getDataName() is
        # the name of a valid data.frame, otherwise returns NULL.
        getData <- reactive({
            if (getDataName() == "") out <- NULL
            else out <- tryCatch(
                get(getDataName()), 
                error = function(e) return(NULL))
            return(out)
        })
        
        # Returns the colnames() of the data.frame named in getDataName(),
        # if it's a valid data.frame, otherwise returns NULL.
        getDataVarNames <- reactive({
            dataFrame <- getData()
            if (class(dataFrame) == "data.frame") out <- colnames(dataFrame)
            else out <- NULL
            return(out)
        })
        
        # If dataVarNames() returns a valid list of column names,
        # returns a list of variable selectors: one for the x-variable, one
        # for the y-variable.
        output$varSelector <- renderUI({
            varNames <- getDataVarNames()
        
            # If the values returned from dataVarNames() is NULL, 
            # you don't have a valid data.frame, so only provide 
            # "N/A" as options. for both selectors.
            if (is.null(varNames)) varNames <- "N/A"
            
            out <- list(
                selectInput(
                    inputId = "xVarName",
                    label   = "Select horizontal axis variable",
                    choices = as.list(varNames)
                ),
                
                selectInput(
                    inputId = "yVarName",
                    label   = "Select vertical axis variable",
                    choices = as.list(varNames)
                )
            )
            return(out)
        })
        
        # Return the value selected in input$xVarName.
        xVarName <- reactive({
            input$xVarName
        })
        
        # Return the value selected in input$yVarName.
        yVarName <- reactive({
            input$yVarName
        })
        
        # Update scatter plot every time the data, xVarName, or yVarName
        # changes.
        scatterPlot <- reactive({
            plotData <- getData()
            plotXvar <- xVarName()
            plotYvar <- yVarName()
            
            # If the values of the selected x-variable and y-variable
            # are valid (not "N/A"), return the plot, otherwise NULL.
            if (plotXvar != "N/A" && plotYvar != "N/A") {
                out <- ggplot(
                    data = plotData,
                    aes_string(
                        x = plotXvar,
                        y = plotYvar)) +
                    geom_point() +
                    theme_bw()
                    # geom_point() creates a scatter plot in ggplot2.
                    # Read up on the documentation at 
                    # http://docs.ggplot2.org/current/
                    # to see what else is possible here.
            } else out <- NULL
            return(out)
        })
        
        # Include the printed plot in the output list.
        output$scatterPlot <- renderPlot({
            print(scatterPlot())
        })
        
        # Include a downloadable file of the plot in the output list.
        output$downloadPlot <- downloadHandler(
            filename = "shinyPlot.pdf",
            # The argument content below takes filename as a function
            # and returns what's printed to it.
            content = function(con) {
                pdf(con)
                    print(scatterPlot())
                dev.off(which=dev.cur())
            }
        )
        
    }
)
