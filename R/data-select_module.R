#' Variable selection
#'
#' GUI and server modules for variable selection of RGS datasets.
#'
#' @param id Namespace id.
#' @param RGS Reactive value for the reference system.
#' @param ref_code Pre-selected variables (character string or vector).
#' @param default Default variables (character string or vector).
#' @param additional Additional variables (character string or vector).
#'
#' @return Shiny GUI or server.
#' @export
select_ui <- function(id) {
  tagList(
    selectInput(
      NS(id, "var"),
      h6("Selecteer kolom"),
      choices = NULL,
      multiple = TRUE,
      width = "66%"
    )
  )
}
#' @rdname select_ui
#'
#' @export
select_server <- function(id, RGS,
                          ref_code = c("referentiecode", "nivo", "terminal"),
                          default = c("omschrijving", "referentienummer"),
                          additional = c("sortering", "omschrijving_verkort",
                                         "referentie_omslagcode")) {

  stopifnot(is.reactive(RGS))

  moduleServer(id, function(input, output, session) {

    # default selection
    def_vars <- reactive({default[default %in% colnames(RGS())]})

    observeEvent(RGS(), {
      updateSelectInput(
        session,
        "var",
        choices =  c(def_vars(), additional),
        selected =  def_vars()
      )
    })

    # custom selection
    reactive({dplyr::select(RGS(), ref_code, input$var)})
  })
}
