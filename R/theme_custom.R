theme_custom <- function(base = ggplot2::theme_classic(), ...) {
  `%+replace%` <- ggplot2::`%+replace%`
  base %+replace%
    ggplot2::theme(
      plot.title =  ggplot2::element_text(size = 15, face = "bold",
                                          vjust = 0.2, hjust = 0),
      plot.subtitle =  ggplot2::element_text(size = 11, hjust = 0.5),
      axis.text.y =  ggplot2::element_text(size = 11),
      axis.text.x =  ggplot2::element_text(size = 11, angle = 45),
      axis.title.y =  ggplot2::element_text(size = 12),
      axis.title.x =  ggplot2::element_blank()
      )

}
