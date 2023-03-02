library(shiny)
library(rsnell)


ui <- fluidPage(
  
  #Title of App
  titlePanel("Rsnell Online"),
  
  #Layout
  sidebarLayout(
    
    #Inputs in the sidebar
    sidebarPanel("Inputs",

                 #File input
                 fileInput(inputId ="File",
                           label = "Choose csv file",
                           accept = c(".csv")
                           ),
                 
                 # Horizontal line
                 tags$hr(),
                 
                 # Input: Select separator
                 radioButtons("sep", "Separator",
                              choices = c(Comma = ",",
                                          Tab = "\t",
                                          Space = " "),
                              selected = ","),
                 
                 # Horizontal line
                 tags$hr(),
                 
                 # Input: Select if rownames are present
                 radioButtons("rownames", "Row Names",
                              choices = c(True = TRUE,
                                          False = FALSE),
                              selected = FALSE),
                 
                 ),
    
    #Outputs in the main panel
    mainPanel(h3("Snell Scores"),
              tableOutput("data"),
              tableOutput("snellscores"))
  )
  
)



server <- function(input, output){
  
  #display the input data back to the user
  output$data <- renderTable({
    
    req(input$File)
    
    if (input$rownames == TRUE){
      rownames = 1
    }
    else{
      rownames = NULL
    }
    
    freqtable <- read.table(input$File$datapath,
                            header = TRUE,
                            sep = input$sep,
                            row.names = rownames)
    return(freqtable)
  })
  
  #Display the snell scores
  output$snellscores <- renderTable({
    
    req(input$File)
    
    if (input$rownames == TRUE){
      rownames = 1
    }
    else{
      rownames = NULL
    }
    
    freqtable <- read.table(input$File$datapath,
                            header = TRUE,
                            sep = input$sep,
                            row.names = rownames)
    
    scores <- snell(freqtable)
    
    scores <- data.frame("Category" = names(scores),
                         "Score" = scores)
    
    return(scores)
    
  })
  
}


shinyApp(ui = ui,
         server = server)