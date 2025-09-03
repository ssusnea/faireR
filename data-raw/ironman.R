## code to prepare `ironman` dataset goes here

library(tidyverse)

marathon <- here::here("data-large/ironman_texas_2024.csv") |>
  read_csv(skip = 35) |>
  slice_head(n = 2769)

# https://besttriathletes.com/ironman-texas-record/

params <- tibble::tibble(
  gender = c("Male", "Female"),
  world_record = c(hms("7:24:20"), hms("8:10:34")),
  max_rank = c(10, 7)
)

ironman <- marathon |>
  janitor::clean_names() |>
  select(gender, division, division_rank, overall_time, finish_status) |>
  filter(division %in% c("MPRO", "FPRO") & finish_status == "Finisher") |>
  left_join(params, by = join_by(gender)) |>
  mutate(
    y = ifelse(division_rank <= 10, 1, 0),
    quotient_model = hms(overall_time) / world_record,
    y_hat = ifelse(division_rank <= max_rank, 1, 0),
    y = as.factor(y),
    y_hat = as.factor(y_hat)
  )

usethis::use_data(ironman, overwrite = TRUE)
