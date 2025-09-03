library(tidyverse)

swimming1650 <- read_rds("https://github.com/elizabeth-upton/Age_and_Performance_SwimRun/raw/refs/heads/main/Age_and_Performance/swim_1650.RDS") |>
  janitor::clean_names()

usethis::use_data(swimming1650, overwrite = TRUE)

# ggplot(swimming1650, aes(y = time_sec, x = year, color = age)) +
#   geom_point() +
#   facet_wrap(vars(sex))
