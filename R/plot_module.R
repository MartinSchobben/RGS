#' Hierarchical plot shiny module
#'
#' GUI and server modules for hierarchical plotting of RGS datasets.
#'
#' @param id Namespace id.
#' @param output Plot output.
#' @param download Add download button.
#' @param RGS Reactive value for the reference system.
#' @param child Reactive value for children of parent RGS.
#'
#' @return Shiny GUI or server.
#' @export
plot_ui <- function(id, output = c("plot", "description"), download = TRUE) {
  tagList(
    fluidRow(
      column(
        6,
        tags$br(),
        shiny::fixedRow(
          actionButton(NS(id, "reset"), label = "Reset"),
          actionButton(NS(id, "terug"), label = "Terug"),
          if (isTRUE(download)) uiOutput(NS(id, "download")) else NULL
        ),
        ggiraph::ggiraphOutput(
          NS(id, output[output == "plot"]),
          width = "100%",
          height = "100%"
        )
      ),
      column(
        6,
        tags$br(),
        wellPanel(
          h5("Referentiecode"),
          tableOutput(NS(id, "reference")),
          tags$br(),
          tags$br(),
          tableOutput(NS(id, output[output == "description"]))
        )
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

    # initiate output table and selection
    rows <- reactiveVal(tibble::tibble(NULL))
    selected <- reactiveVal(NULL)

    # reactive plot selection
    observe({selected(input$plot_selected)})

    # plot
    output$plot <-  ggiraph::renderGirafe({
      suppressWarnings(
        ggiraph::girafe(
          code = print(RGS_sunburst(RGS())),
          width_svg = 6,
          height_svg = 6,
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
        )
      })

    # only select description for output table
    output$description <- renderTable({
      if(nrow(rows()) < 1) {
        NULL
      } else {
        dplyr::select(
          rows(),
          Niveau = .data$nivo,
          Omschrijving = .data$omschrijving
          )
      }
    },
    digits = 0
    )

    # download button
    output$download <- renderUI(output_ui("RGS", 1))

    # referentiecode
    output$reference <- renderTable(ref_output(selected()))

    # reset
    observeEvent(input$reset, {session$reload()})

    # update output table
    observeEvent(selected(), {
      # stop adding rows at terminal node but replace them
      obs <- dplyr::filter(RGS(), .data$referentiecode %in% selected())
      if (!selected() %in% find_children(RGS(), selected())) {
        rows(dplyr::bind_rows(rows(), obs))
      } else {
        rows(dplyr::rows_upsert(rows(), obs, by = "nivo"))
      }
    })


    # return to parent if return button clicked
    observeEvent(input$terug, {
      selected(parent_code(parent_seeker_(selected())[[1]]))
      rows(rows()[-nrow(rows()),])
    })

    # return children for reference code
    reactive({child(selected())})

  })
}

# find the children for the selected parent in the plot
find_children <- function(
  RGS = get_standard_business_reporting("Nederland"),
  parent
  ) {

  if (is.null(parent)) return(NULL)
  pattern <- glue::glue("^{parent}([:alnum:])+")

  # select find the children
  children <- dplyr::filter(
    RGS,
    stringr::str_detect(.data$referentiecode, pattern)
    ) %>%
    dplyr::pull(.data$referentiecode)
  # if no more children short cut and return original group of children
  if (length(children) == 0) {
    return(find_children(RGS, parent_code(parent_seeker_(parent)[[1]])))
  } else {
    return(children)
  }
}

ref_output <- function(reference = "BIva", filter_ref = NULL) {
  # short cut
  if (is.null(reference)) return(tibble::tibble(NULL))
  reference <- parent_seeker_(reference)[[1]]
  # filter when going backwards
  if (!is.null(filter_ref)) reference <- reference[1:filter_ref]
  reference <- rlang::set_names(reference, 1:length(reference))
  purrr::map_dfc(reference, ~.x)

}
