#' Compute fairness metrics
#' @export
#' @inheritParams mlr3fairness::compute_metrics
#' @details
#'
#' Computes our chosen fairness metrics.
#' @return a `double` of length 4
#' @seealso [mlr3fairness::compute_metrics()]
#' @examples
#' # Compute fairness for COMPAS data
#' compute_fairness(
#'   data = compas_binary,
#'   target = "two_year_recid",
#'   prediction = factor(ifelse(compas_binary$score_text == "High", 1, 0)),
#'   protected_attribute = "race"
#' )
#'
#' # Compute fairness for MLB pitch data
#' csas25$y <- factor(ifelse(csas25$is_within_strike_zone, 1, 0))
#' compute_fairness(
#'   data = csas25,
#'   target = "y",
#'   prediction = factor(ifelse(csas25$is_called_strike, 1, 0)),
#'   protected_attribute = "stand"
#' )
#'

compute_fairness <- function(data, target, prediction, protected_attribute) {
  requireNamespace("mlr3fairness", quietly = TRUE)

  # see page 61, independence in the binary case is demographic parity
  ind <- mlr3::msr("fairness.cv")
  # see page 82, separation is equivalent to equalized odds
  sep <- mlr3::msr("fairness.eod")
  suf <- mlr3::msr("fairness.pp")

  ours <- c(ind, sep, suf)

  mlr3fairness::compute_metrics(
    data = data,
    target = target,
    prediction = prediction,
    protected_attribute = protected_attribute,
    metrics = ours
  )
}

#' @rdname compute_fairness
#' @export
#' @inheritParams fairness_cube
#' @examplesIf require(dplyr)
#' # Use a tidy-interface
#' compas_binary |>
#'   mutate(y_hat = factor(ifelse(score_text == "High", 1, 0))) |>
#'   group_by(race) |>
#'   compute_fairness_tidy(truth = "two_year_recid", estimate = "y_hat")
#'
#' # Use a tidy-interface
#' csas25 |>
#'   mutate(
#'     y = factor(ifelse(is_within_strike_zone, 1, 0)),
#'     y_hat = factor(ifelse(is_called_strike, 1, 0)),
#'   ) |>
#'   group_by(stand) |>
#'   compute_fairness_tidy(
#'     truth = "y",
#'     estimate = "y_hat"
#'   )
#'
#' # Compute fairness for Texas Ironman
#'
#' ironman |>
#'   # remove columns with non-standard data types
#'   select(-overall_time, -world_record) |>
#'   mutate(
#'     y = factor(division_rank <= 10),
#'     y_hat = factor(dense_rank(quotient_model) <= 20)
#'   ) |>
#'   group_by(gender) |>
#'   compute_fairness_tidy(truth = "y", estimate = "y_hat")
#'
compute_fairness_tidy <- function(data, truth, estimate) {

  protected_attribute <- data |>
    dplyr::group_vars() |>
    # currently only one group!!!
    utils::head(1)

  data |>
    compute_fairness(
      target = {{ truth }},
      prediction = data[[estimate]],
      protected_attribute = protected_attribute
    )
}
