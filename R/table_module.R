#' Hierarchical table shiny module
#'
#' This module creates the table input and output as an
#' \code{reactable::\link[reactable:reactable]{reactable}()}.
#'
#' @param id Namespace id.
#' @param RGS Reactive value of the RGS data.
#' @param select Add variable selection interface.
#' @param download Add download button.
#' @param level Name on controller ui for level selection.
#' @param ref_code Name on controller ui for reference code selection.
#' @param labels Labels for hierarchical structure (default = \code{"Niveau "}.
#'
#' @return Shiny GUI or server
#'
#' @export
table_ui <- function(id, select, download, level = "Niveau",
                     ref_code = "Referentiecode") {
  tagList(
    fixedRow(select),
    fixedRow(
      selectInput(
        NS(id, "level"),
        h6(level),
        choices = "",
        width = "30%"
      ),
      selectInput(
        NS(id, "ref_code"),
        h6(ref_code),
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
    shinycssloaders::withSpinner(reactable::reactableOutput(NS(id, "table"))),
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
    observeEvent(RGS(), {
      values <- unique(nested()[[1]])
      updateSelectInput(session, "ref_code", choices = isolate(values))
      values <- colnames(nested())[stringr::str_detect(colnames(nested()), labels)]
      updateSelectInput(session, "level", choices = isolate(values))
    },
    ignoreInit = TRUE
    )

    # reformat to include hierarchy
    nested <- reactive({reformat_data(RGS())})

    # accumulate input
    labelled  <- reactiveVal(tibble(NULL))

    # no label
    observe({labelled(nested())})

    # add new label
    observeEvent(input$add, {
      req(input$label, input$ref_code)
      # only add column when none existent
      cols <- c(label = NA_character_)
      vc_cols <- cols[!names(cols) %in% names(labelled())]
      new <- tibble::add_column(labelled(), !!!vc_cols) %>%
        # otherwise proceed by adding labels
        dplyr::mutate(
          label =
            dplyr::case_when(
              .data[[input$level]] == input$ref_code ~ input$label,
              .data[[input$level]] != input$ref_code ~ .data$label,
              TRUE ~ NA_character_
            )
        )
      labelled(new)
      })


    #table output with nested data structure
    output$table <- reactable::renderReactable({
      reactable::reactable(
        display_data(labelled(), labels),
        details =
          drill_down(labelled(), display_data(labelled(), labels), labels)
      )
    })
  })
}

# function to reformat the RGS data to include hierarchical structure
reformat_data <- function(RGS, labels = "Niveau ", bind = TRUE) {

  # find children
  if (tibble::is_tibble(RGS)) {
    # reference codes
    refs <- dplyr::pull(RGS, .data$referentiecode)
    # levels
    lvls <- unique(RGS$nivo) %>% sort()
  } else if (is.character(RGS)) {
    refs <- RGS
    max_lvl <- unlist(stringr::str_extract_all(RGS, "[:upper:]")) %>%
      length()
    lvls <- 1:max_lvl
  }

  # splits
  chunks <- purrr::map_df(
    parent_seeker_(refs),
    ~ parent_code(.x, parent = FALSE, label = labels)
    )

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
