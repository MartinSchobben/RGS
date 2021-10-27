test_that("Sever output based on RGS input", {
  x <- reactiveVal()
  testServer(filter_server, args = list(RGS = x), {
    x(get_standard_business_reporting("nl"))

    session$flushReact()
    session$setInputs(direction = "C", level = c(1,5))
    # unfiltered
    expect_equal(RGS(), get_standard_business_reporting("nl"))
    # credit/debit filtered
    expect_equal(
      session$returned(),
      dplyr::filter(
        get_standard_business_reporting("nl"),
        d_c %in%  "C" | is.na(d_c)
        )
      )
  })

})
