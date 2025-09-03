library(mlr3fairness)
library(mlr3)
compas_binary <- tsk("compas_race_binary")

usethis::use_data(compas_binary, overwrite = TRUE)

