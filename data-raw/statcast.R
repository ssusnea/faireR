library(tidyverse)

pitches <- read_csv(here::here("data-large/statcast_pitch_swing_data_20240402_20240630.csv"))

csas25 <- pitches |>
  select(type, sz_top, sz_bot, plate_z, plate_x, stand) |>
  filter(type != "X" & !is.na(sz_top)) |>
  mutate(
    y_hat = as.factor(ifelse(type == "S", 1, 0)),
    within_zbounds = plate_z <= sz_top & plate_z >= sz_bot,
    within_xbounds = abs(plate_x <= 8.5/12),
    y = as.factor(ifelse(within_zbounds & within_xbounds, 1, 0))
  ) |>
  select(-contains("within"))

usethis::use_data(csas25, overwrite = TRUE)
