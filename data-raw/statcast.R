library(tidyverse)

pitches <- read_csv(here::here("data-large/statcast_pitch_swing_data_20240402_20240630.csv"))

csas25 <- pitches |>
  select(type, sz_top, sz_bot, plate_z, plate_x, stand)

usethis::use_data(csas25)
