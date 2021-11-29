#' Hierarchical table shiny module
#'
#' This module creates the table input and output as an
#' \code{reactable::\link[reactable:reactable]{reactable}()}.
#'
#' @param id Namespace id.
#' @param RGS Reactive value of the RGS data.
#' @param select Add variable selection interface.
#' @param download Add download button.
#' @param labels Labels for hierarchical structure (default = \code{"Niveau "}.
#'
#' @return Shiny GUI or server
#'
#' @export
table_ui <- function(id, select, download = TRUE) {
  tagList(
    select,
    if (isTRUE(download)) uiOutput(NS(id, "download")) else NULL,
    tags$br(),
    shinycssloaders::withSpinner(reactable::reactableOutput(NS(id,"table")))
    )
}
#' @rdname table_ui
#'
#' @export
table_server <- function(id, RGS, labels = "Niveau ") {

  # check for reactive
  stopifnot(is.reactive(RGS))

  moduleServer(id, function(input, output, session) {

    # reformat to include hierarchy
    nested <- reactive(reformat_data(RGS()))

    observe(message(glue::glue("{str(nested())}")))
    observe(message(glue::glue("{str(display_data(nested(), labels))}")))

    # table output with nested data structure
    output$table <- reactable::renderReactable({
      reactable::reactable(
        display_data(nested(), labels),
        details = drill_down(nested(), display_data(nested(), labels), labels)
      )
    })
    # download button
    output$download <- renderUI(output_ui("RGS", 2))
  })
}

# function to reformat the RGS data to include hierarchical structure
reformat_data <- function(RGS, labels = "Niveau ", bind = TRUE) {

  # find children
  refs <- dplyr::pull(RGS, .data$referentiecode)

  # splits
  chunks <- purrr::map_df(
    parent_seeker_(refs),
    ~ parent_code(.x, parent = FALSE, label = labels)
    )

  # levels
  lvls <- unique(RGS$nivo) %>% sort()
  # splice splitted reference code according to hierarchical structure
  splits <- purrr::accumulate(as.list(chunks), stringr::str_c)[lvls]

  # nesting
  if (isTRUE(bind)) {
    dplyr::bind_cols(
      tibble::as_tibble(splits),
      tidyr::replace_na(RGS, list(referentienummer = 0))
    )
  } else {
    splits
  }
}

# get the data ready for table output
display_data <- function(original, labels, drill_down = FALSE) {

  # filter NA based on the first column of augmented data
  original <- original [!is.na(original[[1]]), ]

  # level
  level <- dplyr::pull(original, .data$nivo) %>%
    min(na.rm = TRUE)

  # labels of columns to be removed
  labs <- find_label_colums(original, labels)
  labs <- labs[!labs %in% paste0(labels, level)]

  # filter reference codes
  xc <- dplyr::filter(
    original,
    .data$referentiecode %in% unique(original[[paste0(labels, level)]])
    ) %>%
    dplyr::select(
      # omit unimportant columns for viewing
      -c(.data$referentiecode, .data$nivo, .data$terminal)
      ) %>%
    # remove NA columns
    dplyr::select(tidyselect::vars_select_helpers$where(~{!all(is.na(.x))}))

  # less than minimal level columns
  if (isTRUE(drill_down)) {
    xc
  } else {
    dplyr::select(xc, -tidyselect::any_of(labs))
  }
}

# recursive drill down of table for nested tables
drill_down <- function(original, display, labels, test_modus = FALSE) {
  function(index) {

    # index
    display_index <- display[[1]][index]

    # filter with index upon parent column
    augmented <- original[original[[1]] == display_index & !is.na(original[[1]]), , drop = FALSE]

    # terminal point? then short cut
    if(all(augmented$terminal)) return(NULL)

    # remove first column of hierarchical structure
    labs <- find_label_colums(augmented, labels)
    # if (length(labs) <= 1) return(NULL)
    augmented <- dplyr::select(augmented, -tidyselect::any_of(labs[1]))

    # filter NA based on the first column of augmented data
    augmented <- augmented[!is.na(augmented[[1]]), , drop = FALSE]

    # final display
    display <- display_data(augmented, labels = labels, drill_down = TRUE)

    if (isTRUE(test_modus)) {
    display
    } else {
    # new nested reactable
    reactable::reactable(
      display,
      columns = remove_column_names(display),
      details = drill_down(augmented, display, labels)
    )
    }
  }
}

# find column names referring to hierachy labels
find_label_colums <- function(RGS, labels) {
  colnames(RGS)[stringr::str_detect(colnames(RGS), labels)]
}

# remove column names for table output
remove_column_names <- function(RGS) {
  rlang::rep_named(colnames(RGS)[-1], list(reactable::colDef(name = "")))
}
