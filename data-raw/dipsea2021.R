## code to prepare `dipsea` dataset goes here

library(tidyverse)

dipsea2021 <- read.csv(here::here("data-raw/dipsea2021_data.csv")) |>
  select(!c(City, Time.to.Cardiac))

usethis::use_data(dipsea2021, overwrite = TRUE)
