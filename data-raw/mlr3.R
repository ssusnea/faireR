library(mlr3fairness)
library(mlr3)
compas_binary <- tsk("compas_race_binary")

compas_binary <- compas_binary$data() |>
  tibble::as_tibble()

usethis::use_data(compas_binary, overwrite = TRUE)

