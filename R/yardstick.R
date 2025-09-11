globalVariables(
  c(".estimate", ".metric", "obs", "abs_diff", "coordinate", "y", "y_hat")
)

#' Compute fairness metrics using yardstick
#' @inheritParams yardstick::ppv
#' @export
#' @seealso [yardstick::metric_set()], [yardstick]
#' @examplesIf require(dplyr)
#' # Compute independence measure for Ironman
#' ironman |>
#'   group_by(gender) |>
#'   fairness_independence(truth = y, estimate = y_hat)
fairness_cv <- function(...) {
  fairness_cube(...)[["independence"]]
}

#' @export
#' @rdname fairness_cv
fairness_independence <- fairness_cv

#' @export
#' @rdname fairness_cv
#' @examplesIf require(dplyr)
#' # Compute separation measure for Ironman
#' ironman |>
#'   group_by(gender) |>
#'   fairness_separation(truth = y, estimate = y_hat)
fairness_eod <- function(...) {
  fairness_cube(...)[["separation"]]
}

#' @export
#' @rdname fairness_cv
fairness_separation <- fairness_eod

#' @export
#' @rdname fairness_cv
#' @examplesIf require(dplyr)
#' # Compute sufficiency measure for Ironman
#' ironman |>
#'   group_by(gender) |>
#'   fairness_sufficiency(truth = y, estimate = y_hat)
fairness_predictive_parity <- function(...) {
  fairness_cube(...)[["sufficiency"]]
}

#' @export
#' @rdname fairness_cv
fairness_sufficiency <- fairness_predictive_parity

#' @export
#' @rdname fairness_cv
#' @examplesIf require(dplyr)
#' # Compute fairness measures for Ironman
#' ironman |>
#'   group_by(gender) |>
#'   fairness_cube(truth = y, estimate = y_hat)

fairness_cube <- function(data, truth = y, estimate = y_hat) {
  blah <- yardstick::metric_set(
    yardstick::detection_prevalence,
    yardstick::sens,
    yardstick::spec,
    yardstick::ppv,
    yardstick::npv
  )

  data |>
    blah(truth = {{ truth }}, estimate = {{ estimate }}) |>
    dplyr::mutate(
      .estimate = ifelse(.metric == "spec", 1 - .estimate, .estimate),
      coordinate = dplyr::case_when(
        grepl("prevalence", .metric) ~ "independence",
        grepl("sens|spec", .metric) ~ "separation",
        grepl("pv", .metric) ~ "sufficiency",
        .default = as.character("")
      )
    ) |>
    dplyr::group_by(coordinate, .metric) |>
    dplyr::summarize(
      abs_diff = abs(diff(.estimate))
    ) |>
    dplyr::group_by(coordinate) |>
    dplyr::summarize(
      mad = mean(abs_diff)
    ) |>
    tidyr::pivot_wider(names_from = "coordinate", values_from = "mad")
}
