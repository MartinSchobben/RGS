test_that("load RGS for country", {
  expect_snapshot(get_standard_business_reporting("nl"))
  expect_snapshot(get_standard_business_reporting("Netherlands"))
  expect_error(
    get_standard_business_reporting("d"),
    "There is no standard reference system available for this country."
    )
})
