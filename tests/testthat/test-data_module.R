test_that("Loading the respective dataset and alter ui based on availability", {
  expect_snapshot(input_ui("x"))
})

test_that("Server output based on available data", {

  testServer(input_server, {

    dataset <- session$getReturned()

    session$setInputs(dataset = "Nederland")
    expect_equal(dataset(), get_standard_business_reporting("Nederland"))
  })
})
