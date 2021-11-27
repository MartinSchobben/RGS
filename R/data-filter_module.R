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
  tagList(uiOutput(NS(id, "controls")))
    #uiOutput(NS(id, "default"))
}
#' @rdname filter_ui
#'
#' @export
filter_server <- function(id, RGS, external, iexternal = "referentiecode",
                          ivars = c(Balanszijde = "d_c", Niveau = "nivo")) {

  stopifnot(is.reactive(RGS))
  stopifnot(is.reactive(external))

  moduleServer(id, function(input, output, session) {

    # find children for selected
    child <- reactive({find_children(RGS(), external())})

    # prevent flickering by two time flushing by child() and input reactive vals
    observeEvent(child(), {purrr::walk(ivars, ~freezeReactiveValue(input, .x))})

    # conditional isolation of filter values
    observe(message(glue::glue("obs filter = {nrow(filter())}")))


    # render controls
    output$controls <- renderUI({
      purrr::imap(
        ivars,
        function(var, nm) make_ui(filter()[[var]], NS(id, var), nm)
      ) %>%
        purrr::imap(~make_panel(.x, .y, id = NS(id)))
    })

    # hide controls
    output$show1 <- reactive({
      #TRUE
      diff(input$nivo) > 1
      })
    output$show2 <- reactive({
      #TRUE
      length(input$d_c) >= 1
      })

    outputOptions(output, 'show1', suspendWhenHidden = FALSE)
    outputOptions(output, 'show2', suspendWhenHidden = FALSE)

    observe(message(glue::glue("range: {diff(input$nivo) < 1} and levels: {length(input$d_c) <= 1}")))

    # render controls for default filters (supplied by creator)
    # output$default <- renderUI({
    #   make_def_ui(RGS(), NS(id, "dynamic"), "Bedrijfstype")
    #   })

    # pseudo input value
    pseudo <- reactiveValues()
    observe({
      # external input
      pseudo[[iexternal]] <- child()
      # internal input
      purrr::walk(ivars, ~{pseudo[[.x]] <- input[[.x]]})
      message(glue::glue("{(x<-reactiveValuesToList(pseudo));str(x)}"))
      })

    # temporary check
    # observe(message(glue::glue("{obs()}")))
    # extra <- reactive({if (length(obs()) != 0) RGS <- RGS()[obs(), , drop = FALSE] else RGS <- RGS()})
    # observe(message(glue::glue("Selected: {external()} and number of children: {length(child())} and the nivo range: {stringr::str_c(range(extra()$nivo), collapse = ':')} ")))

    # filter based on controllers and plot selection
    filter <- eventReactive(purrr::walk(c(iexternal, ivars), ~pseudo[[.x]]), {
      each_var <- purrr::map(
        c(iexternal, ivars),
        function(var) filter_var(RGS()[[var]], pseudo[[var]])
        )
      obs <- purrr::reduce(each_var, `&`)
      RGS()[obs, , drop = FALSE]
    },
    ignoreInit = T
    )

    # return and include end point variable
    eventReactive(purrr::walk(ivars, ~input[[.x]]) ,{
      endnote_seeker(filter())
    })
  })
}

#
# trigger <- reactive({any(purrr::map_lgl(vars(), ~isTruthy(pseudo[[.x]])))})

make_ui <- function(x, id, name) {

  if (stringr::str_detect(id, "nivo")) {
    # level range
    value <- range(x, na.rm = TRUE)
    # no ui rendering when at end of range
    #if (diff(value) < 1) return()
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
    # no ui rendering when only one level exists
    #if (length(levels) <= 1) return()
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
    condition = paste0("output.show", nm),
    x,
    ns = id
  )
}

