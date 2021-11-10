#' Hierarchical table shiny module
#'
#' @param id Namespace id
#' @param output Table output
#'
#' @return Shiny GUI or server
#' @export
table_ui <- function(id) {

  tagList(
    shinycssloaders::withSpinner(reactable::reactableOutput(NS(id,"table")))
    )

}
#' @rdname plot_ui
#'
#' @export
table_server <- function(id, RGS, labels = "Niveau ") {

  # check for reactive
  stopifnot(is.reactive(RGS))

  moduleServer(id, function(input, output, session) {

    # find children
    split <- reactive({
      refs <- dplyr::pull(RGS(), .data$referentiecode)
      chunks <- purrr::map_df(
        parent_seeker_(refs),
        ~parent_code(.x, parent = FALSE, label = labels)
      )
      purrr::accumulate(as.list(chunks), stringr::str_c) %>%
        tibble::as_tibble()
    })
    # nesting
    nested <- reactive({
      dplyr::bind_cols(
        split(),
        tidyr::replace_na(RGS(), list(referentienummer = 0))
        )
    })

    # table
    output$table <- reactable::renderReactable({
      reactable::reactable(
        display_data(nested()),
        details = drill_down(nested(), display_data(nested()), labels)
        # elementId = "reactable"
      )
    })
  })
}


display_data <- function(original, level = 1) {
  # filter NA based on the first column of augmented data
  original <- original [!is.na(original[[level]]),]
  # regex
  pattern <- stringr::str_c("^", unique(original[[level]]), "$", collapse = "|")
  # filter ref codes
  dplyr::filter(original, stringr::str_detect(.data$referentiecode, pattern)) %>%
    dplyr::select(-.data$referentiecode) %>%
    # remove NA columns
    dplyr::select(tidyselect::vars_select_helpers$where(~{!all(is.na(.x))}))

}

drill_down <- function(original, display, labels) {
  function(index) {

    # index
    display_index <- display[[1]][index]

    # filter with index upon parent column
    augmented <- original[original[[1]] == display_index,]

    # loose first column of hierarchical structure
    labs <- colnames(augmented)[stringr::str_detect(colnames(augmented), labels)]
    if (length(labs) <= 1) return(NULL)
    augmented <- dplyr::select(augmented, -tidyselect::any_of(labs[1]))

    # filter NA based on the first column of augmented data
    augmented  <- augmented  [!is.na(augmented [[1]]),]

    # final display
    display <- display_data(augmented, level = 1)

    if (nrow(display) > 0) {
      # new nested reactable
      reactable::reactable(
        display,
        columns = remove_column_names(display),
        details = drill_down(augmented, display, labels)
      )
    } else {
      NULL
    }

  }
}


remove_column_names <- function(RGS) {
  rlang::rep_named(colnames(RGS)[-1], list(reactable::colDef(name = "")))
}
