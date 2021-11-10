## code to prepare `code_refs` dataset goes here
code_refs <- tibble::tibble(
  country_code = "NL",
  url_ref = "https://www.referentiegrootboekschema.nl/sites/default/files/kennisbank/Defversie%20RGS%203.3-8-dec-2020.xlsx",
  args_read = list(list(sheet = 2, skip = 1, col_types = c(rep("text", 7), "numeric" ,rep("logical", 17))))
  )

usethis::use_data(code_refs, overwrite = TRUE)
