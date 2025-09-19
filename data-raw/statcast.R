library(tidyverse)

pitches <- read_csv(here::here("data-large/statcast_pitch_swing_data_20240402_20240630.csv"))

csas25 <- pitches |>
  select(type, sz_top, sz_bot, plate_z, plate_x, stand) |>
  filter(type != "X" & !is.na(sz_top)) |>
  mutate(
    is_called_strike = type == "S",
    within_zbounds = plate_z <= sz_top & plate_z >= sz_bot,
    within_xbounds = abs(plate_x <= 8.5/12),
    is_within_strike_zone = within_zbounds & within_xbounds
  ) |>
  select(-contains("bounds"))

usethis::use_data(csas25, overwrite = TRUE)
