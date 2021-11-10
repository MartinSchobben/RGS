test_that("Loading the respective dataset and alter ui based on availability", {
  expect_snapshot(data_ui("x"))
})

test_that("Server output based on available data", {

  x <- reactiveVal()
  testServer(data_server, args = list(RGS = x), {

    x(get_standard_business_reporting("nl"))

    dataset <- session$getReturned()

    session$setInputs(dataset = "nl")
    expect_equal(dataset(), get_standard_business_reporting("nl"))
  })
})
