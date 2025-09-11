## code to prepare `dipsea` dataset goes here

library(tidyverse)
library(ggplot2)

# start with 2021, the most recent year they used in their analysis
dipsea2021 <- read.csv(here::here("data-raw/dipsea2021_data.csv")) |>
  select(!c(City, Time.to.Cardiac)) |>
  filter(Race == "Invitational")

# top fifth percentile has to be referring to the 95 percentile right? otherwise how does that make any sense
# implement top 5th percentile method for predicting new handicaps
# so is it of those top 5th percentile people?? what?

## thought about it some more:
### find 95th percentile for each grouping of gender and age
### take the difference of that threshold relative to the baseline group (SCRATCH)
### smooth the differences by fitting a simple polynomial model?
### fit model to data and generate predictions? But isn't this overfit... idk.
### adjust the race times of each runner to find the new winner for each year (starting simple with one year though)

ref_group <- hms("1:25:00")

dipsea <- dipsea2021 |>
  group_by(Group, Sex) |>
  mutate(fifth_percentile = hms(quantile(Clock.Time, 0.95, type = 1)),
         scr_time = ref_group,
         difference = fifth_percentile - ref_group)

ggplot(data = dipsea, aes(x = Age, y = Head.Start)) +
  geom_point() +
  geom_line(aes(x = Age, y = difference)) +
  geom_smooth(method = "lm", formula = y ~ poly(x, 2)) +
  facet_wrap(~Sex)




percentiles <- dipsea2021 |>
  group_by(Group, Sex) |>
  # they use Head.Start to represent differences between times it seems like
  summarize(fifth = quantile(Head.Start, 0.95, type = 1)) |>
  # will fix this hard coding later
  mutate(ref_group = hms("2:6:31"),
         difference = fifth - ref_group)

percentiles_method$fifth <- hms(percentiles_method$fifth)

# method they describe for using median times:
## compare differences between median group times to median scratch time,
## then smooth the differences using polynomial regression? so we have the differences in times, we just need to smooth them out now?
## and smoothing will give us those new handicaps

# fitting model for smoothing:

smooth_model <- lm(Head.Start ~ poly(Age, degree = 2), data = dipsea2021)




usethis::use_data(dipsea2021, overwrite = TRUE)
