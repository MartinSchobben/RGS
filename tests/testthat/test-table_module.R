RGS <- dplyr::select(
  get_standard_business_reporting("Nederland"),
  .data$referentiecode,
  .data$omschrijving,
  .data$referentienummer,
  .data$nivo
)

# ui <- fluidPage(
#   table_ui("table")
# )
#
# server <- function(input, output, session) {
#   table_server(
#     "table",
#     reactiveVal(RGS)
#   )
# }
#
# shinyApp(ui, server)

test_that("drill down nesting", {

  # reformat
  labels <- "Niveau "
  nested <- reformat_data(RGS)
  expect_snapshot(nested)

  # display
  expect_snapshot(display_data(nested, labels))
  expect_snapshot(
    reactable::reactable(
      display_data(nested, labels),
      details = drill_down(nested, display_data(nested, labels), labels)
      )
    )
  # remove column names
  expect_snapshot(
    reactable::reactable(
      display_data(nested, labels),
      details = drill_down(nested, display_data(nested, labels), labels),
      columns = remove_column_names(display_data(nested, labels))
      )
    )

  # reformat on filter data
  nested <- reformat_data(dplyr::filter(RGS, nivo == 5))
  expect_snapshot(nested)

  # display
  expect_snapshot(display_data(nested, labels))

})