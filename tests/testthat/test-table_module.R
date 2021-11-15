# data
RGS <- dplyr::select(
  get_standard_business_reporting("Nederland"),
  .data$referentiecode,
  .data$omschrijving,
  .data$referentienummer,
  .data$nivo
)

# ui <- fluidPage(
#   table_ui("table", select = select_ui("select"))
# )
#
# server <- function(input, output, session) {
#   table_server(
#     "table",
#     reactiveVal(RGS)
#   )
# }
#
# # virtual sessions
# test_that("Can I select reference codes from plot", {
#   app <- shinytest::ShinyDriver$new(shinyApp(ui, server))
# })

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


test_that("Test that columns of children of levels that don't exist do not appear",{

  RGS_xc <- dplyr::filter(RGS, .data$nivo > 1)
  expect_snapshot(reformat_data(RGS_xc))
})
