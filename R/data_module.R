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
              readr::write_csv(augmented(), file)
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

# find terminal nodes
endnote_seeker <- function(RGS) {
  ls_codes <- reformat_data(RGS, bind = FALSE)
  # highest node is anyway an endpoint
  max_nodes <- length(ls_codes)
  upper_nodes <- ls_codes[[max_nodes]]  %>% .[!is.na(.)]
  upper_nodes <- rlang::rep_named(upper_nodes, TRUE)

  # intermediate nodes can also have terminal nodes
  if (max_nodes > 1) {
    upper_nodes <- purrr::map(
      1:(max_nodes - 1),
      ~terminator(ls_codes, index = .x)
      ) %>%
      purrr::flatten_lgl() %>%
      append(upper_nodes)
  }

  # add to original
  dplyr::mutate(
    RGS,
    terminal = dplyr::recode(.data$referentiecode, !!! upper_nodes)
  )
}

terminator <- function(codes, index) {

  # parent
  parent <- unique(codes[[index]]) %>% .[!is.na(.)]
  # child
  child <- unique(codes[[(index + 1)]]) %>% .[!is.na(.)]

  purrr::map_lgl(parent, ~terminator_(.x, y = child)) %>%
    rlang::set_names(nm = parent)
}

terminator_ <- function(x, y) {
  if (is.na(x)) return(NA)
  pattern_x <- stringr::str_c(x, "([:alnum:])+")
  vc_lgl <- stringr::str_detect(y, pattern_x) %>% any
  !vc_lgl
}
