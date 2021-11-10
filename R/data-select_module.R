#' Variable selection
#'
#'
#' @export
select_ui <- function(id) {
  tagList(
    selectInput(
      NS(id, "var"),
      h5("Selecteer kolom"),
      choices = NULL,
      multiple = TRUE,
      width = "75%"
    ),
    downloadButton("Download")
  )
}
#' @rdname select_ui
#'
#' @export
select_server <- function(id, RGS, ref_code = c("referentiecode", "nivo"),
                          default = c("omschrijving", "referentienummer")) {

  stopifnot(is.reactive(RGS))

  moduleServer(id, function(input, output, session) {

    # default selection
    def_vars <- reactive(default[default %in% colnames(RGS())])

    observeEvent(RGS(), {
      updateSelectInput(
        session,
        "var",
        choices =  def_vars(),
        selected =  def_vars()
      )
    })

    # custom selection
    reactive(dplyr::select(RGS(),  ref_code, input$var))

  })
}
