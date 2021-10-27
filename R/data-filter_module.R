#' Variable filtering
#'
#' @export
filter_ui <- function(id) {
  tagList(
    checkboxGroupInput(NS(id, "direction"), "Balanszijde", choices = c(credit = "C", debet = "D"), selected = c("C", "D")),
    sliderInput(NS(id, "level"), "Niveau", min = 1, max = 5, value = c(1, 5)),
    uiOutput(NS(id, "controls"))
    )
  }
#' @rdname filter_ui
#'
#' @export
filter_server <- function(id, RGS) {

  stopifnot(is.reactive(RGS))

  moduleServer(id, function(input, output, session) {

    # make check boxes for company type
    lgl_vars <- reactive(
      dplyr::select(
        RGS(),
        tidyselect::vars_select_helpers$where(is.logical)
        ) %>%
        colnames()
      )
    output$controls <- renderUI({
      checkboxGroupInput(NS(id, "dynamic"), "Bedrijfstype", choices = lgl_vars())
    })

    # filter the dataset
    reactive({
      dplyr::filter(
        RGS(),
        d_c %in% input$direction | is.na(d_c),
        dplyr::between(nivo, input$level[1], input$level[2]),
        !!! rlang::syms(input$dynamic)
        )
      })
  })
}
