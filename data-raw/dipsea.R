## code to prepare `dipsea` dataset goes here

library(tidyverse)

# start with 2021, the most recent year they used in their analysis
dipsea2021 <- read.csv(here::here("data-large/dipsea2021_data.csv")) |>
  select(!c(City, Time.to.Cardiac)) |>
  filter(Race == "Invitational")

dipsea2021$Clock.Time <- hms(dipsea2021$Clock.Time)

percentiles_method <- dipsea2021 |>
  # implement fifth percentile times handicap system ?
  group_by(Group, Sex) |>
  # going to assume they used clock time but idk
  summarize(fifth = quantile(Clock.Time, 0.05, type = 1)) |>
  # will fix this hard coding later
  mutate(ref_group = hms("2:6:31"),
         difference = fifth - ref_group)

percentiles_method$fifth <- hms(percentiles_method$fifth)

# method they describe for using median times:
## compare differences between median group times to median scratch time,
## then smooth the differences using polynomial regression? so we have the differences in times, we just need to smooth them out now?
## and smoothing will give us those new handicaps


usethis::use_data(dipsea, overwrite = TRUE)
