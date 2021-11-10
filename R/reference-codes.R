#' Obtain country specific reference system.
#'
#' Often accountants use standardized reference codes to assign booking to
#' certain journal posts and account on the general ledger.
#'
#' @param country A character string of the countries names. Any language is
#' supported.
#'
#' @return One or more entries form the coder reference database in tibble
#' format.
#'
#' @export
get_standard_business_reporting <- function(country = "Nederland") {

  # convert
  code <- countrycode::countrycode(
    countrycode::countryname(country),
    origin = 'country.name',
    destination = 'iso2c'
    )

  # extract country RGS
  pattern <- stringr::regex(
    paste0("^\\Q", code, "\\E"),
    ignore_case = TRUE
    )

  # extract
  tb_refs <- dplyr::filter(
      code_refs,
      stringr::str_detect(.data$country_code, pattern)
      ) %>%
    purrr::flatten()

  # check if information exists
  if (length(tb_refs) == 0) {
    stop("There is no standard reference system available for this country.",
         call. = FALSE)
  }

  # make connection
  httr::GET(tb_refs$url_ref, httr::write_disk(tf <- tempfile(fileext = ".xls")))
  callxl <- rlang::call2(
    "read_xlsx",
    rlang::expr(tf),
    !!! tb_refs$args_read,
    .ns = "readxl"
    )

  # execute
  suppressMessages(eval(callxl)) %>%
    janitor::clean_names()
}
