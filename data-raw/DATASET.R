## code to prepare `code_refs` dataset goes here
code_refs <- tibble::tibble(
  country = "Netherlands",
  country_code = "NL",
  url_ref = "https://www.referentiegrootboekschema.nl/sites/default/files/kennisbank/Defversie%20RGS%203.3-8-dec-2020.xlsx",
  args_read = list(list(sheet = 2, skip = 1, col_types = "text")),
  var_select =
    list(
      c(
        `reference code` = "Referentiecode",
        `reference number` = "Referentienummer",
        `description short` = "Omschrijving (verkort)",
        `description long` = "Omschrijving",
        `one-man business` = "EZ/VOF...12",
        direction = "D/C"
        )
      )
  )

usethis::use_data(code_refs, overwrite = TRUE)
