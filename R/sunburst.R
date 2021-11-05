#' Sunburst
#'
#' @param RGS
#'
#' @return
#' @export
RGS_sunburst <- function(RGS = get_standard_business_reporting("nl")) {

  p <- parent_seeker(RGS) %>% add_weight() %>% rectify() %>% pie_baker()

  #plotly::ggplotly(p)
  p
  }

parent_seeker <- function(RGS) {

  ref_codes <- dplyr::pull(RGS, referentiecode)

  mt <- ref_codes %>%
    stringr::str_split("((?<=([A-Z]|[:alnum:]))[^[:alnum:]]*(?=[A-Z]))", simplify = F)

  # recast into parent
  parent <- purrr::map_chr(mt, parent_code)

  tb <- tibble::tibble(parent, child = ref_codes)

  dplyr::left_join(tb, RGS, by = c("child" = "referentiecode"))
  }

add_weight <- function(RGS) {

  ls_RGS <- dplyr::select(RGS, .data$parent, .data$child) %>%
    dplyr::group_by(n = nchar(.data$parent)) %>%
    dplyr::group_split(.keep = FALSE) %>%
    purrr::imap(function(x, n) dplyr::rename(x, "child_{n}" := child))

  # names
  nm_child <- stringr::str_c("child_", 1:length(ls_RGS))

  wide_RGS <- purrr::reduce2(
    ls_RGS,
    purrr::map(nm_child[-length(nm_child)], ~rlang::set_names("parent", .)),
    dplyr::left_join,
  )

  RGS_wt <- purrr::map_dfc(
    c("parent", nm_child),
    ~dplyr::add_count(wide_RGS, !!rlang::sym(.x), name = paste0("weight", sub("[^0-9|_]*", "", .x))) %>%
      dplyr::select(last_col())
    ) %>%
    dplyr::mutate(dplyr::across(.fns = ~.x / weight)) %>%
    dplyr::select(-weight)

  long_weight <- tidyr::pivot_longer(RGS_wt, everything(), names_to = c(".value", "level"), names_sep = "_")
  long_child <- tidyr::pivot_longer(dplyr::select(wide_RGS, -parent), everything(), names_to = c(".value", "level"), names_sep = "_")
  weights <- dplyr::bind_cols(long_child, dplyr::select(long_weight, -level))

  # distinct
  weights <- dplyr::distinct(weights, .data$child, .keep_all = TRUE)
  dplyr::left_join(RGS, weights, by = "child")

}

rectify <- function(RGS) {

  dplyr::group_by(RGS, n = nchar(.data$parent)) %>%
    dplyr::group_split() %>%
    .[-1] %>%
    purrr::imap(rectify_)
}

rectify_ <- function(RGS, n = 1) {

  rect_data <- dplyr::group_by(RGS, parent) %>%
    dplyr::summarise(tot_weight = sum(.data$weight)) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(
      ymax = cumsum(tot_weight),
      ymin = dplyr::lag(ymax, n = 1, default = 0)
      )

  ggplot2::geom_rect(
    data = rect_data,
    mapping = ggplot2::aes(xmin = 1 + {{n}}, xmax = 2 + {{n}}, ymin = ymin, ymax = ymax, fill = parent),
    color = "white",
    show.legend = FALSE
    )
}

#ls_xc <- xc %>% purrr::imap(rectify)
pie_baker <- function(rects, lab = FALSE) {

  p <- ggplot2::ggplot() +
    rects +
    ggplot2::xlim(0, 2 + length(rects)) +
    ggplot2::theme_void() +
    ggplot2::coord_polar(theta = "y")

  if (isTRUE(lab)) {
    p + ggplot2::labs(title = "Referentie GrootboekSchema") }
  else {
    p
  }
}

weight_create <- function(RGS, parent, child) {

  # capture quo
  child <- enquo(child)
  #vectors
  vc_child <- dplyr::pull(RGS, !!child)
  vc_parent <- dplyr::pull(RGS, {{parent}})

  purrr::map_dbl(vc_parent, ~weight_(vc_child, .x))
}


weight_ <- function(vc_child, parent) {

  n_max <- unique(sapply(vc_child, nchar))
  n_min <- nchar({{parent}})

  reg_wght <- glue::glue("^((parent))([:alnum:]){((n_max - n_min))}$", .open = "((", .close = "))")
  weight <- stringr::str_detect(vc_child, reg_wght) %>% sum()

  tot <- length(vc_child[nchar(vc_child) == n_max])
  if (nchar(parent) > 0) weight / tot else 1
}


RGS_tree <- function(tb) {

  ls_tb <- dplyr::mutate(
    tb,
    dplyr::across(
      tidyselect::vars_select_helpers$where(is.character),
      ~dplyr::na_if(., "")
      )
    ) %>%
    tidyr::drop_na() %>%
    dplyr::group_by(n = nchar(parent)) %>%
    dplyr::group_split(.keep = FALSE)

  tb <- purrr::imap(ls_tb, widening) %>%
    purrr::reduce2(
      purrr::map(stringr::str_c("child_", 1:(length(ls_tb) - 1)), ~rlang::set_names("parent", .)),
      dplyr::left_join,
      )

  mt <- dplyr::select(tb, -c(parent, stringr::str_c("child_", 1:(length(ls_tb) - 1))))  %>%
    # dplyr::slice_sample(prop = 0.1) %>%
    tibble::column_to_rownames(paste0("child_", length(ls_tb))) %>%
    as.matrix()
  dd <- dist(mt, method = "binary")
  hc <- hclust(dd, method = "single")
  hc
  # plot(ape::as.phylo(hc), type = "fan")
}

widening <- function(codes, n) {
  tidyr::pivot_wider(
    codes,
    names_from = parent,
    values_from = parent,
    values_fn = function(x) as.integer(is.character(x)),
    values_fill = 0
    ) %>%
    dplyr::left_join(codes, ., by = "child") %>%
    dplyr::rename("child_{n}" := child)
}


parent_code <- function(code) {

  code <- purrr::map_chr(code, ~stringr::str_replace(.x, "\\s", NA_character_))
  nmax <- length(code)
  stringr::str_c(code[1:nmax - 1], collapse = "")
}

labeller <- function(RGS = dplyr::select(RGS, c(parent, starts_with("child_")))) {
  n_end <- ncol(RGS)
  terminal_node <- RGS[[n_end]]
}
