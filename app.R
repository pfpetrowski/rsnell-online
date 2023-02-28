library(shiny)
library(rsnell)


ui <- fluidPage(
  titlePanel("Rsnell Online"),
  
  sidebarLayout(
    sidebarPanel("Sidebar",
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
    mainPanel("Main",
              textOutput("results"))
  )
  
)

server <- function(input, output){
  
  output$results <- renderText({
    
    req(input$file)
    
    freqtable <- read.csv(input$file,
                          header = TRUE,
                          sep = input$sep)
    
    scores <- snell(freqtable)
    
    return(scores)
    
  })
  
}


shinyApp(ui = ui,
         server = server)