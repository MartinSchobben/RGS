# ui <- fluidPage(
#   plot_ui("plot", download = input_ui("RGS", 1))
# )
#
# server <- function(input, output, session) {
#   plot_server(
#     "plot",
#     reactiveVal(get_standard_business_reporting("Nederland") %>% endnote_seeker())
#     )
# }
#
# #virtual sessions
# test_that("Can I select reference codes from plot", {
#   app <- shinytest::ShinyDriver$new(shinyApp(ui, server))
#   # click plot reset
#   app$click("reset")
#   expect_equal(app$getValue("reset"), 1)
#   })


# server only
test_that("Sever output based on figure selection", {
  x <- reactiveVal()
  testServer(plot_server, args = list(RGS = x), {
    # data
    x(get_standard_business_reporting("Nederland"))

    # successive selection on the plot
    session$setInputs(plot_selected = "B")
    session$flushReact()
    session$setInputs(plot_selected = "BIva")
    session$flushReact()
    session$setInputs(plot_selected = "BIvaKou")
    session$flushReact()
    session$setInputs(plot_selected = "BIvaKouVvp")
    session$flushReact()
    session$setInputs(plot_selected = "BIvaKouVvpDes")
    session$flushReact()

    # print
    print(session$returned())
    # print(output$reference)
    # print(selected())
    # print(rows())

    # terminal point returns parent
    expect_equal(session$returned(), "BIvaKouVvpDes")
    expect_snapshot(output$reference)
    expect_equal(selected(), "BIvaKouVvpDes")
    expect_snapshot(rows())

    # go back one layer with "Terug" button
    session$setInputs(back = 0)
    session$flushReact()
    expect_equal(session$returned(), "BIvaKouVvp")
    expect_snapshot(output$reference)
    expect_equal(selected(), "BIvaKouVvp")
    expect_snapshot(rows())
    # print
    print(session$returned())
  })
})

alternative_extract <- function(
  RGS = get_standard_business_reporting("Nederland"),
  pattern
  ) {

  dplyr::filter(
    RGS,
    stringr::str_detect(.data$referentiecode, paste0("^", pattern))
    )[["referentiecode"]] %>%
    .[!stringr::str_detect(., paste0("^", pattern, "$"))]
}

test_that("Find children", {
  expect_equal(
    find_children(parent = NULL),
    NULL
  )
  expect_equal(
    find_children(parent = "B"),
    alternative_extract(pattern = "B")
    )
  expect_equal(
    find_children(parent = "BIva"),
    alternative_extract(pattern = "BIva")
  )
  expect_equal(
    find_children(parent = "BIvaKou"),
    alternative_extract(pattern = "BIvaKou")
  )
  expect_equal(
    find_children(parent = "BIvaKouVvp"),
    alternative_extract(pattern = "BIvaKouVvp")
  )
  # terminal node returns previous node's children
  expect_equal(
    find_children(parent = "BIvaKouVvpBeg"),
    alternative_extract(pattern = "BIvaKouVvp")
  )
})


test_that("Find parents",{
  expect_equal(find_parents(NULL), NULL)
  expect_equal(find_parents(""), NULL)
})
