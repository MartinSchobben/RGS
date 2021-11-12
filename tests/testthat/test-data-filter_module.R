test_that("Sever output based on RGS input", {
  x <- reactiveVal()
  y <- reactiveVal()
  testServer(filter_server, args = list(RGS = x, external = y), {
    x(get_standard_business_reporting("Nederland"))
    y(get_standard_business_reporting("Nederland")$referentiecode)

    session$flushReact()
    session$setInputs(direction = "C", level = c(1,5))
    # unfiltered
    expect_equal(RGS(), get_standard_business_reporting("Nederland"))
    # credit/debit filtered
    expect_equal(
      session$returned(),
      dplyr::filter(
        get_standard_business_reporting("Nederland"),
        d_c %in%  "C" | is.na(d_c)
        )
      )
    # external input change
    session$flushReact()
    session$setInputs(direction = c("C", "D"), level = c(1,5))
    y("BVasOzv")
    expect_equal(session$returned()$referentiecode, "BVasOzv")
  })

})
