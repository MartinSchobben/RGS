## code to prepare `code_refs` dataset
code_refs <- tibble::tibble(
  country_code = "NL",
  url_ref = "https://www.referentiegrootboekschema.nl/sites/default/files/kennisbank/Defversie%20RGS%203.3-8-dec-2020.xlsx",
  args_read = list(list(sheet = 2, skip = 1, col_types = c(rep("text", 7), "numeric" ,rep("logical", 17))))
)

# code to prepare `examples` dataset

# omzet belasting codes
code_btw <- dplyr::filter(
  RGS::get_standard_business_reporting("Nederland"),
  stringr::str_detect(.data$referentiecode, "^WOmz")
  ) %>% dplyr::pull(.data$referentiecode)

examples <- tibble::tibble(
  daybook = "sales",
  fixed = c(
    reformat_data("BVorDebHad", bind = FALSE),
    reformat_data("BSchBepBtw", bind = FALSE),
    "W", code_btw
    )
)

usethis::use_data(code_refs, overwrite = TRUE)
usethis::use_data(examples, overwrite = TRUE)
