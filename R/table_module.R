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
table_ui <- function(id, select, download) {
  tagList(
    fixedRow(select),
    fixedRow(
      selectInput(
        NS(id, "niveau"),
        h6("Niveau"),
        choices = "",
        width = "30%"
      ),
      selectInput(
        NS(id, "ref"),
        h6("Referentiecode"),
        choices = "",
        width = "30%"
      ),
      textInput(
        NS(id, "label"),
        h6("Label"),
        width = "30%"
      )
    ),
    fixedRow(
      download,
      actionButton(NS(id, "add"), "Voeg label toe")
    ),
    tags$br(),
    shinycssloaders::withSpinner(reactable::reactableOutput(NS(id,"table"))),
    tableOutput(NS(id, "table2"))
    )
}
#' @rdname table_ui
#'
#' @export
table_server <- function(id, RGS, labels = "Niveau ") {

  # check for reactive
  stopifnot(is.reactive(RGS))

  moduleServer(id, function(input, output, session) {


    # update
    observe({
      updateSelectInput(session, "ref", choices = unique(nested()[[1]]))
      updateSelectInput(session, "niveau", choices = colnames(nested())[stringr::str_detect(colnames(nested()), labels)])
      #message(glue::glue("{colnames(nested())[stringr::str_detect(colnames(nested()), labels)]}"))
    })

    # reformat to include hierarchy
    nested <- reactive({reformat_data(RGS())})

    # add new label
    newtb <- reactive({
      dplyr::mutate(
        nested(),
        label =
          dplyr::if_else(
            !! input$niveau == !! input$ref,
            input$label,
            NA_character_
            )
      )
    }) %>%
      bindCache(input$niveau, input$ref, input$label) %>%
      bindEvent(input$add, ignoreInit = TRUE)

    output$table2 <-renderTable(newtb())

    # table output with nested data structure
    output$table <- reactable::renderReactable({
      reactable::reactable(
        display_data(nested(), labels),
        details = drill_down(nested(), display_data(nested(), labels), labels)
      )
    })
    # download button
    #output$download <- renderUI(output_ui("RGS", 2))
  })
}

# function to reformat the RGS data to include hierarchical structure
reformat_data <- function(RGS, labels = "Niveau ") {

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
  splits <- purrr::accumulate(as.list(chunks), stringr::str_c)[lvls] %>%
      tibble::as_tibble()

  # nesting
  dplyr::bind_cols(
    splits,
    tidyr::replace_na(RGS, list(referentienummer = 0))
    )
}

# get the data ready for table output
display_data <- function(original, labels) {

  if (is.character(labels)) {
    # minimum level of ref code
    level <- min(dplyr::pull(original, .data$nivo))
    # label columns to be removed
    labs <- find_label_colums(original, labels)
    labs <- labs[!labs %in% paste0(labels, level)]
  } else {
    level <- labels
  }
  # filter NA based on the first column of augmented data
  original <- original [!is.na(original[[level]]),]
  # regex
  pattern <- stringr::str_c("^", unique(original[[level]]), "$", collapse = "|")

  # filter ref codes
  xc <- dplyr::filter(
    original,
    stringr::str_detect(.data$referentiecode, pattern)
    ) %>%
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

# recursive drill down of table for nested tables
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

# find column names referring to hierachy labels
find_label_colums <- function(RGS, labels) {
  colnames(RGS)[stringr::str_detect(colnames(RGS), labels)]
}

# remove column names for table output
remove_column_names <- function(RGS) {
  rlang::rep_named(colnames(RGS)[-1], list(reactable::colDef(name = "")))
}
