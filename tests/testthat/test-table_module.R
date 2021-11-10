RGS <- dplyr::select(
  get_standard_business_reporting("Nederland"),
  .data$referentiecode,
  .data$omschrijving,
  .data$referentienummer
)

ui <- fluidPage(
  table_ui("table")
)


server <- function(input, output, session) {
  table_server(
    "table",
    reactiveVal(RGS)
  )
}

shinyApp(ui, server)

test_that("drill down nesting", {

  # reformat
  refs <- dplyr::pull(RGS, .data$referentiecode)
  chunks <- purrr::map_df(
    parent_seeker_(refs),
    ~parent_code(.x, parent = FALSE, label = "Niveau")
    )
  split <- purrr::accumulate(as.list(chunks), stringr::str_c) %>%
    tibble::as_tibble()

  # nesting
  nested <- dplyr::bind_cols(split, tidyr::replace_na(RGS, list(referentienummer = 0)))

  # display
  expect_snapshot(display_data(nested, 2))
  expect_snapshot(reactable::reactable(display_data(nested), details = drill_down(nested)))
  # remove column names
  expect_snapshot(reactable::reactable(display_data(nested), columns = remove_column_names(display_data(nested))))
})
