ui <- fluidPage(
  plot_ui("plot", download = download_ui("RGS"))
)

server <- function(input, output, session) {
  plot_server(
    "plot",
    reactiveVal(get_standard_business_reporting("Nederland")),
    reactiveVal(get_standard_business_reporting("Nederland")$referentiecode)
    )
}

# virtual sessions
test_that("Can I select reference codes from plot", {
  app <- shinytest::ShinyDriver$new(shinyApp(ui, server))
  # click plot reset
  app$click("plot-reset")
  expect_equal(app$getValue("plot-reset"), 1)
  })

# server only
test_that("Sever output based on figure selection", {
  x <- reactiveVal()
  y <- reactiveVal()
  testServer(plot_server, args = list(RGS = x, child = y), {
    x(get_standard_business_reporting("Nederland"))
    y(get_standard_business_reporting("Nederland")$referentiecode)

    session$flushReact()

    # select something on the plot
    session$setInputs(plot_selected = "BFvaOvr")
    expect_equal(
      session$returned(),
      find_children(
        parent_seeker(get_standard_business_reporting("Nederland")),
        "BFvaOvr"
        )
      )
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
