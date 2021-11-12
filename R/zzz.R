#' @noRd
.onLoad <- function(libname, pkgname) {
  utils::data("code_refs")
  # shiny::addResourcePath("sbs", system.file("www", package = "shinyBS"))
}

