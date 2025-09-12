## code to prepare `nz_swim` dataset goes here

# data from: https://osf.io/gcpwv

library(tidyverse)

nz_swim <- here::here("data-large/MMResults_2013-2020 New Zealand.csv") |>
  read_csv()


usethis::use_data(nz_swim, overwrite = TRUE)
