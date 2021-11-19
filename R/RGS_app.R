#' Explore RGS data app
#'
#' Shiny app for exploring of RGS
#' (\href{https://www.referentiegrootboekschema.nl/}{Referentie GrootboekSchema})
#' datasets.
#'
#' @return Shiny app.
#' @export
RGS_app <- function() {
  ui <- fluidPage(
    theme = bslib::bs_theme(bootswatch = "cerulean"),
    titlePanel("Referentie Grootboekschema"),
    sidebarLayout(
      sidebarPanel(
        input_ui("RGS", is.data.frame),
        selectInput(
          NS("plot", "modus"),
          h5("Zoek opties"),
          choices = c("Referentiecodes" = "code", "Voorbeelden" = "example")
        ),
        filter_ui("filter")
        ),
      mainPanel(
        tabsetPanel(
          id = "tabs",
          tabPanel(
            "Grafiek",
            plot_ui(
              "plot",
              download = output_ui("RGS", 1)
            ),
            value = "code"
          ),
          tabPanel(
            "Tabel",
            table_ui(
              "table",
              select = select_ui("select"),
              download = output_ui("RGS", 2)
            )
          )
        )
      )
    )
  )
  server <- function(input, output, session) {
    thematic::thematic_shiny()

    # initiate
    child <- reactiveVal(NULL)
    #observe(message(glue::glue("{child()}")))

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
    output_server("RGS", var, 3)

  }
  shinyApp(ui, server)
}
