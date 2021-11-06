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
        fluidRow(
          column(
            width = 7,
            h4("Select states: "),
            actionButton("reset", label = "Reset selection"),
            ggiraph::ggiraphOutput("plot")
            ),
          column(
            width = 5,
            h4("Hovering states"),
            verbatimTextOutput("console"),
            h4("Selected states"),
            tableOutput("datatab")
            )
          )
        )
      )
    )
  server <- function(input, output, session) {
    thematic::thematic_shiny()
    RGS <- data_server("RGS")
    filter <- filter_server("filter", RGS)
    # var <- select_server("select", filter)

    selected_state <- reactive({
      input$plot_selected
    })
    output$console <- renderPrint({
      input$plot_hovered
    })

    output$plot <-  ggiraph::renderGirafe({
        x <- ggiraph::girafe(
          code = print(RGS_sunburst(filter())),
          width_svg = 6,
          height_svg = 5,
          options = list(
            ggiraph::opts_hover(
              css = "fill:#FF3333;stroke:black;cursor:pointer;",
              reactive = TRUE
              ),
            ggiraph::opts_selection(
              type = "multiple",
              css = "fill:#FF3333;stroke:black;")
              )
            )
        x
      })

    observeEvent(input$reset, {
      session$sendCustomMessage(type = 'plot_set', message = character(0))
    })

    output$datatab <- renderTable({
      out <- dplyr::filter(filter(), .data$referentiecode %in% selected_state()) %>%
        dplyr::select(.data$omschrijving)
      if(nrow(out) < 1) return(NULL)
      row.names(out) <- NULL
      out
    })

  }
  shinyApp(ui, server)
}



