test_that("parent and weight generation work", {
  expect_snapshot(parent_seeker(get_standard_business_reporting("nl")))
  tb <- parent_seeker(get_standard_business_reporting("nl"))
  expect_snapshot(add_weight(tb))
})
