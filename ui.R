# Load shiny library
library(shiny)

# All UI elements must be inside shinyUI()
shinyUI(
    
    # Set up a page with a left-hand sidebar menu. 
    pageWithSidebar(
        # The header/title of the page.
        headerPanel("Dynamic Plotting"),
        
        # User inputs go in a sidebar on the left.
        sidebarPanel(
        
            # User types name of data.frame into a text box.
            textInput(
                inputId = "dataName",
                label   = "Enter data.frame name"
            ),
            
            # This is returned once a valid data.frame name is entered
            # above. It allows the user to pick an x-variable and y-variable
            # from the column names of the selected data.frame.
            uiOutput(outputId = "varSelector")
        ),
        
        # The output goes in mainPanel().
        mainPanel(
            # Show the plot itself.
            plotOutput(
                outputId = "scatterPlot"),
            # Button to allow the user to save the image.
            downloadButton(
                outputId = "downloadPlot", 
                label    = "Download Plot")
        )
        
    )
)
