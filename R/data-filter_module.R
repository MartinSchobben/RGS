#' Observation filtering
#'
#' GUI and server modules for filtering RGS datasets.
#'
#' @param id Namespace id.
#' @param RGS Reactive value for the reference system.
#' @param external Reactive value for children of parent RGS.
#'
#' @return Shiny GUI or server.
#' @export
filter_ui <- function(id, level = "Niveau", direction = "Balanszijde") {

  ls_input <- tagList(
    sliderInput(
      NS(id, "level"),
      h5(level),
      min = 1,
      max = 5,
      value = c(1, 5)
      # step = 1
      ),
    checkboxGroupInput(
      NS(id, "direction"),
      h5(direction),
      choices = c(debit = "C", credit = "D"),
      selected = c("C", "D"),
      inline = TRUE
    )
  )

  # conditional panels
  purrr::map2(ls_input, c("level", "direction"), ~make_panel(.x, .y, id = NS(id)))

}
#' @rdname filter_ui
#'
#' @export
filter_server <- function(id, RGS, external,
                          iexternal = c(code = "referentiecode"),
                          ivars = c(direction = "d_c", level = "nivo")) {

  stopifnot(is.reactive(RGS))
  stopifnot(is.reactive(external))

  moduleServer(id, function(input, output, session) {

    # find children for selected
    child <- reactive({find_children(RGS(), external())})

    # observe(message(glue::glue("{str(rlang::list2(!!!reactiveValuesToList(input), code = child()))}")))

    # update controls to make them conditional to the available variable ranges
    observeEvent(codes(), {
      sub <- RGS()[codes(), , drop = FALSE]
      purrr::iwalk(
        ivars,
        ~update_ui(sub[[.x]], input[[.y]], id = .y, session = session)
      )
    })
    observeEvent(filter(), {
      sub <- RGS()[filter(), , drop = FALSE]
      purrr::iwalk(
        ivars,
        ~update_ui(sub[[.x]], input[[.y]], id = .y, session = session)
      )
    })

    # remove controls from view when choices are absent
    observe({
      sub <- RGS()[codes() & filter(), , drop = FALSE]
      purrr::iwalk(
        ivars,
        ~{
        output[[.y]] <- remove_ui(sub[[.x]], id = .y)
        outputOptions(output, .y, suspendWhenHidden = FALSE)
        }
      )
    })

    # filter based on plot selection
    codes <- reactive({filter_var(RGS()[[iexternal]], child())})

    # filter based on controllers
    filter <- reactive({
      each_var <- purrr::imap(ivars, ~filter_var(RGS()[[.x]], input[[.y]]))
      purrr::reduce(each_var, `&`)
    })

    # return and include end point variable
    eventReactive(purrr::walk(names(ivars), ~input[[.x]]), {
      endnote_seeker(RGS()[codes() & filter(), , drop = FALSE])
    },
    ignoreInit = TRUE
    )
  })
}

update_ui <- function(x, original, id, session) {

  if (id == "level") {
    # level range in data
    value <- range(x, na.rm = TRUE)
    # compare original with new range
    if (!isTRUE(all.equal(value, original))) {
        updateSliderInput(
          session = session,
          inputId = id,
          min = value[1],
          max = value[2],
          value = value
        )
    }
  } else if (id == "direction") {
    levels <- unique(x[!is.na(x)])
    # no ui rendering when only one level exists
    D <- c(debit = search_pattern(levels, "d|(debit)|(debet)"))
    C <- c(credit = search_pattern(levels, "c|(credit)"))
    levels <- c(C, D)
    # compare original with new range
    if (!isTRUE(all.equal(levels, original))) {
        updateCheckboxGroupInput(
          session = session,
          inputId = id,
          choices = levels,
          selected = levels
        )
    }
  }
}

remove_ui <- function(x, id) {
  if (id == "level") {
    # level range in data
    value <- range(x, na.rm = TRUE)
    reactive({if (diff(value) > 1) TRUE else FALSE})
  } else if (id == "direction") {
    levels <- unique(x[!is.na(x)])
    # no ui rendering when only one level exists
    D <- c(debit = search_pattern(levels, "d|(debit)|(debet)"))
    C <- c(credit = search_pattern(levels, "c|(credit)"))
    levels <- c(C, D)
    reactive({if (length(levels) > 0) TRUE else FALSE})
  }
}

# default filters
make_def_ui <- function(RGS, id, nm) {
  selectizeInput(
    id,
    h5(nm),
    choices = find_vars(RGS, is.logical),
    options = list(
      placeholder = "Selecteer een bedrijfstype",
      onInitialize = I('function() { this.setValue(""); }')
    )
  )

}

filter_var <- function(x, val) {

  if (is.null(val)) return(rep(TRUE, length(x)))

  if (is.numeric(x)) {
    !is.na(x) & x >= val[1] & x <= val[2]
  } else if (is.character(x) | is.factor(x)) {
    is.na(x) | x %in% val
  } else if (is.logical(x)) {
    x
  } else {
    # No control, so don't filter
    TRUE
  }
}

find_vars <- function(RGS, filter = is.logical) {
  dplyr::select(RGS, tidyselect::vars_select_helpers$where(filter)) %>%
    colnames()
}

find_level <- function(RGS, external, vars) {
  if (!is.null(external)){
    dplyr::filter(RGS, .data$referentiecode == external)[[vars["Niveau"]]]
  } else {
    NULL
  }
}


search_pattern <- function(x, pattern) {
  reg <- stringr::regex(pattern, ignore_case = TRUE)
  x[stringr::str_detect(x, reg)] %>%
    # remove duplicate because of case
    # toupper() %>%
    unique()
}

make_panel <- function(x, nm, id){
  conditionalPanel(
    condition = paste0("output.", nm),
    x,
    ns = id
  )
}

# output$controls <- renderUI({
#   purrr::imap(
#     ivars,
#     function(var, nm) make_ui(filter()[[var]], NS(id, var), nm)
#   )
# })

# hide controls
# output$show1 <- reactive({
#   #TRUE
#   diff(input$nivo) > 1
# })
# output$show2 <- reactive({
#   #TRUE
#   length(input$d_c) >= 1
# })
#
# outputOptions(output, 'show1', suspendWhenHidden = FALSE)
# outputOptions(output, 'show2', suspendWhenHidden = FALSE)

# render controls for default filters (supplied by creator)
# output$default <- renderUI({
#   make_def_ui(RGS(), NS(id, "dynamic"), "Bedrijfstype")
#   })
