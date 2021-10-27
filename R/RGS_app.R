#' Explore your data app
#'
#'@import shiny
#'@export
RGS_app <- function() {
  ui <- fluidPage(
    theme = bslib::bs_theme(bootswatch = "cerulean"),
    sidebarLayout(
      sidebarPanel(
        data_ui("RGS", is.data.frame),
        select_ui("select"),
        filter_ui("filter")
        ),
      mainPanel(
        fluidRow(dataTableOutput("table"))
        )
      )
    )
  server <- function(input, output, session) {
    thematic::thematic_shiny()
    RGS <- data_server("RGS")
    filter <- filter_server("filter", RGS)
    var <- select_server("select", filter)

    output$table <- renderDataTable(var())
  }
  shinyApp(ui, server)
}



