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
        input_ui("RGS", is.data.frame),
        filter_ui("filter")
        ),
      mainPanel(
        tabsetPanel(
          id = NS("table", "tabs"),
          tabPanel(
            "Grafiek",
            plot_ui("plot")
            ),
          tabPanel(
            "Tabel",
            table_ui("table", select = select_ui("select"))
          )
        )
      )
    )
  )
  server <- function(input, output, session) {
    thematic::thematic_shiny()

    # initiate
    child <- reactiveVal(NULL)

    # original data
    RGS <- input_server("RGS")

    # transforms
    filter <- filter_server("filter", RGS, child)
    var <- select_server("select", filter)

    # plot
    child <- plot_server("plot", filter, child)
    # table
    table_server("table", var)
    # download
    output_server("RGS", var, 2)

  }
  shinyApp(ui, server)
}
