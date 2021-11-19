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
plot_ui <- function(id, select = NULL, download) {

  tagList(
    fluidRow(
      column(
        6,
        tags$br(),
        uiOutput(NS(id, "example")),
        shiny::fixedRow(
          actionButton(NS(id, "reset"), label = "Reset"),
          # actionButton(NS(id, "terug"), label = "Terug"),
          download
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
plot_server <- function(id, RGS, child) {

  # check for reactive
  stopifnot(is.reactive(RGS))
  stopifnot(is.reactive(child))

  moduleServer(id, function(input, output, session) {

    # reactive plot
    selected <- reactive({input$plot_selected})

    # If "voorbeeld" then a fixed child is needed.
    observeEvent(input$modus, {
      if (input$modus == "example") {
        child(union(child(), examples$fixed))
        output$example <- renderUI({
          selectInput(
            NS(id, "daybook"),
            h5("Dagboek"),
            choices = c(Verkoop = "sales")
          )
        })
      } else if (input$modus == "code") {
        child(NULL)
      }
    })

    # initiate output table
    rows <- reactiveVal(tibble::tibble(NULL))

    # find parent belonging to reference code
    parent <- reactive(parent_seeker(RGS()))

    # plot
    output$plot <- ggiraph::renderGirafe({
      suppressWarnings(
        ggiraph::girafe(
          code = print(RGS_sunburst(parent())),
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


    # referentiecode
    output$reference <- renderTable({ref_output(selected())})

    # reset
    observeEvent(input$reset, {session$reload()})

    # update output table
    observeEvent(selected(), {
      # stop adding rows at terminal node but replace them
        obs <- dplyr::filter(RGS(), .data$referentiecode %in% selected())
        if (!selected() %in% find_children(parent(), selected())) {
          rows(dplyr::bind_rows(rows(), obs))
        } else {
          rows(dplyr::rows_upsert(rows(), obs, by = "nivo"))
        }
      })

    # find children for reference code based on example and plot
    observeEvent(selected(), {
      if (nrow(rows()) > 0) {
        ref <- dplyr::pull(rows(), .data$referentiecode)[nrow(rows())]
        code <- find_children(parent(), ref)
        child(code)
      }
      # message(glue::glue("{child()}"))
    })

    # return children for reference code
    reactive(child())

  })
}

# find the children for the selected parent in the plot
find_children <- function(
  RGS = parent_seeker(get_standard_business_reporting("Nederland")),
  parent
  ) {

  # select reference parent
  # parent <- dplyr::pull(parent, .data$referentiecode)[nrow(parent)]
  pattern <- glue::glue("^{parent}([:alnum:])*")

  # select find the children
  children <- dplyr::filter(RGS, stringr::str_detect(.data$parent, pattern)) %>%
    dplyr::pull(.data$child)
  # if no more children short cut and return original group of children
  if (length(children) == 0) {
    return(find_children(RGS, parent_code(parent_seeker_(parent)[[1]])))
  } else {
    return(children)
  }
}

ref_output <- function(reference = "BIva") {
  #short cut
  if (is.null(reference)) return(tibble::tibble(NULL))
  reference <- parent_seeker_(reference)[[1]]
  reference <- rlang::set_names(reference, 1:length(reference))
  purrr::map_dfc(reference, ~.x)

}
