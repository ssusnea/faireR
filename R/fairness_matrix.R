## write a version calling on MLR3 package(s), note that all three arguments
## (except for data) need to be called as characters, so in quotes

library(tidyverse)

metrics_mlr3 <- function(data, truth, estimate, class) {
  # arguments: data = data frame provided to calculate scores for
  # truth = observed data
  # estimate = predicted data
  # class = the categorical variable we are interested in investigating

  # select necessary columns
  data <- data |>
    dplyr::select({{ class }}, {{ truth }}, {{ estimate }})

  # extract vector for predictions:
  yhat <- as.factor(data[[estimate]])

  # coerce subset data into data table
  data_dt <- as.data.table(data)

  # define our desired metrics:
  ## using these three for now but still unsure/need to check work

  independence = msr("fairness.cv")
  separation = msr("fairness.tpr")
  sufficiency = msr("fairness.ppv")

  # put them into a vector:

  our_metrics <- c(independence, separation, sufficiency)

  # use MLR3:

  scores = mlr3fairness::compute_metrics(
    data = data_dt,
    target = truth,
    prediction = yhat,
    protected_attribute = class,
    metrics = our_metrics
  )

  # remove names from this named number
  scores_unnamed <- unname(scores)

  print(scores_unnamed)
  print(typeof(scores_unnamed))
  print(class(scores_unnamed))


  # not sure about this part yet...
  fairness_matrix <- as.matrix(scores_unnamed, ncol = 3)

  return(fairness_matrix)

}

test <- metrics_mlr3(data = ironman, truth = "y", estimate = "y_hat", class = "Gender")

print(test)
