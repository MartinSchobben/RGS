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

    # initiate plot selection (parent)
    parent <- reactiveVal(NULL)

    # original data
    RGS <- input_server("RGS")

    # filter, select and find children of parent
    obs <- filter_server("filter", RGS, parent)
    var <- select_server("select", obs)

      # plot
    x <- plot_server("plot", obs)
    observe({parent(x())})

    # table
    table_server("table", var)
    # download
    output_server("RGS", var, 2)

  }
  shinyApp(ui, server)
}
