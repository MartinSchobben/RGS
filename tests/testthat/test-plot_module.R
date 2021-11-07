ui <- fluidPage(
  plot_ui("plot")
)

server <- function(input, output, session) {
  plot_server(
    "plot",
    reactiveVal(get_standard_business_reporting("nl")),
    reactiveVal(get_standard_business_reporting("nl")$referentiecode)
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
    x(get_standard_business_reporting("nl"))
    y(get_standard_business_reporting("nl")$referentiecode)

    session$flushReact()

    # select something on the plot
    session$setInputs(plot_selected = "BFvaOvr")
    expect_equal(
      session$returned(),
      find_children(
        parent_seeker(get_standard_business_reporting("nl")),
        "BFvaOvr"
        )
      )
  })
})
