# this function will take in some data, convert it into a confusion matrix,
# and then calculate the corresponding fairness scores.
# it will return the scores as a matrix as well

# this matrix can then be plotted in 2/3D
# depending on the number of dimensions

## write a version calling on MLR3 package(s)

## START HERE:

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
  ## using these three for now but I don't think they're all right

  independence = msr("fairness.cv")
  separation = msr("fairness.tpr")
  sufficiency = msr("fairness.ppv")

  # put them into a vector:

  our <- c(independence, separation, sufficiency)

  # use MLR3:

  scores = mlr3fairness::compute_metrics(
    data = data_dt,
    target = truth,
    prediction = yhat,
    protected_attribute = class,
    metrics = our
  )

  # not sure about this part yet...
  fairness_matrix <- as.matrix(scores, ncol = 3)

  return(fairness_matrix)

}


test <- metrics_mlr3(data = ironman, truth = "y", estimate = "y_hat", class = "Gender")

print(test)

# define a function building off of yardstick metrics

metrics_yardstick <- function(data, truth, estimate, class) {

  # create confusion matrices using yardstick syntax

  ## this is for multiple levels to the class
  conf_matrix <- data |>
    group_by({{ class }}) |>
    conf_mat(truth, estimate)|>
    mutate(tidied = lapply(conf_mat, broom::tidy))

  # summary_stats <- summary(conf_matrix)

  ## but let's first figure it out for just one, like a minimally minimally viable product:

  summary1 <- conf_matrix[[1,3]]

  summary_stats <- summary(summary1)

  ## return for testing:
  # return(conf_matrix)
  return(summary_stats)

  # stats <- summary(conf_matrix)
}

test2 <- metrics_yardstick(data = ironman, truth = "y", estimate = "y_hat", class = Gender)


## trying a minimally viable version, for only one level of protected class:
yardstick_minimal <- function(data, truth, estimate, class, filter) {

  # thinking:
  ## summary function will return metrics in the same order every time,
  ## so couldn't we hard code the subsetting?
  ## or I guess we could filter the data frame reporting the stats

  ### lets say we want sensitivity, specificity, and ppv, that's:
  ### rows 3, 4, and 5

  # create a confusion matrix for a single level in protected class
  conf_matrix <- data |>
    filter({{ class }} == {{ filter }}) |>
    conf_mat(truth, estimate)

  # compute summary statistics:
  summary_stats <- summary(conf_matrix)

  metrics <- summary_stats[3:5, ]

  return(metrics)
}

test3 <- yardstick_minimal(data = ironman, truth = "y", estimate = "y_hat", class = Gender, filter = "Female")
