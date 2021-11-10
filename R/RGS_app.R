#' Explore your data app
#'
#'@import shiny
#'@export
RGS_app <- function() {
  ui <- fluidPage(
    theme = bslib::bs_theme(bootswatch = "cerulean"),
    titlePanel("Referentie Grootboekschema"),
    sidebarLayout(
      sidebarPanel(
        data_ui("RGS", is.data.frame),
        filter_ui("filter")
        ),
      mainPanel(
        tabsetPanel(
          id = NS("table", "tabs"),
          tabPanel("Grafiek", plot_ui("plot", download = download_ui("RGS"))),
          tabPanel(
            "Tabel",
            select_ui("select"),
            tags$br(),
            #dataTableOutput("table")
            table_ui("table")
          )
        )
      )
    )
  )
  server <- function(input, output, session) {
    thematic::thematic_shiny()

    # initiate
    RGS <- reactiveVal(NULL)
    child <- reactiveVal(NULL)

    # original data
    RGS <- data_server("RGS", RGS)

    # transforms
    filter <- filter_server("filter", RGS, child)
    var <- select_server("select", filter)

    # plot
    child <- plot_server("plot", filter, child)
    # table
    #output$table <- renderDataTable(display_data(var()))
    table_server("table", var)

  }
  shinyApp(ui, server)
}
