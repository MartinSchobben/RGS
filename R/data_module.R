#' Dataset selection and output
#'
#' GUI and server modules for uploading and downloading RGS datasets.
#'
#' @param id Namespace id.
#' @param filter Currently not supported.
#' @param augmented Reactive value for the augmented dataset.
#' @param n Number of download button (if multiple tabs exist).
#'
#' @return Shiny GUI or server.
#' @export
input_ui <- function(id, filter = NULL) {

  names <- c("Nederland")

  selectInput(
    NS(id, "dataset"),
    h5("Selecteer schema"),
    choices = names
    )

}
#' @rdname input_ui
#'
#' @export
output_ui <- function(id, n) {
  downloadButton(NS(id, paste0("download", n)), "Download")
}
#' @rdname input_ui
#'
#' @export
input_server <- function(id) {

  moduleServer(id, function(input, output, session) {

    # input data
    reactive(get_standard_business_reporting(input$dataset))

  })
}
#' @rdname input_ui
#'
#' @export
output_server <- function(id, augmented, n) {

  stopifnot(is.reactive(augmented))

  moduleServer(id, function(input, output, session) {

    observe({
      purrr::walk(
        1:n,
        ~{
          output_name <- paste0("download", .x)
          output[[output_name]] <- downloadHandler(
            filename = function() {
            name <- dplyr::filter(
              code_refs,
              .data$country_code == get_countrycode(input$dataset)
            ) %>%
              dplyr::pull(.data$url_ref) %>%
              fs::path_file() %>%
              fs::path_ext_remove()
            paste0(name, ".csv")
            },
            content = function(file) {
              # remove terminal variable which is only for reference
              RGS <- dplyr::select(augmented(), -.data$terminal)
              readr::write_csv(RGS, file)
            }
          )
        }
      )
    })
  })
}

# get country code
get_countrycode <- function(country) {
  countrycode::countrycode(
    countrycode::countryname(country),
    origin = 'country.name',
    destination = 'iso2c'
    )
}
