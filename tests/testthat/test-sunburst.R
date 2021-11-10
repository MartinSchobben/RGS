test_that("parent and weight generation work", {
  expect_snapshot(parent_seeker(get_standard_business_reporting("Nederland")))
  tb <- parent_seeker(get_standard_business_reporting("Nederland"))
  expect_snapshot(add_weight(tb))
})
