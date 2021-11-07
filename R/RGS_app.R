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
        # select_ui("select"),
        filter_ui("filter")
        ),
      mainPanel(
        plot_ui("plot")
        )
      )
    )
  server <- function(input, output, session) {
    thematic::thematic_shiny()
    RGS <- data_server("RGS")
    child <- reactiveVal(get_standard_business_reporting("nl")$referentiecode)
    filter <- filter_server("filter", RGS, child)
    # var <- select_server("select", filter)
    child <- plot_server("plot", filter, child)
    # observeEvent(child(), message(glue::glue("{child()}")))

  }
  shinyApp(ui, server)
}



