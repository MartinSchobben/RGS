#' Sunburst
#'
#' @param RGS
#'
#' @return
#' @export
RGS_sunburst <- function(
  RGS = parent_seeker(get_standard_business_reporting("nl")),
  interactive = TRUE
  ) {

  add_weight(RGS) %>%
   rectify(interactive = interactive) %>%
   pie_baker()
}
#' @rdname RGS_sunburst
#'
#' @export
parent_seeker <- function(RGS = get_standard_business_reporting("nl")) {

  ref_codes <- dplyr::pull(RGS, referentiecode)

  # split of parent
  mt <- parent_seeker_(ref_codes)

  # recast into parent vector and tibble
  parent <- purrr::map_chr(mt, parent_code)
  tb <- tibble::tibble(parent, child = ref_codes)
  dplyr::left_join(tb, RGS, by = c("child" = "referentiecode"))
}

# element wise
parent_seeker_ <- function(code) {
  stringr::str_split(
    code,
    "((?<=([A-Z]|[:alnum:]))[^[:alnum:]]*(?=[A-Z]))",
    simplify = FALSE
  )
}

parent_code <- function(code) {

  code <- purrr::map_chr(code, ~stringr::str_replace(.x, "\\s", NA_character_))
  nmax <- length(code)
  stringr::str_c(code[1:nmax - 1], collapse = "")
}

# assess weight of univariate categorical variable with hierarchical structure
add_weight <- function(RGS) {

  # split groups and rename child to depth in tree
  ls_RGS <- dplyr::select(RGS, .data$parent, .data$child) %>%
    dplyr::group_by(n = nchar(.data$parent)) %>%
    dplyr::group_split(.keep = FALSE) %>%
    purrr::imap(function(x, n) dplyr::rename(x, "child_{n}" := child))

  # names
  nm_child <- stringr::str_c("child_", 1:length(ls_RGS))

  # recast as wide data frame
  wide_RGS <- purrr::reduce2(
    ls_RGS,
    purrr::map(nm_child[-length(nm_child)], ~rlang::set_names("parent", .)),
    dplyr::left_join,
  )

  # add counts and normalise to total count of maximum depth in the tree
  RGS_wt <- purrr::map_dfc(
    c("parent", nm_child),
    ~dplyr::add_count(wide_RGS, !!rlang::sym(.x), name = paste0("weight", sub("[^0-9|_]*", "", .x))) %>%
      dplyr::select(last_col())
    ) %>%
    dplyr::mutate(dplyr::across(.fns = ~.x / weight)) %>%
    dplyr::select(-weight)

  # recast to long format
  long_weight <- tidyr::pivot_longer(RGS_wt, everything(), names_to = c(".value", "level"), names_sep = "_")
  long_child <- tidyr::pivot_longer(dplyr::select(wide_RGS, -parent), everything(), names_to = c(".value", "level"), names_sep = "_")
  weights <- dplyr::bind_cols(long_child, dplyr::select(long_weight, -level))

  # distinct
  weights <- dplyr::distinct(weights, .data$child, .keep_all = TRUE)
  dplyr::left_join(RGS, weights, by = "child")
}

# create plot element (rectangles) vectorised
rectify <- function(RGS, n_max = 1, interactive) {

  ls_RGS <- dplyr::group_by(RGS, n = nchar(.data$child)) %>%
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
  dplyr::group_by(RGS, .data$child) %>%
    dplyr::summarise(
      tot_weight = sum(.data$weight),
      omschrijving = unique(.data$omschrijving),
      element = parent_seeker_(.data$child) %>% purrr::map_chr(~tail(.x, n= 1))
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
  ggrepel::geom_text_repel(
    data = text_data,
    mapping = ggplot2::aes(
      x = 1.5,
      y = ymid,
      label = .data$element
      ),
    vjust = 1,
    hjust = 1
    # direction = "y",
    #force = 2
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
        fill = .data$child,
        tooltip = .data$omschrijving,
        data_id = .data$child
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
        fill = .data$child
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

