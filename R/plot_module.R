#' Hierachical plot shiny module
#'
#' @param id Namespace id
#' @param output Plot output
#'
#' @return Shiny GUI or server
#' @export
plot_ui <- function(id, output = c("plot", "datatab")) {
  tagList(
    fluidRow(
      column(
        width = 7,
        h4("Select states: "),
        actionButton(NS(id, "reset"), label = "Reset selection"),
        ggiraph::ggiraphOutput(NS(id, output[output == "plot"]))
        ),
      column(
        width = 5,
        h4("Selected states"),
        tableOutput(NS(id, output[output == "datatab"]))
        )
      )
  )
}
#' @rdname plot_ui
#'
#' @export
plot_server <- function(id, RGS, child) {

  # check for reactive
  stopifnot(is.reactive(RGS))
  stopifnot(is.reactive(child))

  moduleServer(id, function(input, output, session) {

    selected <- reactive({
      input$plot_selected
    })

    # initiate output table
    rows <- reactiveVal(tibble::tibble(NULL))

    # find parent belonging to reference code
    parent <- reactive(parent_seeker(RGS()))

    # plot
    output$plot <-  ggiraph::renderGirafe({
      x <- ggiraph::girafe(
        code = print(RGS_sunburst(parent())),
        width_svg = 6,
        height_svg = 5,
        options = list(
          ggiraph::opts_hover(
            css = "fill:#FF3333;stroke:black;cursor:pointer;",
            reactive = TRUE
            ),
          ggiraph::opts_selection(
            type = "single",
            css = "fill:#FF3333;stroke:black;"
            )
          )
      )
      x
      })

    # reset
    observeEvent(input$reset, {
      session$sendCustomMessage(type = NS(id, 'plot_set'), message = character(0))
      output$datatab <- renderTable(NULL)
    })

    # update output table
    observeEvent(selected(), {
      rows(dplyr::bind_rows(rows(), dplyr::filter(RGS(), .data$referentiecode %in% selected())))
    })

    # only select description for output table
    output$datatab <- renderTable({
      if(nrow(rows()) < 1) {
        NULL
      } else {
        dplyr::select(rows(), .data$omschrijving)
      }
    })

    # find children for reference code
    observe({
      if (nrow(rows()) > 0) {
        x <- dplyr::pull(rows(), .data$referentiecode)[nrow(rows())]
        x <- parent() %>% find_children(x)
        child(x)
      }
    })

    # return children for reference code
    reactive(child())

  })
}

# find the children for the selected parent in the plot
find_children <- function(RGS = get_standard_business_reporting("nl"), parent) {

  pattern <- glue::glue("^{parent}([:alnum:])*")
  dplyr::filter(RGS, stringr::str_detect(.data$parent, pattern)) %>%
    dplyr::pull(.data$child)
}
