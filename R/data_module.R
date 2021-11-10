#' Dataset selection
#'
#' @export
data_ui <- function(id, filter = NULL) {

  names <- ("Nederland")
  selectInput(
    NS(id, "dataset"),
    h5("Selecteer schema"),
    choices = names
    )
}
#' @rdname data_ui
#'
#' @export
download_ui <- function(id) {
  downloadButton(NS(id, "download"), "Download")
}
#' @rdname data_ui
#'
#' @export
data_server <- function(id, RGS) {

  stopifnot(is.reactive(RGS))

  moduleServer(id, function(input, output, session) {

    RGS <- reactive(get_standard_business_reporting(input$dataset))

    output$download <- downloadHandler(
      filename = function() {
        name <- dplyr::filter(code_refs, .data$country == input$dataset) %>%
          dplyr::pull(.data$url_ref) %>%
          fs::path_file() %>%
          fs::path_ext_remove()
        paste0(name, ".csv")
      },
      content = function(file) {
        readr::write_csv(RGS(), file)
      }
    )

    RGS
  })

}
