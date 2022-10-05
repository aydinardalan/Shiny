library(shiny)
#' @import graphics
#' @import shiny

ui <- fluidPage(
  
  # App title ----
  titlePanel("Property price condominium"),
  sidebarLayout(
    sidebarPanel(
      
      selectInput("state", "Choose a state:",
                  list("Falun", "Aneby", "Halmstad", "Dorotea", "Lund")
      ),
      
    ),
    mainPanel(
      plotOutput(outputId = "bar")
      
    )
  )
)

server <- function(input, output) {
  devtools::install_github("aydinardalan/Lab5")
  
  reactive_data = reactive({
    municipality_id = as.list(Lab5::Municipality(input$state)$id)
    
    search = Lab5::advancedSearch(kpi_list=list("N07908"),
                                  municipality_list=municipality_id,
                                  year_list = as.list(2010:2021)
    )
    x = as.numeric(sapply(search$values, unlist)[4,])
    
    return(x)
  })
  
  output$bar <- renderPlot({
    
    x=reactive_data()
    
    barplot(x,
            ylab = "SEK per Square Meter",
            xlab = "Year",
            names.arg = as.character(2010:2021)
    )
    
  })
}

#' Visualize Kolada
#' @return Nothing.
#' @export
#'
# visualize_kolada= shinyApp(ui = ui, server = server)
shinyApp(ui = ui, server = server)