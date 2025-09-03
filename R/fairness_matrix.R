#' Compute fairness metrics using MLR3
#'
#' `metrics_mlr3()` calculates the independence,
#'  sufficiency, and separation scores for a given dataset using the `mlr3fairness`
#'  package
#'
#' @param data The data for which to calculate the metrics
#' @param truth A string. The observed outcome in the data
#' @param estimate A string. The predicted outcome in the data
#' @param class A string. The protected class, a character vector with at least two levels
#'
#' @returns A 1x3 matrix reporting the independence,
#'  sufficiency, and separation scores for the data
#'
#' @examplesIf require(dplyr)
#' # Compute metrics for Ironman data
#' score_matrix <- metrics_mlr3(data = ironman, truth = "y", estimate = "y_hat", class = "gender")
#' @export
metrics_mlr3 <- function(data, truth, estimate, class) {

  data <- data |>
    dplyr::select({{ class }}, {{ truth }}, {{ estimate }})

  yhat <- as.factor(data[[estimate]])

  data_dt <- data.table::setDT(data)

  independence = mlr3::msr("fairness.cv")
  separation = mlr3::msr("fairness.eod")
  sufficiency = mlr3::msr("fairness.pp")

  our_metrics <- c(independence, separation, sufficiency)

  scores = mlr3fairness::compute_metrics(
    data = data_dt,
    target = truth,
    prediction = yhat,
    protected_attribute = class,
    metrics = our_metrics
  )

  fairness_matrix <- matrix(data = scores, ncol = 3)

  return(fairness_matrix)

}

