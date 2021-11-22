test_that("Loading the respective dataset and alter ui based on availability", {
  expect_snapshot(input_ui("x"))
})


test_that("Server output based on available data", {
  # terminal nodes
  RGS_end <- endnote_seeker(get_standard_business_reporting("Nederland"))

  testServer(input_server, {

    dataset <- session$getReturned()

    session$setInputs(dataset = "Nederland")
    expect_equal(dataset(),  RGS_end)
  })
})

test_that("find terminal nodes" , {
  RGS <- get_standard_business_reporting("Nederland")
  # remove an RGS level
  RGS <- RGS[!stringr::str_detect(RGS$referentiecode, "BIvaKouVvp([:alnum:])+"), ]
  ls_codes <- reformat_data(RGS, bind = FALSE)

  # terminal node
  expect_equal(terminator_(ls_codes[[4]][4], ls_codes[[5]] %>% .[!is.na(.)]), TRUE)
  # none terminal node
  expect_equal(terminator_(ls_codes[[4]][5], ls_codes[[5]] %>% .[!is.na(.)]), FALSE)

  # any terminal nodes
  expect_snapshot(terminator(ls_codes, 4))
  # for all levels
  expect_snapshot(endnote_seeker(RGS))

})
