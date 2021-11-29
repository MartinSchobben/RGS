# data
RGS <- dplyr::select(
  get_standard_business_reporting("Nederland") %>% endnote_seeker(),
  .data$referentiecode,
  .data$omschrijving,
  .data$referentienummer,
  .data$nivo,
  .data$terminal
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

test_that("Another filtering operation simulating clicking on the sunburst graphic", {
  labels <- "Niveau "
  filterRGS <- dplyr::filter(
    RGS,
    .data$referentiecode %in% find_children(parent = "BFvaOve")
  )
  nestedRGS <- reformat_data(filterRGS)
  expect_snapshot(display_data(nestedRGS, labels))
})

test_that("Test that columns of children of levels that don't exist do not appear",{

  RGS_xc <- dplyr::filter(RGS, .data$nivo > 1)
  expect_snapshot(reformat_data(RGS_xc))
})


test_that("Drilldown", {
  # reformat
  labels <- "Niveau "
  nested <- reformat_data(RGS)

  expect_snapshot(
    drill_down(
      nested[,-c(1:3)],
      display_data(nested[,-c(1:3)], labels),
      labels,
      test_modus = TRUE
    )(1)
    )
  expect_null(
    drill_down(
      nested[,-c(1:4)],
      display_data(nested[,-c(1:4)], labels),
      labels,
      test_modus = TRUE
    )(1)
  )

})
