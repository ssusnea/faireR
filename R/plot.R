globalVariables(c("independence", "separation", "sufficiency", ".pred_1", "n",
                  "num_obs", "pct_pos"))

#' Plot fairness measures
#' @param data a [data.frame] of output from [fairness_cube()]
#' @param ... currently ignored
#' @export
#' @examplesIf require(dplyr)
#' # Compute fairness measures for Ironman
#' d1 <- ironman |>
#'   mutate(
#'     y = factor(division_rank <= 10),
#'     y_hat = factor(dense_rank(quotient_model) <= 20)
#'   ) |>
#'   group_by(gender) |>
#'   fairness_cube(truth = y, estimate = y_hat)
#'
#' # Compute fairness measures for baseball
#' d2 <- csas25 |>
#'   mutate(
#'     y = factor(is_within_strike_zone),
#'     y_hat = factor(is_called_strike)
#'   ) |>
#'   group_by(stand) |>
#'   fairness_cube()
#'
#' # Compute fairness measures for COMPAS
#' d3 <- compas_binary |>
#'   mutate(is_high_risk = factor(ifelse(score_text == "High", 1, 0))) |>
#'   group_by(race) |>
#'   fairness_cube(truth = two_year_recid, estimate = is_high_risk)
#'
#' d <- list(d1, d2, d3) |>
#'   bind_rows()
#'
#' # Plot a series of 2D plots
#' d |>
#'   plot_fairness()
#'
#' # Plot a 3D plots
#' d |>
#'   plotly_fairness()

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

#' @rdname plot_fairness
#' @export

plotly_fairness <- function(data, ...) {
  data |>
    plotly::plot_ly(x = ~independence, y = ~separation, z = ~sufficiency, type = "scatter3d", mode = "markers") |>
    plotly::layout(
      title = "Fairness",
      scene = list(
        xaxis = list(title = "Independence"),
        yaxis = list(title = "Separation"),
        zaxis = list(title = "Sufficiency")
      )
    ) |>
    plotly::add_markers(x = 0, y = 0, z = 0)
}

#' Plot fairness metrics
#' @inheritParams yardstick::ppv
#' @export
#' @examplesIf require(dplyr)
#' # example code
#'
#' hof_grp <- hof2025 |>
#'   mutate(is_pitcher = tSO > 100) |>
#'   group_by(is_pitcher)
#'
#' hof_grp |>
#'   plot_independence()
#'
#' hof_grp |>
#'   plot_separation()

plot_independence <- function(data, truth = y, estimate = y_hat, ...) {
  protected_attribute <- data |>
    dplyr::group_vars() |>
    # currently only one group!!!
    utils::head(1)

  data |>
    yardstick::detection_prevalence(truth = {{ truth }}, estimate = {{ estimate }}) |>
    ggplot2::ggplot(
      ggplot2::aes(x = !!rlang::sym(protected_attribute), y = .estimate)
    ) +
    ggplot2::geom_col()
}

#' @export
#' @rdname plot_independence

plot_separation <- function(data, truth = y, ...) {
  data |>
    yardstick::roc_curve(truth = {{ truth }}, .pred_1) |>
    ggplot2::autoplot()
}


#' @export
#' @rdname plot_independence

plot_sufficiency <- function(data, truth = y, ...) {
  data |>
    dplyr::group_by(.pred_1) |>
    dplyr::summarize(
      num_obs = dplyr::n(),
      pct_pos = sum(y == 1) / num_obs
    ) |>
    ggplot2::ggplot(ggplot2::aes(x = .pred_1, y  = pct_pos)) +
    ggplot2::geom_line()
}
