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
    
    freqtable <- read.csv(input$File$datapath,
                          header = TRUE,
                          sep = input$sep)
    return(freqtable)
  })
  
  #Display the snell scores
  output$snellscores <- renderTable({
    
    req(input$File)
    
    df <- read.csv(input$File$datapath,
                   sep = input$sep)
    
    scores <- snell(df)
    
    scores <- data.frame("Category" = names(scores),
                         "Score" = scores)
    
    return(scores)
    
  })
  
}


shinyApp(ui = ui,
         server = server)