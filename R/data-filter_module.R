#' Observation filtering
#'
#' GUI and server modules for filtering RGS datasets.
#'
#' @param id Namespace id.
#' @param RGS Reactive value for the reference system.
#' @param external Reactive value for children of parent RGS.
#'
#' @return Shiny GUI or server.
#' @export
filter_ui <- function(id) {
  tagList(
    checkboxGroupInput(
      NS(id, "direction"),
      h5("Balanszijde"),
      choices = c(credit = "C", debet = "D"),
      selected = c("C", "D"),
      inline = TRUE
      ),
    sliderInput(
      NS(id, "level"),
      h5("Niveau"),
      min = 2,
      max = 5,
      value = 5
      ),
    uiOutput(NS(id, "controls"))
    )
  }
#' @rdname filter_ui
#'
#' @export
filter_server <- function(id, RGS, external) {

  stopifnot(is.reactive(RGS))
  stopifnot(is.reactive(external))

  moduleServer(id, function(input, output, session) {

    # make check boxes for company type
    lgl_vars <- reactive({
      dplyr::select(
        RGS(),
        tidyselect::vars_select_helpers$where(is.logical)
        ) %>%
        colnames()
      })

    output$controls <- renderUI({
      selectizeInput(
        NS(id, "dynamic"),
        h5("Bedrijfstype"),
        choices = lgl_vars(),
        options = list(
          placeholder = "Selecteer een bedrijfstype",
          onInitialize = I('function() { this.setValue(""); }')
        )
      )
    })

    # find children for selected
    child <- reactive({find_children(RGS(), external())})

    # check whether plot selection extents beyond slider level input
    observeEvent(external(), {
      min_sl <- dplyr::filter(RGS(), .data$referentiecode == external())$nivo
      message(glue::glue("{min_sl}"))
      updateSliderInput(
        session,
        "level",
        # value = min_sl,
        min = min_sl,
        max = 5
      )
    })

    # filter the dataset
    reactive({
      x <- dplyr::filter(
        RGS(),
        .data$d_c %in% input$direction | is.na(.data$d_c),
        .data$nivo <= input$level,
        !!! rlang::syms(input$dynamic)
        )
      if (!is.null(external())) {
        x <- dplyr::filter(x, .data$referentiecode %in% child())
      }
      # find terminal nodes
      endnote_seeker(x)
      })
  })
}
