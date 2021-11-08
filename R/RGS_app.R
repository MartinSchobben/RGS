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
        select_ui("select"),
        filter_ui("filter")
        ),
      mainPanel(
        tabsetPanel(
          tabPanel("Grafiek", plot_ui("plot")),
          tabPanel("Tabel", reactable::reactableOutput("table"))
          )
        )
      )
    )
  server <- function(input, output, session) {
    thematic::thematic_shiny()
    RGS <- data_server("RGS")
    child <- reactiveVal(get_standard_business_reporting("nl")$referentiecode)
    filter <- filter_server("filter", RGS, child)
    var <- select_server("select", filter)

    # plot
    child <- plot_server("plot", filter, child)
    # table
    output$table <- reactable::renderReactable({
      reactable::reactable(var())
    })
    # observeEvent(child(), message(glue::glue("{child()}")))

  }
  shinyApp(ui, server)
}



