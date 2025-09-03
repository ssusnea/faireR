## write a version calling on MLR3 package(s), note that all three arguments
## (except for data) need to be called as characters, so in quotes

library(tidyverse)

metrics_mlr3 <- function(data, truth, estimate, class) {
  # arguments: data = data frame provided to calculate scores for
  # truth = observed data
  # estimate = predicted data
  # class = the categorical variable we are interested in investigating

  # select columns
  data <- data |>
    dplyr::select({{ class }}, {{ truth }}, {{ estimate }})

  # extract vector for predictions:
  yhat <- as.factor(data[[estimate]])

  # coerce subset data into data table
  data_dt <- data.table::setDT(data)

  # define our desired metrics & store in vector:
  independence = mlr3::msr("fairness.cv")
  separation = mlr3::msr("fairness.eod")
  sufficiency = mlr3::msr("fairness.pp")

  our_metrics <- c(independence, separation, sufficiency)

  # use MLR3:

  scores = mlr3fairness::compute_metrics(
    data = data_dt,
    target = truth,
    prediction = yhat,
    protected_attribute = class,
    metrics = our_metrics
  )

  # store as matrix
  fairness_matrix <- matrix(data = scores, ncol = 3)

  return(fairness_matrix)

}

