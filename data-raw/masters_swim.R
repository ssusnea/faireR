## code to prepare `masters_swim` dataset goes here

# data from here: https://osf.io/gcpwv

library(tidyverse)

masters_swim <- here::here("data-large/MMResults_2013-2020 New Zealand.csv") |>
  read_csv()


usethis::use_data(masters_swim, overwrite = TRUE)
