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
    # dataTableOutput(NS(id,"table"))
    )

}
#' @rdname plot_ui
#'
#' @export
table_server <- function(id, RGS, labels = "Niveau ") {

  # check for reactive
  stopifnot(is.reactive(RGS))

  moduleServer(id, function(input, output, session) {

    nested <- reactive(reformat_data(RGS()))



    # table
    output$table <- reactable::renderReactable({
      reactable::reactable(
        display_data(nested(), labels),
        details = drill_down(nested(), display_data(nested(), labels), labels)
        # elementId = "reactable"
      )
    })
  })
}

reformat_data <- function(RGS, labels = "Niveau ") {

  # find children
  refs <- dplyr::pull(RGS, .data$referentiecode)

  chunks <- purrr::map_df(
    parent_seeker_(refs),
    ~ parent_code(.x, parent = FALSE, label = labels)
    )

  splits <- purrr::accumulate(as.list(chunks), stringr::str_c) %>%
      tibble::as_tibble()

  # nesting
  dplyr::bind_cols(
    splits,
    tidyr::replace_na(RGS, list(referentienummer = 0))
    )
}

display_data <- function(original, labels) {


  if (is.character(labels)) {
    # minimum level of ref code
    level <- min(dplyr::pull(original, .data$nivo))
    # label columns to be removed
    labs <- find_label_colums(nested, labels)
    labs <- labs[!labs %in% paste0(labels, level)]
  }

  # filter NA based on the first column of augmented data
  original <- original [!is.na(original[[level]]),]
  # regex
  pattern <- stringr::str_c("^", unique(original[[level]]), "$", collapse = "|")

  # filter ref codes
  xc <- dplyr::filter(original, stringr::str_detect(.data$referentiecode, pattern)) %>%
    dplyr::select(
      # none important columns
      -c(.data$referentiecode, .data$nivo)
      ) %>%
    # remove NA columns
    dplyr::select(tidyselect::vars_select_helpers$where(~{!all(is.na(.x))}))

  # less than minimal level columns
  if (is.character(labels)) {
    dplyr::select(xc, -tidyselect::any_of(labs))
  } else {
    return(xc)
  }

}

drill_down <- function(original, display, labels) {
  function(index) {

    # index
    display_index <- display[[1]][index]

    # filter with index upon parent column
    augmented <- original[original[[1]] == display_index,]

    # remove first column of hierarchical structure
    labs <- find_label_colums(augmented, labels)
    if (length(labs) <= 1) return(NULL)
    augmented <- dplyr::select(augmented, -tidyselect::any_of(labs[1]))

    # filter NA based on the first column of augmented data
    augmented <- augmented[!is.na(augmented [[1]]),]

    # final display
    display <- display_data(augmented, 1)

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

find_label_colums <- function(RGS, labels) {
  colnames(RGS)[stringr::str_detect(colnames(RGS), labels)]
}

remove_column_names <- function(RGS) {
  rlang::rep_named(colnames(RGS)[-1], list(reactable::colDef(name = "")))
}