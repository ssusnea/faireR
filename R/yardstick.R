#' Compute fairness metrics using yardstick
#' @export
#' @examplesIf require(dplyr)
#' # Compute separation measure for Ironman
#' ironman |>
#'   group_by(gender) |>
#'   fairness_independence(truth = y, estimate = y_hat)

fairness_cv <- function(data, truth, estimate) {
  msr <- yardstick::metric_set(yardstick::detection_prevalence)

  data |>
    msr(obs, truth = {{ truth }}, estimate = {{ estimate }}) |>
    dplyr::summarize(
      calder_weavers = abs(diff(.estimate))
    )
}

#' @export
#' @rdname fairness_cv
fairness_independence <- fairness_cv

#' @export
#' @rdname fairness_cv
#' @examplesIf require(dplyr)
#' ironman |>
#'   group_by(gender) |>
#'   fairness_separation(truth = y, estimate = y_hat)

fairness_eod <- function(data, truth, estimate) {
  msr <- yardstick::metric_set(yardstick::sens, yardstick::spec)

  data |>
    msr(obs, truth = {{ truth }}, estimate = {{ estimate }}) |>
    dplyr::mutate(
      .estimate = ifelse(.metric == "spec", 1 - .estimate, .estimate)
    ) |>
    dplyr::summarize(
      equalized_odds = mean(abs(diff(.estimate)))
    )
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
fairness_predictive_parity <- function(data, truth, estimate) {
  msr <- yardstick::metric_set(yardstick::ppv, yardstick::npv)

  data |>
    msr(obs, truth = {{ truth }}, estimate = {{ estimate }}) |>
    dplyr::summarize(
      predictive_parity = mean(abs(diff(.estimate)))
    )
}

#' @export
#' @rdname fairness_cv
fairness_sufficiency <- fairness_predictive_parity
