## code to prepare `masters-swimming` dataset goes here

nz_swim <- here::here("data-large/MMResults_2013-2020 New Zealand.csv") |>
  read_csv()

usethis::use_data(masters-swimming, overwrite = TRUE)
