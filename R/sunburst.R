#' Sunburst
#'
#' Sunburst plot for hierarchical data.
#'
#' @param RGS \href{https://www.referentiegrootboekschema.nl/}{Referentie GrootboekSchema}
#' @param interactive Make plot interactive.
#'
#' @return \code{ggplot2::\link[ggplot2:ggplot]{ggplot}()}
#' @export
RGS_sunburst <- function(
  RGS = get_standard_business_reporting("Nederland"),
  interactive = TRUE
  ) {

  add_weight(RGS) %>%
   rectify(interactive = interactive) %>%
   pie_baker()
}
#' @rdname RGS_sunburst
#'
#' @export
parent_seeker <- function(RGS = get_standard_business_reporting("Nederland")) {

  ref_codes <- dplyr::pull(RGS, .data$referentiecode)

  # split of parent
  ls_par <- parent_seeker_(ref_codes)

  # recast into parent vector and tibble
  parent <- purrr::map_chr(ls_par, parent_code)
  tb <- tibble::tibble(parent, child = ref_codes)
  dplyr::left_join(tb, RGS, by = c("child" = "referentiecode"))
}

# element wise
parent_seeker_ <- function(code) {
  stringr::str_split(
    code,
    "((?<=([A-Z]|[:alnum:]))[^[:alnum:]]*(?=[A-Z]))"
    )
}

parent_code <- function(code, parent = TRUE, label = "child_") {

  # make NAs
  code <- stringr::str_replace(code, "\\s", NA_character_)
  # length character vector
  nmax <- length(code)

  if (isTRUE(parent)) {
    stringr::str_c(code[1:nmax - 1], collapse = "")
  } else {
    rlang::set_names(code, nm = c(paste0(label, 1:nmax)))
  }
}

# assess weight of univariate categorical variable with hierarchical structure
add_weight <- function(RGS, label = "child_") {

  # rename to depth in tree
  vc_RGS <- reformat_data(RGS, labels = label, bind = FALSE)

  # add counts and normalise to total count of maximum depth in the tree
  weights <- purrr::map(vc_RGS, ~{table(.x)/length(.x)}) %>% purrr::flatten_dbl()

  # add weight to df
  dplyr::mutate(RGS, weight = dplyr::recode(.data$referentiecode, !!!weights))
}

# create plot element (rectangles) vectorised
rectify <- function(RGS, n_max = 1, interactive) {

  ls_RGS <- dplyr::group_by(RGS, n = nchar(.data$referentiecode)) %>%
    dplyr::group_split()
  rect_init <- rectify_(ls_RGS[[1]], n = 0, interactive = interactive)
  text_init <- textify_(ls_RGS[[1]])
  # check maximum length of list
  if (length(ls_RGS) < n_max + 1) n_max <- length(ls_RGS) - 1
  # static rectangles only if list is longer than length 1
  if (length(ls_RGS) > 1) {
    rect_static <- purrr::imap(
      ls_RGS[-1][1:n_max],
      rectify_,
      interactive = FALSE,
      alpha = 0.3
      )
  } else {
    rect_static <- list(NULL)
  }
  # return
  purrr::prepend(rect_static, rect_init) %>%
    append(text_init)
}

# summarise
transform_stat <-  function(RGS) {
  dplyr::group_by(RGS, .data$referentiecode) %>%
    dplyr::summarise(
      tot_weight = sum(.data$weight),
      omschrijving = unique(.data$omschrijving),
      element = parent_seeker_(.data$referentiecode) %>% purrr::map_chr(~tail(.x, n= 1))
    ) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(
      ymax = cumsum(.data$tot_weight),
      ymin = dplyr::lag(.data$ymax, n = 1, default = 0),
      ymid = .data$ymin + ((.data$ymax - .data$ymin) / 2)
    )
}

# element wise text
textify_ <- function(RGS) {

  text_data <- transform_stat(RGS)
  suppressWarnings(
    ggrepel::geom_text_repel(
      data = text_data,
      mapping = ggplot2::aes(
        x = 1.5,
        y = .data$ymid,
        label = .data$element
      ),
        # vjust = 1,
        # hjust = 1
        # direction = "y",
        force = 2,
        size = 6
    )
  )

}
# element wise rects
rectify_ <- function(RGS, n = 1, interactive, alpha = 1) {

  rect_data <- transform_stat(RGS)

  if (isTRUE(interactive)) {
    ggiraph::geom_rect_interactive(
      data = rect_data,
      mapping = ggplot2::aes(
        xmin = 1 + {{n}},
        xmax = 2 + {{n}},
        ymin = .data$ymin,
        ymax = .data$ymax,
        fill = .data$referentiecode,
        tooltip = .data$omschrijving,
        data_id = .data$referentiecode
        ),
      alpha = alpha,
      color = "white",
      show.legend = FALSE
    )
  } else {
    ggplot2::geom_rect(
      data = rect_data,
      mapping = ggplot2::aes(
        xmin = 1 + {{n}},
        xmax = 2 + {{n}},
        ymin = .data$ymin,
        ymax = .data$ymax,
        fill = .data$referentiecode
        ),
      alpha = alpha,
      color = "white",
      show.legend = FALSE
    )
  }
}

# make final plot
pie_baker <- function(rects, lab = FALSE) {

  p <- ggplot2::ggplot() +
    rects +
    ggplot2::xlim(0, length(rects)) +
    ggplot2::theme_void() +
    ggplot2::coord_polar(theta = "y")

  if (isTRUE(lab)) {
    p + ggplot2::labs(title = "Referentie GrootboekSchema") }
  else {
    p
  }
}
