globalVariables(c("independence", "separation", "sufficiency"))

#' Plot fairness measures
#' @param data a [tibble::tibble] of output from [fairness_cube()]
#' @param ... currently ignored
#' @export
#' @examplesIf require(dplyr)
#' # Compute fairness measures for Ironman
#' d1 <- ironman |>
#'   group_by(gender) |>
#'   fairness_cube(truth = y, estimate = y_hat)
#'
#' # Compute fairness measures for baseball
#' d2 <- csas25 |>
#'   group_by(stand) |>
#'   fairness_cube()
#'
#' # Compute fairness measures for COMPAS
#' d3 <- compas_binary$data() |>
#'   mutate(is_high_risk = factor(ifelse(score_text == "High", 1, 0))) |>
#'   group_by(race) |>
#'   fairness_cube(truth = two_year_recid, estimate = is_high_risk)
#'
#' list(d1, d2, d3) |>
#'   bind_rows() |>
#'   plot_fairness()

plot_fairness <- function(data, ...) {
  p1 <- ggplot2::ggplot(data, ggplot2::aes(x = independence, y = separation)) +
    ggplot2::geom_point() +
    ggplot2::xlim(c(0, NA)) +
    ggplot2::ylim(c(0, NA))

  p2 <- p1 +
    ggplot2::aes(y = sufficiency)

  p3 <- p1 +
    ggplot2::aes(x = separation, y = sufficiency)

  list(p1, p2, p3) |>
    patchwork::wrap_plots(axes = "collect")
}
