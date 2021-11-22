test_that("parent and weight generation work", {
  tb <- get_standard_business_reporting("Nederland") %>% endnote_seeker()
  expect_snapshot(add_weight(tb))
})
