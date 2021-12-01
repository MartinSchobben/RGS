#' Observation filtering
#'
#' GUI and server modules for filtering RGS datasets.
#'
#' @param id Namespace id.
#' @param level Name on controller ui for level in hierarchical data.
#' @param direction Name on controller ui for ledger side (debit or credit).
#' @param dynamic Name on controller ui for user supplied filters.
#' @param RGS Reactive value for the reference system.
#' @param external Reactive value for children of parent RGS.
#' @param iexternal Name of variable for reference codes.
#' @param ivars Named vector of length two for the variables associated with
#' `level` (see parameter ui above) and `direction` (see parameter ui above) to
#' filter data in the server module.
#'
#' @return Shiny GUI or server.
#' @export
filter_ui <- function(id, level = "Niveau", direction = "Balanszijde",
                      dynamic = "Rechtsvorm/sector",
                      examples = "Voorbeelden") {

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
  tagAppendChildren(
    ls_input,
    selectizeInput(
      NS(id, "dynamic"),
      h5(dynamic),
      choices = "",
      options = list(
        placeholder = "Selecteer een rechtsvorm/sector",
        onInitialize = I('function() { this.setValue(""); }')
      )
    ),
    selectizeInput(
      NS(id, "examples"),
      h5(examples),
      choices = c("Verkoopboek" = "sales"),
      options = list(
        placeholder = "Selecteer een voorbeeld",
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

    # filter based on example ledgers or plot selection
    codes <- eventReactive({external(); input$examples}, {
      if (input$examples == "") {
        # find children for selected
        child <- find_children(RGS(), external())

      } else {
        # examples represent selections of the full dataset
        extract <- RGS::examples
        extract <- extract[extract$daybook == input$examples, , drop = FALSE][[2]]
        child <- find_children(RGS(), external())
        child <- child[child %in% extract]

      }
      filter_var(RGS()[[iexternal]], child)
    })


    # return and include end point variable
    eventReactive(purrr::walk(names(ivars), ~input[[.x]]), {
      endnote_seeker(RGS()[codes() & filter(), , drop = FALSE])
    },
    ignoreInit = TRUE
    )
  })
}

#-------------------------------------------------------------------------------
# dynamic inputs
#-------------------------------------------------------------------------------
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

# conditional panel
make_panel <- function(x, nm, id){
  conditionalPanel(
    condition = paste0("output.", nm),
    x,
    ns = id
  )
}

# remove controllers with conditional panels
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
    reactive({if (length(levels) > 1) TRUE else FALSE})
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
    unique()
}

#-------------------------------------------------------------------------------
# filter observations
#-------------------------------------------------------------------------------

filter_var <- function(x, val = NULL) {

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

#-------------------------------------------------------------------------------
# find terminal nodes
#-------------------------------------------------------------------------------
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

  # check whether the codes actually exist in the data
  upper_nodes <- upper_nodes[names(upper_nodes) %in% RGS$referentiecode]

  # add to original but first order vector to names
  order_nodes <- upper_nodes[order(
    factor(names(upper_nodes), levels = RGS$referentiecode)
  )]
  tibble::add_column(RGS, terminal = order_nodes)

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
