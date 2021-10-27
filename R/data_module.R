#' Dataset selection
#'
#' @export
data_ui <- function(id, filter = NULL) {

  names <- code_refs$country
  selectInput(NS(id, "dataset"), h2("Pick a dataset"), choices = names)
}
#' @rdname data_ui
#'
#' @export
data_server <- function(id) {

  moduleServer(id, function(input, output, session) {
    reactive(get_standard_business_reporting(input$dataset))
  })
  }
