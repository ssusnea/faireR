#' Compute fairness metrics
#' @export
#' @inheritParams mlr3fairness::compute_metrics
#' @details
#'
#' Computes our chosen fairness metrics.
#' @return a `double` of length 4
#' @seealso [mlr3fairness::compute_metrics()]
#' @examples
#' compas <- compas_binary$data()
#' compute_fairness(
#'   data = compas,
#'   target = "two_year_recid",
#'   prediction = factor(ifelse(compas$score_text == "High", 1, 0)),
#'   protected_attribute = "race"
#' )

compute_fairness <- function(data, target, prediction, protected_attribute) {
  # see page 61, independence in the binary case is demographic parity
  ind <- mlr3::msr("fairness.cv")
  # see page 82, separation is equivalent to equalized odds
  sep <- mlr3::msr("fairness.eod")
  suf <- c(mlr3::msr("fairness.fpr"), mlr3::msr("fairness.tpr"))

  ours <- c(ind, sep, suf)

  mlr3fairness::compute_metrics(
    data = data,
    target = target,
    prediction = prediction,
    protected_attribute = protected_attribute,
    metrics = ours
  )
}

