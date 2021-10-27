#' Variable selection
#'
#'
#' @export
select_ui <- function(id) {
  selectInput(NS(id, "var"), h2("Select variable"), choices = NULL, multiple = T)
}
#' @rdname select_ui
#'
#' @export
select_server <- function(id, RGS, default = c("referentiecode", "omschrijving", "referentienummer")) {

  stopifnot(is.reactive(RGS))

  moduleServer(id, function(input, output, session) {

    # default selection
    def_vars <- reactive(default[default %in% names(RGS())])

    observeEvent(RGS(), {
      updateSelectInput(session, "var", choices =  def_vars(), selected =  def_vars())
    })

    # custom selection
    reactive(dplyr::select(RGS(), input$var))

  })
}

