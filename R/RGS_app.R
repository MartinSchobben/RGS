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
          #id = NS("plot", "tabs"),
          tabPanel(
            "Grafiek",
            plot_ui(
              "plot",
              download = output_ui("RGS", 1)
            )
          ),
          tabPanel(
            "Tabel",
            table_ui(
              "table",
              select = select_ui("select"),
              download = output_ui("RGS", 2)
            )
          ),
          tabPanel(
            "Voorbeeld",
            plot_ui(
              "plot",
              select = selectInput(
                "daybook",
                h5("Dagboek"),
                choices = c(Verkoop = "sales")
              ),
              download = output_ui("RGS", 3),
              type = "daybook"
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
    observe(message(glue::glue("{child()}")))

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
