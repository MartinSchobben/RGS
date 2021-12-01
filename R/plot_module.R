#' Hierarchical plot shiny module
#'
#' GUI and server modules for hierarchical plotting of RGS datasets.
#'
#' @param id Namespace id.
#' @param select Ui element for variable selection.
#' @param download Add download button.
#' @param RGS Reactive value for the reference system.
#'
#' @return Shiny GUI or server.
#' @export
plot_ui <- function(id, select = NULL, download) {

  tagList(
    fluidRow(
      column(
        6,
        tags$br(),
        uiOutput(NS(id, "example")),
        shiny::fixedRow(
          actionButton(NS(id, "reset"), label = "Reset"),
          download,
          actionButton(NS(id, "back"), label = "Terug"),
        ),
        ggiraph::ggiraphOutput(
          NS(id,  "plot"),
          width = "100%",
          height = "100%"
        )
      ),
      column(
        6,
        tags$br(),
        wellPanel(
          h5("Referentiecode"),
          conditionalPanel(
            condition = "output.reference==null",
            "Klik op de grafiek om een code samen te stellen.",
            ns = NS(id)
          ),
          tableOutput(NS(id, "reference")),
          tags$br(),
          tags$br(),
          tableOutput(NS(id, "description"))
        )
      )
    )
  )
}
#' @rdname plot_ui
#'
#' @export
plot_server <- function(id, RGS) {

  # check for reactive
  stopifnot(is.reactive(RGS))

  moduleServer(id, function(input, output, session) {

    # initiate output table and selection
    rows <- reactiveVal(tibble::tibble(NULL))
    selected <- reactiveVal(NULL)

    # plot
    output$plot <- ggiraph::renderGirafe({
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


    # reactive plot selection
    observe(selected(input$plot_selected))

    # only select description for output table
    output$description <- renderTable({
      if(nrow(rows()) == 0) {
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


    # referentiecode
    output$reference <- renderTable({ref_output(selected())})

    # reset
    observeEvent(input$reset, {session$reload()})

    # return to parent if return button clicked
    observeEvent(input$back, {
      # unselect plot
      # session$sendCustomMessage(type = 'plot_set', message = character(0))
      # update selected ref code
      if (nrow(rows()) >= 0 ) {
        selected(find_parents(selected()))
      } else if (rows()$terminal[nrow(rows())]) {
        selected(find_parents(find_parents(selected())))
      }
      # update table
      if (nrow(rows()) <= 1) {
        rows(tibble::tibble(NULL))
      } else {
        rows(rows()[-nrow(rows()),]) # 1 row
      }
      # message(glue::glue("{child()}"))
    })

    # return selection for reference code filtering
    selected

  })
}

# find the children for the selected parent in the plot
find_children <- function(
  RGS = get_standard_business_reporting("Nederland"),
  parent
  ) {

  if (is.null(parent)) return(dplyr::pull(RGS, .data$referentiecode))
  pattern <- glue::glue("^{parent}([:alnum:])+")

  # select find the children
  children <- dplyr::filter(
    RGS,
    stringr::str_detect(.data$referentiecode, pattern)
    ) %>%
    dplyr::pull(.data$referentiecode)
  # if no more children short cut and return original group of parents
  if (length(children) == 0) {
    return(find_children(RGS, find_parents(parent)))
  } else {
    return(children)
  }
}

find_parents <- function(child) {
  if (is.null(child)) {
    NULL
  } else {
    parent <- parent_code(parent_seeker_(child)[[1]])
    if (parent == "") return(NULL) else return(parent)
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
