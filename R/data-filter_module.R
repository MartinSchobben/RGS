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
filter_ui <- function(id) {
  tagList(
    uiOutput(NS(id, "controls")),
    uiOutput(NS(id, "default"))
  )
}
#' @rdname filter_ui
#'
#' @export
filter_server <- function(id, RGS, external,
                          ivars = c(Balanszijde = "d_c", Niveau = "nivo")) {

  stopifnot(is.reactive(RGS))
  stopifnot(is.reactive(external))

  moduleServer(id, function(input, output, session) {

    # find children for selected
    child <- reactive({find_children(RGS(), external())})

    # Hadley's book
    # render controls
    output$controls <- renderUI({
      # omit level on gui slider based on graphic selected level
      omit <- find_level(RGS(), external(), ivars)
      purrr::imap(
        ivars,
        function(var, nm) make_ui(RGS()[[var]], NS(id, var), nm, omit)
      )
    })

    # render controls for default filters (supplied by creator)
    output$default <- renderUI({
      make_def_ui(RGS(), NS(id, "dynamic"), "Bedrijfstype")
      })

    # variables to be filtered
    vars <- reactive({c(ivars, input$dynamic)})

    trigger <- reactiveVal(NULL)
    observe({
      trigger(isolate(external()))
    })

    event_trigger <- reactive({
      any(purrr::map_lgl(vars(), ~isTruthy(input[[.x]]))) #& (trigger() == external())
    })

    observe(message(glue::glue("or is it zero: {is.null(trigger())} ")))

    obs1 <- eventReactive(event_trigger(), {
      # filter based on controllers; only react when panel controllers are changed
      each_var <- purrr::map(
        vars(),
        function(var) filter_var(RGS()[[var]], input[[var]])
        )
      purrr::reduce(each_var, `&`)
    },
    ignoreInit = TRUE,
    ignoreNULL = FALSE
    )

    obs2  <- eventReactive(external(), {
    # filter children based on external input; only react when plot selected
      RGS()$referentiecode %in% child()
    },
    ignoreNULL = FALSE
    )

    # return
    reactive({endnote_seeker(RGS()[obs1() & obs2(), , drop = FALSE])})
  })
}

# any(purrr::map_lgl(vars(), ~isTruthy(input[[.x]])))


make_ui <- function(x, id, name, external = NULL) {

  if (stringr::str_detect(id, "nivo")) {
    # level range
    value <- range(x, na.rm = TRUE)
    if (!is.null(external)) {
      value[1] <- external + 1
      # no ui rendering when at end of range
      if (external + 1 >= value[2]) return(NULL)
    }
    sliderInput(
      id,
      h5(name),
      min = value[1],
      max = value[2],
      value = value,
      step = 1
    )
  } else if (stringr::str_detect(id, "d_c")) {
    levels <- unique(x[!is.na(x)])
    D <- c(debit = search_pattern(levels, "d|(debit)|(debet)"))
    C <- c(credit = search_pattern(levels, "c|(credit)"))
    levels <- c(C, D)
    checkboxGroupInput(
      id,
      h5(name),
      choices = levels,
      selected = levels,
      inline = TRUE
    )
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
  if (is.numeric(x)) {
    !is.na(x) & x >= val[1] & x <= val[2]
  } else if (is.character(x) | is.factor(x)) {
    is.na(x) | toupper(x) %in% val
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
    toupper() %>%
    unique()
}
