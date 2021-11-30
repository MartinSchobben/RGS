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
filter_ui <- function(id, level = "Niveau", direction = "Balanszijde",
                      dynamic = "Rechtsvorm/sector") {

  ls_input <- tagList(
    sliderInput(
      NS(id, "level"),
      h5(level),
      min = 0,
      max = 0,
      value = c(0, 0),
      step = 1
      ),
    checkboxGroupInput(
      NS(id, "direction"),
      h5(direction),
      choices = "",
      selected = "",
      inline = TRUE
    )
  )

  # conditional panels
  ls_input <- purrr::map2(
    ls_input,
    c("level", "direction"),
    ~make_panel(.x, .y, id = NS(id))
  )

  # default filters
  tagAppendChild(
    ls_input,
    selectizeInput(
      NS(id, "dynamic"),
      h5(dynamic),
      choices = "",
      options = list(
        placeholder = "Selecteer een rechtsvorm/sector",
        onInitialize = I('function() { this.setValue(""); }')
      )
    )
  )

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

    # update controls to make them conditional to the available variable ranges
    observeEvent(codes(), {
      sub <- RGS()[req(codes()), , drop = FALSE]
      purrr::iwalk(
        ivars,
        ~update_ui(sub[[.x]], input[[.y]], id = .y, session = session)
      )
    })
    observeEvent(filter(), {
      sub <- RGS()[req(filter()), , drop = FALSE]
      purrr::iwalk(
        ivars,
        ~update_ui(sub[[.x]], input[[.y]], id = .y, session = session)
      )
      # default filter
      dynamic_ui(sub, input$dynamic, "dynamic", session = session)
    })

    # remove controls from view when choices are absent
    observe({
      sub <- RGS()[req(codes()) & req(filter()), , drop = FALSE]
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
    filter <- eventReactive({
      purrr::walk(c(names(ivars), "dynamic"), ~input[[.x]])
    }, {
      each_var <- purrr::imap(
        c(ivars, input$dynamic),
        ~filter_var(RGS()[[.x]], input[[.y]])
      )
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
    reactive({if (diff(value) > 0) TRUE else FALSE})
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
dynamic_ui <- function(RGS, value, id, session) {
  updateSelectizeInput(
    session = session,
    inputId = id,
    choices = find_vars(RGS, is.logical),
    selected = isolate(value)
  )
}

filter_var <- function(x, val = NULL) {

  # if (is.null(val)) return(rep(TRUE, length(x)))

  if (is.numeric(x)) {
    !is.na(x) & x >= val[1] & x <= val[2]
  } else if (is.character(x) | is.factor(x)) {
    is.na(x) | x %in% val
  } else if (is.logical(x)) {
    !is.na(x) & x
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
